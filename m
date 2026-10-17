Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908BA391E74;
	Sat, 17 Oct 2026 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254638; cv=none; b=aEkRIbB1vhIZtxgmxwY9XomlUY30Wk3/Q93PjGs1nFTVglx4wDD6Pab8FttWz8PGXBupljfr8wPx0iU23JzN3umjvo+K2hKbqu0cLvBb5bpzcCrj06p+xejRgXY2E0Jb5dksuoC4tY++sTMQRY4ItZyK2gzVrm8PaEWy3TgnlKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254638; c=relaxed/simple;
	bh=PwsfmWhMaeo3p9ZkxMCJdaezl1NW3MATUOtCcMOvSyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJOKxusIq8lN/sjk2REoLW37oRA1TKj31BJEGMk4weal6u21OrbmOxRWRqzzLSFP1lQKMkaUnLc31dqK39vqe35XRnIuKhjgXSbfPYj81cw1r1RL8dFaTuCHuOq9u8gpwRJW/tRbqVEfgP1UDMMeazL8eEpAfewJjYaPyQwSjKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHdlWOmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHdlWOmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28791F000C4;
	Sat, 17 Oct 2026 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254637;
	bh=cezJoaJJZRsXILfVs0Fi2f0IbyvaILEv7dRB23jOGOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHdlWOmbtVIExmOGKGRt/DRwIyO8PHM5R1Xow+66jxJDiOiul7M5rn8a27XbLbCxX
	 PhpiRH/A0A8gXcU7py6rX2HRHv6Pv+100i1tMgXxg4HSr8Zagvb0bazXFUMQuGqGHf
	 6Qe65gnyA38ZwgApkIJw2DFi9emrScQiR0hOfMmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 511/869] hwmon: (pmbus) Fix type confusion in notification logic
Date: Sat, 17 Oct 2026 17:55:52 +0200
Message-ID: <20261017160050.203677767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 59bd68ab05a8f9c9a60b6ec44682084184803ff4 ]

Sashiko reports:

At the start of the loop in pmbus_notify(), the code unconditionally casts
every attribute to a struct sensor_device_attribute:

drivers/hwmon/pmbus/pmbus_core.c:pmbus_notify() {
    for (i = 0; i < data->num_attributes; i++) {
        struct device_attribute *da = to_dev_attr(data->group.attrs[i]);
        struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
        int index = attr->index;
...
}

However, data->group.attrs can contain other types like struct
pmbus_samples_reg or struct pmbus_sensor, which only embed a base
struct device_attribute.

If da is a struct pmbus_samples_reg, dev_attr is the last member. Casting
it to struct sensor_device_attribute and reading the index field appears
to access memory past the end of the allocation, which might trigger a
slab-out-of-bounds read.

Additionally, if da is a struct pmbus_sensor, casting it causes the index
field to overlap with the page, phase, and reg fields. Could this produce
a garbage mask on little-endian systems that spuriously matches the target
reg, page, and flags during an alert?

Fix the problem by using struct sensor_device_attr in struct pmbus_sensor
and struct pmbus_label. Since those attributes never trigger a
notification, set the value of attr->index to -1 for them. Use this value
to distinguish from boolean attributes which _can_ trigger a notification
and use the index field to encode mask, page, and register values.

Fixes: f469bde9afd1 ("hwmon: (pmbus/core) Notify hwmon events")
Cc: Vincent Jardin <vjardin@free.fr>
Tested-by: Vincent Jardin <vjardin@free.fr>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 61 +++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 5061717389dbd..ea79cff0e8d0d 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -35,7 +35,7 @@
 struct pmbus_sensor {
 	struct pmbus_sensor *next;
 	char name[PMBUS_NAME_SIZE];	/* sysfs sensor name */
-	struct device_attribute attribute;
+	struct sensor_device_attribute attribute;
 	u8 page;		/* page number */
 	u8 phase;		/* phase number, 0xff for all phases */
 	u16 reg;		/* register */
@@ -58,7 +58,7 @@ struct pmbus_boolean {
 
 struct pmbus_label {
 	char name[PMBUS_NAME_SIZE];	/* sysfs label name */
-	struct device_attribute attribute;
+	struct sensor_device_attribute attribute;
 	char label[PMBUS_NAME_SIZE];	/* label */
 };
 #define to_pmbus_label(_attr) \
@@ -1238,7 +1238,8 @@ static ssize_t pmbus_show_sensor(struct device *dev,
 				 struct device_attribute *devattr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev->parent);
-	struct pmbus_sensor *sensor = to_pmbus_sensor(devattr);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct pmbus_sensor *sensor = to_pmbus_sensor(attr);
 	struct pmbus_data *data = i2c_get_clientdata(client);
 	ssize_t ret;
 
@@ -1258,7 +1259,8 @@ static ssize_t pmbus_set_sensor(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct pmbus_data *data = i2c_get_clientdata(client);
-	struct pmbus_sensor *sensor = to_pmbus_sensor(devattr);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct pmbus_sensor *sensor = to_pmbus_sensor(attr);
 	ssize_t rv = count;
 	s64 val;
 	int ret;
@@ -1281,7 +1283,8 @@ static ssize_t pmbus_set_sensor(struct device *dev,
 static ssize_t pmbus_show_label(struct device *dev,
 				struct device_attribute *da, char *buf)
 {
-	struct pmbus_label *label = to_pmbus_label(da);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
+	struct pmbus_label *label = to_pmbus_label(attr);
 
 	return sysfs_emit(buf, "%s\n", label->label);
 }
@@ -1434,8 +1437,8 @@ static struct pmbus_sensor *pmbus_add_sensor(struct pmbus_data *data,
 					     bool update, bool readonly,
 					     bool writeonly, bool convert)
 {
+	struct sensor_device_attribute *a;
 	struct pmbus_sensor *sensor;
-	struct device_attribute *a;
 
 	sensor = devm_kzalloc(data->dev, sizeof(*sensor), GFP_KERNEL);
 	if (!sensor)
@@ -1459,12 +1462,11 @@ static struct pmbus_sensor *pmbus_add_sensor(struct pmbus_data *data,
 	sensor->update = update;
 	sensor->convert = convert;
 	sensor->data = -ENODATA;
-	pmbus_dev_attr_init(a, sensor->name,
-			    readonly ? 0444 : 0644,
-			    writeonly ? pmbus_show_zero : pmbus_show_sensor,
-			    pmbus_set_sensor);
+	pmbus_attr_init(a, sensor->name, readonly ? 0444 : 0644,
+			writeonly ? pmbus_show_zero : pmbus_show_sensor,
+			pmbus_set_sensor, -1);
 
-	if (pmbus_add_attribute(data, &a->attr))
+	if (pmbus_add_attribute(data, &a->dev_attr.attr))
 		return NULL;
 
 	sensor->next = data->sensors;
@@ -1481,8 +1483,8 @@ static int pmbus_add_label(struct pmbus_data *data,
 			   const char *name, int seq,
 			   const char *lstring, int index, int phase)
 {
+	struct sensor_device_attribute *a;
 	struct pmbus_label *label;
-	struct device_attribute *a;
 
 	label = devm_kzalloc(data->dev, sizeof(*label), GFP_KERNEL);
 	if (!label)
@@ -1507,8 +1509,8 @@ static int pmbus_add_label(struct pmbus_data *data,
 				 lstring, index, phase);
 	}
 
-	pmbus_dev_attr_init(a, label->name, 0444, pmbus_show_label, NULL);
-	return pmbus_add_attribute(data, &a->attr);
+	pmbus_attr_init(a, label->name, 0444, pmbus_show_label, NULL, -1);
+	return pmbus_add_attribute(data, &a->dev_attr.attr);
 }
 
 /*
@@ -2396,7 +2398,7 @@ struct pmbus_samples_attr {
 struct pmbus_samples_reg {
 	int page;
 	struct pmbus_samples_attr *attr;
-	struct device_attribute dev_attr;
+	struct sensor_device_attribute attribute;
 };
 
 static struct pmbus_samples_attr pmbus_samples_registers[] = {
@@ -2418,14 +2420,15 @@ static struct pmbus_samples_attr pmbus_samples_registers[] = {
 	}
 };
 
-#define to_samples_reg(x) container_of(x, struct pmbus_samples_reg, dev_attr)
+#define to_samples_reg(x) container_of(x, struct pmbus_samples_reg, attribute)
 
 static ssize_t pmbus_show_samples(struct device *dev,
 				  struct device_attribute *devattr, char *buf)
 {
 	int val;
 	struct i2c_client *client = to_i2c_client(dev->parent);
-	struct pmbus_samples_reg *reg = to_samples_reg(devattr);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct pmbus_samples_reg *reg = to_samples_reg(attr);
 	struct pmbus_data *data = i2c_get_clientdata(client);
 
 	mutex_lock(&data->update_lock);
@@ -2444,7 +2447,8 @@ static ssize_t pmbus_set_samples(struct device *dev,
 	int ret;
 	long val;
 	struct i2c_client *client = to_i2c_client(dev->parent);
-	struct pmbus_samples_reg *reg = to_samples_reg(devattr);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct pmbus_samples_reg *reg = to_samples_reg(attr);
 	struct pmbus_data *data = i2c_get_clientdata(client);
 
 	if (kstrtol(buf, 0, &val) < 0)
@@ -2460,6 +2464,7 @@ static ssize_t pmbus_set_samples(struct device *dev,
 static int pmbus_add_samples_attr(struct pmbus_data *data, int page,
 				  struct pmbus_samples_attr *attr)
 {
+	struct sensor_device_attribute *a;
 	struct pmbus_samples_reg *reg;
 
 	reg = devm_kzalloc(data->dev, sizeof(*reg), GFP_KERNEL);
@@ -2469,10 +2474,12 @@ static int pmbus_add_samples_attr(struct pmbus_data *data, int page,
 	reg->attr = attr;
 	reg->page = page;
 
-	pmbus_dev_attr_init(&reg->dev_attr, attr->name, 0644,
-			    pmbus_show_samples, pmbus_set_samples);
+	a = &reg->attribute;
+
+	pmbus_attr_init(a, attr->name, 0644,
+			pmbus_show_samples, pmbus_set_samples, -1);
 
-	return pmbus_add_attribute(data, &reg->dev_attr.attr);
+	return pmbus_add_attribute(data, &a->dev_attr.attr);
 }
 
 static int pmbus_add_samples_attributes(struct i2c_client *client,
@@ -2941,9 +2948,15 @@ static void pmbus_notify(struct pmbus_data *data, int page, int reg, int flags)
 		struct device_attribute *da = to_dev_attr(data->group.attrs[i]);
 		struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 		int index = attr->index;
-		u16 smask = pb_index_to_mask(index);
-		u8 spage = pb_index_to_page(index);
-		u16 sreg = pb_index_to_reg(index);
+		u16 smask, sreg;
+		u8 spage;
+
+		if (index == -1)
+			continue;
+
+		smask = pb_index_to_mask(index);
+		spage = pb_index_to_page(index);
+		sreg = pb_index_to_reg(index);
 
 		if (reg == sreg && page == spage && (smask & flags)) {
 			dev_dbg(data->dev, "sysfs notify: %s", da->attr.name);
-- 
2.53.0



