Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C95327E7EB;
	Tue, 11 Nov 2025 01:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824511; cv=none; b=R1/1zh+9veb1MKn2DskGZ2Pad5pytXymE346fH7En7Nz5h4qY7HMM+hTuWE6v3qKHifZNqtwZfqloJqZOavozTnBAQsb8XYjbZNoe17UOM0YrTiPLi4sEo/2oHl3Bn0za504wttbmh3MGf3J40hDMp2EB7Vg3F52Ny97N4e3fGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824511; c=relaxed/simple;
	bh=NR19GgoEt5R5wjbBwpxCsYNmWZnPmFYBpkD6cqdUnpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la32DaMQ04GfFvOamAnPyGN33fhp9XVvrqvZw2TS3MbleKKs7nvIbQp4JW9Go+6d68g8Hea8Z1HockMcXX+vt6oV4UJYeiczcxf4Wio0Ak0QSiSN0MMUr+0BcFpd0D/F83TEokbYhFXQTEVubQFvxTG61jQzxhs1f7TB2QQRshA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWpPVtZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWpPVtZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3DBC116B1;
	Tue, 11 Nov 2025 01:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824511;
	bh=NR19GgoEt5R5wjbBwpxCsYNmWZnPmFYBpkD6cqdUnpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWpPVtZNfT+dRpFkt4nHWzCm5G0MAyYldMEs4FcBGcGY/ne8AIvXHLcnRrZwQjZmt
	 OPJbrm+TFd5gT+jYLRBNGf+mVq0fQGO3AgEcwAvYqfvL1CwbxsTv7y8xXB+VaQs3mM
	 wLD1zVv7Y7m81kiM26kicuL+sI0Ckjyd6o4y5syU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 460/565] RDMA/hns: Fix wrong WQE data when QP wraps around
Date: Tue, 11 Nov 2025 09:45:16 +0900
Message-ID: <20251111004537.245806211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit fe9622011f955e35ba84d3af7b2f2fed31cf8ca1 ]

When QP wraps around, WQE data from the previous use at the same
position still remains as driver does not clear it. The WQE field
layout differs across different opcodes, causing that the fields
that are not explicitly assigned for the current opcode retain
stale values, and are issued to HW by mistake. Such fields are as
follows:

* MSG_START_SGE_IDX field in ATOMIC WQE
* BLOCK_SIZE and ZBVA fields in FRMR WQE
* DirectWQE fields when DirectWQE not used

For ATOMIC WQE, always set the latest sge index in MSG_START_SGE_IDX
as required by HW.

For FRMR WQE and DirectWQE, clear only those unassigned fields
instead of the entire WQE to avoid performance penalty.

Fixes: 68a997c5d28c ("RDMA/hns: Add FRMR support for hip08")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20251016114051.1963197-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 6a6daca9f606c..f9356cb89497b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -162,6 +162,8 @@ static void set_frmr_seg(struct hns_roce_v2_rc_send_wqe *rc_sq_wqe,
 	hr_reg_write(fseg, FRMR_PBL_BUF_PG_SZ,
 		     to_hr_hw_page_shift(mr->pbl_mtr.hem_cfg.buf_pg_shift));
 	hr_reg_clear(fseg, FRMR_BLK_MODE);
+	hr_reg_clear(fseg, FRMR_BLOCK_SIZE);
+	hr_reg_clear(fseg, FRMR_ZBVA);
 }
 
 static void set_atomic_seg(const struct ib_send_wr *wr,
@@ -336,9 +338,6 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	int j = 0;
 	int i;
 
-	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_MSG_START_SGE_IDX,
-		     (*sge_ind) & (qp->sge.sge_cnt - 1));
-
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_INLINE,
 		     !!(wr->send_flags & IB_SEND_INLINE));
 	if (wr->send_flags & IB_SEND_INLINE)
@@ -583,6 +582,9 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_CQE,
 		     (wr->send_flags & IB_SEND_SIGNALED) ? 1 : 0);
 
+	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_MSG_START_SGE_IDX,
+		     curr_idx & (qp->sge.sge_cnt - 1));
+
 	if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
 	    wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD) {
 		if (msg_len != ATOMIC_WR_LEN)
@@ -731,6 +733,9 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 		owner_bit =
 		       ~(((qp->sq.head + nreq) >> ilog2(qp->sq.wqe_cnt)) & 0x1);
 
+		/* RC and UD share the same DirectWQE field layout */
+		((struct hns_roce_v2_rc_send_wqe *)wqe)->byte_4 = 0;
+
 		/* Corresponding to the QP type, wqe process separately */
 		if (ibqp->qp_type == IB_QPT_RC)
 			ret = set_rc_wqe(qp, wr, wqe, &sge_idx, owner_bit);
-- 
2.51.0



