Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB7C1F76AD;
	Tue,  3 Dec 2024 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239396; cv=none; b=akBaASfpXtv29hyWby7YIt59q7TuAc4SM5gNGnXVkE1MsghLi/Dr7i0f7Hd2QhtWsZLpV11yhcBqyGbIp8azcdof6F/+isFklAvnKTqOHfoVID8ufyEP1zG0TCHohAZM/cTlSUAdrMS5qo/JrISs/n4ANcj1MnHSjxH2sNJCRgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239396; c=relaxed/simple;
	bh=RrNLYDp50Ty7TgNsqnmYHB5rcCzpojr2fNgUJBIAQlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSBQXvxVbzdFp55Ir5GriImE8j1TLob+guhFEukUwZp1nv511wCKOKpupInCS5XyrQ3HWxBLArVQjvHi0tNuXlhEoY0WvPZqdO6bcmUa8/KVWVeqIpKlXzrNvasCayhaniKaUSNVA9kFC9MzXSso0Ingrz5tlda9i3/aHiwG5ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjshTyJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjshTyJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8982CC4CECF;
	Tue,  3 Dec 2024 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239395;
	bh=RrNLYDp50Ty7TgNsqnmYHB5rcCzpojr2fNgUJBIAQlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjshTyJjlFBl4KuB0a2xnvPig2A8xuXEj8XBeU+IhVHkTagjwU8+WKQ0inYYPK4Tz
	 cic7Gry99qXA25dG/fO022A4iPfjeVFC8uMSPI4S0O2grA2jbbRPQ92tshQVsmJnmv
	 5aYz4y43B2V7pdU2Vh3BhV9noa6YImfxekFfCkuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 599/817] usb: yurex: make waiting on yurex_write interruptible
Date: Tue,  3 Dec 2024 15:42:51 +0100
Message-ID: <20241203144019.308230820@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 7c12b937d0759..bd94bf078de3b 100644
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



