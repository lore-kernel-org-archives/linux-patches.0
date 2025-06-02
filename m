Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D8223DCF;
	Mon,  2 Jun 2025 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877052; cv=none; b=p9t+1u0xe8oIC2vHyHN0H5YwbAA3EPUK0OyYBL3hzON8OfFkIu8RkpknFOBwx5c5xsUdXxOVrbkfkK/R2/neYdK2r6onQqLy/BqAyDXBure6JvIIqXEAS14kU6If7wi0wAkG5+0xSwvxqboik5Yng+6lcrLCIZJm56ciLugtWYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877052; c=relaxed/simple;
	bh=3zORa9GMN09OmF/EpdQ45Yyo0udo5q3AGK3I7Jvb8ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX1sgYTRn+vgI6DtvdjHXrNK0KZtTsVXJvHdD4kGgQsSpc+RWLDGLCdVMyPXMau8/DdF6l2ZUS6SjjxXBcaHxw1MfOxkCSK+Nw4m/+kj+bvnhjVljKabX6WE79dIULzWRz6JgoFfpdKPE/3xmv8hb4tjyGj1OmbpQqxqZRPbhKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2byJOqNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2byJOqNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8258DC4CEF0;
	Mon,  2 Jun 2025 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877051;
	bh=3zORa9GMN09OmF/EpdQ45Yyo0udo5q3AGK3I7Jvb8ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2byJOqNrCDwlZYFs8VLegZXI17fHwiJOXiuyEPoo5wHMO4mD4DyQ6qVB986dOnJvj
	 m7MGae33KmufLvxhlPMadtKzrq7qzkYBXnYQw2WF9+oyxDu4TXktsw0XkZHa1Vort0
	 XDqwda65IJrglAzt5UJLlc2vBHm8wasojAltJj+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/325] RDMA/core: Fix best page size finding when it can cross SG entries
Date: Mon,  2 Jun 2025 15:47:13 +0200
Message-ID: <20250602134326.189620767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Margolin <mrgolin@amazon.com>

[ Upstream commit 486055f5e09df959ad4e3aa4ee75b5c91ddeec2e ]

A single scatter-gather entry is limited by a 32 bits "length" field
that is practically 4GB - PAGE_SIZE. This means that even when the
memory is physically contiguous, we might need more than one entry to
represent it. Additionally when using dmabuf, the sg_table might be
originated outside the subsystem and optimized for other needs.

For instance an SGT of 16GB GPU continuous memory might look like this:
(a real life example)

dma_address 34401400000, length fffff000
dma_address 345013ff000, length fffff000
dma_address 346013fe000, length fffff000
dma_address 347013fd000, length fffff000
dma_address 348013fc000, length 4000

Since ib_umem_find_best_pgsz works within SG entries, in the above case
we will result with the worst possible 4KB page size.

Fix this by taking into consideration only the alignment of addresses of
real discontinuity points rather than treating SG entries as such, and
adjust the page iterator to correctly handle cross SG entry pages.

There is currently an assumption that drivers do not ask for pages
bigger than maximal DMA size supported by their devices.

Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
Link: https://patch.msgid.link/20250217141623.12428-1-mrgolin@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem.c  | 36 ++++++++++++++++++++++++---------
 drivers/infiniband/core/verbs.c | 11 +++++-----
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 8ce569bf7525e..1d154055a335b 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -80,9 +80,12 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 				     unsigned long pgsz_bitmap,
 				     unsigned long virt)
 {
-	struct scatterlist *sg;
+	unsigned long curr_len = 0;
+	dma_addr_t curr_base = ~0;
 	unsigned long va, pgoff;
+	struct scatterlist *sg;
 	dma_addr_t mask;
+	dma_addr_t end;
 	int i;
 
 	umem->iova = va = virt;
@@ -107,17 +110,30 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 	pgoff = umem->address & ~PAGE_MASK;
 
 	for_each_sgtable_dma_sg(&umem->sgt_append.sgt, sg, i) {
-		/* Walk SGL and reduce max page size if VA/PA bits differ
-		 * for any address.
+		/* If the current entry is physically contiguous with the previous
+		 * one, no need to take its start addresses into consideration.
 		 */
-		mask |= (sg_dma_address(sg) + pgoff) ^ va;
+		if (check_add_overflow(curr_base, curr_len, &end) ||
+		    end != sg_dma_address(sg)) {
+
+			curr_base = sg_dma_address(sg);
+			curr_len = 0;
+
+			/* Reduce max page size if VA/PA bits differ */
+			mask |= (curr_base + pgoff) ^ va;
+
+			/* The alignment of any VA matching a discontinuity point
+			* in the physical memory sets the maximum possible page
+			* size as this must be a starting point of a new page that
+			* needs to be aligned.
+			*/
+			if (i != 0)
+				mask |= va;
+		}
+
+		curr_len += sg_dma_len(sg);
 		va += sg_dma_len(sg) - pgoff;
-		/* Except for the last entry, the ending iova alignment sets
-		 * the maximum possible page size as the low bits of the iova
-		 * must be zero when starting the next chunk.
-		 */
-		if (i != (umem->sgt_append.sgt.nents - 1))
-			mask |= va;
+
 		pgoff = 0;
 	}
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b99b3cc283b65..97a116960f317 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2959,22 +2959,23 @@ EXPORT_SYMBOL(__rdma_block_iter_start);
 bool __rdma_block_iter_next(struct ib_block_iter *biter)
 {
 	unsigned int block_offset;
-	unsigned int sg_delta;
+	unsigned int delta;
 
 	if (!biter->__sg_nents || !biter->__sg)
 		return false;
 
 	biter->__dma_addr = sg_dma_address(biter->__sg) + biter->__sg_advance;
 	block_offset = biter->__dma_addr & (BIT_ULL(biter->__pg_bit) - 1);
-	sg_delta = BIT_ULL(biter->__pg_bit) - block_offset;
+	delta = BIT_ULL(biter->__pg_bit) - block_offset;
 
-	if (sg_dma_len(biter->__sg) - biter->__sg_advance > sg_delta) {
-		biter->__sg_advance += sg_delta;
-	} else {
+	while (biter->__sg_nents && biter->__sg &&
+	       sg_dma_len(biter->__sg) - biter->__sg_advance <= delta) {
+		delta -= sg_dma_len(biter->__sg) - biter->__sg_advance;
 		biter->__sg_advance = 0;
 		biter->__sg = sg_next(biter->__sg);
 		biter->__sg_nents--;
 	}
+	biter->__sg_advance += delta;
 
 	return true;
 }
-- 
2.39.5



