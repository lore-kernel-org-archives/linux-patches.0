Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B8B847F;
	Fri, 10 Mar 2023 13:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADC2C433EF;
	Fri, 10 Mar 2023 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456646;
	bh=sycv6iu5K5F3S5Tr2gJLFuQPxHuazObeqeVF4t+R/m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9mE1dVnmEvfMoyBn/cg5CdMdRAX/akaDpQwafzRM4KKYx5cjwEemUE8+BZTkax6C
	 bUCGp+iKc+54aLqZ98AGvwHxI0X7P8BYWTZFFM6mhVCixfM3LRJeYYzy/qko8RB6aL
	 cQrhalVASLsNeosdM/hUyqiowu85KXdPX08Z2EB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	iommu@lists.linux.dev,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 073/211] swiotlb: mark swiotlb_memblock_alloc() as __init
Date: Fri, 10 Mar 2023 14:37:33 +0100
Message-Id: <20230310133721.005935440@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 9b07d27d0fbb7f7441aa986859a0f53ec93a0335 ]

swiotlb_memblock_alloc() calls memblock_alloc(), which calls
(__init) memblock_alloc_try_nid(). However, swiotlb_membloc_alloc()
can be marked as __init since it is only called by swiotlb_init_remap(),
which is already marked as __init. This prevents a modpost build
warning/error:

WARNING: modpost: vmlinux.o: section mismatch in reference: swiotlb_memblock_alloc (section: .text) -> memblock_alloc_try_nid (section: .init.text)
WARNING: modpost: vmlinux.o: section mismatch in reference: swiotlb_memblock_alloc (section: .text) -> memblock_alloc_try_nid (section: .init.text)

This fixes the build warning/error seen on ARM64, PPC64, S390, i386,
and x86_64.

Fixes: 8d58aa484920 ("swiotlb: reduce the swiotlb buffer size on allocation failure")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: iommu@lists.linux.dev
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index a34c38bbe28f1..ef3bc3a5bbed3 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -300,7 +300,8 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 	return;
 }
 
-static void *swiotlb_memblock_alloc(unsigned long nslabs, unsigned int flags,
+static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
+		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
 	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
-- 
2.39.2



