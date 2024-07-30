Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7581A6160;
	Tue, 30 Jul 2024 16:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356771; cv=none; b=i9NvII7iX9pd1NFSVg79iyN5TR6r4bfN/2XwG6qNovmb+fFZBrKsWHQ+k68ModA0z8UtbbiWuCzZDabz6VtFIF2DKbwlG90w1thBX8zlo9b1V8nrLJkiJ8tvJlqnmoppJTQPcmtNP+wBRZ7jiIQXMgmO6TYhNI+HMqK/uzoMVQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356771; c=relaxed/simple;
	bh=5kwgm8QScgqpeqP7V57XwufKlCv0V2YMgwChYI13K8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSIBDlOa6Pt42ogeBa9O2xReyOKWvADgkSATx0QycostGmPqHYcF4gJ2eHfOnUMJyGc6PwMnVaQi34xPdAC+FW9B0Mk1uMsoje8UMeDNI+/3JXFL8Gs/n7oH6sN3JSUxhSdfkyTfU2gJnCYVWtlK1WBRdMX22twW7744DRRnFMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04ZY/o1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04ZY/o1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F737C4AF0C;
	Tue, 30 Jul 2024 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356771;
	bh=5kwgm8QScgqpeqP7V57XwufKlCv0V2YMgwChYI13K8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04ZY/o1cLY/HvbXnc9JE0/hv3mFEAhR1QiMCd9V/U5Q+kXvFxcj+e8SoS78mcly0K
	 464fSIi5kMi9ft6xiwA8T6XRreAwliXE6Qj6La0VwtAqsdkeA0+f5zfrzYV98xAJHd
	 fn5Zdf76rK/W7lduQ2UIe8XVxyFD8cOSTesqbivY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanfei Xu <yanfei.xu@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 227/440] iommu/vt-d: Fix to convert mm pfn to dma pfn
Date: Tue, 30 Jul 2024 17:47:40 +0200
Message-ID: <20240730151624.725021111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanfei Xu <yanfei.xu@intel.com>

[ Upstream commit fb5f50a43d9fd44fd6bc4f4dbcf9d3ec5b556558 ]

For the case that VT-d page is smaller than mm page, converting dma pfn
should be handled in two cases which are for start pfn and for end pfn.
Currently the calculation of end dma pfn is incorrect and the result is
less than real page frame number which is causing the mapping of iova
always misses some page frames.

Rename the mm_to_dma_pfn() to mm_to_dma_pfn_start() and add a new helper
for converting end dma pfn named mm_to_dma_pfn_end().

Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
Link: https://lore.kernel.org/r/20230625082046.979742-1-yanfei.xu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 31000732d56b ("iommu/vt-d: Fix identity map bounds in si_domain_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e111b35a7aff2..e3a95a347c3b9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -113,13 +113,17 @@ static inline unsigned long lvl_to_nr_pages(unsigned int lvl)
 
 /* VT-d pages must always be _smaller_ than MM pages. Otherwise things
    are never going to work. */
-static inline unsigned long mm_to_dma_pfn(unsigned long mm_pfn)
+static inline unsigned long mm_to_dma_pfn_start(unsigned long mm_pfn)
 {
 	return mm_pfn << (PAGE_SHIFT - VTD_PAGE_SHIFT);
 }
+static inline unsigned long mm_to_dma_pfn_end(unsigned long mm_pfn)
+{
+	return ((mm_pfn + 1) << (PAGE_SHIFT - VTD_PAGE_SHIFT)) - 1;
+}
 static inline unsigned long page_to_dma_pfn(struct page *pg)
 {
-	return mm_to_dma_pfn(page_to_pfn(pg));
+	return mm_to_dma_pfn_start(page_to_pfn(pg));
 }
 static inline unsigned long virt_to_dma_pfn(void *p)
 {
@@ -2439,8 +2443,8 @@ static int __init si_domain_init(int hw)
 
 		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			ret = iommu_domain_identity_map(si_domain,
-					mm_to_dma_pfn(start_pfn),
-					mm_to_dma_pfn(end_pfn));
+					mm_to_dma_pfn_start(start_pfn),
+					mm_to_dma_pfn_end(end_pfn));
 			if (ret)
 				return ret;
 		}
@@ -2461,8 +2465,8 @@ static int __init si_domain_init(int hw)
 				continue;
 
 			ret = iommu_domain_identity_map(si_domain,
-					mm_to_dma_pfn(start >> PAGE_SHIFT),
-					mm_to_dma_pfn(end >> PAGE_SHIFT));
+					mm_to_dma_pfn_start(start >> PAGE_SHIFT),
+					mm_to_dma_pfn_end(end >> PAGE_SHIFT));
 			if (ret)
 				return ret;
 		}
@@ -3698,8 +3702,8 @@ static int intel_iommu_memory_notifier(struct notifier_block *nb,
 				       unsigned long val, void *v)
 {
 	struct memory_notify *mhp = v;
-	unsigned long start_vpfn = mm_to_dma_pfn(mhp->start_pfn);
-	unsigned long last_vpfn = mm_to_dma_pfn(mhp->start_pfn +
+	unsigned long start_vpfn = mm_to_dma_pfn_start(mhp->start_pfn);
+	unsigned long last_vpfn = mm_to_dma_pfn_end(mhp->start_pfn +
 			mhp->nr_pages - 1);
 
 	switch (val) {
@@ -4401,7 +4405,7 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 	unsigned long i;
 
 	nrpages = aligned_nrpages(gather->start, size);
-	start_pfn = mm_to_dma_pfn(iova_pfn);
+	start_pfn = mm_to_dma_pfn_start(iova_pfn);
 
 	xa_for_each(&dmar_domain->iommu_array, i, info)
 		iommu_flush_iotlb_psi(info->iommu, dmar_domain,
-- 
2.43.0



