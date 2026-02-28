Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1373603EC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302742; cv=none; b=XWC20qSxuXpcn6rOCvYmEHtYx0i0m24ZEbaX+B3euU5Z3Fhe8D3XALS5BczewDtYeN5Tq+GeX9+79yB8FJj8ntSVvpRJHpt7Q1SI9zQzT1lWM8mx/PP0vUVxYeCUcLc9PPls3ZtBf5eaYsjh82TYj9c3wAPcyvHI8mxbOA6RRgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302742; c=relaxed/simple;
	bh=axxVuDdlUokt/6tdU1kmM8PCDU4kMaeelhNLMVgUAZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESW1imQpojE+XlEoESsJoWcLoA5oVa/S0mSkaRNOPvC98eOGGefqxq32p5BetYggSmfb2O7ouN9D7WQpzhJmyXHSvpaxi0j/qZMYdxLjpTEvsq/4tXxiQCP9iFThlkozLyTAYgRbY9kPWinsfEOmp7zfREZAtRxNQb4sNSoNOuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7c0l9RP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7c0l9RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB7BC116D0;
	Sat, 28 Feb 2026 18:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302742;
	bh=axxVuDdlUokt/6tdU1kmM8PCDU4kMaeelhNLMVgUAZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7c0l9RPkdp2R/ZkClkX0V3iePTid1sechsUN6vCSahBhMNquKvMA7D87/Q3BD3io
	 pdAnHL7Juek/APDZCJEG5ZM4TewO7CwmhbEzN5c1YU8OmdC4t6ell2LcR4AtkOpWel
	 sVCB1hmMzD8ZKwO17jfs+hWzQ39pzBmN/V551lty4A0NuOK/VYoIfC2dRUMdiz38Zd
	 8q4sb44KW43e629LCcmiUUwXnTSBdP5MgeJEr9hlW6MCy3my3YijdL5IyKxroF/ipP
	 3lN8UVw/n3xVEHk7lHSkgZj8eOFaHG9DY7ASGBDhSUkowbBab3EpSPYny9hhWVJLWJ
	 l5UKsDSdxCJLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/147] RDMA/core: add rdma_rw_max_sge() helper for SQ sizing
Date: Sat, 28 Feb 2026 13:16:56 -0500
Message-ID: <20260228181736.1605592-108-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit afcae7d7b8a278a6c29e064f99e5bafd4ac1fb37 ]

svc_rdma_accept() computes sc_sq_depth as the sum of rq_depth and the
number of rdma_rw contexts (ctxts). This value is used to allocate the
Send CQ and to initialize the sc_sq_avail credit pool.

However, when the device uses memory registration for RDMA operations,
rdma_rw_init_qp() inflates the QP's max_send_wr by a factor of three
per context to account for REG and INV work requests. The Send CQ and
credit pool remain sized for only one work request per context,
causing Send Queue exhaustion under heavy NFS WRITE workloads.

Introduce rdma_rw_max_sge() to compute the actual number of Send Queue
entries required for a given number of rdma_rw contexts. Upper layer
protocols call this helper before creating a Queue Pair so that their
Send CQs and credit accounting match the QP's true capacity.

Update svc_rdma_accept() to use rdma_rw_max_sge() when computing
sc_sq_depth, ensuring the credit pool reflects the work requests
that rdma_rw_init_qp() will reserve.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: 00bd1439f464 ("RDMA/rw: Support threshold for registration vs scattering to local pages")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20260128005400.25147-5-cel@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rw.c             | 53 +++++++++++++++++-------
 include/rdma/rw.h                        |  2 +
 net/sunrpc/xprtrdma/svc_rdma_transport.c |  8 +++-
 3 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 3cc5ed902976b..d479408a2cf73 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -660,34 +660,57 @@ unsigned int rdma_rw_mr_factor(struct ib_device *device, u8 port_num,
 }
 EXPORT_SYMBOL(rdma_rw_mr_factor);
 
+/**
+ * rdma_rw_max_send_wr - compute max Send WRs needed for RDMA R/W contexts
+ * @dev: RDMA device
+ * @port_num: port number
+ * @max_rdma_ctxs: number of rdma_rw_ctx structures
+ * @create_flags: QP create flags (pass IB_QP_CREATE_INTEGRITY_EN if
+ *                data integrity will be enabled on the QP)
+ *
+ * Returns the total number of Send Queue entries needed for
+ * @max_rdma_ctxs. The result accounts for memory registration and
+ * invalidation work requests when the device requires them.
+ *
+ * ULPs use this to size Send Queues and Send CQs before creating a
+ * Queue Pair.
+ */
+unsigned int rdma_rw_max_send_wr(struct ib_device *dev, u32 port_num,
+				 unsigned int max_rdma_ctxs, u32 create_flags)
+{
+	unsigned int factor = 1;
+	unsigned int result;
+
+	if (create_flags & IB_QP_CREATE_INTEGRITY_EN ||
+	    rdma_rw_can_use_mr(dev, port_num))
+		factor += 2;	/* reg + inv */
+
+	if (check_mul_overflow(factor, max_rdma_ctxs, &result))
+		return UINT_MAX;
+	return result;
+}
+EXPORT_SYMBOL(rdma_rw_max_send_wr);
+
 void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
 {
-	u32 factor;
+	unsigned int factor = 1;
 
 	WARN_ON_ONCE(attr->port_num == 0);
 
 	/*
-	 * Each context needs at least one RDMA READ or WRITE WR.
-	 *
-	 * For some hardware we might need more, eventually we should ask the
-	 * HCA driver for a multiplier here.
-	 */
-	factor = 1;
-
-	/*
-	 * If the device needs MRs to perform RDMA READ or WRITE operations,
-	 * we'll need two additional MRs for the registrations and the
-	 * invalidation.
+	 * If the device uses MRs to perform RDMA READ or WRITE operations,
+	 * or if data integrity is enabled, account for registration and
+	 * invalidation work requests.
 	 */
 	if (attr->create_flags & IB_QP_CREATE_INTEGRITY_EN ||
 	    rdma_rw_can_use_mr(dev, attr->port_num))
-		factor += 2;	/* inv + reg */
+		factor += 2;	/* reg + inv */
 
 	attr->cap.max_send_wr += factor * attr->cap.max_rdma_ctxs;
 
 	/*
-	 * But maybe we were just too high in the sky and the device doesn't
-	 * even support all we need, and we'll have to live with what we get..
+	 * The device might not support all we need, and we'll have to
+	 * live with what we get.
 	 */
 	attr->cap.max_send_wr =
 		min_t(u32, attr->cap.max_send_wr, dev->attrs.max_qp_wr);
diff --git a/include/rdma/rw.h b/include/rdma/rw.h
index 6ad9dc836c107..b7249929109dd 100644
--- a/include/rdma/rw.h
+++ b/include/rdma/rw.h
@@ -66,6 +66,8 @@ int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 
 unsigned int rdma_rw_mr_factor(struct ib_device *device, u8 port_num,
 		unsigned int maxpages);
+unsigned int rdma_rw_max_send_wr(struct ib_device *dev, u32 port_num,
+		unsigned int max_rdma_ctxs, u32 create_flags);
 void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr);
 int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr);
 void rdma_rw_cleanup_mrs(struct ib_qp *qp);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 7b7d2add99a4c..1041ea72b3613 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -418,7 +418,10 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
-	/* Arbitrary estimate of the needed number of rdma_rw contexts.
+	/* Estimate the needed number of rdma_rw contexts. The maximum
+	 * Read and Write chunks have one segment each. Each request
+	 * can involve one Read chunk and either a Write chunk or Reply
+	 * chunk; thus a factor of three.
 	 */
 	maxpayload = min(xprt->xpt_server->sv_max_payload,
 			 RPCSVC_MAXPAYLOAD_RDMA);
@@ -426,7 +429,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		rdma_rw_mr_factor(dev, newxprt->sc_port_num,
 				  maxpayload >> PAGE_SHIFT);
 
-	newxprt->sc_sq_depth = rq_depth + ctxts;
+	newxprt->sc_sq_depth = rq_depth +
+		rdma_rw_max_send_wr(dev, newxprt->sc_port_num, ctxts, 0);
 	if (newxprt->sc_sq_depth > dev->attrs.max_qp_wr)
 		newxprt->sc_sq_depth = dev->attrs.max_qp_wr;
 	atomic_set(&newxprt->sc_sq_avail, newxprt->sc_sq_depth);
-- 
2.51.0

