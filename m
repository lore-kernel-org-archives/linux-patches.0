Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C1A427A1B;
	Tue, 31 Mar 2026 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975159; cv=none; b=J5gdp032p0iLhhbgTy5ZVt6LkpnhIfE6FYp8gkpq1JtylPhJlx8vqp2zA8q4RV5Ph9HfAwMK8DW/Kdw53HkE7r+kJQf+km1V7cHT28xnvWUwW1kbpY286YbLDa+MRxJdphTPNC4o8IwGzx9GU0Ygdxu1C3IacHeaq6kyyXgW3OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975159; c=relaxed/simple;
	bh=5qHAMyPk6NPK5FaXUzXBRC/NlRtxfuBLC8mTtreFi1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3LHKlLF4wiBOzOkPT1VyYf0JPqwsooBstzxzh8JrX+cT5lCdu0kYy0qZucvQlI52oZuoqxCWjkQ+3w6Cj1K6KKKRo1urlzFPdUHOpdyNWtEoNF9QA96vJYRu4bftQ2RS/5dRl1oxtb5O/MSsRsWcP6uFUgI3yVk+Wnt4g8zqMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpEzt8qI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpEzt8qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF44C19423;
	Tue, 31 Mar 2026 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975159;
	bh=5qHAMyPk6NPK5FaXUzXBRC/NlRtxfuBLC8mTtreFi1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpEzt8qIL1JwM653zjlCWTFCv1EF2lTotIAJezwWOQ8ollcZSDKep/Ad6VTtHMLh1
	 WZ2KtYj67QrE2iXgsr9roQl+ANDx/duOHbZgEk4JgQWESQi3fx6BBuZENuxoNWybDa
	 zvouB9r5Ne5lGoTeNq5p/IZWSUcA+HGyUDNidA+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 186/342] hwmon: (pmbus) Introduce the concept of "write-only" attributes
Date: Tue, 31 Mar 2026 18:20:19 +0200
Message-ID: <20260331161805.845589012@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit cd658475e7694d58e1c40dabc1dacf8431ccedb2 ]

Attributes intended to clear sensor history are intended to be writeable
only. Reading those attributes today results in reporting more or less
random values. To avoid ABI surprises, have those attributes explicitly
return 0 when reading.

Fixes: 787c095edaa9d ("hwmon: (pmbus/core) Add support for rated attributes")
Reviewed-by: Sanman Pradhan <psanman@juniper.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index ecd1dddcbe0ff..cbc36f0ba4bf9 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1209,6 +1209,12 @@ static ssize_t pmbus_show_boolean(struct device *dev,
 	return sysfs_emit(buf, "%d\n", val);
 }
 
+static ssize_t pmbus_show_zero(struct device *dev,
+			       struct device_attribute *devattr, char *buf)
+{
+	return sysfs_emit(buf, "0\n");
+}
+
 static ssize_t pmbus_show_sensor(struct device *dev,
 				 struct device_attribute *devattr, char *buf)
 {
@@ -1407,7 +1413,7 @@ static struct pmbus_sensor *pmbus_add_sensor(struct pmbus_data *data,
 					     int reg,
 					     enum pmbus_sensor_classes class,
 					     bool update, bool readonly,
-					     bool convert)
+					     bool writeonly, bool convert)
 {
 	struct pmbus_sensor *sensor;
 	struct device_attribute *a;
@@ -1436,7 +1442,8 @@ static struct pmbus_sensor *pmbus_add_sensor(struct pmbus_data *data,
 	sensor->data = -ENODATA;
 	pmbus_dev_attr_init(a, sensor->name,
 			    readonly ? 0444 : 0644,
-			    pmbus_show_sensor, pmbus_set_sensor);
+			    writeonly ? pmbus_show_zero : pmbus_show_sensor,
+			    pmbus_set_sensor);
 
 	if (pmbus_add_attribute(data, &a->attr))
 		return NULL;
@@ -1496,6 +1503,7 @@ struct pmbus_limit_attr {
 	u16 reg;		/* Limit register */
 	u16 sbit;		/* Alarm attribute status bit */
 	bool readonly:1;	/* True if the attribute is read-only */
+	bool writeonly:1;	/* True if the attribute is write-only */
 	bool update:1;		/* True if register needs updates */
 	bool low:1;		/* True if low limit; for limits with compare functions only */
 	const char *attr;	/* Attribute name */
@@ -1545,7 +1553,7 @@ static int pmbus_add_limit_attrs(struct i2c_client *client,
 			curr = pmbus_add_sensor(data, name, l->attr, index,
 						page, 0xff, l->reg, attr->class,
 						attr->update || l->update,
-						l->readonly, true);
+						l->readonly, l->writeonly, true);
 			if (!curr)
 				return -ENOMEM;
 			if (l->sbit && (info->func[page] & attr->sfunc)) {
@@ -1585,7 +1593,7 @@ static int pmbus_add_sensor_attrs_one(struct i2c_client *client,
 			return ret;
 	}
 	base = pmbus_add_sensor(data, name, "input", index, page, phase,
-				attr->reg, attr->class, true, true, true);
+				attr->reg, attr->class, true, true, false, true);
 	if (!base)
 		return -ENOMEM;
 	/* No limit and alarm attributes for phase specific sensors */
@@ -1722,6 +1730,7 @@ static const struct pmbus_limit_attr vin_limit_attrs[] = {
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_VIN_HISTORY,
+		.writeonly = true,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_VIN_MIN,
@@ -1796,6 +1805,7 @@ static const struct pmbus_limit_attr vout_limit_attrs[] = {
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_VOUT_HISTORY,
+		.writeonly = true,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_VOUT_MIN,
@@ -1877,6 +1887,7 @@ static const struct pmbus_limit_attr iin_limit_attrs[] = {
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_IIN_HISTORY,
+		.writeonly = true,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_IIN_MAX,
@@ -1918,6 +1929,7 @@ static const struct pmbus_limit_attr iout_limit_attrs[] = {
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_IOUT_HISTORY,
+		.writeonly = true,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_IOUT_MAX,
@@ -1976,6 +1988,7 @@ static const struct pmbus_limit_attr pin_limit_attrs[] = {
 		.attr = "input_highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_PIN_HISTORY,
+		.writeonly = true,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_PIN_MAX,
@@ -2017,6 +2030,7 @@ static const struct pmbus_limit_attr pout_limit_attrs[] = {
 		.attr = "input_highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_POUT_HISTORY,
+		.writeonly = true,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_POUT_MAX,
@@ -2088,6 +2102,7 @@ static const struct pmbus_limit_attr temp_limit_attrs[] = {
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_TEMP_HISTORY,
+		.writeonly = true,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_MAX_TEMP_1,
@@ -2133,6 +2148,7 @@ static const struct pmbus_limit_attr temp_limit_attrs2[] = {
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_TEMP2_HISTORY,
+		.writeonly = true,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_MAX_TEMP_2,
@@ -2250,7 +2266,7 @@ static int pmbus_add_fan_ctrl(struct i2c_client *client,
 
 	sensor = pmbus_add_sensor(data, "fan", "target", index, page,
 				  0xff, PMBUS_VIRT_FAN_TARGET_1 + id, PSC_FAN,
-				  false, false, true);
+				  false, false, false, true);
 
 	if (!sensor)
 		return -ENOMEM;
@@ -2261,14 +2277,14 @@ static int pmbus_add_fan_ctrl(struct i2c_client *client,
 
 	sensor = pmbus_add_sensor(data, "pwm", NULL, index, page,
 				  0xff, PMBUS_VIRT_PWM_1 + id, PSC_PWM,
-				  false, false, true);
+				  false, false, false, true);
 
 	if (!sensor)
 		return -ENOMEM;
 
 	sensor = pmbus_add_sensor(data, "pwm", "enable", index, page,
 				  0xff, PMBUS_VIRT_PWM_ENABLE_1 + id, PSC_PWM,
-				  true, false, false);
+				  true, false, false, false);
 
 	if (!sensor)
 		return -ENOMEM;
@@ -2310,7 +2326,7 @@ static int pmbus_add_fan_attributes(struct i2c_client *client,
 
 			if (pmbus_add_sensor(data, "fan", "input", index,
 					     page, 0xff, pmbus_fan_registers[f],
-					     PSC_FAN, true, true, true) == NULL)
+					     PSC_FAN, true, true, false, true) == NULL)
 				return -ENOMEM;
 
 			/* Fan control */
-- 
2.53.0



