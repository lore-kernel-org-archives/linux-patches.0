Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9A44CB4A;
	Mon,  1 Apr 2024 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990237; cv=none; b=NHRhx7orB6Fk2pU66Z93D7nUQQNC2RUJ1C103weIUOTFRDx7BF2WQB8B2sg/2zNg7qiJrBXiO16SUQ+lAy/LRLOvIBk6RDBJdT451GPB7u0F06AKf5WEZvcIza7/QPFcK5+uHjSaJmt/GdzKxiJTVMO+UPLSR/hjBy5fjDVO2Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990237; c=relaxed/simple;
	bh=hDz67f2DB412MPmFBtDa4LB1SuH3Qj4S7QwtQDfgXeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXJbMa78NHlI185sFZMBgGzWBSaK30qI+SvoX1iLulS2gpCfB/TmC+X8Uaw4cepl+g3rR6mWbEXke2QR/o9imN2M7j+k5SclVV5B1bTmsf21kJnIQ7U3Wk/J4GxxVPnS/7n5Or7c2mx91C/7OXIK3RRmcGrl5TRMJaMddP+tFLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiYqRuld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiYqRuld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3DEC43390;
	Mon,  1 Apr 2024 16:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990237;
	bh=hDz67f2DB412MPmFBtDa4LB1SuH3Qj4S7QwtQDfgXeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiYqRuldcbUbTppvRIyqbgCFfGfeuXoMxFbIs/QCZBqppR38QzA5z4Ra+wo3IGlYC
	 thUNNZ/XooC4NgNcfzuBl95kJDWeqev0IuZTDOIVYZYpyrVxA+Qb7yRWAU5+0tzKgv
	 oocleKDU6CH2294kZQ57Cp6FLr4IIQO/a3Nku9KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Petr Tesarik <petr.tesarik1@huawei-partners.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/396] swiotlb: Honour dma_alloc_coherent() alignment in swiotlb_alloc()
Date: Mon,  1 Apr 2024 17:45:38 +0200
Message-ID: <20240401152556.521724707@linuxfoundation.org>
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

[ Upstream commit cbf53074a528191df82b4dba1e3d21191102255e ]

core-api/dma-api-howto.rst states the following properties of
dma_alloc_coherent():

  | The CPU virtual address and the DMA address are both guaranteed to
  | be aligned to the smallest PAGE_SIZE order which is greater than or
  | equal to the requested size.

However, swiotlb_alloc() passes zero for the 'alloc_align_mask'
parameter of swiotlb_find_slots() and so this property is not upheld.
Instead, allocations larger than a page are aligned to PAGE_SIZE,

Calculate the mask corresponding to the page order suitable for holding
the allocation and pass that to swiotlb_find_slots().

Fixes: e81e99bacc9f ("swiotlb: Support aligned swiotlb buffers")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Petr Tesarik <petr.tesarik1@huawei-partners.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index e59f510a5d8a6..ded5a1f9e8f82 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1608,12 +1608,14 @@ struct page *swiotlb_alloc(struct device *dev, size_t size)
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 	struct io_tlb_pool *pool;
 	phys_addr_t tlb_addr;
+	unsigned int align;
 	int index;
 
 	if (!mem)
 		return NULL;
 
-	index = swiotlb_find_slots(dev, 0, size, 0, &pool);
+	align = (1 << (get_order(size) + PAGE_SHIFT)) - 1;
+	index = swiotlb_find_slots(dev, 0, size, align, &pool);
 	if (index == -1)
 		return NULL;
 
-- 
2.43.0



