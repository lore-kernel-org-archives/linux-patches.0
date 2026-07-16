Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748E44248D7;
	Thu, 16 Jul 2026 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211081; cv=none; b=jQ3o6FsgAD5GTY9H9ZE0Oni0kf31e+avK6kf7aI8UtPSi+F9XgACYr2oP4b/hVtvhhi48Zy4wX7gSz/OK/6U6gRJcoBGiSQRMXLdrNM80tME13LWOacgPrQGY5Noxn26rhxbQX0PK7qjMfV8bfgxykDD4rIB0YQ5U9K2VnQkHkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211081; c=relaxed/simple;
	bh=GFSLS0Iq/AvMGTWAgBTHltQ8wYjEO/PCn+PawU4Z6tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mE1Bwn+i2DLPgfTcRIZPfbCntu+oXiKdbxVWg7Vo9OA/jQY4x22GKkZhF7YpyegGEB79sj8guqo624ljaD5uzqKTE6cFNoyTeAN3dHX3UwNGdUKovkjV5UpONIb5CPw/apUbPGqsszAvU+w/u3p067Unh2EZ8jheDUlrKQivNB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPJiRpIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPJiRpIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96B61F000E9;
	Thu, 16 Jul 2026 14:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211080;
	bh=gjqKbNj1VSn/NsG5oMahyJR/qqpP6F5maxtTd5s2q+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPJiRpICsmPFO3d2/2HeQwvQRLdTVvU1mgEouT5v8v/AVcbjJKZClIM7ta2+oouzf
	 bBOp6Ce5wrNQSCACoh25tPv7OYDTZdCLnA2jzWLPz27DYEmHz2SpYOakIYm2Mbeh/S
	 cXlNjBk7Bwp7Z5ydsq0k7Ym2iosuJHlRwmkZ2VZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Daniel Walker <dwalker@mvista.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 293/480] USB: ldusb: fix use-after-free on disconnect race
Date: Thu, 16 Jul 2026 15:30:40 +0200
Message-ID: <20260716133051.159743036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 19bdfc7b3c179331eafa423d87e1336f43bbfeb8 upstream.

mutex_unlock() may access the mutex structure after releasing the lock
and therefore cannot be used to manage lifetime of objects directly
(unlike spinlocks and refcounts). [1][2]

Use a kref to release the driver data to avoid use-after-free in
mutex_unlock() when release() races with disconnect().

[1] a51749ab34d9 ("locking/mutex: Document that mutex_unlock() is
                   non-atomic")
[2] 2b9d9e0a9ba0 ("locking/mutex: Clarify that mutex_unlock(), and most
                   other sleeping locks, can still use the lock object
                   after it's unlocked")

Fixes: ce0d7d3f575f ("usb: ldusb: ld_usb semaphore to mutex")
Cc: stable <stable@kernel.org>
Cc: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260622152612.116422-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/ldusb.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -150,6 +150,7 @@ MODULE_PARM_DESC(min_interrupt_out_inter
 
 /* Structure to hold all of our device specific stuff */
 struct ld_usb {
+	struct kref		kref;
 	struct mutex		mutex;		/* locks this structure */
 	struct usb_interface	*intf;		/* save off the usb interface pointer */
 	unsigned long		disconnected:1;
@@ -201,8 +202,10 @@ static void ld_usb_abort_transfers(struc
 /*
  *	ld_usb_delete
  */
-static void ld_usb_delete(struct ld_usb *dev)
+static void ld_usb_delete(struct kref *kref)
 {
+	struct ld_usb *dev = container_of(kref, struct ld_usb, kref);
+
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -355,6 +358,8 @@ static int ld_usb_open(struct inode *ino
 		goto unlock_exit;
 	}
 
+	kref_get(&dev->kref);
+
 	/* save device in the file's private structure */
 	file->private_data = dev;
 
@@ -381,17 +386,8 @@ static int ld_usb_release(struct inode *
 
 	mutex_lock(&dev->mutex);
 
-	if (dev->open_count != 1) {
-		retval = -ENODEV;
+	if (dev->disconnected)
 		goto unlock_exit;
-	}
-	if (dev->disconnected) {
-		/* the device was unplugged before the file was released */
-		mutex_unlock(&dev->mutex);
-		/* unlock here as ld_usb_delete frees dev */
-		ld_usb_delete(dev);
-		goto exit;
-	}
 
 	/* wait until write transfer is finished */
 	if (dev->interrupt_out_busy)
@@ -401,7 +397,7 @@ static int ld_usb_release(struct inode *
 
 unlock_exit:
 	mutex_unlock(&dev->mutex);
-
+	kref_put(&dev->kref, ld_usb_delete);
 exit:
 	return retval;
 }
@@ -659,6 +655,8 @@ static int ld_usb_probe(struct usb_inter
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		goto exit;
+
+	kref_init(&dev->kref);
 	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->rbsl);
 	dev->intf = intf;
@@ -740,7 +738,7 @@ exit:
 	return retval;
 
 error:
-	ld_usb_delete(dev);
+	kref_put(&dev->kref, ld_usb_delete);
 
 	return retval;
 }
@@ -768,18 +766,18 @@ static void ld_usb_disconnect(struct usb
 
 	mutex_lock(&dev->mutex);
 
-	/* if the device is not opened, then we clean up right now */
-	if (!dev->open_count) {
-		mutex_unlock(&dev->mutex);
-		ld_usb_delete(dev);
-	} else {
-		dev->disconnected = 1;
+	dev->disconnected = 1;
+
+	if (dev->open_count) {
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);
-		mutex_unlock(&dev->mutex);
 	}
 
+	mutex_unlock(&dev->mutex);
+
+	kref_put(&dev->kref, ld_usb_delete);
+
 	dev_info(&intf->dev, "LD USB Device #%d now disconnected\n",
 		 (minor - USB_LD_MINOR_BASE));
 }


