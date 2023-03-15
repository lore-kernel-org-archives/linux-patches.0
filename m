Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E008F4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690B8C433D2;
	Wed, 15 Mar 2023 12:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883747;
	bh=bmCvWM5EVpx7FteXmHjEP5hgqEpiIvki5zAkvaaBY2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4MLIZn457Rid/abohxXbvETw9jC7dkkzJJA67sfCdW9ygCbc3E4BdtxI2wEW1+vQ
	 94hGE1vsQ0zuFTWdZfTTh2EZO20dVOrW+MdnXegNAqiAff7M6L90s9P3THas8ppZtX
	 dbB9iej9R8W4vW0PACCYDDQiqxDnnYuuSVxEnu7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/143] bnxt_en: Avoid order-5 memory allocation for TPA data
Date: Wed, 15 Mar 2023 13:12:53 +0100
Message-Id: <20230315115743.173438123@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit accd7e23693aaaa9aa0d3e9eca0ae77d1be80ab3 ]

The driver needs to keep track of all the possible concurrent TPA (GRO/LRO)
completions on the aggregation ring.  On P5 chips, the maximum number
of concurrent TPA is 256 and the amount of memory we allocate is order-5
on systems using 4K pages.  Memory allocation failure has been reported:

NetworkManager: page allocation failure: order:5, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0-1
CPU: 15 PID: 2995 Comm: NetworkManager Kdump: loaded Not tainted 5.10.156 #1
Hardware name: Dell Inc. PowerEdge R660/0M1CC5, BIOS 0.2.25 08/12/2022
Call Trace:
 dump_stack+0x57/0x6e
 warn_alloc.cold.120+0x7b/0xdd
 ? _cond_resched+0x15/0x30
 ? __alloc_pages_direct_compact+0x15f/0x170
 __alloc_pages_slowpath.constprop.108+0xc58/0xc70
 __alloc_pages_nodemask+0x2d0/0x300
 kmalloc_order+0x24/0xe0
 kmalloc_order_trace+0x19/0x80
 bnxt_alloc_mem+0x1150/0x15c0 [bnxt_en]
 ? bnxt_get_func_stat_ctxs+0x13/0x60 [bnxt_en]
 __bnxt_open_nic+0x12e/0x780 [bnxt_en]
 bnxt_open+0x10b/0x240 [bnxt_en]
 __dev_open+0xe9/0x180
 __dev_change_flags+0x1af/0x220
 dev_change_flags+0x21/0x60
 do_setlink+0x35c/0x1100

Instead of allocating this big chunk of memory and dividing it up for the
concurrent TPA instances, allocate each small chunk separately for each
TPA instance.  This will reduce it to order-0 allocations.

Fixes: 79632e9ba386 ("bnxt_en: Expand bnxt_tpa_info struct to support 57500 chips.")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cecda545372f9..251b102d2792b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3143,7 +3143,7 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 
 static void bnxt_free_tpa_info(struct bnxt *bp)
 {
-	int i;
+	int i, j;
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
@@ -3151,8 +3151,10 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 		kfree(rxr->rx_tpa_idx_map);
 		rxr->rx_tpa_idx_map = NULL;
 		if (rxr->rx_tpa) {
-			kfree(rxr->rx_tpa[0].agg_arr);
-			rxr->rx_tpa[0].agg_arr = NULL;
+			for (j = 0; j < bp->max_tpa; j++) {
+				kfree(rxr->rx_tpa[j].agg_arr);
+				rxr->rx_tpa[j].agg_arr = NULL;
+			}
 		}
 		kfree(rxr->rx_tpa);
 		rxr->rx_tpa = NULL;
@@ -3161,14 +3163,13 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 
 static int bnxt_alloc_tpa_info(struct bnxt *bp)
 {
-	int i, j, total_aggs = 0;
+	int i, j;
 
 	bp->max_tpa = MAX_TPA;
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		if (!bp->max_tpa_v2)
 			return 0;
 		bp->max_tpa = max_t(u16, bp->max_tpa_v2, MAX_TPA_P5);
-		total_aggs = bp->max_tpa * MAX_SKB_FRAGS;
 	}
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
@@ -3182,12 +3183,12 @@ static int bnxt_alloc_tpa_info(struct bnxt *bp)
 
 		if (!(bp->flags & BNXT_FLAG_CHIP_P5))
 			continue;
-		agg = kcalloc(total_aggs, sizeof(*agg), GFP_KERNEL);
-		rxr->rx_tpa[0].agg_arr = agg;
-		if (!agg)
-			return -ENOMEM;
-		for (j = 1; j < bp->max_tpa; j++)
-			rxr->rx_tpa[j].agg_arr = agg + j * MAX_SKB_FRAGS;
+		for (j = 0; j < bp->max_tpa; j++) {
+			agg = kcalloc(MAX_SKB_FRAGS, sizeof(*agg), GFP_KERNEL);
+			if (!agg)
+				return -ENOMEM;
+			rxr->rx_tpa[j].agg_arr = agg;
+		}
 		rxr->rx_tpa_idx_map = kzalloc(sizeof(*rxr->rx_tpa_idx_map),
 					      GFP_KERNEL);
 		if (!rxr->rx_tpa_idx_map)
-- 
2.39.2



