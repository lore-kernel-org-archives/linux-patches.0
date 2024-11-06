Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992B01F130F;
	Wed,  6 Nov 2024 13:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898156; cv=none; b=hsaQ01L/ZtXWtwZPTD9nUvk1HzZ4nQmhxolC2jYQZDraEYg+s1pd/RpzE+Utyrid5f6jISwKBCvlcJLyG3yGRqnDJUhK8K77AAuDT7fCMJ1TfeDLul4CjnPft2k6qtKgXgHKjjcSxhNZ7JNQOyZnU7zsCUrfOkyAQ0ItjummFqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898156; c=relaxed/simple;
	bh=4Y6p3RRoplX+aMXu6W7ATF+CNpPghRThYDNu+sKTLL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7RDgBqPmW/ZbC0sQ2UvGot2diJo1rjdBb+NEAfzoZo0sSgAnRyUtiGcYHpzNC6HRweA05Xwy5qJlvIlPk1CMb+eZR/5m5izH2bWSbVkD1bsXifot60Xyj55pdLnNUvP1eVDaRIh/DVSKr3kphRsSFqDKrmKPgCPBfV2SFp1NAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uipfyNdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uipfyNdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22909C4CED3;
	Wed,  6 Nov 2024 13:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898156;
	bh=4Y6p3RRoplX+aMXu6W7ATF+CNpPghRThYDNu+sKTLL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uipfyNdM0n1AHkgKRQ7bOLnN9FVddirxRYaMsMxT2gTxUiNwrtGFw9u3/597abVJ2
	 REWdZn6GqCuksRV7qp77o7HzT87pYm+Ycz0rXqpCulAW6rAYkKSikn6Yrd1JuNgAnK
	 ruF4k3NzH4X8VnNL3QZeC5RzGJHVofmluVt16ruE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.4 142/462] USB: appledisplay: close race between probe and completion handler
Date: Wed,  6 Nov 2024 13:00:35 +0100
Message-ID: <20241106120335.019195845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 8265d06b7794493d82c5c21a12d7ba43eccc30cb upstream.

There is a small window during probing when IO is running
but the backlight is not registered. Processing events
during that time will crash. The completion handler
needs to check for a backlight before scheduling work.

The bug is as old as the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240912123317.1026049-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/appledisplay.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -107,7 +107,12 @@ static void appledisplay_complete(struct
 	case ACD_BTN_BRIGHT_UP:
 	case ACD_BTN_BRIGHT_DOWN:
 		pdata->button_pressed = 1;
-		schedule_delayed_work(&pdata->work, 0);
+		/*
+		 * there is a window during which no device
+		 * is registered
+		 */
+		if (pdata->bd )
+			schedule_delayed_work(&pdata->work, 0);
 		break;
 	case ACD_BTN_NONE:
 	default:
@@ -202,6 +207,7 @@ static int appledisplay_probe(struct usb
 	const struct usb_device_id *id)
 {
 	struct backlight_properties props;
+	struct backlight_device *backlight;
 	struct appledisplay *pdata;
 	struct usb_device *udev = interface_to_usbdev(iface);
 	struct usb_endpoint_descriptor *endpoint;
@@ -272,13 +278,14 @@ static int appledisplay_probe(struct usb
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
-	pdata->bd = backlight_device_register(bl_name, NULL, pdata,
+	backlight = backlight_device_register(bl_name, NULL, pdata,
 					      &appledisplay_bl_data, &props);
-	if (IS_ERR(pdata->bd)) {
+	if (IS_ERR(backlight)) {
 		dev_err(&iface->dev, "Backlight registration failed\n");
-		retval = PTR_ERR(pdata->bd);
+		retval = PTR_ERR(backlight);
 		goto error;
 	}
+	pdata->bd = backlight;
 
 	/* Try to get brightness */
 	brightness = appledisplay_bl_get_brightness(pdata->bd);


