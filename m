Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3576451A747;
	Wed, 30 Sep 2026 17:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790234; cv=none; b=gc2JDaeaJbXDcEGdJmL2aGWR5ZoO/Yx78chL9T0IdMAN4vvBEEh1imsqGW9zqQ5HXN34c5cbE7S0Mlah54Rg2SFm8Pp0UU1GAx07PjEmwip7ZmStWAaUsEFaybfA+yv9yQQQ+2aiahhSVXVIG6zbMTaGi3rl7uGFVt436gaqaa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790234; c=relaxed/simple;
	bh=pfA8/7qGQAhe9ZskRjZirsqEkUWm0hG/DtfSFvBAqRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNZ0r37Pag1AdnXBdwr3DGNt6X7HyA9cEnNFqKjLlJeBURRz4lxnzSodLiw8MwZukAuIc+dl9x1TxDnjh9tD1m6rR/PlGE7G+wXYZFW3mZiJqKpKF2hfHvtposgOZhJ/ymiTryzmpG/CoJ15g6J4OrUf6id5R1tIGo7mCaRXln4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyBttz8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyBttz8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3FD1F000FF;
	Wed, 30 Sep 2026 17:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790233;
	bh=irSnhIouWUKaMSa4/dmScHHrIHGGS0sjJkzOUz/HZ7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyBttz8oFYtNMm7Hdt79z8PXnm81/K4nw+5bwh1vFEWJiHcVAiinpnx13qbKnd7pB
	 eGgiTtYWfKTjOTpsj42Bmrndx10cMUDWuKuvv2Sqp36qx0a2ASXnZwsJMuGOCI+2Jg
	 8l39ZgRp3GDNCCqD63vUkNCytPtlgjaj1uaarkLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 757/877] page_pool: disable sync for cpu for dmabuf memory provider
Date: Wed, 30 Sep 2026 17:27:48 +0200
Message-ID: <20260930152431.034873563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit 7dba339faae991a23c54f7b93a58798c58f8c16f ]

dmabuf dma-addresses should not be dma_sync'd for CPU/device. Typically
its the driver responsibility to dma_sync for CPU, but the driver should
not dma_sync for CPU if the netmem is actually coming from a dmabuf
memory provider.

The page_pool already exposes a helper for dma_sync_for_cpu:
page_pool_dma_sync_for_cpu. Upgrade this existing helper to handle
netmem, and have it skip dma_sync if the memory is from a dmabuf memory
provider. Drivers should migrate to using this helper when adding
support for netmem.

Also minimize the impact on the dma syncing performance for pages. Special
case the dma-sync path for pages to not go through the overhead checks
for dma-syncing and conversion to netmem.

Cc: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20241211212033.1684197-5-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b814dfbfeb0a ("bnxt_en: Propagate TPA buffer allocation failures in bnxt_queue_mem_alloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/page_pool/helpers.h |   35 ++++++++++++++++++++++++++++++-----
 include/net/page_pool/types.h   |    3 ++-
 net/core/devmem.c               |    1 +
 net/core/page_pool.c            |    1 +
 4 files changed, 34 insertions(+), 6 deletions(-)

--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -418,7 +418,21 @@ static inline dma_addr_t page_pool_get_d
  */
 static inline dma_addr_t page_pool_get_dma_addr(const struct page *page)
 {
-	return page_pool_get_dma_addr_netmem(page_to_netmem((struct page *)page));
+	dma_addr_t ret = page->dma_addr;
+
+	if (PAGE_POOL_32BIT_ARCH_WITH_64BIT_DMA)
+		ret <<= PAGE_SHIFT;
+
+	return ret;
+}
+
+static inline void __page_pool_dma_sync_for_cpu(const struct page_pool *pool,
+						const dma_addr_t dma_addr,
+						u32 offset, u32 dma_sync_size)
+{
+	dma_sync_single_range_for_cpu(pool->p.dev, dma_addr,
+				      offset + pool->p.offset, dma_sync_size,
+				      page_pool_get_dma_dir(pool));
 }
 
 /**
@@ -437,10 +451,21 @@ static inline void page_pool_dma_sync_fo
 					      const struct page *page,
 					      u32 offset, u32 dma_sync_size)
 {
-	dma_sync_single_range_for_cpu(pool->p.dev,
-				      page_pool_get_dma_addr(page),
-				      offset + pool->p.offset, dma_sync_size,
-				      page_pool_get_dma_dir(pool));
+	__page_pool_dma_sync_for_cpu(pool, page_pool_get_dma_addr(page), offset,
+				     dma_sync_size);
+}
+
+static inline void
+page_pool_dma_sync_netmem_for_cpu(const struct page_pool *pool,
+				  const netmem_ref netmem, u32 offset,
+				  u32 dma_sync_size)
+{
+	if (!pool->dma_sync_for_cpu)
+		return;
+
+	__page_pool_dma_sync_for_cpu(pool,
+				     page_pool_get_dma_addr_netmem(netmem),
+				     offset, dma_sync_size);
 }
 
 static inline bool page_pool_put(struct page_pool *pool)
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -171,7 +171,8 @@ struct page_pool {
 
 	bool has_init_callback:1;	/* slow::init_callback is set */
 	bool dma_map:1;			/* Perform DMA mapping */
-	bool dma_sync:1;		/* Perform DMA sync */
+	bool dma_sync:1;		/* Perform DMA sync for device */
+	bool dma_sync_for_cpu:1;	/* Perform DMA sync for cpu */
 #ifdef CONFIG_PAGE_POOL_STATS
 	bool system:1;			/* This is a global percpu pool */
 #endif
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -343,6 +343,7 @@ int mp_dmabuf_devmem_init(struct page_po
 	 * dma_sync_for_cpu/device. Force disable dma_sync.
 	 */
 	pool->dma_sync = false;
+	pool->dma_sync_for_cpu = false;
 
 	if (pool->p.order != 0)
 		return -E2BIG;
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -203,6 +203,7 @@ static int page_pool_init(struct page_po
 	memcpy(&pool->slow, &params->slow, sizeof(pool->slow));
 
 	pool->cpuid = cpuid;
+	pool->dma_sync_for_cpu = true;
 
 	/* Validate only known flags were used */
 	if (pool->slow.flags & ~PP_FLAG_ALL)


