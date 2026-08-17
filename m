Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E201D3B811F;
	Mon, 17 Aug 2026 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975998; cv=none; b=AxU+4bdc4JjxR5hruOLxgE8FlP6BugMmDz+GVZhK4zJbucfMEBcZrHaB/a32NR/1Wz5cDluqhVasC17HPR+EZGOwK5jqLHu4zO7XqS7tcyH/9nOH+utCuRlveCT8YH4iCjoqgzmqIVOm2aGCjDKztH1FUqqvHAvW1kEDgT0MD70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975998; c=relaxed/simple;
	bh=ZyF7UC8nYMvTy5g2ydxc973MoA8/yhugsQXqquToDdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTq0Mih84BhyTR1CydK9j7FhuKYd0dMQAKGrOGieubmUWRLYXGrSdfIAPiQf35NtnxcAOL0mT3LaqUb0Raezp9YjYWfgB+OCLwwROmI5F+oAOFT8YYg2CVjoAJYunDjTM6sQqxCNHAGDDyFh4yCfWXqfCTKUyukhbM78YddxajA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDP1f001; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDP1f001"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D1D1F000E9;
	Mon, 17 Aug 2026 14:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975996;
	bh=iA4UDfX11Of+FdHqaxk03wWbv9av6rmHBUu8KaYUTNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDP1f001FEt5N2C5HYEZONxaSriZhvSOAQ1+VaUtL4rAh5075iOgwUy4Kl7SonCNm
	 sdli8NYn5gRVVJ3QsS03CeAe+cZaPBAmVeGxDZunCCnYzztWKTki+/wV7QfbXrosFO
	 hh+8JDD5dwTnrUdaLx3Kg4wDxiOv3PAC1L0DDDBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/389] hwmon: (adt7470) Create functions for updating readings and limits
Date: Mon, 17 Aug 2026 15:31:00 +0200
Message-ID: <20260817132547.831331163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit ad00a02e34b481396938c5fa62ee642bff7fbb08 ]

Split the body of adt7470_update_device() into two helper functions
adt7470_update_sensors() and adt7470_update_limits(). Although neither
of the new helpers returns an error yet lay the groundwork for
propagating failures through to the sysfs readers.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20201019223423.31488-2-chris.packham@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 92413f439d1e ("hwmon: (adt7470) Fix PWM auto temp state array and bounds check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 154 ++++++++++++++++++++++++++++++----------
 1 file changed, 118 insertions(+), 36 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 23a447c1f0cf0..b8697975d8b6c 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -270,37 +270,11 @@ static int adt7470_update_thread(void *p)
 	return 0;
 }
 
-static struct adt7470_data *adt7470_update_device(struct device *dev)
+static int adt7470_update_sensors(struct adt7470_data *data)
 {
-	struct adt7470_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
-	unsigned long local_jiffies = jiffies;
 	u8 cfg;
 	int i;
-	int need_sensors = 1;
-	int need_limits = 1;
-
-	/*
-	 * Figure out if we need to update the shadow registers.
-	 * Lockless means that we may occasionally report out of
-	 * date data.
-	 */
-	if (time_before(local_jiffies, data->sensors_last_updated +
-			SENSOR_REFRESH_INTERVAL) &&
-	    data->sensors_valid)
-		need_sensors = 0;
-
-	if (time_before(local_jiffies, data->limits_last_updated +
-			LIMIT_REFRESH_INTERVAL) &&
-	    data->limits_valid)
-		need_limits = 0;
-
-	if (!need_sensors && !need_limits)
-		return data;
-
-	mutex_lock(&data->lock);
-	if (!need_sensors)
-		goto no_sensor_update;
 
 	if (!data->temperatures_probed)
 		adt7470_read_temperatures(client, data);
@@ -352,12 +326,13 @@ static struct adt7470_data *adt7470_update_device(struct device *dev)
 	data->alarms_mask = adt7470_read_word_data(client,
 						   ADT7470_REG_ALARM1_MASK);
 
-	data->sensors_last_updated = local_jiffies;
-	data->sensors_valid = 1;
+	return 0;
+}
 
-no_sensor_update:
-	if (!need_limits)
-		goto out;
+static int adt7470_update_limits(struct adt7470_data *data)
+{
+	struct i2c_client *client = data->client;
+	int i;
 
 	for (i = 0; i < ADT7470_TEMP_COUNT; i++) {
 		data->temp_min[i] = i2c_smbus_read_byte_data(client,
@@ -382,12 +357,55 @@ static struct adt7470_data *adt7470_update_device(struct device *dev)
 						ADT7470_REG_PWM_TMIN(i));
 	}
 
-	data->limits_last_updated = local_jiffies;
-	data->limits_valid = 1;
+	return 0;
+}
 
+static struct adt7470_data *adt7470_update_device(struct device *dev)
+{
+	struct adt7470_data *data = dev_get_drvdata(dev);
+	unsigned long local_jiffies = jiffies;
+	int need_sensors = 1;
+	int need_limits = 1;
+	int err;
+
+	/*
+	 * Figure out if we need to update the shadow registers.
+	 * Lockless means that we may occasionally report out of
+	 * date data.
+	 */
+	if (time_before(local_jiffies, data->sensors_last_updated +
+			SENSOR_REFRESH_INTERVAL) &&
+	    data->sensors_valid)
+		need_sensors = 0;
+
+	if (time_before(local_jiffies, data->limits_last_updated +
+			LIMIT_REFRESH_INTERVAL) &&
+	    data->limits_valid)
+		need_limits = 0;
+
+	if (!need_sensors && !need_limits)
+		return data;
+
+	mutex_lock(&data->lock);
+	if (need_sensors) {
+		err = adt7470_update_sensors(data);
+		if (err < 0)
+			goto out;
+		data->sensors_last_updated = local_jiffies;
+		data->sensors_valid = 1;
+	}
+
+	if (need_limits) {
+		err = adt7470_update_limits(data);
+		if (err < 0)
+			goto out;
+		data->limits_last_updated = local_jiffies;
+		data->limits_valid = 1;
+	}
 out:
 	mutex_unlock(&data->lock);
-	return data;
+
+	return err < 0 ? ERR_PTR(err) : data;
 }
 
 static ssize_t auto_update_interval_show(struct device *dev,
@@ -395,6 +413,10 @@ static ssize_t auto_update_interval_show(struct device *dev,
 					 char *buf)
 {
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", data->auto_update_interval);
 }
 
@@ -422,6 +444,10 @@ static ssize_t num_temp_sensors_show(struct device *dev,
 				     char *buf)
 {
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", data->num_temp_sensors);
 }
 
@@ -451,6 +477,10 @@ static ssize_t temp_min_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", 1000 * data->temp_min[attr->index]);
 }
 
@@ -483,6 +513,10 @@ static ssize_t temp_max_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", 1000 * data->temp_max[attr->index]);
 }
 
@@ -515,6 +549,10 @@ static ssize_t temp_show(struct device *dev, struct device_attribute *devattr,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", 1000 * data->temp[attr->index]);
 }
 
@@ -524,6 +562,9 @@ static ssize_t alarm_mask_show(struct device *dev,
 {
 	struct adt7470_data *data = adt7470_update_device(dev);
 
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%x\n", data->alarms_mask);
 }
 
@@ -554,6 +595,9 @@ static ssize_t fan_max_show(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
 
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	if (FAN_DATA_VALID(data->fan_max[attr->index]))
 		return sprintf(buf, "%d\n",
 			       FAN_PERIOD_TO_RPM(data->fan_max[attr->index]));
@@ -590,6 +634,9 @@ static ssize_t fan_min_show(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
 
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	if (FAN_DATA_VALID(data->fan_min[attr->index]))
 		return sprintf(buf, "%d\n",
 			       FAN_PERIOD_TO_RPM(data->fan_min[attr->index]));
@@ -626,6 +673,9 @@ static ssize_t fan_show(struct device *dev, struct device_attribute *devattr,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
 
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	if (FAN_DATA_VALID(data->fan[attr->index]))
 		return sprintf(buf, "%d\n",
 			       FAN_PERIOD_TO_RPM(data->fan[attr->index]));
@@ -637,6 +687,10 @@ static ssize_t force_pwm_max_show(struct device *dev,
 				  struct device_attribute *devattr, char *buf)
 {
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", data->force_pwm_max);
 }
 
@@ -670,6 +724,10 @@ static ssize_t pwm_show(struct device *dev, struct device_attribute *devattr,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", data->pwm[attr->index]);
 }
 
@@ -763,6 +821,10 @@ static ssize_t pwm_max_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", data->pwm_max[attr->index]);
 }
 
@@ -794,6 +856,10 @@ static ssize_t pwm_min_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", data->pwm_min[attr->index]);
 }
 
@@ -825,6 +891,10 @@ static ssize_t pwm_tmax_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	/* the datasheet says that tmax = tmin + 20C */
 	return sprintf(buf, "%d\n", 1000 * (20 + data->pwm_tmin[attr->index]));
 }
@@ -834,6 +904,10 @@ static ssize_t pwm_tmin_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", 1000 * data->pwm_tmin[attr->index]);
 }
 
@@ -866,6 +940,10 @@ static ssize_t pwm_auto_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	return sprintf(buf, "%d\n", 1 + data->pwm_automatic[attr->index]);
 }
 
@@ -911,8 +989,12 @@ static ssize_t pwm_auto_temp_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
-	u8 ctrl = data->pwm_auto_temp[attr->index];
+	u8 ctrl;
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
+	ctrl = data->pwm_auto_temp[attr->index];
 	if (ctrl)
 		return sprintf(buf, "%d\n", 1 << (ctrl - 1));
 	else
-- 
2.53.0



