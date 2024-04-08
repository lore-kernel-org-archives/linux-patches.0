Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC1885284;
	Mon,  8 Apr 2024 13:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582699; cv=none; b=nuxqCXWlSoOQDcf+3TKXUeioRkhIRvLMlHnkTjxujK16AciMZ/LK49yCs3vaOU8l02LwBv+HwqegkHRmiohiOuAubOqkcF3aVRn5gaPxmIzMG8JkyQ1GEg08d/vc7wo+DEFRZXaqHb+xRF9X0v45vVdkYoiwV8FFUlpyVBIhjEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582699; c=relaxed/simple;
	bh=AZJqBFkiZ7ds04KrSC4aNj8EJws8DOQsPUhRW+7oP0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1WRUOVzU+Ik5M/lbwOV5rU1uVmgnw19Z6vnT9DTIjiJPpruMMkpmVfvJdrXp4gb2sngY1ySrsdDNJvLL6MGL6+9hS697U2EX5+h/peYWxnWHR09v1pR4ePEhRTJRlnCA0m8XOlphYCtWJkdFSOu984DbGi16vZoO0xeWpxy0fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0K5c1GnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0K5c1GnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D87C433F1;
	Mon,  8 Apr 2024 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582699;
	bh=AZJqBFkiZ7ds04KrSC4aNj8EJws8DOQsPUhRW+7oP0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0K5c1GnB0dS8/of7TaBjY1AkM5rkxX0OUWHELAqoCtUJ7X0Up5hPXPKmdOORw8Bty
	 juSkOtt8Sekdz4q/FC0IflzjFvi2nUqYGPlrlWH+JAQzjWQryFbcTmePQsQiC/HbDS
	 p3Rh63oCwqd07JnOxiVu0ga0rg1yo105AT/VxAN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/690] swiotlb: Fix alignment checks when both allocation and DMA masks are present
Date: Mon,  8 Apr 2024 14:50:08 +0200
Message-ID: <20240408125404.664613612@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a9849670bdb54..5c7ed5d519424 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -469,8 +469,7 @@ static int swiotlb_find_slots(struct device *dev, phys_addr_t orig_addr,
 	dma_addr_t tbl_dma_addr =
 		phys_to_dma_unencrypted(dev, mem->start) & boundary_mask;
 	unsigned long max_slots = get_max_slots(boundary_mask);
-	unsigned int iotlb_align_mask =
-		dma_get_min_align_mask(dev) & ~(IO_TLB_SIZE - 1);
+	unsigned int iotlb_align_mask = dma_get_min_align_mask(dev);
 	unsigned int nslots = nr_slots(alloc_size), stride;
 	unsigned int index, wrap, count = 0, i;
 	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
@@ -478,6 +477,14 @@ static int swiotlb_find_slots(struct device *dev, phys_addr_t orig_addr,
 
 	BUG_ON(!nslots);
 
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
 	 * unaligned slots once we found an aligned one.  For allocations of
-- 
2.43.0



