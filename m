Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0988333CCA;
	Fri, 24 Nov 2023 19:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1uRo98h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACF4C433C7;
	Fri, 24 Nov 2023 19:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853855;
	bh=eoxyJhXxwAa2825onB33TrClTIZCg71HSWfm7u8gclw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1uRo98ho1YlnYylCRzXShvCo5ZaQub2DzCHR6n9hm9KlFJRBt367L2PT/hLykplO
	 QZ4yEk5DzMA/qBIAzhsZgVbcVEtceUARACbjj32IKhAJT5IMAZXs6G+w1totM4NU3m
	 jaoDUoTUx8DyRL3oyxdZYCcRW0lEhCL30gzOv+hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/159] net: ethernet: cortina: Fix MTU max setting
Date: Fri, 24 Nov 2023 17:54:34 +0000
Message-ID: <20231124171944.295849317@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit dc6c0bfbaa947dd7976e30e8c29b10c868b6fa42 ]

The RX max frame size is over 10000 for the Gemini ethernet,
but the TX max frame size is actually just 2047 (0x7ff after
checking the datasheet). Reflect this in what we offer to Linux,
cap the MTU at the TX max frame minus ethernet headers.

We delete the code disabling the hardware checksum for large
MTUs as netdev->mtu can no longer be larger than
netdev->max_mtu meaning the if()-clause in gmac_fix_features()
is never true.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20231109-gemini-largeframe-fix-v4-3-6e611528db08@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 17 ++++-------------
 drivers/net/ethernet/cortina/gemini.h |  2 +-
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index ce1ada712af69..4bcdb48b0e9cc 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2015,15 +2015,6 @@ static int gmac_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
-static netdev_features_t gmac_fix_features(struct net_device *netdev,
-					   netdev_features_t features)
-{
-	if (netdev->mtu + ETH_HLEN + VLAN_HLEN > MTU_SIZE_BIT_MASK)
-		features &= ~GMAC_OFFLOAD_FEATURES;
-
-	return features;
-}
-
 static int gmac_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
@@ -2244,7 +2235,6 @@ static const struct net_device_ops gmac_351x_ops = {
 	.ndo_set_mac_address	= gmac_set_mac_address,
 	.ndo_get_stats64	= gmac_get_stats64,
 	.ndo_change_mtu		= gmac_change_mtu,
-	.ndo_fix_features	= gmac_fix_features,
 	.ndo_set_features	= gmac_set_features,
 };
 
@@ -2498,11 +2488,12 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 
 	netdev->hw_features = GMAC_OFFLOAD_FEATURES;
 	netdev->features |= GMAC_OFFLOAD_FEATURES | NETIF_F_GRO;
-	/* We can handle jumbo frames up to 10236 bytes so, let's accept
-	 * payloads of 10236 bytes minus VLAN and ethernet header
+	/* We can receive jumbo frames up to 10236 bytes but only
+	 * transmit 2047 bytes so, let's accept payloads of 2047
+	 * bytes minus VLAN and ethernet header
 	 */
 	netdev->min_mtu = ETH_MIN_MTU;
-	netdev->max_mtu = 10236 - VLAN_ETH_HLEN;
+	netdev->max_mtu = MTU_SIZE_BIT_MASK - VLAN_ETH_HLEN;
 
 	port->freeq_refill = 0;
 	netif_napi_add(netdev, &port->napi, gmac_napi_poll,
diff --git a/drivers/net/ethernet/cortina/gemini.h b/drivers/net/ethernet/cortina/gemini.h
index 99efb11557436..24bb989981f23 100644
--- a/drivers/net/ethernet/cortina/gemini.h
+++ b/drivers/net/ethernet/cortina/gemini.h
@@ -502,7 +502,7 @@ union gmac_txdesc_3 {
 #define SOF_BIT			0x80000000
 #define EOF_BIT			0x40000000
 #define EOFIE_BIT		BIT(29)
-#define MTU_SIZE_BIT_MASK	0x1fff
+#define MTU_SIZE_BIT_MASK	0x7ff /* Max MTU 2047 bytes */
 
 /* GMAC Tx Descriptor */
 struct gmac_txdesc {
-- 
2.42.0



