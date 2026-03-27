Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E1330DEB8
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 01:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774576487; cv=none; b=gAnIoFfe5np6Z+DRg+qoeOnHAXuNCRtp3fi8q84Mt90/+klFV8oYRHu9aqeCmmd7ixzQTlEkC46re+Hs/MjYZOKk5OyTPzkBqZ6FaHewFGQs76YEgwel46JdAiSm5k30Gi44oeC6MsGdfOae2a8I4LvTdHkf1z628E96XDlXD2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774576487; c=relaxed/simple;
	bh=ZqV+tRZXIY15nG5MUbhJ9kF9CsPGNZz/KgeQrtcorBM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KC9wtoaFES/8AI+FJN5voB27QuP/CAY5X5OHoGGZiJhQlcsbKLdsB5b04W3e43M87apzQzKxf8AOeIXzJKaYmLSRIUQbhpBaDsxs07G31bl06GFjiqL+bWaF6BANROisgm2fVh3I4tpnFh0V6CqAMkZxCS89jJrYA95zsRnAahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=3XiAAVNA; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="3XiAAVNA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=3XiAAVNADMJx0bKCLvOhGJSLsN2KhUSC6/qZT8qw6WVoLhOfCHMvqmzULics/bX4caTmO46HAaI95
	 LmAusC7XR8Eq2YVdAFGXv+V8J0A/uGkqq3EkXDwW0hlNyWNkKzP54zHy7eeW4AvWruk88+UDBWb+RT
	 4itDxmadmy/WDbXU=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-04-12082 (RichMail) with SMTP id 2f3269c5e29809b-010b3;
	Fri, 27 Mar 2026 09:51:22 +0800 (CST)
X-RM-TRANSID:2f3269c5e29809b-010b3
From: Rajani Kantha <681739313@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	vladimir.oltean@nxp.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	rmk+kernel@armlinux.org.uk
Subject: [PATCH 6.1.y 1/3] net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()
Date: Fri, 27 Mar 2026 09:51:20 +0800
Message-Id: <20260327015120.1712759-1-681739313@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
[ Minor context change fixed ]
Signed-off-by: Rajani Kantha <681739313@139.com>
---
 drivers/net/phy/phy_device.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 11839dca8f56..7d19857a6dc4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -234,6 +234,19 @@ static struct phy_driver genphy_driver;
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
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
@@ -1036,19 +1049,6 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
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
2.34.1


