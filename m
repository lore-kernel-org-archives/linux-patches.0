Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6E215762;
	Thu, 12 Dec 2024 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024250; cv=none; b=NNofwh4AFNt6mRsE8VGmTq5PHpU1LuQFhTwnEfTOfsU8uSwz2nm37qTfIzQvGzB32ebOVtI6Kjzjp/TjjesB8hoND4fcZov553+Greg0pIa/W4YkPG1/tAbErWdrkZTKTUaa7hBx1VyGBldcSsleMq2k+1tRwJvJN4Qb0l32y08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024250; c=relaxed/simple;
	bh=xBjqdF7ATqdEdc+nTD5Ctew7brlR2L5PMeFryXaT5xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Za7cvs1/PM2+svNubB5SO5pxytqN0hk5cc9vpbjg5jerA5RGFZgTusSkb0r1bbJGU5bkQIzFNoU6Xf7ApPYyHmd7GyEXsjRTjp6QK+AnmJ0Cs4ILXkktkv4Gpb/Jk2+dPxLnFhyEbsCZIOSITQCJbpz4RNqZ393LkEqe1lSm+wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1oGxy+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1oGxy+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3040CC4CECE;
	Thu, 12 Dec 2024 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024250;
	bh=xBjqdF7ATqdEdc+nTD5Ctew7brlR2L5PMeFryXaT5xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1oGxy+nwjHJ0m/IcO0AcApwMOEnFmAC5iCrOXbARPyiUXNN4DPfe37PKi7C48ioW
	 7A7QmoL4AVZQ5uSiSLCf7p42kIwGfK0A1xP1nEU3pApIKu8lLxdKTN2ROXtYmgr4VE
	 qoYF/CczcsXqGHcOt7kNy7hGvRgpNtEdIvtthx28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+422188bce66e76020e55@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/459] USB: chaoskey: fail open after removal
Date: Thu, 12 Dec 2024 15:59:32 +0100
Message-ID: <20241212144302.814148945@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 422dc0a4d12d0b80dd3aab3fe5943f665ba8f041 ]

chaoskey_open() takes the lock only to increase the
counter of openings. That means that the mutual exclusion
with chaoskey_disconnect() cannot prevent an increase
of the counter and chaoskey_open() returning a success.

If that race is hit, chaoskey_disconnect() will happily
free all resources associated with the device after
it has dropped the lock, as it has read the counter
as zero.

To prevent this race chaoskey_open() has to check
the presence of the device under the lock.
However, the current per device lock cannot be used,
because it is a part of the data structure to be
freed. Hence an additional global mutex is needed.
The issue is as old as the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+422188bce66e76020e55@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=422188bce66e76020e55
Fixes: 66e3e591891da ("usb: Add driver for Altus Metrum ChaosKey device (v2)")
Rule: add
Link: https://lore.kernel.org/stable/20241002132201.552578-1-oneukum%40suse.com
Link: https://lore.kernel.org/r/20241002132201.552578-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/chaoskey.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/misc/chaoskey.c b/drivers/usb/misc/chaoskey.c
index 87067c3d6109b..32fa7fd50c380 100644
--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -27,6 +27,8 @@ static struct usb_class_driver chaoskey_class;
 static int chaoskey_rng_read(struct hwrng *rng, void *data,
 			     size_t max, bool wait);
 
+static DEFINE_MUTEX(chaoskey_list_lock);
+
 #define usb_dbg(usb_if, format, arg...) \
 	dev_dbg(&(usb_if)->dev, format, ## arg)
 
@@ -231,6 +233,7 @@ static void chaoskey_disconnect(struct usb_interface *interface)
 	if (dev->hwrng_registered)
 		hwrng_unregister(&dev->hwrng);
 
+	mutex_lock(&chaoskey_list_lock);
 	usb_deregister_dev(interface, &chaoskey_class);
 
 	usb_set_intfdata(interface, NULL);
@@ -245,6 +248,7 @@ static void chaoskey_disconnect(struct usb_interface *interface)
 	} else
 		mutex_unlock(&dev->lock);
 
+	mutex_unlock(&chaoskey_list_lock);
 	usb_dbg(interface, "disconnect done");
 }
 
@@ -252,6 +256,7 @@ static int chaoskey_open(struct inode *inode, struct file *file)
 {
 	struct chaoskey *dev;
 	struct usb_interface *interface;
+	int rv = 0;
 
 	/* get the interface from minor number and driver information */
 	interface = usb_find_interface(&chaoskey_driver, iminor(inode));
@@ -267,18 +272,23 @@ static int chaoskey_open(struct inode *inode, struct file *file)
 	}
 
 	file->private_data = dev;
+	mutex_lock(&chaoskey_list_lock);
 	mutex_lock(&dev->lock);
-	++dev->open;
+	if (dev->present)
+		++dev->open;
+	else
+		rv = -ENODEV;
 	mutex_unlock(&dev->lock);
+	mutex_unlock(&chaoskey_list_lock);
 
-	usb_dbg(interface, "open success");
-	return 0;
+	return rv;
 }
 
 static int chaoskey_release(struct inode *inode, struct file *file)
 {
 	struct chaoskey *dev = file->private_data;
 	struct usb_interface *interface;
+	int rv = 0;
 
 	if (dev == NULL)
 		return -ENODEV;
@@ -287,14 +297,15 @@ static int chaoskey_release(struct inode *inode, struct file *file)
 
 	usb_dbg(interface, "release");
 
+	mutex_lock(&chaoskey_list_lock);
 	mutex_lock(&dev->lock);
 
 	usb_dbg(interface, "open count at release is %d", dev->open);
 
 	if (dev->open <= 0) {
 		usb_dbg(interface, "invalid open count (%d)", dev->open);
-		mutex_unlock(&dev->lock);
-		return -ENODEV;
+		rv = -ENODEV;
+		goto bail;
 	}
 
 	--dev->open;
@@ -303,13 +314,15 @@ static int chaoskey_release(struct inode *inode, struct file *file)
 		if (dev->open == 0) {
 			mutex_unlock(&dev->lock);
 			chaoskey_free(dev);
-		} else
-			mutex_unlock(&dev->lock);
-	} else
-		mutex_unlock(&dev->lock);
-
+			goto destruction;
+		}
+	}
+bail:
+	mutex_unlock(&dev->lock);
+destruction:
+	mutex_lock(&chaoskey_list_lock);
 	usb_dbg(interface, "release success");
-	return 0;
+	return rv;
 }
 
 static void chaos_read_callback(struct urb *urb)
-- 
2.43.0



