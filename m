Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29301DE8A2;
	Wed,  6 Nov 2024 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895112; cv=none; b=nV9D1MVpAXJwK9mr+6JHzqG6IkxyzRpt4ShautVSNJO2i9BpJWvk1DJa7pAHdDAqDUiEQiAIeKSeemaj3rkjW2zzi1yyuh2wBT8huHh1dAL5nNRHvGUCN/qnmBr8rexdYpiHjg3ji3aDlBPxGad7cEBXA4cyOvhNOZrDquOv6NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895112; c=relaxed/simple;
	bh=V70O6t+CbF9pFtcpCkv1PNlinp3HJP26afhjof4ZzRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dm2saxJRw4w9FoDuzgYBozXeifdPQ9KhFo37K7SWTpuYZsU4HK497zJTrvjGcRLZ87j8e1n6PzkrHSsHFDCQv2gzPNjk7sV4FJj8g2blxYylo1kS/N9aibadZVJKEmepILknPPtAE/4PYKgV9+Pfr490TG0lQLlNtsI31Upqx7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLvKEbTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLvKEbTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3CBC4CECD;
	Wed,  6 Nov 2024 12:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895112;
	bh=V70O6t+CbF9pFtcpCkv1PNlinp3HJP26afhjof4ZzRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLvKEbTwHmJ1gmEBR/qH42ToRr8LujpsyDkaLa73BwEazyEddjRTetBJGFmBsxZUG
	 mqpFQrDlOubmS325kKiI6UlhuwS+Uu8QQudO90pewXGNoIty38l2g7CIw1hMx8eHo/
	 l35jKJD4Nwnai6Hhmurm60QjsYq8yoHUR/mKbAts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.19 109/350] USB: appledisplay: close race between probe and completion handler
Date: Wed,  6 Nov 2024 13:00:37 +0100
Message-ID: <20241106120323.593890999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -111,7 +111,12 @@ static void appledisplay_complete(struct
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
@@ -208,6 +213,7 @@ static int appledisplay_probe(struct usb
 	const struct usb_device_id *id)
 {
 	struct backlight_properties props;
+	struct backlight_device *backlight;
 	struct appledisplay *pdata;
 	struct usb_device *udev = interface_to_usbdev(iface);
 	struct usb_endpoint_descriptor *endpoint;
@@ -278,13 +284,14 @@ static int appledisplay_probe(struct usb
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


