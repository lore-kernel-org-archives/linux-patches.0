Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468B32F5A2C;
	Wed, 25 Feb 2026 06:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002651; cv=none; b=RkeLsWbv6BttGEbRDeadONaaC7CH+3KWH5cWVsmdV4SchI+tjGHag9f47K58tGj0QWdt8Ws0b98FJQev6TZnnMfHyUNihFgUDu4tKmi1AygfEGbafst+3D4qmsA46q+cxFkNSA0CmrClusxpbCO97Im39L1O+z3ZRfIXa7yHDbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002651; c=relaxed/simple;
	bh=FKuviGZVmSALmuj0whKkfV325vZ1AAwafiKM5EsT504=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+9EsB4X2Mo4dUOANnTCoD2DcEZW6RlNGbjcrDc/vK7zq0rsvBH0dhb5VW6o9T8SIHdJlIFiltWWdDlje7w816EWWm/5bTiSutaVYMzb1U9FSyNjtTVCKwPaoUlOiBdEnmmAej/74dmg6BBZmMzftMFz6tuCLq7IdPAPEncJd/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qh3HfTM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qh3HfTM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D90FC116D0;
	Wed, 25 Feb 2026 06:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002651;
	bh=FKuviGZVmSALmuj0whKkfV325vZ1AAwafiKM5EsT504=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qh3HfTM/w4xQu5+IeWGZiPPw3BdCayui0QrhFGVYffEDLOWAaJjvMuSz5SVcAGRFY
	 ONJL879K8m1oGtqd/zHvYJjnI4BH5QAPnj9d0BLKh4e/cY1gr09FXqN7IQ4iScmjyQ
	 vyime361JqmnP2znC61pIs+IaklYxPCyORxzl2UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 382/641] RDMA/core: add rdma_rw_max_sge() helper for SQ sizing
Date: Tue, 24 Feb 2026 17:21:48 -0800
Message-ID: <20260225012357.849637088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 6354ddf2a274c..2522ff1cc462c 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -651,34 +651,57 @@ unsigned int rdma_rw_mr_factor(struct ib_device *device, u32 port_num,
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
index d606cac482338..9a8f4b76ce588 100644
--- a/include/rdma/rw.h
+++ b/include/rdma/rw.h
@@ -66,6 +66,8 @@ int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u32 port_num,
 
 unsigned int rdma_rw_mr_factor(struct ib_device *device, u32 port_num,
 		unsigned int maxpages);
+unsigned int rdma_rw_max_send_wr(struct ib_device *dev, u32 port_num,
+		unsigned int max_rdma_ctxs, u32 create_flags);
 void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr);
 int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr);
 void rdma_rw_cleanup_mrs(struct ib_qp *qp);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 3d7f1413df023..12857381e8610 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -462,7 +462,10 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
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
@@ -470,7 +473,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
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



