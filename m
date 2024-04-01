Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C340876;
	Mon,  1 Apr 2024 16:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990241; cv=none; b=BcWOxHkwhrSMVG75owPSf0kIOCeaVc1cjZ04dEGTo99oiudH6J27BY9eITG6HmNjfploEZy/2wnm3Lb4NUbhuStRaqJ95gIPyeLHZi+zLMtIkvNiz95jiD9D137E29IuuDfrKFMFa6eZeYebN+5oqmQQ/kXwv7fkBEL1OyRQ/NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990241; c=relaxed/simple;
	bh=9+Wa5HP77h5phw56+vIBjCVHuCv6duYsTXPFHQuw47Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsJhPnkrlWe/C5QqlImykdfkufGQSbmklBhA38a0brBHTIQyoPNfV05ynuHVdq6bhbhoidht026RUjkvBPYs+Aw9YsPpEMgjAwdXWXu9TSY3NO/9z5fBhICP+GxprOkTCrEsDoM9f3R7ekO0LHj5ofZap78CsK+dChj5k+m2ZQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rc9Iu0Km; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rc9Iu0Km"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D6FC433F1;
	Mon,  1 Apr 2024 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990240;
	bh=9+Wa5HP77h5phw56+vIBjCVHuCv6duYsTXPFHQuw47Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rc9Iu0Kmk9b/YmhTD5gcgiyql2uBDoHQ+WW+NILWgQjDbDYJyb71E74YjXORW4NPr
	 nw2zrY4CPh0IX4P130aQA7k4rg5B8DsUvMd/iOumovX2/XsTKiFjYPao56NElKTDGq
	 2H6s/TQOJqpjnWGv9NwluosPWHawX+DQoDSm4Fd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/396] swiotlb: Fix alignment checks when both allocation and DMA masks are present
Date: Mon,  1 Apr 2024 17:45:39 +0200
Message-ID: <20240401152556.550855173@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[ Upstream commit 51b30ecb73b481d5fac6ccf2ecb4a309c9ee3310 ]

Nicolin reports that swiotlb buffer allocations fail for an NVME device
behind an IOMMU using 64KiB pages. This is because we end up with a
minimum allocation alignment of 64KiB (for the IOMMU to map the buffer
safely) but a minimum DMA alignment mask corresponding to a 4KiB NVME
page (i.e. preserving the 4KiB page offset from the original allocation).
If the original address is not 4KiB-aligned, the allocation will fail
because swiotlb_search_pool_area() erroneously compares these unmasked
bits with the 64KiB-aligned candidate allocation.

Tweak swiotlb_search_pool_area() so that the DMA alignment mask is
reduced based on the required alignment of the allocation.

Fixes: 82612d66d51d ("iommu: Allow the dma-iommu api to use bounce buffers")
Link: https://lore.kernel.org/r/cover.1707851466.git.nicolinc@nvidia.com
Reported-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index ded5a1f9e8f82..675ae318f74f8 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -981,8 +981,7 @@ static int swiotlb_area_find_slots(struct device *dev, struct io_tlb_pool *pool,
 	dma_addr_t tbl_dma_addr =
 		phys_to_dma_unencrypted(dev, pool->start) & boundary_mask;
 	unsigned long max_slots = get_max_slots(boundary_mask);
-	unsigned int iotlb_align_mask =
-		dma_get_min_align_mask(dev) & ~(IO_TLB_SIZE - 1);
+	unsigned int iotlb_align_mask = dma_get_min_align_mask(dev);
 	unsigned int nslots = nr_slots(alloc_size), stride;
 	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
 	unsigned int index, slots_checked, count = 0, i;
@@ -993,6 +992,14 @@ static int swiotlb_area_find_slots(struct device *dev, struct io_tlb_pool *pool,
 	BUG_ON(!nslots);
 	BUG_ON(area_index >= pool->nareas);
 
+	/*
+	 * Ensure that the allocation is at least slot-aligned and update
+	 * 'iotlb_align_mask' to ignore bits that will be preserved when
+	 * offsetting into the allocation.
+	 */
+	alloc_align_mask |= (IO_TLB_SIZE - 1);
+	iotlb_align_mask &= ~alloc_align_mask;
+
 	/*
 	 * For mappings with an alignment requirement don't bother looping to
 	 * unaligned slots once we found an aligned one.
-- 
2.43.0



