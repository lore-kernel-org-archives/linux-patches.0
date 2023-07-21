Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A6C20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA106C433C9;
	Fri, 21 Jul 2023 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967004;
	bh=a4PgXN//rlm5y+8RxnIoDDKJPqNpn3SX4h8K3CaHvik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwg5VbpCr8Z23iVZmCX/cOUOE3u1KB5h9yEOXcR9aJFDdKmIuBvZOJxNip6+DJbpy
	 xs6iJ00Mq/IzJXVpbX74UUr8WkIBR0reoWCTiaiSu8LiaLNsP9mtvZHt7MTGYPiQSW
	 gABfNkJthoWRpQasSG7uSoCfyhEaM0uT2GL0S9lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/223] swiotlb: reduce the swiotlb buffer size on allocation failure
Date: Fri, 21 Jul 2023 18:04:24 +0200
Message-ID: <20230721160521.356466644@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey Kardashevskiy <aik@amd.com>

[ Upstream commit 8d58aa484920c4f9be4834a7aeb446cdced21a37 ]

At the moment the AMD encrypted platform reserves 6% of RAM for SWIOTLB
or 1GB, whichever is less. However it is possible that there is no block
big enough in the low memory which make SWIOTLB allocation fail and
the kernel continues without DMA. In such case a VM hangs on DMA.

This moves alloc+remap to a helper and calls it from a loop where
the size is halved on each iteration.

This updates default_nslabs on successful allocation which looks like
an oversight as not doing so should have broken callers of
swiotlb_size_or_default().

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 8ac04063354a ("swiotlb: reduce the number of areas to match actual memory pool size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 63 +++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 3961065412542..cc0c55ed20429 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -307,6 +307,37 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 	return;
 }
 
+static void *swiotlb_memblock_alloc(unsigned long nslabs, unsigned int flags,
+		int (*remap)(void *tlb, unsigned long nslabs))
+{
+	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
+	void *tlb;
+
+	/*
+	 * By default allocate the bounce buffer memory from low memory, but
+	 * allow to pick a location everywhere for hypervisors with guest
+	 * memory encryption.
+	 */
+	if (flags & SWIOTLB_ANY)
+		tlb = memblock_alloc(bytes, PAGE_SIZE);
+	else
+		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
+
+	if (!tlb) {
+		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
+			__func__, bytes);
+		return NULL;
+	}
+
+	if (remap && remap(tlb, nslabs) < 0) {
+		memblock_free(tlb, PAGE_ALIGN(bytes));
+		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
+		return NULL;
+	}
+
+	return tlb;
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -317,7 +348,6 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 	struct io_tlb_mem *mem = &io_tlb_default_mem;
 	unsigned long nslabs;
 	size_t alloc_size;
-	size_t bytes;
 	void *tlb;
 
 	if (!addressing_limit && !swiotlb_force_bounce)
@@ -329,31 +359,16 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 	nslabs = default_nslabs;
-	/*
-	 * By default allocate the bounce buffer memory from low memory, but
-	 * allow to pick a location everywhere for hypervisors with guest
-	 * memory encryption.
-	 */
-retry:
-	bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
-	if (flags & SWIOTLB_ANY)
-		tlb = memblock_alloc(bytes, PAGE_SIZE);
-	else
-		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
-	if (!tlb) {
-		pr_warn("%s: failed to allocate tlb structure\n", __func__);
-		return;
-	}
-
-	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
-
+	while ((tlb = swiotlb_memblock_alloc(nslabs, flags, remap)) == NULL) {
+		if (nslabs <= IO_TLB_MIN_SLABS)
+			return;
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
-		if (nslabs >= IO_TLB_MIN_SLABS)
-			goto retry;
+	}
 
-		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
-		return;
+	if (default_nslabs != nslabs) {
+		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
+			default_nslabs, nslabs);
+		default_nslabs = nslabs;
 	}
 
 	alloc_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), nslabs));
-- 
2.39.2



