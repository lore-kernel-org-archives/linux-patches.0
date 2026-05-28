Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9AC335566;
	Thu, 28 May 2026 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998899; cv=none; b=ZmsJ2MWacCNplkFtUX6MFFll4l1UezBm/koXnkFKiiDblAIj+s2MQBQh6Tnql1bB/B8KrP5gGb4Lukzf0tgEfQDWIpzslC0bTxWSZX8betB5De+CzgvXDY7//S3ZGZ2bJlqKSn5Vqu3AJkX8poFsuyRUBFq0GmNf/uIykmnkFd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998899; c=relaxed/simple;
	bh=zORb2eRZ/wQ9Y1uI4scitJzz7htXNEqLvbztjqY0RG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTeu/pjQXar9Fc/pzC1F+fIlWGkl4h2nVgARqcx+OYIVU1ZslyLHo9J7anV+bT2CJhhAFevviDbP02hUBDRBppQIP2kj531UW1+2F5btU0XLMQNQ97eOw1B2PkqKmKikhEwXE7iNQNgayCerywwpOFcC6dcCgX18KBu5jge23JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wz3t9qBa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wz3t9qBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829DC1F00A3A;
	Thu, 28 May 2026 20:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998898;
	bh=qQoFmL1g90MRWFdq5mikM3Rr03tcPeHaAzrJVUDORmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wz3t9qBaEnzT1J+8PTFMW18JLrSzshVWzKz+lw5EuFGHI/KzBSOKRjOr6ONSdboa6
	 AiYT5S604Cq8sVwcPFPgbT1GDZREu2Ony1DBURBq1l/7QTB9o0qyfZS9pQO4rQd3wr
	 Ve1vjgLwuniz5O3HXGyv33UyUFKcIHWM3X3WGTnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Josua Mayer <josua@solid-run.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 337/461] iommu: Fix up map/unmap debugging for iommupt domains
Date: Thu, 28 May 2026 21:47:46 +0200
Message-ID: <20260528194657.113342915@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit b948a87228482235afbaf5f4d8037860b5c470fd ]

Sashiko noticed a few issues in this path, and a few more were
found on review. Tidy them up further. These are intertwined
because the debug code depends on some of the WARN_ONs to function
right:

Lift into iommu_map_nosync():
- The might_sleep_if()
- 0 pgsize_bitmap WARN_ON
- Promote the illegal domain->type to a WARN_ON
- WARN_ON for illegal gfp flags

Then remove the return 0 since it is now safe to call
iommu_debug_map().

Lift into __iommu_unmap():
- 0 pgsize_bitmap WARN_ON
- Promote the illegal domain->type to a WARN_ON
- iommu_debug_unmap_begin()

This now pairs with the unconditional iommu_debug_map() on the
mapping side. Thus iommu debugging now works for iommupt along
with some of the other debugging features.

Fixes: 99fb8afa16ad ("iommupt: Directly call iommupt's unmap_range()")
Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 0735c54804c7 ("iommu: Handle unmap error when iommu_debug is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 84ae594824a55..0c2a4beb6ac32 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2623,19 +2623,9 @@ static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
 	size_t orig_size = size;
 	int ret = 0;
 
-	might_sleep_if(gfpflags_allow_blocking(gfp));
-
-	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
-		return -EINVAL;
-
-	if (WARN_ON(!ops->map_pages || domain->pgsize_bitmap == 0UL))
+	if (WARN_ON(!ops->map_pages))
 		return -ENODEV;
 
-	/* Discourage passing strange GFP flags */
-	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
-				__GFP_HIGHMEM)))
-		return -EINVAL;
-
 	/* find out the minimum page size supported */
 	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
 
@@ -2697,6 +2687,15 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 	struct pt_iommu *pt = iommupt_from_domain(domain);
 	int ret;
 
+	might_sleep_if(gfpflags_allow_blocking(gfp));
+
+	/* Discourage passing strange GFP flags or illegal domains */
+	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING) ||
+			 !domain->pgsize_bitmap ||
+			 (gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				 __GFP_HIGHMEM))))
+		return -EINVAL;
+
 	if (pt) {
 		size_t mapped = 0;
 
@@ -2706,11 +2705,12 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 			iommu_unmap(domain, iova, mapped);
 			return ret;
 		}
-		return 0;
+	} else {
+		ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot,
+					       gfp);
+		if (ret)
+			return ret;
 	}
-	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
-	if (ret)
-		return ret;
 
 	trace_map(iova, paddr, size);
 	iommu_debug_map(domain, paddr, size);
@@ -2742,10 +2742,7 @@ __iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
 	size_t unmapped_page, unmapped = 0;
 	unsigned int min_pagesz;
 
-	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
-		return 0;
-
-	if (WARN_ON(!ops->unmap_pages || domain->pgsize_bitmap == 0UL))
+	if (WARN_ON(!ops->unmap_pages))
 		return 0;
 
 	/* find out the minimum page size supported */
@@ -2764,8 +2761,6 @@ __iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
 
 	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
 
-	iommu_debug_unmap_begin(domain, iova, size);
-
 	/*
 	 * Keep iterating until we either unmap 'size' bytes (or more)
 	 * or we hit an area that isn't mapped.
@@ -2801,6 +2796,12 @@ static size_t __iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 	struct pt_iommu *pt = iommupt_from_domain(domain);
 	size_t unmapped;
 
+	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING) ||
+			 !domain->pgsize_bitmap))
+		return 0;
+
+	iommu_debug_unmap_begin(domain, iova, size);
+
 	if (pt)
 		unmapped = pt->ops->unmap_range(pt, iova, size, iotlb_gather);
 	else
-- 
2.53.0



