Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156C5326B4;
	Thu, 17 Sep 2026 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666127; cv=none; b=H69jlA4d6FmAsVhQ1wKRn/hiZ1mb4X3l6LeAh72+LQxQok6bgRulkInT4nsEe1wpQR0XRDoBY8WLrKiUrT3H71j94F+QbFoDusuzC4sQ7QXwqGVqk58KhTChmJLuJX9FsRsEvvg37MPz/d06TT/yStp6P3KG7I12+Csckt/XiUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666127; c=relaxed/simple;
	bh=A59YMwpBwM6PwlV/kpCZ/LkyWh1qTBKVLIuZf+OYPjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nq+670MJvfxX2KC14Is86JN4j1BJuD++iPwrs4S26KWNfUxXHE1AjzojrH4wk9Qy4ASegglMNygsZsF9e1jF6vEcN+cIGlZ+ayOwD5nqMiOcuyOcLXwagZpDMxx99aF8GAxzDJ/uafoMObyy+x3/I+U1gPagSY1EkOADIFM7JFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGPPOs4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGPPOs4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552D51F000FF;
	Thu, 17 Sep 2026 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666125;
	bh=F6dxkaF4lmhzOgA+KjD7XK//tq/yQOUMdbGDBVrGoHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGPPOs4r1nFkBZPqkXPoeOPRjX3IyBvRT97poEDKoEjTKdMaze/zMWzFhxN+YN4NL
	 yluwSoQchD/07EB8XD9xWcgpx3bxsL7opKsaYq1yEYuSip6rqJYuE42XVXjeeBJfw9
	 6qR1/rpmNf23q2XfteADq3iExTBzGdbtVfXc+84s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0932/1250] net: ethernet: mtk_eth_soc: fix supported_interface set after phylink_create
Date: Thu, 17 Sep 2026 16:12:07 +0100
Message-ID: <20260917151617.275682913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: d876c9cb2d16 ("net: ethernet: mtk_eth_soc: populate lpi_interfaces to fix EEE support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 19d971bf66f51..dcf86a8cd8c02 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4958,6 +4958,11 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
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
@@ -4968,11 +4973,6 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
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



