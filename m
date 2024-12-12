Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020AF2253FD;
	Thu, 12 Dec 2024 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025459; cv=none; b=C47qyygtA/btfqI3zNgLnDpvkwIn7TD8g5n/cdKsDjlB54vW44CfMUWz/l/uEW0iJbWwg0At4esALyki+NGfEwRukSgnFXyBXbh1Ed6m2uUhgMU8pfcIlbZSJEKLljjfIVX7oQ110xp1oENWNLpOjGy0wam7Y5s++cpA+TV1I2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025459; c=relaxed/simple;
	bh=D7XeO9Y1Y/c08XLLanwTaLHAlyg9hVFVUxB+ymapqnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iU3X5rPaoaWPPtQDium+5zn0FusT7oBfZ4g2LOy8qWuA2Rlx+kd7q3dyHqQ3ur/Do4UOpS6HANuTQExTR2FUGS2GLncnAZ2EP0EQkXjash4DU7cq6iGvGKIt+U+E59i4zB1IcMsAbsDwscHQd60b5qwrOwx8bvDAW1Bi9nxm6wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYz+YZl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYz+YZl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824E4C4CED0;
	Thu, 12 Dec 2024 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025458;
	bh=D7XeO9Y1Y/c08XLLanwTaLHAlyg9hVFVUxB+ymapqnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYz+YZl4EnVAisRXUwRYA9uMp80clYjgG9gGYgWqLKy7jyoNx/tSFO97fLpGluJ/e
	 S3VdbeOnb6sGj7huFuwJrJy2EJPXkyIcotdpvIdHEiiIuMBkBPofeIjzW7LEYC920Z
	 3lVSsf/pzi4r6f1rHZxNao8n6NNX+Ro3y/AY6tAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	stable@kernel.org,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 145/321] ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices
Date: Thu, 12 Dec 2024 16:01:03 +0100
Message-ID: <20241212144235.708094475@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

From: Benoît Sevens <bsevens@google.com>

commit b909df18ce2a998afef81d58bbd1a05dc0788c40 upstream.

A bogus device can provide a bNumConfigurations value that exceeds the
initial value used in usb_get_configuration for allocating dev->config.

This can lead to out-of-bounds accesses later, e.g. in
usb_destroy_configuration.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@kernel.org
Link: https://patch.msgid.link/20241120124144.3814457-1-bsevens@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -585,6 +585,7 @@ int snd_usb_create_quirk(struct snd_usb_
 static int snd_usb_extigy_boot_quirk(struct usb_device *dev, struct usb_interface *intf)
 {
 	struct usb_host_config *config = dev->actconfig;
+	struct usb_device_descriptor new_device_descriptor;
 	int err;
 
 	if (le16_to_cpu(get_cfg_desc(config)->wTotalLength) == EXTIGY_FIRMWARE_SIZE_OLD ||
@@ -596,10 +597,14 @@ static int snd_usb_extigy_boot_quirk(str
 		if (err < 0)
 			dev_dbg(&dev->dev, "error sending boot message: %d\n", err);
 		err = usb_get_descriptor(dev, USB_DT_DEVICE, 0,
-				&dev->descriptor, sizeof(dev->descriptor));
-		config = dev->actconfig;
+				&new_device_descriptor, sizeof(new_device_descriptor));
 		if (err < 0)
 			dev_dbg(&dev->dev, "error usb_get_descriptor: %d\n", err);
+		if (new_device_descriptor.bNumConfigurations > dev->descriptor.bNumConfigurations)
+			dev_dbg(&dev->dev, "error too large bNumConfigurations: %d\n",
+				new_device_descriptor.bNumConfigurations);
+		else
+			memcpy(&dev->descriptor, &new_device_descriptor, sizeof(dev->descriptor));
 		err = usb_reset_configuration(dev);
 		if (err < 0)
 			dev_dbg(&dev->dev, "error usb_reset_configuration: %d\n", err);
@@ -933,6 +938,7 @@ static void mbox2_setup_48_24_magic(stru
 static int snd_usb_mbox2_boot_quirk(struct usb_device *dev)
 {
 	struct usb_host_config *config = dev->actconfig;
+	struct usb_device_descriptor new_device_descriptor;
 	int err;
 	u8 bootresponse[0x12];
 	int fwsize;
@@ -968,10 +974,14 @@ static int snd_usb_mbox2_boot_quirk(stru
 	dev_dbg(&dev->dev, "device initialised!\n");
 
 	err = usb_get_descriptor(dev, USB_DT_DEVICE, 0,
-		&dev->descriptor, sizeof(dev->descriptor));
-	config = dev->actconfig;
+		&new_device_descriptor, sizeof(new_device_descriptor));
 	if (err < 0)
 		dev_dbg(&dev->dev, "error usb_get_descriptor: %d\n", err);
+	if (new_device_descriptor.bNumConfigurations > dev->descriptor.bNumConfigurations)
+		dev_dbg(&dev->dev, "error too large bNumConfigurations: %d\n",
+			new_device_descriptor.bNumConfigurations);
+	else
+		memcpy(&dev->descriptor, &new_device_descriptor, sizeof(dev->descriptor));
 
 	err = usb_reset_configuration(dev);
 	if (err < 0)
@@ -1018,7 +1028,6 @@ static int snd_usb_axefx3_boot_quirk(str
 	return 0;
 }
 
-
 #define MICROBOOK_BUF_SIZE 128
 
 static int snd_usb_motu_microbookii_communicate(struct usb_device *dev, u8 *buf,


