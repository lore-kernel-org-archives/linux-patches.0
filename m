Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591114;
	b=eeH8yZMX4uy2QZMnFamEX53ahRSh2wctDQr6SlDujwP/PmO+WxWd7u6BNSCWfbptCudP
	 D4LvGv5RyJSBN89T3HJzJsd1rkQPIK0cB2nSmd7NMoMdG4LACboli/gBYf7SHCAsmMuih
	 e7rXWbU+HPqWEUphDIQtcW8UUnkeEFTAi/EG38yvKmx896wzGJQTuLAz9EacIKnur+e7m
	 DOyv+onBp3ZbdP5+TxTNM+xH4H5Ddb+HV22F2fHJejlg0S3Ca4jndBZQvlREkVgw4fHcg
	 6Tzjsin7vKoyjfwOVwUczymG3YjEYT7Lg1IEFav2xxJNQlYkmvT/zY17NecT8KxN2JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zyJNrUOBm3elIFfRC6LJsK9A0FqRnRUbaCPTlBrmZMU=;
	b=R4y7wsZ+CJeceakqTe/GotYO+7lRiL7Zqlsp8kI7jLW1pVWCPdMkSKlmqDkXD7lxaCi8
	 GCPheSDrVuVM2bYbVCUKYIQvUZmOF7DWgJCdu+K9EwSwT6JbbtoOxgD8wweOCj+BsbXJk
	 +/AbsiEX8g2QKl+mGDbMSsJrSKlNZAQc3Mbafi+rv5XbE/dPfIGNhXgSQvU7RaBd036zw
	 5p9wFNq2iDNrbHYLXRXVfeVz/h1CKmoXu304jtfVas69lAooHJgasyFF5f/9gH9dpz9yu
	 1L+yerO/xtLBK8n+vBa/gzAJhOrNBYnICwNgZR7PAmJ99aHfTpgkB9fDyStXccqHivA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgGateud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA8C606A8B3;
	Fri, 13 Nov 2026 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgGateud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693461F000C4;
	Fri, 13 Nov 2026 17:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591114;
	bh=zyJNrUOBm3elIFfRC6LJsK9A0FqRnRUbaCPTlBrmZMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgGateudOgbax6Jr5IE67WQP3s0Od0Q3xLa0n5hfnhAkpZSCMLQJgETbdBnEgNyQx
	 AFUbpV52VoEm1QXB4Lxd7h43EXrftJLhXA5HON//sURRbIuhzMwrNMzh3hkZQU4han
	 h3daSL2F8gqFvs8ffXo5kvUd4uAwBVfZI+kzSxt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vas Zayarskiy <contact@vasily.cc>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/670] hwmon: (aquacomputer_d5next) Avoid truncating scaled sensor readings
Date: Fri, 13 Nov 2026 10:47:09 -0500
Message-ID: <20261113153820.840009574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vas Zayarskiy <contact@vasily.cc>

[ Upstream commit c221091f7e30c64280e4cbfa27dc4c05edc96d0c ]

High Flow Next power is reported in watts. Multiplying the 16-bit value
by one million can overflow both the signed intermediate and the u32
cache. Store power in long, perform the conversion in u64, and clamp to
LONG_MAX. The other existing power conversions fit in a signed 32-bit
value. Return -ENODATA for unavailable power instead of exposing the
stored error as a reading.

The power cache is updated by HID reports without the hwmon read mutex.
Read it once with READ_ONCE() and use that snapshot for both the
availability check and the returned value. Mark the corresponding
updates with WRITE_ONCE() so that the shared accesses are explicit.

Widen the shared current cache to u32. The Aquastream XT conversion to
milliamperes can exceed 65535 mA; clamp its negative conversion results
to zero before assigning to the unsigned cache. This also permits devices
with scaled aggregate currents to store milliamperes directly.

Fixes: aed80bb91de8 ("hwmon: (aquacomputer_d5next) Add support for Aquacomputer High Flow Next")
Cc: stable@vger.kernel.org
Signed-off-by: Vas Zayarskiy <contact@vasily.cc>
Link: https://patch.msgid.link/20260927191316.4137752-2-contact@vasily.cc
[groeck: Dropped obsolete 'Assisted-by: tag]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index e0052ba4702c6..95ec74c6e67eb 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -19,6 +19,7 @@
 #include <linux/hwmon.h>
 #include <linux/jiffies.h>
 #include <linux/ktime.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
@@ -614,9 +615,9 @@ struct aqc_data {
 	u32 speed_input_min[1];
 	u32 speed_input_target[1];
 	u32 speed_input_max[1];
-	u32 power_input[8];
+	long power_input[8];
 	u16 voltage_input[8];
-	u16 current_input[8];
+	u32 current_input[8];
 
 	/* Label values */
 	const char *const *temp_label;
@@ -1009,7 +1010,7 @@ static int aqc_legacy_read(struct aqc_data *priv)
 
 		/* Calculation derived from linear regression */
 		sensor_value = get_unaligned_le16(priv->buffer + AQUASTREAMXT_PUMP_CURR_OFFSET);
-		priv->current_input[0] = DIV_ROUND_CLOSEST(sensor_value * 176, 100) - 52;
+		priv->current_input[0] = max(DIV_ROUND_CLOSEST(sensor_value * 176, 100) - 52, 0);
 
 		sensor_value = get_unaligned_le16(priv->buffer + AQUASTREAMXT_PUMP_VOLTAGE_OFFSET);
 		priv->voltage_input[0] = DIV_ROUND_CLOSEST(sensor_value * 1000, 61);
@@ -1042,6 +1043,7 @@ static int aqc_legacy_read(struct aqc_data *priv)
 static int aqc_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 		    int channel, long *val)
 {
+	long power;
 	int ret;
 	struct aqc_data *priv = dev_get_drvdata(dev);
 
@@ -1106,7 +1108,10 @@ static int aqc_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 		}
 		break;
 	case hwmon_power:
-		*val = priv->power_input[channel];
+		power = READ_ONCE(priv->power_input[channel]);
+		if (power == -ENODATA)
+			return -ENODATA;
+		*val = power;
 		break;
 	case hwmon_pwm:
 		switch (priv->kind) {
@@ -1406,9 +1411,9 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 		priv->speed_input[i] =
 		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
 				       priv->fan_structure->speed);
-		priv->power_input[i] =
-		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
-				       priv->fan_structure->power) * 10000;
+		WRITE_ONCE(priv->power_input[i],
+			   get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
+					      priv->fan_structure->power) * 10000);
 		priv->voltage_input[i] =
 		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
 				       priv->fan_structure->voltage) * 10;
@@ -1448,7 +1453,8 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 		priv->speed_input[2] = get_unaligned_be16(data + AQUASTREAMULT_PRESSURE_OFFSET);
 		priv->speed_input[3] = get_unaligned_be16(data + AQUASTREAMULT_FLOW_SENSOR_OFFSET);
 
-		priv->power_input[1] = get_unaligned_be16(data + AQUASTREAMULT_PUMP_POWER) * 10000;
+		WRITE_ONCE(priv->power_input[1],
+			   get_unaligned_be16(data + AQUASTREAMULT_PUMP_POWER) * 10000);
 
 		priv->voltage_input[1] = get_unaligned_be16(data + AQUASTREAMULT_PUMP_VOLTAGE) * 10;
 
@@ -1461,10 +1467,11 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 	case highflownext:
 		/* If external temp sensor is not connected, its power reading is also N/A */
 		if (priv->temp_input[1] == -ENODATA)
-			priv->power_input[0] = -ENODATA;
+			WRITE_ONCE(priv->power_input[0], -ENODATA);
 		else
-			priv->power_input[0] =
-			    get_unaligned_be16(data + HIGHFLOWNEXT_POWER) * 1000000;
+			WRITE_ONCE(priv->power_input[0],
+				   min_t(u64, get_unaligned_be16(data + HIGHFLOWNEXT_POWER) *
+					 1000000ULL, LONG_MAX));
 
 		priv->voltage_input[0] = get_unaligned_be16(data + HIGHFLOWNEXT_5V_VOLTAGE) * 10;
 		priv->voltage_input[1] =
-- 
2.53.0



