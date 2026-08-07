Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE94280331;
	Fri,  7 Aug 2026 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116793; cv=none; b=FQjJ7gXUgHIzYzq8O9k6Ml0r+ZTDLdVmWsicGSMJUO6/DKev5ekePkDXEyH9NPt1dY/QVppAAKXYNiqHD2QKeu1atUc5NBDAm48cckCjg2ATiBOLQzFp7nfjGgF93aw8INY0k773GMg4xmaN7BpgJOEIONLjtPrEpKuWgx1W05E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116793; c=relaxed/simple;
	bh=qnaVeXtlFJL5ukPo4uHtRj81/55k8/u7D4F2TJ0SAb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7XcAHtEsNH6Mi2hmsOow/Anbj2FSxibO8vsDwXd726g4mXCaNNXkiguMOvy0leagmr569Gz6Vn4M3yt8k0LEOI6CYXrOS5zoH+HYBJ1JsQdfEdo29rzhNwbvjLpxtVFCaWJYRe+m36G6PH4U71JKyUrIja+v/w5XJ+jEcZDbsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFkhp79Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFkhp79Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D3E1F00A3A;
	Fri,  7 Aug 2026 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116791;
	bh=oi6GYIqIIu9eKvRBKJuyAoKu65pMbDemPE/iNSPZ2uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFkhp79ZtGHze48vD6p8/Rf+oGRY7aUDR6eGe0U1Fr7BXCeGA5Y20ppt9Z1WJNo6I
	 3oOXvcLALjVxHy6dkSMBO7g791ksSpHRK8aohWoOZvc1awFubv6mzT73/HL2rQvjzO
	 bBU+uYy3ytdtdPhJ5avwdzN7nynK8eg1fQCPPfi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 092/438] hwmon: (ina2xx) Fix various overflow issues
Date: Fri,  7 Aug 2026 16:34:48 +0200
Message-ID: <20260807143429.954257720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit e6c80061ca239f45c0eaf7e47a91d6d6df9bd636 ]

Sashiko reports several integer overflow problems in the ina2xx driver
caused by unbounded multiplications and inadequate types for intermediate
calculations.

Specifically:
- In ina2xx_get_value(), the return type is changed from int to long.
  Intermediate calculations for current are now performed using 64-bit
  types to prevent 32-bit integer overflow before the division by 1000.
- When calculating power in ina2xx_get_value() and
  sy24655_average_power_read(), interim values are cast to u64 and clamped
  to LONG_MAX. This prevents overflow when regval or accumulator_24 is
  multiplied by power_lsb_uW.
- In ina226_alert_to_reg(), the clamping logic is rewritten using min_t().
  This safely avoids integer overflows when scaling user-provided values
  for shunt voltage, bus voltage, power, and current limits.

Cc: Loic Poulain <loic.poulain@oss.qualcomm.com>
Fixes: ab7fbee452be ("hwmon: (ina2xx) Fix various overflow issues")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina2xx.c | 61 ++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 32bf4595bcb48..789eeb718b1ca 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -16,6 +16,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/regmap.h>
@@ -266,30 +267,34 @@ static u16 ina226_interval_to_reg(long interval)
 	return FIELD_PREP(INA226_AVG_RD_MASK, avg_bits);
 }
 
-static int ina2xx_get_value(struct ina2xx_data *data, u8 reg,
-			    unsigned int regval)
+static long ina2xx_get_value(struct ina2xx_data *data, u8 reg,
+			     unsigned int regval)
 {
-	int val;
+	s64 val64;
+	long val;
 
 	switch (reg) {
 	case INA2XX_SHUNT_VOLTAGE:
 		/* signed register */
-		val = (s16)regval >> data->config->shunt_voltage_shift;
-		val = DIV_ROUND_CLOSEST(val, data->config->shunt_div);
+		val = DIV_ROUND_CLOSEST((s16)regval >> data->config->shunt_voltage_shift,
+					data->config->shunt_div);
 		break;
 	case INA2XX_BUS_VOLTAGE:
-		val = (regval >> data->config->bus_voltage_shift) *
-		  data->config->bus_voltage_lsb;
-		val = DIV_ROUND_CLOSEST(val, 1000);
+		val = DIV_ROUND_CLOSEST((regval >> data->config->bus_voltage_shift) *
+					data->config->bus_voltage_lsb, 1000);
 		break;
 	case INA2XX_POWER:
-		val = regval * data->power_lsb_uW;
+		val = min_t(u64, (u64)regval * data->power_lsb_uW, LONG_MAX);
 		break;
 	case INA2XX_CURRENT:
 		/* signed register, result in mA */
-		val = ((s16)regval >> data->config->current_shift) *
+		val64 = (s64)((s16)regval >> data->config->current_shift) *
 		  data->current_lsb_uA;
-		val = DIV_ROUND_CLOSEST(val, 1000);
+		if (val64 < 0)
+			val64 = -DIV_ROUND_CLOSEST_ULL(-val64, 1000);
+		else
+			val64 = DIV_ROUND_CLOSEST_ULL(val64, 1000);
+		val = clamp_val(val64, LONG_MIN, LONG_MAX);
 		break;
 	case INA2XX_CALIBRATION:
 		val = regval;
@@ -378,27 +383,29 @@ static int ina2xx_read_init(struct device *dev, int reg, long *val)
  */
 static u16 ina226_alert_to_reg(struct ina2xx_data *data, int reg, long val)
 {
+	long limit;
+
 	switch (reg) {
 	case INA2XX_SHUNT_VOLTAGE:
-		val = clamp_val(val, 0, SHRT_MAX * data->config->shunt_div);
-		val *= data->config->shunt_div;
-		val <<= data->config->shunt_voltage_shift;
-		return clamp_val(val, 0, SHRT_MAX);
+		val = min_t(long, val, DIV_ROUND_CLOSEST(SHRT_MAX, data->config->shunt_div));
+		return min_t(long, (val * data->config->shunt_div) << data->config->shunt_voltage_shift,
+			     SHRT_MAX);
 	case INA2XX_BUS_VOLTAGE:
-		val = clamp_val(val, 0, 200000);
-		val = (val * 1000) << data->config->bus_voltage_shift;
-		val = DIV_ROUND_CLOSEST(val, data->config->bus_voltage_lsb);
-		return clamp_val(val, 0, USHRT_MAX);
+		val = min_t(long, val, 130000);
+		return min_t(long,
+			     DIV_ROUND_CLOSEST((val * 1000) << data->config->bus_voltage_shift,
+					       data->config->bus_voltage_lsb),
+			     USHRT_MAX);
 	case INA2XX_POWER:
-		val = clamp_val(val, 0, UINT_MAX - data->power_lsb_uW);
-		val = DIV_ROUND_CLOSEST(val, data->power_lsb_uW);
-		return clamp_val(val, 0, USHRT_MAX);
+		val = min_t(long, val, LONG_MAX - data->power_lsb_uW);
+		return min_t(long, DIV_ROUND_CLOSEST(val, data->power_lsb_uW), USHRT_MAX);
 	case INA2XX_CURRENT:
-		val = clamp_val(val, INT_MIN / 1000, INT_MAX / 1000);
+		limit = (LONG_MAX - (data->current_lsb_uA / 2)) / 1000;
+		val = min_t(long, val, limit);
 		/* signed register, result in mA */
 		val = DIV_ROUND_CLOSEST(val * 1000, data->current_lsb_uA);
-		val <<= data->config->current_shift;
-		return clamp_val(val, SHRT_MIN, SHRT_MAX);
+		limit = SHRT_MAX >> data->config->current_shift;
+		return (u16)(min_t(long, val, limit) << data->config->current_shift);
 	default:
 		/* programmer goofed */
 		WARN_ON_ONCE(1);
@@ -537,6 +544,7 @@ static int sy24655_average_power_read(struct ina2xx_data *data, u8 reg, long *va
 	u8 template[6];
 	int ret;
 	long accumulator_24, sample_count;
+	u64 val64;
 
 	/* 48-bit register read */
 	ret = i2c_smbus_read_i2c_block_data(data->client, reg, 6, template);
@@ -555,7 +563,8 @@ static int sy24655_average_power_read(struct ina2xx_data *data, u8 reg, long *va
 		return 0;
 	}
 
-	*val = DIV_ROUND_CLOSEST(accumulator_24, sample_count) * data->power_lsb_uW;
+	val64 = (u64)DIV_ROUND_CLOSEST(accumulator_24, sample_count) * data->power_lsb_uW;
+	*val = min_t(u64, val64, LONG_MAX);
 
 	return 0;
 }
-- 
2.53.0



