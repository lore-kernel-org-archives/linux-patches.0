Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646F1337EB4;
	Wed, 17 Sep 2025 12:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112890; cv=none; b=FHRhd9qMM5fYYMAFWhSt9Eb2UITtG1QBxdlatw2lrbvlYh1IEawy57znHWrWuJQ/I7KxAVHGw76EWYY7PaIf44kkQJlMWLH+FxaT2XNE0VfWb6R3zDXwQzxGhD0FgfGsdrhkQtwjADh3Hu8XxuuV2AV7kkgj5RYm4Sh3tQEMlKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112890; c=relaxed/simple;
	bh=7xPE+CFnaylDUP0DzFMA+ZP3z1ao3oW+NVeAPBeB4rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BhYDBIzjuxaya6vNYe7/FlQEL9xb7rEX04jOE1Qji3d7it95b2XOFZfYozLGW9jMS73ED/4YmdEipNkIL9E9Y04k0tK1enm9UFrPcbW8vdf8HArQanmzlR2ddV+r+Solr5ucfB+U8SSyI4aSQ2gRYyqpO17mtpV4CCUZIES4uuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hg8PC8JF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hg8PC8JF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5223C4CEF0;
	Wed, 17 Sep 2025 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112890;
	bh=7xPE+CFnaylDUP0DzFMA+ZP3z1ao3oW+NVeAPBeB4rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hg8PC8JFF6XjwiykET/qDJdNqa2kMoBQlmzv6wRMSzY75b4guri2zvsvipIuNx7lL
	 jVuWDTt0kjukD3V0WshpV2dXfOCehmcsTUcthlxDUndCF0SXzpasroHgcLHL9yR11J
	 IOqJSVa2Z9hOXs7bhCjCQb5UKtdI7oRbO8suuiGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Hubert=20Wi=C5=9Bniewski?= <hubert.wisniewski.25632@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Xu Yang <xu.yang_2@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 063/189] net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups
Date: Wed, 17 Sep 2025 14:32:53 +0200
Message-ID: <20250917123353.409761498@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/usb/asix_devices.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -607,15 +607,8 @@ static const struct net_device_ops ax887
 
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
@@ -644,12 +637,6 @@ static void ax88772_resume(struct usbnet
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


