Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1160C14263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoeDsu7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ECCC433C7;
	Mon, 23 Oct 2023 11:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059324;
	bh=lpxY9B7KJkEOJ1a6f0nC2SXp4BJ+3rEMRZNgjnfvRMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoeDsu7Bzo2ZkVjMxGkIbkyxlV3LZknTjLSesjWKvD9uWWG+6PI7HpJbP6Z3paz5a
	 1kuS6eaCW4k39lqFYv/TPEZ9N6Ee/E65Phy1G6HZuSax5PHaRAvpJl0KESgpD89MMs
	 iYfyOApYUKimYAHKO+s5mhWbPlOfzKPoaROOeAWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Fontana <tinozzo123@gmail.com>,
	"Daniel J. Ogorchock" <djogorchock@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 139/241] HID: nintendo: reinitialize USB Pro Controller after resuming from suspend
Date: Mon, 23 Oct 2023 12:55:25 +0200
Message-ID: <20231023104837.253291685@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martino Fontana <tinozzo123@gmail.com>

[ Upstream commit 95ea4d9fd385fe335b989f22d409df079a042b7a ]

When suspending the computer, a Switch Pro Controller connected via USB will
lose its internal status. However, because the USB connection was technically
never lost, when resuming the computer, the driver will attempt to communicate
with the controller as if nothing happened (and fail).
Because of this, the user was forced to manually disconnect the controller
(or to press the sync button on the controller to power it off), so that it
can be re-initialized.

With this patch, the controller will be automatically re-initialized after
resuming from suspend.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216233

Signed-off-by: Martino Fontana <tinozzo123@gmail.com>
Reviewed-by: Daniel J. Ogorchock <djogorchock@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 175 ++++++++++++++++++++++---------------
 1 file changed, 103 insertions(+), 72 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 250f5d2f888ab..10468f727e5bb 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -2088,7 +2088,9 @@ static int joycon_read_info(struct joycon_ctlr *ctlr)
 	struct joycon_input_report *report;
 
 	req.subcmd_id = JC_SUBCMD_REQ_DEV_INFO;
+	mutex_lock(&ctlr->output_mutex);
 	ret = joycon_send_subcmd(ctlr, &req, 0, HZ);
+	mutex_unlock(&ctlr->output_mutex);
 	if (ret) {
 		hid_err(ctlr->hdev, "Failed to get joycon info; ret=%d\n", ret);
 		return ret;
@@ -2117,6 +2119,85 @@ static int joycon_read_info(struct joycon_ctlr *ctlr)
 	return 0;
 }
 
+static int joycon_init(struct hid_device *hdev)
+{
+	struct joycon_ctlr *ctlr = hid_get_drvdata(hdev);
+	int ret = 0;
+
+	mutex_lock(&ctlr->output_mutex);
+	/* if handshake command fails, assume ble pro controller */
+	if ((jc_type_is_procon(ctlr) || jc_type_is_chrggrip(ctlr)) &&
+	    !joycon_send_usb(ctlr, JC_USB_CMD_HANDSHAKE, HZ)) {
+		hid_dbg(hdev, "detected USB controller\n");
+		/* set baudrate for improved latency */
+		ret = joycon_send_usb(ctlr, JC_USB_CMD_BAUDRATE_3M, HZ);
+		if (ret) {
+			hid_err(hdev, "Failed to set baudrate; ret=%d\n", ret);
+			goto out_unlock;
+		}
+		/* handshake */
+		ret = joycon_send_usb(ctlr, JC_USB_CMD_HANDSHAKE, HZ);
+		if (ret) {
+			hid_err(hdev, "Failed handshake; ret=%d\n", ret);
+			goto out_unlock;
+		}
+		/*
+		 * Set no timeout (to keep controller in USB mode).
+		 * This doesn't send a response, so ignore the timeout.
+		 */
+		joycon_send_usb(ctlr, JC_USB_CMD_NO_TIMEOUT, HZ/10);
+	} else if (jc_type_is_chrggrip(ctlr)) {
+		hid_err(hdev, "Failed charging grip handshake\n");
+		ret = -ETIMEDOUT;
+		goto out_unlock;
+	}
+
+	/* get controller calibration data, and parse it */
+	ret = joycon_request_calibration(ctlr);
+	if (ret) {
+		/*
+		 * We can function with default calibration, but it may be
+		 * inaccurate. Provide a warning, and continue on.
+		 */
+		hid_warn(hdev, "Analog stick positions may be inaccurate\n");
+	}
+
+	/* get IMU calibration data, and parse it */
+	ret = joycon_request_imu_calibration(ctlr);
+	if (ret) {
+		/*
+		 * We can function with default calibration, but it may be
+		 * inaccurate. Provide a warning, and continue on.
+		 */
+		hid_warn(hdev, "Unable to read IMU calibration data\n");
+	}
+
+	/* Set the reporting mode to 0x30, which is the full report mode */
+	ret = joycon_set_report_mode(ctlr);
+	if (ret) {
+		hid_err(hdev, "Failed to set report mode; ret=%d\n", ret);
+		goto out_unlock;
+	}
+
+	/* Enable rumble */
+	ret = joycon_enable_rumble(ctlr);
+	if (ret) {
+		hid_err(hdev, "Failed to enable rumble; ret=%d\n", ret);
+		goto out_unlock;
+	}
+
+	/* Enable the IMU */
+	ret = joycon_enable_imu(ctlr);
+	if (ret) {
+		hid_err(hdev, "Failed to enable the IMU; ret=%d\n", ret);
+		goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&ctlr->output_mutex);
+	return ret;
+}
+
 /* Common handler for parsing inputs */
 static int joycon_ctlr_read_handler(struct joycon_ctlr *ctlr, u8 *data,
 							      int size)
@@ -2248,85 +2329,19 @@ static int nintendo_hid_probe(struct hid_device *hdev,
 
 	hid_device_io_start(hdev);
 
-	/* Initialize the controller */
-	mutex_lock(&ctlr->output_mutex);
-	/* if handshake command fails, assume ble pro controller */
-	if ((jc_type_is_procon(ctlr) || jc_type_is_chrggrip(ctlr)) &&
-	    !joycon_send_usb(ctlr, JC_USB_CMD_HANDSHAKE, HZ)) {
-		hid_dbg(hdev, "detected USB controller\n");
-		/* set baudrate for improved latency */
-		ret = joycon_send_usb(ctlr, JC_USB_CMD_BAUDRATE_3M, HZ);
-		if (ret) {
-			hid_err(hdev, "Failed to set baudrate; ret=%d\n", ret);
-			goto err_mutex;
-		}
-		/* handshake */
-		ret = joycon_send_usb(ctlr, JC_USB_CMD_HANDSHAKE, HZ);
-		if (ret) {
-			hid_err(hdev, "Failed handshake; ret=%d\n", ret);
-			goto err_mutex;
-		}
-		/*
-		 * Set no timeout (to keep controller in USB mode).
-		 * This doesn't send a response, so ignore the timeout.
-		 */
-		joycon_send_usb(ctlr, JC_USB_CMD_NO_TIMEOUT, HZ/10);
-	} else if (jc_type_is_chrggrip(ctlr)) {
-		hid_err(hdev, "Failed charging grip handshake\n");
-		ret = -ETIMEDOUT;
-		goto err_mutex;
-	}
-
-	/* get controller calibration data, and parse it */
-	ret = joycon_request_calibration(ctlr);
+	ret = joycon_init(hdev);
 	if (ret) {
-		/*
-		 * We can function with default calibration, but it may be
-		 * inaccurate. Provide a warning, and continue on.
-		 */
-		hid_warn(hdev, "Analog stick positions may be inaccurate\n");
-	}
-
-	/* get IMU calibration data, and parse it */
-	ret = joycon_request_imu_calibration(ctlr);
-	if (ret) {
-		/*
-		 * We can function with default calibration, but it may be
-		 * inaccurate. Provide a warning, and continue on.
-		 */
-		hid_warn(hdev, "Unable to read IMU calibration data\n");
-	}
-
-	/* Set the reporting mode to 0x30, which is the full report mode */
-	ret = joycon_set_report_mode(ctlr);
-	if (ret) {
-		hid_err(hdev, "Failed to set report mode; ret=%d\n", ret);
-		goto err_mutex;
-	}
-
-	/* Enable rumble */
-	ret = joycon_enable_rumble(ctlr);
-	if (ret) {
-		hid_err(hdev, "Failed to enable rumble; ret=%d\n", ret);
-		goto err_mutex;
-	}
-
-	/* Enable the IMU */
-	ret = joycon_enable_imu(ctlr);
-	if (ret) {
-		hid_err(hdev, "Failed to enable the IMU; ret=%d\n", ret);
-		goto err_mutex;
+		hid_err(hdev, "Failed to initialize controller; ret=%d\n", ret);
+		goto err_close;
 	}
 
 	ret = joycon_read_info(ctlr);
 	if (ret) {
 		hid_err(hdev, "Failed to retrieve controller info; ret=%d\n",
 			ret);
-		goto err_mutex;
+		goto err_close;
 	}
 
-	mutex_unlock(&ctlr->output_mutex);
-
 	/* Initialize the leds */
 	ret = joycon_leds_create(ctlr);
 	if (ret) {
@@ -2352,8 +2367,6 @@ static int nintendo_hid_probe(struct hid_device *hdev,
 	hid_dbg(hdev, "probe - success\n");
 	return 0;
 
-err_mutex:
-	mutex_unlock(&ctlr->output_mutex);
 err_close:
 	hid_hw_close(hdev);
 err_stop:
@@ -2383,6 +2396,20 @@ static void nintendo_hid_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 }
 
+#ifdef CONFIG_PM
+
+static int nintendo_hid_resume(struct hid_device *hdev)
+{
+	int ret = joycon_init(hdev);
+
+	if (ret)
+		hid_err(hdev, "Failed to restore controller after resume");
+
+	return ret;
+}
+
+#endif
+
 static const struct hid_device_id nintendo_hid_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NINTENDO,
 			 USB_DEVICE_ID_NINTENDO_PROCON) },
@@ -2404,6 +2431,10 @@ static struct hid_driver nintendo_hid_driver = {
 	.probe		= nintendo_hid_probe,
 	.remove		= nintendo_hid_remove,
 	.raw_event	= nintendo_hid_event,
+
+#ifdef CONFIG_PM
+	.resume		= nintendo_hid_resume,
+#endif
 };
 module_hid_driver(nintendo_hid_driver);
 
-- 
2.40.1



