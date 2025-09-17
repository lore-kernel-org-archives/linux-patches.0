Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDA930BBB3;
	Wed, 17 Sep 2025 12:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113337; cv=none; b=V9h94+nDLsGnTFwK5vnwUX18yQkoP1I1js4+LIbyluok6zRgN61Li343iZKpP4CDAu1G2wWsk3vpg0y2utX16f+6x5THCPJcI81yOvp/VNbEFOyhruiTzu85PKJn1heRlkwfFn5GXqDiE3gvj+c8j9vukoH9fEIXCRDSX1ZGqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113337; c=relaxed/simple;
	bh=HCkF2agkF6CZcF1qDdVlRt+e55WuB5TyQrcOS2koOcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I0W6ehrW1nMbaShO3DDKfwcjGSHuV/rR+4aiDIH0w+dtTyGxpBZDo8zqrr7UdlA+IlDIgbizMp4z+FLzQWEGuCPZ0EGNG8+m0S/mtDZtVaEMsdpDTmLXAzHAJ/nbwtHYN2xQ2JAJFxRsg5Q6SRz8llQBF75S3OJqOoZ+gYH+BqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V97rp1GC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V97rp1GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C58AC4CEF7;
	Wed, 17 Sep 2025 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113337;
	bh=HCkF2agkF6CZcF1qDdVlRt+e55WuB5TyQrcOS2koOcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V97rp1GCFR4Q3zZEe9izpuZIqyttRScRku8eUiUYB2b9LcW8HR882hHf7YSxM8MT6
	 z6VcvPZJn5AAhjXfLGmFsT09MKlv7GTMl7WEwPv5n8nIjpIcIHIUrGHBAyOL+c8+aP
	 NIW/Avqk5ZgvqrY4suZvELqCX9MeBsaTg4OYuKrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Hubert=20Wi=C5=9Bniewski?= <hubert.wisniewski.25632@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Xu Yang <xu.yang_2@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 055/140] net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups
Date: Wed, 17 Sep 2025 14:33:47 +0200
Message-ID: <20250917123345.653871231@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


