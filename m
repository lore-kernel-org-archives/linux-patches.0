Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B7A375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301657; cv=none; b=PvVGrmvY94ELsJj5W9f6cT/P8cY3HKmmgfTZAvq3MB9M+L3G5J+9mbSfFX/afvax287tg7cGmI+wqn/kV9lZPhuCvTzW0F8lKH2AN9/V5vArmza0l1OIHZvIxMijsOeQdF2tmXnmHWmCVHpj9e9oplaravDkCHuXz9uFTOr+r20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301657; c=relaxed/simple;
	bh=GzON4Fl2W19i+WA/VFRsj4hnUHMHAa6B/qtCXD3DV6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ium8IQttsfS4j0+15ODOpoMj3hwFnYx2JXUdiTS7uW8ImQw/YsHjBXml5nOjobTU+RDu13L2pJ1kzfsJwyo+PcuKiUIma82rOBF3ZSZ0g44WizPuFFok0uVwQvQZ2M34KVblyMz4gtVIjSnlWIQ6jDtE/p09YkFxKJk9rQtSsxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6JSwt9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6JSwt9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF99C19424;
	Sat, 28 Feb 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301657;
	bh=GzON4Fl2W19i+WA/VFRsj4hnUHMHAa6B/qtCXD3DV6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6JSwt9A6sL/50lVy6KeEtNNcPyfgsMnmyq847dgfdDOCFE4RmYSA35h/TZHAS90y
	 xuiTvt0WKYI3moVBUJi5S+etWTGkWN60rXqfYn8spgH3LjbZ+K6JyFk5JzR5mk2/Uc
	 ThTgJJ4F3SxOnfU84kycVDMnlHcjrLq/094+HPdHIm6zRIy0d5xD5piAZsl+SGiKN/
	 xT6v58v6DxPmrejxWpuWTVA7EJFJbgWWx05BHvq8G8LwX3A2Mm11AysfIsFCmXGPUy
	 MKz0HkpLOz6MpAQYmlurqwBUCjYqbVXHsl8wY4lq1bkdN4YEewCH7frynR44FcZmlG
	 /wuo3LUFbbH9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/385] crypto: hisilicon/zip - adjust the way to obtain the req in the callback function
Date: Sat, 28 Feb 2026 12:54:37 -0500
Message-ID: <20260228180011.1568201-55-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit 19c2475ce1984cf675ebfbbeaa5509b2fb1887d6 ]

In the shared queue design, multiple tfms use same qp, and one qp
need to corresponds to multiple qp_ctx. So use tag to obtain the
req virtual address. Build a one-to-one relationship between tfm
and qp_ctx. finaly remove the old get_tag operation.

Fixes: 2bcf36348ce5 ("crypto: hisilicon/zip - initialize operations about 'sqe' in 'acomp_alg.init'")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 24 +++++++++--------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 7327f8f29b013..42ac275be36fc 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -39,6 +39,7 @@ enum {
 	HZIP_CTX_Q_NUM
 };
 
+#define GET_REQ_FROM_SQE(sqe)	((u64)(sqe)->dw26 | (u64)(sqe)->dw27 << 32)
 #define COMP_NAME_TO_TYPE(alg_name)					\
 	(!strcmp((alg_name), "deflate") ? HZIP_ALG_TYPE_DEFLATE : 0)
 
@@ -48,6 +49,7 @@ struct hisi_zip_req {
 	struct hisi_acc_hw_sgl *hw_dst;
 	dma_addr_t dma_src;
 	dma_addr_t dma_dst;
+	struct hisi_zip_qp_ctx *qp_ctx;
 	u16 req_id;
 };
 
@@ -74,7 +76,6 @@ struct hisi_zip_sqe_ops {
 	void (*fill_req_type)(struct hisi_zip_sqe *sqe, u8 req_type);
 	void (*fill_tag)(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req);
 	void (*fill_sqe_type)(struct hisi_zip_sqe *sqe, u8 sqe_type);
-	u32 (*get_tag)(struct hisi_zip_sqe *sqe);
 	u32 (*get_status)(struct hisi_zip_sqe *sqe);
 	u32 (*get_dstlen)(struct hisi_zip_sqe *sqe);
 };
@@ -131,6 +132,7 @@ static struct hisi_zip_req *hisi_zip_create_req(struct hisi_zip_qp_ctx *qp_ctx,
 	req_cache = q + req_id;
 	req_cache->req_id = req_id;
 	req_cache->req = req;
+	req_cache->qp_ctx = qp_ctx;
 
 	return req_cache;
 }
@@ -181,7 +183,8 @@ static void hisi_zip_fill_req_type(struct hisi_zip_sqe *sqe, u8 req_type)
 
 static void hisi_zip_fill_tag(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req)
 {
-	sqe->dw26 = req->req_id;
+	sqe->dw26 = lower_32_bits((u64)req);
+	sqe->dw27 = upper_32_bits((u64)req);
 }
 
 static void hisi_zip_fill_sqe_type(struct hisi_zip_sqe *sqe, u8 sqe_type)
@@ -236,7 +239,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 						    &req->dma_dst);
 	if (IS_ERR(req->hw_dst)) {
 		ret = PTR_ERR(req->hw_dst);
-		dev_err(dev, "failed to map the dst buffer to hw slg (%d)!\n",
+		dev_err(dev, "failed to map the dst buffer to hw sgl (%d)!\n",
 			ret);
 		goto err_unmap_input;
 	}
@@ -264,11 +267,6 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 	return ret;
 }
 
-static u32 hisi_zip_get_tag(struct hisi_zip_sqe *sqe)
-{
-	return sqe->dw26;
-}
-
 static u32 hisi_zip_get_status(struct hisi_zip_sqe *sqe)
 {
 	return sqe->dw3 & HZIP_BD_STATUS_M;
@@ -281,14 +279,12 @@ static u32 hisi_zip_get_dstlen(struct hisi_zip_sqe *sqe)
 
 static void hisi_zip_acomp_cb(struct hisi_qp *qp, void *data)
 {
-	struct hisi_zip_qp_ctx *qp_ctx = qp->qp_ctx;
+	struct hisi_zip_sqe *sqe = data;
+	struct hisi_zip_req *req = (struct hisi_zip_req *)GET_REQ_FROM_SQE(sqe);
+	struct hisi_zip_qp_ctx *qp_ctx = req->qp_ctx;
 	const struct hisi_zip_sqe_ops *ops = qp_ctx->ctx->ops;
 	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
-	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 	struct device *dev = &qp->qm->pdev->dev;
-	struct hisi_zip_sqe *sqe = data;
-	u32 tag = ops->get_tag(sqe);
-	struct hisi_zip_req *req = req_q->q + tag;
 	struct acomp_req *acomp_req = req->req;
 	int err = 0;
 	u32 status;
@@ -392,7 +388,6 @@ static const struct hisi_zip_sqe_ops hisi_zip_ops = {
 	.fill_req_type		= hisi_zip_fill_req_type,
 	.fill_tag		= hisi_zip_fill_tag,
 	.fill_sqe_type		= hisi_zip_fill_sqe_type,
-	.get_tag		= hisi_zip_get_tag,
 	.get_status		= hisi_zip_get_status,
 	.get_dstlen		= hisi_zip_get_dstlen,
 };
@@ -580,7 +575,6 @@ static void hisi_zip_acomp_exit(struct crypto_acomp *tfm)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(&tfm->base);
 
-	hisi_zip_set_acomp_cb(ctx, NULL);
 	hisi_zip_release_sgl_pool(ctx);
 	hisi_zip_release_req_q(ctx);
 	hisi_zip_ctx_exit(ctx);
-- 
2.51.0

