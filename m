Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6224FBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8804C433D2;
	Tue,  7 Mar 2023 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210539;
	bh=dfx7WlhRyvmaTgFrGn55IsFod+CXcvHbiv8UIwl9W14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LL8wtx4JYiyC9AyRQHEVI6bWf4YQYkxv+l5RfA3+9ZmP9vI2htnWs8thR+839fE9F
	 9Lvck9LxnAPU9AozIUSAyJfRchEngGth2HouPyK5kdnXbYVkpBIsHmSz1g2AWzDwoh
	 KNOGQe+xCl1q8EZpWneWGf+d4OySLjA754Fs7/i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0574/1001] RDMA/rxe: Cleanup page variables in rxe_mr.c
Date: Tue,  7 Mar 2023 17:55:46 +0100
Message-Id: <20230307170046.372539055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 325a7eb85199ec9c5b5a7af812f43ea16b735569 ]

Cleanup usage of mr->page_shift and mr->page_mask and introduce
an extractor for mr->ibmr.page_size. Normal usage in the kernel
has page_mask masking out offset in page rather than masking out
the page number. The rxe driver had reversed that which was confusing.
Implicitly there can be a per mr page_size which was not uniformly
supported.

Link: https://lore.kernel.org/r/20230119235936.19728-6-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 5ff31dfcd6d2 ("Subject: RDMA/rxe: Handle zero length rdma")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c    | 31 ++++++++++++---------------
 drivers/infiniband/sw/rxe/rxe_verbs.h | 11 +++++++---
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 5c4ce43914fa2..2181165ea40d7 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -62,6 +62,9 @@ static void rxe_mr_init(int access, struct rxe_mr *mr)
 	mr->lkey = mr->ibmr.lkey = lkey;
 	mr->rkey = mr->ibmr.rkey = rkey;
 
+	mr->ibmr.page_size = PAGE_SIZE;
+	mr->page_mask = PAGE_MASK;
+	mr->page_shift = PAGE_SHIFT;
 	mr->state = RXE_MR_STATE_INVALID;
 }
 
@@ -151,9 +154,6 @@ int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 		goto err_release_umem;
 	}
 
-	mr->page_shift = PAGE_SHIFT;
-	mr->page_mask = PAGE_SIZE - 1;
-
 	num_buf			= 0;
 	map = mr->map;
 	if (length > 0) {
@@ -182,7 +182,7 @@ int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 				goto err_release_umem;
 			}
 			buf->addr = (uintptr_t)vaddr;
-			buf->size = PAGE_SIZE;
+			buf->size = mr_page_size(mr);
 			num_buf++;
 			buf++;
 
@@ -191,10 +191,9 @@ int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 
 	mr->umem = umem;
 	mr->access = access;
-	mr->offset = ib_umem_offset(umem);
+	mr->page_offset = ib_umem_offset(umem);
 	mr->state = RXE_MR_STATE_VALID;
 	mr->ibmr.type = IB_MR_TYPE_USER;
-	mr->ibmr.page_size = PAGE_SIZE;
 
 	return 0;
 
@@ -248,29 +247,27 @@ int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset)
 {
 	struct rxe_mr *mr = to_rmr(ibmr);
-	int n;
-
-	mr->nbuf = 0;
+	unsigned int page_size = mr_page_size(mr);
 
-	n = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, rxe_set_page);
+	mr->page_shift = ilog2(page_size);
+	mr->page_mask = ~((u64)page_size - 1);
+	mr->page_offset = ibmr->iova & (page_size - 1);
 
-	mr->page_shift = ilog2(ibmr->page_size);
-	mr->page_mask = ibmr->page_size - 1;
-	mr->offset = ibmr->iova & mr->page_mask;
+	mr->nbuf = 0;
 
-	return n;
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, rxe_set_page);
 }
 
 static void lookup_iova(struct rxe_mr *mr, u64 iova, int *m_out, int *n_out,
 			size_t *offset_out)
 {
-	size_t offset = iova - mr->ibmr.iova + mr->offset;
+	size_t offset = iova - mr->ibmr.iova + mr->page_offset;
 	int			map_index;
 	int			buf_index;
 	u64			length;
 
 	if (likely(mr->page_shift)) {
-		*offset_out = offset & mr->page_mask;
+		*offset_out = offset & (mr_page_size(mr) - 1);
 		offset >>= mr->page_shift;
 		*n_out = offset & mr->map_mask;
 		*m_out = offset >> mr->map_shift;
@@ -329,7 +326,7 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, int length)
 	if (mr->ibmr.type == IB_MR_TYPE_DMA)
 		return -EFAULT;
 
-	offset = (iova - mr->ibmr.iova + mr->offset) & mr->page_mask;
+	offset = (iova - mr->ibmr.iova + mr->page_offset) & mr->page_mask;
 	while (length > 0) {
 		u8 *va;
 		int bytes;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 19ddfa8904803..bfc94caaeec57 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -310,11 +310,11 @@ struct rxe_mr {
 	u32			lkey;
 	u32			rkey;
 	enum rxe_mr_state	state;
-	u32			offset;
 	int			access;
 
-	int			page_shift;
-	int			page_mask;
+	unsigned int		page_offset;
+	unsigned int		page_shift;
+	u64			page_mask;
 	int			map_shift;
 	int			map_mask;
 
@@ -329,6 +329,11 @@ struct rxe_mr {
 	struct rxe_map		**map;
 };
 
+static inline unsigned int mr_page_size(struct rxe_mr *mr)
+{
+	return mr ? mr->ibmr.page_size : PAGE_SIZE;
+}
+
 enum rxe_mw_state {
 	RXE_MW_STATE_INVALID	= RXE_MR_STATE_INVALID,
 	RXE_MW_STATE_FREE	= RXE_MR_STATE_FREE,
-- 
2.39.2



