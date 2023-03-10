Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31EA847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AFDC4339C;
	Fri, 10 Mar 2023 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456820;
	bh=aFaLbQCDVyXQXY1B9O2X8SpnR7OiMYiu0IUvYlUqn70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrmhvRgVzBEVy6cIw0ufxeY/xGjD6z8QDbziMmsbIuNAAhIxjOM3B1s6rL5C0EELn
	 QF9BHZ70Rla21PtISV7fTnpjiOv9ivo9mKNMLFXPVAX7JbkXR0o2lCpAdvEpNZ+ZeY
	 5yzs4GUnrF+eBN9WzyBpqotNr5IbvwDIU/fQL+M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 135/211] media: uvcvideo: Handle errors from calls to usb_string
Date: Fri, 10 Mar 2023 14:38:35 +0100
Message-Id: <20230310133722.843622993@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 4867bb590ae445bcfaa711a86b603c97e94574b3 ]

On a Webcam from Quanta, we see the following error.

usb 3-5: New USB device found, idVendor=0408, idProduct=30d2, bcdDevice= 0.03
usb 3-5: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 3-5: Product: USB2.0 HD UVC WebCam
usb 3-5: Manufacturer: Quanta
usb 3-5: SerialNumber: 0x0001
...
uvcvideo: Found UVC 1.10 device USB2.0 HD UVC WebCam (0408:30d2)
uvcvideo: Failed to initialize entity for entity 5
uvcvideo: Failed to register entities (-22).

The Webcam reports an entity of type UVC_VC_EXTENSION_UNIT. It reports a
string index of '7' associated with that entity. The attempt to read that
string from the camera fails with error -32 (-EPIPE). usb_string() returns
that error, but it is ignored. As result, the entity name is empty. This
later causes v4l2_device_register_subdev() to return -EINVAL, and no
entities are registered as result.

While this appears to be a firmware problem with the camera, the kernel
should still handle the situation gracefully. To do that, check the return
value from usb_string(). If it reports an error, assign the entity's
default name.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 48 ++++++++++++------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d30f77d89598c..943ae2559448c 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -860,10 +860,8 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 					       + n;
 		memcpy(unit->extension.bmControls, &buffer[23+p], 2*n);
 
-		if (buffer[24+p+2*n] != 0)
-			usb_string(udev, buffer[24+p+2*n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[24+p+2*n] == 0 ||
+		    usb_string(udev, buffer[24+p+2*n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -987,15 +985,15 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 			memcpy(term->media.bmTransportModes, &buffer[10+n], p);
 		}
 
-		if (buffer[7] != 0)
-			usb_string(udev, buffer[7], term->name,
-				   sizeof(term->name));
-		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
-			sprintf(term->name, "Camera %u", buffer[3]);
-		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
-			sprintf(term->name, "Media %u", buffer[3]);
-		else
-			sprintf(term->name, "Input %u", buffer[3]);
+		if (buffer[7] == 0 ||
+		    usb_string(udev, buffer[7], term->name, sizeof(term->name)) < 0) {
+			if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
+				sprintf(term->name, "Camera %u", buffer[3]);
+			if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
+				sprintf(term->name, "Media %u", buffer[3]);
+			else
+				sprintf(term->name, "Input %u", buffer[3]);
+		}
 
 		list_add_tail(&term->list, &dev->entities);
 		break;
@@ -1028,10 +1026,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(term->baSourceID, &buffer[7], 1);
 
-		if (buffer[8] != 0)
-			usb_string(udev, buffer[8], term->name,
-				   sizeof(term->name));
-		else
+		if (buffer[8] == 0 ||
+		    usb_string(udev, buffer[8], term->name, sizeof(term->name)) < 0)
 			sprintf(term->name, "Output %u", buffer[3]);
 
 		list_add_tail(&term->list, &dev->entities);
@@ -1053,10 +1049,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(unit->baSourceID, &buffer[5], p);
 
-		if (buffer[5+p] != 0)
-			usb_string(udev, buffer[5+p], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[5+p] == 0 ||
+		    usb_string(udev, buffer[5+p], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Selector %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1086,10 +1080,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		if (dev->uvc_version >= 0x0110)
 			unit->processing.bmVideoStandards = buffer[9+n];
 
-		if (buffer[8+n] != 0)
-			usb_string(udev, buffer[8+n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[8+n] == 0 ||
+		    usb_string(udev, buffer[8+n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Processing %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1117,10 +1109,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->extension.bmControls = (u8 *)unit + sizeof(*unit);
 		memcpy(unit->extension.bmControls, &buffer[23+p], n);
 
-		if (buffer[23+p+n] != 0)
-			usb_string(udev, buffer[23+p+n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[23+p+n] == 0 ||
+		    usb_string(udev, buffer[23+p+n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
-- 
2.39.2



