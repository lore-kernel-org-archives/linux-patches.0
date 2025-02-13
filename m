Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC2D21D3FD;
	Thu, 13 Feb 2025 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457430; cv=none; b=XreWSNcJu4cO11eVlculAbqKnktDxYd/4lHHePBl3zi5DEbQwrrPzzA8dg1nqub0LYOGmskAmJsy0+G0eqmtCVJpbcv11J3stSg8eZ5oAxUtXdSl+28cDt335CShyNwAlHFnCukepvFDyFwL2Qm64mGE8VJR8mR7tGyZVvBi3nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457430; c=relaxed/simple;
	bh=+3C+co+ZHKlH43KUrjpMurqiIoI+LzfgATYfstnSUl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAIKKvgvHQFd25SjUbEjnPZAj/NBXMdMZbDyRzIcQBzeddphc5xJEhxmye88HRAHuWqQbV5UIQ5eQbraGI1mceiNZWLmGGunCmsJcW4CAx4G2IpU/6K5G2OvyZ6uArJSeHhmgnGET/7kAtq2QjRLriLkfxVAldDkbTRzq734h5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuWUlvwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuWUlvwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EE8C4CED1;
	Thu, 13 Feb 2025 14:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457430;
	bh=+3C+co+ZHKlH43KUrjpMurqiIoI+LzfgATYfstnSUl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuWUlvwn2h6hcFnI30zBiaDccYSEZGTrSfsjuldJ1SFrtgzcWhbZQOwgHfjhjEicC
	 7pyZWDCtq8DMj6+zIv5IY0yb5XpCgiX2wbhpvYsUlecPCDT8tFlXOpj5m1JnqTxRot
	 Wfli7t0+XKeXXHsVD12X+khi0vyGhnGt9UYq1Yho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/422] net: bcmgenet: Correct overlaying of PHY and MAC Wake-on-LAN
Date: Thu, 13 Feb 2025 15:24:17 +0100
Message-ID: <20250213142440.725005471@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 46ded709232344b5750a852747a8881763c721ab ]

Some Wake-on-LAN modes such as WAKE_FILTER may only be supported by the MAC,
while others might be only supported by the PHY. Make sure that the .get_wol()
returns the union of both rather than only that of the PHY if the PHY supports
Wake-on-LAN.

When disabling Wake-on-LAN, make sure that this is done at both the PHY
and MAC level, rather than doing an early return from the PHY driver.

Fixes: 7e400ff35cbe ("net: bcmgenet: Add support for PHY-based Wake-on-LAN")
Fixes: 9ee09edc05f2 ("net: bcmgenet: Properly overlay PHY and MAC Wake-on-LAN capabilities")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250129231342.35013-1-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet_wol.c   | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 0715ea5bf13ed..3b082114f2e53 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -41,9 +41,12 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
+	u32 phy_wolopts = 0;
 
-	if (dev->phydev)
+	if (dev->phydev) {
 		phy_ethtool_get_wol(dev->phydev, wol);
+		phy_wolopts = wol->wolopts;
+	}
 
 	/* MAC is not wake-up capable, return what the PHY does */
 	if (!device_can_wakeup(kdev))
@@ -51,9 +54,14 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 
 	/* Overlay MAC capabilities with that of the PHY queried before */
 	wol->supported |= WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
-	wol->wolopts = priv->wolopts;
-	memset(wol->sopass, 0, sizeof(wol->sopass));
+	wol->wolopts |= priv->wolopts;
 
+	/* Return the PHY configured magic password */
+	if (phy_wolopts & WAKE_MAGICSECURE)
+		return;
+
+	/* Otherwise the MAC one */
+	memset(wol->sopass, 0, sizeof(wol->sopass));
 	if (wol->wolopts & WAKE_MAGICSECURE)
 		memcpy(wol->sopass, priv->sopass, sizeof(priv->sopass));
 }
@@ -70,7 +78,7 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	/* Try Wake-on-LAN from the PHY first */
 	if (dev->phydev) {
 		ret = phy_ethtool_set_wol(dev->phydev, wol);
-		if (ret != -EOPNOTSUPP)
+		if (ret != -EOPNOTSUPP && wol->wolopts)
 			return ret;
 	}
 
-- 
2.39.5



