Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485EB1D47C3;
	Wed, 19 Mar 2025 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395022; cv=none; b=aodRey9iP5VD7N6Pku9dHy9KWW3DhMcg9wP3CpSdIIFjSt2lXNCfL1zhPZPF2AEby4DSYG39HWtddkZSoQ74qRf2bFJgKdwLsxRIwtCrIeAaM2rZ7u6RR3tyfop+pSRhUxjxRfYocGYJE+ds6OWqCj2zoHHOdUEqh/WgHT3UIZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395022; c=relaxed/simple;
	bh=sF4gxrfIuSzd4lyymU9cNveRBhZxNMP5IyZ4DzuKSME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQR+VeyHfsDrMJvG8Z4SWeqsBB+MK+2BDB+FrWDwtpXX2r7rKib3/XGIe0PQhp4tOFGQUhQklk8Dtiv4E0kNTMKiGj4BZIFcYRkgFxlgC6JeqxU5cJNW3Z5rM/ijUsfARPlUkAG8wl3vP/uyM/CRZQe+Lw28BpidAF+1l4e6eok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHPYh7AS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHPYh7AS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136A5C4CEE4;
	Wed, 19 Mar 2025 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395022;
	bh=sF4gxrfIuSzd4lyymU9cNveRBhZxNMP5IyZ4DzuKSME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHPYh7ASms7c/2oBQknY8JJSBkmYurRlEcn1lUI9KO4j21APwMR1MUjBjFQVh+r6g
	 ehbh0KGwwNQmY8lEYw+4nSZee2ABxKWMTrhzDjIFai9+a80icU9LvlRmy2/+HSb/xb
	 N59xvzfPtw9cfufFb/3epffRG0cddO7sYmrEp67s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	David Wei <dw@davidwei.uk>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/231] bnxt_en: refactor tpa_info alloc/free into helpers
Date: Wed, 19 Mar 2025 07:28:49 -0700
Message-ID: <20250319143027.705041589@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Wei <dw@davidwei.uk>

[ Upstream commit 5883a3e0babf55d85422fddec3422f211c853f6e ]

Refactor bnxt_rx_ring_info->tpa_info operations into helpers that work
on a single tpa_info in prep for queue API using them.

There are 2 pairs of operations:

* bnxt_alloc_one_tpa_info()
* bnxt_free_one_tpa_info()

These alloc/free the tpa_info array itself.

* bnxt_alloc_one_tpa_info_data()
* bnxt_free_one_tpa_info_data()

These alloc/free the frags stored in tpa_info array.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: David Wei <dw@davidwei.uk>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20241204041022.56512-2-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 87dd2850835d ("eth: bnxt: fix memory leak in queue reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 142 ++++++++++++++--------
 1 file changed, 90 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b97bced5c002c..800a63daba2b4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3363,15 +3363,11 @@ static void bnxt_free_one_rx_agg_ring(struct bnxt *bp, struct bnxt_rx_ring_info
 	}
 }
 
-static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
+static void bnxt_free_one_tpa_info_data(struct bnxt *bp,
+					struct bnxt_rx_ring_info *rxr)
 {
-	struct bnxt_rx_ring_info *rxr = &bp->rx_ring[ring_nr];
-	struct bnxt_tpa_idx_map *map;
 	int i;
 
-	if (!rxr->rx_tpa)
-		goto skip_rx_tpa_free;
-
 	for (i = 0; i < bp->max_tpa; i++) {
 		struct bnxt_tpa_info *tpa_info = &rxr->rx_tpa[i];
 		u8 *data = tpa_info->data;
@@ -3382,6 +3378,17 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 		tpa_info->data = NULL;
 		page_pool_free_va(rxr->head_pool, data, false);
 	}
+}
+
+static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp,
+				       struct bnxt_rx_ring_info *rxr)
+{
+	struct bnxt_tpa_idx_map *map;
+
+	if (!rxr->rx_tpa)
+		goto skip_rx_tpa_free;
+
+	bnxt_free_one_tpa_info_data(bp, rxr);
 
 skip_rx_tpa_free:
 	if (!rxr->rx_buf_ring)
@@ -3409,7 +3416,7 @@ static void bnxt_free_rx_skbs(struct bnxt *bp)
 		return;
 
 	for (i = 0; i < bp->rx_nr_rings; i++)
-		bnxt_free_one_rx_ring_skbs(bp, i);
+		bnxt_free_one_rx_ring_skbs(bp, &bp->rx_ring[i]);
 }
 
 static void bnxt_free_skbs(struct bnxt *bp)
@@ -3521,29 +3528,64 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 	return 0;
 }
 
+static void bnxt_free_one_tpa_info(struct bnxt *bp,
+				   struct bnxt_rx_ring_info *rxr)
+{
+	int i;
+
+	kfree(rxr->rx_tpa_idx_map);
+	rxr->rx_tpa_idx_map = NULL;
+	if (rxr->rx_tpa) {
+		for (i = 0; i < bp->max_tpa; i++) {
+			kfree(rxr->rx_tpa[i].agg_arr);
+			rxr->rx_tpa[i].agg_arr = NULL;
+		}
+	}
+	kfree(rxr->rx_tpa);
+	rxr->rx_tpa = NULL;
+}
+
 static void bnxt_free_tpa_info(struct bnxt *bp)
 {
-	int i, j;
+	int i;
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
 
-		kfree(rxr->rx_tpa_idx_map);
-		rxr->rx_tpa_idx_map = NULL;
-		if (rxr->rx_tpa) {
-			for (j = 0; j < bp->max_tpa; j++) {
-				kfree(rxr->rx_tpa[j].agg_arr);
-				rxr->rx_tpa[j].agg_arr = NULL;
-			}
-		}
-		kfree(rxr->rx_tpa);
-		rxr->rx_tpa = NULL;
+		bnxt_free_one_tpa_info(bp, rxr);
 	}
 }
 
+static int bnxt_alloc_one_tpa_info(struct bnxt *bp,
+				   struct bnxt_rx_ring_info *rxr)
+{
+	struct rx_agg_cmp *agg;
+	int i;
+
+	rxr->rx_tpa = kcalloc(bp->max_tpa, sizeof(struct bnxt_tpa_info),
+			      GFP_KERNEL);
+	if (!rxr->rx_tpa)
+		return -ENOMEM;
+
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5_PLUS))
+		return 0;
+	for (i = 0; i < bp->max_tpa; i++) {
+		agg = kcalloc(MAX_SKB_FRAGS, sizeof(*agg), GFP_KERNEL);
+		if (!agg)
+			return -ENOMEM;
+		rxr->rx_tpa[i].agg_arr = agg;
+	}
+	rxr->rx_tpa_idx_map = kzalloc(sizeof(*rxr->rx_tpa_idx_map),
+				      GFP_KERNEL);
+	if (!rxr->rx_tpa_idx_map)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int bnxt_alloc_tpa_info(struct bnxt *bp)
 {
-	int i, j;
+	int i, rc;
 
 	bp->max_tpa = MAX_TPA;
 	if (bp->flags & BNXT_FLAG_CHIP_P5_PLUS) {
@@ -3554,25 +3596,10 @@ static int bnxt_alloc_tpa_info(struct bnxt *bp)
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
-		struct rx_agg_cmp *agg;
-
-		rxr->rx_tpa = kcalloc(bp->max_tpa, sizeof(struct bnxt_tpa_info),
-				      GFP_KERNEL);
-		if (!rxr->rx_tpa)
-			return -ENOMEM;
 
-		if (!(bp->flags & BNXT_FLAG_CHIP_P5_PLUS))
-			continue;
-		for (j = 0; j < bp->max_tpa; j++) {
-			agg = kcalloc(MAX_SKB_FRAGS, sizeof(*agg), GFP_KERNEL);
-			if (!agg)
-				return -ENOMEM;
-			rxr->rx_tpa[j].agg_arr = agg;
-		}
-		rxr->rx_tpa_idx_map = kzalloc(sizeof(*rxr->rx_tpa_idx_map),
-					      GFP_KERNEL);
-		if (!rxr->rx_tpa_idx_map)
-			return -ENOMEM;
+		rc = bnxt_alloc_one_tpa_info(bp, rxr);
+		if (rc)
+			return rc;
 	}
 	return 0;
 }
@@ -4181,10 +4208,31 @@ static void bnxt_alloc_one_rx_ring_page(struct bnxt *bp,
 	rxr->rx_agg_prod = prod;
 }
 
+static int bnxt_alloc_one_tpa_info_data(struct bnxt *bp,
+					struct bnxt_rx_ring_info *rxr)
+{
+	dma_addr_t mapping;
+	u8 *data;
+	int i;
+
+	for (i = 0; i < bp->max_tpa; i++) {
+		data = __bnxt_alloc_rx_frag(bp, &mapping, rxr,
+					    GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+
+		rxr->rx_tpa[i].data = data;
+		rxr->rx_tpa[i].data_ptr = data + bp->rx_offset;
+		rxr->rx_tpa[i].mapping = mapping;
+	}
+
+	return 0;
+}
+
 static int bnxt_alloc_one_rx_ring(struct bnxt *bp, int ring_nr)
 {
 	struct bnxt_rx_ring_info *rxr = &bp->rx_ring[ring_nr];
-	int i;
+	int rc;
 
 	bnxt_alloc_one_rx_ring_skb(bp, rxr, ring_nr);
 
@@ -4194,19 +4242,9 @@ static int bnxt_alloc_one_rx_ring(struct bnxt *bp, int ring_nr)
 	bnxt_alloc_one_rx_ring_page(bp, rxr, ring_nr);
 
 	if (rxr->rx_tpa) {
-		dma_addr_t mapping;
-		u8 *data;
-
-		for (i = 0; i < bp->max_tpa; i++) {
-			data = __bnxt_alloc_rx_frag(bp, &mapping, rxr,
-						    GFP_KERNEL);
-			if (!data)
-				return -ENOMEM;
-
-			rxr->rx_tpa[i].data = data;
-			rxr->rx_tpa[i].data_ptr = data + bp->rx_offset;
-			rxr->rx_tpa[i].mapping = mapping;
-		}
+		rc = bnxt_alloc_one_tpa_info_data(bp, rxr);
+		if (rc)
+			return rc;
 	}
 	return 0;
 }
@@ -13463,7 +13501,7 @@ static void bnxt_rx_ring_reset(struct bnxt *bp)
 			bnxt_reset_task(bp, true);
 			break;
 		}
-		bnxt_free_one_rx_ring_skbs(bp, i);
+		bnxt_free_one_rx_ring_skbs(bp, rxr);
 		rxr->rx_prod = 0;
 		rxr->rx_agg_prod = 0;
 		rxr->rx_sw_agg_prod = 0;
-- 
2.39.5



