Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF88551DAEC;
	Wed, 23 Sep 2026 14:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174005; cv=none; b=M0C9RIQysJSvd6ox7lrAsNj78FmXCLmFJUtqIOug0B+ydiC550VMtZe/VSyL1UR9jpaKvLR68im2sPkdQOVCzV6tiX1SMDTpM9zR2J5i0sfk6wLdjN/eFDUaQ5TelyHApjsEqn/pX/ZXxr8jbZoPh5QNy1XMLeRVRszRK9Cwo1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174005; c=relaxed/simple;
	bh=Mbs7A2PFHaRpTYGhuKaryspNR1A0gwqV2o9gOJPHDl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKJn/j/63gVNzBcIt2xNhSN5nwwzkSUHRpMC+Hpv8u6oQAX2AHtYG2jBqCgb1vgCEnSw/gKWeorgfEU9Q3VUHRel1gik3rulFX18Y/WAh1HP1AOuKS8t+ZqpL1mUeI/V5zJr42sBpHRw5AdkpgzUdnp5F7Q8yomf2R2TnmQl+y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Okq8Ecca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Okq8Ecca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8701F000FF;
	Wed, 23 Sep 2026 14:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174003;
	bh=Pq6E+r3y1FcZN07S8CwaiQZ2hylNxX41u+vFaXAs+LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Okq8Ecca5CvgKRivUwcNw7Q5VMGHF8GFXA9CZtLtabZjy9fmunHc1tQ4799VuqtUZ
	 Ehm2QH91qlbWkmCZEImI6aGAz0OtOolcRC8X5t9vZ4nstwz+T+Ne3rLn6zLlal4HPj
	 zd8PHZ7gpdIaSrDwTPl/arIfZrQxOSssLOigGKKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Thomas Richard (congatec GmbH)" <thomas.richard@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 372/438] hwmon: (cgbc-hwmon) Fix current sensors ID lookup
Date: Wed, 23 Sep 2026 16:06:33 +0200
Message-ID: <20260923140654.505533577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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


