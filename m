Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20133372B;
	Fri,  9 Jan 2026 12:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962671; cv=none; b=HV/6q7Buy1Vxv+KAZlZEILZ2d4+yzabqzQNrnKnMLBZ0ALLXS6hmBXN9q4Hm1+j4FZuWTH2uU7djiUzyjMxG0wKtKRgdKQq3YcIBY1lg+Uo7xPyzu7On3SYeUnO7xCv6v5jfVUT90kS29bF98okdXPrjxMpMtvAD0FjFWfkLdHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962671; c=relaxed/simple;
	bh=TbQ4jTuu+bVhbE6zKtyxzqL6Ihy7j+4CUVRg4JRp4Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojUQTmrdZVd+0+u5aahJU0RLOdeDT6VzkSlqv1dmwjvNlkQHHpDPEPjkhOv7XcX47wWA5HhP44kaQ387AWJKoaZw7abJ1F9wDKrBrk4xlN7IofP1FahXXPO3ugHDPGlmZD40o4zCNiTfTWuP4Z5nTlZ3ZAM8Ni3yGIb5yGv+gEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNQfWOsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNQfWOsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBB8C4CEF1;
	Fri,  9 Jan 2026 12:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962671;
	bh=TbQ4jTuu+bVhbE6zKtyxzqL6Ihy7j+4CUVRg4JRp4Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNQfWOsn5091whC4BiG0OdDCleN9X56HVTb9jTvkQKQjUvaPzeIRonvntVQL5tg6h
	 nTJXtW6ZuJfneVbQGtABXf+iphTmFtzpYr/YnAn2tDv7fvZQxAuOZ5ECCqDABPNBzV
	 3DrIrNdhkrrSjlMkokrt+Rbcbw5fTuSenLzXJdWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Revanth Kumar Uppala <ruppala@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 420/634] net: stmmac: Power up SERDES after the PHY link
Date: Fri,  9 Jan 2026 12:41:38 +0100
Message-ID: <20260109112133.341697772@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Revanth Kumar Uppala <ruppala@nvidia.com>

[ Upstream commit a46e9010124256f5bf5fc2c241a45cf1944b768e ]

The Tegra MGBE ethernet controller requires that the SERDES link is
powered-up after the PHY link is up, otherwise the link fails to
become ready following a resume from suspend. Add a variable to indicate
that the SERDES link must be powered-up after the PHY link.

Signed-off-by: Revanth Kumar Uppala <ruppala@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a48e23221000 ("net: stmmac: fix the crash issue for zero copy XDP_TX action")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +++++--
 include/linux/stmmac.h                            | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 202c43d73a2b..0483e8c2f1de 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -994,6 +994,9 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 old_ctrl, ctrl;
 
+	if (priv->plat->serdes_up_after_phy_linkup && priv->plat->serdes_powerup)
+		priv->plat->serdes_powerup(priv->dev, priv->plat->bsp_priv);
+
 	old_ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl = old_ctrl & ~priv->hw->link.speed_mask;
 
@@ -3839,7 +3842,7 @@ static int __stmmac_open(struct net_device *dev,
 
 	stmmac_reset_queues_param(priv);
 
-	if (priv->plat->serdes_powerup) {
+	if (!priv->plat->serdes_up_after_phy_linkup && priv->plat->serdes_powerup) {
 		ret = priv->plat->serdes_powerup(dev, priv->plat->bsp_priv);
 		if (ret < 0) {
 			netdev_err(priv->dev, "%s: Serdes powerup failed\n",
@@ -7563,7 +7566,7 @@ int stmmac_resume(struct device *dev)
 			stmmac_mdio_reset(priv->mii);
 	}
 
-	if (priv->plat->serdes_powerup) {
+	if (!priv->plat->serdes_up_after_phy_linkup && priv->plat->serdes_powerup) {
 		ret = priv->plat->serdes_powerup(ndev,
 						 priv->plat->bsp_priv);
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 9f4a4f70270d..c97df9464f90 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -273,5 +273,6 @@ struct plat_stmmacenet_data {
 	int msi_tx_base_vec;
 	bool use_phy_wol;
 	bool sph_disable;
+	bool serdes_up_after_phy_linkup;
 };
 #endif
-- 
2.51.0



