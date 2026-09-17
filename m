Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAF04D37D5;
	Thu, 17 Sep 2026 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665852; cv=none; b=YjmrEvWfsDZv+xZkDBGOaKHYGjMc4T35KakoZ0qda+CDtKERG2RGxbBpjxxMtparSvVIVIXk/u3/uYiXgZ6u+OtKy6wsW6xFjgTl/6mp6yp+QNpwi4/Hgu6EKbGBi8BQWyskZw912f8FqGd70SMe4upRGEtb7o8a5MEkcF4k5NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665852; c=relaxed/simple;
	bh=ZgUSZ2k2BakH+Ko8Vh6Wlujvju96fRb0V5IpYehXfnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWbCNmQiXHVmkSScDTGuC/ZJ2YkLsQOb+/4SY4TkLZfmq5PxOIXVx9LChIGSzSAWBHAfXL71a/AABI5/qFUUWaIfY47wvLevJ68H5Xblx9GPBDinxWkzimoG7huwVqVUPLZKzkgVZsuTkM9rT1ilfJXkfncONH6v45ukO7jV52Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjO+2DSa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjO+2DSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298A01F000FF;
	Thu, 17 Sep 2026 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665850;
	bh=FXzDszxOHrdjSfm56wzbsH60j5E0o3Rkj+pn/6jyGs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjO+2DSamsuKCD7B1ycF7tWBxtyACjMaSlvx69qsGNathxBL9Pn1mXWLwC11fgsZu
	 7iXLQ/LdP6e72OnQF4OCTSRjUnzVyqCT1sG6x4r4LB/6sa+Z/f5jQc8HcbN9uSoMtU
	 5lOoXLYX/V50dnlycpU3OOZ6s13Fm7YQQTC5mL9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0841/1250] hwmon: (ina2xx) Replace masks with enum in alert functions
Date: Thu, 17 Sep 2026 16:10:36 +0100
Message-ID: <20260917151614.749144930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit e92b9208415a90e9cc1d923c5d8c058dde77be68 ]

Instead of passing an explicit mask to alert/limit functions like
ina226_alert_read(), introduce an enum ina2xx_alert_type that can be
converted to a mask internally. This semantically separates current from
shunt voltage in helpers that use function masks, which previously saw
the same mask for the two functions.

Signed-off-by: Jared Kangas <jkangas@redhat.com>
Link: https://patch.msgid.link/20260820-upstream-ina2xx-in0-curr1-alarms-v2-3-fdce35abc41e@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 35760f5efd7b ("hwmon: (ina2xx) Decouple in0 and curr1 alarms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina2xx.c | 90 +++++++++++++++++++++++++++++++-----------
 1 file changed, 67 insertions(+), 23 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index ce4f79745a115..9a0b19225e7d1 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -144,6 +144,17 @@ enum ina2xx_ids {
 	sy24655
 };
 
+enum ina2xx_alert_type {
+	INA2XX_ALERT_NONE,
+	INA2XX_ALERT_CURRENT_LOW,
+	INA2XX_ALERT_CURRENT_HIGH,
+	INA2XX_ALERT_POWER_HIGH,
+	INA2XX_ALERT_BUS_VOLTAGE_LOW,
+	INA2XX_ALERT_BUS_VOLTAGE_HIGH,
+	INA2XX_ALERT_SHUNT_VOLTAGE_LOW,
+	INA2XX_ALERT_SHUNT_VOLTAGE_HIGH,
+};
+
 struct ina2xx_config {
 	u16 config_default;
 	bool has_alerts;	/* chip supports alerts and limits */
@@ -429,16 +440,43 @@ static u16 ina226_alert_to_reg(struct ina2xx_data *data, int reg, long val)
 	}
 }
 
-static int ina226_alert_limit_read(struct ina2xx_data *data, u32 mask, int reg, long *val)
+static u32 ina2xx_alert_type_to_mask(enum ina2xx_alert_type alert)
+{
+	switch (alert) {
+	case INA2XX_ALERT_CURRENT_LOW:
+	case INA2XX_ALERT_SHUNT_VOLTAGE_LOW:
+		return INA226_SHUNT_UNDER_VOLTAGE_MASK;
+	case INA2XX_ALERT_CURRENT_HIGH:
+	case INA2XX_ALERT_SHUNT_VOLTAGE_HIGH:
+		return INA226_SHUNT_OVER_VOLTAGE_MASK;
+	case INA2XX_ALERT_BUS_VOLTAGE_LOW:
+		return INA226_BUS_UNDER_VOLTAGE_MASK;
+	case INA2XX_ALERT_BUS_VOLTAGE_HIGH:
+		return INA226_BUS_OVER_VOLTAGE_MASK;
+	case INA2XX_ALERT_POWER_HIGH:
+		return INA226_POWER_OVER_LIMIT_MASK;
+	case INA2XX_ALERT_NONE:
+		return 0;
+	default:
+		/* programmer error */
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+static int ina226_alert_limit_read(struct ina2xx_data *data, enum ina2xx_alert_type alert,
+				   int reg, long *val)
 {
 	struct regmap *regmap = data->regmap;
 	int regval;
+	u32 mask;
 	int ret;
 
 	ret = regmap_read(regmap, INA226_MASK_ENABLE, &regval);
 	if (ret)
 		return ret;
 
+	mask = ina2xx_alert_type_to_mask(alert);
 	if (regval & mask) {
 		ret = regmap_read(regmap, INA226_ALERT_LIMIT, &regval);
 		if (ret)
@@ -450,9 +488,11 @@ static int ina226_alert_limit_read(struct ina2xx_data *data, u32 mask, int reg,
 	return 0;
 }
 
-static int ina226_alert_limit_write(struct ina2xx_data *data, u32 mask, int reg, long val)
+static int ina226_alert_limit_write(struct ina2xx_data *data, enum ina2xx_alert_type alert,
+				    int reg, long val)
 {
 	struct regmap *regmap = data->regmap;
+	u32 mask;
 	int ret;
 
 	if (val < 0)
@@ -473,9 +513,11 @@ static int ina226_alert_limit_write(struct ina2xx_data *data, u32 mask, int reg,
 	if (ret < 0)
 		return ret;
 
-	if (val)
+	if (val) {
+		mask = ina2xx_alert_type_to_mask(alert);
 		return regmap_update_bits(regmap, INA226_MASK_ENABLE,
 					  INA226_ALERT_CONFIG_MASK, mask);
+	}
 	return 0;
 }
 
@@ -499,15 +541,17 @@ static int ina2xx_chip_read(struct device *dev, u32 attr, long *val)
 	return 0;
 }
 
-static int ina226_alert_read(struct ina2xx_data *data, u32 mask, long *val)
+static int ina226_alert_read(struct ina2xx_data *data, enum ina2xx_alert_type alert, long *val)
 {
 	unsigned int regval;
+	u32 mask;
 	int ret;
 
 	ret = regmap_read_bypassed(data->regmap, INA226_MASK_ENABLE, &regval);
 	if (ret)
 		return ret;
 
+	mask = ina2xx_alert_type_to_mask(alert);
 	*val = (regval & mask) && (regval & INA226_ALERT_FUNCTION_FLAG);
 
 	return 0;
@@ -516,10 +560,10 @@ static int ina226_alert_read(struct ina2xx_data *data, u32 mask, long *val)
 static int ina2xx_in_read(struct device *dev, u32 attr, int channel, long *val)
 {
 	int voltage_reg = channel ? INA2XX_BUS_VOLTAGE : INA2XX_SHUNT_VOLTAGE;
-	u32 under_voltage_mask = channel ? INA226_BUS_UNDER_VOLTAGE_MASK
-					 : INA226_SHUNT_UNDER_VOLTAGE_MASK;
-	u32 over_voltage_mask = channel ? INA226_BUS_OVER_VOLTAGE_MASK
-					: INA226_SHUNT_OVER_VOLTAGE_MASK;
+	enum ina2xx_alert_type under_voltage_alert = channel ? INA2XX_ALERT_BUS_VOLTAGE_LOW
+							     : INA2XX_ALERT_SHUNT_VOLTAGE_LOW;
+	enum ina2xx_alert_type over_voltage_alert = channel ? INA2XX_ALERT_BUS_VOLTAGE_HIGH
+							    : INA2XX_ALERT_SHUNT_VOLTAGE_HIGH;
 	struct ina2xx_data *data = dev_get_drvdata(dev);
 	struct regmap *regmap = data->regmap;
 	unsigned int regval;
@@ -533,15 +577,15 @@ static int ina2xx_in_read(struct device *dev, u32 attr, int channel, long *val)
 		*val = ina2xx_get_value(data, voltage_reg, regval);
 		break;
 	case hwmon_in_lcrit:
-		return ina226_alert_limit_read(data, under_voltage_mask,
+		return ina226_alert_limit_read(data, under_voltage_alert,
 					       voltage_reg, val);
 	case hwmon_in_crit:
-		return ina226_alert_limit_read(data, over_voltage_mask,
+		return ina226_alert_limit_read(data, over_voltage_alert,
 					       voltage_reg, val);
 	case hwmon_in_lcrit_alarm:
-		return ina226_alert_read(data, under_voltage_mask, val);
+		return ina226_alert_read(data, under_voltage_alert, val);
 	case hwmon_in_crit_alarm:
-		return ina226_alert_read(data, over_voltage_mask, val);
+		return ina226_alert_read(data, over_voltage_alert, val);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -595,10 +639,10 @@ static int ina2xx_power_read(struct device *dev, u32 attr, long *val)
 	case hwmon_power_average:
 		return sy24655_average_power_read(data, SY24655_EIN, val);
 	case hwmon_power_crit:
-		return ina226_alert_limit_read(data, INA226_POWER_OVER_LIMIT_MASK,
+		return ina226_alert_limit_read(data, INA2XX_ALERT_POWER_HIGH,
 					       INA2XX_POWER, val);
 	case hwmon_power_crit_alarm:
-		return ina226_alert_read(data, INA226_POWER_OVER_LIMIT_MASK, val);
+		return ina226_alert_read(data, INA2XX_ALERT_POWER_HIGH, val);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -634,15 +678,15 @@ static int ina2xx_curr_read(struct device *dev, u32 attr, long *val)
 		*val = ina2xx_get_value(data, INA2XX_CURRENT, regval);
 		return 0;
 	case hwmon_curr_lcrit:
-		return ina226_alert_limit_read(data, INA226_SHUNT_UNDER_VOLTAGE_MASK,
+		return ina226_alert_limit_read(data, INA2XX_ALERT_CURRENT_LOW,
 					       INA2XX_CURRENT, val);
 	case hwmon_curr_crit:
-		return ina226_alert_limit_read(data, INA226_SHUNT_OVER_VOLTAGE_MASK,
+		return ina226_alert_limit_read(data, INA2XX_ALERT_CURRENT_HIGH,
 					       INA2XX_CURRENT, val);
 	case hwmon_curr_lcrit_alarm:
-		return ina226_alert_read(data, INA226_SHUNT_UNDER_VOLTAGE_MASK, val);
+		return ina226_alert_read(data, INA2XX_ALERT_CURRENT_LOW, val);
 	case hwmon_curr_crit_alarm:
-		return ina226_alert_read(data, INA226_SHUNT_OVER_VOLTAGE_MASK, val);
+		return ina226_alert_read(data, INA2XX_ALERT_CURRENT_HIGH, val);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -686,12 +730,12 @@ static int ina2xx_in_write(struct device *dev, u32 attr, int channel, long val)
 	switch (attr) {
 	case hwmon_in_lcrit:
 		return ina226_alert_limit_write(data,
-			channel ? INA226_BUS_UNDER_VOLTAGE_MASK : INA226_SHUNT_UNDER_VOLTAGE_MASK,
+			channel ? INA2XX_ALERT_BUS_VOLTAGE_LOW : INA2XX_ALERT_SHUNT_VOLTAGE_LOW,
 			channel ? INA2XX_BUS_VOLTAGE : INA2XX_SHUNT_VOLTAGE,
 			val);
 	case hwmon_in_crit:
 		return ina226_alert_limit_write(data,
-			channel ? INA226_BUS_OVER_VOLTAGE_MASK : INA226_SHUNT_OVER_VOLTAGE_MASK,
+			channel ? INA2XX_ALERT_BUS_VOLTAGE_HIGH : INA2XX_ALERT_SHUNT_VOLTAGE_HIGH,
 			channel ? INA2XX_BUS_VOLTAGE : INA2XX_SHUNT_VOLTAGE,
 			val);
 	default:
@@ -706,7 +750,7 @@ static int ina2xx_power_write(struct device *dev, u32 attr, long val)
 
 	switch (attr) {
 	case hwmon_power_crit:
-		return ina226_alert_limit_write(data, INA226_POWER_OVER_LIMIT_MASK,
+		return ina226_alert_limit_write(data, INA2XX_ALERT_POWER_HIGH,
 						INA2XX_POWER, val);
 	default:
 		return -EOPNOTSUPP;
@@ -720,10 +764,10 @@ static int ina2xx_curr_write(struct device *dev, u32 attr, long val)
 
 	switch (attr) {
 	case hwmon_curr_lcrit:
-		return ina226_alert_limit_write(data, INA226_SHUNT_UNDER_VOLTAGE_MASK,
+		return ina226_alert_limit_write(data, INA2XX_ALERT_CURRENT_LOW,
 						INA2XX_CURRENT, val);
 	case hwmon_curr_crit:
-		return ina226_alert_limit_write(data, INA226_SHUNT_OVER_VOLTAGE_MASK,
+		return ina226_alert_limit_write(data, INA2XX_ALERT_CURRENT_HIGH,
 						INA2XX_CURRENT, val);
 	default:
 		return -EOPNOTSUPP;
-- 
2.53.0



