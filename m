Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4134218F2FD;
	Mon, 28 Oct 2024 06:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098025; cv=none; b=omvbj5X1tuq+CDnwY14olb0D2CxXgfFk5xYyFZY8H/sfgNuvBMSCabLY7PQceq9zHhUKV1KbNTk/Eu5ezt/LP46RVLoV8Z1PbKVbT5ctv3BIMQlLDmYMU1n+ewYJm3L2HdaIdTHbuFtdC4uLOr+By0uWzHcYZ02zfN7M0MGR24E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098025; c=relaxed/simple;
	bh=+2i9M0tDD1+Wa6mtzu4fhOC7KtXOr4O1VWS1MeBSaXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYS1iABV7vvX3IL/Zto+jnbyQOW1DXMCs+n9mOp9G8HwTIxBqQbRXGJ+QhdZmU20zK3O1rbmn/oTTpnBTH5UYtHDvhhhCKStjjvpDkDNo9+3bE6rWclfzSxCdgWz2He1xgVfxM/i74AVcNsWcJtUu4veQWQMe+rdQtNj0tujKDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWAzF8+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWAzF8+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F53C4CEC3;
	Mon, 28 Oct 2024 06:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098025;
	bh=+2i9M0tDD1+Wa6mtzu4fhOC7KtXOr4O1VWS1MeBSaXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWAzF8+WjkwUVHsSzyYUL5MmRcujeO7sJUPceuQUArgW7xEGeMdmPcZODkkMlbLqv
	 FZaeRUkdw52BxzwvMdeLiiQyIh8ejSV59Awa1XpXsyDDZZXhrpxeYr26TKcWfiBVHH
	 PTraPU9Ls/JznTCIVtTx8VbDoV4esN09zIGFYPYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 044/261] RDMA/bnxt_re: Get the toggle bits from SRQ events
Date: Mon, 28 Oct 2024 07:23:06 +0100
Message-ID: <20241028062313.113715935@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Hongguang Gao <hongguang.gao@broadcom.com>

[ Upstream commit 640c2cf84e1de62e6bb0738dc2128d5506e7e5bc ]

SRQ arming requires the toggle bits received from hardware.
Get the toggle bits from SRQ notification for the
gen p7 adapters. This value will be zero for the older adapters.

Signed-off-by: Hongguang Gao <hongguang.gao@broadcom.com>
Signed-off-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1724945645-14989-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 2df411353dac ("RDMA/bnxt_re: Change the sequence of updating the CQ toggle value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  1 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 11 +++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.h |  1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index e98cb17173385..b368916a5bcfc 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -77,6 +77,7 @@ struct bnxt_re_srq {
 	struct bnxt_qplib_srq	qplib_srq;
 	struct ib_umem		*umem;
 	spinlock_t		lock;		/* protect srq */
+	void			*uctx_srq_page;
 };
 
 struct bnxt_re_qp {
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 49e4a4a50bfae..19bb45329a19b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -54,6 +54,10 @@
 #include "qplib_rcfw.h"
 #include "qplib_sp.h"
 #include "qplib_fp.h"
+#include <rdma/ib_addr.h>
+#include "bnxt_ulp.h"
+#include "bnxt_re.h"
+#include "ib_verbs.h"
 
 static void __clean_cq(struct bnxt_qplib_cq *cq, u64 qp);
 
@@ -347,6 +351,7 @@ static void bnxt_qplib_service_nq(struct tasklet_struct *t)
 		case NQ_BASE_TYPE_SRQ_EVENT:
 		{
 			struct bnxt_qplib_srq *srq;
+			struct bnxt_re_srq *srq_p;
 			struct nq_srq_event *nqsrqe =
 						(struct nq_srq_event *)nqe;
 
@@ -354,6 +359,12 @@ static void bnxt_qplib_service_nq(struct tasklet_struct *t)
 			q_handle |= (u64)le32_to_cpu(nqsrqe->srq_handle_high)
 				     << 32;
 			srq = (struct bnxt_qplib_srq *)q_handle;
+			srq->toggle = (le16_to_cpu(nqe->info10_type) & NQ_CN_TOGGLE_MASK)
+				      >> NQ_CN_TOGGLE_SFT;
+			srq->dbinfo.toggle = srq->toggle;
+			srq_p = container_of(srq, struct bnxt_re_srq, qplib_srq);
+			if (srq_p->uctx_srq_page)
+				*((u32 *)srq_p->uctx_srq_page) = srq->toggle;
 			bnxt_qplib_armen_db(&srq->dbinfo,
 					    DBC_DBC_TYPE_SRQ_ARMENA);
 			if (nq->srqn_handler(nq,
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index c7412e461436f..389862df818d9 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -105,6 +105,7 @@ struct bnxt_qplib_srq {
 	struct bnxt_qplib_sg_info	sg_info;
 	u16				eventq_hw_ring_id;
 	spinlock_t			lock; /* protect SRQE link list */
+	u8				toggle;
 };
 
 struct bnxt_qplib_sge {
-- 
2.43.0



