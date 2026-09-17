Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34E44ED1A0;
	Thu, 17 Sep 2026 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659684; cv=none; b=ekIqVWJ8XsggJmt7ckgy4jMKkLUmu3d6kb70LJXXQHHJPPez82zwcZEAcYsVUXC4Ga0DR6rmglbPKKhICg+4Ofjkv+mmxG4M1A523JqxejmqkhFNZuvHMVqacOJ8gS8JyddQiTji9hoV3BiVnC6ejkNXPX1wfEzaBn3sXP3P+sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659684; c=relaxed/simple;
	bh=H6hmrOY8W1Hj+P0c8qJWW4envI3R7RVb7Su+wdUVZvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxL/qh2PcjK1cLQe9sk0XcgLO9HQWllqXckcr4VMV3lSxWTnDc3Z45G9niod7FT7/TIP9uX491Kcll4Qzy/J2RATY783xcEfiZspwzmNEl69eiUBvLE8P6MpnPfjkV9mm6nV3nDLhDZrdmXGz89Y8I5ss+9ESTi6NONSw33Y82U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsBSiumr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsBSiumr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD161F00899;
	Thu, 17 Sep 2026 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659673;
	bh=Zg+T74+v/ZbOxAR8nCVldKWYi18epWhEA2sURg2RZ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsBSiumrJoZ8R9hxdS6+CgwZF4AQ4MvojBlocXfOY+PmD5dnv9mQTPZLI7CUTMG1H
	 wXZSpgVT+7DW1/eOSSdeGqRFmjLb2G7lveC3lhFqOH7cXVwG9Ijj1R9zKtZvdNMdKA
	 8l1VwErwp9suLUaug1b8sTIArSTG9ahp/3aWTLOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 328/733] hwmon: (ina2xx) Decouple in0 and curr1 alarms
Date: Thu, 17 Sep 2026 16:10:36 +0100
Message-ID: <20260917151359.686407616@linuxfoundation.org>
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

[ Upstream commit 35760f5efd7bfa7a44a3831f47e19fe9cbafc905 ]

INA2XX current limits are converted into shunt voltage limits internally
using the shunt resistor value. Once a current limit's corresponding
voltage limit is written to the hardware, shunt voltage and current
alarms are indistinguishable from each other.

This causes two issues:

1. in0/curr1 alarms may be unintentionally cleared by reading from the
   opposite input's alarm.

2. When a limit for either in0 (shunt voltage) or curr1 (current) is
   set, both of their alarms are triggered, and both of their limits
   read nonzero.

An example of this behavior on an INA231:

        # cd /sys/class/hwmon/hwmon0
        # head {curr1,in0}_input
        ==> curr1_input <==
        1713

        ==> in0_input <==
        2
        # echo 1800 >curr1_lcrit
        # head {curr1,in0}_lcrit_alarm
        ==> curr1_lcrit_alarm <==
        1

        ==> in0_lcrit_alarm <==
        0
        # head {in0,curr1}_lcrit_alarm
        ==> in0_lcrit_alarm <==
        1

        ==> curr1_lcrit_alarm <==
        0
        # head {in0,curr1}_lcrit_alarm
        ==> in0_lcrit_alarm <==
        1

        ==> curr1_lcrit_alarm <==
        1

This is because curr1 uses the same underlying masks
(INA226_SHUNT_*_VOLTAGE_MASK) as in0 on the hardware. As a result,
ina2xx_{curr,in}_read() both read the shunt voltage alarms/limits
without considering whether the voltage or current is currently set.

To fix this, track the active alarm type in ina2xx_data and guard
alarm/limit reads with a check that returns zero if the active alarm is
for a different type. The new field is initialized based on the
MASK_ENABLE register's set function, assuming voltage instead of current
when the shunt voltage mask is set.

After this fix, the alarms only read back 1 if their corresponding limit
is set:

        # echo 0 >curr1_lcrit
        # head {curr1,in0}_lcrit_alarm
        ==> curr1_lcrit_alarm <==
        0

        ==> in0_lcrit_alarm <==
        0
        # echo 9999 >curr1_lcrit
        # head {curr1,in0}_lcrit_alarm
        ==> curr1_lcrit_alarm <==
        1

        ==> in0_lcrit_alarm <==
        0
        # echo 9999 >in0_lcrit
        # head {curr1,in0}_lcrit_alarm
        ==> curr1_lcrit_alarm <==
        0

        ==> in0_lcrit_alarm <==
        1

Fixes: 4d5c2d986757 ("hwmon: (ina2xx) Add support for current limits")
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Link: https://patch.msgid.link/20260820-upstream-ina2xx-in0-curr1-alarms-v2-4-fdce35abc41e@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina2xx.c | 65 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index dec4e72be2f92..958a1e3ec728d 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/bitops.h>
 #include <linux/bits.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -158,6 +159,7 @@ struct ina2xx_data {
 	const struct ina2xx_config *config;
 	enum ina2xx_ids chip;
 
+	enum ina2xx_alert_type active_alert;
 	long rshunt;
 	long current_lsb_uA;
 	long power_lsb_uW;
@@ -448,6 +450,35 @@ static u32 ina2xx_alert_type_to_mask(enum ina2xx_alert_type alert)
 	}
 }
 
+static enum ina2xx_alert_type ina2xx_mask_to_alert_type(u32 mask)
+{
+	int top_bit = fls(mask & INA226_ALERT_CONFIG_MASK);
+
+	if (!top_bit)
+		return INA2XX_ALERT_NONE;
+
+	/*
+	 * Multiple bits may be set, with the highest-set function taking
+	 * precedence according to the datasheet. Shunt voltage masks are
+	 * assumed to map to voltage monitoring rather than current monitoring,
+	 * since the latter isn't directly implemented in the hardware.
+	 */
+	switch (BIT(top_bit - 1)) {
+	case INA226_SHUNT_OVER_VOLTAGE_MASK:
+		return INA2XX_ALERT_SHUNT_VOLTAGE_HIGH;
+	case INA226_SHUNT_UNDER_VOLTAGE_MASK:
+		return INA2XX_ALERT_SHUNT_VOLTAGE_LOW;
+	case INA226_BUS_OVER_VOLTAGE_MASK:
+		return INA2XX_ALERT_BUS_VOLTAGE_HIGH;
+	case INA226_BUS_UNDER_VOLTAGE_MASK:
+		return INA2XX_ALERT_BUS_VOLTAGE_LOW;
+	case INA226_POWER_OVER_LIMIT_MASK:
+		return INA2XX_ALERT_POWER_HIGH;
+	default:
+		return INA2XX_ALERT_NONE;
+	}
+}
+
 static int ina226_alert_limit_read(struct ina2xx_data *data, enum ina2xx_alert_type alert,
 				   int reg, long *val)
 {
@@ -456,6 +487,12 @@ static int ina226_alert_limit_read(struct ina2xx_data *data, enum ina2xx_alert_t
 	u32 mask;
 	int ret;
 
+	/* Avoid nonzero reads from inactive alerts caused by shared limit register */
+	if (data->active_alert != alert) {
+		*val = 0;
+		return 0;
+	}
+
 	ret = regmap_read(regmap, INA226_MASK_ENABLE, &regval);
 	if (ret)
 		return ret;
@@ -491,6 +528,7 @@ static int ina226_alert_limit_write(struct ina2xx_data *data, enum ina2xx_alert_
 				 INA226_ALERT_CONFIG_MASK, 0);
 	if (ret < 0)
 		return ret;
+	data->active_alert = INA2XX_ALERT_NONE;
 
 	ret = regmap_write(regmap, INA226_ALERT_LIMIT,
 			   ina226_alert_to_reg(data, reg, val));
@@ -499,9 +537,13 @@ static int ina226_alert_limit_write(struct ina2xx_data *data, enum ina2xx_alert_
 
 	if (val) {
 		mask = ina2xx_alert_type_to_mask(alert);
-		return regmap_update_bits(regmap, INA226_MASK_ENABLE,
-					  INA226_ALERT_CONFIG_MASK, mask);
+		ret = regmap_update_bits(regmap, INA226_MASK_ENABLE,
+					 INA226_ALERT_CONFIG_MASK, mask);
+		if (ret < 0)
+			return ret;
+		data->active_alert = alert;
 	}
+
 	return 0;
 }
 
@@ -531,6 +573,15 @@ static int ina226_alert_read(struct ina2xx_data *data, enum ina2xx_alert_type al
 	u32 mask;
 	int ret;
 
+	/*
+	 * With alert latching, reading alerts from hardware also clears the
+	 * alert, so return early if the alert is inactive.
+	 */
+	if (data->active_alert != alert) {
+		*val = 0;
+		return 0;
+	}
+
 	ret = regmap_read_bypassed(data->regmap, INA226_MASK_ENABLE, &regval);
 	if (ret)
 		return ret;
@@ -973,6 +1024,16 @@ static int ina2xx_init(struct device *dev, struct ina2xx_data *data)
 
 	if (data->config->has_alerts) {
 		bool active_high = device_property_read_bool(dev, "ti,alert-polarity-active-high");
+		unsigned int mask_enable;
+
+		/*
+		 * Infer active alert from MASK_ENABLE in case it's already
+		 * configured (e.g., by a past probe or firmware)
+		 */
+		ret = regmap_read(regmap, INA226_MASK_ENABLE, &mask_enable);
+		if (ret < 0)
+			return ret;
+		data->active_alert = ina2xx_mask_to_alert_type(mask_enable);
 
 		regmap_update_bits(regmap, INA226_MASK_ENABLE,
 				   INA226_ALERT_LATCH_ENABLE | INA226_ALERT_POLARITY,
-- 
2.53.0



