Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B5921D596;
	Wed, 25 Feb 2026 01:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982903; cv=none; b=SioebcdecLyuCR3PgYu16Q65aBoDSBSWgfHhWL21XChycBoAvjw0CAaFVeH6HWXIu4Z7rf/Skn3qmjKMpNtlpyIlUffqwStD3ZHdSjMmcggrBHVEVMWYO8jU4AgvTk/3Rput6s2Q+hIJBu4TRmrC6O4Uh1ZD8mY3QFoLSrHp1c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982903; c=relaxed/simple;
	bh=l314jUTTbf3R7SHTUDaH1sTJ+Us+6Vk3Qgj+gNceWNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMJp3SR7sbLmBNb68fRfMoCl+fEhfI8po5iGcgYwrOaVDe3XGQYk0McL1BOvysQ06vgobJiho1HBZmammfB9dNwmn0WLAM3zZk0jsKHBZRvAiBP3m6dN9IqMR1vi6WQlu4kT3IJW1DgtiXuhcOb+FvOTVss4KwUdpjxF2mf5LkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0IQo755; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0IQo755"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE63C19423;
	Wed, 25 Feb 2026 01:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982903;
	bh=l314jUTTbf3R7SHTUDaH1sTJ+Us+6Vk3Qgj+gNceWNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0IQo755lmFZPwz+5+bwa82EUk7cmUFELIKVb6CwX+MaqnaWC7VP86lYPFFsZ/jdF
	 ORfImHvc0wAtyilwNAZCdSjqSBYK1kdsBruHzecTK8e7ONyltC3LbuQd9biLh+i9X1
	 5YtIk1KxclKHCRmOa/jI0H2EC3YQrEi1C0zcHz5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 086/781] crypto: hisilicon/qm - centralize the sending locks of each module into qm
Date: Tue, 24 Feb 2026 17:13:15 -0800
Message-ID: <20260225012401.805488396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit 8cd9b608ee8dea78cac3f373bd5e3b3de2755d46 ]

When a single queue used by multiple tfms, the protection of shared
resources by individual module driver programs is no longer
sufficient. The hisi_qp_send needs to be ensured by the lock in qp.

Fixes: 5fdb4b345cfb ("crypto: hisilicon - add a lock for the qp send operation")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  4 ----
 drivers/crypto/hisilicon/qm.c               | 16 ++++++++++++----
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  3 ---
 include/linux/hisi_acc_qm.h                 |  1 +
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 4197281c8dff5..220022ae7afb6 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -109,7 +109,6 @@ struct hpre_ctx {
 	struct hisi_qp *qp;
 	struct device *dev;
 	struct hpre *hpre;
-	spinlock_t req_lock;
 	unsigned int key_sz;
 	bool crt_g2_mode;
 	union {
@@ -410,7 +409,6 @@ static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 
 	qp->qp_ctx = ctx;
 	qp->req_cb = hpre_alg_cb;
-	spin_lock_init(&ctx->req_lock);
 	ctx->qp = qp;
 	ctx->dev = &qp->qm->pdev->dev;
 	hpre = container_of(ctx->qp->qm, struct hpre, qm);
@@ -478,9 +476,7 @@ static int hpre_send(struct hpre_ctx *ctx, struct hpre_sqe *msg)
 
 	do {
 		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
-		spin_lock_bh(&ctx->req_lock);
 		ret = hisi_qp_send(ctx->qp, msg);
-		spin_unlock_bh(&ctx->req_lock);
 		if (ret != -EBUSY)
 			break;
 		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 5c80ca04a8d42..0f5e39884e4a3 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2369,26 +2369,33 @@ EXPORT_SYMBOL_GPL(hisi_qm_stop_qp);
 int hisi_qp_send(struct hisi_qp *qp, const void *msg)
 {
 	struct hisi_qp_status *qp_status = &qp->qp_status;
-	u16 sq_tail = qp_status->sq_tail;
-	u16 sq_tail_next = (sq_tail + 1) % qp->sq_depth;
-	void *sqe = qm_get_avail_sqe(qp);
+	u16 sq_tail, sq_tail_next;
+	void *sqe;
 
+	spin_lock_bh(&qp->qp_lock);
 	if (unlikely(atomic_read(&qp->qp_status.flags) == QP_STOP ||
 		     atomic_read(&qp->qm->status.flags) == QM_STOP ||
 		     qp->is_resetting)) {
+		spin_unlock_bh(&qp->qp_lock);
 		dev_info_ratelimited(&qp->qm->pdev->dev, "QP is stopped or resetting\n");
 		return -EAGAIN;
 	}
 
-	if (!sqe)
+	sqe = qm_get_avail_sqe(qp);
+	if (!sqe) {
+		spin_unlock_bh(&qp->qp_lock);
 		return -EBUSY;
+	}
 
+	sq_tail = qp_status->sq_tail;
+	sq_tail_next = (sq_tail + 1) % qp->sq_depth;
 	memcpy(sqe, msg, qp->qm->sqe_size);
 	qp->msg[sq_tail] = msg;
 
 	qm_db(qp->qm, qp->qp_id, QM_DOORBELL_CMD_SQ, sq_tail_next, 0);
 	atomic_inc(&qp->qp_status.used);
 	qp_status->sq_tail = sq_tail_next;
+	spin_unlock_bh(&qp->qp_lock);
 
 	return 0;
 }
@@ -2968,6 +2975,7 @@ static int hisi_qp_memory_init(struct hisi_qm *qm, size_t dma_size, int id,
 	qp->qm = qm;
 	qp->qp_id = id;
 
+	spin_lock_init(&qp->qp_lock);
 	spin_lock_init(&qp->backlog.lock);
 	INIT_LIST_HEAD(&qp->backlog.list);
 
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 8250a33ba5862..2f9035c016f3f 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -217,7 +217,6 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 {
 	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
 	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
-	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 	struct acomp_req *a_req = req->req;
 	struct hisi_qp *qp = qp_ctx->qp;
 	struct device *dev = &qp->qm->pdev->dev;
@@ -250,9 +249,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 
 	/* send command to start a task */
 	atomic64_inc(&dfx->send_cnt);
-	spin_lock_bh(&req_q->req_lock);
 	ret = hisi_qp_send(qp, &zip_sqe);
-	spin_unlock_bh(&req_q->req_lock);
 	if (unlikely(ret < 0)) {
 		atomic64_inc(&dfx->send_busy_cnt);
 		ret = -EAGAIN;
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index dd4323633d81e..ef4d3a79bcb70 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -476,6 +476,7 @@ struct hisi_qp {
 	u16 pasid;
 	struct uacce_queue *uacce_q;
 
+	spinlock_t qp_lock;
 	struct instance_backlog backlog;
 	const void **msg;
 };
-- 
2.51.0



