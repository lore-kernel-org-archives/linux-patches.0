Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E31C15AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E20AC433C9;
	Tue, 25 Jul 2023 11:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283358;
	bh=rkFAPEoG2NQsx3d65VRXSfyXQcGkdYLNr+2c7wiTYVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5yJjhyiEhE1cKpZ/9snSxkiNKFSwVabsCCYxAOssjtM2wRgVMU0vkn60ZTzTQrcu
	 8CyK2dgi15dWSWfa4DQxpFbhW4IyyuAM21O9MLPuj1wppmZNqfITif/1twIQ84vLzS
	 6JrtIbBhSLYyy6wcfCadlpiaXJHnMmbZ/1ADQex8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/78] net: ethernet: mtk_eth_soc: handle probe deferral
Date: Tue, 25 Jul 2023 12:46:38 +0200
Message-ID: <20230725104453.100358749@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 1d6d537dc55d1f42d16290f00157ac387985b95b ]

Move the call to of_get_ethdev_address to mtk_add_mac which is part of
the probe function and can hence itself return -EPROBE_DEFER should
of_get_ethdev_address return -EPROBE_DEFER. This allows us to entirely
get rid of the mtk_init function.

The problem of of_get_ethdev_address returning -EPROBE_DEFER surfaced
in situations in which the NVMEM provider holding the MAC address has
not yet be loaded at the time mtk_eth_soc is initially probed. In this
case probing of mtk_eth_soc should be deferred instead of falling back
to use a random MAC address, so once the NVMEM provider becomes
available probing can be repeated.

Fixes: 656e705243fd ("net-next: mediatek: add support for MT7623 ethernet")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 29 ++++++++-------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c55ba1d085e5b..50ee9d3d4c841 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2612,23 +2612,6 @@ static int mtk_hw_deinit(struct mtk_eth *eth)
 	return 0;
 }
 
-static int __init mtk_init(struct net_device *dev)
-{
-	struct mtk_mac *mac = netdev_priv(dev);
-	struct mtk_eth *eth = mac->hw;
-	int ret;
-
-	ret = of_get_ethdev_address(mac->of_node, dev);
-	if (ret) {
-		/* If the mac address is invalid, use random mac address */
-		eth_hw_addr_random(dev);
-		dev_err(eth->dev, "generated random MAC address %pM\n",
-			dev->dev_addr);
-	}
-
-	return 0;
-}
-
 static void mtk_uninit(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -2956,7 +2939,6 @@ static const struct ethtool_ops mtk_ethtool_ops = {
 };
 
 static const struct net_device_ops mtk_netdev_ops = {
-	.ndo_init		= mtk_init,
 	.ndo_uninit		= mtk_uninit,
 	.ndo_open		= mtk_open,
 	.ndo_stop		= mtk_stop,
@@ -3010,6 +2992,17 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	mac->hw = eth;
 	mac->of_node = np;
 
+	err = of_get_ethdev_address(mac->of_node, eth->netdev[id]);
+	if (err == -EPROBE_DEFER)
+		return err;
+
+	if (err) {
+		/* If the mac address is invalid, use random mac address */
+		eth_hw_addr_random(eth->netdev[id]);
+		dev_err(eth->dev, "generated random MAC address %pM\n",
+			eth->netdev[id]->dev_addr);
+	}
+
 	memset(mac->hwlro_ip, 0, sizeof(mac->hwlro_ip));
 	mac->hwlro_ip_cnt = 0;
 
-- 
2.39.2



