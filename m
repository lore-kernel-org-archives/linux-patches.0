Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFA01A3142;
	Tue, 15 Jul 2025 13:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586087; cv=none; b=Ticbi9eBCbFOr2lmLuVAOU5J8DrmBjP4fteaSWPZGEXVWTfWH4JaDh7J0WYlrZnQNXnDEn4W0e2uIGhRRIne/YO2QMEfFH+CSNnVQPpL48eM4Y8+GIYkXfW0pJ0Vk4DoKMk8EdnkYpquJaKtMnuvHGjpVOvZe1NjRdBI1UIGkpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586087; c=relaxed/simple;
	bh=ZtQODZ5H+6aQ/JnaFUMcPbGRpPAlOtB0C5FfU/XDjv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcZTW37puPW746Ff9O3uTAnM5czO7y/0c8uGIFnnEJefdsWmBuM8QBw62wx2vMEN7KKiDcnvXEw/tBHAJM9Ate1PXJWSXGI1b7GJoHjFH8REuNyObYTPu8dEtQgL23QAxn513yrEVzbO+DHhlu9PdIkdMhigDkQlX76+KKMDwvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSrzZ6Ti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSrzZ6Ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3E5C4CEE3;
	Tue, 15 Jul 2025 13:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586086;
	bh=ZtQODZ5H+6aQ/JnaFUMcPbGRpPAlOtB0C5FfU/XDjv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSrzZ6TiKpaD/zEJ6n/NhpZ1waAMzHvaJiS8vKIxcqtzgLzBaiAdrXPbwyHR4V8gu
	 D9Z8R2DE7G0wMSVrb1rsDrc1y+taa9Z2EQ6p8r/vONoMAjmNdx8UjQvne9u5qL8xiC
	 AYugQ/sU2QuG0dDmKJajj7Xhuk0KQXHI6naGZTZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andre Edich <andre.edich@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/77] net: phy: smsc: Fix link failure in forced mode with Auto-MDIX
Date: Tue, 15 Jul 2025 15:13:10 +0200
Message-ID: <20250715130752.147241292@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 9dfe110cc0f6ef42af8e81ce52aef34a647d0b8a ]

Force a fixed MDI-X mode when auto-negotiation is disabled to prevent
link instability.

When forcing the link speed and duplex on a LAN9500 PHY (e.g., with
`ethtool -s eth0 autoneg off ...`) while leaving MDI-X control in auto
mode, the PHY fails to establish a stable link. This occurs because the
PHY's Auto-MDIX algorithm is not designed to operate when
auto-negotiation is disabled. In this state, the PHY continuously
toggles the TX/RX signal pairs, which prevents the link partner from
synchronizing.

This patch resolves the issue by detecting when auto-negotiation is
disabled. If the MDI-X control mode is set to 'auto', the driver now
forces a specific, stable mode (ETH_TP_MDI) to prevent the pair
toggling. This choice of a fixed MDI mode mirrors the behavior the
hardware would exhibit if the AUTOMDIX_EN strap were configured for a
fixed MDI connection.

Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Andre Edich <andre.edich@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250703114941.3243890-4-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 6d9069a53db1d..5c3ebb66fceb5 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -143,10 +143,29 @@ static int lan911x_config_init(struct phy_device *phydev)
 
 static int lan87xx_config_aneg(struct phy_device *phydev)
 {
-	int rc;
+	u8 mdix_ctrl;
 	int val;
+	int rc;
+
+	/* When auto-negotiation is disabled (forced mode), the PHY's
+	 * Auto-MDIX will continue toggling the TX/RX pairs.
+	 *
+	 * To establish a stable link, we must select a fixed MDI mode.
+	 * If the user has not specified a fixed MDI mode (i.e., mdix_ctrl is
+	 * 'auto'), we default to ETH_TP_MDI. This choice of a ETH_TP_MDI mode
+	 * mirrors the behavior the hardware would exhibit if the AUTOMDIX_EN
+	 * strap were configured for a fixed MDI connection.
+	 */
+	if (phydev->autoneg == AUTONEG_DISABLE) {
+		if (phydev->mdix_ctrl == ETH_TP_MDI_AUTO)
+			mdix_ctrl = ETH_TP_MDI;
+		else
+			mdix_ctrl = phydev->mdix_ctrl;
+	} else {
+		mdix_ctrl = phydev->mdix_ctrl;
+	}
 
-	switch (phydev->mdix_ctrl) {
+	switch (mdix_ctrl) {
 	case ETH_TP_MDI:
 		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_;
 		break;
@@ -172,7 +191,7 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 	rc |= val;
 	phy_write(phydev, SPECIAL_CTRL_STS, rc);
 
-	phydev->mdix = phydev->mdix_ctrl;
+	phydev->mdix = mdix_ctrl;
 	return genphy_config_aneg(phydev);
 }
 
-- 
2.39.5



