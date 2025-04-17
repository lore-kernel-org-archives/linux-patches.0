Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F5C256C95;
	Thu, 17 Apr 2025 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912610; cv=none; b=cWQ4kOnWubxuK5xHXws18FmnTBBr1czf9Zvg5WcYl536ODeEwXQUNzgpmKCaVbcxFBfOaB+xQIdl5PP0c6cVl4wYujkbjUBxNPydaSP0NAphQRJKdA0a2+oKgDv5JtITQbAdUAY3d+LxJKRy0BmnvtLQ5Gp3ZI2uaPYoJHwbhBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912610; c=relaxed/simple;
	bh=k0G9y/OrM/X5RnjpcG53268cFgZi0kV15qXRSk5HWkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIH9zXoGCNJoLITddp2TVZ3TJjsY1vJT8H/xssfs3WeY48lKNwIjHgEUizCHkiHO97DRwHi6ruDVYs8Icc0ANN+d07W5wrA+GCDINnyqWW/Aq4/91jbMz6CJoFeRd96s3iAiSoX7Kup4sZpwSe3/Cl3kW6eBo0sNwwgobqNPiWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHPvg20H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHPvg20H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C87C4CEEA;
	Thu, 17 Apr 2025 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912610;
	bh=k0G9y/OrM/X5RnjpcG53268cFgZi0kV15qXRSk5HWkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHPvg20Hu2YG0hgTDWybWKM+5M+wl0RtoRHenKBqWf/prDd43NV3ASZks0tNsgB5s
	 sDdruBbnkA/RsdjbT9owgrAtpgOUrVCGaSUYHCSnQ6HmKKyGT/d/XdAFgRlLgZwEts
	 KWhk4P9y0mqmTHiN7hYUFls3jDQRahg3hxTWAbps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 038/449] net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()
Date: Thu, 17 Apr 2025 19:45:26 +0200
Message-ID: <20250417175119.527106875@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f40a673d6b4a128fe95dd9b8c3ed02da50a6a862 ]

In an upcoming change, mdio_bus_phy_may_suspend() will need to
distinguish a phylib-based PHY client from a phylink PHY client.
For that, it will need to compare the phydev->phy_link_change() function
pointer with the eponymous phy_link_change() provided by phylib.

To avoid forward function declarations, the default PHY link state
change method should be moved upwards. There is no functional change
associated with this patch, it is only to reduce the noise from a real
bug fix.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250407093900.2155112-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: fc75ea20ffb4 ("net: phy: allow MDIO bus PM ops to start/stop state machine for phylink-controlled PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 46713d27412b7..27d61d95933fa 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -240,6 +240,19 @@ static bool phy_drv_wol_enabled(struct phy_device *phydev)
 	return wol.wolopts != 0;
 }
 
+static void phy_link_change(struct phy_device *phydev, bool up)
+{
+	struct net_device *netdev = phydev->attached_dev;
+
+	if (up)
+		netif_carrier_on(netdev);
+	else
+		netif_carrier_off(netdev);
+	phydev->adjust_link(netdev);
+	if (phydev->mii_ts && phydev->mii_ts->link_state)
+		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
+}
+
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 {
 	struct device_driver *drv = phydev->mdio.dev.driver;
@@ -1052,19 +1065,6 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
 }
 EXPORT_SYMBOL(phy_find_first);
 
-static void phy_link_change(struct phy_device *phydev, bool up)
-{
-	struct net_device *netdev = phydev->attached_dev;
-
-	if (up)
-		netif_carrier_on(netdev);
-	else
-		netif_carrier_off(netdev);
-	phydev->adjust_link(netdev);
-	if (phydev->mii_ts && phydev->mii_ts->link_state)
-		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
-}
-
 /**
  * phy_prepare_link - prepares the PHY layer to monitor link status
  * @phydev: target phy_device struct
-- 
2.39.5



