Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC389184E;
	Mon,  1 Dec 2025 11:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588633; cv=none; b=sSb3bTTJTxKpiWOn/ktu6wa8GCe+7igLdmrVpuGJK7z2g6jNnn54kisRzoE9UTzbB8VRCQZMOyjjW3mgX6DhtEOeIAM6O8kzrQiPv49WG1SMGyEGV8K4PAbPjyA/VxVwWW36PweRMmvESMPeBQvKBQaANaD1HbnOywhZsFrDPKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588633; c=relaxed/simple;
	bh=kxLFJIt/m3Zq9bUF4/s0vzHH3OsE7cI/RyQUEbrfNnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3cVzSCnUp05MTZNhhSE4HvBhJ2qarGGa0y7ngj88RcLL1QylWiQmGweg6CvMFdbUKvxSXZQvG1+eWvkJ/FYpGwrXkYd7hDBX48fQ8eASxN9y68hnt+93XK6PbU6/6qA+x6leYN8foRjYzMnqlrZVSPFvR7FbqwaWOK7HS+lrW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zv0Q+Epd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zv0Q+Epd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74115C116D0;
	Mon,  1 Dec 2025 11:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588632;
	bh=kxLFJIt/m3Zq9bUF4/s0vzHH3OsE7cI/RyQUEbrfNnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv0Q+EpdFBjHiZWFQxA9LLYb1oo1vpM7D7epdxZgdC0qTbaQhYZL3O2tVJqzRD8YS
	 tSZkHZu/4RRjEfGFBoguwGEoV5JNIY+LtWbVz7SqU2BpKZdVzJ6N7dbrYfpeZXke6E
	 qQpdl3OMVTz68sTNa2NgNckOawYhIWiK49+e6vdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/187] net: dsa/b53: change b53_force_port_config() pause argument
Date: Mon,  1 Dec 2025 12:23:43 +0100
Message-ID: <20251201112245.385782505@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 3cad1c8b49e93c62f27f4eb34e0ccfde92f4cdc0 ]

Replace the b53_force_port_config() pause argument, which is based on
phylink's MLO_PAUSE_* definitions, to use a pair of booleans.  This
will allow us to move b53_force_port_config() from
b53_phylink_mac_config() to b53_phylink_mac_link_up().

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b6a8a5477fe9 ("net: dsa: b53: fix resetting speed and pause on forced link")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index fea28b24a1a0b..4de302f20e4f3 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1041,7 +1041,8 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 }
 
 static void b53_force_port_config(struct b53_device *dev, int port,
-				  int speed, int duplex, int pause)
+				  int speed, int duplex,
+				  bool tx_pause, bool rx_pause)
 {
 	u8 reg, val, off;
 
@@ -1079,9 +1080,9 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 		return;
 	}
 
-	if (pause & MLO_PAUSE_RX)
+	if (rx_pause)
 		reg |= PORT_OVERRIDE_RX_FLOW;
-	if (pause & MLO_PAUSE_TX)
+	if (tx_pause)
 		reg |= PORT_OVERRIDE_TX_FLOW;
 
 	b53_write8(dev, B53_CTRL_PAGE, off, reg);
@@ -1093,22 +1094,24 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 	struct b53_device *dev = ds->priv;
 	struct ethtool_eee *p = &dev->ports[port].eee;
 	u8 rgmii_ctrl = 0, reg = 0, off;
-	int pause = 0;
+	bool tx_pause = false;
+	bool rx_pause = false;
 
 	if (!phy_is_pseudo_fixed_link(phydev))
 		return;
 
 	/* Enable flow control on BCM5301x's CPU port */
 	if (is5301x(dev) && port == dev->cpu_port)
-		pause = MLO_PAUSE_TXRX_MASK;
+		tx_pause = rx_pause = true;
 
 	if (phydev->pause) {
 		if (phydev->asym_pause)
-			pause |= MLO_PAUSE_TX;
-		pause |= MLO_PAUSE_RX;
+			tx_pause = true;
+		rx_pause = true;
 	}
 
-	b53_force_port_config(dev, port, phydev->speed, phydev->duplex, pause);
+	b53_force_port_config(dev, port, phydev->speed, phydev->duplex,
+			      tx_pause, rx_pause);
 	b53_force_link(dev, port, phydev->link);
 
 	if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
@@ -1170,7 +1173,7 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 	} else if (is5301x(dev)) {
 		if (port != dev->cpu_port) {
 			b53_force_port_config(dev, dev->cpu_port, 2000,
-					      DUPLEX_FULL, MLO_PAUSE_TXRX_MASK);
+					      DUPLEX_FULL, true, true);
 			b53_force_link(dev, dev->cpu_port, 1);
 		}
 	}
@@ -1260,7 +1263,9 @@ void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 
 	if (mode == MLO_AN_FIXED) {
 		b53_force_port_config(dev, port, state->speed,
-				      state->duplex, state->pause);
+				      state->duplex,
+				      !!(state->pause & MLO_PAUSE_TX),
+				      !!(state->pause & MLO_PAUSE_RX));
 		return;
 	}
 
-- 
2.51.0



