Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCBD44AB6A;
	Tue, 21 Jul 2026 22:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674773; cv=none; b=QYJUlvvVf00k3vB50Cadx7JFUldIHvQbu01ISdcLnJvgc4y96cvm26WKmFqF/BX4Za3HINSeoIGEDh2ADx2NRsPIMOaULB7ttv4oKoYnxJ3bQJWJ+aLGR/viPQdQfVjwj9dN8VRJ6utcP1O3A/QldPzofaeLAcGfGJgySZKEJKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674773; c=relaxed/simple;
	bh=6U7KzBKwvk3DnP/rDvja20XuYz2KQnCM+fuUsc7G4+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCsEHG22SIdvJyjsAz7teloSusrplc0trtaNpMF7D3Xv8VnTp6y+5kel/pQbVshjJz71sfGcmGfFPA8mf3RWpF4jMc2E3UDhPS6/8lBrQhMaqYhFwJcwudWPQMQGsnFTVDjVhK6SnBHxeLFHnuF3LcwUq0EJdf1IQHSp3r+Ilvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On7m18BW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On7m18BW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555F51F000E9;
	Tue, 21 Jul 2026 22:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674771;
	bh=m3Etx6ZZFBlZY0SbR1+Xnoplq3ZzmX2+aDGNXFqpgvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=On7m18BWRXludgxgYu6ThEq/SFRtW6WIaFIdh5XAWX+TEdWVWj5uCxk+HpWzfWypI
	 jcXDCtodD4YiNergMsTF/XZocyzTEmhp49zb8fVuYg4Xe9q7N7caUYD5dFIbqY6cnv
	 J1dzzanQnR4znA294Zxzfn/ab9QOUrsYJIjohgeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 666/699] usb: iowarrior: remove inherent race with minor number
Date: Tue, 21 Jul 2026 17:27:05 +0200
Message-ID: <20260721152410.788982129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -526,9 +519,6 @@ static long iowarrior_ioctl(struct file
 		goto error_out;
 	}
 
-	dev_dbg(&dev->interface->dev, "minor %d, cmd 0x%.4x, arg %ld\n",
-		dev->minor, cmd, arg);
-
 	retval = 0;
 	io_res = 0;
 	switch (cmd) {
@@ -675,8 +665,6 @@ static int iowarrior_release(struct inod
 	if (!dev)
 		return -ENODEV;
 
-	dev_dbg(&dev->interface->dev, "minor %d\n", dev->minor);
-
 	/* lock our device */
 	mutex_lock(&dev->mutex);
 
@@ -779,6 +767,7 @@ static int iowarrior_probe(struct usb_in
 	struct usb_host_interface *iface_desc;
 	int retval = -ENOMEM;
 	int res;
+	int minor;
 
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(struct iowarrior), GFP_KERNEL);
@@ -894,12 +883,12 @@ static int iowarrior_probe(struct usb_in
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


