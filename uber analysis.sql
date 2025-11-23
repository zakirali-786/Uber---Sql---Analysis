create database uber;
use uber;

select * from rides;
select * from drivers;
select * from passangers;

#  1.What are and how many unique pick up location are there in data set


select distinct pickup_location from rides;

# 2.What is the total number of rides in data set

select count(ride_id)as total_rides from rides;

# 3.Calculate the average right duration 

select round(avg(ride_distance),2)as avg_ride_dist from rides;

# 4.List the top five drivers based on their total earning 

select driver_name,sum(earnings)as total_earnings from drivers
group by driver_name order by total_earnings desc
limit 5;

# 5. Calculate the total number of rides for each payment method 

select payment_method, count(*)total_rides from rides
group by payment_method 
order by total_rides desc;

# 6. Retrive rides with a fair amount greater than 20 

select * from rides where fare_amount > 20;

# 7. Identify the most common pick up location 

select pickup_location, count(*)as total_rides from rides
group by pickup_location 
order by total_rides desc
limit 1;

# 8. Calculate the average fare amount 

select round(avg(fare_amount),2)as avg_fare_amount from rides;

# 9. List the top 10 drivers with the highest average ratings 

select driver_name, avg(rating)as avg_ratings from drivers
group by driver_name 
order by avg_ratings desc
limit 10;

# 10. Calculate the total earnings for all drivers 

select round(sum(earnings),2)as total_earnings from drivers;

# 11. How many rides were paid using the cash payment method 

select count(*)as total_rides_for_cash from rides
where payment_method = 'cash';

# 12. Calculate the number of rides and average ride distance for rides originating from the Dhanbad 

select count(*)as number_of_rides , round(avg(ride_distance),2)as avg_ride_dist from rides
where pickup_location = 'Dhanbad'

# 13. Retrieve rides with a ride duration less than 10 minutes 

select * from rides where ride_duration < 10;

# 14. List the passengers who have taken the most number of rides 

select p.passenger_name as passenger_name,
count(r.ride_id)as number_of_rides
from passangers p join rides r
on p.passenger_id = r.passenger_id
group by passenger_name 
order by number_of_rides desc
limit 1;

# 15. Calculate the total number of rides for each driver in descending order 

select d.driver_name as driver_name,
count(r.ride_id)as number_of_rides
from rides r join drivers d
on r.driver_id = d.driver_id
group by driver_name
order by number_of_rides desc;


# 16. Identify the payment methods used by passengers who took rides from the Gandhinagar 

select distinct payment_method from rides where pickup_location = 'Gandhinagar';

# 17. Calculate the average fair amount for ride with a ride distance greater than 10 

select round(avg(fare_amount),2)as avg_fare_amount from rides
where ride_distance > 10;

# 18. List the driver in descending order according to the total number of rides

select driver_name,sum(total_rides) from drivers
group by driver_name 
order by sum(total_rides) desc;

# 19. Calculate the percentage distribution of rides for each pick up location

select
pickup_location,
count(*)as total_rides,
round(count(*) * 100/(select count(*) from rides),2) as percentage_distribution
from rides
group by pickup_location 
order by percentage_distribution desc;

# 20. Retrieve rides were both pickup and drop of locations are the same 

select * from rides
where pickup_location = dropoff_location;

# 21. List the passengers who have taken rides from at least 300 different pick up locations 

select p.passenger_name as passengers,
p.passenger_id as passenger_id,
count(distinct pickup_location)as distinct_location
from passangers p inner join rides r
on p.passenger_id = r.passenger_id
group by p.passenger_name, p.passenger_id
having distinct_location >= 300;

select * from rides;

# 22. Calculate the average fare amount for rides taken on weekdays 


select round(avg(fare_amount),2)as avg_fare_amount
from rides
where DAYOFWEEK(ride_timestamp) > 5;

# 23. Identify the drivers who have taken rides with distance greater than 19 

select d.driver_name as driver_name,
r.ride_distance as ride_distance
from rides r inner join drivers d
on r.driver_id = d.driver_id
where r.ride_distance > 19;

# 24. Calculate the total earnings for drivers who have completed more than 100 rides

select driver_name,sum(earnings)as total_earnings from drivers
where total_rides > 100
group by driver_name 
order by total_earnings ;

# 25. Retrieve rides where the fare amount is less than the average fair amount


select
	*
from
	rides
where
	fare_amount
< (
	select
		avg(fare_amount)
	from
		rides);


#26. Calculate the average rating of drivers who have driven rides with both 'Credit Card' and 'Cash' payment methods.

SELECT 
    AVG(d.rating) AS avg_rating
FROM 
    drivers d
WHERE 
    d.driver_id IN (
        SELECT 
            driver_id
        FROM 
            rides
        WHERE 
            payment_method IN ('Cash', 'Credit Card')
        GROUP BY 
            driver_id
        HAVING 
            COUNT(DISTINCT payment_method) = 2
    );


#27. List the top 3 passengers with the highest total spending.
select * from passangers order by total_spent desc limit 3;


#28. Calculate the average fare amount for rides taken during different months of the year.
select month(ride_timestamp) Months ,
       monthname(ride_timestamp) Month_Name,
       round(avg(fare_amount),2) AVG_Fareamount 
from rides
group by month(ride_timestamp), monthname(ride_timestamp)
order by month(ride_timestamp);


#29. Identify the most common pair of pickup and dropoff locations.
select pickup_location,
       dropoff_location,
       count(*) as Total_Trips
from rides
group by pickup_location, dropoff_location
order by Total_Trips desc; 


#30. Calculate the total earnings for each driver and order them by earnings in descending order.
select driver_name, sum(earnings) from drivers
group by driver_name
order by sum(earnings) desc;

#31. List the passengers who have taken rides on their signup date.
#hint -> We need to find passanger, whoes signup-date = the date of any ride they took.
select * from passangers;
select * from rides;

select p.passenger_id,
       p.passenger_name,
       p.signup_date,
       r.ride_timestamp
from rides r inner join passangers p
on r.passenger_id = p.passenger_id
where date(p.signup_date) = date(r.ride_timestamp); 


#32. Calculate the average earnings for each driver and order them by earnings in descending order.
select driver_name, avg(earnings) from drivers
group by driver_name
order by avg(earnings) desc;


#33. Retrieve rides with distances less than the average ride distance.
select * from rides;
select * from rides where ride_distance < (
    select avg(ride_distance) from rides
);


#34. List the drivers who have completed the least number of rides.
select driver_id,
       driver_name,
       total_rides
from drivers where total_rides = (
    select min(total_rides) from drivers
);


#35. Calculate the average fare amount for rides taken by passengers who have taken at least 20 rides.
select * from rides;
select * from passangers;
select p.passenger_id,
       p.passenger_name, 
       avg(r.fare_amount),
       p.total_rides 
from passangers p inner join rides r
on p.passenger_id = r.passenger_id
where p.total_rides >= 20
group by p.passenger_id ,p.passenger_name, p.total_rides ;


#36. Identify the pickup location with the highest average fare amount.
select * from rides;
select pickup_location, avg(fare_amount) from rides
group by pickup_location
order by avg(fare_amount) desc
limit 1; 

#37. Calculate the average rating of drivers who completed at least 100 rides.
select driver_id, driver_name, avg(rating)
from drivers where total_rides >=100
group by driver_id,driver_name;

select driver_id, avg(rating)
from drivers 
where driver_id in (
    select driver_id from rides
    group by driver_id
    having count(*) >= 100   
)
group by driver_id;

#38. List the passengers who have taken rides from at least 5 different pickup locations.
select * from rides;
select * from passangers;

select p.passenger_id PassengerID,
       p.passenger_name Passenger_Name,
       count( distinct r.pickup_location) Unique_Pickups
from rides r inner join passangers p
on r.passenger_id = p.passenger_id 
group by p.passenger_id, p.passenger_name  
having count(distinct r.pickup_location) >=5;

#39. Calculate the average fare amount for rides taken by passengers with ratings above 4.
select * from rides;
select * from passangers;

select p.passenger_id,
       p.passenger_name, 
       p.rating,
       round(avg(r.fare_amount), 2) AVG_FareAmount
from passangers p inner join rides r 
on p.passenger_id = r.passenger_id
where p.rating > 4
group by p.passenger_id, p.passenger_name, p.rating; 


#40. Retrieve rides with the shortest ride duration in each pickup location.
#hint-> for every pickup location, find the minimum ride_duration.
select * from rides;
select pickup_location , min(ride_duration) from rides
group by pickup_location
order by min(ride_duration) asc;


