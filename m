Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA3E4F3939;
	Thu, 17 Sep 2026 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659802; cv=none; b=Xch+qIvgV4ubDrWxXaqaCgNa/5BCN87HapVaXlgh5bRzeGcDUlzq6nyPdGb9du4hnOC+JqxFVqHmLJ65NqX1zm8r8ESD4buEXMV4MAwzs9GNe7rN1P55XF3VWM9xoyvOUL7ys4AhrE7pofnq2gmM0HRittgZaD78OFuhXqRgjz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659802; c=relaxed/simple;
	bh=bzrPX9odXoFjHokL6CW14bSv61UC+qB51hwoi9wF8Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I69Pk8aCEdxRzppqb0JGMrrl56in6mFBK9jysysmtLwGB07Tm/0PRfaACcKzJhPBilRq/WyMogYYlvrIgrY66dl8N/zD41DgnTLYiJXdB4no2CXCz6ScC5vLefYdA4PQAIumzh9NLFCAkssjKgaeX20Qu6N9AIVNic1t8AwcTkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLRtg7Ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLRtg7Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8659C1F0089A;
	Thu, 17 Sep 2026 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659791;
	bh=yyjKq1qL3ish2rnl8phPBwxVLm5c72/o/17YF6hSSJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLRtg7Qlr1xqfPGpxPN5geUy1WKGNf5YlC5pA+UL+NrSTaS1PPExa1zrS6VIEMld9
	 6TiWfA6949Vqsf+bStdk58XeS7/HQBiwDnGN/Cs0/BeHxlpyeshjJ0vioJ8bbtirkY
	 LMqzGoxR6tZghTSVZItasDwqNUKcXDSbAPTAzE8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 327/733] hwmon: (ina2xx) Replace masks with enum in alert functions
Date: Thu, 17 Sep 2026 16:10:35 +0100
Message-ID: <20260917151359.658160517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6175fab8728e0..dec4e72be2f92 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -128,6 +128,17 @@ enum ina2xx_ids {
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
@@ -413,16 +424,43 @@ static u16 ina226_alert_to_reg(struct ina2xx_data *data, int reg, long val)
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
@@ -434,9 +472,11 @@ static int ina226_alert_limit_read(struct ina2xx_data *data, u32 mask, int reg,
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
@@ -457,9 +497,11 @@ static int ina226_alert_limit_write(struct ina2xx_data *data, u32 mask, int reg,
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
 
@@ -483,15 +525,17 @@ static int ina2xx_chip_read(struct device *dev, u32 attr, long *val)
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
@@ -500,10 +544,10 @@ static int ina226_alert_read(struct ina2xx_data *data, u32 mask, long *val)
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
@@ -517,15 +561,15 @@ static int ina2xx_in_read(struct device *dev, u32 attr, int channel, long *val)
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
@@ -579,10 +623,10 @@ static int ina2xx_power_read(struct device *dev, u32 attr, long *val)
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
@@ -618,15 +662,15 @@ static int ina2xx_curr_read(struct device *dev, u32 attr, long *val)
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
@@ -670,12 +714,12 @@ static int ina2xx_in_write(struct device *dev, u32 attr, int channel, long val)
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
@@ -690,7 +734,7 @@ static int ina2xx_power_write(struct device *dev, u32 attr, long val)
 
 	switch (attr) {
 	case hwmon_power_crit:
-		return ina226_alert_limit_write(data, INA226_POWER_OVER_LIMIT_MASK,
+		return ina226_alert_limit_write(data, INA2XX_ALERT_POWER_HIGH,
 						INA2XX_POWER, val);
 	default:
 		return -EOPNOTSUPP;
@@ -704,10 +748,10 @@ static int ina2xx_curr_write(struct device *dev, u32 attr, long val)
 
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



