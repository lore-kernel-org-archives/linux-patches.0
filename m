Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D7F85274;
	Tue, 23 Apr 2024 21:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908557; cv=none; b=ZC3xWs3uidSmOS51lNb2iTPcGEDWz7AFJvSpHUauluxscqnhFBAspdzt8kuFlMjhvFHKlxoHcH/ytZyU/9Qz1qPV7nDbvTRY84tRF31MNdzXYvH15G/OCyV7b1sn9UG0JrTTKkTquh/6JIIermonNcW7DY8VPgB6gbiWCLEwcJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908557; c=relaxed/simple;
	bh=1HAtiFcCjFyGfI0IiI+flOZ1FxsFuO16oSRcEKjnoIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDgSqFlKyj/g1p19pabp9Gb51C/uPKTqQ97BdmMBezxCM3fWjt17g4LNQlrYoBnI/Olg/Zrkd4HxcdJeIJ8/JTaF4nqdnGs/e13OnGjQiWZyC3nJLm5FFDqvQ4nxVSvpsJHLxwvAPU5Psq+eHo32io6hGhhK/h2ru5NeevkTHM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3rP5aDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3rP5aDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A96EC3277B;
	Tue, 23 Apr 2024 21:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908557;
	bh=1HAtiFcCjFyGfI0IiI+flOZ1FxsFuO16oSRcEKjnoIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3rP5aDXMmDd9aXu9g2FFEQP/ytp/rC28Ba6AZne2RzfUQST1CK35Wu+C/AsOTQHU
	 Zf7OzyudXN97Hraw7oW85SxcbQp4AH3B6RUkEwC0wD4FudzIhs6tnIImp5zBNY86Gw
	 ZIkhyALpsHNNBMroyX0oG+e2DFZLz7jRKtIVs+ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>
Subject: [PATCH 6.8 143/158] drm/ttm: stop pooling cached NUMA pages v2
Date: Tue, 23 Apr 2024 14:39:25 -0700
Message-ID: <20240423213900.511839153@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <ckoenig.leichtzumerken@gmail.com>

commit b6976f323a8687cc0d55bc92c2086fd934324ed5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_pool.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -288,17 +288,23 @@ static struct ttm_pool_type *ttm_pool_se
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
 
@@ -566,11 +572,17 @@ void ttm_pool_init(struct ttm_pool *pool
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
@@ -599,10 +611,16 @@ void ttm_pool_fini(struct ttm_pool *pool
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


