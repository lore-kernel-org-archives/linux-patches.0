Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0862F260C;
	Thu, 28 May 2026 20:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998902; cv=none; b=AV3iBkCiXmLWdWxHn8T27yyPNvxU477Auzys48tDeo9ijCer2svouX7WKc6RC22xcLW6Y616hDxnHtunBBbo9z1BEARxHyBA+uPDLZb3fORYn55Tqx2Luz/dtmXJEoBEjlIH4ayZQ5LaK6VRRZw/CoY86BTQQojjRcqe6RIHq3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998902; c=relaxed/simple;
	bh=6bvXFfldKtFwhHTLIAi1zNZJRrJvKrraF2nxNQH1TGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKfKNWHM4dXmE6NU3zfpBHuaGMtqBswePcgoF/MiheG9VycwpYClfwiIRzsSLxSrMQp4WjSbA6qv7r7mfdIxNAHv4IXLitlb3JcdKPCwj/CHzSpBnIMkGzaqnoQ8OLSHZc3yKa4hvZNtWEYBLq/cJgEdBFphKNF4eahTP99GM+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1b5dlvvh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1b5dlvvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F2E1F000E9;
	Thu, 28 May 2026 20:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998900;
	bh=sZtbClwEIUt414oryh26e5ZKWs/fXJzCcIhpix0MIqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1b5dlvvhIAjOled5VphJh62eoZv0n5hC3XV3Ih0KAp4gdB/9zwYdtjUxjEeTMHeob
	 fOamGCirUecbfwGJkuyvTEgYN87ygy4SuwF9AeVPlRY5C55zjnUvHGwE0oNbuVQHuM
	 Vp45y1QqTc2ALzcKEUxIo+696L3/hZW0Zjg6Kprw=
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
Subject: [PATCH 7.0 338/461] iommu: Handle unmap error when iommu_debug is enabled
Date: Thu, 28 May 2026 21:47:47 +0200
Message-ID: <20260528194657.142497112@linuxfoundation.org>
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

[ Upstream commit 0735c54804c709d1b292f3b6947cfb560b2ce552 ]

Sashiko noticed a latent bug where the map error flow called iommu_unmap()
which calls iommu_debug_unmap_begin()/iommu_debug_unmap_end() however
since this is an error path the map flow never actually established the
original iommu_debug_map() it will malfunction.

Lift the unmap error handling into iommu_map_nosync() and reorder it so
the trace_map()/iommu_debug_map() records the partial mapping and then
immediately unmaps it. This avoid creating the unbalanced tracking and
provides saner tracing instead of a unmap unmatched to any map.

Fixes: ccc21213f013 ("iommu: Add calls for IOMMU_DEBUG_PAGEALLOC")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 49 +++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0c2a4beb6ac32..93c9081707401 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2615,12 +2615,11 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 
 static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
 				    unsigned long iova, phys_addr_t paddr,
-				    size_t size, int prot, gfp_t gfp)
+				    size_t size, int prot, gfp_t gfp,
+				    size_t *mapped)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
-	unsigned long orig_iova = iova;
 	unsigned int min_pagesz;
-	size_t orig_size = size;
 	int ret = 0;
 
 	if (WARN_ON(!ops->map_pages))
@@ -2643,31 +2642,25 @@ static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
 	pr_debug("map: iova 0x%lx pa %pa size 0x%zx\n", iova, &paddr, size);
 
 	while (size) {
-		size_t pgsize, count, mapped = 0;
+		size_t pgsize, count, op_mapped = 0;
 
 		pgsize = iommu_pgsize(domain, iova, paddr, size, &count);
 
 		pr_debug("mapping: iova 0x%lx pa %pa pgsize 0x%zx count %zu\n",
 			 iova, &paddr, pgsize, count);
 		ret = ops->map_pages(domain, iova, paddr, pgsize, count, prot,
-				     gfp, &mapped);
+				     gfp, &op_mapped);
 		/*
 		 * Some pages may have been mapped, even if an error occurred,
 		 * so we should account for those so they can be unmapped.
 		 */
-		size -= mapped;
-
+		*mapped += op_mapped;
 		if (ret)
-			break;
-
-		iova += mapped;
-		paddr += mapped;
-	}
+			return ret;
 
-	/* unroll mapping in case something went wrong */
-	if (ret) {
-		iommu_unmap(domain, orig_iova, orig_size - size);
-		return ret;
+		size -= op_mapped;
+		iova += op_mapped;
+		paddr += op_mapped;
 	}
 	return 0;
 }
@@ -2685,6 +2678,7 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct pt_iommu *pt = iommupt_from_domain(domain);
+	size_t mapped = 0;
 	int ret;
 
 	might_sleep_if(gfpflags_allow_blocking(gfp));
@@ -2696,24 +2690,19 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 				 __GFP_HIGHMEM))))
 		return -EINVAL;
 
-	if (pt) {
-		size_t mapped = 0;
-
+	if (pt)
 		ret = pt->ops->map_range(pt, iova, paddr, size, prot, gfp,
 					 &mapped);
-		if (ret) {
-			iommu_unmap(domain, iova, mapped);
-			return ret;
-		}
-	} else {
+	else
 		ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot,
-					       gfp);
-		if (ret)
-			return ret;
-	}
+					       gfp, &mapped);
 
-	trace_map(iova, paddr, size);
-	iommu_debug_map(domain, paddr, size);
+	trace_map(iova, paddr, mapped);
+	iommu_debug_map(domain, paddr, mapped);
+	if (ret) {
+		iommu_unmap(domain, iova, mapped);
+		return ret;
+	}
 	return 0;
 }
 
-- 
2.53.0



