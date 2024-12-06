Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51040154BF5;
	Fri,  6 Dec 2024 15:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497904; cv=none; b=d3CA1a9EE73PZvU3HkbWVV6J4iq97JV0X8m2O2TuTPCauutcNQPJUPOd3+bKvv9adqSIvLe5wHxhtyY9kWsyaMygb4P3O1VGXwu1k5OchVocOmjbGnwshPpxhsxnTATIbFT6aJB3JWPOmIKf0pGvG0w5rRWDrND5kdhRATMj5GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497904; c=relaxed/simple;
	bh=afS9EBqEWYn4S3XNzgvKyNyCQEf59q89lIs6I0269HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct7B0Dwa2RzsiA24LLupTC67FFpWtSD+bcPQRXxdYufARlYX75OTYXYF4jc++VXP+T8GGM5hJ7yw6jkSKKIloTJk8D4PpfQH9ajYu5kus3Xymo2hs7h1VFuTo1RxOXzYNDtxb9cGRS7pmAaVibwIpr3zugVc3Xyc5Szt4CL2uUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfKOE/VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfKOE/VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B960DC4CED1;
	Fri,  6 Dec 2024 15:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497904;
	bh=afS9EBqEWYn4S3XNzgvKyNyCQEf59q89lIs6I0269HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfKOE/VYFASvkifFF4Ft85WiYmNSEIErL3HFBh4lcTfIevKkqpRLiGFpx89P5mJl9
	 V2ufc87qhDKALh8NPNpTxjrqri2zVxYwOdrAmuz6Q9KvLK79e+5nKrvw7CGQ3Cck5j
	 kR5OJrHGzQdNKOLa38HcmOa+tYch0Gu8i9qAt0eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 428/676] usb: yurex: make waiting on yurex_write interruptible
Date: Fri,  6 Dec 2024 15:34:07 +0100
Message-ID: <20241206143710.062148925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit e0aa9614ab0fd35b404e4b16ebe879f9fc152591 ]

The IO yurex_write() needs to wait for in order to have a device
ready for writing again can take a long time time.
Consequently the sleep is done in an interruptible state.
Therefore others waiting for yurex_write() itself to finish should
use mutex_lock_interruptible.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 6bc235a2e24a5 ("USB: add driver for Meywa-Denki & Kayac YUREX")
Rule: add
Link: https://lore.kernel.org/stable/20240924084415.300557-1-oneukum%40suse.com
Link: https://lore.kernel.org/r/20240924084415.300557-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/iowarrior.c | 4 ----
 drivers/usb/misc/yurex.c     | 5 ++++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 8cb78c0e2f415..4fae04094021e 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -912,7 +912,6 @@ static int iowarrior_probe(struct usb_interface *interface,
 static void iowarrior_disconnect(struct usb_interface *interface)
 {
 	struct iowarrior *dev = usb_get_intfdata(interface);
-	int minor = dev->minor;
 
 	usb_deregister_dev(interface, &iowarrior_class);
 
@@ -936,9 +935,6 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 		mutex_unlock(&dev->mutex);
 		iowarrior_delete(dev);
 	}
-
-	dev_info(&interface->dev, "I/O-Warror #%d now disconnected\n",
-		 minor - IOWARRIOR_MINOR_BASE);
 }
 
 /* usb specific object needed to register this driver with the usb subsystem */
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index c313cd41f7a5a..0eed614ac1273 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -441,7 +441,10 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
 	if (count == 0)
 		goto error;
 
-	mutex_lock(&dev->io_mutex);
+	retval = mutex_lock_interruptible(&dev->io_mutex);
+	if (retval < 0)
+		return -EINTR;
+
 	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
-- 
2.43.0



