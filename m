Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72F319FA93;
	Wed, 25 Feb 2026 01:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983792; cv=none; b=fR7rw81IR7D8/So0GQkYN6X9PF6dXRJVA9h4Ss9B+dodWECKdpif+L95rCDvv6LPuxpc34XnqJIcr9s1l6sg8ul0XzXTOVyO9oPXMAME5I9yfu9z5lNTkO+FUuGUZkR9/Y+G8EeDUZyjV+i6dH4at9jR52xAYlFZktK1CeBkjlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983792; c=relaxed/simple;
	bh=Kd9CSmHfZDCOGXSG7GKtJHY/LkQuhRaM6oi33QDA0Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjVzdKAXz5w6ncnIVMVputba5cOynkEsigfOv/EhfBWvMBmONiERf7LPvYLdxwq+82VuY2H7euRbILOqR801opXJV/KvPt5567hq9JGEer/gD2T6koChtJtKOTsC8KKb9v/DkqdzBZLqtWnY6OjcArhN3UUxjF8b7/bkMmDei08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sSZDDYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sSZDDYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19F5C116D0;
	Wed, 25 Feb 2026 01:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983791;
	bh=Kd9CSmHfZDCOGXSG7GKtJHY/LkQuhRaM6oi33QDA0Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sSZDDYOucEJpYOqPJR+/jWAaGHoAkLLx9d0mPsK+4LbKn8TftiCqTvQWGErjikz7
	 7Nmcw3LJfKmrlFGIx8LianHYgjGP0OttRSPdnjEe101ofp1rJY+wHwrqXkf2Ys95PS
	 m2uzh8+IkBTlfaRPu9Xb/b6P+HAyr+LEz2iXi7Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/641] crypto: hisilicon/qm - enhance the configuration of req_type in queue attributes
Date: Tue, 24 Feb 2026 17:16:43 -0800
Message-ID: <20260225012350.936033294@linuxfoundation.org>
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

[ Upstream commit 21452eaa06edb5f6038720e643aed0bbfffad9c3 ]

Originally, when a queue was requested, it could only be configured
with the default algorithm type of 0. Now, when multiple tfms use
the same queue, the queue must be selected based on its attributes
to meet the requirements of tfm tasks. So the algorithm type
attribute of queue need to be distinguished. Just like a queue used
for compression in ZIP cannot be used for decompression tasks.

Fixes: 3f1ec97aacf1 ("crypto: hisilicon/qm - Put device finding logic into QM")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c  |  2 +-
 drivers/crypto/hisilicon/qm.c              |  8 ++++----
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  1 -
 drivers/crypto/hisilicon/sec2/sec_main.c   | 21 ++++++++++++++++-----
 drivers/crypto/hisilicon/zip/zip.h         |  2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c  | 13 +++++++++----
 drivers/crypto/hisilicon/zip/zip_main.c    |  4 ++--
 include/linux/hisi_acc_qm.h                |  3 +--
 8 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index b94fecd765eeb..884d5d0afaf41 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -465,7 +465,7 @@ struct hisi_qp *hpre_create_qp(u8 type)
 	 * type: 0 - RSA/DH. algorithm supported in V2,
 	 *       1 - ECC algorithm in V3.
 	 */
-	ret = hisi_qm_alloc_qps_node(&hpre_devices, 1, type, node, &qp);
+	ret = hisi_qm_alloc_qps_node(&hpre_devices, 1, &type, node, &qp);
 	if (!ret)
 		return qp;
 
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 6bf91735dfcd8..41b7ffa0fb1ae 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3583,7 +3583,7 @@ static int hisi_qm_sort_devices(int node, struct list_head *head,
  * not meet the requirements will return error.
  */
 int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
-			   u8 alg_type, int node, struct hisi_qp **qps)
+			   u8 *alg_type, int node, struct hisi_qp **qps)
 {
 	struct hisi_qm_resource *tmp;
 	int ret = -ENODEV;
@@ -3601,7 +3601,7 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 
 	list_for_each_entry(tmp, &head, list) {
 		for (i = 0; i < qp_num; i++) {
-			qps[i] = hisi_qm_create_qp(tmp->qm, alg_type);
+			qps[i] = hisi_qm_create_qp(tmp->qm, alg_type[i]);
 			if (IS_ERR(qps[i])) {
 				hisi_qm_free_qps(qps, i);
 				break;
@@ -3616,8 +3616,8 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 
 	mutex_unlock(&qm_list->lock);
 	if (ret)
-		pr_info("Failed to create qps, node[%d], alg[%u], qp[%d]!\n",
-			node, alg_type, qp_num);
+		pr_info("Failed to create qps, node[%d], qp[%d]!\n",
+			node, qp_num);
 
 err:
 	free_list(&head);
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 4e41235116e15..364bd69c60883 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -626,7 +626,6 @@ static int sec_create_qp_ctx(struct sec_ctx *ctx, int qp_ctx_id)
 
 	qp_ctx = &ctx->qp_ctx[qp_ctx_id];
 	qp = ctx->qps[qp_ctx_id];
-	qp->req_type = 0;
 	qp->qp_ctx = qp_ctx;
 	qp_ctx->qp = qp;
 	qp_ctx->ctx = ctx;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 5eb2d68207426..7dd125f5f511f 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -417,18 +417,29 @@ struct hisi_qp **sec_create_qps(void)
 	int node = cpu_to_node(raw_smp_processor_id());
 	u32 ctx_num = ctx_q_num;
 	struct hisi_qp **qps;
+	u8 *type;
 	int ret;
 
 	qps = kcalloc(ctx_num, sizeof(struct hisi_qp *), GFP_KERNEL);
 	if (!qps)
 		return NULL;
 
-	ret = hisi_qm_alloc_qps_node(&sec_devices, ctx_num, 0, node, qps);
-	if (!ret)
-		return qps;
+	/* The type of SEC is all 0, so just allocated by kcalloc */
+	type = kcalloc(ctx_num, sizeof(u8), GFP_KERNEL);
+	if (!type) {
+		kfree(qps);
+		return NULL;
+	}
 
-	kfree(qps);
-	return NULL;
+	ret = hisi_qm_alloc_qps_node(&sec_devices, ctx_num, type, node, qps);
+	if (ret) {
+		kfree(type);
+		kfree(qps);
+		return NULL;
+	}
+
+	kfree(type);
+	return qps;
 }
 
 u64 sec_get_alg_bitmap(struct hisi_qm *qm, u32 high, u32 low)
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index 9fb2a9c01132b..b83f228281ab1 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -99,7 +99,7 @@ enum zip_cap_table_type {
 	ZIP_CORE5_BITMAP,
 };
 
-int zip_create_qps(struct hisi_qp **qps, int qp_num, int node);
+int zip_create_qps(struct hisi_qp **qps, int qp_num, int node, u8 *alg_type);
 int hisi_zip_register_to_crypto(struct hisi_qm *qm);
 void hisi_zip_unregister_from_crypto(struct hisi_qm *qm);
 bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg);
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index b4a656e0177d2..8250a33ba5862 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -66,6 +66,7 @@ struct hisi_zip_qp_ctx {
 	struct hisi_acc_sgl_pool *sgl_pool;
 	struct hisi_zip *zip_dev;
 	struct hisi_zip_ctx *ctx;
+	u8 req_type;
 };
 
 struct hisi_zip_sqe_ops {
@@ -245,7 +246,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 		goto err_unmap_input;
 	}
 
-	hisi_zip_fill_sqe(qp_ctx->ctx, &zip_sqe, qp->req_type, req);
+	hisi_zip_fill_sqe(qp_ctx->ctx, &zip_sqe, qp_ctx->req_type, req);
 
 	/* send command to start a task */
 	atomic64_inc(&dfx->send_cnt);
@@ -360,7 +361,6 @@ static int hisi_zip_start_qp(struct hisi_qp *qp, struct hisi_zip_qp_ctx *qp_ctx,
 	struct device *dev = &qp->qm->pdev->dev;
 	int ret;
 
-	qp->req_type = req_type;
 	qp->alg_type = alg_type;
 	qp->qp_ctx = qp_ctx;
 
@@ -397,10 +397,15 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 {
 	struct hisi_qp *qps[HZIP_CTX_Q_NUM] = { NULL };
 	struct hisi_zip_qp_ctx *qp_ctx;
+	u8 alg_type[HZIP_CTX_Q_NUM];
 	struct hisi_zip *hisi_zip;
 	int ret, i, j;
 
-	ret = zip_create_qps(qps, HZIP_CTX_Q_NUM, node);
+	/* alg_type = 0 for compress, 1 for decompress in hw sqe */
+	for (i = 0; i < HZIP_CTX_Q_NUM; i++)
+		alg_type[i] = i;
+
+	ret = zip_create_qps(qps, HZIP_CTX_Q_NUM, node, alg_type);
 	if (ret) {
 		pr_err("failed to create zip qps (%d)!\n", ret);
 		return -ENODEV;
@@ -409,7 +414,6 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 	hisi_zip = container_of(qps[0]->qm, struct hisi_zip, qm);
 
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++) {
-		/* alg_type = 0 for compress, 1 for decompress in hw sqe */
 		qp_ctx = &hisi_zip_ctx->qp_ctx[i];
 		qp_ctx->ctx = hisi_zip_ctx;
 		ret = hisi_zip_start_qp(qps[i], qp_ctx, i, req_type);
@@ -422,6 +426,7 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 		}
 
 		qp_ctx->zip_dev = hisi_zip;
+		qp_ctx->req_type = req_type;
 	}
 
 	hisi_zip_ctx->ops = &hisi_zip_ops;
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 4fcbe6bada066..85b26ef175485 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -446,12 +446,12 @@ static const struct pci_device_id hisi_zip_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
 
-int zip_create_qps(struct hisi_qp **qps, int qp_num, int node)
+int zip_create_qps(struct hisi_qp **qps, int qp_num, int node, u8 *alg_type)
 {
 	if (node == NUMA_NO_NODE)
 		node = cpu_to_node(raw_smp_processor_id());
 
-	return hisi_qm_alloc_qps_node(&zip_devices, qp_num, 0, node, qps);
+	return hisi_qm_alloc_qps_node(&zip_devices, qp_num, alg_type, node, qps);
 }
 
 bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 2d0cc61ed8869..4f83f07009907 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -454,7 +454,6 @@ struct hisi_qp {
 	u16 sq_depth;
 	u16 cq_depth;
 	u8 alg_type;
-	u8 req_type;
 
 	struct qm_dma qdma;
 	void *sqe;
@@ -580,7 +579,7 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 void hisi_acc_free_sgl_pool(struct device *dev,
 			    struct hisi_acc_sgl_pool *pool);
 int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
-			   u8 alg_type, int node, struct hisi_qp **qps);
+			   u8 *alg_type, int node, struct hisi_qp **qps);
 void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num);
 void hisi_qm_dev_shutdown(struct pci_dev *pdev);
 void hisi_qm_wait_task_finish(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
-- 
2.51.0



