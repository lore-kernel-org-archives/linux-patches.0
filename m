Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6751FDA6D;
	Wed,  5 Feb 2025 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766931; cv=none; b=JtUmON8gtSarQn8lOR484mBBSSCgWHh3jdmDtohUd3NCl8KGQRndJHBxI/0f92Hg+yzfyq26ktNjG+9QRTi7uhHGegsOIq8vHD7c8nk3y2F1d2mueY0I8nQkz5e8LKahHsweRR/DxGCgrtIm9slLQenOVTF0f7bI3kDy+NnhPfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766931; c=relaxed/simple;
	bh=7kkogKxavZ3r/iSn2MUsLvNEAtWavRkTEh147fcghR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+skiFC8f63OQYKd0GvzcbbltmWyHro1yj5NnGh0/9EjYNjv9MxUNehRyhgmSWLH8LbGCR9M/J9QF9BQU5rHff7G60NFglEX1h3bni3hYcBcydBwRSQoAOWF4XgrBsesnwWTlYKNch33lGkxvZQlHYWOLLkeM6h/7LliZwoillU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/aewgfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/aewgfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED38CC4CED1;
	Wed,  5 Feb 2025 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766931;
	bh=7kkogKxavZ3r/iSn2MUsLvNEAtWavRkTEh147fcghR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/aewgfQewzj68fMsnZPqDecglOcONKS6DEdz6ign/Ha4IRhOHHOyQid3F+MIEsU5
	 //h8BL9LbRBpmrK8TZL4G8ublP1CJxhFRUEtPtzxkpZHDOuuODGDnagDBmzEgjVSrs
	 N5zCdUmsvWx+WrWySPkqNDAKRuCEaKbeGL0Dgh+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 317/623] iommu/amd: Remove type argument from do_iommu_domain_alloc() and related
Date: Wed,  5 Feb 2025 14:40:59 +0100
Message-ID: <20250205134508.348844795@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 55b237dd7f7ec2ee9c7986e0fc28c5867bf63282 ]

do_iommu_domain_alloc() is only called from
amd_iommu_domain_alloc_paging_flags() so type is always
IOMMU_DOMAIN_UNMANAGED. Remove type and all the dead conditionals checking
it.

IOMMU_DOMAIN_IDENTITY checks are similarly obsolete as the conversion to
the global static identity domain removed those call paths.

The caller of protection_domain_alloc() should set the type, fix the miss
in the SVA code.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/4-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 082f1bcae8d1 ("iommu/amd: Fully decode all combinations of alloc_paging_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 35 ++++++++++-------------------------
 drivers/iommu/amd/pasid.c     |  3 ++-
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index c38e02510cf73..1d384b2c6e28e 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -47,7 +47,7 @@ extern unsigned long amd_iommu_pgsize_bitmap;
 
 /* Protection domain ops */
 void amd_iommu_init_identity_domain(void);
-struct protection_domain *protection_domain_alloc(unsigned int type, int nid);
+struct protection_domain *protection_domain_alloc(int nid);
 void protection_domain_free(struct protection_domain *domain);
 struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 						struct mm_struct *mm);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 12c416abdce7d..081a5dbe7ba7b 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2276,7 +2276,7 @@ static void protection_domain_init(struct protection_domain *domain, int nid)
 	domain->iop.pgtbl.cfg.amd.nid = nid;
 }
 
-struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
+struct protection_domain *protection_domain_alloc(int nid)
 {
 	struct protection_domain *domain;
 	int domid;
@@ -2297,15 +2297,10 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 	return domain;
 }
 
-static int pdom_setup_pgtable(struct protection_domain *domain,
-			      unsigned int type, int pgtable)
+static int pdom_setup_pgtable(struct protection_domain *domain, int pgtable)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 
-	/* No need to allocate io pgtable ops in passthrough mode */
-	if (!(type & __IOMMU_DOMAIN_PAGING))
-		return 0;
-
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
 		domain->pd_mode = PD_MODE_V1;
@@ -2339,27 +2334,19 @@ static bool amd_iommu_hd_support(struct amd_iommu *iommu)
 	return iommu && (iommu->features & FEATURE_HDSUP);
 }
 
-static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
-						  struct device *dev,
-						  u32 flags, int pgtable)
+static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
+						  int pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	struct protection_domain *domain;
 	int ret;
 
-	/*
-	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
-	 * default to use IOMMU_DOMAIN_DMA[_FQ].
-	 */
-	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
-		return ERR_PTR(-EINVAL);
-
-	domain = protection_domain_alloc(type, dev_to_node(dev));
+	domain = protection_domain_alloc(dev_to_node(dev));
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	ret = pdom_setup_pgtable(domain, type, pgtable);
+	ret = pdom_setup_pgtable(domain, pgtable);
 	if (ret) {
 		pdom_id_free(domain->id);
 		kfree(domain);
@@ -2371,7 +2358,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.force_aperture = true;
 	domain->domain.pgsize_bitmap = domain->iop.pgtbl.cfg.pgsize_bitmap;
 
-	domain->domain.type = type;
+	domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	domain->domain.ops = iommu->iommu.ops->default_domain_ops;
 
 	if (dirty_tracking)
@@ -2385,7 +2372,6 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 				    const struct iommu_user_data *user_data)
 
 {
-	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 						IOMMU_HWPT_ALLOC_PASID;
@@ -2398,20 +2384,19 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		if (!amd_iommu_pasid_supported())
 			return ERR_PTR(-EOPNOTSUPP);
 
-		return do_iommu_domain_alloc(type, dev, flags, AMD_IOMMU_V2);
+		return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V2);
 	}
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
 		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(type, dev, flags,
-						     AMD_IOMMU_V1);
+			return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
 	/* If nothing specific is required use the kernel commandline default */
-	return do_iommu_domain_alloc(type, dev, 0, amd_iommu_pgtable);
+	return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
 }
 
 void amd_iommu_domain_free(struct iommu_domain *dom)
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 8c73a30c2800e..9101d07b11d3f 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -185,12 +185,13 @@ struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 	struct protection_domain *pdom;
 	int ret;
 
-	pdom = protection_domain_alloc(IOMMU_DOMAIN_SVA, dev_to_node(dev));
+	pdom = protection_domain_alloc(dev_to_node(dev));
 	if (!pdom)
 		return ERR_PTR(-ENOMEM);
 
 	pdom->domain.ops = &amd_sva_domain_ops;
 	pdom->mn.ops = &sva_mn;
+	pdom->domain.type = IOMMU_DOMAIN_SVA;
 
 	ret = mmu_notifier_register(&pdom->mn, mm);
 	if (ret) {
-- 
2.39.5



