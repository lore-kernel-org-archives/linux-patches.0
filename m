Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C141DA3D;
	Tue,  3 Dec 2024 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238920; cv=none; b=Hr3ejrVCEU3ThBCmfZYFKddL5vKIJB4VohzbvbLnAct4dANXJ8D+PVBPMF7RALgHIr4U5LlvLWoUD4NwCeoQuiHuAsUVBwFBTDcIrd7LbsiXmnlcebyRiQ/mo4ieHXenm2w00H9Iiag8j/FDDRXOGOHaNQOatx4/CRqphE4JyFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238920; c=relaxed/simple;
	bh=09yUiju5y5uHwmyvQvhzaIZoOZS78bEuvp7hB9ez+aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy1Vl8BgbnzktT057VuhixcRlSTzxVFXLyCI1ezcujKjwl2SvJXGGj/W+JVIfzFE7rqYPk2xt0/sT9VYS8CmMhrGpVQIZz0G8o8ixxE70zRTNeoZHnFbdpeMY4HjS2WPWeggJjua0U4Tl0p28Q4FlHyYSR4ynBMh40NZggyk3r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hE6fhaRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hE6fhaRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD69C4CECF;
	Tue,  3 Dec 2024 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238920;
	bh=09yUiju5y5uHwmyvQvhzaIZoOZS78bEuvp7hB9ez+aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hE6fhaRQYqteIK9DH+3RRWDAwr+V5ltlcxgIufrqdIMsHJMDsogIynkt01aC1J2Mk
	 Gq3fwXB0PE0otwVoBj5CpdtNymlV5T8dRM3y5YZakwy667j5IcQkV8XfChMDgPsGYK
	 1kQ/3xPHMwpH6+Fi2cFLQCGzQ/PBgiLmRBysGIys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 411/817] iommu/amd: Narrow the use of struct protection_domain to invalidation
Date: Tue,  3 Dec 2024 15:39:43 +0100
Message-ID: <20241203144011.923468015@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 9ac0b3380acdece01fa1b361687e3cd988831c55 ]

The AMD io_pgtable stuff doesn't implement the tlb ops callbacks, instead
it invokes the invalidation ops directly on the struct protection_domain.

Narrow the use of struct protection_domain to only those few code paths.
Make everything else properly use struct amd_io_pgtable through the call
chains, which is the correct modular type for an io-pgtable module.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/9-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 016991606aa0 ("iommu/amd/pgtbl_v2: Take protection domain lock before invalidating TLB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable.c    | 33 +++++++++++++++++--------------
 drivers/iommu/amd/io_pgtable_v2.c | 11 +++++++----
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index f71140416fcf6..667718db7ffde 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -137,11 +137,13 @@ static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
  * another level increases the size of the address space by 9 bits to a size up
  * to 64 bits.
  */
-static bool increase_address_space(struct protection_domain *domain,
+static bool increase_address_space(struct amd_io_pgtable *pgtable,
 				   unsigned long address,
 				   gfp_t gfp)
 {
-	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
+	struct protection_domain *domain =
+		container_of(pgtable, struct protection_domain, iop);
 	unsigned long flags;
 	bool ret = true;
 	u64 *pte;
@@ -152,17 +154,17 @@ static bool increase_address_space(struct protection_domain *domain,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (address <= PM_LEVEL_SIZE(domain->iop.mode))
+	if (address <= PM_LEVEL_SIZE(pgtable->mode))
 		goto out;
 
 	ret = false;
-	if (WARN_ON_ONCE(domain->iop.mode == PAGE_MODE_6_LEVEL))
+	if (WARN_ON_ONCE(pgtable->mode == PAGE_MODE_6_LEVEL))
 		goto out;
 
-	*pte = PM_LEVEL_PDE(domain->iop.mode, iommu_virt_to_phys(domain->iop.root));
+	*pte = PM_LEVEL_PDE(pgtable->mode, iommu_virt_to_phys(pgtable->root));
 
-	domain->iop.root  = pte;
-	domain->iop.mode += 1;
+	pgtable->root  = pte;
+	pgtable->mode += 1;
 	amd_iommu_update_and_flush_device_table(domain);
 	amd_iommu_domain_flush_complete(domain);
 
@@ -176,31 +178,31 @@ static bool increase_address_space(struct protection_domain *domain,
 	return ret;
 }
 
-static u64 *alloc_pte(struct protection_domain *domain,
+static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 		      unsigned long address,
 		      unsigned long page_size,
 		      u64 **pte_page,
 		      gfp_t gfp,
 		      bool *updated)
 {
-	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	int level, end_lvl;
 	u64 *pte, *page;
 
 	BUG_ON(!is_power_of_2(page_size));
 
-	while (address > PM_LEVEL_SIZE(domain->iop.mode)) {
+	while (address > PM_LEVEL_SIZE(pgtable->mode)) {
 		/*
 		 * Return an error if there is no memory to update the
 		 * page-table.
 		 */
-		if (!increase_address_space(domain, address, gfp))
+		if (!increase_address_space(pgtable, address, gfp))
 			return NULL;
 	}
 
 
-	level   = domain->iop.mode - 1;
-	pte     = &domain->iop.root[PM_LEVEL_INDEX(level, address)];
+	level   = pgtable->mode - 1;
+	pte     = &pgtable->root[PM_LEVEL_INDEX(level, address)];
 	address = PAGE_SIZE_ALIGN(address, page_size);
 	end_lvl = PAGE_SIZE_LEVEL(page_size);
 
@@ -349,7 +351,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
-	struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
+	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
 	LIST_HEAD(freelist);
 	bool updated = false;
 	u64 __pte, *pte;
@@ -366,7 +368,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	while (pgcount > 0) {
 		count = PAGE_SIZE_PTE_COUNT(pgsize);
-		pte   = alloc_pte(dom, iova, pgsize, NULL, gfp, &updated);
+		pte   = alloc_pte(pgtable, iova, pgsize, NULL, gfp, &updated);
 
 		ret = -ENOMEM;
 		if (!pte)
@@ -403,6 +405,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 out:
 	if (updated) {
+		struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
 		unsigned long flags;
 
 		spin_lock_irqsave(&dom->lock, flags);
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index c881ec848f545..afa5844495ca8 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -233,8 +233,8 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
-	struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
-	struct io_pgtable_cfg *cfg = &pdom->iop.pgtbl.cfg;
+	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	u64 *pte;
 	unsigned long map_size;
 	unsigned long mapped_size = 0;
@@ -251,7 +251,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	while (mapped_size < size) {
 		map_size = get_alloc_page_size(pgsize);
-		pte = v2_alloc_pte(cfg->amd.nid, pdom->iop.pgd,
+		pte = v2_alloc_pte(cfg->amd.nid, pgtable->pgd,
 				   iova, map_size, gfp, &updated);
 		if (!pte) {
 			ret = -EINVAL;
@@ -266,8 +266,11 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 	}
 
 out:
-	if (updated)
+	if (updated) {
+		struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
+
 		amd_iommu_domain_flush_pages(pdom, o_iova, size);
+	}
 
 	if (mapped)
 		*mapped += mapped_size;
-- 
2.43.0



