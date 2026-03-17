Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA0C3446DA;
	Tue, 17 Mar 2026 16:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765844; cv=none; b=Q+Nq+zUqiBlK51x3b6djKEroFKhaVAzEIFioOZTf4/IU9LHvFgPJQH6Y5J8BDYGtOe42ab+qn/kXY8Tbv/Df5+JA/WvaCezrrN0L34e0Yw2rfQRPF93gbm6OG/wyb3EPOeFAE3pcwABb3vNn8NEPgBdy5EGax3N4CHp/a0UKtmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765844; c=relaxed/simple;
	bh=bS1KdViKttQBjCOS2EGp5dqCK3fXu78TcCm62RvcWc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSzDr4uQC5k3M2IzjQgPWfSqwvMSnPPEFYWyOzPpxq7l5SwysMO61aS9ps9ASui7wweJegEMmLHc1gwycQMJ4RGYZ6pCaaVvnUz0XR8vrEmQ5/9ydSOpqDJt2ubJnfW6ha3kAZmTqpiT2kkwuYcUn+nDK8CkHylQl4UJVBe8wE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNrW6WrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNrW6WrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEDDC4CEF7;
	Tue, 17 Mar 2026 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765844;
	bh=bS1KdViKttQBjCOS2EGp5dqCK3fXu78TcCm62RvcWc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNrW6WrRHzl9UMpqXrBWYXJI8kz6JSGBMSSkHCNp3PbI9A6OnazY3Vx/zRkEMYdcE
	 0L/TS63WWX1Mql05pq/OQCEmZ5zKQu67qWSVNfNycUbk5qsj1ck9VbWsFROZfibU4X
	 R14/ABrJB6u2AN5Xs9Or98TxZRmHrrHm4SAHmwMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chintan Vankar <c-vankar@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 108/378] net: ethernet: ti: am65-cpsw-nuss: Fix rx_filter value for PTP support
Date: Tue, 17 Mar 2026 17:31:05 +0100
Message-ID: <20260317163010.990084398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chintan Vankar <c-vankar@ti.com>

[ Upstream commit 840c9d13cb1ca96683a5307ee8e221be163a2c1e ]

The "rx_filter" member of "hwtstamp_config" structure is an enum field and
does not support bitwise OR combination of multiple filter values. It
causes error while linuxptp application tries to match rx filter version.
Fix this by storing the requested filter type in a new port field.

Fixes: 97248adb5a3b ("net: ti: am65-cpsw: Update hw timestamping filter for PTPv1 RX packets")
Signed-off-by: Chintan Vankar <c-vankar@ti.com>
Link: https://patch.msgid.link/20260310160940.109822-1-c-vankar@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 16 +++++++++-------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 9679180504330..265ce5479915f 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1351,7 +1351,7 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_rx_flow *flow,
 	ndev_priv = netdev_priv(ndev);
 	am65_cpsw_nuss_set_offload_fwd_mark(skb, ndev_priv->offload_fwd_mark);
 	skb_put(skb, pkt_len);
-	if (port->rx_ts_enabled)
+	if (port->rx_ts_filter)
 		am65_cpts_rx_timestamp(common->cpts, skb);
 	skb_mark_for_recycle(skb);
 	skb->protocol = eth_type_trans(skb, ndev);
@@ -1811,11 +1811,14 @@ static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
 
 	switch (cfg->rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		port->rx_ts_enabled = false;
+		port->rx_ts_filter = HWTSTAMP_FILTER_NONE;
 		break;
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		port->rx_ts_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		cfg->rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		break;
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
@@ -1825,8 +1828,8 @@ static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
-		port->rx_ts_enabled = true;
-		cfg->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT | HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		port->rx_ts_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		cfg->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
 		break;
 	case HWTSTAMP_FILTER_ALL:
 	case HWTSTAMP_FILTER_SOME:
@@ -1863,7 +1866,7 @@ static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
 		ts_ctrl |= AM65_CPSW_TS_TX_ANX_ALL_EN |
 			   AM65_CPSW_PN_TS_CTL_TX_VLAN_LT1_EN;
 
-	if (port->rx_ts_enabled)
+	if (port->rx_ts_filter)
 		ts_ctrl |= AM65_CPSW_TS_RX_ANX_ALL_EN |
 			   AM65_CPSW_PN_TS_CTL_RX_VLAN_LT1_EN;
 
@@ -1888,8 +1891,7 @@ static int am65_cpsw_nuss_hwtstamp_get(struct net_device *ndev,
 	cfg->flags = 0;
 	cfg->tx_type = port->tx_ts_enabled ?
 		      HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
-	cfg->rx_filter = port->rx_ts_enabled ? HWTSTAMP_FILTER_PTP_V2_EVENT |
-			HWTSTAMP_FILTER_PTP_V1_L4_EVENT : HWTSTAMP_FILTER_NONE;
+	cfg->rx_filter = port->rx_ts_filter;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 917c37e4e89bd..7750448e47468 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -52,7 +52,7 @@ struct am65_cpsw_port {
 	bool				disabled;
 	struct am65_cpsw_slave_data	slave;
 	bool				tx_ts_enabled;
-	bool				rx_ts_enabled;
+	enum hwtstamp_rx_filters	rx_ts_filter;
 	struct am65_cpsw_qos		qos;
 	struct devlink_port		devlink_port;
 	struct bpf_prog			*xdp_prog;
-- 
2.51.0



