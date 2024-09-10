Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B4318D640;
	Tue, 10 Sep 2024 09:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961755; cv=none; b=Igp3FkFlpvxFEYGS+7Fgh9HIuLhliseq50C7X/V+qVweOPYDPG98AY8dqRyBz6vuC/BxKQ7e2aveC3bhDe7q66xOFl+Ar7i31cjM0OzzeoaBTZ2f52fmATjPngG4xzQPhlAdYutuia56GtcCPa8pnZnWU/xzUTMM+LmNBAdqhkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961755; c=relaxed/simple;
	bh=YInuxiD9gCkJhRflB3XgCa4KMXJCU9N3aEW8d+WlAKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRaaMLcQBvLx3d7TOij5WI7HcgqAjqRJQLj0WjFmYdViiqZPD/1JA0QyDuqEBUZ5m4prGyMYSo9wvBIisT7MtsLRXYBgmB0ep2LtB7ANEVKxcGHwKB8baWIboBrQ6nitrywNIxUKnP14WdUX7wJILjwq3InUv/BwTKL8cTqhfGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miFDmkr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miFDmkr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE34AC4CEC3;
	Tue, 10 Sep 2024 09:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961755;
	bh=YInuxiD9gCkJhRflB3XgCa4KMXJCU9N3aEW8d+WlAKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miFDmkr3SPj5f8dZBE0h9BLNrMDu9ao3HgO07BUt6GeA86ELCa7s9/peKt5QJ7FKG
	 XR0HiLWYcDKvNO91aB3GiJldF07xeq6u+KNEYiSwi4HqWtPiVMfe9FbxuF1XnbGCeM
	 Jfec2DqFkCrxTNJfwxjb52Du5zpNXpmrpj4TQkTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Julien Panis <jpanis@baylibre.com>,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 178/375] net: ethernet: ti: am65-cpsw: Fix RX statistics for XDP_TX and XDP_REDIRECT
Date: Tue, 10 Sep 2024 11:29:35 +0200
Message-ID: <20240910092628.458036209@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 624d3291484f9cada10660f820db926c0bce7741 ]

We are not using ndev->stats for rx_packets and rx_bytes anymore.
Instead, we use per CPU stats which are collated in
am65_cpsw_nuss_ndo_get_stats().

Fix RX statistics for XDP_TX and XDP_REDIRECT cases.

Fixes: 8acacc40f733 ("net: ethernet: ti: am65-cpsw: Add minimal XDP support")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Julien Panis <jpanis@baylibre.com>
Reviewed-by: MD Danish Anwar <danishanwar@ti.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 902b22de61d1..330eea349caa 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -998,7 +998,9 @@ static int am65_cpsw_run_xdp(struct am65_cpsw_common *common,
 			     int desc_idx, int cpu, int *len)
 {
 	struct am65_cpsw_rx_chn *rx_chn = &common->rx_chns;
+	struct am65_cpsw_ndev_priv *ndev_priv;
 	struct net_device *ndev = port->ndev;
+	struct am65_cpsw_ndev_stats *stats;
 	int ret = AM65_CPSW_XDP_CONSUMED;
 	struct am65_cpsw_tx_chn *tx_chn;
 	struct netdev_queue *netif_txq;
@@ -1016,6 +1018,9 @@ static int am65_cpsw_run_xdp(struct am65_cpsw_common *common,
 	/* XDP prog might have changed packet data and boundaries */
 	*len = xdp->data_end - xdp->data;
 
+	ndev_priv = netdev_priv(ndev);
+	stats = this_cpu_ptr(ndev_priv->stats);
+
 	switch (act) {
 	case XDP_PASS:
 		ret = AM65_CPSW_XDP_PASS;
@@ -1035,16 +1040,20 @@ static int am65_cpsw_run_xdp(struct am65_cpsw_common *common,
 		if (err)
 			goto drop;
 
-		ndev->stats.rx_bytes += *len;
-		ndev->stats.rx_packets++;
+		u64_stats_update_begin(&stats->syncp);
+		stats->rx_bytes += *len;
+		stats->rx_packets++;
+		u64_stats_update_end(&stats->syncp);
 		ret = AM65_CPSW_XDP_CONSUMED;
 		goto out;
 	case XDP_REDIRECT:
 		if (unlikely(xdp_do_redirect(ndev, xdp, prog)))
 			goto drop;
 
-		ndev->stats.rx_bytes += *len;
-		ndev->stats.rx_packets++;
+		u64_stats_update_begin(&stats->syncp);
+		stats->rx_bytes += *len;
+		stats->rx_packets++;
+		u64_stats_update_end(&stats->syncp);
 		ret = AM65_CPSW_XDP_REDIRECT;
 		goto out;
 	default:
-- 
2.43.0



