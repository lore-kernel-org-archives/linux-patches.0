Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752AF41DEC3;
	Thu, 16 Jul 2026 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209879; cv=none; b=Tzr29zRI8629YEiW81ctq8+efjjCZBuRHHik5FGK/+V8wlru7PzhNCwIqw7AvsfMUwuz9Tu0nQ1f4cwhLoo8vecicTjwlTmW6W9eB9sZ4KUYtIptDOefvtDIlTcgXRmCmSbsKT3kk3NTtyUx6pdw+k3ZQ8WuMiaGvO17Pf3gzfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209879; c=relaxed/simple;
	bh=v4vxyecinicOar36ck6cZ1Ym5SlFPwdNU7NeMhFIoZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ow2nfDr30wIVY4V6EaDj9vWL2EzPKIIDLNFRXBEkkgXoxrU+CA3yeYHUU035DKGx1JE6FV4IXhuC+NgWDehx7G2Gs7GaNkxSh2Ky7+XHC2hqTdltSFon4g519l6csySmY6UvJKYLfurl7wTKIsUjiTid29SzSiMyYXaJFFWhCu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNl2rfHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNl2rfHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04B31F000E9;
	Thu, 16 Jul 2026 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209878;
	bh=yUJhzzDlJdJhE4HFKX+TZpq1/o11i8L3AGDxqWN6OOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNl2rfHfNlHpRouXfnB3nqaj8150l7aCJbool4uxHPiPk5GOtVbXNAWmUAoKrqxVN
	 HDGlq9st1V2guR4wB5UulXl+UXDG9P9YAQSF3paWuXyvuqlRZMAYXbSb/RQVzX435J
	 8MGWSBx7zLaGRthgkFnRE8PoUlHwSXgEsqGBsiL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yue Sun <samsun1006219@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 310/518] USB: iowarrior: fix use-after-free on disconnect race
Date: Thu, 16 Jul 2026 15:29:38 +0200
Message-ID: <20260716133054.606146333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit c602254ba4c10f60a73cd99d147874f86a3f485c upstream.

mutex_unlock() may access the mutex structure after releasing the lock
and therefore cannot be used to manage lifetime of objects directly
(unlike spinlocks and refcounts). [1][2]

Use a kref to release the driver data to avoid use-after-free in
mutex_unlock() when release() races with disconnect().

[1] a51749ab34d9 ("locking/mutex: Document that mutex_unlock() is non-atomic")
[2] 2b9d9e0a9ba0 ("locking/mutex: Clarify that mutex_unlock(), and most
                   other sleeping locks, can still use the lock object
                   after it's unlocked")

Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Cc: stable <stable@kernel.org>
Reported-by: Yue Sun <samsun1006219@gmail.com>
Link: https://lore.kernel.org/r/20260618080204.38322-1-samsun1006219@gmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260622152612.116422-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c |   57 ++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -72,6 +72,7 @@ static struct usb_driver iowarrior_drive
 
 /* Structure to hold all of our device specific stuff */
 struct iowarrior {
+	struct kref kref;
 	struct mutex mutex;			/* locks this structure */
 	struct usb_device *udev;		/* save off the usb device pointer */
 	struct usb_interface *interface;	/* the interface for this device */
@@ -240,8 +241,10 @@ static void iowarrior_write_callback(str
 /*
  *	iowarrior_delete
  */
-static inline void iowarrior_delete(struct iowarrior *dev)
+static inline void iowarrior_delete(struct kref *kref)
 {
+	struct iowarrior *dev = container_of(kref, struct iowarrior, kref);
+
 	kfree(dev->int_in_buffer);
 	usb_free_urb(dev->int_in_urb);
 	kfree(dev->read_queue);
@@ -637,6 +640,9 @@ static int iowarrior_open(struct inode *
 	}
 	/* increment our usage count for the driver */
 	++dev->opened;
+
+	kref_get(&dev->kref);
+
 	/* save our object in the file's private structure */
 	file->private_data = dev;
 	retval = 0;
@@ -652,7 +658,6 @@ out:
 static int iowarrior_release(struct inode *inode, struct file *file)
 {
 	struct iowarrior *dev;
-	int retval = 0;
 
 	dev = file->private_data;
 	if (!dev)
@@ -660,29 +665,18 @@ static int iowarrior_release(struct inod
 
 	/* lock our device */
 	mutex_lock(&dev->mutex);
+	dev->opened = 0;	/* we're closing now */
 
-	if (dev->opened <= 0) {
-		retval = -ENODEV;	/* close called more than once */
-		mutex_unlock(&dev->mutex);
-	} else {
-		dev->opened = 0;	/* we're closing now */
-		retval = 0;
-		if (dev->present) {
-			/*
-			   The device is still connected so we only shutdown
-			   pending read-/write-ops.
-			 */
-			usb_kill_urb(dev->int_in_urb);
-			wake_up_interruptible(&dev->read_wait);
-			wake_up_interruptible(&dev->write_wait);
-			mutex_unlock(&dev->mutex);
-		} else {
-			/* The device was unplugged, cleanup resources */
-			mutex_unlock(&dev->mutex);
-			iowarrior_delete(dev);
-		}
+	if (dev->present) {
+		usb_kill_urb(dev->int_in_urb);
+		wake_up_interruptible(&dev->read_wait);
+		wake_up_interruptible(&dev->write_wait);
 	}
-	return retval;
+	mutex_unlock(&dev->mutex);
+
+	kref_put(&dev->kref, iowarrior_delete);
+
+	return 0;
 }
 
 static __poll_t iowarrior_poll(struct file *file, poll_table * wait)
@@ -767,6 +761,7 @@ static int iowarrior_probe(struct usb_in
 	if (!dev)
 		return retval;
 
+	kref_init(&dev->kref);
 	mutex_init(&dev->mutex);
 
 	atomic_set(&dev->intr_idx, 0);
@@ -885,7 +880,8 @@ static int iowarrior_probe(struct usb_in
 	return retval;
 
 error:
-	iowarrior_delete(dev);
+	kref_put(&dev->kref, iowarrior_delete);
+
 	return retval;
 }
 
@@ -909,19 +905,14 @@ static void iowarrior_disconnect(struct
 	usb_kill_anchored_urbs(&dev->submitted);
 
 	if (dev->opened) {
-		/* There is a process that holds a filedescriptor to the device ,
-		   so we only shutdown read-/write-ops going on.
-		   Deleting the device is postponed until close() was called.
-		 */
 		usb_kill_urb(dev->int_in_urb);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
-		mutex_unlock(&dev->mutex);
-	} else {
-		/* no process is using the device, cleanup now */
-		mutex_unlock(&dev->mutex);
-		iowarrior_delete(dev);
 	}
+
+	mutex_unlock(&dev->mutex);
+
+	kref_put(&dev->kref, iowarrior_delete);
 }
 
 /* usb specific object needed to register this driver with the usb subsystem */


