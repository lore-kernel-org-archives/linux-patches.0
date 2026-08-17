Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEF93ED5A1;
	Mon, 17 Aug 2026 13:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974826; cv=none; b=JHgWVteoQhnc+5XXA6QEYvvXEV5JkQNaNpesKbxM++RsDxf9R6VUxOQfEOMooobWPu4OllxLv3rZU0mN4dWo8RdnnNv4RlWKCQ2TyNO2IfTyQwgc4H+68d8POEe540hvvrmgAQHiG0Z9xIO2QfQhoV2/G3HOup1wcNGyAlu9jlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974826; c=relaxed/simple;
	bh=10KfMDBfS8ZaJ452LhpIQdoPaokUwX+Y1VCDhfRqi8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oqo5HKAm64Jbfb5TOXy3TKCXO1hpivkRvP2/ag4F8C1+uNrEOAvUPimf4sNGGPv7aa/UUoLY0MemPVX2CNZrHnUXfZsmt1iwE/vFHq7wQNWJmNkQpPHgW6btbN3VEyRinKUABNhUl+47INgIWOUEJN9srMND2koH5T4ZdRw21LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTLLMono; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTLLMono"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ACB1F00A3E;
	Mon, 17 Aug 2026 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974816;
	bh=SJ5mPqCneZmwoKX23ge0YDlurmxUVeYGArFizj3/RAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTLLMonog1rCIWGFF71PoJI8wsaqvA8h0LMkRcx/cZNEoKQGtaMVzZ8PZ5Cpn0ght
	 FiJA5lb/Mn8/3na3CXcLWz3f+bRuPVESDd9TQ3GA/N+subQXdKPit9JpP1Hc3XPGqW
	 L81P9t8csfOI8NAqs4PJBVuP71FGcP1Ez5eSqQtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/250] eth: bnxt: support qcfg provided rx page size
Date: Mon, 17 Aug 2026 15:30:24 +0200
Message-ID: <20260817132539.032690053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit f96e1b35779e153be266fd7de50bda0c5553ad21 ]

Implement support for qcfg provided rx page sizes. For that, implement
the ndo_default_qcfg callback and validate the config on restart. Also,
use the current config's value in bnxt_init_ring_struct to retain the
correct size across resets.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Stable-dep-of: d1000fd7995e ("bnxt: fix memory leak in bnxt_queue_mem_alloc error cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 36 ++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fddfdf807950f..52b356f4966ab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4323,6 +4323,7 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 		struct bnxt_rx_ring_info *rxr;
 		struct bnxt_tx_ring_info *txr;
 		struct bnxt_ring_struct *ring;
+		struct netdev_rx_queue *rxq;
 
 		if (!bnapi)
 			continue;
@@ -4340,7 +4341,8 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 		if (!rxr)
 			goto skip_rx;
 
-		rxr->rx_page_size = BNXT_RX_PAGE_SIZE;
+		rxq = __netif_get_rx_queue(bp->dev, i);
+		rxr->rx_page_size = rxq->qcfg.rx_page_size;
 
 		ring = &rxr->rx_ring_struct;
 		rmem = &ring->ring_mem;
@@ -15964,6 +15966,29 @@ static const struct netdev_stat_ops bnxt_stat_ops = {
 	.get_base_stats		= bnxt_get_base_stats,
 };
 
+static void bnxt_queue_default_qcfg(struct net_device *dev,
+				    struct netdev_queue_config *qcfg)
+{
+	qcfg->rx_page_size = BNXT_RX_PAGE_SIZE;
+}
+
+static int bnxt_validate_qcfg(struct bnxt *bp, struct netdev_queue_config *qcfg)
+{
+	/* Older chips need MSS calc so rx_page_size is not supported */
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5_PLUS) &&
+	    qcfg->rx_page_size != BNXT_RX_PAGE_SIZE)
+		return -EINVAL;
+
+	if (!is_power_of_2(qcfg->rx_page_size))
+		return -ERANGE;
+
+	if (qcfg->rx_page_size < BNXT_RX_PAGE_SIZE ||
+	    qcfg->rx_page_size > BNXT_MAX_RX_PAGE_SIZE)
+		return -ERANGE;
+
+	return 0;
+}
+
 static int bnxt_queue_mem_alloc(struct net_device *dev,
 				struct netdev_queue_config *qcfg,
 				void *qmem, int idx)
@@ -15976,6 +16001,10 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	if (!bp->rx_ring)
 		return -ENETDOWN;
 
+	rc = bnxt_validate_qcfg(bp, qcfg);
+	if (rc < 0)
+		return rc;
+
 	rxr = &bp->rx_ring[idx];
 	clone = qmem;
 	memcpy(clone, rxr, sizeof(*rxr));
@@ -15987,6 +16016,7 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	clone->rx_sw_agg_prod = 0;
 	clone->rx_next_cons = 0;
 	clone->need_head_pool = false;
+	clone->rx_page_size = qcfg->rx_page_size;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)
@@ -16113,6 +16143,8 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
 	src_ring = &src->rx_agg_ring_struct;
 	src_rmem = &src_ring->ring_mem;
 
+	dst->rx_page_size = src->rx_page_size;
+
 	WARN_ON(dst_rmem->nr_pages != src_rmem->nr_pages);
 	WARN_ON(dst_rmem->page_size != src_rmem->page_size);
 	WARN_ON(dst_rmem->flags != src_rmem->flags);
@@ -16267,6 +16299,8 @@ static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 	.ndo_queue_mem_free	= bnxt_queue_mem_free,
 	.ndo_queue_start	= bnxt_queue_start,
 	.ndo_queue_stop		= bnxt_queue_stop,
+	.ndo_default_qcfg	= bnxt_queue_default_qcfg,
+	.supported_params	= QCFG_RX_PAGE_SIZE,
 };
 
 static void bnxt_remove_one(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 9a1be6b71219d..3ca989da0eb02 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -760,6 +760,7 @@ struct nqe_cn {
 #endif
 
 #define BNXT_RX_PAGE_SIZE (1 << BNXT_RX_PAGE_SHIFT)
+#define BNXT_MAX_RX_PAGE_SIZE BIT(15)
 
 #define BNXT_MAX_MTU		9500
 
-- 
2.53.0



