Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6FA446AC;
	Mon,  1 Apr 2024 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988839; cv=none; b=TgpIwuB1kh6EhZsAjAx6UC2NKaUZt9NMBSIawX1RexQfWs8ffdWx2nGRrOLyAjVBjfF7eZD87QOai+jAtv0aSWlteklVHPC0cniWz4PHtB9ZRj5sYqUeGhqAuoDW2WMvRwRtdoSme+OeqpTlXhHs2ig9wTA1XYiF2OqpvmY8oOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988839; c=relaxed/simple;
	bh=5W/PH10U5zcQzJ/Mwsq91dJaSPfuN0chxKayjG6/rhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9l00yCAZ4HDJ8AK3QcsDRLcg7ODDeQ1ST1YphGCI3pt29VfAxfSPEzfHdKqL0MxlmfMjCpNE5RnRESOHRCtpa+xIEQrct8JJM2PPoX5At95Y3RDnwOWkMM30craWuD78RtLzDArd4cv2PEfLXlMg3IvnRGSPv0TTgDcN+ojyf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TyWYbDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TyWYbDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D5EC433C7;
	Mon,  1 Apr 2024 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988839;
	bh=5W/PH10U5zcQzJ/Mwsq91dJaSPfuN0chxKayjG6/rhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TyWYbDTUk3xJ+OP3bXkeuj8INQwb7jZUV6M0cgmMkWy1bdrVV1hMfn5TEpjbwYQU
	 9lLTzOnkyT84WtlXQfA52RUFHQFvy58v87iKpc93oyHjZNkemhTZXUU+OINSfmyo3w
	 k3ywqRjP1/mNkSoawwhdUV+NXto4MuG4fkRuuAyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 304/432] swiotlb: Fix alignment checks when both allocation and DMA masks are present
Date: Mon,  1 Apr 2024 17:44:51 +0200
Message-ID: <20240401152602.258326466@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 2d347685cf566..9edfb3b7702bb 100644
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



