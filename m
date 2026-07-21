Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A299244AB60;
	Tue, 21 Jul 2026 21:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669172; cv=none; b=gL5FTA6jQEThiekJGoJxSzUvQKSTH2aHUkuM7/katSUoLO6b98s1vP1VoUCvSAtwQLdwDTQqK0BB6sGD6YgWT5YlS23gSInde5oJ1FAEvP/D1xP2wD5ZWkrb4OB3e5t8Esn++tIRs1J+eHZnPQTJWFkqyPvV/Om4a4weTFgjUM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669172; c=relaxed/simple;
	bh=rBH/xwImEJwNfOeOKHUK4IDCO6AtaPfpZWbK7kyH7qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg0jjI1i8lJ9X+D0FiSEsKs/OXGUYuCw8SLH4iUG8R6UT/28TMW/enc/GIqaSRXRGdRrD5oWFiHFZ5ssVH4wvg1R7FRafZIXPJtgqkC45Oo7jPOEb0fe/TGDFI+U9Bvcu52qkovqiurIOBjjgAeotYtTHATL37WfLyJ5FpcUwwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwoL8jgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwoL8jgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135E11F000E9;
	Tue, 21 Jul 2026 21:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669171;
	bh=RtmCEPWsYinsl2Ude6YQI4BJEa69CsiQXnoMByfW5xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwoL8jggDegQi4YZvqYih2sqQTK+4wxBh/J2D59fufCKllwT+TPGqzaU2pxEh3pGL
	 bbCzD0MFQP2fgbbZtDSl8fMH8IvErG9SZSusKpFQMNP3jhQQew0m9OnLQlZwGLTjtg
	 vUfzIbjQYu84RjQTJJKO6takgzR4mH77pKqD69u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0453/1067] net: bcmgenet: Use weighted round-robin TX DMA arbitration
Date: Tue, 21 Jul 2026 17:17:34 +0200
Message-ID: <20260721152434.751878081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit fd615abd53110f0f815984e99e7cc51ca6b7d979 ]

Under heavy network traffic, we observed sporadic TX queue timeouts on the
Raspberry Pi 4. The timeouts can be reproduced by stress testing the TX
path with multiple concurrent iperf UDP streams:

    iperf3 -c <ip> -u -b0 -P16 -t60
    NETDEV WATCHDOG: CPU: 0: transmit queue 0 timed out 2044 ms
    NETDEV WATCHDOG: CPU: 3: transmit queue 0 timed out 2004 ms

Investigation showed that the timeouts are caused by the priority-based
arbiter. Under heavy load the highest priority queue starves the lower
priority ones, causing timeouts. The TX strict priority arbiter is not
suitable for the default use case where all the traffic gets spread
across all the TX queues.

Therefore, to fix this, switch the TX DMA arbiter to Weighted Round-Robin,
which services all queues, so they do not stall. The weights were chosen
to follow the existing priority scheme: q0 gets the smallest weight, while
q1-4 get the bulk of the TX bandwidth.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Link: https://patch.msgid.link/20260610085238.56300-1-ovidiu.panait.rb@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 23 +++++++------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ab06c676e2cbaa..a22f569987c6f8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -41,9 +41,8 @@
 
 #include "bcmgenet.h"
 
-/* Default highest priority queue for multi queue support */
-#define GENET_Q1_PRIORITY	0
-#define GENET_Q0_PRIORITY	1
+#define GENET_Q0_WEIGHT		1
+#define GENET_Q1_WEIGHT		4
 
 #define GENET_Q0_RX_BD_CNT	\
 	(TOTAL_DESC - priv->hw_params->rx_queues * priv->hw_params->rx_bds_per_q)
@@ -2081,13 +2080,6 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 	int i;
 
 	index = skb_get_queue_mapping(skb);
-	/* Mapping strategy:
-	 * queue_mapping = 0, unclassified, packet xmited through ring 0
-	 * queue_mapping = 1, goes to ring 1. (highest priority queue)
-	 * queue_mapping = 2, goes to ring 2.
-	 * queue_mapping = 3, goes to ring 3.
-	 * queue_mapping = 4, goes to ring 4.
-	 */
 	ring = &priv->tx_rings[index];
 	txq = netdev_get_tx_queue(dev, index);
 
@@ -2787,8 +2779,9 @@ static void bcmgenet_fini_tx_napi(struct bcmgenet_priv *priv)
 
 /* Initialize Tx queues
  *
- * Queues 1-4 are priority-based, each one has 32 descriptors,
- * with queue 1 being the highest priority queue.
+ * Queues 1-4 are the priority queues, each one has 32 descriptors.
+ * The weighted round-robin arbiter gives them a larger share of TX
+ * bandwidth than the default queue 0.
  *
  * Queue 0 is the default Tx queue with
  * GENET_Q0_TX_BD_CNT = 256 - 4 * 32 = 128 descriptors.
@@ -2816,8 +2809,8 @@ static void bcmgenet_init_tx_queues(struct net_device *dev)
 	dma_ctrl = 0;
 	ring_cfg = 0;
 
-	/* Enable strict priority arbiter mode */
-	bcmgenet_tdma_writel(priv, DMA_ARBITER_SP, DMA_ARB_CTRL);
+	/* Enable Weighted Round-Robin arbiter mode */
+	bcmgenet_tdma_writel(priv, DMA_ARBITER_WRR, DMA_ARB_CTRL);
 
 	/* Initialize Tx priority queues */
 	for (i = 0; i <= priv->hw_params->tx_queues; i++) {
@@ -2827,7 +2820,7 @@ static void bcmgenet_init_tx_queues(struct net_device *dev)
 		ring_cfg |= (1 << i);
 		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 		dma_priority[DMA_PRIO_REG_INDEX(i)] |=
-			(i ? GENET_Q1_PRIORITY : GENET_Q0_PRIORITY)
+			(i ? GENET_Q1_WEIGHT : GENET_Q0_WEIGHT)
 			<< DMA_PRIO_REG_SHIFT(i);
 	}
 
-- 
2.53.0



