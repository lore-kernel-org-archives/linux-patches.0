Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8D42E001;
	Thu, 16 Jul 2026 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212192; cv=none; b=S1YUzLcDdwry/pV3Oxk/Ye12XcSBJ+Y39a6Y+rBM3axLtT1xsfURen+83gYd1c4hOVH5JLgnnhi+z7O+L1CjxnCml91UWVSzpI9qRnLpsiWMCALfiqaqiIQ4/urTHgD9WokZbCWTRKeAIg3Utx8QxVUhlNb1xm5DBg+Gx88osrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212192; c=relaxed/simple;
	bh=rxxULse5VfU2MC7A/dTaQOHWH8apZy9uaT8k8QZuZ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8LufPqJZ/7RlEAinTgLhT1MyIohfh74O3ls+WMZWJHX75IxcWbYAGEANmqlB1sNZF7hXtNBLYE2EmWoTx9pO7ECCfNHA1GPx7AWPSmatDpeJ5mhua54CAtYL36gCTjlmbhwB9SX9DjKHWUvbeEl/aDww0kbuIWc0F3OuJP36eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvFpR+kI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvFpR+kI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3438E1F000E9;
	Thu, 16 Jul 2026 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212191;
	bh=+j0CvZvPLYHC++Lag7eeZE83M8DTOPasPbGnCX1sOhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvFpR+kIPD9SYq6K13iKiG2Yk2wM4Jq8aOqGJoz8zknPEJyVLgKqXxNRemHLQqhEc
	 WA34WdR7rciyQlW07k5r/0N0H2Tcz/GhxvaFtvdw/mJGbaGwrZQyBM2S0ryWeKJMO3
	 YNYTfy1B1qoUYz6kQp3W9VZsXepgwWrrKGLCaG3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Daniel Walker <dwalker@mvista.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 232/349] USB: legousbtower: fix use-after-free on disconnect race
Date: Thu, 16 Jul 2026 15:32:46 +0200
Message-ID: <20260716133038.558111500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 62fc8eb1b1481051f7bab4aa93d79809053dd09f upstream.

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

Fixes: 18bcbcfe9ca2 ("USB: misc: legousbtower: semaphore to mutex")
Cc: stable <stable@kernel.org>
Cc: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260622152612.116422-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/legousbtower.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -185,6 +185,7 @@ MODULE_DEVICE_TABLE(usb, tower_table);
 
 /* Structure to hold all of our device specific stuff */
 struct lego_usb_tower {
+	struct kref		kref;
 	struct mutex		lock;		/* locks this structure */
 	struct usb_device	*udev;		/* save off the usb device pointer */
 	unsigned char		minor;		/* the starting minor number for this device */
@@ -220,7 +221,6 @@ struct lego_usb_tower {
 /* local function prototypes */
 static ssize_t tower_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos);
 static ssize_t tower_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos);
-static inline void tower_delete(struct lego_usb_tower *dev);
 static int tower_open(struct inode *inode, struct file *file);
 static int tower_release(struct inode *inode, struct file *file);
 static __poll_t tower_poll(struct file *file, poll_table *wait);
@@ -286,8 +286,10 @@ static inline void lego_usb_tower_debug_
 /*
  *	tower_delete
  */
-static inline void tower_delete(struct lego_usb_tower *dev)
+static inline void tower_delete(struct kref *kref)
 {
+	struct lego_usb_tower *dev = container_of(kref, struct lego_usb_tower, kref);
+
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -381,6 +383,8 @@ static int tower_open(struct inode *inod
 
 	dev->open_count = 1;
 
+	kref_get(&dev->kref);
+
 unlock_exit:
 	mutex_unlock(&dev->lock);
 
@@ -404,14 +408,8 @@ static int tower_release(struct inode *i
 
 	mutex_lock(&dev->lock);
 
-	if (dev->disconnected) {
-		/* the device was unplugged before the file was released */
-
-		/* unlock here as tower_delete frees dev */
-		mutex_unlock(&dev->lock);
-		tower_delete(dev);
-		goto exit;
-	}
+	if (dev->disconnected)
+		goto out_unlock;
 
 	/* wait until write transfer is finished */
 	if (dev->interrupt_out_busy) {
@@ -425,7 +423,9 @@ static int tower_release(struct inode *i
 
 	dev->open_count = 0;
 
+out_unlock:
 	mutex_unlock(&dev->lock);
+	kref_put(&dev->kref, tower_delete);
 exit:
 	return retval;
 }
@@ -752,6 +752,7 @@ static int tower_probe(struct usb_interf
 	if (!dev)
 		goto exit;
 
+	kref_init(&dev->kref);
 	mutex_init(&dev->lock);
 	dev->udev = usb_get_dev(udev);
 	spin_lock_init(&dev->read_buffer_lock);
@@ -828,7 +829,7 @@ exit:
 	return retval;
 
 error:
-	tower_delete(dev);
+	kref_put(&dev->kref, tower_delete);
 	return retval;
 }
 
@@ -856,18 +857,18 @@ static void tower_disconnect(struct usb_
 
 	mutex_lock(&dev->lock);
 
-	/* if the device is not opened, then we clean up right now */
-	if (!dev->open_count) {
-		mutex_unlock(&dev->lock);
-		tower_delete(dev);
-	} else {
-		dev->disconnected = 1;
+	dev->disconnected = 1;
+
+	if (dev->open_count) {
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);
-		mutex_unlock(&dev->lock);
 	}
 
+	mutex_unlock(&dev->lock);
+
+	kref_put(&dev->kref, tower_delete);
+
 	dev_info(&interface->dev, "LEGO USB Tower #%d now disconnected\n",
 		 (minor - LEGO_USB_TOWER_MINOR_BASE));
 }


