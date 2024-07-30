Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7E41A6166;
	Tue, 30 Jul 2024 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358016; cv=none; b=U5j+1yiUSXhHawU//tlzc7Q8piRaY0ogyEi1aR1HhEq9C37b/o2MDTrava+a3Mo0teh6XS7U/HE0Ur5XNo/3hLlR4ZuOMulE7tdcVmeTDDcBnmREtVgBr2HZnFzgQh+SjlWrJZvigCPQ3qkRhEDXIFnvGOvIcnQpmV3ydIJcfXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358016; c=relaxed/simple;
	bh=BDD+BZgG/nU0BV+dkxd7lmFd1+51en0ZX8/Pp4lf4TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tArazARjvDfbT5f19Z3MNEtZ5OMf7yppd/OsAIorkQC7MiqmHbrYjwtteaiWnpFm64oiGzu0ZUedjkADqqIr9J4y6a9TxdcmjsMnT0oHHlV2QIZ3asy7QAuzBU5vZyUPlNMerYnGTUkO7NkEARRa0HkE5BTVOlsJqX6W/b+HIWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtwhiP8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtwhiP8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9AAC32782;
	Tue, 30 Jul 2024 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358015;
	bh=BDD+BZgG/nU0BV+dkxd7lmFd1+51en0ZX8/Pp4lf4TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtwhiP8ffKYw8DUSSqYzw9DY7KPXkEmd179ts9ph5Ql60Tbk/OyUUwcDDstCcmj4B
	 xTlGr5wkGZFBRvp63+2XjeMNMJoAcsFYwD4W2NRonZUeA4ajurJgIaNxnINvqZAqL0
	 WD5FlnA7z6mGQDV0CJ714F3FGWAPUJJVJyDuy6dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/568] bnxt_re: Fix imm_data endianness
Date: Tue, 30 Jul 2024 17:46:55 +0200
Message-ID: <20240730151651.911890037@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 95b087f87b780daafad1dbb2c84e81b729d5d33f ]

When map a device between servers with MLX and BCM RoCE nics, RTRS
server complain about unknown imm type, and can't map the device,

After more debug, it seems bnxt_re wrongly handle the
imm_data, this patch fixed the compat issue with MLX for us.

In off list discussion, Selvin confirmed HW is working in little endian format
and all data needs to be converted to LE while providing.

This patch fix the endianness for imm_data

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/20240710122102.37569-1-jinpu.wang@ionos.com
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
 drivers/infiniband/hw/bnxt_re/qplib_fp.h | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index fd69be982ce06..b4d3e7dfc939f 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2467,7 +2467,7 @@ static int bnxt_re_build_send_wqe(struct bnxt_re_qp *qp,
 		break;
 	case IB_WR_SEND_WITH_IMM:
 		wqe->type = BNXT_QPLIB_SWQE_TYPE_SEND_WITH_IMM;
-		wqe->send.imm_data = wr->ex.imm_data;
+		wqe->send.imm_data = be32_to_cpu(wr->ex.imm_data);
 		break;
 	case IB_WR_SEND_WITH_INV:
 		wqe->type = BNXT_QPLIB_SWQE_TYPE_SEND_WITH_INV;
@@ -2497,7 +2497,7 @@ static int bnxt_re_build_rdma_wqe(const struct ib_send_wr *wr,
 		break;
 	case IB_WR_RDMA_WRITE_WITH_IMM:
 		wqe->type = BNXT_QPLIB_SWQE_TYPE_RDMA_WRITE_WITH_IMM;
-		wqe->rdma.imm_data = wr->ex.imm_data;
+		wqe->rdma.imm_data = be32_to_cpu(wr->ex.imm_data);
 		break;
 	case IB_WR_RDMA_READ:
 		wqe->type = BNXT_QPLIB_SWQE_TYPE_RDMA_READ;
@@ -3545,7 +3545,7 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *gsi_sqp,
 	wc->byte_len = orig_cqe->length;
 	wc->qp = &gsi_qp->ib_qp;
 
-	wc->ex.imm_data = orig_cqe->immdata;
+	wc->ex.imm_data = cpu_to_be32(le32_to_cpu(orig_cqe->immdata));
 	wc->src_qp = orig_cqe->src_qp;
 	memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
 	if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
@@ -3690,7 +3690,7 @@ int bnxt_re_poll_cq(struct ib_cq *ib_cq, int num_entries, struct ib_wc *wc)
 				 (unsigned long)(cqe->qp_handle),
 				 struct bnxt_re_qp, qplib_qp);
 			wc->qp = &qp->ib_qp;
-			wc->ex.imm_data = cqe->immdata;
+			wc->ex.imm_data = cpu_to_be32(le32_to_cpu(cqe->immdata));
 			wc->src_qp = cqe->src_qp;
 			memcpy(wc->smac, cqe->smac, ETH_ALEN);
 			wc->port_num = 1;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 113be429f0aac..a6f38d8f12efe 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -164,7 +164,7 @@ struct bnxt_qplib_swqe {
 		/* Send, with imm, inval key */
 		struct {
 			union {
-				__be32	imm_data;
+				u32	imm_data;
 				u32	inv_key;
 			};
 			u32		q_key;
@@ -182,7 +182,7 @@ struct bnxt_qplib_swqe {
 		/* RDMA write, with imm, read */
 		struct {
 			union {
-				__be32	imm_data;
+				u32	imm_data;
 				u32	inv_key;
 			};
 			u64		remote_va;
@@ -389,7 +389,7 @@ struct bnxt_qplib_cqe {
 	u16				cfa_meta;
 	u64				wr_id;
 	union {
-		__be32			immdata;
+		__le32			immdata;
 		u32			invrkey;
 	};
 	u64				qp_handle;
-- 
2.43.0



