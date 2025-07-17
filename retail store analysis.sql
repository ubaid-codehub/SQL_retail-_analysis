
drop table if exists retail

create table retail(
transactions_id int primary key,
sale_date date,	
sale_time time,	 
customer_id	int,
gender	varchar(10),
age	int,
category varchar(15),
quantity	int,
price_per_unit float,
cogs	float,
 total_sale float

)

select count(*) from retail 

--cleaning data

select count(*) FROM retail
where 
transactionS_id  IS NULL OR	
sale_date	IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender	IS NULL OR
age	IS NULL OR
category IS NULL OR
quantity IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL OR
total_sale IS NULL ;

--Removing raws who have not placed any order 
delete from retail 
where quantity is null

-- This will calculate the average of non-null ages and update nulls with it
WITH avg_age_cte AS (
    SELECT ROUND(AVG(age)) AS avg_age FROM retail WHERE age IS NOT NULL
)
UPDATE retail
SET age = avg_age_cte.avg_age
FROM avg_age_cte
WHERE age IS NULL;


        --exploration
--highest sale category
select category,sum(total_sale) as total_category_sales from retail
group by category

--total sale of retail store
select sum(total_sale) as total_sales from retail

--no.of customers we have
select count(distinct customer_id) from retail

--Total sales over time (yearly)
select 
extract (year from sale_date) as year,
sum(total_sale) as total_sales from retail
group by year;

--Total sales over time (monthly)
select 
extract (year from sale_date) as year,
extract (month from sale_date) as month,
sum(total_sale) as total_sales from retail
group by year,month
order by year,month;

--peak hours
select 
extract (hour from sale_time)as hours,
count(*) as transactions
from retail
group by hours
order by transactions desc


--best selling product of 2022 and 2023
SELECT 
    category,
    SUM(quantity) AS total_quantity_sold,
    SUM(total_sale) AS total_revenue
FROM 
    retail
WHERE 
     EXTRACT(YEAR FROM sale_date) = 2023
GROUP BY 
    category,EXTRACT(YEAR FROM sale_date)
ORDER BY 
    total_quantity_sold DESC
LIMIT 1;
--which gender buy more 
SELECT SUM(total_sale),gender from retail
GROUP BY gender

--average age
SELECT category,round(avg(age)) as avg_age from retail
GROUP BY category

--who bought more beauty products
SELECT gender,
    SUM(quantity) AS total_beauty_quantity
FROM 
    retail
WHERE category = 'Beauty'
GROUP BY gender

--who bought more clothing products
SELECT gender,
    SUM(quantity) AS total_clothing_quantity
FROM 
    retail
WHERE category = 'Clothing'
GROUP BY
gender

--who bought more electronics products
SELECT gender,
    SUM(quantity) AS total_electronics_quantity
FROM 
    retail
WHERE category = 'Electronics'
GROUP BY 
gender

--TOTAL PROFIT BY YEARS
SELECT EXTRACT(YEAR FROM sale_date) as year,
    ROUND(SUM(total_sale - cogs)) AS total_profit
FROM 
    retail
GROUP BY
   year;

--TOTAL REVENUE BY YEARS
SELECT EXTRACT(YEAR FROM sale_date) as year,
    ROUND(SUM(total_sale)) AS total_revenue
FROM 
    retail
GROUP BY
   year;   
