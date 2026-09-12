Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F14F331EC0;
	Sat, 12 Sep 2026 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223039; cv=none; b=jvT/WXdPbTL8BVOb1W5IkmvFbg2UoAysMCYP04B0KzkMKlDVuqM3Gs1MNEcziCpeB3xz1WtV/nQ9twi/iFKiSuRzaRs39wQyEiFBhcKJ4kmnM0xXr+/8PhN3SVHFitVsxSkWVo52LN9B/jGQY6TnYUgL1zQLASkXS6kiRZ1jiPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223039; c=relaxed/simple;
	bh=K4jBe+d+V1najhz/n9Bc/Hi/hb3Kd4Rc5ENUmVW+bo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzSnh/BrskTtRDV7KtJGQ7YsDEG24g4jKaOBmBFaUXXl5wNbAW0y0uoTiTo8MB8tidOL2vSh9k5LlKLn9AYYCPW0YCUX6Z7pa51ehmhT6A/gE6V1JA48gW1pO8t0k7sPKX8fR/7xtClrSvGo3TtqmPWHOGA6LzxtLh8x1XsfSwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVv6pXER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVv6pXER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDBA1F000FF;
	Sat, 12 Sep 2026 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223038;
	bh=wUFqCHIPK5iOGRTDs1PygsOpb0cj6y9DYTK/ykJjOLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVv6pXERBaSkISDeMfZQjlpjUtHlcbvFY00T3G1GGXsMJtXW0Wv21aL45AignYWr0
	 s/kmil1gsIMVJJU7kPvs2e6oXvIT6jQ5l8+M5KAnR/4c7hnzUHoUjRE+ZH8NFBbYxs
	 WcZLEpQJVyvBFv3goXSXeiXfvbzfUnS1FUaFb/Kw=
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
Subject: [PATCH 6.6 0707/1424] USB: make to_usb_driver() use container_of_const()
Date: Sat, 12 Sep 2026 08:52:19 +0200
Message-ID: <20260912065623.132617070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b0181fd4bdce7..2b2eb04b57f4a 100644
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
index 21358e1600216..502a2f4f13bae 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1239,7 +1239,7 @@ struct usb_driver {
 	unsigned int disable_hub_initiated_lpm:1;
 	unsigned int soft_unbind:1;
 };
-#define	to_usb_driver(d) container_of(d, struct usb_driver, driver)
+#define	to_usb_driver(d) container_of_const(d, struct usb_driver, driver)
 
 /**
  * struct usb_device_driver - identifies USB device driver to usbcore
-- 
2.53.0



