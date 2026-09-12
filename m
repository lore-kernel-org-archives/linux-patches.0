Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4B2369D4A;
	Sat, 12 Sep 2026 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224288; cv=none; b=ZZ8Ktp4ckScioWi4TUSJ3BY9W0FbmoFQ9YEEKG1HWCHgWOcC5bmooTlEZCX/iMyFvAd71uAQBDuFFazoWuY42m/CCGztJYj2UAEO20iRj15ElSY9u7ncUrBxrHJZdB0WPMtiXaoSdyk52TLSeMlQQ+oJLxthfEmnU95w+Pa92rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224288; c=relaxed/simple;
	bh=7ITDGj1c6UeKC0soXu5Cj6jqDEPgdK/5rKXPdC44VrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIm631oszbUSmdt6yjPSyHMfOqSaO2up51A0XbHYgL12p5UiEYpeFbc0kzP9Yh8ZZtVms22zS7x+/emEeY0yTMHOIcCSvtnsPY6CpXh8JN5MfAXoQb3sIfJ/nqwHtgUw59uceynEVW7qEl9z0XSpugNCZC+oQzrxVmBL/I08XbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjmkjReC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjmkjReC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773791F000FF;
	Sat, 12 Sep 2026 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224285;
	bh=Lwm7e+6innhk4bPI2eDA2GLOlWjrqgs9FGCrtjyDx8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjmkjReC4F8sXpnywBpt/kHSRmbD0Hscesvnvww/9tfPAFIq5rEZfK03iTrByws2q
	 L//FTAGTTIDyuB364PkprVzuL8ZrQYQmG4zNhmh4c4wvWrhW2QPJjwWufJqpg7Dw9Y
	 Vd0QIiTs8OhTUzWnO2omM/HoKvWjT1j8bKK3Rf2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Mostafa Saleh <smostafa@google.com>,
	Petr Tesarik <ptesarik@suse.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0963/1424] swiotlb: Preserve allocation virtual address for dynamic pools
Date: Sat, 12 Sep 2026 08:56:35 +0200
Message-ID: <20260912065628.878370942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

[ Upstream commit 57d29044d0f29a76c6ec0c112c8c7371d5608dc7 ]

swiotlb_alloc_tlb() can allocate from the DMA atomic pool when a decrypted
pool is needed from atomic context. With CONFIG_DMA_DIRECT_REMAP, the
atomic pool is backed by remapped virtual addresses, which are not the same
as the direct-map addresses returned by phys_to_virt().

swiotlb_init_io_tlb_pool() currently reconstructs the pool virtual address
from the physical start address. For atomic-pool backed allocations this
stores the wrong address in pool->vaddr. Later, swiotlb_free_tlb() passes
that address to dma_free_from_pool(), which will fail to recognize the
chunk

Pass the virtual address returned by the allocation path into
swiotlb_init_io_tlb_pool(), and store that address in pool->vaddr. This
keeps the pool free path using the same virtual address as the allocator.

Fixes: 79636caad361 ("swiotlb: if swiotlb is full, fall back to a transient memory pool")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Link: https://lore.kernel.org/r/20260717180442.110954-6-aneesh.kumar@kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 2959309c4fb82..0968155a638e3 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -268,9 +268,9 @@ void __init swiotlb_update_mem_attributes(void)
 }
 
 static void swiotlb_init_io_tlb_pool(struct io_tlb_pool *mem, phys_addr_t start,
-		unsigned long nslabs, bool late_alloc, unsigned int nareas)
+		void *vaddr, unsigned long nslabs, bool late_alloc,
+		unsigned int nareas)
 {
-	void *vaddr = phys_to_virt(start);
 	unsigned long bytes = nslabs << IO_TLB_SHIFT, i;
 
 	mem->nslabs = nslabs;
@@ -411,7 +411,7 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 		return;
 	}
 
-	swiotlb_init_io_tlb_pool(mem, __pa(tlb), nslabs, false, nareas);
+	swiotlb_init_io_tlb_pool(mem, __pa(tlb), tlb, nslabs, false, nareas);
 	add_mem_pool(&io_tlb_default_mem, mem);
 
 	if (flags & SWIOTLB_VERBOSE)
@@ -509,7 +509,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 
 	set_memory_decrypted((unsigned long)vstart,
 			     (nslabs << IO_TLB_SHIFT) >> PAGE_SHIFT);
-	swiotlb_init_io_tlb_pool(mem, virt_to_phys(vstart), nslabs, true,
+	swiotlb_init_io_tlb_pool(mem, virt_to_phys(vstart), vstart, nslabs, true,
 				 nareas);
 	add_mem_pool(&io_tlb_default_mem, mem);
 
@@ -607,25 +607,26 @@ static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes, u64 phys_limit)
  * @bytes:	Size of the buffer.
  * @phys_limit:	Maximum allowed physical address of the buffer.
  * @gfp:	GFP flags for the allocation.
+ * @vaddr:	Receives the virtual address for the allocated buffer.
  *
  * Return: Allocated pages, or %NULL on allocation failure.
  */
 static struct page *swiotlb_alloc_tlb(struct device *dev, size_t bytes,
-		u64 phys_limit, gfp_t gfp)
+		u64 phys_limit, gfp_t gfp, void **vaddr)
 {
 	struct page *page;
 
+	*vaddr = NULL;
+
 	/*
 	 * Allocate from the atomic pools if memory is encrypted and
 	 * the allocation is atomic, because decrypting may block.
 	 */
 	if (!gfpflags_allow_blocking(gfp) && dev && force_dma_unencrypted(dev)) {
-		void *vaddr;
-
 		if (!IS_ENABLED(CONFIG_DMA_COHERENT_POOL))
 			return NULL;
 
-		return dma_alloc_from_pool(dev, bytes, &vaddr, gfp,
+		return dma_alloc_from_pool(dev, bytes, vaddr, gfp,
 					   dma_coherent_ok);
 	}
 
@@ -647,6 +648,8 @@ static struct page *swiotlb_alloc_tlb(struct device *dev, size_t bytes,
 			return NULL;
 	}
 
+	if (page)
+		*vaddr = phys_to_virt(page_to_phys(page));
 	return page;
 }
 
@@ -687,6 +690,7 @@ static struct io_tlb_pool *swiotlb_alloc_pool(struct device *dev,
 {
 	struct io_tlb_pool *pool;
 	unsigned int slot_order;
+	void *tlb_vaddr;
 	struct page *tlb;
 	size_t pool_size;
 	size_t tlb_size;
@@ -703,7 +707,8 @@ static struct io_tlb_pool *swiotlb_alloc_pool(struct device *dev,
 	pool->areas = (void *)pool + sizeof(*pool);
 
 	tlb_size = nslabs << IO_TLB_SHIFT;
-	while (!(tlb = swiotlb_alloc_tlb(dev, tlb_size, phys_limit, gfp))) {
+	while (!(tlb = swiotlb_alloc_tlb(dev, tlb_size, phys_limit, gfp,
+					 &tlb_vaddr))) {
 		if (nslabs <= minslabs)
 			goto error_tlb;
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
@@ -717,11 +722,12 @@ static struct io_tlb_pool *swiotlb_alloc_pool(struct device *dev,
 	if (!pool->slots)
 		goto error_slots;
 
-	swiotlb_init_io_tlb_pool(pool, page_to_phys(tlb), nslabs, true, nareas);
+	swiotlb_init_io_tlb_pool(pool, page_to_phys(tlb), tlb_vaddr, nslabs,
+				 true, nareas);
 	return pool;
 
 error_slots:
-	swiotlb_free_tlb(page_address(tlb), tlb_size);
+	swiotlb_free_tlb(tlb_vaddr, tlb_size);
 error_tlb:
 	kfree(pool);
 error:
@@ -1746,7 +1752,8 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 
 		set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
 				     rmem->size >> PAGE_SHIFT);
-		swiotlb_init_io_tlb_pool(pool, rmem->base, nslabs,
+		swiotlb_init_io_tlb_pool(pool, rmem->base, phys_to_virt(rmem->base),
+					 nslabs,
 					 false, nareas);
 		mem->force_bounce = true;
 		mem->for_alloc = true;
-- 
2.53.0



