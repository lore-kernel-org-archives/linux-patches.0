Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2631F758F;
	Tue, 17 Dec 2024 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455429; cv=none; b=t6CwvUpdasHG154vkOxWTY/pcu55IBonuhH5S8kcx2NWwTcDv+ZlUMkLGsejpqxrIEtfJYPUp1/vm6iOtsBirhVNSHTYO2XxF0sVcmltUBGTZPi/NN4lz0ERmvZxAt9CRDvy4O0EjaszOYCAe3fs9WFFslPrRnCQrOW6zKPn8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455429; c=relaxed/simple;
	bh=LV9MS8uEQvUGP15oX98Rwdv7fx3h41OiiEWNoGY0q1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GF/IfvcXxnydZc1V4dw63gvNKmRSSpo8aRo8fuPwFEVOqlwtkGRU/aI5qbliiiVDaRXbDdgYGdU50ozgDweNLdnW2tv3V4+aQUibnA1gyQCw4fraNb1DNprf7R6KwZXoOGESP0ooesif65mYNq6BMA+3b4yPiZxCDc8gNmKR3lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEw/YDnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEw/YDnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145BAC4CED3;
	Tue, 17 Dec 2024 17:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455426;
	bh=LV9MS8uEQvUGP15oX98Rwdv7fx3h41OiiEWNoGY0q1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEw/YDnTGayDtoX3PxtyykmNMOcwY8k1OH6y+T/ZGLrg/KvUSEduNkx4gp7zNLQf8
	 LGBQPubJi+XCxZ+q6BZ1jZ2hkAGE7xaLvtSdYlKLn0KXHNxyi1RZXHyIRYkKti+mJz
	 r0fdDSaLsxFnkjairJXNXx31CCunlbrISVDSYzw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>
Subject: [PATCH 5.4 24/24] ALSA: usb-audio: Fix a DMA to stack memory bug
Date: Tue, 17 Dec 2024 18:07:22 +0100
Message-ID: <20241217170519.990243495@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 sound/usb/quirks.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -585,7 +585,7 @@ int snd_usb_create_quirk(struct snd_usb_
 static int snd_usb_extigy_boot_quirk(struct usb_device *dev, struct usb_interface *intf)
 {
 	struct usb_host_config *config = dev->actconfig;
-	struct usb_device_descriptor new_device_descriptor;
+	struct usb_device_descriptor *new_device_descriptor = NULL;
 	int err;
 
 	if (le16_to_cpu(get_cfg_desc(config)->wTotalLength) == EXTIGY_FIRMWARE_SIZE_OLD ||
@@ -596,15 +596,20 @@ static int snd_usb_extigy_boot_quirk(str
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
+		kfree(new_device_descriptor);
 		err = usb_reset_configuration(dev);
 		if (err < 0)
 			dev_dbg(&dev->dev, "error usb_reset_configuration: %d\n", err);
@@ -938,7 +943,7 @@ static void mbox2_setup_48_24_magic(stru
 static int snd_usb_mbox2_boot_quirk(struct usb_device *dev)
 {
 	struct usb_host_config *config = dev->actconfig;
-	struct usb_device_descriptor new_device_descriptor;
+	struct usb_device_descriptor *new_device_descriptor = NULL;
 	int err;
 	u8 bootresponse[0x12];
 	int fwsize;
@@ -973,15 +978,21 @@ static int snd_usb_mbox2_boot_quirk(stru
 
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
+
+	kfree(new_device_descriptor);
 
 	err = usb_reset_configuration(dev);
 	if (err < 0)


