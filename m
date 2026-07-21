Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F13471267;
	Tue, 21 Jul 2026 18:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657779; cv=none; b=YTXVeTLqqebNunYfvzjIYvNoFnAQNyAfEkqYJwMyOLJMEencLagmXPJBe0i3yrorgXSQeOcUjddSSM5ElnhA0I/GWLsDRSZ2+D3SX+mnD8zxl0CNc1JndWJrCd2pwOl975/XpXxoXGRDee3/TAZhiUGXyIyxIDqF/s31pJr+zKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657779; c=relaxed/simple;
	bh=Cr3T/JB6AC5guedcww9cmPgP3SxwKF0klQPOVeuuFdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eY3PC4W7ewQH//e1e9wEeSgevHwGD3dBC0M7Na+ZSLqsyyFF/+xO5pb9R/1wXs30KbUUKb0LbOUD/Hs5KU8aJ6PTnmYRzPZNKzHfbZ1NJiCm1eSA313T0JnrXT8sgEnRR28yukCR3aPt5vebknfElV94wl4jKavVUIWVTwdxXu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diH3f1vo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diH3f1vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4BA1F000E9;
	Tue, 21 Jul 2026 18:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657778;
	bh=EHic1O601y24EuZ0nvlZqV4ZA4dEWb9OU3YTgdOmYpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=diH3f1vobmrxgOxV0bgHJGk540vA2S7rBW3nbBR89mOExtSubPg9DFNIDPUVexL1K
	 nbAkGw7eu99/20ZjYmfVht6CcF3St0jPMndzZtUrMiirusOa6CsC7wUk1sY0bMdG2p
	 lAtIc+IaM+QDKLVMrN8pT+UjYBjSMTjfP5fyQNdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0895/1611] eth: bnxt: gather and report HW-GRO stats
Date: Tue, 21 Jul 2026 17:16:51 +0200
Message-ID: <20260721152535.520640444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a7fc1a488f09f0fbf727fe3ca5b017e7657f152d ]

Count and report HW-GRO stats as seen by the kernel.
The device stats for GRO seem to not reflect the reality,
perhaps they count sessions which did not actually result
in any aggregation. Also they count wire packets, so we
have to count super-frames, anyway.

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260207003509.3927744-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 40529e58629b ("eth: bnxt: improve the timing of stats")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 +++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  6 ++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6c78fc85eafa50..2dece9aad5b95a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1803,7 +1803,8 @@ static inline struct sk_buff *bnxt_gro_skb(struct bnxt *bp,
 					   struct bnxt_tpa_info *tpa_info,
 					   struct rx_tpa_end_cmp *tpa_end,
 					   struct rx_tpa_end_cmp_ext *tpa_end1,
-					   struct sk_buff *skb)
+					   struct sk_buff *skb,
+					   struct bnxt_rx_sw_stats *rx_stats)
 {
 #ifdef CONFIG_INET
 	int payload_off;
@@ -1813,6 +1814,9 @@ static inline struct sk_buff *bnxt_gro_skb(struct bnxt *bp,
 	if (segs == 1)
 		return skb;
 
+	rx_stats->rx_hw_gro_packets++;
+	rx_stats->rx_hw_gro_wire_packets += segs;
+
 	NAPI_GRO_CB(skb)->count = segs;
 	skb_shinfo(skb)->gso_size =
 		le32_to_cpu(tpa_end1->rx_tpa_end_cmp_seg_len);
@@ -1986,7 +1990,8 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 	}
 
 	if (gro)
-		skb = bnxt_gro_skb(bp, tpa_info, tpa_end, tpa_end1, skb);
+		skb = bnxt_gro_skb(bp, tpa_info, tpa_end, tpa_end1, skb,
+				   &cpr->sw_stats->rx);
 
 	return skb;
 }
@@ -13413,6 +13418,8 @@ static void bnxt_get_one_ring_err_stats(struct bnxt *bp,
 	stats->rx_total_netpoll_discards += sw_stats->rx.rx_netpoll_discards;
 	stats->rx_total_ring_discards +=
 		BNXT_GET_RING_STATS64(hw_stats, rx_discard_pkts);
+	stats->rx_total_hw_gro_packets += sw_stats->rx.rx_hw_gro_packets;
+	stats->rx_total_hw_gro_wire_packets += sw_stats->rx.rx_hw_gro_wire_packets;
 	stats->tx_total_resets += sw_stats->tx.tx_resets;
 	stats->tx_total_ring_discards +=
 		BNXT_GET_RING_STATS64(hw_stats, tx_discard_pkts);
@@ -15844,6 +15851,8 @@ static void bnxt_get_queue_stats_rx(struct net_device *dev, int i,
 	stats->bytes += BNXT_GET_RING_STATS64(sw, rx_bcast_bytes);
 
 	stats->alloc_fail = cpr->sw_stats->rx.rx_oom_discards;
+	stats->hw_gro_packets = cpr->sw_stats->rx.rx_hw_gro_packets;
+	stats->hw_gro_wire_packets = cpr->sw_stats->rx.rx_hw_gro_wire_packets;
 }
 
 static void bnxt_get_queue_stats_tx(struct net_device *dev, int i,
@@ -15879,6 +15888,8 @@ static void bnxt_get_base_stats(struct net_device *dev,
 	rx->packets = bp->net_stats_prev.rx_packets;
 	rx->bytes = bp->net_stats_prev.rx_bytes;
 	rx->alloc_fail = bp->ring_err_stats_prev.rx_total_oom_discards;
+	rx->hw_gro_packets = bp->ring_err_stats_prev.rx_total_hw_gro_packets;
+	rx->hw_gro_wire_packets = bp->ring_err_stats_prev.rx_total_hw_gro_wire_packets;
 
 	tx->packets = bp->net_stats_prev.tx_packets;
 	tx->bytes = bp->net_stats_prev.tx_bytes;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c80603704838db..b326a814b1f7a7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1123,8 +1123,11 @@ struct bnxt_rx_sw_stats {
 	u64			rx_l4_csum_errors;
 	u64			rx_resets;
 	u64			rx_buf_errors;
+	/* end of ethtool -S stats */
 	u64			rx_oom_discards;
 	u64			rx_netpoll_discards;
+	u64			rx_hw_gro_packets;
+	u64			rx_hw_gro_wire_packets;
 };
 
 struct bnxt_tx_sw_stats {
@@ -1151,6 +1154,9 @@ struct bnxt_total_ring_err_stats {
 	u64			tx_total_resets;
 	u64			tx_total_ring_discards;
 	u64			total_missed_irqs;
+	/* end of ethtool -S stats */
+	u64			rx_total_hw_gro_packets;
+	u64			rx_total_hw_gro_wire_packets;
 };
 
 struct bnxt_stats_mem {
-- 
2.53.0



