Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3856C381D6;
	Fri, 24 Nov 2023 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9OTtQqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC97C433C8;
	Fri, 24 Nov 2023 18:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850160;
	bh=ELTDsoXldzoVK4tJ7/jn0Bs3yJ9cu/ewvwymdf7aulU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9OTtQqZWjGWlm2Px7Ob9Zhw7fnZIWa2oUa/9ki6DMOO0hIUU0iHqFBRlNVsrwCJ9
	 mZb5IPyxLdR1mc+bgn9lGXAppsp6w24vJprKCr4wLSVk/yYuwFsGk39mIs0fKZIWZY
	 kK2tvhve8pDAVX9yucxfsyAI+WvfBUNU428Nr5H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Petr Tesarik <petr.tesarik1@huawei-partners.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.6 469/530] swiotlb: fix out-of-bounds TLB allocations with CONFIG_SWIOTLB_DYNAMIC
Date: Fri, 24 Nov 2023 17:50:35 +0000
Message-ID: <20231124172042.349387737@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Petr Tesarik <petr.tesarik1@huawei-partners.com>

commit 53c87e846e335e3c18044c397cc35178163d7827 upstream.

Limit the free list length to the size of the IO TLB. Transient pool can be
smaller than IO_TLB_SEGSIZE, but the free list is initialized with the
assumption that the total number of slots is a multiple of IO_TLB_SEGSIZE.
As a result, swiotlb_area_find_slots() may allocate slots past the end of
a transient IO TLB buffer.

Reported-by: Niklas Schnelle <schnelle@linux.ibm.com>
Closes: https://lore.kernel.org/linux-iommu/104a8c8fedffd1ff8a2890983e2ec1c26bff6810.camel@linux.ibm.com/
Fixes: 79636caad361 ("swiotlb: if swiotlb is full, fall back to a transient memory pool")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Tesarik <petr.tesarik1@huawei-partners.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 71392c9fac10..33d942615be5 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -283,7 +283,8 @@ static void swiotlb_init_io_tlb_pool(struct io_tlb_pool *mem, phys_addr_t start,
 	}
 
 	for (i = 0; i < mem->nslabs; i++) {
-		mem->slots[i].list = IO_TLB_SEGSIZE - io_tlb_offset(i);
+		mem->slots[i].list = min(IO_TLB_SEGSIZE - io_tlb_offset(i),
+					 mem->nslabs - i);
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
 	}
-- 
2.43.0



