Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348EC1F09B3;
	Tue, 11 Nov 2025 01:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824184; cv=none; b=gwG3ibkfY24qh1RYKMyfSVxHvCtyv6kKuT1ldHevR1UIdPMrmh+77h2/gnYO80VvzFbDyjfENl2yrjYSdgzqriT1iFed4iHg80BJPgPgeOYE24Bb3otQ1qwKe2SHijfHG/u8cex8gwg2Rvi/EHu+V4ZWh477ITZGgrU3TrTxHyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824184; c=relaxed/simple;
	bh=C3TUmuJl9tufYhukLFNS/a0kzEG2+efP3UQeRRHhMKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WS3kMF2KGuPwZb+aQlEDVm++wlJzalb1L2RXUjTsS0Jfht9BQ3DsZzpxFZeFPfdOOKHnmhvh8//+psYn6YsmbV+cLSXatfISulN/5Xn+5C3PF8rNydMynJOWspz3r+B+09kDblHPq29JgtBWOnF+sy10Yst6fvXgWbqz+YX6qnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efZePzvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efZePzvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7715FC4CEF5;
	Tue, 11 Nov 2025 01:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824183;
	bh=C3TUmuJl9tufYhukLFNS/a0kzEG2+efP3UQeRRHhMKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efZePzvPp3yT6240vHBmhiNnb/6hkhX1sNyFlZpm6VXmsbRyUveX3ydhQiytpF/GH
	 32Ef7gKCKf277r33K5BQyME1NkZlMizPUcW/1N+QKKedJb2LDHjtxeeLj3kyT9VQR1
	 VlO8ju5rKS+/MCAh9Ibq86JUJS3h5Rz9aPVEHjgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 406/565] crypto: hisilicon/qm - invalidate queues in use
Date: Tue, 11 Nov 2025 09:44:22 +0900
Message-ID: <20251111004536.007170813@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 85acd1b26b8f5b838887dc965dc3aa2c0253f4d1 ]

Before the device reset, although the driver has set the queue
status to intercept doorbells sent by the task process, the reset
thread is isolated from the user-mode task process, so the task process
may still send doorbells. Therefore, before the reset, the queue is
directly invalidated, and the device directly discards the doorbells
sent by the process.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 53 ++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a9550a05dfbd3..73eea2ee1b9b9 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -47,6 +47,8 @@
 
 #define QM_SQ_TYPE_MASK			GENMASK(3, 0)
 #define QM_SQ_TAIL_IDX(sqc)		((le16_to_cpu((sqc).w11) >> 6) & 0x1)
+#define QM_SQC_DISABLE_QP		(1U << 6)
+#define QM_XQC_RANDOM_DATA		0xaaaa
 
 /* cqc shift */
 #define QM_CQ_HOP_NUM_SHIFT		0
@@ -3008,6 +3010,9 @@ static int qm_eq_aeq_ctx_cfg(struct hisi_qm *qm)
 
 	qm_init_eq_aeq_status(qm);
 
+	/* Before starting the dev, clear the memory and then configure to device using. */
+	memset(qm->qdma.va, 0, qm->qdma.size);
+
 	ret = qm_eq_ctx_cfg(qm);
 	if (ret) {
 		dev_err(dev, "Set eqc failed!\n");
@@ -3019,9 +3024,13 @@ static int qm_eq_aeq_ctx_cfg(struct hisi_qm *qm)
 
 static int __hisi_qm_start(struct hisi_qm *qm)
 {
+	struct device *dev = &qm->pdev->dev;
 	int ret;
 
-	WARN_ON(!qm->qdma.va);
+	if (!qm->qdma.va) {
+		dev_err(dev, "qm qdma is NULL!\n");
+		return -EINVAL;
+	}
 
 	if (qm->fun_type == QM_HW_PF) {
 		ret = hisi_qm_set_vft(qm, 0, qm->qp_base, qm->qp_num);
@@ -3095,7 +3104,7 @@ static int qm_restart(struct hisi_qm *qm)
 	for (i = 0; i < qm->qp_num; i++) {
 		qp = &qm->qp_array[i];
 		if (atomic_read(&qp->qp_status.flags) == QP_STOP &&
-		    qp->is_resetting == true) {
+		    qp->is_resetting == true && qp->is_in_kernel == true) {
 			ret = qm_start_qp_nolock(qp, 0);
 			if (ret < 0) {
 				dev_err(dev, "Failed to start qp%d!\n", i);
@@ -3127,24 +3136,44 @@ static void qm_stop_started_qp(struct hisi_qm *qm)
 }
 
 /**
- * qm_clear_queues() - Clear all queues memory in a qm.
- * @qm: The qm in which the queues will be cleared.
+ * qm_invalid_queues() - invalid all queues in use.
+ * @qm: The qm in which the queues will be invalidated.
  *
- * This function clears all queues memory in a qm. Reset of accelerator can
- * use this to clear queues.
+ * This function invalid all queues in use. If the doorbell command is sent
+ * to device in user space after the device is reset, the device discards
+ * the doorbell command.
  */
-static void qm_clear_queues(struct hisi_qm *qm)
+static void qm_invalid_queues(struct hisi_qm *qm)
 {
 	struct hisi_qp *qp;
+	struct qm_sqc *sqc;
+	struct qm_cqc *cqc;
 	int i;
 
+	/*
+	 * Normal stop queues is no longer used and does not need to be
+	 * invalid queues.
+	 */
+	if (qm->status.stop_reason == QM_NORMAL)
+		return;
+
+	if (qm->status.stop_reason == QM_DOWN)
+		hisi_qm_cache_wb(qm);
+
 	for (i = 0; i < qm->qp_num; i++) {
 		qp = &qm->qp_array[i];
-		if (qp->is_in_kernel && qp->is_resetting)
+		if (!qp->is_resetting)
+			continue;
+
+		/* Modify random data and set sqc close bit to invalid queue. */
+		sqc = qm->sqc + i;
+		cqc = qm->cqc + i;
+		sqc->w8 = cpu_to_le16(QM_XQC_RANDOM_DATA);
+		sqc->w13 = cpu_to_le16(QM_SQC_DISABLE_QP);
+		cqc->w8 = cpu_to_le16(QM_XQC_RANDOM_DATA);
+		if (qp->is_in_kernel)
 			memset(qp->qdma.va, 0, qp->qdma.size);
 	}
-
-	memset(qm->qdma.va, 0, qm->qdma.size);
 }
 
 /**
@@ -3201,7 +3230,7 @@ int hisi_qm_stop(struct hisi_qm *qm, enum qm_stop_reason r)
 		}
 	}
 
-	qm_clear_queues(qm);
+	qm_invalid_queues(qm);
 	qm->status.stop_reason = QM_NORMAL;
 
 err_unlock:
@@ -4586,8 +4615,6 @@ void hisi_qm_dev_shutdown(struct pci_dev *pdev)
 	ret = hisi_qm_stop(qm, QM_DOWN);
 	if (ret)
 		dev_err(&pdev->dev, "Fail to stop qm in shutdown!\n");
-
-	hisi_qm_cache_wb(qm);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_dev_shutdown);
 
-- 
2.51.0



