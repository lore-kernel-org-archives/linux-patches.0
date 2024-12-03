Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FE91EE029;
	Tue,  3 Dec 2024 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236710; cv=none; b=h0zsSXGotXvpvA35AwP4Ydi1tAWw2VC3plzR40PVG9ZuiZkUHHCZo4knRZgOUBJh7MrS2i69W82O6NkdVQ5yfR0qJsvjFdXNnOg3MPn73DS6qfsdVtyB8WVWeqx8cRr3WVQMGbg4Xjch91hG0orYh0J0cykpXuWQVgBOQpIOehg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236710; c=relaxed/simple;
	bh=aukljZkplC27LGEAvNcXeEQMR73QrRM/ycenkvkKSls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKLXh1fpuDkFNIoB34nrWeHBKxGnVJtALAPr+rIkl1QUyR10pS1ihewGNQaRGXGHkZn0A/CrEVFhTiwX57o6/17cre/yOqKZpfuOliLfVN63YBOMvBK9qajwupMuaU+V1Nbjc8quH1B0BJgOkxCrEBBZz1MVz6Q7pp/PLLVpytw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukHn+rCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukHn+rCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA460C4CECF;
	Tue,  3 Dec 2024 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236710;
	bh=aukljZkplC27LGEAvNcXeEQMR73QrRM/ycenkvkKSls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukHn+rCl0OguRaHWXie+c/kDrdrREQRZcX0keW+0IDMiu7vIRjadJj3bBaGiuy86g
	 bwptS7ipgQX5K9nP9hMXHAC+GADa+Q+v6bqYsq9tTuol82pfo33l3ZYwJadTgiA9wN
	 25OS5fLNLNYRUu8GkJiy8Da3YnCXdkI4hYdJEBX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+422188bce66e76020e55@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/138] USB: chaoskey: fail open after removal
Date: Tue,  3 Dec 2024 15:32:04 +0100
Message-ID: <20241203141927.200234826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



