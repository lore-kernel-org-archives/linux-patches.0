Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347381CA8F;
	Mon,  1 Apr 2024 16:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988836; cv=none; b=GuHngIyVfNvkKNhhHhQUo97BzGjtLUpwb49a1WV4E1hKEewZzcKhF5xJERXinybtyGOrVbpJICgg4LcJclu1lcU/lsKIYO6kMzKsUyI4Fbm5uKqISf2/OnltGyuyjR9ufII3Cvmgzhq4+QuGE3cOOQBQQyOJF4sWSAb2iJFiWnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988836; c=relaxed/simple;
	bh=YP9ZhuwGjOKgnEI3RIyrpcvhgNeHRhyopjMAlHBMjds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnyiPiJKHR8WxZJ/earhTrjD/+iRG3nRsBKSsRZ5BA8Dtd5IGCrDhScbp436CiUlP+EEsQm7jESXhQIVZEvDiFPEkWwWDRNXFQ5ooSC/ZgzdY2PQB3RKUYn2boS0DxwnmjpeD/DGY0jO3tjxZzd9iDhXkhsOUIjZytSiBfhmM7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODAUKGUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODAUKGUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973D8C433C7;
	Mon,  1 Apr 2024 16:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988836;
	bh=YP9ZhuwGjOKgnEI3RIyrpcvhgNeHRhyopjMAlHBMjds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODAUKGUKdXjPK49WyQjnDJWqUbhbk58b2th031IKJ6ifUOLysJ1+XAkpWlWeZobL+
	 hBDFYeaJBCZ6bVfNSEHZkZCS/DB3GDSrSOVQg7vlfUOI2IAzyVs/a/vTCSlULZ66Ny
	 +7QkInY2M+cAfyh/7H37dtDNvAyEMOrOnh3TrM14=
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
Subject: [PATCH 6.7 303/432] swiotlb: Honour dma_alloc_coherent() alignment in swiotlb_alloc()
Date: Mon,  1 Apr 2024 17:44:50 +0200
Message-ID: <20240401152602.229140671@linuxfoundation.org>
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
index 8fba61069b84d..2d347685cf566 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1610,12 +1610,14 @@ struct page *swiotlb_alloc(struct device *dev, size_t size)
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



