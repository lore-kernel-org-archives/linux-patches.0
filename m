Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC2E43C7C9;
	Tue, 21 Jul 2026 19:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660898; cv=none; b=JA8AU775wR5sf5uEHs3wP+7buszZPGk31krsEkBM01cz7wms/4CAKEnDcUbM7ARyvuU8IClA2VRW46DCc9cxgYba6iZy4Chi397mQ8bNYYPi/fT3jJLpQJ127K55Qqye6ek+B6JpgoKjZwgthfrgyut2o8XLZtyBPioP9YcR3fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660898; c=relaxed/simple;
	bh=YDT+fjKXlqBWViNl+SP5ffGb2aJ/LI7pM77Mhp4Fqyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIGmW2VO2d39MB8b4o0ffZl04tod/hZsR+hp1xw48JjZTbd1lgrVu5LlNrsGte5WN5CxfS0rvPx7STNsseW4z6cFiPEpHX4gJQZRZNV3AtWeEfxITDbSUHUn6JJaAtMiBPyp57euzao9hlKse6u7nP9ZakuodwwahDhVIJ74tOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4wPYJ33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4wPYJ33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D911F00A3A;
	Tue, 21 Jul 2026 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660896;
	bh=kLUMfHM0fLXJXhamYvNmX9Yy0Mf6knvY8xIEPpQa+O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4wPYJ33KZ5thP4CLWHzFcJWqipN1icuXyujxr48ISdzkIpGOK7h81kA0d+rQnAA2
	 tvIMlv4YzX910PYiIQ6qUi15xcrh4XHDsx8j4JMbccJdmXzLjDcQhEHQ96GZSh/NAz
	 AeEO4VXAhQJECsvrzcOySjAYQ+2xnWlOT3MCLytM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1109/2077] net: ethernet: mtk_eth_soc: fix supported_interface set after phylink_create
Date: Tue, 21 Jul 2026 17:13:02 +0200
Message-ID: <20260721152618.978751541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit e4b4d8410c7ccea25f4b332a077c6b9f5d263228 ]

Everything configured in phylink_config it's assumed to be set before
calling phylink_create() to permit correct parsing of all the different
modes and capabilities.

Commit 51cf06ddafc9 ("net: ethernet: mtk_eth_soc: add support for MT7988
internal 2.5G PHY") while introducing support for 2.5G phy for MT7988,
probably due to an auto-rebase, placed the configuration of the INTERNAL
interface mode for the supported_interfaces for phylink_config right after
phylink_create() introducing a possible problem with supported interfaces
parsing.

While this doesn't currently create any problem/bug, move setting this bit
before phylink_create() to prevent any possible regression in future code
change in phylink core.

Fixes: 51cf06ddafc9 ("net: ethernet: mtk_eth_soc: add support for MT7988 internal 2.5G PHY")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/20260615151106.15438-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 7d771168b99011..5d291e50a47bb9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4960,6 +4960,11 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 		mac_ops = &rt5350_phylink_ops;
 
+	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_2P5GPHY) &&
+	    id == MTK_GMAC2_ID)
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  mac->phylink_config.supported_interfaces);
+
 	phylink = phylink_create(&mac->phylink_config,
 				 of_fwnode_handle(mac->of_node),
 				 phy_mode, mac_ops);
@@ -4970,11 +4975,6 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	mac->phylink = phylink;
 
-	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_2P5GPHY) &&
-	    id == MTK_GMAC2_ID)
-		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
-			  mac->phylink_config.supported_interfaces);
-
 	SET_NETDEV_DEV(eth->netdev[id], eth->dev);
 	eth->netdev[id]->watchdog_timeo = 5 * HZ;
 	eth->netdev[id]->netdev_ops = &mtk_netdev_ops;
-- 
2.53.0



