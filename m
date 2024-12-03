Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4413D1F4711;
	Tue,  3 Dec 2024 14:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236612; cv=none; b=rFPCgfVUaJluKk1quUgEOWmnZoT00n3pY1eeG5zp9CPhBrhUKe4318zAXLUxdgMefj93wXYHu6VWACCGvbBGv994bMIVUrYuUUK2mm1w1mX6wL3BdARMA000zPB+legw7Z3ODqysqKHScxcmF8itx7ZiatMJShuwk8LitX1QEPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236612; c=relaxed/simple;
	bh=0qxcbxSd0yd9XYvPtKKm7t2vaHeJl8KANkIqEOzsHIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKZumwADUqoF4I5TfFVScmyLBpHGub3SaZN4WeaBzzLt81Rz+huTEik4/YPQiBAB4oI8a6qyJ/tN1ObJ3eZJwxmpLOjWyPEyN/rJu8SEtFoMOJC9cMjMBeGvKVqcATRoZkSMwEpspnVeUiaixm5PMXpA9+cwtUqMi5ccpP+FYwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmXgq9Nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmXgq9Nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDF5C4CECF;
	Tue,  3 Dec 2024 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236611;
	bh=0qxcbxSd0yd9XYvPtKKm7t2vaHeJl8KANkIqEOzsHIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmXgq9NfAd1YISfIsnc2skcowYjJjlNzE0wGfvKEATGzsIn/NwCG5fXQFr7wCjCz/
	 SEL3gSLU4fvroV71D85LUiQDFcQ8arIQxYYca+QBhDCV0Kv68liWqj6GpujqlRKcvs
	 e0IAcZN5T9sQ2iOk0Ego74eiBtpQoQCzVwD8HcqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/138] RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey
Date: Tue,  3 Dec 2024 15:31:32 +0100
Message-ID: <20241203141925.970229193@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e2c93a50fe762..9b6ebf6356983 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3110,7 +3110,7 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
 	wc->byte_len = orig_cqe->length;
 	wc->qp = &qp1_qp->ib_qp;
 
-	wc->ex.imm_data = cpu_to_be32(le32_to_cpu(orig_cqe->immdata));
+	wc->ex.imm_data = cpu_to_be32(orig_cqe->immdata);
 	wc->src_qp = orig_cqe->src_qp;
 	memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
 	if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
@@ -3231,7 +3231,10 @@ int bnxt_re_poll_cq(struct ib_cq *ib_cq, int num_entries, struct ib_wc *wc)
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
index aed0c53d84be2..6c0129231c07b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -349,7 +349,7 @@ struct bnxt_qplib_cqe {
 	u32				length;
 	u64				wr_id;
 	union {
-		__le32			immdata;
+		u32			immdata;
 		u32			invrkey;
 	};
 	u64				qp_handle;
-- 
2.43.0



