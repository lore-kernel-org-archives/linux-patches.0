Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7564F20A5EE;
	Thu, 12 Dec 2024 17:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025220; cv=none; b=B23gAvbjD0A9lVhZX2HV89f+Y+SN5E2zMcBwYwYMxri6OloDmi9Y+xfvoGf3+O5lQBPVIai2DB1lgDgkgsXRAPhRTL0X8bcbbM6VB+RgaAgY5AhzRx0DctuBztuPLlszsp5ubsXB0yfmUVL480cERCtmnfEYmtV4vSur6Wc2IPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025220; c=relaxed/simple;
	bh=yWGTSweGMh8m4iGOdmyuidU9qWehICKYPaUt4sLb4EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiYArcip+5piAl0bd84hmSm+f4/hMCuojLrTxOl7MVqyoicXhny3RRyFeXkLKd1GuPVi/uk12PPFopcsEY9o15wP2U8ah97bYXyrD4lVAXxQf+gmLq5WcsHTC3/HWTRBrMJgMTdhC5e/F/L7OXYKYq7hst58JPo3FaeJzpYciVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGomdR14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGomdR14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAEDC4CECE;
	Thu, 12 Dec 2024 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025220;
	bh=yWGTSweGMh8m4iGOdmyuidU9qWehICKYPaUt4sLb4EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGomdR14MJIcaFpknkZ9hWapNQtU2D6HW/8oSPt0TNj9BchwKAhDr0TG78mC3mETn
	 ue9j4TH7WDCwZaFc97bNpGNurkRiew7GV9QedDdAkTlDc5bDOCN3g8Qwih33pEXyWz
	 8kDeFcsetrpctoGcjvF9V36C1x+J0iTnxARn1p1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/321] RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey
Date: Thu, 12 Dec 2024 16:00:14 +0100
Message-ID: <20241212144233.781895134@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 808ca6de989c598bc5af1ae0ad971a66077efac0 ]

Invalidate rkey is cpu endian and immediate data is in big endian format.
Both immediate data and invalidate the remote key returned by
HW is in little endian format.

While handling the commit in fixes tag, the difference between
immediate data and invalidate rkey endianness was not considered.

Without changes of this patch, Kernel ULP was failing while processing
inv_rkey.

dmesg log snippet -
nvme nvme0: Bogus remote invalidation for rkey 0x2000019Fix in this patch

Do endianness conversion based on completion queue entry flag.
Also, the HW completions are already converted to host endianness in
bnxt_qplib_cq_process_res_rc and bnxt_qplib_cq_process_res_ud and there
is no need to convert it again in bnxt_re_poll_cq. Modified the union to
hold the correct data type.

Fixes: 95b087f87b78 ("bnxt_re: Fix imm_data endianness")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1730110014-20755-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 7 +++++--
 drivers/infiniband/hw/bnxt_re/qplib_fp.h | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 4a1c11bdc4adc..eca36da7f9d4b 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3250,7 +3250,7 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *gsi_sqp,
 	wc->byte_len = orig_cqe->length;
 	wc->qp = &gsi_qp->ib_qp;
 
-	wc->ex.imm_data = cpu_to_be32(le32_to_cpu(orig_cqe->immdata));
+	wc->ex.imm_data = cpu_to_be32(orig_cqe->immdata);
 	wc->src_qp = orig_cqe->src_qp;
 	memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
 	if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
@@ -3391,7 +3391,10 @@ int bnxt_re_poll_cq(struct ib_cq *ib_cq, int num_entries, struct ib_wc *wc)
 				continue;
 			}
 			wc->qp = &qp->ib_qp;
-			wc->ex.imm_data = cpu_to_be32(le32_to_cpu(cqe->immdata));
+			if (cqe->flags & CQ_RES_RC_FLAGS_IMM)
+				wc->ex.imm_data = cpu_to_be32(cqe->immdata);
+			else
+				wc->ex.invalidate_rkey = cqe->invrkey;
 			wc->src_qp = cqe->src_qp;
 			memcpy(wc->smac, cqe->smac, ETH_ALEN);
 			wc->port_num = 1;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index bdc3a4f969c7e..a40f8cd8860a7 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -350,7 +350,7 @@ struct bnxt_qplib_cqe {
 	u16				cfa_meta;
 	u64				wr_id;
 	union {
-		__le32			immdata;
+		u32			immdata;
 		u32			invrkey;
 	};
 	u64				qp_handle;
-- 
2.43.0



