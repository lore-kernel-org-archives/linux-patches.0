Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3621D04BE;
	Wed,  2 Oct 2024 14:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877791; cv=none; b=uKPes3RMgQxHe0HaHc1tv7BQtx8klRSZcAsJlE7/7IzmLUMSn+BrvOJKOrIQyxAtsvdGY/rLJqu57GtREbOlP11NIEUORHjXZv2MNMBaPz8eBQQ1FjksIH4qdjGIVvPzyqf8aKVIMwAdIj2sbRi1l7XbemHztBJ2UNUsTXNfNX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877791; c=relaxed/simple;
	bh=9hc6e392OpQsjou00FXVbMHHJu8IwUx0F3t3j6Lu2WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S08V1ySmkCh8iQP7ViNNkSH5gIRFe/+RuOAnNX3MvzssEBztS6evMkH1ly57mWTtf9VZQZTzoCEy1WgyvNVKyCozB6LK/ITwz6iemEBhB79IO8F3t9Dd8Skx9hedh4gYUbtCptbM+sd5AiR8r8Ly/7BjhhdYcT6qMSph/vJIryM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHZwfWGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHZwfWGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8A5C4CEC2;
	Wed,  2 Oct 2024 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877790;
	bh=9hc6e392OpQsjou00FXVbMHHJu8IwUx0F3t3j6Lu2WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHZwfWGUoCfp7OivUPXfmCtzH8Sazq/m5/vrdsAujI9mB7+TlpP12zddsUBc68gOs
	 w11WpWn4BGL5MuOkuGYFnL/3QcnfgolaxsRbOG92mo7EPe1vG1h6T6SP/5SUyFXsuK
	 OTq5y2mzF7Rfrp295rh9E/Uzk2WAW5/aUQ6/oh3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 168/634] iommu/amd: Set the pgsize_bitmap correctly
Date: Wed,  2 Oct 2024 14:54:28 +0200
Message-ID: <20241002125817.740293935@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 7a41dcb52f9de6079621fc31c3b84c7fc290934b ]

When using io_pgtable the correct pgsize_bitmap is stored in the cfg, both
v1_alloc_pgtable() and v2_alloc_pgtable() set it correctly.

This fixes a bug where the v2 pgtable had the wrong pgsize as
protection_domain_init_v2() would set it and then do_iommu_domain_alloc()
immediately resets it.

Remove the confusing ops.pgsize_bitmap since that is not used if the
driver sets domain.pgsize_bitmap.

Fixes: 134288158a41 ("iommu/amd: Add domain_alloc_user based domain allocation")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/3-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index edbd4ca1451a8..833637ffae39f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2271,26 +2271,11 @@ void protection_domain_free(struct protection_domain *domain)
 	kfree(domain);
 }
 
-static int protection_domain_init_v1(struct protection_domain *domain)
-{
-	domain->pd_mode = PD_MODE_V1;
-	return 0;
-}
-
-static int protection_domain_init_v2(struct protection_domain *pdom)
-{
-	pdom->pd_mode = PD_MODE_V2;
-	pdom->domain.pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
-
-	return 0;
-}
-
 struct protection_domain *protection_domain_alloc(unsigned int type)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 	struct protection_domain *domain;
 	int pgtable;
-	int ret;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
@@ -2326,18 +2311,14 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
-		ret = protection_domain_init_v1(domain);
+		domain->pd_mode = PD_MODE_V1;
 		break;
 	case AMD_IOMMU_V2:
-		ret = protection_domain_init_v2(domain);
+		domain->pd_mode = PD_MODE_V2;
 		break;
 	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	if (ret)
 		goto out_err;
+	}
 
 	pgtbl_ops = alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl_cfg, domain);
 	if (!pgtbl_ops)
@@ -2390,10 +2371,10 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.aperture_start = 0;
 	domain->domain.geometry.aperture_end   = dma_max_address();
 	domain->domain.geometry.force_aperture = true;
+	domain->domain.pgsize_bitmap = domain->iop.iop.cfg.pgsize_bitmap;
 
 	if (iommu) {
 		domain->domain.type = type;
-		domain->domain.pgsize_bitmap = iommu->iommu.ops->pgsize_bitmap;
 		domain->domain.ops = iommu->iommu.ops->default_domain_ops;
 
 		if (dirty_tracking)
@@ -2852,7 +2833,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.device_group = amd_iommu_device_group,
 	.get_resv_regions = amd_iommu_get_resv_regions,
 	.is_attach_deferred = amd_iommu_is_attach_deferred,
-	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
 	.def_domain_type = amd_iommu_def_domain_type,
 	.dev_enable_feat = amd_iommu_dev_enable_feature,
 	.dev_disable_feat = amd_iommu_dev_disable_feature,
-- 
2.43.0



