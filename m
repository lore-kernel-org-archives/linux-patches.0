Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C946A440A16;
	Wed, 23 Sep 2026 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175076; cv=none; b=B+B7hhPqt8szVsuFcQggb/Z/wmJEZ1dKwLT3r6Ru3E7dsv+B+M8H+bRSpwI+J1J+yQnqrq2LQhZ6G1UxYjOqZ1VtYMOYjT5Id2AzfNaIrHrpKZrG1M6IQlRFEa7o1GX0jwymav+7K+d73PA+Td1/zuj8R/Xwvfa3cmhbBi+pxik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175076; c=relaxed/simple;
	bh=A0UZGaS5FADNVlzt+fWr5+uaHAqafIYv7BW/+o3kDXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYljCMWneaxXOYSsCYpUB9IszUFOqILASlQ9m3aEXMBy11TtjymMmUJuPoOtbBgBNa7wjAFM52RPTS7PXJtGSylr63Zkb0Hq0jAf3zRoGgSzkv7uo4T8+ABs/StmtB+5KmGcpMalv72GAtSCQxtgohPizdcZBIJfipn1e18UejQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqXhJTuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqXhJTuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276341F000FF;
	Wed, 23 Sep 2026 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175074;
	bh=3n2WDqZhz4NQQRlzWxHs+wc89ODOYv4DKv8/oDfJ6P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqXhJTuSIE76XxLBUVFIviVhTihIAaBZwgKgyQlix5kaWslWJk69+ZzanSn8TXn0j
	 24Knk6VFjOwsmfyXQ4ZJje1Bk8dghbYCmMUjzCvKcfZo4zmwIuonGDR3ne8VidrB0j
	 H06OyPprea1Lp94Iko00zbEQWDCZQua2O6NwZ6Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Thomas Richard (congatec GmbH)" <thomas.richard@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 313/398] hwmon: (cgbc-hwmon) Fix current sensors ID lookup
Date: Wed, 23 Sep 2026 16:06:27 +0200
Message-ID: <20260923140651.538025241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Thomas Richard (congatec GmbH) <thomas.richard@bootlin.com>

commit 7bae83ffb133bc373d098fa6828cef2ef4da49fe upstream.

Current sensors on the Congatec Board Controller don't use consecutive IDs,
unlike other sensor types (voltage, temperature, fan). The driver assumed
consecutive IDs and performed a simple lookup, which caused an unknown
sensor warning. Define current sensor IDs explicitly.

Changes the warning on conga-SA7 (type and channel are correct now).
Before:
  Board Controller returned an unknown sensor (type=2, channel=17), ignore it
After:
  Board Controller returned an unknown sensor (bc_type=1, bc_id=11), ignore it

Cc: stable@kernel.org
Fixes: 08ebc9def79f ("hwmon: Add Congatec Board Controller monitoring driver")
Signed-off-by: Thomas Richard (congatec GmbH) <thomas.richard@bootlin.com>
Link: https://patch.msgid.link/20260911-cgbc-hwmon-fix-and-new-sensors-v2-1-0c6bf078d173@bootlin.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/cgbc-hwmon.c |   93 ++++++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 39 deletions(-)

--- a/drivers/hwmon/cgbc-hwmon.c
+++ b/drivers/hwmon/cgbc-hwmon.c
@@ -52,31 +52,36 @@ static const char * const cgbc_hwmon_lab
 	"BOTTOMDIM Temperature",
 };
 
+static const char * const cgbc_hwmon_labels_in[] = {
+	"CPU Voltage",
+	"DC Runtime Voltage",
+	"DC Standby Voltage",
+	"CMOS Battery Voltage",
+	"Battery Voltage",
+	"AC Voltage",
+	"Other Voltage",
+	"5V Voltage",
+	"5V Standby Voltage",
+	"3V3 Voltage",
+	"3V3 Standby Voltage",
+	"VCore A Voltage",
+	"VCore B Voltage",
+	"12V Voltage",
+};
+
+/*
+ * Current sensors are a bit special, they don't have consecutive IDs like
+ * other types of sensors. So they need to be defined explicitly.
+ */
 static const struct {
-	enum hwmon_sensor_types type;
 	const char *label;
-} cgbc_hwmon_labels_in[] = {
-	{ hwmon_in, "CPU Voltage" },
-	{ hwmon_in, "DC Runtime Voltage" },
-	{ hwmon_in, "DC Standby Voltage" },
-	{ hwmon_in, "CMOS Battery Voltage" },
-	{ hwmon_in, "Battery Voltage" },
-	{ hwmon_in, "AC Voltage" },
-	{ hwmon_in, "Other Voltage" },
-	{ hwmon_in, "5V Voltage" },
-	{ hwmon_in, "5V Standby Voltage" },
-	{ hwmon_in, "3V3 Voltage" },
-	{ hwmon_in, "3V3 Standby Voltage" },
-	{ hwmon_in, "VCore A Voltage" },
-	{ hwmon_in, "VCore B Voltage" },
-	{ hwmon_in, "12V Voltage" },
-	{ hwmon_curr, "DC Current" },
-	{ hwmon_curr, "5V Current" },
-	{ hwmon_curr, "12V Current" },
+	int id;
+} cgbc_hwmon_labels_curr[] = {
+	{ "DC Current", 0x12 },
+	{ "5V Current", 0x18 },
+	{ "12V Current", 0x1E },
 };
 
-#define CGBC_HWMON_NB_IN_SENSORS	14
-
 static const char * const cgbc_hwmon_labels_fan[] = {
 	"CPU Fan",
 	"Box Fan",
@@ -114,7 +119,8 @@ static int cgbc_hwmon_probe_sensors(stru
 
 	for (i = 0; i < nb_sensors; i++) {
 		enum cgbc_sensor_types type;
-		unsigned int channel;
+		unsigned int channel, id;
+		int j;
 
 		/*
 		 * No need to request data for the first sensor.
@@ -128,32 +134,49 @@ static int cgbc_hwmon_probe_sensors(stru
 		}
 
 		type = FIELD_GET(CGBC_HWMON_TYPE_MASK, data[1]);
-		channel = FIELD_GET(CGBC_HWMON_ID_MASK, data[1]) - 1;
+		id = FIELD_GET(CGBC_HWMON_ID_MASK, data[1]);
+		channel = id - 1;
 
 		if (type == CGBC_HWMON_TYPE_TEMP && channel < ARRAY_SIZE(cgbc_hwmon_labels_temp)) {
 			sensor->type = hwmon_temp;
 			sensor->label = cgbc_hwmon_labels_temp[channel];
-		} else if (type == CGBC_HWMON_TYPE_IN &&
-			   channel < ARRAY_SIZE(cgbc_hwmon_labels_in)) {
+		} else if (type == CGBC_HWMON_TYPE_IN) {
 			/*
 			 * The Board Controller doesn't differentiate current and voltage sensors.
-			 * Get the sensor type from cgbc_hwmon_labels_in[channel].type instead.
+			 * First check if it is a current sensor.
 			 */
-			sensor->type = cgbc_hwmon_labels_in[channel].type;
-			sensor->label = cgbc_hwmon_labels_in[channel].label;
+			for (j = 0; j < ARRAY_SIZE(cgbc_hwmon_labels_curr); j++) {
+				if (id == cgbc_hwmon_labels_curr[j].id) {
+					sensor->type = hwmon_curr;
+					sensor->label = cgbc_hwmon_labels_curr[j].label;
+					channel = j;
+				}
+			}
+
+			/* If it's not a current sensor, it may be a voltage sensor. */
+			if (!sensor->label && channel < ARRAY_SIZE(cgbc_hwmon_labels_in)) {
+				sensor->type = hwmon_in;
+				sensor->label = cgbc_hwmon_labels_in[channel];
+			}
 		} else if (type == CGBC_HWMON_TYPE_FAN &&
 			   channel < ARRAY_SIZE(cgbc_hwmon_labels_fan)) {
 			sensor->type = hwmon_fan;
 			sensor->label = cgbc_hwmon_labels_fan[channel];
-		} else {
-			dev_warn(dev, "Board Controller returned an unknown sensor (type=%d, channel=%d), ignore it",
-				 type, channel);
+		}
+
+		if (!sensor->label) {
+			dev_warn(dev, "Board Controller returned an unknown sensor (bc_type=%d, bc_id=%d), ignore it",
+				 type, id);
 			continue;
 		}
 
 		sensor->active = FIELD_GET(CGBC_HWMON_ACTIVE_BIT, data[1]);
 		sensor->channel = channel;
 		sensor->index = i;
+
+		dev_dbg(dev, "Found sensor: bc_type=%d, bc_id=%d, hwmon_type=%d, hwmon_channel=%d, hwmon_label='%s', active=%d\n",
+			type, id, sensor->type, sensor->channel, sensor->label, sensor->active);
+
 		sensor++;
 		hwmon->nb_sensors++;
 	}
@@ -167,14 +190,6 @@ static struct cgbc_hwmon_sensor *cgbc_hw
 	struct cgbc_hwmon_sensor *sensor = NULL;
 	int i;
 
-	/*
-	 * The Board Controller doesn't differentiate current and voltage sensors.
-	 * The channel value (from the Board Controller point of view) shall be computed for current
-	 * sensors.
-	 */
-	if (type == hwmon_curr)
-		channel += CGBC_HWMON_NB_IN_SENSORS;
-
 	for (i = 0; i < hwmon->nb_sensors; i++) {
 		if (hwmon->sensors[i].type == type && hwmon->sensors[i].channel == channel) {
 			sensor = &hwmon->sensors[i];


