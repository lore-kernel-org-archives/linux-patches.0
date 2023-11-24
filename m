Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4482FC4E;
	Fri, 24 Nov 2023 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njOFZzNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEE6C433C8;
	Fri, 24 Nov 2023 18:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852152;
	bh=cXsO14c5i0cJiR7eoJbyakqo5X7bZQVA2zsg71kqkqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njOFZzNb4eFtj6Be2v0CBrAvqPutrx4JcIIsG17aMjk8wNGt6N1LeAyjT1XXOvVPv
	 7s0TKpYgQA1Xx1LJgpPW5TJhl0fvVVfDn7ny3QzZsBBGuADok8kqJdSnpMk4SU+otz
	 gVA/oMutvzpLgLx6x6qntnfxOnQSyPJjrVADn8Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Lentin <jm@lentin.co.uk>,
	Martin Kepplinger <martink@posteo.de>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 240/372] hid: lenovo: Resend all settings on reset_resume for compact keyboards
Date: Fri, 24 Nov 2023 17:50:27 +0000
Message-ID: <20231124172018.523069224@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Jamie Lentin <jm@lentin.co.uk>

commit 2f2bd7cbd1d1548137b351040dc4e037d18cdfdc upstream.

The USB Compact Keyboard variant requires a reset_resume function to
restore keyboard configuration after a suspend in some situations. Move
configuration normally done on probe to lenovo_features_set_cptkbd(), then
recycle this for use on reset_resume.

Without, the keyboard and driver would end up in an inconsistent state,
breaking middle-button scrolling amongst other problems, and twiddling
sysfs values wouldn't help as the middle-button mode won't be set until
the driver is reloaded.

Tested on a USB and Bluetooth Thinkpad Compact Keyboard.

CC: stable@vger.kernel.org
Fixes: 94eefa271323 ("HID: lenovo: Use native middle-button mode for compact keyboards")
Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Link: https://lore.kernel.org/r/20231002150914.22101-1-martink@posteo.de
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo.c |   50 +++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -526,6 +526,19 @@ static void lenovo_features_set_cptkbd(s
 	int ret;
 	struct lenovo_drvdata *cptkbd_data = hid_get_drvdata(hdev);
 
+	/*
+	 * Tell the keyboard a driver understands it, and turn F7, F9, F11 into
+	 * regular keys
+	 */
+	ret = lenovo_send_cmd_cptkbd(hdev, 0x01, 0x03);
+	if (ret)
+		hid_warn(hdev, "Failed to switch F7/9/11 mode: %d\n", ret);
+
+	/* Switch middle button to native mode */
+	ret = lenovo_send_cmd_cptkbd(hdev, 0x09, 0x01);
+	if (ret)
+		hid_warn(hdev, "Failed to switch middle button: %d\n", ret);
+
 	ret = lenovo_send_cmd_cptkbd(hdev, 0x05, cptkbd_data->fn_lock);
 	if (ret)
 		hid_err(hdev, "Fn-lock setting failed: %d\n", ret);
@@ -1148,22 +1161,6 @@ static int lenovo_probe_cptkbd(struct hi
 	}
 	hid_set_drvdata(hdev, cptkbd_data);
 
-	/*
-	 * Tell the keyboard a driver understands it, and turn F7, F9, F11 into
-	 * regular keys (Compact only)
-	 */
-	if (hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD ||
-	    hdev->product == USB_DEVICE_ID_LENOVO_CBTKBD) {
-		ret = lenovo_send_cmd_cptkbd(hdev, 0x01, 0x03);
-		if (ret)
-			hid_warn(hdev, "Failed to switch F7/9/11 mode: %d\n", ret);
-	}
-
-	/* Switch middle button to native mode */
-	ret = lenovo_send_cmd_cptkbd(hdev, 0x09, 0x01);
-	if (ret)
-		hid_warn(hdev, "Failed to switch middle button: %d\n", ret);
-
 	/* Set keyboard settings to known state */
 	cptkbd_data->middlebutton_state = 0;
 	cptkbd_data->fn_lock = true;
@@ -1286,6 +1283,24 @@ err:
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static int lenovo_reset_resume(struct hid_device *hdev)
+{
+	switch (hdev->product) {
+	case USB_DEVICE_ID_LENOVO_CUSBKBD:
+	case USB_DEVICE_ID_LENOVO_TPIIUSBKBD:
+		if (hdev->type == HID_TYPE_USBMOUSE)
+			lenovo_features_set_cptkbd(hdev);
+
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+#endif
+
 static void lenovo_remove_tpkbd(struct hid_device *hdev)
 {
 	struct lenovo_drvdata *data_pointer = hid_get_drvdata(hdev);
@@ -1402,6 +1417,9 @@ static struct hid_driver lenovo_driver =
 	.raw_event = lenovo_raw_event,
 	.event = lenovo_event,
 	.report_fixup = lenovo_report_fixup,
+#ifdef CONFIG_PM
+	.reset_resume = lenovo_reset_resume,
+#endif
 };
 module_hid_driver(lenovo_driver);
 


