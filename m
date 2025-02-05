Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8783F1FCD0C;
	Wed,  5 Feb 2025 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766855; cv=none; b=LDog7vg5aY+LyaH4tOYkO9ff74f7pp8aRuAkW20RSgkbSPqpiTgEKtZ8iAUcpjkuDlHm0TfJgtCfNYBRmOr84zrzwHH4M8Tj4KwSNIPiPDCcqQCwK2SIsTIbN9WyG+IX7kndTAz04U8927KpdoknG/Pna816J7jBtn9O5fd6ihU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766855; c=relaxed/simple;
	bh=ArSJnTiD+Wmu+VabDeNKYxUsmJz901KGwBaOOHhOdLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEMq/Q/FWPAIihScWVo2yJ8zZlWwzJq1ryRyU32RAsPvLRGyz+r3G7Ie2Rlj0DdFem7iw69Jp96dxzvYt+xr5+BARGsCb1PhK+t5hsxOgRhO83iVE6jUrg7dQk/D0Ea/H4PtRCNBYU97gj7CsyxYsPNNPTld5CNPWk0EaNHkX3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6r5dqO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6r5dqO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2FBC4CED1;
	Wed,  5 Feb 2025 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766855;
	bh=ArSJnTiD+Wmu+VabDeNKYxUsmJz901KGwBaOOHhOdLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6r5dqO6wlbMtLvhChZiMMFsvVwAZ0+3B2aWbyce9hsV2mae6FsT/N+LDM6s/hHv9
	 Xv4qmN1ZzPCCw1fZANFazWz1vbkq5sSXPd9RypPk6jq5+KCyf5bEinJj8egqkeBzh0
	 1YBnhrhmFJJQiCnz8YF+NrLxv58GJKrJaWW7ZYU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 316/623] iommu/amd: Remove dev == NULL checks
Date: Wed,  5 Feb 2025 14:40:58 +0100
Message-ID: <20250205134508.311492696@linuxfoundation.org>
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

[ Upstream commit 02bcd1a8b991c6fc29271fa02250bea1b61fb742 ]

This is no longer possible, amd_iommu_domain_alloc_paging_flags() is never
called with dev = NULL from the core code. Similarly
get_amd_iommu_from_dev() can never be NULL either.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/3-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 082f1bcae8d1 ("iommu/amd: Fully decode all combinations of alloc_paging_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 96d87406f8946..12c416abdce7d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2344,13 +2344,10 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 						  u32 flags, int pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	struct protection_domain *domain;
-	struct amd_iommu *iommu = NULL;
 	int ret;
 
-	if (dev)
-		iommu = get_amd_iommu_from_dev(dev);
-
 	/*
 	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
 	 * default to use IOMMU_DOMAIN_DMA[_FQ].
@@ -2358,8 +2355,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
 		return ERR_PTR(-EINVAL);
 
-	domain = protection_domain_alloc(type,
-					 dev ? dev_to_node(dev) : NUMA_NO_NODE);
+	domain = protection_domain_alloc(type, dev_to_node(dev));
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
@@ -2375,13 +2371,11 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.force_aperture = true;
 	domain->domain.pgsize_bitmap = domain->iop.pgtbl.cfg.pgsize_bitmap;
 
-	if (iommu) {
-		domain->domain.type = type;
-		domain->domain.ops = iommu->iommu.ops->default_domain_ops;
+	domain->domain.type = type;
+	domain->domain.ops = iommu->iommu.ops->default_domain_ops;
 
-		if (dirty_tracking)
-			domain->domain.dirty_ops = &amd_dirty_ops;
-	}
+	if (dirty_tracking)
+		domain->domain.dirty_ops = &amd_dirty_ops;
 
 	return &domain->domain;
 }
@@ -2392,13 +2386,10 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 
 {
 	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
-	struct amd_iommu *iommu = NULL;
+	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 						IOMMU_HWPT_ALLOC_PASID;
 
-	if (dev)
-		iommu = get_amd_iommu_from_dev(dev);
-
 	if ((flags & ~supported_flags) || user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -2412,10 +2403,9 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
-		if (iommu && amd_iommu_hd_support(iommu)) {
-			return do_iommu_domain_alloc(type, dev,
-						     flags, AMD_IOMMU_V1);
-		}
+		if (amd_iommu_hd_support(iommu))
+			return do_iommu_domain_alloc(type, dev, flags,
+						     AMD_IOMMU_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
-- 
2.39.5



