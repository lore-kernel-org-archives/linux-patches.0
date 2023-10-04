Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447EE136C
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDv4nXyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96F6C433C8;
	Wed,  4 Oct 2023 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444208;
	bh=HmZft+h2vyo78N5b3gkszDY+CSGJ5eOIWVNovvxxRj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDv4nXyVJ+sl+zMtZWHbwAaAX7iJqG/jU0ssRh60yGsY5HcQlb4IGpNfrWBPvThJO
	 DptdWYva+JdjVBO8G/a5Ms5CJVSS/y159X65PFp6fIn3sxeL2h63nV1o2PBB5UvQDq
	 ain2zGmmH75ELPKdnW1DSUz1K0+5dpVvRqdyzhJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 168/321] parisc: ccio-dma: Fix sparse warnings
Date: Wed,  4 Oct 2023 19:55:13 +0200
Message-ID: <20231004175237.040787965@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 9a47a710cf517801a8b4fff9949c4cecb5fd019a ]

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parisc/ccio-dma.c      | 18 +++++++++---------
 drivers/parisc/iommu-helpers.h |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 10e846286f4ef..623707fc6ff1c 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -222,7 +222,7 @@ struct ioa_registers {
 struct ioc {
 	struct ioa_registers __iomem *ioc_regs;  /* I/O MMU base address */
 	u8  *res_map;	                /* resource map, bit == pdir entry */
-	u64 *pdir_base;	                /* physical base address */
+	__le64 *pdir_base;		/* physical base address */
 	u32 pdir_size;			/* bytes, function of IOV Space size */
 	u32 res_hint;			/* next available IOVP -
 					   circular search */
@@ -347,7 +347,7 @@ ccio_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 	BUG_ON(pages_needed == 0);
 	BUG_ON((pages_needed * IOVP_SIZE) > DMA_CHUNK_SIZE);
 
-	DBG_RES("%s() size: %d pages_needed %d\n",
+	DBG_RES("%s() size: %zu pages_needed %d\n",
 			__func__, size, pages_needed);
 
 	/*
@@ -435,7 +435,7 @@ ccio_free_range(struct ioc *ioc, dma_addr_t iova, unsigned long pages_mapped)
 	BUG_ON((pages_mapped * IOVP_SIZE) > DMA_CHUNK_SIZE);
 	BUG_ON(pages_mapped > BITS_PER_LONG);
 
-	DBG_RES("%s():  res_idx: %d pages_mapped %d\n", 
+	DBG_RES("%s():  res_idx: %d pages_mapped %lu\n",
 		__func__, res_idx, pages_mapped);
 
 #ifdef CCIO_COLLECT_STATS
@@ -551,7 +551,7 @@ static u32 hint_lookup[] = {
  * index are bits 12:19 of the value returned by LCI.
  */ 
 static void
-ccio_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned long vba,
+ccio_io_pdir_entry(__le64 *pdir_ptr, space_t sid, unsigned long vba,
 		   unsigned long hints)
 {
 	register unsigned long pa;
@@ -727,7 +727,7 @@ ccio_map_single(struct device *dev, void *addr, size_t size,
 	unsigned long flags;
 	dma_addr_t iovp;
 	dma_addr_t offset;
-	u64 *pdir_start;
+	__le64 *pdir_start;
 	unsigned long hint = hint_lookup[(int)direction];
 
 	BUG_ON(!dev);
@@ -754,8 +754,8 @@ ccio_map_single(struct device *dev, void *addr, size_t size,
 
 	pdir_start = &(ioc->pdir_base[idx]);
 
-	DBG_RUN("%s() 0x%p -> 0x%lx size: %0x%x\n",
-		__func__, addr, (long)iovp | offset, size);
+	DBG_RUN("%s() %px -> %#lx size: %zu\n",
+		__func__, addr, (long)(iovp | offset), size);
 
 	/* If not cacheline aligned, force SAFE_DMA on the whole mess */
 	if((size % L1_CACHE_BYTES) || ((unsigned long)addr % L1_CACHE_BYTES))
@@ -813,7 +813,7 @@ ccio_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
 		return;
 	}
 
-	DBG_RUN("%s() iovp 0x%lx/%x\n",
+	DBG_RUN("%s() iovp %#lx/%zx\n",
 		__func__, (long)iova, size);
 
 	iova ^= offset;        /* clear offset bits */
@@ -1291,7 +1291,7 @@ ccio_ioc_init(struct ioc *ioc)
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
-	ioc->pdir_base = (u64 *)__get_free_pages(GFP_KERNEL, 
+	ioc->pdir_base = (__le64 *)__get_free_pages(GFP_KERNEL,
 						 get_order(ioc->pdir_size));
 	if(NULL == ioc->pdir_base) {
 		panic("%s() could not allocate I/O Page Table\n", __func__);
diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
index a00c38b6224ab..c43f1a212a5c8 100644
--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -31,8 +31,8 @@ iommu_fill_pdir(struct ioc *ioc, struct scatterlist *startsg, int nents,
 		unsigned long vaddr;
 		long size;
 
-		DBG_RUN_SG(" %d : %08lx/%05x %p/%05x\n", nents,
-			   (unsigned long)sg_dma_address(startsg), cnt,
+		DBG_RUN_SG(" %d : %08lx %p/%05x\n", nents,
+			   (unsigned long)sg_dma_address(startsg),
 			   sg_virt(startsg), startsg->length
 		);
 
-- 
2.40.1



