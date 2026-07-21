Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAB444AB76;
	Tue, 21 Jul 2026 21:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668429; cv=none; b=oIKLlcC6AkP8/2JSDXT7VnX/Jvk8v/xke8eTImSVE3nBs7HQAbObkRIYyCepZjKqSOxzETRIapx854HjxO9j7AHfYlJNN+IXXPfLpg1MkWn3BK3fG/aHrHT2n6ZCGGAbj633hQA5kQZzhoGpax2ciFsgsJ0uYj9tJeP/3QZc/ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668429; c=relaxed/simple;
	bh=gA2z9UULytr9+ml0vBXug4qtmxUtDObI3plIiMyfHhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTQB4PyEaTLBaTcptYklW09t7bR65jTi7F8D7EX/qmXt306O8lMwoU140KAG69NrMP3cG80eNonAUyYnrBMAiJbCAKK0amhV7vOSogR0f1HRte2cR0bPcTX0RY3Rm1J03o40IKYb7ULTjQbY1pWw3QgEAZLDvOeSQAyGoouuw2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZtQfYGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZtQfYGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7E31F000E9;
	Tue, 21 Jul 2026 21:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668428;
	bh=dBE3DhNli/2wshYcPt9Qps+oEZUEki+kEW8O8UjVf7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZtQfYGx84qnY9LgOBH3UyCN0nCoa5FcUY1p5P1GnZIp16YZn4fYO5QGRdJPFk0Zl
	 vBzibYH1fCtqQezIHXPsoNSIfjUnHMonpEU0mO7eDyr4/mDS9t/RdKHE1AE3oUZbN3
	 JOh4dezLAbD5td8okeSuoohy4VPL/rmKURGc2Dss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0172/1067] USB: idmouse: fix use-after-free on disconnect race
Date: Tue, 21 Jul 2026 17:12:53 +0200
Message-ID: <20260721152428.438675158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ff002c153f9722caece3983cc23dc4d9d4652cb4 upstream.

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

Fixes: 54d2bc068fd2 ("USB: fix locking in idmouse")
Cc: stable@vger.kernel.org	# 2.6.24
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260622152612.116422-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/idmouse.c |   45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -63,6 +63,7 @@ MODULE_DEVICE_TABLE(usb, idmouse_table);
 
 /* structure to hold all of our device specific stuff */
 struct usb_idmouse {
+	struct kref kref;
 
 	struct usb_device *udev; /* save off the usb device pointer */
 	struct usb_interface *interface; /* the interface for this device */
@@ -209,8 +210,10 @@ static int idmouse_resume(struct usb_int
 	return 0;
 }
 
-static inline void idmouse_delete(struct usb_idmouse *dev)
+static inline void idmouse_delete(struct kref *kref)
 {
+	struct usb_idmouse *dev = container_of(kref, struct usb_idmouse, kref);
+
 	kfree(dev->bulk_in_buffer);
 	kfree(dev);
 }
@@ -254,6 +257,8 @@ static int idmouse_open(struct inode *in
 		/* increment our usage count for the driver */
 		++dev->open;
 
+		kref_get(&dev->kref);
+
 		/* save our object in the file's private structure */
 		file->private_data = dev;
 
@@ -277,16 +282,11 @@ static int idmouse_release(struct inode
 
 	/* lock our device */
 	mutex_lock(&dev->lock);
-
 	--dev->open;
+	mutex_unlock(&dev->lock);
+
+	kref_put(&dev->kref, idmouse_delete);
 
-	if (!dev->present) {
-		/* the device was unplugged before the file was released */
-		mutex_unlock(&dev->lock);
-		idmouse_delete(dev);
-	} else {
-		mutex_unlock(&dev->lock);
-	}
 	return 0;
 }
 
@@ -334,6 +334,7 @@ static int idmouse_probe(struct usb_inte
 	if (dev == NULL)
 		return -ENOMEM;
 
+	kref_init(&dev->kref);
 	mutex_init(&dev->lock);
 	dev->udev = udev;
 	dev->interface = interface;
@@ -342,8 +343,7 @@ static int idmouse_probe(struct usb_inte
 	result = usb_find_bulk_in_endpoint(iface_desc, &endpoint);
 	if (result) {
 		dev_err(&interface->dev, "Unable to find bulk-in endpoint.\n");
-		idmouse_delete(dev);
-		return result;
+		goto err_put_kref;
 	}
 
 	dev->orig_bi_size = usb_endpoint_maxp(endpoint);
@@ -351,8 +351,8 @@ static int idmouse_probe(struct usb_inte
 	dev->bulk_in_endpointAddr = endpoint->bEndpointAddress;
 	dev->bulk_in_buffer = kmalloc(IMGSIZE + dev->bulk_in_size, GFP_KERNEL);
 	if (!dev->bulk_in_buffer) {
-		idmouse_delete(dev);
-		return -ENOMEM;
+		result = -ENOMEM;
+		goto err_put_kref;
 	}
 
 	/* allow device read, write and ioctl */
@@ -364,14 +364,18 @@ static int idmouse_probe(struct usb_inte
 	if (result) {
 		/* something prevented us from registering this device */
 		dev_err(&interface->dev, "Unable to allocate minor number.\n");
-		idmouse_delete(dev);
-		return result;
+		goto err_put_kref;
 	}
 
 	/* be noisy */
 	dev_info(&interface->dev,"%s now attached\n",DRIVER_DESC);
 
 	return 0;
+
+err_put_kref:
+	kref_put(&dev->kref, idmouse_delete);
+
+	return result;
 }
 
 static void idmouse_disconnect(struct usb_interface *interface)
@@ -387,14 +391,9 @@ static void idmouse_disconnect(struct us
 	/* prevent device read, write and ioctl */
 	dev->present = 0;
 
-	/* if the device is opened, idmouse_release will clean this up */
-	if (!dev->open) {
-		mutex_unlock(&dev->lock);
-		idmouse_delete(dev);
-	} else {
-		/* unlock */
-		mutex_unlock(&dev->lock);
-	}
+	mutex_unlock(&dev->lock);
+
+	kref_put(&dev->kref, idmouse_delete);
 
 	dev_info(&interface->dev, "disconnected\n");
 }


