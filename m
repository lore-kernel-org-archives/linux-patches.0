Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B9F41BA94;
	Sat, 12 Sep 2026 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229406; cv=none; b=B9PN1kpzSD//dn7QDZQRJAy6S4qm1QjijIoAHUG+EUYRjZ9mkzEthmthxCEyOuwoCfOxC32j76sxHjmr+zXka5mAyaww2P9ba2Cii191HI8hRUWATEtRuEVkhOP8P/lFH8Rl2uE6eXjuz2oTz5CCy8WwGHsi3BaPzjz9SnTpdKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229406; c=relaxed/simple;
	bh=nJUH6Vufgz2SRfEzutTpKtAcQZAILNDu4son0ZFmig4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeP60/tDieZElF6UKDqXMX2Xz41Oyky2tIPcBtCQlzJ0WOCZE+pSfkl5ejDE1zXWZJtSR7Ftm1AmWRzWx+qvKBE5q5Cgjd+yTTl/Qy7g0hM2LJ/PvO7qLrwkz6LeGioP6/ynGAmCbKwWTwz/tCeVmj35gfoZ+2MLrjpd+GGjnDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz2UwP7e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz2UwP7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE161F000FF;
	Sat, 12 Sep 2026 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229399;
	bh=/ZhxdHP4IFbS509NRCeFBIDsWQ8kuCyA1qER3k/LUkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pz2UwP7eSKoUIhXlCQEp1cyhYMRBtHGr3ixhzn8Du6Zc7q5J1DhMLIMVMDDDX9WTA
	 VIPwz8jYocxYtYNxlmiJY8qMcx+Zwg7hB0WhchIhitB3VbK02ukUSVOU72soQzZ7XH
	 1ktu6jICJZWFe/tc8c3kbKwzSfbHk7svoLkSBv8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Grant Grundler <grundler@chromium.org>,
	Yajun Deng <yajun.deng@linux.dev>,
	Oliver Neukum <oneukum@suse.com>,
	Douglas Anderson <dianders@chromium.org>,
	linux-usb@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0582/1191] USB: make to_usb_driver() use container_of_const()
Date: Sat, 12 Sep 2026 08:55:10 +0200
Message-ID: <20260912065601.317735439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 2f3aab7aecb827ba93c6222646eb0faa8228d590 ]

Turns out that we have some const pointers being passed to
to_usb_driver() but were not catching this.  Change the macro to
properly propagate the const-ness of the pointer so that we will notice
when we try to write to memory that we shouldn't be writing to.

This requires fixing up the usb_match_dynamic_id() function as well,
because it can handle a const * to struct usb_driver.

Cc: Johan Hovold <johan@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Grant Grundler <grundler@chromium.org>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: linux-usb@vger.kernel.org
Link: https://lore.kernel.org/r/2024111339-shaky-goldsmith-b233@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ef8154d8b52d ("usb: fix UAF when probe runs concurrent to dyn ID removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/driver.c | 4 ++--
 include/linux/usb.h       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index e875723ddef26..5cef1be3029a4 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -227,7 +227,7 @@ static void usb_free_dynids(struct usb_driver *usb_drv)
 }
 
 static const struct usb_device_id *usb_match_dynamic_id(struct usb_interface *intf,
-							struct usb_driver *drv)
+							const struct usb_driver *drv)
 {
 	struct usb_dynid *dynid;
 
@@ -873,7 +873,7 @@ static int usb_device_match(struct device *dev, struct device_driver *drv)
 
 	} else if (is_usb_interface(dev)) {
 		struct usb_interface *intf;
-		struct usb_driver *usb_drv;
+		const struct usb_driver *usb_drv;
 		const struct usb_device_id *id;
 
 		/* device drivers never match interfaces */
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 660a8b2c8338e..5c361d0c98076 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1208,7 +1208,7 @@ struct usb_driver {
 	unsigned int disable_hub_initiated_lpm:1;
 	unsigned int soft_unbind:1;
 };
-#define	to_usb_driver(d) container_of(d, struct usb_driver, driver)
+#define	to_usb_driver(d) container_of_const(d, struct usb_driver, driver)
 
 /**
  * struct usb_device_driver - identifies USB device driver to usbcore
-- 
2.53.0



