Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2769D38F236;
	Sat, 12 Sep 2026 19:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242775; cv=none; b=i5sBGqRFMhxE5kobipNrvpA1tW2U8r8cUsDaWAd6I1CvaATaPEFjQdH5A5O4JSG7ZNbvX+xpFu+Ho9L7pPwVnyThMvaXh1jvHFz8nXPKMmtbwAsh2K/w/nFb5S4wfE3Xn5tAN34tfz8Ia2Pxb1c7IbRo1So64/fY94epFtZqYVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242775; c=relaxed/simple;
	bh=ea5WKKXc/zdjrYM/K3vfBo5ef/RUvtowflawucc30Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwRjbLpl5K9oHkFdmn9wYvVMYLJIP/ESc8AY8g0sHSdNo305H6g5n5VuW07w4iTjjs0rKDi+ul+CKQBiaqeKf4Y9hzH67VTpAjf17hdwVO9Iw0FVIlAso5GF2qf/UWCA+5Fj+nfoVSGezKj/1m4gJj/HCx9lGq//Z6RmGZvgcRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orYn5DcG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orYn5DcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EC71F000FF;
	Sat, 12 Sep 2026 19:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242774;
	bh=iTrrddTLeqccsC1eIT9MmjueVelOu/BBgGdtp2MK3t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orYn5DcGU99o8pdJ1LsMHcKseOe8BIzKiTAO7q3V76RWk2fmOhNLaXpINl99tYvTM
	 vyID+X2T/R67VWpZHvX0nOzQMfLt8rduHRoYpjQjTjYvaocWGKqC2UWeLU30sdeuWy
	 sLfWzwmowWXIxR31jyRFObSdXAK6g5Lepx9hsXjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ikjoon Jang <ikjn@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 515/798] power: supply: sbs-battery: cache constant string properties
Date: Sat, 12 Sep 2026 09:02:23 +0200
Message-ID: <20260912065528.940333161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Ikjoon Jang <ikjn@chromium.org>

[ Upstream commit b49a81d0fd021a1f0c8660fa40ad9984d9d1f5b7 ]

Currently sbs-battery supports three string properties -
manufacturer, model_name, and chemistry. Buffers for those
properties are currently defined as global variables.

This patch moves those global variables into struct sbs_info
and cache/reuse them as they are all constant values.

Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 6027892925b8 ("power: supply: sbs-battery: Use a per-device serial number buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sbs-battery.c | 153 ++++++++++++++++++-----------
 1 file changed, 95 insertions(+), 58 deletions(-)

diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sbs-battery.c
index ee8816ce0b800..25332b5a5da79 100644
--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -188,6 +188,14 @@ static const enum power_supply_property sbs_properties[] = {
 /* Supports special manufacturer commands from TI BQ20Z65 and BQ20Z75 IC. */
 #define SBS_FLAGS_TI_BQ20ZX5		BIT(0)
 
+static const enum power_supply_property string_properties[] = {
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+};
+
+#define NR_STRING_BUFFERS	ARRAY_SIZE(string_properties)
+
 struct sbs_info {
 	struct i2c_client		*client;
 	struct power_supply		*power_supply;
@@ -201,11 +209,32 @@ struct sbs_info {
 	struct delayed_work		work;
 	struct mutex			mode_lock;
 	u32				flags;
+	int				technology;
+	char				strings[NR_STRING_BUFFERS][I2C_SMBUS_BLOCK_MAX + 1];
 };
 
-static char model_name[I2C_SMBUS_BLOCK_MAX + 1];
-static char manufacturer[I2C_SMBUS_BLOCK_MAX + 1];
-static char chemistry[I2C_SMBUS_BLOCK_MAX + 1];
+static char *sbs_get_string_buf(struct sbs_info *chip,
+				enum power_supply_property psp)
+{
+	int i = 0;
+
+	for (i = 0; i < NR_STRING_BUFFERS; i++)
+		if (string_properties[i] == psp)
+			return chip->strings[i];
+
+	return ERR_PTR(-EINVAL);
+}
+
+static void sbs_invalidate_cached_props(struct sbs_info *chip)
+{
+	int i = 0;
+
+	chip->technology = -1;
+
+	for (i = 0; i < NR_STRING_BUFFERS; i++)
+		chip->strings[i][0] = 0;
+}
+
 static bool force_load;
 
 static int sbs_read_word_data(struct i2c_client *client, u8 address);
@@ -243,6 +272,7 @@ static int sbs_update_presence(struct sbs_info *chip, bool is_present)
 		chip->is_present = false;
 		/* Disable PEC when no device is present */
 		client->flags &= ~I2C_CLIENT_PEC;
+		sbs_invalidate_cached_props(chip);
 		return 0;
 	}
 
@@ -639,17 +669,45 @@ static int sbs_get_battery_property(struct i2c_client *client,
 	return 0;
 }
 
-static int sbs_get_battery_string_property(struct i2c_client *client,
-	int reg_offset, enum power_supply_property psp, char *val)
+static int sbs_get_property_index(struct i2c_client *client,
+	enum power_supply_property psp)
 {
-	s32 ret;
+	int count;
 
-	ret = sbs_read_string_data(client, sbs_data[reg_offset].addr, val);
+	for (count = 0; count < ARRAY_SIZE(sbs_data); count++)
+		if (psp == sbs_data[count].psp)
+			return count;
 
-	if (ret < 0)
-		return ret;
+	dev_warn(&client->dev,
+		"%s: Invalid Property - %d\n", __func__, psp);
 
-	return 0;
+	return -EINVAL;
+}
+
+static const char *sbs_get_constant_string(struct sbs_info *chip,
+			enum power_supply_property psp)
+{
+	int ret;
+	char *buf;
+	u8 addr;
+
+	buf = sbs_get_string_buf(chip, psp);
+	if (IS_ERR(buf))
+		return buf;
+
+	if (!buf[0]) {
+		ret = sbs_get_property_index(chip->client, psp);
+		if (ret < 0)
+			return ERR_PTR(ret);
+
+		addr = sbs_data[ret].addr;
+
+		ret = sbs_read_string_data(chip->client, addr, buf);
+		if (ret < 0)
+			return ERR_PTR(ret);
+	}
+
+	return buf;
 }
 
 static void  sbs_unit_adjustment(struct i2c_client *client,
@@ -772,48 +830,36 @@ static int sbs_get_battery_serial_number(struct i2c_client *client,
 	return 0;
 }
 
-static int sbs_get_property_index(struct i2c_client *client,
-	enum power_supply_property psp)
-{
-	int count;
-	for (count = 0; count < ARRAY_SIZE(sbs_data); count++)
-		if (psp == sbs_data[count].psp)
-			return count;
-
-	dev_warn(&client->dev,
-		"%s: Invalid Property - %d\n", __func__, psp);
-
-	return -EINVAL;
-}
-
-static int sbs_get_chemistry(struct i2c_client *client,
+static int sbs_get_chemistry(struct sbs_info *chip,
 		union power_supply_propval *val)
 {
-	enum power_supply_property psp = POWER_SUPPLY_PROP_TECHNOLOGY;
-	int ret;
+	const char *chemistry;
 
-	ret = sbs_get_property_index(client, psp);
-	if (ret < 0)
-		return ret;
+	if (chip->technology != -1) {
+		val->intval = chip->technology;
+		return 0;
+	}
 
-	ret = sbs_get_battery_string_property(client, ret, psp,
-					      chemistry);
-	if (ret < 0)
-		return ret;
+	chemistry = sbs_get_constant_string(chip, POWER_SUPPLY_PROP_TECHNOLOGY);
+
+	if (IS_ERR(chemistry))
+		return PTR_ERR(chemistry);
 
 	if (!strncasecmp(chemistry, "LION", 4))
-		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
+		chip->technology = POWER_SUPPLY_TECHNOLOGY_LION;
 	else if (!strncasecmp(chemistry, "LiP", 3))
-		val->intval = POWER_SUPPLY_TECHNOLOGY_LIPO;
+		chip->technology = POWER_SUPPLY_TECHNOLOGY_LIPO;
 	else if (!strncasecmp(chemistry, "NiCd", 4))
-		val->intval = POWER_SUPPLY_TECHNOLOGY_NiCd;
+		chip->technology = POWER_SUPPLY_TECHNOLOGY_NiCd;
 	else if (!strncasecmp(chemistry, "NiMH", 4))
-		val->intval = POWER_SUPPLY_TECHNOLOGY_NiMH;
+		chip->technology = POWER_SUPPLY_TECHNOLOGY_NiMH;
 	else
-		val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
+		chip->technology = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
+
+	if (chip->technology == POWER_SUPPLY_TECHNOLOGY_UNKNOWN)
+		dev_warn(&chip->client->dev, "Unknown chemistry: %s\n", chemistry);
 
-	if (val->intval == POWER_SUPPLY_TECHNOLOGY_UNKNOWN)
-		dev_warn(&client->dev, "Unknown chemistry: %s\n", chemistry);
+	val->intval = chip->technology;
 
 	return 0;
 }
@@ -857,6 +903,7 @@ static int sbs_get_property(struct power_supply *psy,
 	int ret = 0;
 	struct sbs_info *chip = power_supply_get_drvdata(psy);
 	struct i2c_client *client = chip->client;
+	const char *str;
 
 	if (chip->gpio_detect) {
 		ret = gpiod_get_value_cansleep(chip->gpio_detect);
@@ -882,7 +929,7 @@ static int sbs_get_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		ret = sbs_get_chemistry(client, val);
+		ret = sbs_get_chemistry(chip, val);
 		if (ret < 0)
 			break;
 
@@ -934,23 +981,12 @@ static int sbs_get_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_MODEL_NAME:
-		ret = sbs_get_property_index(client, psp);
-		if (ret < 0)
-			break;
-
-		ret = sbs_get_battery_string_property(client, ret, psp,
-						      model_name);
-		val->strval = model_name;
-		break;
-
 	case POWER_SUPPLY_PROP_MANUFACTURER:
-		ret = sbs_get_property_index(client, psp);
-		if (ret < 0)
-			break;
-
-		ret = sbs_get_battery_string_property(client, ret, psp,
-						      manufacturer);
-		val->strval = manufacturer;
+		str = sbs_get_constant_string(chip, psp);
+		if (IS_ERR(str))
+			ret = PTR_ERR(str);
+		else
+			val->strval = str;
 		break;
 
 	case POWER_SUPPLY_PROP_MANUFACTURE_YEAR:
@@ -1097,6 +1133,7 @@ static int sbs_probe(struct i2c_client *client)
 	psy_cfg.of_node = client->dev.of_node;
 	psy_cfg.drv_data = chip;
 	chip->last_state = POWER_SUPPLY_STATUS_UNKNOWN;
+	sbs_invalidate_cached_props(chip);
 	mutex_init(&chip->mode_lock);
 
 	/* use pdata if available, fall back to DT properties,
-- 
2.53.0



