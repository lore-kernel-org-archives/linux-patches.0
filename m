Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F7843E9F9;
	Thu, 30 Jul 2026 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421342; cv=none; b=jPHaxTaeZn4AU8L+p1VeeMm9JWXEJucswaGL4Hncw7atwr3xpypSuV2wWMD/F9i9IAGrNKkrC8ApfAdinDHBUYz3nH1VXm4m32JZljzQvinQIBhdjP3hgmk3eIjHMtjSGTMr0jz+8R08QmSxwUlaK5DERt4EEwGciLT8rBg4Xps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421342; c=relaxed/simple;
	bh=qTbOiNbtOOGDHAZey0/efzfsU8uIK12Jk/5KBCFv1Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUfYDSK18IRkpsPjVXndJSZzYQJPuvJNl+9VnggginLhunTZ56hWmI7uLk9yzuiIk09CGdH+ge+xiaiWEgjQ9zovsZc74rQOswIy0usOXhZcDnVcBS0mfbT9nQVxt1zoa5dK+jiDfiGyTplwuGbmbwgl9KC6fkIhGFo2ycSHvq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqF3lJYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqF3lJYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1588A1F000E9;
	Thu, 30 Jul 2026 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421340;
	bh=7Nq/82IDB6EMzrbKvlaWiBImBSCrVnNr5B4EMQzLOJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqF3lJYd1T5ZHszUiPuYIhw3s3ZGEMbKRKVjtW5sqPMk2VqKi2Tprl52jInhN2fCp
	 ZTn/G3QmAdMco+PcPYVnXOxjsIqr9oap9Bs3hqSHyF+RqrHfTpcvpY4oaeazIGYr/t
	 xuzDCm0GHYqLu6+2Z9ZSKxF9i2Enq6e7JjtNWx9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 034/744] RDMA/irdma: Remove redundant legacy_mode checks
Date: Thu, 30 Jul 2026 16:05:07 +0200
Message-ID: <20260730141445.007741332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit ed8621be482bf18dcd217aa024e95758bf9d28f2 ]

The driver has the following invariants:

1. legacy_mode is only allowed on GEN_1 hardware (enforced
   in irdma_alloc_ucontext).

2. GEN_1 hardware does not set IRDMA_FEATURE_CQ_RESIZE or
   IRDMA_FEATURE_RTS_AE. These feature flags are only set
   for GEN_2 and GEN_3 hardware.

Therefore, legacy_mode is always false if IRDMA_FEATURE_CQ_RESIZE
or IRDMA_FEATURE_RTS_AE is set, so remove the redundant checks.

Link: https://patch.msgid.link/r/20260602214423.1315105-1-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: b9b088907156 ("RDMA/irdma: Prevent user-triggered null deref on QP create")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/uk.c    | 9 +++------
 drivers/infiniband/hw/irdma/user.h  | 1 -
 drivers/infiniband/hw/irdma/verbs.c | 7 +------
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index 4718acf6c6fd00..a34883fe998368 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1568,15 +1568,12 @@ static const struct irdma_wqe_uk_ops iw_wqe_uk_ops_gen_1 = {
  * irdma_setup_connection_wqes - setup WQEs necessary to complete
  * connection.
  * @qp: hw qp (user and kernel)
- * @info: qp initialization info
  */
-static void irdma_setup_connection_wqes(struct irdma_qp_uk *qp,
-					struct irdma_qp_uk_init_info *info)
+static void irdma_setup_connection_wqes(struct irdma_qp_uk *qp)
 {
 	u16 move_cnt = 1;
 
-	if (!info->legacy_mode &&
-	    (qp->uk_attrs->feature_flags & IRDMA_FEATURE_RTS_AE))
+	if (qp->uk_attrs->feature_flags & IRDMA_FEATURE_RTS_AE)
 		move_cnt = 3;
 
 	qp->conn_wqes = move_cnt;
@@ -1727,7 +1724,7 @@ int irdma_uk_qp_init(struct irdma_qp_uk *qp, struct irdma_qp_uk_init_info *info)
 	sq_ring_size = qp->sq_size << info->sq_shift;
 	IRDMA_RING_INIT(qp->sq_ring, sq_ring_size);
 	if (info->first_sq_wq) {
-		irdma_setup_connection_wqes(qp, info);
+		irdma_setup_connection_wqes(qp);
 		qp->swqe_polarity = 1;
 		qp->first_sq_wq = true;
 	} else {
diff --git a/drivers/infiniband/hw/irdma/user.h b/drivers/infiniband/hw/irdma/user.h
index 008af1acc92884..4dd3776a4cddb6 100644
--- a/drivers/infiniband/hw/irdma/user.h
+++ b/drivers/infiniband/hw/irdma/user.h
@@ -563,7 +563,6 @@ struct irdma_qp_uk_init_info {
 	u8 sq_shift;
 	u8 rq_shift;
 	int abi_ver;
-	bool legacy_mode;
 	struct irdma_srq_uk *srq_uk;
 };
 
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index a33bd3c8571247..7ab08f324eb9a2 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -634,7 +634,6 @@ static int irdma_setup_umode_qp(struct ib_udata *udata,
 	iwqp->ctx_info.qp_compl_ctx = req.user_compl_ctx;
 	iwqp->user_mode = 1;
 	if (req.user_wqe_bufs) {
-		info->qp_uk_init_info.legacy_mode = ucontext->legacy_mode;
 		spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
 		iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
 					    &ucontext->qp_reg_mem_list);
@@ -2074,10 +2073,6 @@ static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 			rdma_udata_to_drv_context(udata, struct irdma_ucontext,
 						  ibucontext);
 
-		/* CQ resize not supported with legacy GEN_1 libi40iw */
-		if (ucontext->legacy_mode)
-			return -EOPNOTSUPP;
-
 		if (ib_copy_from_udata(&req, udata,
 				       min(sizeof(req), udata->inlen)))
 			return -EINVAL;
@@ -2559,7 +2554,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		cqmr = &iwpbl->cq_mr;
 
 		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
-		    IRDMA_FEATURE_CQ_RESIZE && !ucontext->legacy_mode) {
+		    IRDMA_FEATURE_CQ_RESIZE) {
 			spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
 			iwpbl_shadow = irdma_get_pbl(
 					(unsigned long)req.user_shadow_area,
-- 
2.53.0



