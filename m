Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E3A143C43;
	Wed, 19 Jun 2024 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802568; cv=none; b=m9uIvFN8taXgYmridKRst0QO0ELYy5rqyL37/2LdT6Fq6ysEK6pAiE0/46B2SPVmQ1Y+1OlBCRW1TvdfWKxz4admRQkJKZmjPxG3bUznSR2f0Y0/8iybHa2Gn7YtCSuLyZMHBXJwM6EnY4IsSDphnGJvk6s13jTub7xr1kdIPmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802568; c=relaxed/simple;
	bh=qGaX9WDcgpsQ+WQkLDTSJSlRPvS/u/f6TRLlnGtCcyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2RAPDbTiEV8fO4DtmwyVXtzpDP+OLlfzxJKVb3ZsK8+0RdPcY+CWzTRGfWhed086D37QXcRJps7uBPOiiPqLWQeYCNbkwoTAb4v8GPVldpjyvKCsxu0cIMq401GK0hXdUrRN7v8sILi17x0q2b1zY2m7/qZBxua84jDUYJzds8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIn6cu2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIn6cu2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73763C2BBFC;
	Wed, 19 Jun 2024 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802567;
	bh=qGaX9WDcgpsQ+WQkLDTSJSlRPvS/u/f6TRLlnGtCcyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIn6cu2OPJj1GrfhJEebk5MwFPP1KMGw+x+F7zgMHdYCOnSqpMuOjKS2vrqQ8BNYN
	 EzEh9q9yFC1K9d3wYe4KXnw6fteivnYuzyVK77PgXlVZNpd3tcS+tkRePiHri8n/IC
	 mUJjKlfM8Iju80ykfr7xTVSVe+VbhyO9JWVfArR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"will@kernel.org, mhklinux@outlook.com, petr.tesarik1@huawei-partners.com, nicolinc@nvidia.com, hch@lst.de, Fabio Estevam" <festevam@denx.de>,
	Petr Tesarik <petr.tesarik1@huawei-partners.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Christoph Hellwig <hch@lst.de>,
	Fabio Estevam <festevam@denx.de>
Subject: [PATCH 6.6 240/267] swiotlb: extend buffer pre-padding to alloc_align_mask if necessary
Date: Wed, 19 Jun 2024 14:56:31 +0200
Message-ID: <20240619125615.534420629@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

commit af133562d5aff41fcdbe51f1a504ae04788b5fc0 upstream.

Allow a buffer pre-padding of up to alloc_align_mask, even if it requires
allocating additional IO TLB slots.

If the allocation alignment is bigger than IO_TLB_SIZE and min_align_mask
covers any non-zero bits in the original address between IO_TLB_SIZE and
alloc_align_mask, these bits are not preserved in the swiotlb buffer
address.

To fix this case, increase the allocation size and use a larger offset
within the allocated buffer. As a result, extra padding slots may be
allocated before the mapping start address.

Leave orig_addr in these padding slots initialized to INVALID_PHYS_ADDR.
These slots do not correspond to any CPU buffer, so attempts to sync the
data should be ignored.

The padding slots should be automatically released when the buffer is
unmapped. However, swiotlb_tbl_unmap_single() takes only the address of the
DMA buffer slot, not the first padding slot. Save the number of padding
slots in struct io_tlb_slot and use it to adjust the slot index in
swiotlb_release_slots(), so all allocated slots are properly freed.

Cc: stable@vger.kernel.org # v6.6+
Fixes: 2fd4fa5d3fb5 ("swiotlb: Fix alignment checks when both allocation and DMA masks are present")
Link: https://lore.kernel.org/linux-iommu/20240311210507.217daf8b@meshulam.tesarici.cz/
Signed-off-by: Petr Tesarik <petr.tesarik1@huawei-partners.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |   59 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 13 deletions(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -69,11 +69,14 @@
  * @alloc_size:	Size of the allocated buffer.
  * @list:	The free list describing the number of free entries available
  *		from each index.
+ * @pad_slots:	Number of preceding padding slots. Valid only in the first
+ *		allocated non-padding slot.
  */
 struct io_tlb_slot {
 	phys_addr_t orig_addr;
 	size_t alloc_size;
-	unsigned int list;
+	unsigned short list;
+	unsigned short pad_slots;
 };
 
 static bool swiotlb_force_bounce;
@@ -287,6 +290,7 @@ static void swiotlb_init_io_tlb_pool(str
 					 mem->nslabs - i);
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
+		mem->slots[i].pad_slots = 0;
 	}
 
 	memset(vaddr, 0, bytes);
@@ -821,12 +825,30 @@ void swiotlb_dev_init(struct device *dev
 #endif
 }
 
-/*
- * Return the offset into a iotlb slot required to keep the device happy.
+/**
+ * swiotlb_align_offset() - Get required offset into an IO TLB allocation.
+ * @dev:         Owning device.
+ * @align_mask:  Allocation alignment mask.
+ * @addr:        DMA address.
+ *
+ * Return the minimum offset from the start of an IO TLB allocation which is
+ * required for a given buffer address and allocation alignment to keep the
+ * device happy.
+ *
+ * First, the address bits covered by min_align_mask must be identical in the
+ * original address and the bounce buffer address. High bits are preserved by
+ * choosing a suitable IO TLB slot, but bits below IO_TLB_SHIFT require extra
+ * padding bytes before the bounce buffer.
+ *
+ * Second, @align_mask specifies which bits of the first allocated slot must
+ * be zero. This may require allocating additional padding slots, and then the
+ * offset (in bytes) from the first such padding slot is returned.
  */
-static unsigned int swiotlb_align_offset(struct device *dev, u64 addr)
+static unsigned int swiotlb_align_offset(struct device *dev,
+					 unsigned int align_mask, u64 addr)
 {
-	return addr & dma_get_min_align_mask(dev) & (IO_TLB_SIZE - 1);
+	return addr & dma_get_min_align_mask(dev) &
+		(align_mask | (IO_TLB_SIZE - 1));
 }
 
 /*
@@ -847,7 +869,7 @@ static void swiotlb_bounce(struct device
 		return;
 
 	tlb_offset = tlb_addr & (IO_TLB_SIZE - 1);
-	orig_addr_offset = swiotlb_align_offset(dev, orig_addr);
+	orig_addr_offset = swiotlb_align_offset(dev, 0, orig_addr);
 	if (tlb_offset < orig_addr_offset) {
 		dev_WARN_ONCE(dev, 1,
 			"Access before mapping start detected. orig offset %u, requested offset %u.\n",
@@ -983,7 +1005,7 @@ static int swiotlb_area_find_slots(struc
 	unsigned long max_slots = get_max_slots(boundary_mask);
 	unsigned int iotlb_align_mask = dma_get_min_align_mask(dev);
 	unsigned int nslots = nr_slots(alloc_size), stride;
-	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
+	unsigned int offset = swiotlb_align_offset(dev, 0, orig_addr);
 	unsigned int index, slots_checked, count = 0, i;
 	unsigned long flags;
 	unsigned int slot_base;
@@ -1282,11 +1304,12 @@ phys_addr_t swiotlb_tbl_map_single(struc
 		unsigned long attrs)
 {
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
-	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
+	unsigned int offset;
 	struct io_tlb_pool *pool;
 	unsigned int i;
 	int index;
 	phys_addr_t tlb_addr;
+	unsigned short pad_slots;
 
 	if (!mem || !mem->nslabs) {
 		dev_warn_ratelimited(dev,
@@ -1303,6 +1326,7 @@ phys_addr_t swiotlb_tbl_map_single(struc
 		return (phys_addr_t)DMA_MAPPING_ERROR;
 	}
 
+	offset = swiotlb_align_offset(dev, alloc_align_mask, orig_addr);
 	index = swiotlb_find_slots(dev, orig_addr,
 				   alloc_size + offset, alloc_align_mask, &pool);
 	if (index == -1) {
@@ -1318,6 +1342,10 @@ phys_addr_t swiotlb_tbl_map_single(struc
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
+	pad_slots = offset >> IO_TLB_SHIFT;
+	offset &= (IO_TLB_SIZE - 1);
+	index += pad_slots;
+	pool->slots[index].pad_slots = pad_slots;
 	for (i = 0; i < nr_slots(alloc_size + offset); i++)
 		pool->slots[index + i].orig_addr = slot_addr(orig_addr, i);
 	tlb_addr = slot_addr(pool->start, index) + offset;
@@ -1336,13 +1364,17 @@ static void swiotlb_release_slots(struct
 {
 	struct io_tlb_pool *mem = swiotlb_find_pool(dev, tlb_addr);
 	unsigned long flags;
-	unsigned int offset = swiotlb_align_offset(dev, tlb_addr);
-	int index = (tlb_addr - offset - mem->start) >> IO_TLB_SHIFT;
-	int nslots = nr_slots(mem->slots[index].alloc_size + offset);
-	int aindex = index / mem->area_nslabs;
-	struct io_tlb_area *area = &mem->areas[aindex];
+	unsigned int offset = swiotlb_align_offset(dev, 0, tlb_addr);
+	int index, nslots, aindex;
+	struct io_tlb_area *area;
 	int count, i;
 
+	index = (tlb_addr - offset - mem->start) >> IO_TLB_SHIFT;
+	index -= mem->slots[index].pad_slots;
+	nslots = nr_slots(mem->slots[index].alloc_size + offset);
+	aindex = index / mem->area_nslabs;
+	area = &mem->areas[aindex];
+
 	/*
 	 * Return the buffer to the free list by setting the corresponding
 	 * entries to indicate the number of contiguous entries available.
@@ -1365,6 +1397,7 @@ static void swiotlb_release_slots(struct
 		mem->slots[i].list = ++count;
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
+		mem->slots[i].pad_slots = 0;
 	}
 
 	/*


