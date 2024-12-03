Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9261F75A4;
	Tue,  3 Dec 2024 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240552; cv=none; b=ezdFXDh4iCd9OgXtZTIF7H2rYXfImAXE7MWJjDgA312LRFaKXjzWinC2dzA9gIeJ6YYBRua7Pka2WVBq/LUQsYxpoutJFdqxXWkOK44AaEBOkb4u8no+ByVIGjaqOz4Myk9+fONtXOV4U4lQtW849KdzNzlvTMMew7FmdjszMCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240552; c=relaxed/simple;
	bh=DRdeuVY9+R7Xk6sIek5ata+mWhXnA+wPB16qDVXgsio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyXKOUHKAabKcdrPsrpY6z0dpdOmfS0vsViudV1Y9oPIagCe/LbvDRh9U3RvyLJgpPblXpbtMylHpiiNOfOtvhcCUxjH4LF2RpFpR/JMcoAir6/4N4KfE1l2snXj/WdZMGBo1Zto8ZblFH6Y9fUDxoA1+Ey+cQt/7+l5EeoIATk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUIsLhO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUIsLhO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBC4C4CECF;
	Tue,  3 Dec 2024 15:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240552;
	bh=DRdeuVY9+R7Xk6sIek5ata+mWhXnA+wPB16qDVXgsio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUIsLhO1cmQs99szkS3DRIvVkTYQMvKlFMsdnwHfB1BQQY5R2/D0KY7AV7W9Zaowb
	 XAQWPz774R/2bGTFfdMBOXLjhApTsbtsYcV4jmj/n+Z2eiA4wCzS18r+Gt45nT+o14
	 6RYozAF5skrBSfl7L/7Li/KKL0lit/qCx0G0HRuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/826] media: ipu6: Fix DMA and physical address debugging messages for 32-bit
Date: Tue,  3 Dec 2024 15:38:15 +0100
Message-ID: <20241203144750.287040084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 199c204bcc732ec18dbaec2b9d6445addbd376ea ]

Fix printing DMA and physical address printing on 32-bit platforms, by
using correct types. Also cast DMA_BIT_MASK() result to dma_addr_t to make
Clang happy.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: daabc5c64703 ("media: ipu6: not override the dma_ops of device in driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-dma.c |  7 ++++---
 drivers/media/pci/intel/ipu6/ipu6-mmu.c | 28 +++++++++++++++----------
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-dma.c b/drivers/media/pci/intel/ipu6/ipu6-dma.c
index 92530a1cc90f5..801f6bd00a891 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-dma.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-dma.c
@@ -428,11 +428,12 @@ static int ipu6_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 
 	iova_addr = iova->pfn_lo;
 	for_each_sg(sglist, sg, count, i) {
+		phys_addr_t iova_pa;
 		int ret;
 
-		dev_dbg(dev, "mapping entry %d: iova 0x%llx phy %pad size %d\n",
-			i, PFN_PHYS(iova_addr), &sg_dma_address(sg),
-			sg_dma_len(sg));
+		iova_pa = PFN_PHYS(iova_addr);
+		dev_dbg(dev, "mapping entry %d: iova %pap phy %pap size %d\n",
+			i, &iova_pa, &sg_dma_address(sg), sg_dma_len(sg));
 
 		ret = ipu6_mmu_map(mmu->dmap->mmu_info, PFN_PHYS(iova_addr),
 				   sg_dma_address(sg),
diff --git a/drivers/media/pci/intel/ipu6/ipu6-mmu.c b/drivers/media/pci/intel/ipu6/ipu6-mmu.c
index c3a20507d6dbc..57298ac73d072 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-mmu.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-mmu.c
@@ -97,13 +97,15 @@ static void page_table_dump(struct ipu6_mmu_info *mmu_info)
 	for (l1_idx = 0; l1_idx < ISP_L1PT_PTES; l1_idx++) {
 		u32 l2_idx;
 		u32 iova = (phys_addr_t)l1_idx << ISP_L1PT_SHIFT;
+		phys_addr_t l2_phys;
 
 		if (mmu_info->l1_pt[l1_idx] == mmu_info->dummy_l2_pteval)
 			continue;
+
+		l2_phys = TBL_PHYS_ADDR(mmu_info->l1_pt[l1_idx];)
 		dev_dbg(mmu_info->dev,
-			"l1 entry %u; iovas 0x%8.8x-0x%8.8x, at %pa\n",
-			l1_idx, iova, iova + ISP_PAGE_SIZE,
-			TBL_PHYS_ADDR(mmu_info->l1_pt[l1_idx]));
+			"l1 entry %u; iovas 0x%8.8x-0x%8.8x, at %pap\n",
+			l1_idx, iova, iova + ISP_PAGE_SIZE, &l2_phys);
 
 		for (l2_idx = 0; l2_idx < ISP_L2PT_PTES; l2_idx++) {
 			u32 *l2_pt = mmu_info->l2_pts[l1_idx];
@@ -227,7 +229,7 @@ static u32 *alloc_l1_pt(struct ipu6_mmu_info *mmu_info)
 	}
 
 	mmu_info->l1_pt_dma = dma >> ISP_PADDR_SHIFT;
-	dev_dbg(mmu_info->dev, "l1 pt %p mapped at %llx\n", pt, dma);
+	dev_dbg(mmu_info->dev, "l1 pt %p mapped at %pad\n", pt, &dma);
 
 	return pt;
 
@@ -330,8 +332,8 @@ static int __ipu6_mmu_map(struct ipu6_mmu_info *mmu_info, unsigned long iova,
 	u32 iova_end = ALIGN(iova + size, ISP_PAGE_SIZE);
 
 	dev_dbg(mmu_info->dev,
-		"mapping iova 0x%8.8x--0x%8.8x, size %zu at paddr 0x%10.10llx\n",
-		iova_start, iova_end, size, paddr);
+		"mapping iova 0x%8.8x--0x%8.8x, size %zu at paddr %pap\n",
+		iova_start, iova_end, size, &paddr);
 
 	return l2_map(mmu_info, iova_start, paddr, size);
 }
@@ -361,10 +363,13 @@ static size_t l2_unmap(struct ipu6_mmu_info *mmu_info, unsigned long iova,
 	for (l2_idx = (iova_start & ISP_L2PT_MASK) >> ISP_L2PT_SHIFT;
 	     (iova_start & ISP_L1PT_MASK) + (l2_idx << ISP_PAGE_SHIFT)
 		     < iova_start + size && l2_idx < ISP_L2PT_PTES; l2_idx++) {
+		phys_addr_t pteval;
+
 		l2_pt = mmu_info->l2_pts[l1_idx];
+		pteval = TBL_PHYS_ADDR(l2_pt[l2_idx]);
 		dev_dbg(mmu_info->dev,
-			"unmap l2 index %u with pteval 0x%10.10llx\n",
-			l2_idx, TBL_PHYS_ADDR(l2_pt[l2_idx]));
+			"unmap l2 index %u with pteval 0x%p\n",
+			l2_idx, &pteval);
 		l2_pt[l2_idx] = mmu_info->dummy_page_pteval;
 
 		clflush_cache_range((void *)&l2_pt[l2_idx],
@@ -525,9 +530,10 @@ static struct ipu6_mmu_info *ipu6_mmu_alloc(struct ipu6_device *isp)
 		return NULL;
 
 	mmu_info->aperture_start = 0;
-	mmu_info->aperture_end = DMA_BIT_MASK(isp->secure_mode ?
-					      IPU6_MMU_ADDR_BITS :
-					      IPU6_MMU_ADDR_BITS_NON_SECURE);
+	mmu_info->aperture_end =
+		(dma_addr_t)DMA_BIT_MASK(isp->secure_mode ?
+					 IPU6_MMU_ADDR_BITS :
+					 IPU6_MMU_ADDR_BITS_NON_SECURE);
 	mmu_info->pgsize_bitmap = SZ_4K;
 	mmu_info->dev = &isp->pdev->dev;
 
-- 
2.43.0



