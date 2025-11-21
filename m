Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40C1190477;
	Fri, 21 Nov 2025 13:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731659; cv=none; b=idCG454NaBA/JgtjktgxlErdFDc/t+CeRbcdq2YZ/GO/ut+9ncBlwCP3n4p9TGS+gBinS5dbkLJLgBR1rTsdTJ8VzXWIvKGFBv/sl8pliIS5JoD2mPEvid8HBITc8TGOdcA+nbcQ/zmaRTd11XA0gr5wOm+zFS6lE42Sgc2F2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731659; c=relaxed/simple;
	bh=nDCPDnYCA/6epzj4PEUdCEPLqhPeBHMaPKoCEHKOUCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4obXCekC+pCZYuzQoVDExnYNgn0p3JSNpwnA+fBDEWIB/NrUwhKkLaTZY1j9QQ15rTFwPW4jCQ3GOepB1qpymC7RDMxLfw3GT75s7fCNJDgELhyBquFf+8cgsMzChyaJZsktkllHohkFYUr/shP+CoEw93tSdXteCP9lah3w9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuQNZV3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuQNZV3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02D8C4CEF1;
	Fri, 21 Nov 2025 13:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731659;
	bh=nDCPDnYCA/6epzj4PEUdCEPLqhPeBHMaPKoCEHKOUCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuQNZV3QpU97D19tkOG2cgatEEynwKlCQ6JAYDDS/HcAwj/ILQy59ruygDrxQ2tgA
	 KcL/lFVxJ7pa5GDONsnpgllXWvhc+Br0HrhNCO+Cy2gCNyVOIk0sYWhYZ7MoGgTwIy
	 JHUOcGzhIbqb0PcBn8DO+pDCJGELv52bouBQ0nlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Divya Koppera <Divya.Koppera@microchip.com>
Subject: [PATCH 6.12 036/185] net: phy: micrel: lan8814 fix reset of the QSGMII interface
Date: Fri, 21 Nov 2025 14:11:03 +0100
Message-ID: <20251121130145.179601233@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 96a9178a29a6b84bb632ebeb4e84cf61191c73d5 ]

The lan8814 is a quad-phy and it is using QSGMII towards the MAC.
The problem is that everytime when one of the ports is configured then
the PCS is reseted for all the PHYs. Meaning that the other ports can
loose traffic until the link is establish again.
To fix this, do the reset one time for the entire PHY package.

Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Divya Koppera <Divya.Koppera@microchip.com >
Link: https://patch.msgid.link/20251106090637.2030625-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e12040cf10eae..030e559a2cf15 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4084,12 +4084,6 @@ static int lan8814_config_init(struct phy_device *phydev)
 {
 	struct kszphy_priv *lan8814 = phydev->priv;
 
-	/* Reset the PHY */
-	lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
-			       LAN8814_QSGMII_SOFT_RESET,
-			       LAN8814_QSGMII_SOFT_RESET_BIT,
-			       LAN8814_QSGMII_SOFT_RESET_BIT);
-
 	/* Disable ANEG with QSGMII PCS Host side */
 	lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
 			       LAN8814_QSGMII_PCS1G_ANEG_CONFIG,
@@ -4175,6 +4169,12 @@ static int lan8814_probe(struct phy_device *phydev)
 			      addr, sizeof(struct lan8814_shared_priv));
 
 	if (phy_package_init_once(phydev)) {
+		/* Reset the PHY */
+		lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
+				       LAN8814_QSGMII_SOFT_RESET,
+				       LAN8814_QSGMII_SOFT_RESET_BIT,
+				       LAN8814_QSGMII_SOFT_RESET_BIT);
+
 		err = lan8814_release_coma_mode(phydev);
 		if (err)
 			return err;
-- 
2.51.0



