Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0531919FA93;
	Wed, 25 Feb 2026 01:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983793; cv=none; b=FIBgPAShrLWg2lGwqBckmcJ0gIpVl+SNjAyxyDQ91LGALGylWk/ZEAFtttBDVSQq/k8d0ZotoI7CcAD5nB1F2WL9whIun9xJT6apq+wd3HgLWP1VDYndEGYLwRlBYjDmG7TzfOYmFPjVENfEimRQuQGRheVqRCuWFOgRel0ZEXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983793; c=relaxed/simple;
	bh=QDEV1Qb0y0OQ4kKrrQC2a2qHDZIVfkpSTgu1YBWb9FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuK7PWzqdub7hayCF8l7Ds1FmLXDBQ65PlOTCoJgmzE8RayqKCy8DEVYrEoCOFiXXcGQzAPkmpZaqVxPSXzXOw1sWvJjxsc2/K5U4mVsGy4hmP+tsaohkShGrrY5F+hJv0hiZY3hIh6y7+BY7eXGKEz3PGlf1i4gPOb2ivWiCBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aj9xAjR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aj9xAjR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA29AC116D0;
	Wed, 25 Feb 2026 01:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983792;
	bh=QDEV1Qb0y0OQ4kKrrQC2a2qHDZIVfkpSTgu1YBWb9FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aj9xAjR/3kUEpCvwGA6O6VlVZ5lXJYqSUBLKL2jf56/p2nydg2ZsEr3GLkA+FhIKp
	 nWIa3oo+q9RP8YgjmDs+3RTV/T7v5nr52oYPXGyZaZiyciKevH11Jz4V1zO0UTsfrd
	 cUIxQDTRASNbP+zENtUL/hjSng/0NyT5RNNsdQGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/641] crypto: hisilicon/qm - centralize the sending locks of each module into qm
Date: Tue, 24 Feb 2026 17:16:44 -0800
Message-ID: <20260225012350.962551698@linuxfoundation.org>
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
index 41b7ffa0fb1ae..c2c24c3a2be86 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2360,26 +2360,33 @@ EXPORT_SYMBOL_GPL(hisi_qm_stop_qp);
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
@@ -2956,6 +2963,7 @@ static int hisi_qp_memory_init(struct hisi_qm *qm, size_t dma_size, int id,
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
index 4f83f07009907..75ae01ddaa1a8 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -473,6 +473,7 @@ struct hisi_qp {
 	u16 pasid;
 	struct uacce_queue *uacce_q;
 
+	spinlock_t qp_lock;
 	struct instance_backlog backlog;
 	const void **msg;
 };
-- 
2.51.0



