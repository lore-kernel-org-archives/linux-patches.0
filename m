Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B90725F780;
	Mon, 22 Sep 2025 19:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569807; cv=none; b=ZBcCSkpRdqtMoKlZLgHM8u9Ozun173rsr16c+cg1kdbfZlwh6cYAvxdUjLldFz89oNLlkxwFrf9nNb3rk4sqxJXzJjUuQEbIUk5wobH1NNy7SED2DukuvSSDLCwxUFkT/8e1XDHo3AZ4yL+dpMEY9MhpT2FiUkOFgWyhbHdjYqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569807; c=relaxed/simple;
	bh=NW3YjLCaqvbY43GNjfgpWTe0oRX4oA5WuMAhw5k3knE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdwawFDYwkl4wZVVtYn8+jv+Z8pfByYw5h/ysjT2JmKUsKjw6g5zVmSnVcBXNKq8ILfFejrOhU7SqQT9WO87JzyJDe+TdQLIHZ930K/Ek6KglO4ZkC6iPT0YrEBizBI/l2GOc6uQ+4V6SAob9CRfmTfEOqC7/klNeakrzdzecfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meKyzRRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meKyzRRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8900C4CEF0;
	Mon, 22 Sep 2025 19:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569807;
	bh=NW3YjLCaqvbY43GNjfgpWTe0oRX4oA5WuMAhw5k3knE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meKyzRRbGE+/RchNC+MWiCSujz/6NqWiWNeFvFf1rR6zbedfgtij8l2UllRm7TRUu
	 ZAF9CTbcY7Ucv4va0pgVtyNMaZe+rjHMevluOXZXVIAAWcMJTwSECjXUWgw1Q23HHc
	 PY4Kc7aIO/lPioQ3g++1iEwBN+Oqixv+wA8TJPds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 64/70] iommu/amd/pgtbl: Fix possible race while increase page table level
Date: Mon, 22 Sep 2025 21:30:04 +0200
Message-ID: <20250922192406.321492658@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 1e56310b40fd2e7e0b9493da9ff488af145bdd0c ]

The AMD IOMMU host page table implementation supports dynamic page table levels
(up to 6 levels), starting with a 3-level configuration that expands based on
IOVA address. The kernel maintains a root pointer and current page table level
to enable proper page table walks in alloc_pte()/fetch_pte() operations.

The IOMMU IOVA allocator initially starts with 32-bit address and onces its
exhuasted it switches to 64-bit address (max address is determined based
on IOMMU and device DMA capability). To support larger IOVA, AMD IOMMU
driver increases page table level.

But in unmap path (iommu_v1_unmap_pages()), fetch_pte() reads
pgtable->[root/mode] without lock. So its possible that in exteme corner case,
when increase_address_space() is updating pgtable->[root/mode], fetch_pte()
reads wrong page table level (pgtable->mode). It does compare the value with
level encoded in page table and returns NULL. This will result is
iommu_unmap ops to fail and upper layer may retry/log WARN_ON.

CPU 0                                         CPU 1
------                                       ------
map pages                                    unmap pages
alloc_pte() -> increase_address_space()      iommu_v1_unmap_pages() -> fetch_pte()
  pgtable->root = pte (new root value)
                                             READ pgtable->[mode/root]
					       Reads new root, old mode
  Updates mode (pgtable->mode += 1)

Since Page table level updates are infrequent and already synchronized with a
spinlock, implement seqcount to enable lock-free read operations on the read path.

Fixes: 754265bcab7 ("iommu/amd: Fix race in increase_address_space()")
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: stable@vger.kernel.org
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[ Adapted pgtable->mode and pgtable->root to use domain->iop.mode and domain->iop.root ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/amd_iommu_types.h |    1 +
 drivers/iommu/amd/io_pgtable.c      |   26 ++++++++++++++++++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -540,6 +540,7 @@ struct amd_irte_ops;
 	container_of((x), struct amd_io_pgtable, pgtbl_cfg)
 
 struct amd_io_pgtable {
+	seqcount_t		seqcount;	/* Protects root/mode update */
 	struct io_pgtable_cfg	pgtbl_cfg;
 	struct io_pgtable	iop;
 	int			mode;
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
+#include <linux/seqlock.h>
 
 #include <asm/barrier.h>
 
@@ -171,8 +172,11 @@ static bool increase_address_space(struc
 
 	*pte = PM_LEVEL_PDE(domain->iop.mode, iommu_virt_to_phys(domain->iop.root));
 
+	write_seqcount_begin(&domain->iop.seqcount);
 	domain->iop.root  = pte;
 	domain->iop.mode += 1;
+	write_seqcount_end(&domain->iop.seqcount);
+
 	amd_iommu_update_and_flush_device_table(domain);
 	amd_iommu_domain_flush_complete(domain);
 
@@ -199,6 +203,7 @@ static u64 *alloc_pte(struct protection_
 		      gfp_t gfp,
 		      bool *updated)
 {
+	unsigned int seqcount;
 	int level, end_lvl;
 	u64 *pte, *page;
 
@@ -214,8 +219,14 @@ static u64 *alloc_pte(struct protection_
 	}
 
 
-	level   = domain->iop.mode - 1;
-	pte     = &domain->iop.root[PM_LEVEL_INDEX(level, address)];
+	do {
+		seqcount = read_seqcount_begin(&domain->iop.seqcount);
+
+		level   = domain->iop.mode - 1;
+		pte     = &domain->iop.root[PM_LEVEL_INDEX(level, address)];
+	} while (read_seqcount_retry(&domain->iop.seqcount, seqcount));
+
+
 	address = PAGE_SIZE_ALIGN(address, page_size);
 	end_lvl = PAGE_SIZE_LEVEL(page_size);
 
@@ -292,6 +303,7 @@ static u64 *fetch_pte(struct amd_io_pgta
 		      unsigned long *page_size)
 {
 	int level;
+	unsigned int seqcount;
 	u64 *pte;
 
 	*page_size = 0;
@@ -299,8 +311,12 @@ static u64 *fetch_pte(struct amd_io_pgta
 	if (address > PM_LEVEL_SIZE(pgtable->mode))
 		return NULL;
 
-	level	   =  pgtable->mode - 1;
-	pte	   = &pgtable->root[PM_LEVEL_INDEX(level, address)];
+	do {
+		seqcount = read_seqcount_begin(&pgtable->seqcount);
+		level	   =  pgtable->mode - 1;
+		pte	   = &pgtable->root[PM_LEVEL_INDEX(level, address)];
+	} while (read_seqcount_retry(&pgtable->seqcount, seqcount));
+
 	*page_size =  PTE_LEVEL_PAGE_SIZE(level);
 
 	while (level > 0) {
@@ -524,6 +540,8 @@ static struct io_pgtable *v1_alloc_pgtab
 	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE,
 	cfg->tlb            = &v1_flush_ops;
 
+	seqcount_init(&pgtable->seqcount);
+
 	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
 	pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
 	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;


