Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDAF324B1F;
	Wed,  8 Apr 2026 18:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672429; cv=none; b=h7HIJvEMBUSPmFLln/Y7YH5co7jbvyP7fy7Zciu2/aWzvEWjUqBwuKlbSZfDMTLfHVTeTCwW5X3pM3AGODzAWSXhaSfAkNStHhamMOWylGQY1QxaBhREkm04d9pPkNeuCIUkmtkZEjuZex4xvjg2Odc148BRWtlI//f86Loogt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672429; c=relaxed/simple;
	bh=eE7ZUcllrQ+WBKs+VykX7iIMEAlB84d7jz1Ji4psPz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leeFT5k1HIzn8cg+W6oKzKpwR7lPdXtH5vNuJfEGEkckI5ej1bVzkoYTaCQ7bFV7raVN/QVwSVwNa9hDP5KCmiidLaDteVec+L13HWMoXHNtRY9gTL0v9ZZOOQ/a14BQIvcUKPml+SMgT3PyWYyMGQzlBzdSMpziW5aLmCV3mUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T33WDJgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T33WDJgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ACAC19421;
	Wed,  8 Apr 2026 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672429;
	bh=eE7ZUcllrQ+WBKs+VykX7iIMEAlB84d7jz1Ji4psPz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T33WDJgQfq1k8LfkkeyNMOM+OAh9D5myalwMy4G7VueMqrm+0U05PENUfIelsEqot
	 xif5LShCqpxMYhJreeUfZXVTYzsgDfvcl/5WBnLt5L+r/XwRPSKsY1THZ8KxJH85jQ
	 9uvzmLcCC4nF0TieyHG+ZIbWeE46HUnV0B3Vwu/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.1 302/312] net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()
Date: Wed,  8 Apr 2026 20:03:39 +0200
Message-ID: <20260408175945.051517304@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Minor context change fixed ]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

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
@@ -1036,19 +1049,6 @@ struct phy_device *phy_find_first(struct
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


