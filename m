Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FE21D47C3;
	Wed, 19 Mar 2025 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395023; cv=none; b=SG3EcogW9MjNXY5o+ZLdiSAwC//lOa+s9vdOKiEfOvoS0n9exo7xxW/R884kBSAWBY3uP0cpk6YqchqJ0x+XSdo6rBt1lIfVcvXZfJqLgYY7rcFtVPextdoGLIU2k660GU6mTOzzeKfMlfZ7Nz99uIPOIHxWUQhhXUmik8OiQDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395023; c=relaxed/simple;
	bh=Jj1jZoile5EOrcH6hY1xUKwpoqqkr1bp7m8DKkQr/sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFfIibI2DwDG6koLmE8K3NMgsAnJuJV5tR99yx0vEqlzvslGA1J5bAONtOBdiJtsg9hFcsT095btqJt1bLQf3AnSZ5CNOFEmRLkXuXfa30ZG7A191cwCf+JrgBthr8fhqsyX4JhAZG3XzERAtW0o6kZeZTpIqidtUTZjs2GuSJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHgAbprR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHgAbprR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC52BC4CEE4;
	Wed, 19 Mar 2025 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395022;
	bh=Jj1jZoile5EOrcH6hY1xUKwpoqqkr1bp7m8DKkQr/sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHgAbprRnnFqYVCLhrRxd1YEyjpAGtvi522Yz6UaK6suh+se7T3vf815ngOcDfr8J
	 xFz6WVOj7vjNvvU9HlgnZNgNb2x+uPFUiE7jA04XT+TUr0p/1UtyKfhAe+umNk5SSo
	 Pi2SCYCphyiofjlDavNRvNZoe1U6gm6rSLvCKE/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/231] bnxt_en: handle tpa_info in queue API implementation
Date: Wed, 19 Mar 2025 07:28:50 -0700
Message-ID: <20250319143027.729123968@linuxfoundation.org>
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

[ Upstream commit bd649c5cc958169b8a8a3e77ea926d92d472b02a ]

Commit 7ed816be35ab ("eth: bnxt: use page pool for head frags") added a
page pool for header frags, which may be distinct from the existing pool
for the aggregation ring. Prior to this change, frags used in the TPA
ring rx_tpa were allocated from system memory e.g. napi_alloc_frag()
meaning their lifetimes were not associated with a page pool. They can
be returned at any time and so the queue API did not alloc or free
rx_tpa.

But now frags come from a separate head_pool which may be different to
page_pool. Without allocating and freeing rx_tpa, frags allocated from
the old head_pool may be returned to a different new head_pool which
causes a mismatch between the pp hold/release count.

Fix this problem by properly freeing and allocating rx_tpa in the queue
API implementation.

Signed-off-by: David Wei <dw@davidwei.uk>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20241204041022.56512-4-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 87dd2850835d ("eth: bnxt: fix memory leak in queue reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 27 +++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 800a63daba2b4..ee52ac821ef9a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3623,7 +3623,7 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 			xdp_rxq_info_unreg(&rxr->xdp_rxq);
 
 		page_pool_destroy(rxr->page_pool);
-		if (rxr->page_pool != rxr->head_pool)
+		if (bnxt_separate_head_pool())
 			page_pool_destroy(rxr->head_pool);
 		rxr->page_pool = rxr->head_pool = NULL;
 
@@ -15199,15 +15199,25 @@ static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
 			goto err_free_rx_agg_ring;
 	}
 
+	if (bp->flags & BNXT_FLAG_TPA) {
+		rc = bnxt_alloc_one_tpa_info(bp, clone);
+		if (rc)
+			goto err_free_tpa_info;
+	}
+
 	bnxt_init_one_rx_ring_rxbd(bp, clone);
 	bnxt_init_one_rx_agg_ring_rxbd(bp, clone);
 
 	bnxt_alloc_one_rx_ring_skb(bp, clone, idx);
 	if (bp->flags & BNXT_FLAG_AGG_RINGS)
 		bnxt_alloc_one_rx_ring_page(bp, clone, idx);
+	if (bp->flags & BNXT_FLAG_TPA)
+		bnxt_alloc_one_tpa_info_data(bp, clone);
 
 	return 0;
 
+err_free_tpa_info:
+	bnxt_free_one_tpa_info(bp, clone);
 err_free_rx_agg_ring:
 	bnxt_free_ring(bp, &clone->rx_agg_ring_struct.ring_mem);
 err_free_rx_ring:
@@ -15215,9 +15225,11 @@ static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
 err_rxq_info_unreg:
 	xdp_rxq_info_unreg(&clone->xdp_rxq);
 err_page_pool_destroy:
-	clone->page_pool->p.napi = NULL;
 	page_pool_destroy(clone->page_pool);
+	if (bnxt_separate_head_pool())
+		page_pool_destroy(clone->head_pool);
 	clone->page_pool = NULL;
+	clone->head_pool = NULL;
 	return rc;
 }
 
@@ -15227,13 +15239,15 @@ static void bnxt_queue_mem_free(struct net_device *dev, void *qmem)
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_ring_struct *ring;
 
-	bnxt_free_one_rx_ring(bp, rxr);
-	bnxt_free_one_rx_agg_ring(bp, rxr);
+	bnxt_free_one_rx_ring_skbs(bp, rxr);
 
 	xdp_rxq_info_unreg(&rxr->xdp_rxq);
 
 	page_pool_destroy(rxr->page_pool);
+	if (bnxt_separate_head_pool())
+		page_pool_destroy(rxr->head_pool);
 	rxr->page_pool = NULL;
+	rxr->head_pool = NULL;
 
 	ring = &rxr->rx_ring_struct;
 	bnxt_free_ring(bp, &ring->ring_mem);
@@ -15315,7 +15329,10 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	rxr->rx_agg_prod = clone->rx_agg_prod;
 	rxr->rx_sw_agg_prod = clone->rx_sw_agg_prod;
 	rxr->rx_next_cons = clone->rx_next_cons;
+	rxr->rx_tpa = clone->rx_tpa;
+	rxr->rx_tpa_idx_map = clone->rx_tpa_idx_map;
 	rxr->page_pool = clone->page_pool;
+	rxr->head_pool = clone->head_pool;
 	rxr->xdp_rxq = clone->xdp_rxq;
 
 	bnxt_copy_rx_ring(bp, rxr, clone);
@@ -15376,6 +15393,8 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 	bnxt_hwrm_rx_agg_ring_free(bp, rxr, false);
 	rxr->rx_next_cons = 0;
 	page_pool_disable_direct_recycling(rxr->page_pool);
+	if (bnxt_separate_head_pool())
+		page_pool_disable_direct_recycling(rxr->head_pool);
 
 	memcpy(qmem, rxr, sizeof(*rxr));
 	bnxt_init_rx_ring_struct(bp, qmem);
-- 
2.39.5



