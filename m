Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673FA433BC7;
	Tue, 21 Jul 2026 19:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662947; cv=none; b=klS1lGRt1FhF9BoeIrHL9ILF8QukJbwDlMZO2IftIusAaFxBMLm6QTMZarItu3uW3L5G3lNu3squBh7jyx5juoa4e/RTejpJ/ru19Ltac4L85ZP3LgVJE3drqz11be2SwUMIH9zEn//yTwEaA9htVLbeZ9FamDGGHPKvgp0SlC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662947; c=relaxed/simple;
	bh=rj4Av1NU5Zmn+AX5mz0fwrY1RlwtE9P3KbueKa+5C1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OajHwIoXwqMPwH9DGvVJTQVHGCyeBUcLgIWlZDgWe9UZCAadfz0ztcAgQi35qPuEGZEywTvaQbzghraBZZSe7M+Gfk4w4rZ6/t0q8v9RIUyUoVdZ6/BlzzAphUhzpfQBSFhnHwPKABEPRAiIStXj+zcdPqd4mhrcQQTQGXqI9h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HR6MBcTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HR6MBcTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58481F000E9;
	Tue, 21 Jul 2026 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662946;
	bh=CXxmLUNzqzJB69fDLzTcD5ZNpzhDKwAXs1I3J73D9e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HR6MBcTNfBDzyl8YIrD7sUKnFuXBBtAnH6SLuOzKaqKcjHBX5vk13ydfYHUsy7tNv
	 5qfVy+4QNnY93Ho6pR9Y07hz7hmNJgTpoN4hBZV6huvOGWDQszhbeMgRnz+GzoN1cf
	 rovDrkbS9EZWmvM/QipdSZnZYvXEQmR0u4TTtHCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0636/1276] eth: bnxt: gather and report HW-GRO stats
Date: Tue, 21 Jul 2026 17:17:59 +0200
Message-ID: <20260721152500.343931047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cff92020b381f8..b0a89a5df73777 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1733,7 +1733,8 @@ static inline struct sk_buff *bnxt_gro_skb(struct bnxt *bp,
 					   struct bnxt_tpa_info *tpa_info,
 					   struct rx_tpa_end_cmp *tpa_end,
 					   struct rx_tpa_end_cmp_ext *tpa_end1,
-					   struct sk_buff *skb)
+					   struct sk_buff *skb,
+					   struct bnxt_rx_sw_stats *rx_stats)
 {
 #ifdef CONFIG_INET
 	int payload_off;
@@ -1743,6 +1744,9 @@ static inline struct sk_buff *bnxt_gro_skb(struct bnxt *bp,
 	if (segs == 1)
 		return skb;
 
+	rx_stats->rx_hw_gro_packets++;
+	rx_stats->rx_hw_gro_wire_packets += segs;
+
 	NAPI_GRO_CB(skb)->count = segs;
 	skb_shinfo(skb)->gso_size =
 		le32_to_cpu(tpa_end1->rx_tpa_end_cmp_seg_len);
@@ -1915,7 +1919,8 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 	}
 
 	if (gro)
-		skb = bnxt_gro_skb(bp, tpa_info, tpa_end, tpa_end1, skb);
+		skb = bnxt_gro_skb(bp, tpa_info, tpa_end, tpa_end1, skb,
+				   &cpr->sw_stats->rx);
 
 	return skb;
 }
@@ -12816,6 +12821,8 @@ static void bnxt_get_one_ring_err_stats(struct bnxt *bp,
 	stats->rx_total_netpoll_discards += sw_stats->rx.rx_netpoll_discards;
 	stats->rx_total_ring_discards +=
 		BNXT_GET_RING_STATS64(hw_stats, rx_discard_pkts);
+	stats->rx_total_hw_gro_packets += sw_stats->rx.rx_hw_gro_packets;
+	stats->rx_total_hw_gro_wire_packets += sw_stats->rx.rx_hw_gro_wire_packets;
 	stats->tx_total_resets += sw_stats->tx.tx_resets;
 	stats->tx_total_ring_discards +=
 		BNXT_GET_RING_STATS64(hw_stats, tx_discard_pkts);
@@ -15224,6 +15231,8 @@ static void bnxt_get_queue_stats_rx(struct net_device *dev, int i,
 	stats->bytes += BNXT_GET_RING_STATS64(sw, rx_bcast_bytes);
 
 	stats->alloc_fail = cpr->sw_stats->rx.rx_oom_discards;
+	stats->hw_gro_packets = cpr->sw_stats->rx.rx_hw_gro_packets;
+	stats->hw_gro_wire_packets = cpr->sw_stats->rx.rx_hw_gro_wire_packets;
 }
 
 static void bnxt_get_queue_stats_tx(struct net_device *dev, int i,
@@ -15259,6 +15268,8 @@ static void bnxt_get_base_stats(struct net_device *dev,
 	rx->packets = bp->net_stats_prev.rx_packets;
 	rx->bytes = bp->net_stats_prev.rx_bytes;
 	rx->alloc_fail = bp->ring_err_stats_prev.rx_total_oom_discards;
+	rx->hw_gro_packets = bp->ring_err_stats_prev.rx_total_hw_gro_packets;
+	rx->hw_gro_wire_packets = bp->ring_err_stats_prev.rx_total_hw_gro_wire_packets;
 
 	tx->packets = bp->net_stats_prev.tx_packets;
 	tx->bytes = bp->net_stats_prev.tx_bytes;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 38690fdc3c46cf..1e673df55c5edf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1113,8 +1113,11 @@ struct bnxt_rx_sw_stats {
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
@@ -1141,6 +1144,9 @@ struct bnxt_total_ring_err_stats {
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



