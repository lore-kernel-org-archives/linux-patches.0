Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248261C07DB;
	Tue, 15 Oct 2024 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997581; cv=none; b=m+Jai9Qblk4Ijew/AHeSjjAv1zX0hwCymwm+5BjHdFdxKXrwosAcA87w+UdAlDPMkiPQD8H3ylH85cJTMIk+zGaTGjqe1LPUw4SQ/eLLcCJK28xpMPhzQfK2FOQO3y9E/gRNpK+s2GWkhlZKvyPc2nfFPuXkkVRivMQfHdwDlIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997581; c=relaxed/simple;
	bh=ALSbTSTipCymgZEvTmQrujF+fblbEAO0F3kGxRnVlkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5ARTpujDn7iRzkW+oAvm1N8bskUuVq1yCoi75Fl50hz+3DDp8cjrdmY3wqxlHA5GdkMYsDiw5R2xdVcUecmosuGN3VGmZw5uyizu6g82k2UjpK9/dznUmh9Dt+SYZZi8mSDV3XhGCpaESiSqVjHiBAZGFJmjXD9wkCZozxI470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCe1b267; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCe1b267"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B914C4CEC6;
	Tue, 15 Oct 2024 13:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997580;
	bh=ALSbTSTipCymgZEvTmQrujF+fblbEAO0F3kGxRnVlkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCe1b267cnWI8MsjgLHELwWyLkjyma+JoG+nXM+ASck47fP31QHoGPAAVYSMqbVZM
	 goFBhKyyegfhWiJkA8dpEEsLFlRU4yRCUItCTkgUha7gWa4lLjCUbUjlnlzm0pYPjB
	 bxgE/aiu9LgwCsusme7upy+k9gbgVXaA7eRIKv1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 224/518] USB: appledisplay: close race between probe and completion handler
Date: Tue, 15 Oct 2024 14:42:08 +0200
Message-ID: <20241015123925.644642409@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


