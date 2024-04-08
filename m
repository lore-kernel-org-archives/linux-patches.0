Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D196371753;
	Mon,  8 Apr 2024 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582483; cv=none; b=OLAZ5pAAFvt+dO1+mJCszowWqFh/IhYx8l0Q7UBKIBiqURsS+rQ7QI8Lk2knMC0fxw7QKUtbxIahT0f0ga5JnVo5JuG8ufsSOk2WnE81511XW5KqNBIqwkaafIIzphoCsYDTKt6qwm+7KOqYaJe3dskoCsioJFkdLze3OkAFEbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582483; c=relaxed/simple;
	bh=wA1qilG9qCRDcR/dliWBXcoaOgaJJK14RrgHfWaM898=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDVC+foTXNVOI3LRH5VANSy9y/VVpHaqxmesui5iq3aUOn3klvuGtL/PervQF7OT52njWT5pq+4ZVimBXrYyOpRtEcyfXBusGMH88Yn5IPnLnTEOr5Sk/pYJH2haYNNmczwQhZoFlb8l1PToYppLH3ps0tYf5vMUdm6wHEiMn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUZ8CPzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUZ8CPzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBA0C43390;
	Mon,  8 Apr 2024 13:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582483;
	bh=wA1qilG9qCRDcR/dliWBXcoaOgaJJK14RrgHfWaM898=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUZ8CPzqoBhUlX+QqSzyKEaAWmsoUzIlfWkpkUoq/JISDi6TujhXFuuq0hTHiVjQ0
	 6kB3pBA2pE4DG6DP7HgG0RbamMkIme+oQj0XGlXtQcZ+coSbUXI0D62tyJe0vjALIg
	 f22I+3KPpesvNWMioU6aqTN6t1ssqWqRf3EsAJRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/690] dma-iommu: add iommu_dma_opt_mapping_size()
Date: Mon,  8 Apr 2024 14:50:10 +0200
Message-ID: <20240408125404.725357275@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.garry@huawei.com>

[ Upstream commit 6d9870b7e5def2450e21316515b9efc0529204dd ]

Add the IOMMU callback for DMA mapping API dma_opt_mapping_size(), which
allows the drivers to know the optimal mapping limit and thus limit the
requested IOVA lengths.

This value is based on the IOVA rcache range limit, as IOVAs allocated
above this limit must always be newly allocated, which may be quite slow.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: afc5aa46ed56 ("iommu/dma: Force swiotlb_max_mapping_size on an untrusted device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 6 ++++++
 drivers/iommu/iova.c      | 5 +++++
 include/linux/iova.h      | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 8cd63e6ccd2cf..a76a46e94a606 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1291,6 +1291,11 @@ static unsigned long iommu_dma_get_merge_boundary(struct device *dev)
 	return (1UL << __ffs(domain->pgsize_bitmap)) - 1;
 }
 
+static size_t iommu_dma_opt_mapping_size(void)
+{
+	return iova_rcache_range();
+}
+
 static const struct dma_map_ops iommu_dma_ops = {
 	.alloc			= iommu_dma_alloc,
 	.free			= iommu_dma_free,
@@ -1313,6 +1318,7 @@ static const struct dma_map_ops iommu_dma_ops = {
 	.map_resource		= iommu_dma_map_resource,
 	.unmap_resource		= iommu_dma_unmap_resource,
 	.get_merge_boundary	= iommu_dma_get_merge_boundary,
+	.opt_mapping_size	= iommu_dma_opt_mapping_size,
 };
 
 /*
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 0835f32e040ad..f6dfb9e45e953 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -27,6 +27,11 @@ static void free_iova_rcaches(struct iova_domain *iovad);
 static void fq_destroy_all_entries(struct iova_domain *iovad);
 static void fq_flush_timeout(struct timer_list *t);
 
+unsigned long iova_rcache_range(void)
+{
+	return PAGE_SIZE << (IOVA_RANGE_CACHE_MAX_SIZE - 1);
+}
+
 static int iova_cpuhp_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct iova_domain *iovad;
diff --git a/include/linux/iova.h b/include/linux/iova.h
index 6b6cc104e300d..9aa0acf9820af 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -137,6 +137,8 @@ static inline unsigned long iova_pfn(struct iova_domain *iovad, dma_addr_t iova)
 int iova_cache_get(void);
 void iova_cache_put(void);
 
+unsigned long iova_rcache_range(void);
+
 void free_iova(struct iova_domain *iovad, unsigned long pfn);
 void __free_iova(struct iova_domain *iovad, struct iova *iova);
 struct iova *alloc_iova(struct iova_domain *iovad, unsigned long size,
-- 
2.43.0



