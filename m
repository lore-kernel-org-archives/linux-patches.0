Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E741F7545;
	Tue,  3 Dec 2024 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238851; cv=none; b=JiiVfw1g/VGqG+bQw/14y2ch2Ua9Xc6T102yVhE3FkTYX2/6Ngzo51jQtcibUgcaB1kAjyPzKu7uVSr9wGqJS7hLnAHnt+wWcnYu3GyCL5QJPdcyXttwYcl3udVibpLXqXZ/wzAkx9dq6ATw4fJNpeyupwJPKfrCNSuPrh1Onvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238851; c=relaxed/simple;
	bh=Rk6spVUrNA4T/YakNZ/5VzWzPcmbpetTvxq8vy7GyoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rghz5521BJf3Q7RnZOqwyy5bbbb61Ojhk2TWbDDRzJbUhMlaHFyFhJAvIeOnET8w0olcJXqJCS3ORMzMZIFjTH+vCiAf5vufSiXpYjO07E7olfw88nWi/BqZgrwhdD3cUoEStR7uIPV50dvVTYZRxKLfXz7BGCwdQEauiRQpujU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G962QwcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G962QwcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A17C4CECF;
	Tue,  3 Dec 2024 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238851;
	bh=Rk6spVUrNA4T/YakNZ/5VzWzPcmbpetTvxq8vy7GyoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G962QwcUrmXSG91B6qN9Iq/tVvQJAXs27z2VK+m41pEybO1OQ0hNeJuVG9ne8Ftxv
	 LQwZvhGJhmI2dVHdTZMGXnMsh9sERihIxWkVJMiqWjVBfdOBvXcoaiVfhC6bEMT9vL
	 yxQdBFPTld31uGjEOKKSso/aVWW4uxAWiEgpUX2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 419/817] RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey
Date: Tue,  3 Dec 2024 15:39:51 +0100
Message-ID: <20241203144012.235108418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 982e85ba211bc..1ec7c563a5e59 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3584,7 +3584,7 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *gsi_sqp,
 	wc->byte_len = orig_cqe->length;
 	wc->qp = &gsi_qp->ib_qp;
 
-	wc->ex.imm_data = cpu_to_be32(le32_to_cpu(orig_cqe->immdata));
+	wc->ex.imm_data = cpu_to_be32(orig_cqe->immdata);
 	wc->src_qp = orig_cqe->src_qp;
 	memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
 	if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
@@ -3729,7 +3729,10 @@ int bnxt_re_poll_cq(struct ib_cq *ib_cq, int num_entries, struct ib_wc *wc)
 				 (unsigned long)(cqe->qp_handle),
 				 struct bnxt_re_qp, qplib_qp);
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
index 389862df818d9..010b07e87acb8 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -390,7 +390,7 @@ struct bnxt_qplib_cqe {
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



