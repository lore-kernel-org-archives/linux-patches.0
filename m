Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC1E3F54C2;
	Tue, 17 Mar 2026 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767494; cv=none; b=JDYB+2k3f+k78pwJO2fosVp+TzUY0XKVpl4sXAP3amHE0i11qJ5hJL1MsEjFuvCkSuciXJx4XH+8fmvqJoOiZJsp2efVBAxd3AMqhpA51ep24V1AMK0dO9xt72tg7Gvrzx1ZIyyC9nILpNEf8nUcOyzfp5MWd8ym2378bTkgric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767494; c=relaxed/simple;
	bh=JFpC44vclqQTuzPx25jSZmZYxtGkIMSV/oaxlAVIDfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X62EBXiRVgIAEFGnjEMOVU6YRkUGfMMhjYphmOGUd/GUhWhZT8db34OJOD1zREYfOcXB05JelSa1AE7ke4xHY1QMa+Xo/LT6zx3OmbqoKje054Efk2QhOANESgV8i4YrZ6kOGjkJW20ejQz4G9jcRcppB5kvEgZcW9ILdDhd+Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTPdcHNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTPdcHNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD533C4CEF7;
	Tue, 17 Mar 2026 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767494;
	bh=JFpC44vclqQTuzPx25jSZmZYxtGkIMSV/oaxlAVIDfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTPdcHNc5Kt6QsgRkXKru3NwmdAz35WziaAQXoIcoylhc8UHDb2tkJPB9GJK45We5
	 bLc5+d8Z2rOwLdCh5v7RlB3gHGqTHXgZYPPKe10ghxDGmIwbUTRTfNwwjrFxaQGVIL
	 wEOxBInIDYo4si2rs4JUa6507jjaV489b3LhJ+Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/333] net: ti: am65-cpsw: move hw timestamping to ndo callback
Date: Tue, 17 Mar 2026 17:32:06 +0100
Message-ID: <20260317163002.968489256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

[ Upstream commit ed5d5928bd54f66af19b71ad342ebf0947d50674 ]

Migrate driver to new API for HW timestamping.

Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20251016152515.3510991-2-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 840c9d13cb1c ("net: ethernet: ti: am65-cpsw-nuss: Fix rx_filter value for PTP support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 44 +++++++++++-------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 77c2cf61c1fb4..071a7c42caa9a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1788,28 +1788,28 @@ static int am65_cpsw_nuss_ndo_slave_set_mac_address(struct net_device *ndev,
 }
 
 static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
-				       struct ifreq *ifr)
+				       struct kernel_hwtstamp_config *cfg,
+				       struct netlink_ext_ack *extack)
 {
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	u32 ts_ctrl, seq_id, ts_ctrl_ltype2, ts_vlan_ltype;
-	struct hwtstamp_config cfg;
 
-	if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
+	if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS)) {
+		NL_SET_ERR_MSG(extack, "Time stamping is not supported");
 		return -EOPNOTSUPP;
-
-	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
-		return -EFAULT;
+	}
 
 	/* TX HW timestamp */
-	switch (cfg.tx_type) {
+	switch (cfg->tx_type) {
 	case HWTSTAMP_TX_OFF:
 	case HWTSTAMP_TX_ON:
 		break;
 	default:
+		NL_SET_ERR_MSG(extack, "TX mode is not supported");
 		return -ERANGE;
 	}
 
-	switch (cfg.rx_filter) {
+	switch (cfg->rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
 		port->rx_ts_enabled = false;
 		break;
@@ -1826,17 +1826,19 @@ static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 		port->rx_ts_enabled = true;
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT | HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		cfg->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT | HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
 		break;
 	case HWTSTAMP_FILTER_ALL:
 	case HWTSTAMP_FILTER_SOME:
 	case HWTSTAMP_FILTER_NTP_ALL:
+		NL_SET_ERR_MSG(extack, "RX filter is not supported");
 		return -EOPNOTSUPP;
 	default:
+		NL_SET_ERR_MSG(extack, "RX filter is not supported");
 		return -ERANGE;
 	}
 
-	port->tx_ts_enabled = (cfg.tx_type == HWTSTAMP_TX_ON);
+	port->tx_ts_enabled = (cfg->tx_type == HWTSTAMP_TX_ON);
 
 	/* cfg TX timestamp */
 	seq_id = (AM65_CPSW_TS_SEQ_ID_OFFSET <<
@@ -1872,25 +1874,24 @@ static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
 	       AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2);
 	writel(ts_ctrl, port->port_base + AM65_CPSW_PORTN_REG_TS_CTL);
 
-	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+	return 0;
 }
 
 static int am65_cpsw_nuss_hwtstamp_get(struct net_device *ndev,
-				       struct ifreq *ifr)
+				       struct kernel_hwtstamp_config *cfg)
 {
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
-	struct hwtstamp_config cfg;
 
 	if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
 		return -EOPNOTSUPP;
 
-	cfg.flags = 0;
-	cfg.tx_type = port->tx_ts_enabled ?
+	cfg->flags = 0;
+	cfg->tx_type = port->tx_ts_enabled ?
 		      HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
-	cfg.rx_filter = port->rx_ts_enabled ? HWTSTAMP_FILTER_PTP_V2_EVENT |
+	cfg->rx_filter = port->rx_ts_enabled ? HWTSTAMP_FILTER_PTP_V2_EVENT |
 			HWTSTAMP_FILTER_PTP_V1_L4_EVENT : HWTSTAMP_FILTER_NONE;
 
-	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+	return 0;
 }
 
 static int am65_cpsw_nuss_ndo_slave_ioctl(struct net_device *ndev,
@@ -1901,13 +1902,6 @@ static int am65_cpsw_nuss_ndo_slave_ioctl(struct net_device *ndev,
 	if (!netif_running(ndev))
 		return -EINVAL;
 
-	switch (cmd) {
-	case SIOCSHWTSTAMP:
-		return am65_cpsw_nuss_hwtstamp_set(ndev, req);
-	case SIOCGHWTSTAMP:
-		return am65_cpsw_nuss_hwtstamp_get(ndev, req);
-	}
-
 	return phylink_mii_ioctl(port->slave.phylink, req, cmd);
 }
 
@@ -1991,6 +1985,8 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_set_tx_maxrate	= am65_cpsw_qos_ndo_tx_p0_set_maxrate,
 	.ndo_bpf		= am65_cpsw_ndo_bpf,
 	.ndo_xdp_xmit		= am65_cpsw_ndo_xdp_xmit,
+	.ndo_hwtstamp_get       = am65_cpsw_nuss_hwtstamp_get,
+	.ndo_hwtstamp_set       = am65_cpsw_nuss_hwtstamp_set,
 };
 
 static void am65_cpsw_disable_phy(struct phy *phy)
-- 
2.51.0



