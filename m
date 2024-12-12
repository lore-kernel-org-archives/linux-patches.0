Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137AE223E93;
	Thu, 12 Dec 2024 16:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022721; cv=none; b=ArfAlxjXVFHzKgUK8sE1LsQDia9qMY11y0U4exj3nAlh5yFo+VKfu/WqvNZCHC46xlC/fHkarOzGZ7oPC16bi+YVDud0ijdOVu+j0kCrr5FzIn2w5w/wWAd6IpYehcvtV/4iGUVwyjoD+NA6t+gfA2fwPhf0DoVvaPEC5zXJ3GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022721; c=relaxed/simple;
	bh=v3BU3+9ehBaaUTOVS74vQxwZTGEb6fuadN1FEqUi6c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9KWJ6fqU/7MoR+uM0FDlTMCJKnttjf6nzSt9LVnKIgy7cD+8l4M+oiXTsun8XE5mNs10WXaCTg9KF2yR7UAQm8ioICZQFzCE+8xuXClvfnaTCIPCRb4xb+S628G4yFG/68VYaqTBOsTI2s4KVmVgNiKwc6qAnw1GNFpbPkWTJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkEVOVl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkEVOVl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71584C4CECE;
	Thu, 12 Dec 2024 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022720;
	bh=v3BU3+9ehBaaUTOVS74vQxwZTGEb6fuadN1FEqUi6c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkEVOVl5JsNoHUUkMYxpgYsvym4zWGkKgalIHbFf1DjyAcj9+WcC4RlmfR+tihRo2
	 LJynyzXtSlnLRNvjTPfUNla6txyoTP5EXem52vnpdEvDklJrZ9+FTpVjL4NJ2paw/B
	 Hhlkd7ZH8m31Ckfe1s+gyf05Qy45soKNzEc6jS80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/565] usb: yurex: make waiting on yurex_write interruptible
Date: Thu, 12 Dec 2024 15:58:03 +0100
Message-ID: <20241212144322.845400648@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2fde8dd0b3e21..5606c5a2624a7 100644
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



