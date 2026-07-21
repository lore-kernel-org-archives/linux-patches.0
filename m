Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB9C43C7DA;
	Tue, 21 Jul 2026 22:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672942; cv=none; b=iR4PjAfXbJ+Hwsxuj6Klp0/I8E44tEaXjJaBzU3B2xSzbVtufHDJWPQlgGNAMP+hcNF9rVePOkxffv60JVwpMHZiWimyvbZkiDPtvmPX4LYZSq7CLVowle2r2bPNjSHBRzrRU0/a5VBPqlp5AY0Wx6ysFklG8nl2h4AUHg981z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672942; c=relaxed/simple;
	bh=tBfAtHTUDqXrp0HmSe24fQxZUzp+GP9TCzJg4tzBdII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxBbodFchv1rWfFGrmwfIyeEvTUH05JVaOwQDInmOUcJC9nRaieYKXd9eA0cPDf186xz7XtmRn9+BoK2sX5Nd+gSjKdXqXHF9IIjp5e6uKkDl9LpdmCpaIYWKEEv2Kj/Ykk7m1F4xUUGBilbGz/QgBFb5YJQLvJNMBSCcs2aOsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpHKjp29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpHKjp29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E381F00A3E;
	Tue, 21 Jul 2026 22:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672941;
	bh=zghv8SjKkIjevqX8FB8MsVDsMR7zkd8WLn1P9XYPAQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpHKjp29dybh85Uw/Vw5k+faWk4z8pIhU7NXWiNh0EA/RvFZWTh1AuqySxn+cc8gF
	 0RyGRfqySslaKeQ+wd7x4UYaiFQ5pq5yah9FbzVoqpOD5x3RGiKfg9SHcehPh+uLjF
	 lm2+lVDZsAo88RVjkpn4Y4mtDjVbayuAyuOT3YPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 813/843] usb: iowarrior: remove inherent race with minor number
Date: Tue, 21 Jul 2026 17:27:28 +0200
Message-ID: <20260721152424.363616183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 56dd29088c9d9510c48a8ebad2465248fde36551 ]

The driver saves the minor number it gets upon registration
in its descriptor for debugging purposes. However, there is
inevitably a window between registration and saving the correct
minor in a descriptor. During this window the debugging output
will be wrong.
As wrong debug output is worse than no debug output, just
remove it.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260312094619.1590556-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c602254ba4c1 ("USB: iowarrior: fix use-after-free on disconnect race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -74,7 +74,6 @@ struct iowarrior {
 	struct mutex mutex;			/* locks this structure */
 	struct usb_device *udev;		/* save off the usb device pointer */
 	struct usb_interface *interface;	/* the interface for this device */
-	unsigned char minor;			/* the starting minor number for this device */
 	struct usb_endpoint_descriptor *int_out_endpoint;	/* endpoint for reading (needed for IOW56 only) */
 	struct usb_endpoint_descriptor *int_in_endpoint;	/* endpoint for reading */
 	struct urb *int_in_urb;		/* the urb for reading data */
@@ -246,7 +245,6 @@ static void iowarrior_write_callback(str
  */
 static inline void iowarrior_delete(struct iowarrior *dev)
 {
-	dev_dbg(&dev->interface->dev, "minor %d\n", dev->minor);
 	kfree(dev->int_in_buffer);
 	usb_free_urb(dev->int_in_urb);
 	kfree(dev->read_queue);
@@ -297,9 +295,6 @@ static ssize_t iowarrior_read(struct fil
 		goto exit;
 	}
 
-	dev_dbg(&dev->interface->dev, "minor %d, count = %zd\n",
-		dev->minor, count);
-
 	/* read count must be packet size (+ time stamp) */
 	if ((count != dev->report_size)
 	    && (count != (dev->report_size + 1))) {
@@ -379,8 +374,6 @@ static ssize_t iowarrior_write(struct fi
 		retval = -ENODEV;
 		goto exit;
 	}
-	dev_dbg(&dev->interface->dev, "minor %d, count = %zd\n",
-		dev->minor, count);
 	/* if count is 0 we're already done */
 	if (count == 0) {
 		retval = 0;
@@ -523,9 +516,6 @@ static long iowarrior_ioctl(struct file
 		goto error_out;
 	}
 
-	dev_dbg(&dev->interface->dev, "minor %d, cmd 0x%.4x, arg %ld\n",
-		dev->minor, cmd, arg);
-
 	retval = 0;
 	io_res = 0;
 	switch (cmd) {
@@ -672,8 +662,6 @@ static int iowarrior_release(struct inod
 	if (!dev)
 		return -ENODEV;
 
-	dev_dbg(&dev->interface->dev, "minor %d\n", dev->minor);
-
 	/* lock our device */
 	mutex_lock(&dev->mutex);
 
@@ -776,6 +764,7 @@ static int iowarrior_probe(struct usb_in
 	struct usb_host_interface *iface_desc;
 	int retval = -ENOMEM;
 	int res;
+	int minor;
 
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(struct iowarrior), GFP_KERNEL);
@@ -891,12 +880,12 @@ static int iowarrior_probe(struct usb_in
 		goto error;
 	}
 
-	dev->minor = interface->minor;
+	minor = interface->minor;
 
 	/* let the user know what node this device is now attached to */
 	dev_info(&interface->dev, "IOWarrior product=0x%x, serial=%s interface=%d "
 		 "now attached to iowarrior%d\n", dev->product_id, dev->chip_serial,
-		 iface_desc->desc.bInterfaceNumber, dev->minor - IOWARRIOR_MINOR_BASE);
+		 iface_desc->desc.bInterfaceNumber, minor - IOWARRIOR_MINOR_BASE);
 	return retval;
 
 error:


