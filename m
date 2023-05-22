Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E49171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C7FC433D2;
	Mon, 22 May 2023 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784140;
	bh=j+o9PJ7QEnX9bYBbmVNQmkxlyPS35gxytrtl2LC+IWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbgbumyMocmdaQAcIdxDkAYNcCvoiqlFUq3zHTLhgUam6IlkpYMXIJzboPPGQB4PB
	 4Tkt5TKnqI09YbsixeaazYZ2FZzajKS0YmCkJx+p/5lLVoZ95XUMJ+909Hd62GlAre
	 Gsv0Q8Vx+pLUO72ke7rcUIccDORJ1oZV3kSBictE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.vnet.ibm.com>,
	Greg Joyce <gjoyce@linux.vnet.ibm.com>,
	Brian King <brking@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 277/292] powerpc/iommu: DMA address offset is incorrectly calculated with 2MB TCEs
Date: Mon, 22 May 2023 20:10:34 +0100
Message-Id: <20230522190412.864839165@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaurav Batra <gbatra@linux.vnet.ibm.com>

commit 096339ab84f36beae0b1db25e0ce63fb3873e8b2 upstream.

When DMA window is backed by 2MB TCEs, the DMA address for the mapped
page should be the offset of the page relative to the 2MB TCE. The code
was incorrectly setting the DMA address to the beginning of the TCE
range.

Mellanox driver is reporting timeout trying to ENABLE_HCA for an SR-IOV
ethernet port, when DMA window is backed by 2MB TCEs.

Fixes: 387273118714 ("powerps/pseries/dma: Add support for 2M IOMMU page size")
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Gaurav Batra <gbatra@linux.vnet.ibm.com>
Reviewed-by: Greg Joyce <gjoyce@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230504175913.83844-1-gbatra@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/iommu.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -517,7 +517,7 @@ int ppc_iommu_map_sg(struct device *dev,
 		/* Convert entry to a dma_addr_t */
 		entry += tbl->it_offset;
 		dma_addr = entry << tbl->it_page_shift;
-		dma_addr |= (s->offset & ~IOMMU_PAGE_MASK(tbl));
+		dma_addr |= (vaddr & ~IOMMU_PAGE_MASK(tbl));
 
 		DBG("  - %lu pages, entry: %lx, dma_addr: %lx\n",
 			    npages, entry, dma_addr);
@@ -904,6 +904,7 @@ void *iommu_alloc_coherent(struct device
 	unsigned int order;
 	unsigned int nio_pages, io_order;
 	struct page *page;
+	int tcesize = (1 << tbl->it_page_shift);
 
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
@@ -930,7 +931,8 @@ void *iommu_alloc_coherent(struct device
 	memset(ret, 0, size);
 
 	/* Set up tces to cover the allocated range */
-	nio_pages = size >> tbl->it_page_shift;
+	nio_pages = IOMMU_PAGE_ALIGN(size, tbl) >> tbl->it_page_shift;
+
 	io_order = get_iommu_order(size, tbl);
 	mapping = iommu_alloc(dev, tbl, ret, nio_pages, DMA_BIDIRECTIONAL,
 			      mask >> tbl->it_page_shift, io_order, 0);
@@ -938,7 +940,8 @@ void *iommu_alloc_coherent(struct device
 		free_pages((unsigned long)ret, order);
 		return NULL;
 	}
-	*dma_handle = mapping;
+
+	*dma_handle = mapping | ((u64)ret & (tcesize - 1));
 	return ret;
 }
 
@@ -949,7 +952,7 @@ void iommu_free_coherent(struct iommu_ta
 		unsigned int nio_pages;
 
 		size = PAGE_ALIGN(size);
-		nio_pages = size >> tbl->it_page_shift;
+		nio_pages = IOMMU_PAGE_ALIGN(size, tbl) >> tbl->it_page_shift;
 		iommu_free(tbl, dma_handle, nio_pages);
 		size = PAGE_ALIGN(size);
 		free_pages((unsigned long)vaddr, get_order(size));


