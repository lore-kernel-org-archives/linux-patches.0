Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3863A168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EE3C433D2;
	Mon,  8 May 2023 10:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540774;
	bh=QRnbVwcM0vq8ZCUmBIGMo5176VAR7brSwNwNpGwwY5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUXqPNMSWygx2VPpJ0fVxfopH5C/bfS1oqZJgGqCozfXK5ZYd3V4hmI1W/ICxEYi+
	 nDGsWPkFCmeSfb9ZzC7uzkyiwBfMn4EyR/Nkzw9gK/prEuXWZG7MUUtm6/IzeYmH30
	 h1innhG8hsPhzuanSJXDwDUIJOfifqhfO9eur/vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 485/611] RDMA/erdma: Use fixed hardware page size
Date: Mon,  8 May 2023 11:45:27 +0200
Message-Id: <20230508094437.839392244@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit d649c638dc26f3501da510cf7fceb5c15ca54258 ]

Hardware's page size is 4096, but the kernel's page size may vary. Driver
should use hardware's page size when communicating with hardware.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Link: https://lore.kernel.org/r/20230307102924.70577-2-chengyou@linux.alibaba.com
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_hw.h    |  4 ++++
 drivers/infiniband/hw/erdma/erdma_verbs.c | 17 +++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_hw.h b/drivers/infiniband/hw/erdma/erdma_hw.h
index c533c693e5e38..2eb41e6d94c4f 100644
--- a/drivers/infiniband/hw/erdma/erdma_hw.h
+++ b/drivers/infiniband/hw/erdma/erdma_hw.h
@@ -112,6 +112,10 @@
 
 #define ERDMA_PAGE_SIZE_SUPPORT 0x7FFFF000
 
+/* Hardware page size definition */
+#define ERDMA_HW_PAGE_SHIFT 12
+#define ERDMA_HW_PAGE_SIZE 4096
+
 /* WQE related. */
 #define EQE_SIZE 16
 #define EQE_SHIFT 4
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 19c69ea1b0c0f..654d8513873ec 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -38,7 +38,7 @@ static int create_qp_cmd(struct erdma_dev *dev, struct erdma_qp *qp)
 		   FIELD_PREP(ERDMA_CMD_CREATE_QP_PD_MASK, pd->pdn);
 
 	if (rdma_is_kernel_res(&qp->ibqp.res)) {
-		u32 pgsz_range = ilog2(SZ_1M) - PAGE_SHIFT;
+		u32 pgsz_range = ilog2(SZ_1M) - ERDMA_HW_PAGE_SHIFT;
 
 		req.sq_cqn_mtt_cfg =
 			FIELD_PREP(ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
@@ -66,13 +66,13 @@ static int create_qp_cmd(struct erdma_dev *dev, struct erdma_qp *qp)
 		user_qp = &qp->user_qp;
 		req.sq_cqn_mtt_cfg = FIELD_PREP(
 			ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
-			ilog2(user_qp->sq_mtt.page_size) - PAGE_SHIFT);
+			ilog2(user_qp->sq_mtt.page_size) - ERDMA_HW_PAGE_SHIFT);
 		req.sq_cqn_mtt_cfg |=
 			FIELD_PREP(ERDMA_CMD_CREATE_QP_CQN_MASK, qp->scq->cqn);
 
 		req.rq_cqn_mtt_cfg = FIELD_PREP(
 			ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
-			ilog2(user_qp->rq_mtt.page_size) - PAGE_SHIFT);
+			ilog2(user_qp->rq_mtt.page_size) - ERDMA_HW_PAGE_SHIFT);
 		req.rq_cqn_mtt_cfg |=
 			FIELD_PREP(ERDMA_CMD_CREATE_QP_CQN_MASK, qp->rcq->cqn);
 
@@ -163,7 +163,7 @@ static int create_cq_cmd(struct erdma_dev *dev, struct erdma_cq *cq)
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
 		page_size = SZ_32M;
 		req.cfg0 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_PAGESIZE_MASK,
-				       ilog2(page_size) - PAGE_SHIFT);
+				       ilog2(page_size) - ERDMA_HW_PAGE_SHIFT);
 		req.qbuf_addr_l = lower_32_bits(cq->kern_cq.qbuf_dma_addr);
 		req.qbuf_addr_h = upper_32_bits(cq->kern_cq.qbuf_dma_addr);
 
@@ -176,8 +176,9 @@ static int create_cq_cmd(struct erdma_dev *dev, struct erdma_cq *cq)
 			cq->kern_cq.qbuf_dma_addr + (cq->depth << CQE_SHIFT);
 	} else {
 		mtt = &cq->user_cq.qbuf_mtt;
-		req.cfg0 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_PAGESIZE_MASK,
-				       ilog2(mtt->page_size) - PAGE_SHIFT);
+		req.cfg0 |=
+			FIELD_PREP(ERDMA_CMD_CREATE_CQ_PAGESIZE_MASK,
+				   ilog2(mtt->page_size) - ERDMA_HW_PAGE_SHIFT);
 		if (mtt->mtt_nents == 1) {
 			req.qbuf_addr_l = lower_32_bits(*(u64 *)mtt->mtt_buf);
 			req.qbuf_addr_h = upper_32_bits(*(u64 *)mtt->mtt_buf);
@@ -618,7 +619,7 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
 	u32 rq_offset;
 	int ret;
 
-	if (len < (PAGE_ALIGN(qp->attrs.sq_size * SQEBB_SIZE) +
+	if (len < (ALIGN(qp->attrs.sq_size * SQEBB_SIZE, ERDMA_HW_PAGE_SIZE) +
 		   qp->attrs.rq_size * RQE_SIZE))
 		return -EINVAL;
 
@@ -628,7 +629,7 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
 	if (ret)
 		return ret;
 
-	rq_offset = PAGE_ALIGN(qp->attrs.sq_size << SQEBB_SHIFT);
+	rq_offset = ALIGN(qp->attrs.sq_size << SQEBB_SHIFT, ERDMA_HW_PAGE_SIZE);
 	qp->user_qp.rq_offset = rq_offset;
 
 	ret = get_mtt_entries(qp->dev, &qp->user_qp.rq_mtt, va + rq_offset,
-- 
2.39.2



