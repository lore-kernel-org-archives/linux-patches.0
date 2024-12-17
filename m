Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C5D1F757B;
	Tue, 17 Dec 2024 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455535; cv=none; b=J6vjDz3NN2inSBQuJEQYTXYG163HVLj0NlIDTilD+inhj7zCkANzXqU1AhU5JXs9TPP1Y4JHTQiv2X3ZHnO5k2+wf7G7AmoBZzHYXiuAklq6nNBchpGAF9skc05+kZd8o3xoyZE/yVkyCutFL3PB3BU4Oi+iplg2ynMsClTBLs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455535; c=relaxed/simple;
	bh=/1jSJMLg5sopGyGswydeZAEKPXb4q0WA6u9eg4e1S3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kfzp9kdNRqeu1nw2/axxze0h3PqnyBHKhkEqNeqr/ZqnLrUF80ujQlB4AEoYKgU+Inm/yQ+lDRjNMRahKJzzCrEdaLSgOe+nnSwYCmsIgQegEx57JxqABEA105gFAVFGS6o1m5YkvBTtQd0CPI0zF0B/fDg6gXy4/En52e7tM6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q49gdoMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q49gdoMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1705C4CED3;
	Tue, 17 Dec 2024 17:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455535;
	bh=/1jSJMLg5sopGyGswydeZAEKPXb4q0WA6u9eg4e1S3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q49gdoMNJ65+2DMbx5OBEFNfUgzVQUjjkfjuDYFPlJCVDQDt5Cd3drHob7rKuZLZy
	 kMWvJHG9wCnZiUgkDoC6aziB6qE57xQqrhiAZxmX6iQvh52zhwoftyud35Gdnb2cxY
	 xBdy/lOuzU1VnEvE5cSPHcvUfJCoBz4zWzHvo+uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>
Subject: [PATCH 5.10 43/43] ALSA: usb-audio: Fix a DMA to stack memory bug
Date: Tue, 17 Dec 2024 18:07:34 +0100
Message-ID: <20241217170522.440866202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -595,7 +595,7 @@ int snd_usb_create_quirk(struct snd_usb_
 static int snd_usb_extigy_boot_quirk(struct usb_device *dev, struct usb_interface *intf)
 {
 	struct usb_host_config *config = dev->actconfig;
-	struct usb_device_descriptor new_device_descriptor;
+	struct usb_device_descriptor *new_device_descriptor = NULL;
 	int err;
 
 	if (le16_to_cpu(get_cfg_desc(config)->wTotalLength) == EXTIGY_FIRMWARE_SIZE_OLD ||
@@ -606,15 +606,20 @@ static int snd_usb_extigy_boot_quirk(str
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
@@ -946,7 +951,7 @@ static void mbox2_setup_48_24_magic(stru
 static int snd_usb_mbox2_boot_quirk(struct usb_device *dev)
 {
 	struct usb_host_config *config = dev->actconfig;
-	struct usb_device_descriptor new_device_descriptor;
+	struct usb_device_descriptor *new_device_descriptor = NULL;
 	int err;
 	u8 bootresponse[0x12];
 	int fwsize;
@@ -981,15 +986,21 @@ static int snd_usb_mbox2_boot_quirk(stru
 
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


