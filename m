Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDB71F76A4;
	Tue,  3 Dec 2024 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242045; cv=none; b=G7GRwI+KyGacClDKctkx7VNtILVBYglRacxP70VZ/q4sS/0STCnEIxRp3y/zoqlhF3uEY6TrCyMOAOej+8EXCPmZFzO6LhwB0r2RF7JqpQy53ypEsMPsFhZPbtjSXWC08T+foRy/V1SqkvS5Ng5on1ziPoktI9tjSU8SXQva25M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242045; c=relaxed/simple;
	bh=OX1nc8qCkde9FqIpP+RRI5UKcKFCKEbj+P5LxoDBSRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zc07hdXiAHATpLHk9Qp6vDDGv7Lk7iOoqLWMspejv0Upk87Yc31qfxisd2/nb2f8ThmVcNUXJMJW9SxfdYqHtQrCypukc5KD+gfwot0x2QvaKB65l7qIsRH/DYG/0P34RCDL/9xyoqz0D15KnpJN8v/80LtsdRfXqclGaX6B7Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+ZMIHmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+ZMIHmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B622C4CECF;
	Tue,  3 Dec 2024 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242045;
	bh=OX1nc8qCkde9FqIpP+RRI5UKcKFCKEbj+P5LxoDBSRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+ZMIHmYdEeLn+nxLs8HxnvqXPWlt8Si0W0vLTmIhMlMtP8eY2ffTnq33gBD/7OvC
	 i5BrBJ86PQrFteDfqEdaovo2t/zzeGZK9zT9G1ITnuRYAeLneP/O0NIP3wit/QXBo6
	 JBXIG7dss25dgm7+S1qmKjh+3c7Zq2LNkFvILH3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 592/826] usb: yurex: make waiting on yurex_write interruptible
Date: Tue,  3 Dec 2024 15:45:19 +0100
Message-ID: <20241203144806.848898242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a513766b4985d..365c100693458 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -911,7 +911,6 @@ static int iowarrior_probe(struct usb_interface *interface,
 static void iowarrior_disconnect(struct usb_interface *interface)
 {
 	struct iowarrior *dev = usb_get_intfdata(interface);
-	int minor = dev->minor;
 
 	usb_deregister_dev(interface, &iowarrior_class);
 
@@ -935,9 +934,6 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 		mutex_unlock(&dev->mutex);
 		iowarrior_delete(dev);
 	}
-
-	dev_info(&interface->dev, "I/O-Warror #%d now disconnected\n",
-		 minor - IOWARRIOR_MINOR_BASE);
 }
 
 /* usb specific object needed to register this driver with the usb subsystem */
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 6aebc736a80c6..70dff0db5354f 100644
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



