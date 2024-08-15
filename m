Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2851714A1;
	Thu, 15 Aug 2024 13:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729578; cv=none; b=UdheVyDsTzd07CizJYzEE90Rns7FTw2aC219FJsrCQkzYq21nooQccSGDhIhWvJsABmRdn1fYMZTW4LeGEUSRtcV7Ooin0S+R3HlhHk9Eraf6otlZqAV8u5mjH5SOVtL58gmGtV33CxcIeCGO17Txgi1OS0xIs2k1I9LrGS0Wko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729578; c=relaxed/simple;
	bh=xvgdvjqaXS2a898TumaasEcyc3GDuxQomLSzw2LLk9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcSFuFHdc6fq26Lv9YXZKt7sA30elgYApawQywJ8xzF6TW/eQcqgT9s3RT1/FjW1l3lA+wkNvemDFhv1VOjZh7A7zyaZu+i56tgYBOP6p3MpUaINx8BcjV2PEMiaKJZu1KWVdsX4hs9U+kUvKtO/6UB7Spw0jg9GcdIjQh0zBkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXzu1drZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXzu1drZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24320C32786;
	Thu, 15 Aug 2024 13:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729578;
	bh=xvgdvjqaXS2a898TumaasEcyc3GDuxQomLSzw2LLk9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXzu1drZg7O7RU8ZIzzu5Tabq4BKVrDs+0jOCSaGuY/YsBtCiY4YS5wemPabSy6C4
	 z8ozfrcb3yeYt0MaTQqtiQ/oXzPrZty4jZR3aXl4PbPbRARvWA7SvXVcuJQKuDj7a3
	 egxrHqyq9KPjG2smY587/jZdEogOF33sTOE9SkUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/484] bnxt_re: Fix imm_data endianness
Date: Thu, 15 Aug 2024 15:20:01 +0200
Message-ID: <20240815131946.941902823@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 91b71fa3c1216..e29894197f5ca 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2354,7 +2354,7 @@ static int bnxt_re_build_send_wqe(struct bnxt_re_qp *qp,
 		break;
 	case IB_WR_SEND_WITH_IMM:
 		wqe->type = BNXT_QPLIB_SWQE_TYPE_SEND_WITH_IMM;
-		wqe->send.imm_data = wr->ex.imm_data;
+		wqe->send.imm_data = be32_to_cpu(wr->ex.imm_data);
 		break;
 	case IB_WR_SEND_WITH_INV:
 		wqe->type = BNXT_QPLIB_SWQE_TYPE_SEND_WITH_INV;
@@ -2384,7 +2384,7 @@ static int bnxt_re_build_rdma_wqe(const struct ib_send_wr *wr,
 		break;
 	case IB_WR_RDMA_WRITE_WITH_IMM:
 		wqe->type = BNXT_QPLIB_SWQE_TYPE_RDMA_WRITE_WITH_IMM;
-		wqe->rdma.imm_data = wr->ex.imm_data;
+		wqe->rdma.imm_data = be32_to_cpu(wr->ex.imm_data);
 		break;
 	case IB_WR_RDMA_READ:
 		wqe->type = BNXT_QPLIB_SWQE_TYPE_RDMA_READ;
@@ -3334,7 +3334,7 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *gsi_sqp,
 	wc->byte_len = orig_cqe->length;
 	wc->qp = &gsi_qp->ib_qp;
 
-	wc->ex.imm_data = orig_cqe->immdata;
+	wc->ex.imm_data = cpu_to_be32(le32_to_cpu(orig_cqe->immdata));
 	wc->src_qp = orig_cqe->src_qp;
 	memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
 	if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
@@ -3470,7 +3470,7 @@ int bnxt_re_poll_cq(struct ib_cq *ib_cq, int num_entries, struct ib_wc *wc)
 				 (unsigned long)(cqe->qp_handle),
 				 struct bnxt_re_qp, qplib_qp);
 			wc->qp = &qp->ib_qp;
-			wc->ex.imm_data = cqe->immdata;
+			wc->ex.imm_data = cpu_to_be32(le32_to_cpu(cqe->immdata));
 			wc->src_qp = cqe->src_qp;
 			memcpy(wc->smac, cqe->smac, ETH_ALEN);
 			wc->port_num = 1;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 49d89c0808275..4f1a845f9be6c 100644
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
@@ -374,7 +374,7 @@ struct bnxt_qplib_cqe {
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



