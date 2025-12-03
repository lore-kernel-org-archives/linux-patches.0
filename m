Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E247234DCE3;
	Wed,  3 Dec 2025 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777929; cv=none; b=YdNwVrhdjE3g3GkbbSOCQnG/b8uGA+jAa1dsmhvel/1RVoz+vrdby1F/s7+Isa6Jl3xiLzirSTHhRsFXlNsgdunEcos7bTzI8fBo6Z7yVnANE3V09O9k01MUaW9W69DdZn+koKsJ5/BgqJh18DMNaycqvpVUVpfiZpNqGKEffg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777929; c=relaxed/simple;
	bh=KSb00PrHiBfh230qWuO38Tt8RynAkrrK3QzAkCrFnhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fuu5UnxQ6+NucRqJ9+PySKerxAiscXjamELZx6xj1SMYibVBSs2O98sMPfr+Erw++bhbe70LnXE1OL+JZzDxe1e6gs64JQoU5JRXKK3b3TOnXYy/E4P71HA5h5B9wu52rDFzN6RBKMnZVM/4NHjG0RZx+VMDepG2KnLMXu4gL+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fueiRsWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fueiRsWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60159C4CEF5;
	Wed,  3 Dec 2025 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777928;
	bh=KSb00PrHiBfh230qWuO38Tt8RynAkrrK3QzAkCrFnhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fueiRsWMr5HMSkYWQgfBrZsNfhplcdOVgr56rBXzd+vA5VSMQjDgziFRerRdsKMyH
	 W7/NJ6vdYLCASLXB34ENe6DzOB0DJG8ncApFcmhszatE1yT7Dgo7nRxCJulPF66ZiV
	 VHUdAstXcGW/kMXnA2ouYPz+4s1u6AlZ22zlOv5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/392] RDMA/hns: Fix wrong WQE data when QP wraps around
Date: Wed,  3 Dec 2025 16:25:40 +0100
Message-ID: <20251203152421.068895227@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 74f48e201031d..8baf6fb2d1fa5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -125,6 +125,8 @@ static void set_frmr_seg(struct hns_roce_v2_rc_send_wqe *rc_sq_wqe,
 	hr_reg_write(fseg, FRMR_PBL_BUF_PG_SZ,
 		     to_hr_hw_page_shift(mr->pbl_mtr.hem_cfg.buf_pg_shift));
 	hr_reg_clear(fseg, FRMR_BLK_MODE);
+	hr_reg_clear(fseg, FRMR_BLOCK_SIZE);
+	hr_reg_clear(fseg, FRMR_ZBVA);
 }
 
 static void set_atomic_seg(const struct ib_send_wr *wr,
@@ -309,9 +311,6 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	int j = 0;
 	int i;
 
-	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_MSG_START_SGE_IDX,
-		     (*sge_ind) & (qp->sge.sge_cnt - 1));
-
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_INLINE,
 		     !!(wr->send_flags & IB_SEND_INLINE));
 	if (wr->send_flags & IB_SEND_INLINE)
@@ -574,6 +573,9 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_CQE,
 		     (wr->send_flags & IB_SEND_SIGNALED) ? 1 : 0);
 
+	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_MSG_START_SGE_IDX,
+		     curr_idx & (qp->sge.sge_cnt - 1));
+
 	if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
 	    wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD)
 		set_atomic_seg(wr, rc_sq_wqe, valid_num_sge);
@@ -717,6 +719,9 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
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



