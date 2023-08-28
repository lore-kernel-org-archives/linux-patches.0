Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A32469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D49AC433C8;
	Mon, 28 Aug 2023 10:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218822;
	bh=K5xee8rZrpG7HffUO5LyQiUjupcTWF3qI89FOWc+ppU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbSa7xTbFAvkUcWbhJj3lMSmZReUKyFfANP4qqBbGadSvGpxPUdpxJhvkZAS928hB
	 RVuSEWMc/QOafY5adOCizixHIzgMB5XeS3yRT0aUZTByAdHZG3rfMoR7oODznBOXUh
	 hwBcVoG58mUW9YR/wqqKMI66QjrsW6qisjEQO+jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 097/122] hwmon: (aquacomputer_d5next) Add selective 200ms delay after sending ctrl report
Date: Mon, 28 Aug 2023 12:13:32 +0200
Message-ID: <20230828101159.627544601@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Savic <savicaleksa83@gmail.com>

commit 56b930dcd88c2adc261410501c402c790980bdb5 upstream.

Add a 200ms delay after sending a ctrl report to Quadro,
Octo, D5 Next and Aquaero to give them enough time to
process the request and save the data to memory. Otherwise,
under heavier userspace loads where multiple sysfs entries
are usually set in quick succession, a new ctrl report could
be requested from the device while it's still processing the
previous one and fail with -EPIPE. The delay is only applied
if two ctrl report operations are near each other in time.

Reported by a user on Github [1] and tested by both of us.

[1] https://github.com/aleksamagicka/aquacomputer_d5next-hwmon/issues/82

Fixes: 752b927951ea ("hwmon: (aquacomputer_d5next) Add support for Aquacomputer Octo")
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Link: https://lore.kernel.org/r/20230807172004.456968-1-savicaleksa83@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ removed Aquaero support as it's not in 6.1 ]
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/aquacomputer_d5next.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -12,9 +12,11 @@
 
 #include <linux/crc16.h>
 #include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/hid.h>
 #include <linux/hwmon.h>
 #include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
@@ -49,6 +51,8 @@ static const char *const aqc_device_name
 
 #define CTRL_REPORT_ID			0x03
 
+#define CTRL_REPORT_DELAY		200	/* ms */
+
 /* The HID report that the official software always sends
  * after writing values, currently same for all devices
  */
@@ -269,6 +273,9 @@ struct aqc_data {
 	enum kinds kind;
 	const char *name;
 
+	ktime_t last_ctrl_report_op;
+	int ctrl_report_delay;	/* Delay between two ctrl report operations, in ms */
+
 	int buffer_size;
 	u8 *buffer;
 	int checksum_start;
@@ -325,17 +332,35 @@ static int aqc_pwm_to_percent(long val)
 	return DIV_ROUND_CLOSEST(val * 100 * 100, 255);
 }
 
+static void aqc_delay_ctrl_report(struct aqc_data *priv)
+{
+	/*
+	 * If previous read or write is too close to this one, delay the current operation
+	 * to give the device enough time to process the previous one.
+	 */
+	if (priv->ctrl_report_delay) {
+		s64 delta = ktime_ms_delta(ktime_get(), priv->last_ctrl_report_op);
+
+		if (delta < priv->ctrl_report_delay)
+			msleep(priv->ctrl_report_delay - delta);
+	}
+}
+
 /* Expects the mutex to be locked */
 static int aqc_get_ctrl_data(struct aqc_data *priv)
 {
 	int ret;
 
+	aqc_delay_ctrl_report(priv);
+
 	memset(priv->buffer, 0x00, priv->buffer_size);
 	ret = hid_hw_raw_request(priv->hdev, CTRL_REPORT_ID, priv->buffer, priv->buffer_size,
 				 HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
 	if (ret < 0)
 		ret = -ENODATA;
 
+	priv->last_ctrl_report_op = ktime_get();
+
 	return ret;
 }
 
@@ -345,6 +370,8 @@ static int aqc_send_ctrl_data(struct aqc
 	int ret;
 	u16 checksum;
 
+	aqc_delay_ctrl_report(priv);
+
 	/* Init and xorout value for CRC-16/USB is 0xffff */
 	checksum = crc16(0xffff, priv->buffer + priv->checksum_start, priv->checksum_length);
 	checksum ^= 0xffff;
@@ -356,12 +383,16 @@ static int aqc_send_ctrl_data(struct aqc
 	ret = hid_hw_raw_request(priv->hdev, CTRL_REPORT_ID, priv->buffer, priv->buffer_size,
 				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 	if (ret < 0)
-		return ret;
+		goto record_access_and_ret;
 
 	/* The official software sends this report after every change, so do it here as well */
 	ret = hid_hw_raw_request(priv->hdev, SECONDARY_CTRL_REPORT_ID, secondary_ctrl_report,
 				 SECONDARY_CTRL_REPORT_SIZE, HID_FEATURE_REPORT,
 				 HID_REQ_SET_REPORT);
+
+record_access_and_ret:
+	priv->last_ctrl_report_op = ktime_get();
+
 	return ret;
 }
 
@@ -853,6 +884,7 @@ static int aqc_probe(struct hid_device *
 		priv->virtual_temp_sensor_start_offset = D5NEXT_VIRTUAL_SENSORS_START;
 		priv->power_cycle_count_offset = D5NEXT_POWER_CYCLES;
 		priv->buffer_size = D5NEXT_CTRL_REPORT_SIZE;
+		priv->ctrl_report_delay = CTRL_REPORT_DELAY;
 
 		priv->temp_label = label_d5next_temp;
 		priv->virtual_temp_label = label_virtual_temp_sensors;
@@ -893,6 +925,7 @@ static int aqc_probe(struct hid_device *
 		priv->virtual_temp_sensor_start_offset = OCTO_VIRTUAL_SENSORS_START;
 		priv->power_cycle_count_offset = OCTO_POWER_CYCLES;
 		priv->buffer_size = OCTO_CTRL_REPORT_SIZE;
+		priv->ctrl_report_delay = CTRL_REPORT_DELAY;
 
 		priv->temp_label = label_temp_sensors;
 		priv->virtual_temp_label = label_virtual_temp_sensors;
@@ -913,6 +946,7 @@ static int aqc_probe(struct hid_device *
 		priv->virtual_temp_sensor_start_offset = QUADRO_VIRTUAL_SENSORS_START;
 		priv->power_cycle_count_offset = QUADRO_POWER_CYCLES;
 		priv->buffer_size = QUADRO_CTRL_REPORT_SIZE;
+		priv->ctrl_report_delay = CTRL_REPORT_DELAY;
 		priv->flow_sensor_offset = QUADRO_FLOW_SENSOR_OFFSET;
 
 		priv->temp_label = label_temp_sensors;


