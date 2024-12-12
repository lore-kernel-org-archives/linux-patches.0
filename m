Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E4422333E;
	Thu, 12 Dec 2024 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022665; cv=none; b=RVK+0ufIRjV//jMXGxTJ313T75qBMW4OfDPpMJ3XfKMezaTSSU/tlFFEvEVu0dcp+M0p0Brjb/FG+Bdr01pRqrhMcNZoO1DFIO0oNqrhI/+DvXRahbq1eM0dy36rUc+Mrb7Nmc6oKKEAfqEz/0mHCCyFxZla4Daw4M1cOyxvHAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022665; c=relaxed/simple;
	bh=oTwi6xK2ZhCA4IAtCNQufSVgdk4yI1b78ihAuuuUPyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9ZAo7DGtAk0+7W6e+nANmuNqYoBLkK+mdaU6QVtFS7WHyHZqSO9GDx0ogI+pHOoH/wMKjCq0DcuUkouLzNqjx+VqX2RQIEXKGaZyzuFo52vjSb0SGiRecFXQrnH8BDrHXinzdB1VyXK43FCiH24RaZ+c5dI2VfjKJDIFygNFag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1llVgOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1llVgOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5490C4CED0;
	Thu, 12 Dec 2024 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022665;
	bh=oTwi6xK2ZhCA4IAtCNQufSVgdk4yI1b78ihAuuuUPyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1llVgOr+uZ9mTIg9nCCCEf5YmNQdmjuRnHdZT6Bhzh2fXy7Rxz9DaxajhxLq96xe
	 xDSELE8WRwYAy9SNcVuWlWgWlJOy2+JxfGxuHye0vlbThX9j1+wUc9d460nopgCCVX
	 4p/P9s7WBws9T6sl0tfgLND/Gxic4+bvut5GiCXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	stable@kernel.org,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 303/565] ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices
Date: Thu, 12 Dec 2024 15:58:18 +0100
Message-ID: <20241212144323.444764471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -591,6 +591,7 @@ int snd_usb_create_quirk(struct snd_usb_
 static int snd_usb_extigy_boot_quirk(struct usb_device *dev, struct usb_interface *intf)
 {
 	struct usb_host_config *config = dev->actconfig;
+	struct usb_device_descriptor new_device_descriptor;
 	int err;
 
 	if (le16_to_cpu(get_cfg_desc(config)->wTotalLength) == EXTIGY_FIRMWARE_SIZE_OLD ||
@@ -602,10 +603,14 @@ static int snd_usb_extigy_boot_quirk(str
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
@@ -937,6 +942,7 @@ static void mbox2_setup_48_24_magic(stru
 static int snd_usb_mbox2_boot_quirk(struct usb_device *dev)
 {
 	struct usb_host_config *config = dev->actconfig;
+	struct usb_device_descriptor new_device_descriptor;
 	int err;
 	u8 bootresponse[0x12];
 	int fwsize;
@@ -972,10 +978,14 @@ static int snd_usb_mbox2_boot_quirk(stru
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
@@ -1020,7 +1030,6 @@ static int snd_usb_axefx3_boot_quirk(str
 	return 0;
 }
 
-
 #define MICROBOOK_BUF_SIZE 128
 
 static int snd_usb_motu_microbookii_communicate(struct usb_device *dev, u8 *buf,


