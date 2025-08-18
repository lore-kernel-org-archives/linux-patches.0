Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC95C322537;
	Mon, 18 Aug 2025 13:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523075; cv=none; b=GEaGVA6GuQGrJ8WYDIedQmIEUC1/UJrBab8g+gGpQ61HgoumMDErn/hWoDDi0MO9PnsinPpRnm4bh6Pm2ZJdr6sccs9Lmc74c0yj+EO31l/ixxVZcCcGodJYGmZb+e/WFs13SWxLemgYo3fHlm/kt/+68+UplJcdA+dAlG9Tjac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523075; c=relaxed/simple;
	bh=rQ9dbT6fJgpgkr4l5vdIzqCqXujaniFa1OBdiDrW2KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9e5d0uuFgs21tZ2epyhEVA/tynOm1/jHANrHANAQvBxSdrWomNKm8ieQ9NkbeiGEuMdVaAG7/7vEypRAE4asY7wqPPaZXUgK6ra8vjIUEXNLwohQ4zQtxCcpAETiGbdl3wHbRrDYIzISloHRGob/r4M/FFSyAVMgQTWx7hnI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDjtwN8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDjtwN8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F71C4CEF1;
	Mon, 18 Aug 2025 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523075;
	bh=rQ9dbT6fJgpgkr4l5vdIzqCqXujaniFa1OBdiDrW2KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDjtwN8b5GS5FHi0RLHfVWCOYu4PafriinD0ea89JyzHVgzGgZSJ17qwsIpQZ0apK
	 f7UEXKd3tJurO+agch+U482OzslBRsqC/D4lweZdiQ1LnJg3an0s/93rbIH5zYUZVg
	 KdYhsziO3MX3+N2CmiCz/yYM2uxOgFhp3TTXVh9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 064/515] net: page_pool: allow enabling recycling late, fix false positive warning
Date: Mon, 18 Aug 2025 14:40:50 +0200
Message-ID: <20250818124500.869312792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 64fdaa94bfe0cca3a0f4b2dd922486c5f59fe678 ]

Page pool can have pages "directly" (locklessly) recycled to it,
if the NAPI that owns the page pool is scheduled to run on the same CPU.
To make this safe we check that the NAPI is disabled while we destroy
the page pool. In most cases NAPI and page pool lifetimes are tied
together so this happens naturally.

The queue API expects the following order of calls:
 -> mem_alloc
    alloc new pp
 -> stop
    napi_disable
 -> start
    napi_enable
 -> mem_free
    free old pp

Here we allocate the page pool in ->mem_alloc and free in ->mem_free.
But the NAPIs are only stopped between ->stop and ->start. We created
page_pool_disable_direct_recycling() to safely shut down the recycling
in ->stop. This way the page_pool_destroy() call in ->mem_free doesn't
have to worry about recycling any more.

Unfortunately, the page_pool_disable_direct_recycling() is not enough
to deal with failures which necessitate freeing the _new_ page pool.
If we hit a failure in ->mem_alloc or ->stop the new page pool has
to be freed while the NAPI is active (assuming driver attaches the
page pool to an existing NAPI instance and doesn't reallocate NAPIs).

Freeing the new page pool is technically safe because it hasn't been
used for any packets, yet, so there can be no recycling. But the check
in napi_assert_will_not_race() has no way of knowing that. We could
check if page pool is empty but that'd make the check much less likely
to trigger during development.

Add page_pool_enable_direct_recycling(), pairing with
page_pool_disable_direct_recycling(). It will allow us to create the new
page pools in "disabled" state and only enable recycling when we know
the reconfig operation will not fail.

Coincidentally it will also let us re-enable the recycling for the old
pool, if the reconfig failed:

 -> mem_alloc (new)
 -> stop (old)
    # disables direct recycling for old
 -> start (new)
    # fail!!
 -> start (old)
    # go back to old pp but direct recycling is lost :(
 -> mem_free (new)

The new helper is idempotent to make the life easier for drivers,
which can operate in HDS mode and support zero-copy Rx.
The driver can call the helper twice whether there are two pools
or it has multiple references to a single pool.

Fixes: 40eca00ae605 ("bnxt_en: unlink page pool when stopping Rx queue")
Tested-by: David Wei <dw@davidwei.uk>
Link: https://patch.msgid.link/20250805003654.2944974-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |  9 ++++++-
 include/net/page_pool/types.h             |  2 ++
 net/core/page_pool.c                      | 29 +++++++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d66519ce57af..8021d97f3f22 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3779,7 +3779,6 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	if (BNXT_RX_PAGE_MODE(bp))
 		pp.pool_size += bp->rx_ring_size;
 	pp.nid = numa_node;
-	pp.napi = &rxr->bnapi->napi;
 	pp.netdev = bp->dev;
 	pp.dev = &bp->pdev->dev;
 	pp.dma_dir = bp->rx_dir;
@@ -3807,6 +3806,12 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	return PTR_ERR(pool);
 }
 
+static void bnxt_enable_rx_page_pool(struct bnxt_rx_ring_info *rxr)
+{
+	page_pool_enable_direct_recycling(rxr->head_pool, &rxr->bnapi->napi);
+	page_pool_enable_direct_recycling(rxr->page_pool, &rxr->bnapi->napi);
+}
+
 static int bnxt_alloc_rx_agg_bmap(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
 {
 	u16 mem_size;
@@ -3845,6 +3850,7 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 		rc = bnxt_alloc_rx_page_pool(bp, rxr, cpu_node);
 		if (rc)
 			return rc;
+		bnxt_enable_rx_page_pool(rxr);
 
 		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i, 0);
 		if (rc < 0)
@@ -15998,6 +16004,7 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 			goto err_reset;
 	}
 
+	bnxt_enable_rx_page_pool(rxr);
 	napi_enable_locked(&bnapi->napi);
 	bnxt_db_nq_arm(bp, &cpr->cp_db, cpr->cp_raw_cons);
 
diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 431b593de709..1509a536cb85 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -265,6 +265,8 @@ struct page_pool *page_pool_create_percpu(const struct page_pool_params *params,
 struct xdp_mem_info;
 
 #ifdef CONFIG_PAGE_POOL
+void page_pool_enable_direct_recycling(struct page_pool *pool,
+				       struct napi_struct *napi);
 void page_pool_disable_direct_recycling(struct page_pool *pool);
 void page_pool_destroy(struct page_pool *pool);
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3eabe78c93f4..ef870c21e854 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1201,6 +1201,35 @@ void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
 	pool->xdp_mem_id = mem->id;
 }
 
+/**
+ * page_pool_enable_direct_recycling() - mark page pool as owned by NAPI
+ * @pool: page pool to modify
+ * @napi: NAPI instance to associate the page pool with
+ *
+ * Associate a page pool with a NAPI instance for lockless page recycling.
+ * This is useful when a new page pool has to be added to a NAPI instance
+ * without disabling that NAPI instance, to mark the point at which control
+ * path "hands over" the page pool to the NAPI instance. In most cases driver
+ * can simply set the @napi field in struct page_pool_params, and does not
+ * have to call this helper.
+ *
+ * The function is idempotent, but does not implement any refcounting.
+ * Single page_pool_disable_direct_recycling() will disable recycling,
+ * no matter how many times enable was called.
+ */
+void page_pool_enable_direct_recycling(struct page_pool *pool,
+				       struct napi_struct *napi)
+{
+	if (READ_ONCE(pool->p.napi) == napi)
+		return;
+	WARN_ON(!napi || pool->p.napi);
+
+	mutex_lock(&page_pools_lock);
+	WRITE_ONCE(pool->p.napi, napi);
+	mutex_unlock(&page_pools_lock);
+}
+EXPORT_SYMBOL(page_pool_enable_direct_recycling);
+
 void page_pool_disable_direct_recycling(struct page_pool *pool)
 {
 	/* Disable direct recycling based on pool->cpuid.
-- 
2.50.1



