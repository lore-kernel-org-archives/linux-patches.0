Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E491BDC3;
	Mon, 14 Oct 2024 15:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918384; cv=none; b=JgsvPLvv3BzJAE22CYLGJujn12JDlNEa5J/w0lK+vKDDkcCzH8a+1ipqS9gHzttW+fIjJQS+2BX9UATB9voMzZy5pvZgM+0fx3ZF2BAFs9Imr71qgwpi6OsoTz3obR4cbxAhSJ951e5fVef+DSc8av72hSLhDWZa1C+k+aB17DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918384; c=relaxed/simple;
	bh=/KHDfbwEF1q/WdiVIAai0m2tveombMwTcm/HSsRIr/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0mdrLo4lZ0E099AZhdp+JBPRCIw8xL/fkHgVBYfnmqnYJeais75rFl/mxiDAPsnCwr+5WLJ+MgNwYgkrahbZ+fzsZwcr+YHG7WtFTbNVxl+5FN/ttzK3Vs+xQNbMKdVud+dlyqcs1uFK8oWusdStsHMxcfdx+E4WDruWHh2l+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TdHhaXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TdHhaXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677C2C4CEC3;
	Mon, 14 Oct 2024 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918383;
	bh=/KHDfbwEF1q/WdiVIAai0m2tveombMwTcm/HSsRIr/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TdHhaXluF+d9E4UDNMhK8jrB28KH7RC5+2YsmrBb6e7VEYSPe9U00uH8Bpc4BVi7
	 3Jq7PWIukEOU1K0G/Fgim99vnF2nEbTKmFZK+Wl+rCmTtUJ8tkp0vUl8iEjPWaURLX
	 eOlF5UvSIi6bTeZzb3DsJTF5MvBwiPu2Fy52OwO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 307/798] USB: appledisplay: close race between probe and completion handler
Date: Mon, 14 Oct 2024 16:14:21 +0200
Message-ID: <20241014141230.007637088@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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


