Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0963F33A702
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302067; cv=none; b=HmBj9cCqdT082xmoIbYynGGlUWaiytdPvNFP0qa/f8hC5F8SpgJG9KkvIzPLxpkGLWFyAPnXFMo+SCUwOHdwEV7lLQAd5Ap3lEXTkP54KGvuUNMBc8cp2HH6GhV1YkwYY7qNeTGL5hhPiRXBD0gSjSVEfVK3shq4qi/rK5fWu0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302067; c=relaxed/simple;
	bh=QwM/PeDCyOfUoFaySeK8v18HNiaxQHi9rT5NkOhbCFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQzoqAtvl8xuwd47zJAEnwDtBAxOtAr1j+/z2iQMuRjibELPcv1LLEYwtn5JHsPSXHmxelhPQmH7gKcuNq9ZvoUqTaJ/NLsY0Jz5VBU0kgb7R792XIkUDzBVXtJthUwwjOangu4Fymwr6Hsb4XMjt29EjTVLjKXk+ZwQCv74dr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpvHs0ux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpvHs0ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5926AC19423;
	Sat, 28 Feb 2026 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302066;
	bh=QwM/PeDCyOfUoFaySeK8v18HNiaxQHi9rT5NkOhbCFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpvHs0uxxcpQMR5/eJMakYlYfelpTB4mBvVXODG3iJyqWgWzTwkloCV/OWZsiMzh7
	 fWvq/JbSbF3Sf2rmzgZcHkJ9NW6XslRAM4z2HRBso9nGAX0la5aYGTazh9mUyRhxaj
	 K59sHC8ehxuRFCsiG6sEB2ibhSVslJeDLV5zL3++K28uML8fHEVftEyYgO73VwI5d5
	 ZZRNy+cI77ICrlr0s5jU40ZnFMD/GUDcB4si2nL2F4KoRti+fkhMLHNOeLhfRB1Yl5
	 /O8ScOIUZUGdfcml1nM/pNXeiEmMNDwJxVGr2imOT1WM8mlq5Dby4r4C5/GNgKeAiu
	 iRu/aj/UljLzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/283] crypto: hisilicon/zip - adjust the way to obtain the req in the callback function
Date: Sat, 28 Feb 2026 13:03:07 -0500
Message-ID: <20260228180709.1583486-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 636ac794ebb75..d21ce4094d7db 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -36,6 +36,7 @@ enum {
 	HZIP_CTX_Q_NUM
 };
 
+#define GET_REQ_FROM_SQE(sqe)	((u64)(sqe)->dw26 | (u64)(sqe)->dw27 << 32)
 #define COMP_NAME_TO_TYPE(alg_name)					\
 	(!strcmp((alg_name), "deflate") ? HZIP_ALG_TYPE_DEFLATE : 0)
 
@@ -45,6 +46,7 @@ struct hisi_zip_req {
 	struct hisi_acc_hw_sgl *hw_dst;
 	dma_addr_t dma_src;
 	dma_addr_t dma_dst;
+	struct hisi_zip_qp_ctx *qp_ctx;
 	u16 req_id;
 };
 
@@ -71,7 +73,6 @@ struct hisi_zip_sqe_ops {
 	void (*fill_req_type)(struct hisi_zip_sqe *sqe, u8 req_type);
 	void (*fill_tag)(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req);
 	void (*fill_sqe_type)(struct hisi_zip_sqe *sqe, u8 sqe_type);
-	u32 (*get_tag)(struct hisi_zip_sqe *sqe);
 	u32 (*get_status)(struct hisi_zip_sqe *sqe);
 	u32 (*get_dstlen)(struct hisi_zip_sqe *sqe);
 };
@@ -128,6 +129,7 @@ static struct hisi_zip_req *hisi_zip_create_req(struct hisi_zip_qp_ctx *qp_ctx,
 	req_cache = q + req_id;
 	req_cache->req_id = req_id;
 	req_cache->req = req;
+	req_cache->qp_ctx = qp_ctx;
 
 	return req_cache;
 }
@@ -178,7 +180,8 @@ static void hisi_zip_fill_req_type(struct hisi_zip_sqe *sqe, u8 req_type)
 
 static void hisi_zip_fill_tag(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req)
 {
-	sqe->dw26 = req->req_id;
+	sqe->dw26 = lower_32_bits((u64)req);
+	sqe->dw27 = upper_32_bits((u64)req);
 }
 
 static void hisi_zip_fill_sqe_type(struct hisi_zip_sqe *sqe, u8 sqe_type)
@@ -232,7 +235,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 						    &req->dma_dst);
 	if (IS_ERR(req->hw_dst)) {
 		ret = PTR_ERR(req->hw_dst);
-		dev_err(dev, "failed to map the dst buffer to hw slg (%d)!\n",
+		dev_err(dev, "failed to map the dst buffer to hw sgl (%d)!\n",
 			ret);
 		goto err_unmap_input;
 	}
@@ -258,11 +261,6 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
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
@@ -275,14 +273,12 @@ static u32 hisi_zip_get_dstlen(struct hisi_zip_sqe *sqe)
 
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
@@ -386,7 +382,6 @@ static const struct hisi_zip_sqe_ops hisi_zip_ops = {
 	.fill_req_type		= hisi_zip_fill_req_type,
 	.fill_tag		= hisi_zip_fill_tag,
 	.fill_sqe_type		= hisi_zip_fill_sqe_type,
-	.get_tag		= hisi_zip_get_tag,
 	.get_status		= hisi_zip_get_status,
 	.get_dstlen		= hisi_zip_get_dstlen,
 };
@@ -574,7 +569,6 @@ static void hisi_zip_acomp_exit(struct crypto_acomp *tfm)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(&tfm->base);
 
-	hisi_zip_set_acomp_cb(ctx, NULL);
 	hisi_zip_release_sgl_pool(ctx);
 	hisi_zip_release_req_q(ctx);
 	hisi_zip_ctx_exit(ctx);
-- 
2.51.0

