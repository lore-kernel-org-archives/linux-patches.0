Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D2831A7EC;
	Wed, 17 Sep 2025 12:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112726; cv=none; b=YOyBdv9qiPcTT/9dfcC3aPHhEbYxcnqXJv7WnczAwsdr8CiOLrSBeZwCyc8V5ZJJWcKEbsPfSNSiHMe3xm7xzLSf9gR/1ukpxYA2lfRIoK8pErH1C1qyVs5EjYjniu2JV0rA0oQ7EsCiHEaILUmcJAswGRIUQQ/7heiO19TkdFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112726; c=relaxed/simple;
	bh=4EMDuxPhLLTldk9yAnRmzkaDGx+AhyAkWEZf1rHbTV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEvlRIYhpkgBLJ0HpGywuUnFociPR6ndJ44x26LgkKXgX7kpKVfvhC4ZrNDqvvq3J9Jv39kxXuU80HAazvPAkIcKE/dgF6KArWCKKa4X3snocS7rzI+YaaOQ4qXuNnJDVY8xeL88Vz7lnJ6YRvZttByCBHOUcgL74E4uX4r6Kks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+DhnXN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+DhnXN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6128C4CEF0;
	Wed, 17 Sep 2025 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112726;
	bh=4EMDuxPhLLTldk9yAnRmzkaDGx+AhyAkWEZf1rHbTV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+DhnXN9/icLQ8FQfEEYThZ9/5LZZS+1vNpgRRX1P6fCRwZocHxTxFNXa2OeQknlJ
	 mrgBBMY23qVXkU7SsifGl5pv9yUR1yuCVVU5QG8MZ3S5Hxca834TPXBudMjXJ3ONRF
	 4xb7G5eB/k8zJ0ReKJP/fgIEGOe3DJltJd43k0QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 013/189] iommu/vt-d: Make iotlb_sync_map a static property of dmar_domain
Date: Wed, 17 Sep 2025 14:32:03 +0200
Message-ID: <20250917123352.174528667@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit cee686775f9cd4eae31f3c1f7ec24b2048082667 ]

Commit 12724ce3fe1a ("iommu/vt-d: Optimize iotlb_sync_map for
non-caching/non-RWBF modes") dynamically set iotlb_sync_map. This causes
synchronization issues due to lack of locking on map and attach paths,
racing iommufd userspace operations.

Invalidation changes must precede device attachment to ensure all flushes
complete before hardware walks page tables, preventing coherence issues.

Make domain->iotlb_sync_map static, set once during domain allocation. If
an IOMMU requires iotlb_sync_map but the domain lacks it, attach is
rejected. This won't reduce domain sharing: RWBF and shadowing page table
caching are legacy uses with legacy hardware. Mixed configs (some IOMMUs
in caching mode, others not) are unlikely in real-world scenarios.

Fixes: 12724ce3fe1a ("iommu/vt-d: Optimize iotlb_sync_map for non-caching/non-RWBF modes")
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20250721051657.1695788-1-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 43 +++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index a718f0bc14cdf..34dd175a331dc 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -57,6 +57,8 @@
 static void __init check_tylersburg_isoch(void);
 static int rwbf_quirk;
 
+#define rwbf_required(iommu)	(rwbf_quirk || cap_rwbf((iommu)->cap))
+
 /*
  * set to 1 to panic kernel if can't successfully enable VT-d
  * (used when kernel is launched w/ TXT)
@@ -1798,18 +1800,6 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 					  (pgd_t *)pgd, flags, old);
 }
 
-static bool domain_need_iotlb_sync_map(struct dmar_domain *domain,
-				       struct intel_iommu *iommu)
-{
-	if (cap_caching_mode(iommu->cap) && intel_domain_is_ss_paging(domain))
-		return true;
-
-	if (rwbf_quirk || cap_rwbf(iommu->cap))
-		return true;
-
-	return false;
-}
-
 static int dmar_domain_attach_device(struct dmar_domain *domain,
 				     struct device *dev)
 {
@@ -1849,8 +1839,6 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 	if (ret)
 		goto out_block_translation;
 
-	domain->iotlb_sync_map |= domain_need_iotlb_sync_map(domain, iommu);
-
 	return 0;
 
 out_block_translation:
@@ -3370,6 +3358,14 @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
 		return ERR_CAST(dmar_domain);
 
 	dmar_domain->domain.ops = &intel_fs_paging_domain_ops;
+	/*
+	 * iotlb sync for map is only needed for legacy implementations that
+	 * explicitly require flushing internal write buffers to ensure memory
+	 * coherence.
+	 */
+	if (rwbf_required(iommu))
+		dmar_domain->iotlb_sync_map = true;
+
 	return &dmar_domain->domain;
 }
 
@@ -3404,6 +3400,14 @@ intel_iommu_domain_alloc_second_stage(struct device *dev,
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING)
 		dmar_domain->domain.dirty_ops = &intel_dirty_ops;
 
+	/*
+	 * Besides the internal write buffer flush, the caching mode used for
+	 * legacy nested translation (which utilizes shadowing page tables)
+	 * also requires iotlb sync on map.
+	 */
+	if (rwbf_required(iommu) || cap_caching_mode(iommu->cap))
+		dmar_domain->iotlb_sync_map = true;
+
 	return &dmar_domain->domain;
 }
 
@@ -3449,6 +3453,11 @@ static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
 	if (!cap_fl1gp_support(iommu->cap) &&
 	    (dmar_domain->domain.pgsize_bitmap & SZ_1G))
 		return -EINVAL;
+
+	/* iotlb sync on map requirement */
+	if ((rwbf_required(iommu)) && !dmar_domain->iotlb_sync_map)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3472,6 +3481,12 @@ paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
 		return -EINVAL;
 	if (!(sslps & BIT(1)) && (dmar_domain->domain.pgsize_bitmap & SZ_1G))
 		return -EINVAL;
+
+	/* iotlb sync on map requirement */
+	if ((rwbf_required(iommu) || cap_caching_mode(iommu->cap)) &&
+	    !dmar_domain->iotlb_sync_map)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.51.0



