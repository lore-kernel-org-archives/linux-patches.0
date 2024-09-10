Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C9618C336;
	Tue, 10 Sep 2024 09:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961837; cv=none; b=f9aH17wk6dFE9vbfM6RrOs01dVAk6rLQPkG802W8AT75TORlEB+SU97BcpaVzokdbx/y/CYUoD64uWGPOJAsfuid3C+R9eGNyklW0He2WZp8q00UrvkxAK9972ZNVKptgz0/lO+qiyJsCKWivAMsqalUBhF6hYGGIMBwDkIUgSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961837; c=relaxed/simple;
	bh=S9XO6YxABW1qNM/hLk7iMGySfKnzE07W0W9kreOMjzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+kusHOIFQISf875BOvdunWnYmZNhTStEnwOhYLvnNRaOve3I3mTt59HfmVRVGlyMZsJJSsqVPkVWSJUw6YxIjyhPQ/GPAr5N2ibumdNPTKFAYKqyV/F+zN8wbzxBAbSwb1Er8PGaOV7NoU3klz3D4kPOtOCXDCNS8o2rpz43+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHyCdSDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHyCdSDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120DCC4CEC3;
	Tue, 10 Sep 2024 09:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961837;
	bh=S9XO6YxABW1qNM/hLk7iMGySfKnzE07W0W9kreOMjzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHyCdSDD16weLNawWnjF6dvNRRIVwDpE1oDxQkay8koAQAc5Dhozjf14a8z+0pAbW
	 kt/ei8uBSYyn+Z+N8rX9Ra50DAiUYNHxkJEokqvKthSEr4HaEP2K2ByLbePoqhwwlA
	 7BUkZ3SWkvg28RTuZ5gb6k+1uILCEtN8pWFTnHf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 206/375] iommu/vt-d: Remove control over Execute-Requested requests
Date: Tue, 10 Sep 2024 11:30:03 +0200
Message-ID: <20240910092629.427141790@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit e995fcde6070f0981e083c1e2e17e401e6c17ad9 ]

The VT-d specification has removed architectural support of the requests
with pasid with a value of 1 for Execute-Requested (ER). And the NXE bit
in the pasid table entry and XD bit in the first-stage paging Entries are
deprecated accordingly.

Remove the programming of these bits to make it consistent with the spec.

Suggested-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240624032351.249858-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20240702130839.108139-4-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c |  4 ++--
 drivers/iommu/intel/iommu.h |  6 ++----
 drivers/iommu/intel/pasid.c |  1 -
 drivers/iommu/intel/pasid.h | 10 ----------
 4 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f55ec1fd7942..e9bea0305c26 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -854,7 +854,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
 			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
 			if (domain->use_first_level)
-				pteval |= DMA_FL_PTE_XD | DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
+				pteval |= DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
 
 			tmp = 0ULL;
 			if (!try_cmpxchg64(&pte->val, &tmp, pteval))
@@ -1872,7 +1872,7 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
 	attr |= DMA_FL_PTE_PRESENT;
 	if (domain->use_first_level) {
-		attr |= DMA_FL_PTE_XD | DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
+		attr |= DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
 		if (prot & DMA_PTE_WRITE)
 			attr |= DMA_FL_PTE_DIRTY;
 	}
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index eaf015b4353b..9a3b064126de 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -49,7 +49,6 @@
 #define DMA_FL_PTE_US		BIT_ULL(2)
 #define DMA_FL_PTE_ACCESS	BIT_ULL(5)
 #define DMA_FL_PTE_DIRTY	BIT_ULL(6)
-#define DMA_FL_PTE_XD		BIT_ULL(63)
 
 #define DMA_SL_PTE_DIRTY_BIT	9
 #define DMA_SL_PTE_DIRTY	BIT_ULL(DMA_SL_PTE_DIRTY_BIT)
@@ -831,11 +830,10 @@ static inline void dma_clear_pte(struct dma_pte *pte)
 static inline u64 dma_pte_addr(struct dma_pte *pte)
 {
 #ifdef CONFIG_64BIT
-	return pte->val & VTD_PAGE_MASK & (~DMA_FL_PTE_XD);
+	return pte->val & VTD_PAGE_MASK;
 #else
 	/* Must have a full atomic 64-bit read */
-	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) &
-			VTD_PAGE_MASK & (~DMA_FL_PTE_XD);
+	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
 #endif
 }
 
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index abce19e2ad6f..aabcdf756581 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -333,7 +333,6 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
-	pasid_set_nxe(pte);
 
 	/* Setup Present and PASID Granular Transfer Type: */
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_FL_ONLY);
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index da9978fef7ac..dde6d3ba5ae0 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -247,16 +247,6 @@ static inline void pasid_set_page_snoop(struct pasid_entry *pe, bool value)
 	pasid_set_bits(&pe->val[1], 1 << 23, value << 23);
 }
 
-/*
- * Setup No Execute Enable bit (Bit 133) of a scalable mode PASID
- * entry. It is required when XD bit of the first level page table
- * entry is about to be set.
- */
-static inline void pasid_set_nxe(struct pasid_entry *pe)
-{
-	pasid_set_bits(&pe->val[2], 1 << 5, 1 << 5);
-}
-
 /*
  * Setup the Page Snoop (PGSNP) field (Bit 88) of a scalable mode
  * PASID entry.
-- 
2.43.0



