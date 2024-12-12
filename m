Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D161E13C918;
	Thu, 12 Dec 2024 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025331; cv=none; b=Mh6cW4I51W6BDEts9/6MrQQ30YFnxg+ZeUk1Vl7flunsKwrp0NHHWt3W2o0x/wkKcxlZ+VibPbbUsHtUhcMWC4rkgZLjzHSx6lxY2yp+5roriBPfv3nxjdJRpdIUKFZe6rbF5q4Ro7xoauBy4i8oNCSWRA8KGyMgL/OJZCiO7v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025331; c=relaxed/simple;
	bh=ETYhmcQuxkZSJhVsBU8uTS2Y8e55VvYq7A+G+frFaas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3OmIVBOtX7F+AH1Sx0Kfak6aHNG4pjq8tW0JGwR3SMJ+dyY6rsxDain1fa8AaBuLcv8pSta4SRfwRibQEPTmDePDgCLEWXelOiNqW8BSNKQaWGks4yhnkO818jCpOTbyHa3u+cH6rliGHmlB7EA8OdBeOfrs/H7rkInvDoLCPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXPDLH56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXPDLH56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F398C4CED0;
	Thu, 12 Dec 2024 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025331;
	bh=ETYhmcQuxkZSJhVsBU8uTS2Y8e55VvYq7A+G+frFaas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXPDLH56CWw4EDwKJ29DvR0yHMICFWL7bHzZUDatMzTz/9RMt0fZpO7RT29+MFnfq
	 qtSizFRz7OMROLNvJLJXxlerdEjyDZDWmYSZpX4NH2QK9fnZVvLwpOiqUT5zX8PlaI
	 d7MCjPVerey5HNi9fQbPcpvR05qGq/RZqsmdg7+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/321] usb: using mutex lock and supporting O_NONBLOCK flag in iowarrior_read()
Date: Thu, 12 Dec 2024 16:00:52 +0100
Message-ID: <20241212144235.274619401@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit 44feafbaa66ec86232b123bb8437a6a262442025 ]

iowarrior_read() uses the iowarrior dev structure, but does not use any
lock on the structure. This can cause various bugs including data-races,
so it is more appropriate to use a mutex lock to safely protect the
iowarrior dev structure. When using a mutex lock, you should split the
branch to prevent blocking when the O_NONBLOCK flag is set.

In addition, it is unnecessary to check for NULL on the iowarrior dev
structure obtained by reading file->private_data. Therefore, it is
better to remove the check.

Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://lore.kernel.org/r/20240919103403.3986-1-aha310510@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/iowarrior.c | 46 ++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index c366a65fbd802..f23291da25498 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -277,28 +277,45 @@ static ssize_t iowarrior_read(struct file *file, char __user *buffer,
 	struct iowarrior *dev;
 	int read_idx;
 	int offset;
+	int retval;
 
 	dev = file->private_data;
 
+	if (file->f_flags & O_NONBLOCK) {
+		retval = mutex_trylock(&dev->mutex);
+		if (!retval)
+			return -EAGAIN;
+	} else {
+		retval = mutex_lock_interruptible(&dev->mutex);
+		if (retval)
+			return -ERESTARTSYS;
+	}
+
 	/* verify that the device wasn't unplugged */
-	if (!dev || !dev->present)
-		return -ENODEV;
+	if (!dev->present) {
+		retval = -ENODEV;
+		goto exit;
+	}
 
 	dev_dbg(&dev->interface->dev, "minor %d, count = %zd\n",
 		dev->minor, count);
 
 	/* read count must be packet size (+ time stamp) */
 	if ((count != dev->report_size)
-	    && (count != (dev->report_size + 1)))
-		return -EINVAL;
+	    && (count != (dev->report_size + 1))) {
+		retval = -EINVAL;
+		goto exit;
+	}
 
 	/* repeat until no buffer overrun in callback handler occur */
 	do {
 		atomic_set(&dev->overflow_flag, 0);
 		if ((read_idx = read_index(dev)) == -1) {
 			/* queue empty */
-			if (file->f_flags & O_NONBLOCK)
-				return -EAGAIN;
+			if (file->f_flags & O_NONBLOCK) {
+				retval = -EAGAIN;
+				goto exit;
+			}
 			else {
 				//next line will return when there is either new data, or the device is unplugged
 				int r = wait_event_interruptible(dev->read_wait,
@@ -309,28 +326,37 @@ static ssize_t iowarrior_read(struct file *file, char __user *buffer,
 								  -1));
 				if (r) {
 					//we were interrupted by a signal
-					return -ERESTART;
+					retval = -ERESTART;
+					goto exit;
 				}
 				if (!dev->present) {
 					//The device was unplugged
-					return -ENODEV;
+					retval = -ENODEV;
+					goto exit;
 				}
 				if (read_idx == -1) {
 					// Can this happen ???
-					return 0;
+					retval = 0;
+					goto exit;
 				}
 			}
 		}
 
 		offset = read_idx * (dev->report_size + 1);
 		if (copy_to_user(buffer, dev->read_queue + offset, count)) {
-			return -EFAULT;
+			retval = -EFAULT;
+			goto exit;
 		}
 	} while (atomic_read(&dev->overflow_flag));
 
 	read_idx = ++read_idx == MAX_INTERRUPT_BUFFER ? 0 : read_idx;
 	atomic_set(&dev->read_idx, read_idx);
+	mutex_unlock(&dev->mutex);
 	return count;
+
+exit:
+	mutex_unlock(&dev->mutex);
+	return retval;
 }
 
 /*
-- 
2.43.0



