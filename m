Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A503149D5A3;
	Thu, 17 Sep 2026 17:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665845; cv=none; b=OxfFhiPduWewBs/8bgme0VgzWDD+erlwFn2QYu6okg8EcgQFuo+QBXqPxtIH4H+fyxCTObh88o8X7V05GyIvVMjDF1fhaRYq3b/acInHQZj7GGNSumQX3GBim9eclBpfKqzUFBSJBjVS/hAAKi1t33xm68EY7NlJS5pK6aTc9nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665845; c=relaxed/simple;
	bh=lyxYcCYGXdlsaJV5LVfll7kRNGgLuO8Jn19sDuYqwDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRXClCs5UMVRCsTvgevi00cO83eMyMQLdSV3k9aw20JEnkoYs1+w2hyx8AKTD2Q6yjh2ru+pOvWDdRhYFSt4wvro7yPYvvbReAl/U/G04AcKiY5MNHdF715E7yPx5jZ7ICofEZfpTX2wbD1K9KlxVYdAW4LXYgMME9jgNXTGS2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gF9ilTPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gF9ilTPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021DF1F000FF;
	Thu, 17 Sep 2026 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665844;
	bh=0opCbVkV3LfkZ/c67qAc46INXT6H//9OEW/Y55erRcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gF9ilTPuD+VSfzVkIqq4ELuaPAS/PiJIs1HZ80YHZIiMV4PnjBt6A6usD/q890kqH
	 fl+ZEKe5LPM3xao36Nh1zZrHbtY5rqAlvVdsX9A0E5r04dcWRZMEKP1mTzahsbAqtC
	 dgtQhMZguLzjuCVR0D+RYJ6Gye3VXJIPp80QEADI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0839/1250] hwmon: (ina2xx) Rely on subsystem locking
Date: Thu, 17 Sep 2026 16:10:34 +0100
Message-ID: <20260917151614.692827641@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit caff6fba5166b6da14ed00c64ad8acf376676e54 ]

Attribute access is now serialized in the hardware monitoring core,
so locking in the driver code is no longer necessary. Drop it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 35760f5efd7b ("hwmon: (ina2xx) Decouple in0 and curr1 alarms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina2xx.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index cde119054f301..e9fb2a90a11c1 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -166,7 +166,6 @@ struct ina2xx_data {
 	long rshunt;
 	long current_lsb_uA;
 	long power_lsb_uW;
-	struct mutex config_lock;
 	struct regmap *regmap;
 	struct i2c_client *client;
 };
@@ -436,22 +435,19 @@ static int ina226_alert_limit_read(struct ina2xx_data *data, u32 mask, int reg,
 	int regval;
 	int ret;
 
-	mutex_lock(&data->config_lock);
 	ret = regmap_read(regmap, INA226_MASK_ENABLE, &regval);
 	if (ret)
-		goto abort;
+		return ret;
 
 	if (regval & mask) {
 		ret = regmap_read(regmap, INA226_ALERT_LIMIT, &regval);
 		if (ret)
-			goto abort;
+			return ret;
 		*val = ina2xx_get_value(data, reg, regval);
 	} else {
 		*val = 0;
 	}
-abort:
-	mutex_unlock(&data->config_lock);
-	return ret;
+	return 0;
 }
 
 static int ina226_alert_limit_write(struct ina2xx_data *data, u32 mask, int reg, long val)
@@ -467,23 +463,20 @@ static int ina226_alert_limit_write(struct ina2xx_data *data, u32 mask, int reg,
 	 * due to register write sequence. Then, only enable the alert
 	 * if the value is non-zero.
 	 */
-	mutex_lock(&data->config_lock);
 	ret = regmap_update_bits(regmap, INA226_MASK_ENABLE,
 				 INA226_ALERT_CONFIG_MASK, 0);
 	if (ret < 0)
-		goto abort;
+		return ret;
 
 	ret = regmap_write(regmap, INA226_ALERT_LIMIT,
 			   ina226_alert_to_reg(data, reg, val));
 	if (ret < 0)
-		goto abort;
+		return ret;
 
 	if (val)
-		ret = regmap_update_bits(regmap, INA226_MASK_ENABLE,
-					 INA226_ALERT_CONFIG_MASK, mask);
-abort:
-	mutex_unlock(&data->config_lock);
-	return ret;
+		return regmap_update_bits(regmap, INA226_MASK_ENABLE,
+					  INA226_ALERT_CONFIG_MASK, mask);
+	return 0;
 }
 
 static int ina2xx_chip_read(struct device *dev, u32 attr, long *val)
@@ -911,9 +904,9 @@ static ssize_t shunt_resistor_store(struct device *dev,
 	if (status < 0)
 		return status;
 
-	mutex_lock(&data->config_lock);
+	hwmon_lock(dev);
 	status = ina2xx_set_shunt(data, val);
-	mutex_unlock(&data->config_lock);
+	hwmon_unlock(dev);
 	if (status < 0)
 		return status;
 	return count;
@@ -1003,7 +996,6 @@ static int ina2xx_probe(struct i2c_client *client)
 	data->client = client;
 	data->config = &ina2xx_config[chip];
 	data->chip = chip;
-	mutex_init(&data->config_lock);
 
 	data->regmap = devm_regmap_init_i2c(client, &ina2xx_regmap_config);
 	if (IS_ERR(data->regmap)) {
-- 
2.53.0



