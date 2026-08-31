Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FFA463B7B;
	Mon, 31 Aug 2026 13:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183964; cv=none; b=Fy6nN74tcxgaxXl/rNe3suWQcILRVkhkoj2xoZjm+LDGIPKZ/hRVWMcvenxeRFTUxomqtSciZImIyr+ob2ra0OYQX6scwZlye9jKzllMC4AwFuRJx3BkXoNDAl+bDNzmKRn95crgU/JRMUSElF+1EMM2Z5voi1DRetoj5ZkO4II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183964; c=relaxed/simple;
	bh=ZzvtMEmfCsR+doVfpKDB47iEEIuijQgJU4FXUuCfRcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XSap48LGgOZ8OutnbA5ZQBuWHl37+k+PkPsz6N3ugtnTRl8wq+0tz8cxyhk/0MP6BdAJZWShW0NnAUzegvK/7Jj5fFMOuqoF3N28+5sweyqlBZ1ZqrmZCQuJvR9gDQAE0Yz0j1ITwHzMecGAh8gITD+4ka60J47GRUyk5Dlm7iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4bD2et+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4bD2et+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034ED1F00A3F;
	Mon, 31 Aug 2026 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183962;
	bh=RWBp5TmzOZszg7oeEPcejSRMHcVv8duZbOn7+sOCf6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4bD2et+nemxa9HOWktgt3HfHC0c5jiPbu8WpVrSlMm6of+Z5Z5FIT1fAjy3ZdYQb
	 rrl8QIXbUxGBTs/JMZaeXOtUZF/4FXiLHT+XwQDQRDBUWMdCrgZVO7ZgguByIh1ebu
	 Wo1JI9xRHRbbxHGgHAPOLiRS+HuSOCVMnQKSna/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 25/83] HID: asus: simplify RGB init sequence
Date: Mon, 31 Aug 2026 15:34:01 +0200
Message-ID: <20260831133400.589218998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 56d1b33e644cca1bedffbc73d28778ed4ae30f64 ]

Currently, RGB initialization forks depending on whether a device is
NKEY. However, in reality both initialization forks are the same, other
than the NKEY initialization initializing the LED_REPORT_ID1,
LED_REPORT_ID2 endpoints, and the non-NKEY initialization having a
functionality check which is skipped for the NKEY path.

Therefore, merge the if blocks, gate the ID1/ID2 initializations
behind the NKEY quirk instead, and introduce the functionality check
for NKEY devices (it is supported by them).

There should be no functional change with this patch.

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260122075044.5070-2-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 02bf61dfb44f ("HID: asus: fix missing hid_is_usb() check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c |   52 ++++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 30 deletions(-)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -638,13 +638,20 @@ static int asus_kbd_register_leds(struct
 	unsigned char kbd_func;
 	int ret;
 
-	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
-		/* Initialize keyboard */
-		ret = asus_kbd_init(hdev, FEATURE_KBD_REPORT_ID);
-		if (ret < 0)
-			return ret;
+	ret = asus_kbd_init(hdev, FEATURE_KBD_REPORT_ID);
+	if (ret < 0)
+		return ret;
+
+	/* Get keyboard functions */
+	ret = asus_kbd_get_functions(hdev, &kbd_func, FEATURE_KBD_REPORT_ID);
+	if (ret < 0)
+		return ret;
+
+	/* Check for backlight support */
+	if (!(kbd_func & SUPPORT_KBD_BACKLIGHT))
+		return -ENODEV;
 
-		/* The LED endpoint is initialised in two HID */
+	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
 		ret = asus_kbd_init(hdev, FEATURE_KBD_LED_REPORT_ID1);
 		if (ret < 0)
 			return ret;
@@ -652,34 +659,19 @@ static int asus_kbd_register_leds(struct
 		ret = asus_kbd_init(hdev, FEATURE_KBD_LED_REPORT_ID2);
 		if (ret < 0)
 			return ret;
+	}
 
-		if (dmi_match(DMI_PRODUCT_FAMILY, "ProArt P16")) {
-			ret = asus_kbd_disable_oobe(hdev);
-			if (ret < 0)
-				return ret;
-		}
-
-		if (drvdata->quirks & QUIRK_ROG_ALLY_XPAD) {
-			intf = to_usb_interface(hdev->dev.parent);
-			udev = interface_to_usbdev(intf);
-			validate_mcu_fw_version(hdev,
-				le16_to_cpu(udev->descriptor.idProduct));
-		}
-
-	} else {
-		/* Initialize keyboard */
-		ret = asus_kbd_init(hdev, FEATURE_KBD_REPORT_ID);
-		if (ret < 0)
-			return ret;
-
-		/* Get keyboard functions */
-		ret = asus_kbd_get_functions(hdev, &kbd_func, FEATURE_KBD_REPORT_ID);
+	if (dmi_match(DMI_PRODUCT_FAMILY, "ProArt P16")) {
+		ret = asus_kbd_disable_oobe(hdev);
 		if (ret < 0)
 			return ret;
+	}
 
-		/* Check for backlight support */
-		if (!(kbd_func & SUPPORT_KBD_BACKLIGHT))
-			return -ENODEV;
+	if (drvdata->quirks & QUIRK_ROG_ALLY_XPAD) {
+		intf = to_usb_interface(hdev->dev.parent);
+		udev = interface_to_usbdev(intf);
+		validate_mcu_fw_version(hdev,
+			le16_to_cpu(udev->descriptor.idProduct));
 	}
 
 	drvdata->kbd_backlight = devm_kzalloc(&hdev->dev,


