Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC522D7DF2;
	Wed, 17 Sep 2025 12:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112723; cv=none; b=bTf6Yl1clG5/6mPsAeEYkIeNo0oG7tYkV0ulOKUepwPOgTG/17mEKSDmdFcRWapKyatKtu/ght7a6veCBePxq9wF2u7F4P4YY0JIBSar8ygtIR3BCgK6Ul3O6WKUqxP5E2H9Gx0CJw42A8W1/RyIXV2XQlpFisWP6RgSAb4qdKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112723; c=relaxed/simple;
	bh=5xnB5NizULBOa0RBEo1pKwJgHOeKJHs/k2nYhYhcwKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucJvjS4MVKUPhYZRT/YVl095zCysMQedKY3CFB5zG9g9IVd6Kyb7VQhZeNFNbKsfTaW3z0o556aPmXWdLt31g9y52IeqlMydx80ZRmQD+r67z6UIOzcL2jY2DGH5GI7LmVqwbAk/uCiKrjATf9w4Rq6xtxQarnoNDcbegRR6BcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff4oK3U4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff4oK3U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7F7C4AF0B;
	Wed, 17 Sep 2025 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112723;
	bh=5xnB5NizULBOa0RBEo1pKwJgHOeKJHs/k2nYhYhcwKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ff4oK3U4IpMkjeIY5vL8hngpOiF/xaX1UiWccBglrkeCBMocI6ORxZfZ9p3FOw6o2
	 Upm6HZ4cCsWn8G8fC5m620cv49/UTbgmDvfcs2KAAS25QYtQ0UAuPL7hLbzqXEx42U
	 622d+bjhRk2rEb03sHZDHeh1xyW7FYxf/nxaRDm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 012/189] iommu/vt-d: Split paging_domain_compatible()
Date: Wed, 17 Sep 2025 14:32:02 +0200
Message-ID: <20250917123352.149597615@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 85cfaacc99377a63e47412eeef66eff77197acea ]

Make First/Second stage specific functions that follow the same pattern in
intel_iommu_domain_alloc_first/second_stage() for computing
EOPNOTSUPP. This makes the code easier to understand as if we couldn't
create a domain with the parameters for this IOMMU instance then we
certainly are not compatible with it.

Check superpage support directly against the per-stage cap bits and the
pgsize_bitmap.

Add a note that the force_snooping is read without locking. The locking
needs to cover the compatible check and the add of the device to the list.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/7-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20250714045028.958850-10-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: cee686775f9c ("iommu/vt-d: Make iotlb_sync_map a static property of dmar_domain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 66 ++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 207f87eeb47a2..a718f0bc14cdf 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3434,33 +3434,75 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 	domain_exit(dmar_domain);
 }
 
+static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
+						struct intel_iommu *iommu)
+{
+	if (WARN_ON(dmar_domain->domain.dirty_ops ||
+		    dmar_domain->nested_parent))
+		return -EINVAL;
+
+	/* Only SL is available in legacy mode */
+	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
+		return -EINVAL;
+
+	/* Same page size support */
+	if (!cap_fl1gp_support(iommu->cap) &&
+	    (dmar_domain->domain.pgsize_bitmap & SZ_1G))
+		return -EINVAL;
+	return 0;
+}
+
+static int
+paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
+				      struct intel_iommu *iommu)
+{
+	unsigned int sslps = cap_super_page_val(iommu->cap);
+
+	if (dmar_domain->domain.dirty_ops && !ssads_supported(iommu))
+		return -EINVAL;
+	if (dmar_domain->nested_parent && !nested_supported(iommu))
+		return -EINVAL;
+
+	/* Legacy mode always supports second stage */
+	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
+		return -EINVAL;
+
+	/* Same page size support */
+	if (!(sslps & BIT(0)) && (dmar_domain->domain.pgsize_bitmap & SZ_2M))
+		return -EINVAL;
+	if (!(sslps & BIT(1)) && (dmar_domain->domain.pgsize_bitmap & SZ_1G))
+		return -EINVAL;
+	return 0;
+}
+
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu = info->iommu;
+	int ret = -EINVAL;
 	int addr_width;
 
-	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING)))
-		return -EPERM;
+	if (intel_domain_is_fs_paging(dmar_domain))
+		ret = paging_domain_compatible_first_stage(dmar_domain, iommu);
+	else if (intel_domain_is_ss_paging(dmar_domain))
+		ret = paging_domain_compatible_second_stage(dmar_domain, iommu);
+	else if (WARN_ON(true))
+		ret = -EINVAL;
+	if (ret)
+		return ret;
 
+	/*
+	 * FIXME this is locked wrong, it needs to be under the
+	 * dmar_domain->lock
+	 */
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
 		return -EINVAL;
 
-	if (domain->dirty_ops && !ssads_supported(iommu))
-		return -EINVAL;
-
 	if (dmar_domain->iommu_coherency !=
 			iommu_paging_structure_coherency(iommu))
 		return -EINVAL;
 
-	if (dmar_domain->iommu_superpage !=
-			iommu_superpage_capability(iommu, dmar_domain->use_first_level))
-		return -EINVAL;
-
-	if (dmar_domain->use_first_level &&
-	    (!sm_supported(iommu) || !ecap_flts(iommu->ecap)))
-		return -EINVAL;
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
-- 
2.51.0



