Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBF125F963;
	Thu, 17 Apr 2025 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915151; cv=none; b=MKeZV3oPRiSt1JkSurIcohbejb//PTWLh/5JQByM+UXk41qsHdq8cruVg6Yrfa1C3+lMB8eC2VGN1OkaWPDcO5JdyA6wus/VOdNtoKjqShmApv9q6mJJ/8CXDYNdt2wTlCFxr0NapEivP8bbu29OjNBe7ZLkt/xSILcuTAAGLk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915151; c=relaxed/simple;
	bh=mQlHhTR9w+r37Qvzx84myt6KRGHdPw/ywlYMY0WYTYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHmpgO/dyW81fZmGWik1aPOZHkaS5Td8iyKR9arYOkWDB5Gj737O47YwF0xgSD7kgdLgP38LP3vyebgQjbAVlybEM4QNe3CO4IQf9eyDq7DdPHg5ITy3lHp6PtdEuvYZIzlyKCWQECs/4uCWo4pvDJTx8p1H9bHJOp4mOekD7To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwF59Ucf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwF59Ucf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BED4C4CEE4;
	Thu, 17 Apr 2025 18:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915151;
	bh=mQlHhTR9w+r37Qvzx84myt6KRGHdPw/ywlYMY0WYTYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwF59UcfyaTgjdhCXLVR3mQpObHhpiKCSmrbd1rX7PH8tIVA2791P8Z1lbDW46R6H
	 sML5JUx7DvipsvF0qXD9r948YAOipNAoLSqomiXM0I5C13cAtTTzCtAKdKTVSq3H5/
	 vciHv8OjPFBGJTv+6cNOjNQoJVXjO48u8YhmexFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/393] net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()
Date: Thu, 17 Apr 2025 19:47:24 +0200
Message-ID: <20250417175109.008780263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 119dfa2d6643a..44aa67fd544dc 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -289,6 +289,19 @@ static bool phy_drv_wol_enabled(struct phy_device *phydev)
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
@@ -1101,19 +1114,6 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
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



