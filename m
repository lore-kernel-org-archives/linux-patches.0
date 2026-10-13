Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06BF4E9C27;
	Tue, 13 Oct 2026 12:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893377; cv=none; b=F5aD/uCoex8x6UOVnXnS1AH9780z/Q5kJESvROUtWVkhJLsYfAA3EC4hreeu7zSX+J+BP9amQeaTGAhB6+ic6D8MAJdMTly4HOcdwCtSrrb0HCbAcw4kieAuAos31lZe7SB6mC8gTLA+9pr8OZYVJdaj0qGhKlIpmTQA52+06xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893377; c=relaxed/simple;
	bh=MVZYRYQ4yaaklZUxBcdGsLHBVpnjmwC90GJUN79xgs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCXp8ttjSzEH8wutsxmLqwGXTI4sSpiruu+nXUc0pwCBpI9X9vS1Ms9yezjfWk2IwizhD9rYvP/OaXdlAJmz8/c8NeXubzDPi5DqPCGGf2Qi63CDrADeel2E7utg71WTWfmElUKsEEhqrsBhPNDg9qPTh5hjjZszNWJklyFiXbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buDho8Gu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buDho8Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3338A1F00893;
	Tue, 13 Oct 2026 12:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893375;
	bh=7Ldk1g4DMAZ5pjBX34AOn9AeiS1pWKQ32Dk1oyM5YYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buDho8GuNvRQwoNsJPiTyfZhOa/OLq810LVz0J2lxHbAeLgnFyKzFtICSuJ445TSY
	 zih6i2x9VE9xmB4N0K55sRvrGIKDmMjqzYlt5KfKH//icjhYIj8Y/tyqNZDHwNcEHN
	 4bQeTTgIol52c0Xk6G6nAXF83/bsF71PrN0o1yLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/621] ti: icssg: convert to ndo_hwtstamp API
Date: Tue, 13 Oct 2026 13:32:37 +0200
Message-ID: <20261013112924.704348776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit b8fa98ea4a22d949e92ebc755abc5e633db88bf9 ]

Convert driver to use .ndo_hwtstamp_get()/.ndo_hwtstamp_set() API.
.ndo_eth_ioctl() implementation becomes pure phy_do_ioctl(), remove
it from common module, remove exported symbol and replace ndo callback.

Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20251016152515.3510991-3-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: eb8c426c9803 ("net: ti: icssg-prueth: fix use-after-free of CPPI descriptor in RX path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c  | 47 ++++++-------------
 drivers/net/ethernet/ti/icssg/icssg_prueth.c  |  4 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.h  |  6 ++-
 .../net/ethernet/ti/icssg/icssg_prueth_sr1.c  |  4 +-
 4 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 93bc054e3fba3..bd1dc034b3bda 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -1223,15 +1223,13 @@ void icssg_ndo_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 }
 EXPORT_SYMBOL_GPL(icssg_ndo_tx_timeout);
 
-static int emac_set_ts_config(struct net_device *ndev, struct ifreq *ifr)
+int icssg_ndo_set_ts_config(struct net_device *ndev,
+			    struct kernel_hwtstamp_config *config,
+			    struct netlink_ext_ack *extack)
 {
 	struct prueth_emac *emac = netdev_priv(ndev);
-	struct hwtstamp_config config;
 
-	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
-		return -EFAULT;
-
-	switch (config.tx_type) {
+	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		emac->tx_ts_enabled = 0;
 		break;
@@ -1242,7 +1240,7 @@ static int emac_set_ts_config(struct net_device *ndev, struct ifreq *ifr)
 		return -ERANGE;
 	}
 
-	switch (config.rx_filter) {
+	switch (config->rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
 		emac->rx_ts_enabled = 0;
 		break;
@@ -1262,43 +1260,28 @@ static int emac_set_ts_config(struct net_device *ndev, struct ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 	case HWTSTAMP_FILTER_NTP_ALL:
 		emac->rx_ts_enabled = 1;
-		config.rx_filter = HWTSTAMP_FILTER_ALL;
+		config->rx_filter = HWTSTAMP_FILTER_ALL;
 		break;
 	default:
 		return -ERANGE;
 	}
 
-	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
-		-EFAULT : 0;
+	return 0;
 }
+EXPORT_SYMBOL_GPL(icssg_ndo_set_ts_config);
 
-static int emac_get_ts_config(struct net_device *ndev, struct ifreq *ifr)
+int icssg_ndo_get_ts_config(struct net_device *ndev,
+			    struct kernel_hwtstamp_config *config)
 {
 	struct prueth_emac *emac = netdev_priv(ndev);
-	struct hwtstamp_config config;
-
-	config.flags = 0;
-	config.tx_type = emac->tx_ts_enabled ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
-	config.rx_filter = emac->rx_ts_enabled ? HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE;
-
-	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
-			    -EFAULT : 0;
-}
 
-int icssg_ndo_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
-{
-	switch (cmd) {
-	case SIOCGHWTSTAMP:
-		return emac_get_ts_config(ndev, ifr);
-	case SIOCSHWTSTAMP:
-		return emac_set_ts_config(ndev, ifr);
-	default:
-		break;
-	}
+	config->flags = 0;
+	config->tx_type = emac->tx_ts_enabled ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
+	config->rx_filter = emac->rx_ts_enabled ? HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE;
 
-	return phy_do_ioctl(ndev, ifr, cmd);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(icssg_ndo_ioctl);
+EXPORT_SYMBOL_GPL(icssg_ndo_get_ts_config);
 
 void icssg_ndo_get_stats64(struct net_device *ndev,
 			   struct rtnl_link_stats64 *stats)
diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index 07489564270b2..d95a37e562cd1 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -1176,7 +1176,7 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_tx_timeout = icssg_ndo_tx_timeout,
 	.ndo_set_rx_mode = emac_ndo_set_rx_mode,
-	.ndo_eth_ioctl = icssg_ndo_ioctl,
+	.ndo_eth_ioctl = phy_do_ioctl,
 	.ndo_get_stats64 = icssg_ndo_get_stats64,
 	.ndo_get_phys_port_name = icssg_ndo_get_phys_port_name,
 	.ndo_fix_features = emac_ndo_fix_features,
@@ -1184,6 +1184,8 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_vlan_rx_kill_vid = emac_ndo_vlan_rx_del_vid,
 	.ndo_bpf = emac_ndo_bpf,
 	.ndo_xdp_xmit = emac_xdp_xmit,
+	.ndo_hwtstamp_get = icssg_ndo_get_ts_config,
+	.ndo_hwtstamp_set = icssg_ndo_set_ts_config,
 };
 
 static int prueth_netdev_init(struct prueth *prueth,
diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.h b/drivers/net/ethernet/ti/icssg/icssg_prueth.h
index ca8a22a4a5daa..f0fa9688d9a08 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.h
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.h
@@ -479,7 +479,11 @@ void prueth_reset_tx_chan(struct prueth_emac *emac, int ch_num,
 void prueth_reset_rx_chan(struct prueth_rx_chn *chn,
 			  int num_flows, bool disable);
 void icssg_ndo_tx_timeout(struct net_device *ndev, unsigned int txqueue);
-int icssg_ndo_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd);
+int icssg_ndo_get_ts_config(struct net_device *ndev,
+			    struct kernel_hwtstamp_config *config);
+int icssg_ndo_set_ts_config(struct net_device *ndev,
+			    struct kernel_hwtstamp_config *config,
+			    struct netlink_ext_ack *extack);
 void icssg_ndo_get_stats64(struct net_device *ndev,
 			   struct rtnl_link_stats64 *stats);
 int icssg_ndo_get_phys_port_name(struct net_device *ndev, char *name,
diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth_sr1.c b/drivers/net/ethernet/ti/icssg/icssg_prueth_sr1.c
index 5e225310c9dea..2a8c8847a6bd0 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth_sr1.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth_sr1.c
@@ -747,9 +747,11 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_tx_timeout = icssg_ndo_tx_timeout,
 	.ndo_set_rx_mode = emac_ndo_set_rx_mode_sr1,
-	.ndo_eth_ioctl = icssg_ndo_ioctl,
+	.ndo_eth_ioctl = phy_do_ioctl,
 	.ndo_get_stats64 = icssg_ndo_get_stats64,
 	.ndo_get_phys_port_name = icssg_ndo_get_phys_port_name,
+	.ndo_hwtstamp_get = icssg_ndo_get_ts_config,
+	.ndo_hwtstamp_set = icssg_ndo_set_ts_config,
 };
 
 static int prueth_netdev_init(struct prueth *prueth,
-- 
2.53.0



