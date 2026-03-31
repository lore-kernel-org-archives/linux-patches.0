Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF972C15B2;
	Tue, 31 Mar 2026 16:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975834; cv=none; b=IYJ9tiB198vJ0DVD5cDLzq1wPO2Goza7ZvOJ8liSBZXjrdSaKIWdQVl28CX4gQEu/bksyxmKQe1/cCXb37mkeTtoAPWQnHEvglPIEOOWauRPn6/pL7WkGRXjW68Cmap9mR3Q+X7ceR0qUgLj9ohsuuC7vIqUDJu1rtky6ghBKN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975834; c=relaxed/simple;
	bh=xXJTqdcsBduwoT/8i14gqleV60GCgCku1kRc5Cf56TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVSeI0SAjNB4/RI2ij04+uhiLW7eMjZA9nJmoaLDWpjWTr843mW6VTps7298DgJEO+IH4ZUJ3gNmqCM3SYr/wihtUuNwW5wRuCbR2YLh+5MNVE7B0K0Z3UeAO7tPIWb9jZ3z/t8U6bPJ77T2RYyQoaF8rMoJ/jLRl4n3qF+2rX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrstdDJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrstdDJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E0CC2BCB3;
	Tue, 31 Mar 2026 16:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975834;
	bh=xXJTqdcsBduwoT/8i14gqleV60GCgCku1kRc5Cf56TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrstdDJecOB5jvwcTvxhfgOz+GBTXmLU2kaGDIycuPp3DtkTGxuDBWGo1zbquKoqy
	 qbmEvLeTHBscFvyG0e/41V+dJ0g8O+jur+NqNGzTyPDE/IObfK669iV0OFWjPetrF2
	 iCHrKSGt64gtZOB2y2CeeU2Xyx5XZEJfF7Fth19Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/244] net: bcm: asp2: fix LPI timer handling
Date: Tue, 31 Mar 2026 18:20:22 +0200
Message-ID: <20260331161744.346860747@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 54033f5512191fa355422d009f32923c1cf24aab ]

Fix the LPI timer handling in Broadcom ASP2 driver after the phylib
managed EEE patches were merged.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/E1tXk7r-000r4l-Li@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbfa5be2bf64 ("net: bcmasp: fix double free of WoL irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c | 2 --
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c    | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
index ca163c8e37297..256577f0f2170 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
@@ -371,7 +371,6 @@ static int bcmasp_get_eee(struct net_device *dev, struct ethtool_keee *e)
 		return -ENODEV;
 
 	e->tx_lpi_enabled = p->tx_lpi_enabled;
-	e->tx_lpi_timer = umac_rl(intf, UMC_EEE_LPI_TIMER);
 
 	return phy_ethtool_get_eee(dev->phydev, e);
 }
@@ -395,7 +394,6 @@ static int bcmasp_set_eee(struct net_device *dev, struct ethtool_keee *e)
 			return ret;
 		}
 
-		umac_wl(intf, e->tx_lpi_timer, UMC_EEE_LPI_TIMER);
 		intf->eee.tx_lpi_enabled = e->tx_lpi_enabled;
 		bcmasp_eee_enable_set(intf, true);
 	}
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 79185bafaf4b3..73e704352d820 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -674,6 +674,8 @@ static void bcmasp_adj_link(struct net_device *dev)
 		}
 		umac_wl(intf, reg, UMC_CMD);
 
+		umac_wl(intf, phydev->eee_cfg.tx_lpi_timer, UMC_EEE_LPI_TIMER);
+
 		active = phy_init_eee(phydev, 0) >= 0;
 		bcmasp_eee_enable_set(intf, active);
 	}
@@ -1052,6 +1054,9 @@ static int bcmasp_netif_init(struct net_device *dev, bool phy_connect)
 
 		/* Indicate that the MAC is responsible for PHY PM */
 		phydev->mac_managed_pm = true;
+
+		/* Set phylib's copy of the LPI timer */
+		phydev->eee_cfg.tx_lpi_timer = umac_rl(intf, UMC_EEE_LPI_TIMER);
 	}
 
 	umac_reset(intf);
-- 
2.51.0



