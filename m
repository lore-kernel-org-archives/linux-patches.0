Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B1E1E50A;
	Tue, 30 Apr 2024 11:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475468; cv=none; b=CGD8+nzj7hMKfMzFqex3Lzdtg+UiJlspVueckA7fAtIkkpLHQtTlWtItJaHvS7G+JQBW3nfyu5X/L0a+rC6cheBpWZYVfYF9mnHioYZC5lAWzBi4f1JbLT8OVVuM9Ra6KwEVisRNXccwao/PhFX1pxh52WWQTNjHmcpUE1w2IRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475468; c=relaxed/simple;
	bh=1X5DkIkzMd+3C9h3ReyhmpAUWEdk7CnZp3IJ7+b9FGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HBN2T1LNjDxl+zNrufETwSZufiPrFG8osWysQy2xdo/+K6n5M/MR+c0U2bNGmGNC3EsgbEvpcjLffbWMlMIuX2g6cMZeo3LTCco+tZF9dVsxHb2C1/TkdM/7n7bVMziMq9YQ/zWnLk+1tqd9kpfH3SdauTRmgljKEJEkF0HMw7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDvNcRbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDvNcRbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A71CC2BBFC;
	Tue, 30 Apr 2024 11:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475467;
	bh=1X5DkIkzMd+3C9h3ReyhmpAUWEdk7CnZp3IJ7+b9FGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDvNcRbLxFr1WGiVanqU00mzdAnaZUw6IbQv48/PYH0lOVdRyj75Vr+a0uW9JnRzQ
	 ALtdBc61GwcIWW2Pe1wXK+KlCKV5dbehEGksCOTRDQxf/R0Xukn7piR3xkhEvAkihr
	 DMauyq0800Iwl1gbIR3NUQJbjmshqM5Ixp7Vyme4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/186] drm/ttm: stop pooling cached NUMA pages v2
Date: Tue, 30 Apr 2024 12:39:16 +0200
Message-ID: <20240430103101.054379400@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <ckoenig.leichtzumerken@gmail.com>

[ Upstream commit b6976f323a8687cc0d55bc92c2086fd934324ed5 ]

We only pool write combined and uncached allocations because they
require extra overhead on allocation and release.

If we also pool cached NUMA it not only means some extra unnecessary
overhead, but also that under memory pressure it can happen that
pages from the wrong NUMA node enters the pool and are re-used
over and over again.

This can lead to performance reduction after running into memory
pressure.

v2: restructure and cleanup the code a bit from the internal hack to
    test this.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 4482d3c94d7f ("drm/ttm: add NUMA node id to the pool")
CC: stable@vger.kernel.org
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415134821.1919-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 38 +++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index c8ec6a2cac5d4..37c08fac7e7d0 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -287,17 +287,23 @@ static struct ttm_pool_type *ttm_pool_select_type(struct ttm_pool *pool,
 						  enum ttm_caching caching,
 						  unsigned int order)
 {
-	if (pool->use_dma_alloc || pool->nid != NUMA_NO_NODE)
+	if (pool->use_dma_alloc)
 		return &pool->caching[caching].orders[order];
 
 #ifdef CONFIG_X86
 	switch (caching) {
 	case ttm_write_combined:
+		if (pool->nid != NUMA_NO_NODE)
+			return &pool->caching[caching].orders[order];
+
 		if (pool->use_dma32)
 			return &global_dma32_write_combined[order];
 
 		return &global_write_combined[order];
 	case ttm_uncached:
+		if (pool->nid != NUMA_NO_NODE)
+			return &pool->caching[caching].orders[order];
+
 		if (pool->use_dma32)
 			return &global_dma32_uncached[order];
 
@@ -563,11 +569,17 @@ void ttm_pool_init(struct ttm_pool *pool, struct device *dev,
 	pool->use_dma_alloc = use_dma_alloc;
 	pool->use_dma32 = use_dma32;
 
-	if (use_dma_alloc || nid != NUMA_NO_NODE) {
-		for (i = 0; i < TTM_NUM_CACHING_TYPES; ++i)
-			for (j = 0; j < NR_PAGE_ORDERS; ++j)
-				ttm_pool_type_init(&pool->caching[i].orders[j],
-						   pool, i, j);
+	for (i = 0; i < TTM_NUM_CACHING_TYPES; ++i) {
+		for (j = 0; j < NR_PAGE_ORDERS; ++j) {
+			struct ttm_pool_type *pt;
+
+			/* Initialize only pool types which are actually used */
+			pt = ttm_pool_select_type(pool, i, j);
+			if (pt != &pool->caching[i].orders[j])
+				continue;
+
+			ttm_pool_type_init(pt, pool, i, j);
+		}
 	}
 }
 EXPORT_SYMBOL(ttm_pool_init);
@@ -584,10 +596,16 @@ void ttm_pool_fini(struct ttm_pool *pool)
 {
 	unsigned int i, j;
 
-	if (pool->use_dma_alloc || pool->nid != NUMA_NO_NODE) {
-		for (i = 0; i < TTM_NUM_CACHING_TYPES; ++i)
-			for (j = 0; j < NR_PAGE_ORDERS; ++j)
-				ttm_pool_type_fini(&pool->caching[i].orders[j]);
+	for (i = 0; i < TTM_NUM_CACHING_TYPES; ++i) {
+		for (j = 0; j < NR_PAGE_ORDERS; ++j) {
+			struct ttm_pool_type *pt;
+
+			pt = ttm_pool_select_type(pool, i, j);
+			if (pt != &pool->caching[i].orders[j])
+				continue;
+
+			ttm_pool_type_fini(pt);
+		}
 	}
 
 	/* We removed the pool types from the LRU, but we need to also make sure
-- 
2.43.0



