Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE67B4D1795;
	Thu, 17 Sep 2026 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670571; cv=none; b=LZ/CWrc11fYuXKigzXx9qDFQJO6RP1R4YlOTSvEgXoSPZd+Og2EedtLd7Y7AtgM99X3I8V4W90XoSgITWIAkyQUjVW6qYPiGdKlL1jVO1OtASGsf3jeXvzoGe48GlR6uBX3/80gr/KDxYUwU6pUubZQt9+BBcUYzURivH6rXNN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670571; c=relaxed/simple;
	bh=dPsj3HbJ9YRzghUj5QAaNcjKYMIQoEyzaN96bB3L2dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2Awz6wWqbbqWulCk+LPgV7kaV/1nDxRY2MUnbrNel8fKANoDrZlc+DNdM348gAuMkZAZ3FUI670VVQbVWpFUTsWstW9WqDK+OJqkr0OC9LMeIasvbgNlG2oGIU/WPgPI80GGVzmr6btjyDUCpdh+FjR2p/mWTsydMzVijzsd/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKcBQsK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKcBQsK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323F51F00893;
	Thu, 17 Sep 2026 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670569;
	bh=sQoYDGY7r0u1JZazyUsndSSqZ5bjgQ/W1LlBP7AWxnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKcBQsK8Zth0f2ndctzNCzteI9KpGm/oaRUEptK1mzMrQQUImdzbBrGOtIXV7wJWe
	 VHEC1IHN3qEa1tnNePOTh58OEL3OcgDUBXVydmssOIcCxfDbzy/9u8MVaUxo+0mFTx
	 wpWogqaZVw/ZOB60Y2ITsV8F3ft7Q9/7OspjSW+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0704/1102] hwmon: Introduce 64-bit energy attribute support
Date: Thu, 17 Sep 2026 16:10:47 +0100
Message-ID: <20260917151557.990749662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0bcd01f757bc06471c82a137eafee281ef1b6e38 ]

Many chips require 64-bit variables to display the accumulated energy,
even more so since the energy units are micro-Joule. Add new sensor type
"energy64" to support reporting the chip energy as 64-bit values.

Changing the entire hardware monitoring API is not feasible, and it is only
really necessary to support reading 64-bit values for the "energyX_input"
attribute. For this reason, keep the API as-is and use type casts on both
ends to pass 64-bit pointers when reading the accumulated energy. On the
write side (which is only useful for the energyX_enable attribute), keep
passing the written value as long.

Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz> # INA780
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: b4fffa75c1d6 ("Documentation/hwmon: Document hwmon_notify_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/hwmon-kernel-api.rst |  3 +++
 drivers/hwmon/hwmon.c                    | 14 ++++++++++----
 include/linux/hwmon.h                    |  1 +
 include/trace/events/hwmon.h             | 10 +++++-----
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
index 8297acfa3a2d8..1577371ec2cbb 100644
--- a/Documentation/hwmon/hwmon-kernel-api.rst
+++ b/Documentation/hwmon/hwmon-kernel-api.rst
@@ -158,6 +158,7 @@ It contains following fields:
      hwmon_curr		Current sensor
      hwmon_power		Power sensor
      hwmon_energy	Energy sensor
+     hwmon_energy64	Energy sensor, reported as 64-bit signed value
      hwmon_humidity	Humidity sensor
      hwmon_fan		Fan speed sensor
      hwmon_pwm		PWM control
@@ -287,6 +288,8 @@ Parameters:
 		The sensor channel number.
 	val:
 		Pointer to attribute value.
+		For hwmon_energy64, `'val`' is passed as `long *` but needs
+		a typecast to `s64 *`.
 
 Return value:
 	0 on success, a negative error number otherwise.
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 9c35c4d0369d7..4ce18b9418783 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -424,18 +424,22 @@ static ssize_t hwmon_attr_show(struct device *dev,
 			       struct device_attribute *devattr, char *buf)
 {
 	struct hwmon_device_attribute *hattr = to_hwmon_attr(devattr);
+	s64 val64;
 	long val;
 	int ret;
 
 	ret = hattr->ops->read(dev, hattr->type, hattr->attr, hattr->index,
-			       &val);
+			       (hattr->type == hwmon_energy64) ? (long *)&val64 : &val);
 	if (ret < 0)
 		return ret;
 
+	if (hattr->type != hwmon_energy64)
+		val64 = val;
+
 	trace_hwmon_attr_show(hattr->index + hwmon_attr_base(hattr->type),
-			      hattr->name, val);
+			      hattr->name, val64);
 
-	return sprintf(buf, "%ld\n", val);
+	return sprintf(buf, "%lld\n", val64);
 }
 
 static ssize_t hwmon_attr_show_string(struct device *dev,
@@ -476,7 +480,7 @@ static ssize_t hwmon_attr_store(struct device *dev,
 		return ret;
 
 	trace_hwmon_attr_store(hattr->index + hwmon_attr_base(hattr->type),
-			       hattr->name, val);
+			       hattr->name, (s64)val);
 
 	return count;
 }
@@ -732,6 +736,7 @@ static const char * const *__templates[] = {
 	[hwmon_curr] = hwmon_curr_attr_templates,
 	[hwmon_power] = hwmon_power_attr_templates,
 	[hwmon_energy] = hwmon_energy_attr_templates,
+	[hwmon_energy64] = hwmon_energy_attr_templates,
 	[hwmon_humidity] = hwmon_humidity_attr_templates,
 	[hwmon_fan] = hwmon_fan_attr_templates,
 	[hwmon_pwm] = hwmon_pwm_attr_templates,
@@ -745,6 +750,7 @@ static const int __templates_size[] = {
 	[hwmon_curr] = ARRAY_SIZE(hwmon_curr_attr_templates),
 	[hwmon_power] = ARRAY_SIZE(hwmon_power_attr_templates),
 	[hwmon_energy] = ARRAY_SIZE(hwmon_energy_attr_templates),
+	[hwmon_energy64] = ARRAY_SIZE(hwmon_energy_attr_templates),
 	[hwmon_humidity] = ARRAY_SIZE(hwmon_humidity_attr_templates),
 	[hwmon_fan] = ARRAY_SIZE(hwmon_fan_attr_templates),
 	[hwmon_pwm] = ARRAY_SIZE(hwmon_pwm_attr_templates),
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 5c6a421ad5805..6544412bf9f28 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -24,6 +24,7 @@ enum hwmon_sensor_types {
 	hwmon_curr,
 	hwmon_power,
 	hwmon_energy,
+	hwmon_energy64,
 	hwmon_humidity,
 	hwmon_fan,
 	hwmon_pwm,
diff --git a/include/trace/events/hwmon.h b/include/trace/events/hwmon.h
index d1ff560cd9b56..3865098f21f14 100644
--- a/include/trace/events/hwmon.h
+++ b/include/trace/events/hwmon.h
@@ -9,14 +9,14 @@
 
 DECLARE_EVENT_CLASS(hwmon_attr_class,
 
-	TP_PROTO(int index, const char *attr_name, long val),
+	TP_PROTO(int index, const char *attr_name, long long val),
 
 	TP_ARGS(index, attr_name, val),
 
 	TP_STRUCT__entry(
 		__field(int, index)
 		__string(attr_name, attr_name)
-		__field(long, val)
+		__field(long long, val)
 	),
 
 	TP_fast_assign(
@@ -25,20 +25,20 @@ DECLARE_EVENT_CLASS(hwmon_attr_class,
 		__entry->val = val;
 	),
 
-	TP_printk("index=%d, attr_name=%s, val=%ld",
+	TP_printk("index=%d, attr_name=%s, val=%lld",
 		  __entry->index,  __get_str(attr_name), __entry->val)
 );
 
 DEFINE_EVENT(hwmon_attr_class, hwmon_attr_show,
 
-	TP_PROTO(int index, const char *attr_name, long val),
+	TP_PROTO(int index, const char *attr_name, long long val),
 
 	TP_ARGS(index, attr_name, val)
 );
 
 DEFINE_EVENT(hwmon_attr_class, hwmon_attr_store,
 
-	TP_PROTO(int index, const char *attr_name, long val),
+	TP_PROTO(int index, const char *attr_name, long long val),
 
 	TP_ARGS(index, attr_name, val)
 );
-- 
2.53.0



