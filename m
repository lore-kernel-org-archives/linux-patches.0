Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88031F37BE;
	Tue, 17 Dec 2024 17:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455918; cv=none; b=hho+Ql1lSq33djMaBA27RC372G2deFnAXF/Y/6sPMtZRIdfZ6E0ybuyPjLB8Ohqtw3u5Il3BKXzWtJHr7zrdG93RcnH9ddcZ70o1evj7ocrWSy2orSFgj3gw+OlGLd3d/J5zLWhkaEFuUaFEGISkOynycloJwIoD2bdcbQH7cV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455918; c=relaxed/simple;
	bh=SS1do0D6rCRkU6a7P+svHPWIG53g+8u9/22TLS/wLd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nyogAvDA+wX3YdZhSNHVv6V1nKWRE6Ys1aNOZ9K2PSVtwqiJ+7/ufjLb66xfYfE9xCw9hV1kBKDixMQ216bkvUswY+962R1/NGXHx4gwWRV7fDRvcf9JPt+cPLvVPqvfdk+nPkScFT01xsbummB60SGYHzctBnydUCZlB0ykK7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzBAro4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzBAro4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3D1C4CED3;
	Tue, 17 Dec 2024 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455918;
	bh=SS1do0D6rCRkU6a7P+svHPWIG53g+8u9/22TLS/wLd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzBAro4bUr0R/GF6Uilyhv1VFm+Cd0vHPxvYCTIQ3BUMO+jOOcEK9/QwBa+5cjo0G
	 XAK9LJYmToAL5Wse1z2yH957/jVqNwAbYcYyxV/Xwn5q7diK+y/6Nc84R+jT3GkZf8
	 gZ6ry6eFAj09bhA0OjM0rAoLhQ5UruuKqIu0E6cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>
Subject: [PATCH 6.1 76/76] ALSA: usb-audio: Fix a DMA to stack memory bug
Date: Tue, 17 Dec 2024 18:07:56 +0100
Message-ID: <20241217170529.782609435@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit f7d306b47a24367302bd4fe846854e07752ffcd9 upstream.

The usb_get_descriptor() function does DMA so we're not allowed
to use a stack buffer for that.  Doing DMA to the stack is not portable
all architectures.  Move the "new_device_descriptor" from being stored
on the stack and allocate it with kmalloc() instead.

Fixes: b909df18ce2a ("ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices")
Cc: stable@kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/60e3aa09-039d-46d2-934c-6f123026c2eb@stanley.mountain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -553,7 +553,7 @@ int snd_usb_create_quirk(struct snd_usb_
 static int snd_usb_extigy_boot_quirk(struct usb_device *dev, struct usb_interface *intf)
 {
 	struct usb_host_config *config = dev->actconfig;
-	struct usb_device_descriptor new_device_descriptor;
+	struct usb_device_descriptor *new_device_descriptor __free(kfree) = NULL;
 	int err;
 
 	if (le16_to_cpu(get_cfg_desc(config)->wTotalLength) == EXTIGY_FIRMWARE_SIZE_OLD ||
@@ -564,15 +564,19 @@ static int snd_usb_extigy_boot_quirk(str
 				      0x10, 0x43, 0x0001, 0x000a, NULL, 0);
 		if (err < 0)
 			dev_dbg(&dev->dev, "error sending boot message: %d\n", err);
+
+		new_device_descriptor = kmalloc(sizeof(*new_device_descriptor), GFP_KERNEL);
+		if (!new_device_descriptor)
+			return -ENOMEM;
 		err = usb_get_descriptor(dev, USB_DT_DEVICE, 0,
-				&new_device_descriptor, sizeof(new_device_descriptor));
+				new_device_descriptor, sizeof(*new_device_descriptor));
 		if (err < 0)
 			dev_dbg(&dev->dev, "error usb_get_descriptor: %d\n", err);
-		if (new_device_descriptor.bNumConfigurations > dev->descriptor.bNumConfigurations)
+		if (new_device_descriptor->bNumConfigurations > dev->descriptor.bNumConfigurations)
 			dev_dbg(&dev->dev, "error too large bNumConfigurations: %d\n",
-				new_device_descriptor.bNumConfigurations);
+				new_device_descriptor->bNumConfigurations);
 		else
-			memcpy(&dev->descriptor, &new_device_descriptor, sizeof(dev->descriptor));
+			memcpy(&dev->descriptor, new_device_descriptor, sizeof(dev->descriptor));
 		err = usb_reset_configuration(dev);
 		if (err < 0)
 			dev_dbg(&dev->dev, "error usb_reset_configuration: %d\n", err);
@@ -904,7 +908,7 @@ static void mbox2_setup_48_24_magic(stru
 static int snd_usb_mbox2_boot_quirk(struct usb_device *dev)
 {
 	struct usb_host_config *config = dev->actconfig;
-	struct usb_device_descriptor new_device_descriptor;
+	struct usb_device_descriptor *new_device_descriptor __free(kfree) = NULL;
 	int err;
 	u8 bootresponse[0x12];
 	int fwsize;
@@ -939,15 +943,19 @@ static int snd_usb_mbox2_boot_quirk(stru
 
 	dev_dbg(&dev->dev, "device initialised!\n");
 
+	new_device_descriptor = kmalloc(sizeof(*new_device_descriptor), GFP_KERNEL);
+	if (!new_device_descriptor)
+		return -ENOMEM;
+
 	err = usb_get_descriptor(dev, USB_DT_DEVICE, 0,
-		&new_device_descriptor, sizeof(new_device_descriptor));
+		new_device_descriptor, sizeof(*new_device_descriptor));
 	if (err < 0)
 		dev_dbg(&dev->dev, "error usb_get_descriptor: %d\n", err);
-	if (new_device_descriptor.bNumConfigurations > dev->descriptor.bNumConfigurations)
+	if (new_device_descriptor->bNumConfigurations > dev->descriptor.bNumConfigurations)
 		dev_dbg(&dev->dev, "error too large bNumConfigurations: %d\n",
-			new_device_descriptor.bNumConfigurations);
+			new_device_descriptor->bNumConfigurations);
 	else
-		memcpy(&dev->descriptor, &new_device_descriptor, sizeof(dev->descriptor));
+		memcpy(&dev->descriptor, new_device_descriptor, sizeof(dev->descriptor));
 
 	err = usb_reset_configuration(dev);
 	if (err < 0)
@@ -1261,7 +1269,7 @@ static void mbox3_setup_48_24_magic(stru
 static int snd_usb_mbox3_boot_quirk(struct usb_device *dev)
 {
 	struct usb_host_config *config = dev->actconfig;
-	struct usb_device_descriptor new_device_descriptor;
+	struct usb_device_descriptor *new_device_descriptor __free(kfree) = NULL;
 	int err;
 	int descriptor_size;
 
@@ -1274,15 +1282,19 @@ static int snd_usb_mbox3_boot_quirk(stru
 
 	dev_dbg(&dev->dev, "device initialised!\n");
 
+	new_device_descriptor = kmalloc(sizeof(*new_device_descriptor), GFP_KERNEL);
+	if (!new_device_descriptor)
+		return -ENOMEM;
+
 	err = usb_get_descriptor(dev, USB_DT_DEVICE, 0,
-		&new_device_descriptor, sizeof(new_device_descriptor));
+		new_device_descriptor, sizeof(*new_device_descriptor));
 	if (err < 0)
 		dev_dbg(&dev->dev, "error usb_get_descriptor: %d\n", err);
-	if (new_device_descriptor.bNumConfigurations > dev->descriptor.bNumConfigurations)
+	if (new_device_descriptor->bNumConfigurations > dev->descriptor.bNumConfigurations)
 		dev_dbg(&dev->dev, "error too large bNumConfigurations: %d\n",
-			new_device_descriptor.bNumConfigurations);
+			new_device_descriptor->bNumConfigurations);
 	else
-		memcpy(&dev->descriptor, &new_device_descriptor, sizeof(dev->descriptor));
+		memcpy(&dev->descriptor, new_device_descriptor, sizeof(dev->descriptor));
 
 	err = usb_reset_configuration(dev);
 	if (err < 0)


