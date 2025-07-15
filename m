Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F43D2EE96F;
	Tue, 15 Jul 2025 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587796; cv=none; b=fuO91bY6+HULM1k35DOlPY8Z999FUxzPewX3/5k9C/fvB3BZ6EP8gJGMiW/f8tv487YXMWUxyfUj7IBxR1h7nsQP0YkrQBZfAEb+y9OkvKkpBJjMT72WRw5AGWid7PW8rL5cuZZY0lJDFHBQmW6m4RHwOcHXM1DZ9cZa0MDTO9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587796; c=relaxed/simple;
	bh=8jbbk6U5wj/H5D8g9eUUfF+NCc96j9wdK3L3VvA2P9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIyqzO+LozD0Zb5TPJngprig2kz+hjivEse809AAi05RsDKvsaYlTgmTJtX9s81RhawKbnDtWGle1f1Hws7sQF/C8qoCZPu+qFdaUl2ojJjAhTF3OG6sAUm8wWKPKUgTco66Ik5XHJrbSjybrsJGoCw111okgqDSPL1mHjX3ysw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7agBmVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7agBmVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83ECC4CEFA;
	Tue, 15 Jul 2025 13:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587796;
	bh=8jbbk6U5wj/H5D8g9eUUfF+NCc96j9wdK3L3VvA2P9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7agBmVudbqXxbvxBfEkJe2sG/NEB4Y1tbtPZm4H1WnNqwRNGT9OOyrvAwHt7JXXv
	 5XaCOMLnNuLwCxJfwLlI90m87SJz5c+JRudLlZ+n5rYgAXnum349QR+nXOcOLot9Z2
	 5Ic4CliHQpbudYwZH4mOq0V6nmTe+O7yaJJRDhYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andre Edich <andre.edich@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/208] net: phy: smsc: Fix link failure in forced mode with Auto-MDIX
Date: Tue, 15 Jul 2025 15:14:16 +0200
Message-ID: <20250715130816.807546127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9ec2485df645e..d860a2626b13b 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -120,10 +120,29 @@ static int lan911x_config_init(struct phy_device *phydev)
 
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
@@ -149,7 +168,7 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 	rc |= val;
 	phy_write(phydev, SPECIAL_CTRL_STS, rc);
 
-	phydev->mdix = phydev->mdix_ctrl;
+	phydev->mdix = mdix_ctrl;
 	return genphy_config_aneg(phydev);
 }
 
-- 
2.39.5



