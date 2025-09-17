Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F308632B;
	Wed, 17 Sep 2025 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114097; cv=none; b=GhnNwma/BcjIU1UIcYw6FAKzM2uAr1eY+i9+voslcXEdKsXk47RHtp8e65o1y9T/cr3VZnMJUqr5kDexW5TvjK9Vs1OTh9st/Rwmoy2VV/LWAPcPgXU1RlqpjYBZc5h3I1kV0Yg70EbvKJWKVgjMCOnTD1IPeymEsi135/iMO7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114097; c=relaxed/simple;
	bh=ATObmO7rJXKzz7yiX8iMzM9Kd86L9ixzway9rIdpqxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LZ1Bv2nJRh5Lv6yV4EJ1pzC94FnNpyGLlvkxJgByBR1v0LNf0/k2oscLfICVZyc9aOsihV4+cfDWqoz9jl7iafmmlmxKQJViVF6TIO2KJ+dOVqh35uP+ZoT9UBzSczx1ETrj7WxDIwgNpxBSgXtxEaI5BH31ar911LdIJSSXMGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npLT0p+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npLT0p+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B85C4CEF0;
	Wed, 17 Sep 2025 13:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114096;
	bh=ATObmO7rJXKzz7yiX8iMzM9Kd86L9ixzway9rIdpqxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npLT0p+JJWyeWJnu0Cu1nckgnCp7RabqvyYo4tuf+MguLZEn5Olhqry/eKZBnIYRr
	 hwsID/jxK51dBO9GN1z+hpJdEd0Ec4XUMDwLd2GypCW1MVxZ+k1bzs6zXfq57tZSaC
	 IZZrRw3zQDFlfeGBzy5SaYFr8MGNrAyQ4KejdHps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Hubert=20Wi=C5=9Bniewski?= <hubert.wisniewski.25632@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Xu Yang <xu.yang_2@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 28/78] net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups
Date: Wed, 17 Sep 2025 14:34:49 +0200
Message-ID: <20250917123330.249664186@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 5537a4679403423e0b49c95b619983a4583d69c5 upstream.

Drop phylink_{suspend,resume}() from ax88772 PM callbacks.

MDIO bus accesses have their own runtime-PM handling and will try to
wake the device if it is suspended. Such wake attempts must not happen
from PM callbacks while the device PM lock is held. Since phylink
{sus|re}sume may trigger MDIO, it must not be called in PM context.

No extra phylink PM handling is required for this driver:
- .ndo_open/.ndo_stop control the phylink start/stop lifecycle.
- ethtool/phylib entry points run in process context, not PM.
- phylink MAC ops program the MAC on link changes after resume.

Fixes: e0bffe3e6894 ("net: asix: ax88772: migrate to phylink")
Reported-by: Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Tested-by: Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20250908112619.2900723-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix_devices.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 792ddda1ad49..1e8f7089f5e8 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -607,15 +607,8 @@ static const struct net_device_ops ax88772_netdev_ops = {
 
 static void ax88772_suspend(struct usbnet *dev)
 {
-	struct asix_common_private *priv = dev->driver_priv;
 	u16 medium;
 
-	if (netif_running(dev->net)) {
-		rtnl_lock();
-		phylink_suspend(priv->phylink, false);
-		rtnl_unlock();
-	}
-
 	/* Stop MAC operation */
 	medium = asix_read_medium_status(dev, 1);
 	medium &= ~AX_MEDIUM_RE;
@@ -644,12 +637,6 @@ static void ax88772_resume(struct usbnet *dev)
 	for (i = 0; i < 3; i++)
 		if (!priv->reset(dev, 1))
 			break;
-
-	if (netif_running(dev->net)) {
-		rtnl_lock();
-		phylink_resume(priv->phylink);
-		rtnl_unlock();
-	}
 }
 
 static int asix_resume(struct usb_interface *intf)
-- 
2.51.0



