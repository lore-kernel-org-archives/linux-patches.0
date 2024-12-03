Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922B11DA3D;
	Tue,  3 Dec 2024 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238917; cv=none; b=rKNCHw8sEpSl0s7aaICZ2ltaO2HDs6nizDZTEYlTIBYkzZeLC7IZEUQyPGcaM6DIK3Caen/b67L+OcqAE8I+qCcSjOixBofLrVpNSHzKVjaTBdkAM28vWyBj7Ow0af8CzSyKsuJUzYbOvU+WRlxCAOV0mc9FzS0rxRdU/NAA4Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238917; c=relaxed/simple;
	bh=OOv1j0a3dr5bfsde8/WGYsimeim8h8Slm6VR2xQpo00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/oeYJH4mEK2yl5eBW9PRalTZQG1ebk/TysO6VNGvxm8F2qWgJ/Q6r5R6Q+EGuYsqNirXsf0UrKUw4+RagTy19VkK2HOfS8ShlbNdwzKifCcdF3wSPHesB9GUhOdYD8/mtWQUYfqIj56ko2HbMhPO66nGsRJpIsnDGWidisza9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkR0Hkvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkR0Hkvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1954CC4CECF;
	Tue,  3 Dec 2024 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238917;
	bh=OOv1j0a3dr5bfsde8/WGYsimeim8h8Slm6VR2xQpo00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkR0HkvlZWtWtdaiUaKJ22Ph/Wz/1V8dcG5RV9O1s9mfkL0jtheLoV5oxF4sWrlmf
	 E4YawQKzEC5Ru1CcGke4HFdTJEOHwlIzbcZwkYSeP2gQwf39azB6YaCLbFXLbjbBUn
	 MSolxvTeS/owf6aDMCp/dFQYXyR1Dl2GSYKh0kQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 410/817] iommu/amd: Store the nid in io_pgtable_cfg instead of the domain
Date: Tue,  3 Dec 2024 15:39:42 +0100
Message-ID: <20241203144011.884612805@linuxfoundation.org>
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

[ Upstream commit 47f218d108950984b24af81f66356ceda380eb74 ]

We already have memory in the union here that is being wasted in AMD's
case, use it to store the nid.

Putting the nid here further isolates the io_pgtable code from the struct
protection_domain.

Fixup protection_domain_alloc so that the NID from the device is provided,
at this point dev is never NULL for AMD so this will now allocate the
first table pointer on the correct NUMA node.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/8-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 016991606aa0 ("iommu/amd/pgtbl_v2: Take protection domain lock before invalidating TLB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h       |  2 +-
 drivers/iommu/amd/amd_iommu_types.h |  1 -
 drivers/iommu/amd/io_pgtable.c      |  8 +++++---
 drivers/iommu/amd/io_pgtable_v2.c   |  5 ++---
 drivers/iommu/amd/iommu.c           | 12 +++++++-----
 drivers/iommu/amd/pasid.c           |  2 +-
 include/linux/io-pgtable.h          |  4 ++++
 7 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 5a050080d2e81..5459f726fb29d 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -45,7 +45,7 @@ extern enum io_pgtable_fmt amd_iommu_pgtable;
 extern int amd_iommu_gpt_level;
 
 /* Protection domain ops */
-struct protection_domain *protection_domain_alloc(unsigned int type);
+struct protection_domain *protection_domain_alloc(unsigned int type, int nid);
 void protection_domain_free(struct protection_domain *domain);
 struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 						struct mm_struct *mm);
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 90a2e4790bffd..caa469abf0327 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -580,7 +580,6 @@ struct protection_domain {
 	struct amd_io_pgtable iop;
 	spinlock_t lock;	/* mostly used to lock the page table*/
 	u16 id;			/* the domain id written to the device table */
-	int nid;		/* Node ID */
 	enum protection_domain_mode pd_mode; /* Track page table type */
 	bool dirty_tracking;	/* dirty tracking is enabled in the domain */
 	unsigned dev_cnt;	/* devices assigned to this domain */
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index dab1cf53b1f3f..f71140416fcf6 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -141,11 +141,12 @@ static bool increase_address_space(struct protection_domain *domain,
 				   unsigned long address,
 				   gfp_t gfp)
 {
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	unsigned long flags;
 	bool ret = true;
 	u64 *pte;
 
-	pte = iommu_alloc_page_node(domain->nid, gfp);
+	pte = iommu_alloc_page_node(cfg->amd.nid, gfp);
 	if (!pte)
 		return false;
 
@@ -182,6 +183,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 		      gfp_t gfp,
 		      bool *updated)
 {
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	int level, end_lvl;
 	u64 *pte, *page;
 
@@ -233,7 +235,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
 		    pte_level == PAGE_MODE_NONE) {
-			page = iommu_alloc_page_node(domain->nid, gfp);
+			page = iommu_alloc_page_node(cfg->amd.nid, gfp);
 
 			if (!page)
 				return NULL;
@@ -560,7 +562,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
-	pgtable->root = iommu_alloc_page(GFP_KERNEL);
+	pgtable->root = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
 	if (!pgtable->root)
 		return NULL;
 	pgtable->mode = PAGE_MODE_3_LEVEL;
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index de60f6f4cb2f9..c881ec848f545 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -251,7 +251,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	while (mapped_size < size) {
 		map_size = get_alloc_page_size(pgsize);
-		pte = v2_alloc_pte(pdom->nid, pdom->iop.pgd,
+		pte = v2_alloc_pte(cfg->amd.nid, pdom->iop.pgd,
 				   iova, map_size, gfp, &updated);
 		if (!pte) {
 			ret = -EINVAL;
@@ -359,10 +359,9 @@ static void v2_free_pgtable(struct io_pgtable *iop)
 static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
-	struct protection_domain *pdom = (struct protection_domain *)cookie;
 	int ias = IOMMU_IN_ADDR_BIT_SIZE;
 
-	pgtable->pgd = iommu_alloc_page_node(pdom->nid, GFP_KERNEL);
+	pgtable->pgd = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
 	if (!pgtable->pgd)
 		return NULL;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b63f0d1bb3251..554179f7de29e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2030,6 +2030,7 @@ static int do_attach(struct iommu_dev_data *dev_data,
 		     struct protection_domain *domain)
 {
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	int ret = 0;
 
 	/* Update data structures */
@@ -2037,8 +2038,8 @@ static int do_attach(struct iommu_dev_data *dev_data,
 	list_add(&dev_data->list, &domain->dev_list);
 
 	/* Update NUMA Node ID */
-	if (domain->nid == NUMA_NO_NODE)
-		domain->nid = dev_to_node(dev_data->dev);
+	if (cfg->amd.nid == NUMA_NO_NODE)
+		cfg->amd.nid = dev_to_node(dev_data->dev);
 
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;
@@ -2273,7 +2274,7 @@ void protection_domain_free(struct protection_domain *domain)
 	kfree(domain);
 }
 
-struct protection_domain *protection_domain_alloc(unsigned int type)
+struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 	struct protection_domain *domain;
@@ -2290,7 +2291,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 	spin_lock_init(&domain->lock);
 	INIT_LIST_HEAD(&domain->dev_list);
 	INIT_LIST_HEAD(&domain->dev_data_list);
-	domain->nid = NUMA_NO_NODE;
+	domain->iop.pgtbl.cfg.amd.nid = nid;
 
 	switch (type) {
 	/* No need to allocate io pgtable ops in passthrough mode */
@@ -2366,7 +2367,8 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	if (dirty_tracking && !amd_iommu_hd_support(iommu))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	domain = protection_domain_alloc(type);
+	domain = protection_domain_alloc(type,
+					 dev ? dev_to_node(dev) : NUMA_NO_NODE);
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index a68215f2b3e1d..0657b9373be54 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -181,7 +181,7 @@ struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 	struct protection_domain *pdom;
 	int ret;
 
-	pdom = protection_domain_alloc(IOMMU_DOMAIN_SVA);
+	pdom = protection_domain_alloc(IOMMU_DOMAIN_SVA, dev_to_node(dev));
 	if (!pdom)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index f9a81761bfced..b1ecfc3cd5bcc 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -171,6 +171,10 @@ struct io_pgtable_cfg {
 			u64 ttbr[4];
 			u32 n_ttbrs;
 		} apple_dart_cfg;
+
+		struct {
+			int nid;
+		} amd;
 	};
 };
 
-- 
2.43.0



