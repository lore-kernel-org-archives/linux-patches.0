Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED724225409;
	Thu, 12 Dec 2024 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019818; cv=none; b=JBidrTDK0RTkPirYrfxb96Ip4XqcpVG3cVyXLirUhu4JTV4mYp855FrS/YFU/0LRqz3OKTed+O1w3vRoXUT/rO5RbXW/SkLxc5w38X90n8YKrAoZqkUOMkgh54QvsCDb3jHVCXSzh5jXboSP69n6WJi9/DjpKNMsedRRXWTvNfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019818; c=relaxed/simple;
	bh=eC0uQa2SuEzQZQ89v0NlPEjCWPLILXZ3r91a3JGFwIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdUXWMkrWbfzpc51v1Kr042FYYD81lQIKKGkJbhcOifZUB/RyWKLkxb4ADrwTdGNF8iKsx+knJEeZQz8kIepdMbm41HBxvFbmYvRBLvVAGQF0vXMrulB2jwOTXQRhz7a8rfF/tyTs9U/hiyLTBasaSDyW4k7AjzCygIDoVfTb7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NU9SkjZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NU9SkjZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FD4C4CECE;
	Thu, 12 Dec 2024 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019816;
	bh=eC0uQa2SuEzQZQ89v0NlPEjCWPLILXZ3r91a3JGFwIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NU9SkjZJjE9C+tgvcIllyKjktda89WREs11bINZzjv1Xqz8PkP1kXyRqD3Cw5zboe
	 2vZ2MEmvOCA2kfdpjehHO8PoyoIv5Rzp7RfrJnXfKCRzakXWyOyhavfJ8W+mYMlRS5
	 lw2/VmNXD2nmalKCK/MvHPCj7vuGfaQrbx7ynxOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghuram Chary J <raghuramchary.jallipalli@microchip.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 306/772] net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device
Date: Thu, 12 Dec 2024 15:54:11 +0100
Message-ID: <20241212144402.543017644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit ae7370e61c5d8f5bcefc2d4fca724bd4e9bbf789 ]

Add calls to `phy_device_free` after `fixed_phy_unregister` to fix a
memory leak that occurs when the device is unplugged. This ensures
proper cleanup of pseudo fixed-link PHYs.

Fixes: 89b36fb5e532 ("lan78xx: Lan7801 Support for Fixed PHY")
Cc: Raghuram Chary J <raghuramchary.jallipalli@microchip.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20241116130558.1352230-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index b18afd2c7aeed..ee3c13bbf6c02 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2387,6 +2387,7 @@ static int lan78xx_phy_init(struct lan78xx_net *dev)
 		if (dev->chipid == ID_REV_CHIP_ID_7801_) {
 			if (phy_is_pseudo_fixed_link(phydev)) {
 				fixed_phy_unregister(phydev);
+				phy_device_free(phydev);
 			} else {
 				phy_unregister_fixup_for_uid(PHY_KSZ9031RNX,
 							     0xfffffff0);
@@ -4246,8 +4247,10 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 
 	phy_disconnect(net->phydev);
 
-	if (phy_is_pseudo_fixed_link(phydev))
+	if (phy_is_pseudo_fixed_link(phydev)) {
 		fixed_phy_unregister(phydev);
+		phy_device_free(phydev);
+	}
 
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
-- 
2.43.0



