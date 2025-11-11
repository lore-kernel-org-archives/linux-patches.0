Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B48DDAB;
	Tue, 11 Nov 2025 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825170; cv=none; b=Fl5NCPwZaknE9vfJDan3DaKCeTvRkp5XjSEY+Sk2R+Obf2DiVUrdCrM4TM9phG78hfBTsDW8p/DsvNbfx/nXqy9P2zPM3asIpInPUToCw7+prICe/gfBaXbmU2PY/8nA7snXJK1IidpUU+HrvZK9d0kuixR9YGs3bTfNJW63kug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825170; c=relaxed/simple;
	bh=3wv6A0zYKIcQxMtwEvr8fSXxLznafJr5F4CHJcrcyyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sme6K2z4qoUHSies4NYWX7IbbTENzfBo8OEiVNo3YhTbPeyM5+Dk3bfxnfo5JKTDE0HcJEPQsarZlJgiqC7XjE08IL0hiWKCPsiplgT6S6uagRsoOio5du2yFc/cEqOXTWLO9jlT8m8Me3UAcdFRfM6n8adZm+161ahB+OJhLtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOD5OQt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOD5OQt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8C5C4CEF5;
	Tue, 11 Nov 2025 01:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825170;
	bh=3wv6A0zYKIcQxMtwEvr8fSXxLznafJr5F4CHJcrcyyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOD5OQt9Y7cy1xhMJybHlJ4aUVl8zEqmt0y5dlzJN+jVhQ3BqjGChOIoggrYvKd9K
	 w89iKBd0YcjZCdqIvVlxB5RNlV/J76m6POFKin8P5r15rdA+6XC2GL3pv+d/SnxyKE
	 lA3tyoWoVUINyO+1RP5M6JFmO5tBM+rlVZeufm08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 690/849] RDMA/hns: Fix wrong WQE data when QP wraps around
Date: Tue, 11 Nov 2025 09:44:20 +0900
Message-ID: <20251111004553.111575662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f82bdd46a9174..ab378525b296a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -165,6 +165,8 @@ static void set_frmr_seg(struct hns_roce_v2_rc_send_wqe *rc_sq_wqe,
 	hr_reg_write(fseg, FRMR_PBL_BUF_PG_SZ,
 		     to_hr_hw_page_shift(mr->pbl_mtr.hem_cfg.buf_pg_shift));
 	hr_reg_clear(fseg, FRMR_BLK_MODE);
+	hr_reg_clear(fseg, FRMR_BLOCK_SIZE);
+	hr_reg_clear(fseg, FRMR_ZBVA);
 }
 
 static void set_atomic_seg(const struct ib_send_wr *wr,
@@ -339,9 +341,6 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	int j = 0;
 	int i;
 
-	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_MSG_START_SGE_IDX,
-		     (*sge_ind) & (qp->sge.sge_cnt - 1));
-
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_INLINE,
 		     !!(wr->send_flags & IB_SEND_INLINE));
 	if (wr->send_flags & IB_SEND_INLINE)
@@ -586,6 +585,9 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_CQE,
 		     (wr->send_flags & IB_SEND_SIGNALED) ? 1 : 0);
 
+	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_MSG_START_SGE_IDX,
+		     curr_idx & (qp->sge.sge_cnt - 1));
+
 	if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
 	    wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD) {
 		if (msg_len != ATOMIC_WR_LEN)
@@ -734,6 +736,9 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
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



