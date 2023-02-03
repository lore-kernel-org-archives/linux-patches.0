Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4C61FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20F0C4339B;
	Fri,  3 Feb 2023 10:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419849;
	bh=FcTV8jsLLGGcPAnVa/CJ/Aog1C5dMMbIq5g6SMp1UnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYihssFVuWxvp25Ko8usMs5Z+oZHJB1ThRxRLFbkqlYduDAIsPEo31vt7RNXIM+SY
	 yFJRSNaWaiAupLPna/ngyODaGx/2FUyL3s8Ym8UzAF3U5lSSZuKxpbpbk2aN0AVSZE
	 Z/jQB8ktqVtgK4qKLEpPRyXqKsRdOgk9FtkjjMts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roderick Colenbrander <roderick.colenbrander@sony.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/20] HID: playstation: sanity check DualSense calibration data.
Date: Fri,  3 Feb 2023 11:13:36 +0100
Message-Id: <20230203101008.395104293@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roderick Colenbrander <roderick@gaikai.com>

[ Upstream commit ccf1e1626d37745d0a697db67407beec9ae9d4b8 ]

Make sure calibration values are defined to prevent potential kernel
crashes. This fixes a hypothetical issue for virtual or clone devices
inspired by a similar fix for DS4.

Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-playstation.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index bd0e0fe2f627..944e5e5ff134 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -626,6 +626,7 @@ static const struct attribute_group ps_device_attribute_group = {
 
 static int dualsense_get_calibration_data(struct dualsense *ds)
 {
+	struct hid_device *hdev = ds->base.hdev;
 	short gyro_pitch_bias, gyro_pitch_plus, gyro_pitch_minus;
 	short gyro_yaw_bias, gyro_yaw_plus, gyro_yaw_minus;
 	short gyro_roll_bias, gyro_roll_plus, gyro_roll_minus;
@@ -636,6 +637,7 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	int speed_2x;
 	int range_2g;
 	int ret = 0;
+	int i;
 	uint8_t *buf;
 
 	buf = kzalloc(DS_FEATURE_REPORT_CALIBRATION_SIZE, GFP_KERNEL);
@@ -687,6 +689,21 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	ds->gyro_calib_data[2].sens_numer = speed_2x*DS_GYRO_RES_PER_DEG_S;
 	ds->gyro_calib_data[2].sens_denom = gyro_roll_plus - gyro_roll_minus;
 
+	/*
+	 * Sanity check gyro calibration data. This is needed to prevent crashes
+	 * during report handling of virtual, clone or broken devices not implementing
+	 * calibration data properly.
+	 */
+	for (i = 0; i < ARRAY_SIZE(ds->gyro_calib_data); i++) {
+		if (ds->gyro_calib_data[i].sens_denom == 0) {
+			hid_warn(hdev, "Invalid gyro calibration data for axis (%d), disabling calibration.",
+					ds->gyro_calib_data[i].abs_code);
+			ds->gyro_calib_data[i].bias = 0;
+			ds->gyro_calib_data[i].sens_numer = DS_GYRO_RANGE;
+			ds->gyro_calib_data[i].sens_denom = S16_MAX;
+		}
+	}
+
 	/*
 	 * Set accelerometer calibration and normalization parameters.
 	 * Data values will be normalized to 1/DS_ACC_RES_PER_G g.
@@ -709,6 +726,21 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	ds->accel_calib_data[2].sens_numer = 2*DS_ACC_RES_PER_G;
 	ds->accel_calib_data[2].sens_denom = range_2g;
 
+	/*
+	 * Sanity check accelerometer calibration data. This is needed to prevent crashes
+	 * during report handling of virtual, clone or broken devices not implementing calibration
+	 * data properly.
+	 */
+	for (i = 0; i < ARRAY_SIZE(ds->accel_calib_data); i++) {
+		if (ds->accel_calib_data[i].sens_denom == 0) {
+			hid_warn(hdev, "Invalid accelerometer calibration data for axis (%d), disabling calibration.",
+					ds->accel_calib_data[i].abs_code);
+			ds->accel_calib_data[i].bias = 0;
+			ds->accel_calib_data[i].sens_numer = DS_ACC_RANGE;
+			ds->accel_calib_data[i].sens_denom = S16_MAX;
+		}
+	}
+
 err_free:
 	kfree(buf);
 	return ret;
-- 
2.39.0



