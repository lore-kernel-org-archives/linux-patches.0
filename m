Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB443446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302065; cv=none; b=QIwsNwQN2Yy52S2HNWZO2N5r5szdxD7xyKyy1qrGYUTPGVX5rjQuCcsbKnszWakKNgl6Nyae9+QpEOJQ4kg5dkag0P/vS3jEuHB7Zfpj4/Ru5vl+0zeYCu+V+5n4D7YvlcioUxXbhTphgtqiar/AJVSfmZdi1G2v+rFI9Z73Iog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302065; c=relaxed/simple;
	bh=QOEpk3+zy7RGW7G1/BsAVbyGlm1B9SOrlDcUvNtHYhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDTqWL7iWs7YtxiEHCw91+wuvk+0z2hNrD70HB+2GBjHUj4lkmiW9et7dVHSsi9nABrwhq7xX0aoOUHBmpq2JesgakM3g7/snd3wrBKy9BkY1yzgR0ltmKapegq/s1Q3LH8V+YbTrcHEW8F4l3zinewDI3LErIZq89+n+stIZzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=auxWJV25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="auxWJV25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2898C116D0;
	Sat, 28 Feb 2026 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302065;
	bh=QOEpk3+zy7RGW7G1/BsAVbyGlm1B9SOrlDcUvNtHYhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auxWJV255jOwj7exEZ92m0Ub9x/wk6FJ8kzaNRkSnSaIl1b+OK8j9C31qpYOjnWbw
	 c+lfZWv/2FhCQpZVvm4Qu71fiIV/laJ7PUGwguiJeXfGG4yGN5Fi88n8uByIwXxxg/
	 CoFgC+8CFEjxRyKuFahPn7qQeezHKHwNHSgzlBtpIJVESgpWFnLkXYvdf/3ZNhuW+Y
	 2W3HEsu1TQ7+qFOHeO8X+9QKNQYfWjsfmzQt+eSdzYgb7WisM+cSjubzr30oIuyCts
	 f4umGZHLnE/4/FBGafGw8V9Ojm6yt9C0j5MvGazchalFSThtkS14HRBPxDt4gIK8q2
	 u4zsfoy/mdRsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yang Shen <shenyang39@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/283] crypto: hisilicon/zip - support deflate algorithm
Date: Sat, 28 Feb 2026 13:03:05 -0500
Message-ID: <20260228180709.1583486-43-sashal@kernel.org>
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

From: Yang Shen <shenyang39@huawei.com>

[ Upstream commit aa3f80500382ca864b7cfcff4e5ca2fa6a0e977d ]

Add the deflate algorithm support for hisilicon zip hardware.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 19c2475ce198 ("crypto: hisilicon/zip - adjust the way to obtain the req in the callback function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 86 ++++++++++++++++++-----
 drivers/crypto/hisilicon/zip/zip_main.c   |  4 +-
 2 files changed, 72 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 6608971d10cdc..09f60f7867795 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -16,6 +16,7 @@
 #define HZIP_OUT_SGE_DATA_OFFSET_M		GENMASK(23, 0)
 /* hisi_zip_sqe dw9 */
 #define HZIP_REQ_TYPE_M				GENMASK(7, 0)
+#define HZIP_ALG_TYPE_DEFLATE			0x01
 #define HZIP_ALG_TYPE_ZLIB			0x02
 #define HZIP_ALG_TYPE_GZIP			0x03
 #define HZIP_BUF_TYPE_M				GENMASK(11, 8)
@@ -41,6 +42,7 @@
 
 #define HZIP_ALG_ZLIB				GENMASK(1, 0)
 #define HZIP_ALG_GZIP				GENMASK(3, 2)
+#define HZIP_ALG_DEFLATE			GENMASK(5, 4)
 
 static const u8 zlib_head[HZIP_ZLIB_HEAD_SIZE] = {0x78, 0x9c};
 static const u8 gzip_head[HZIP_GZIP_HEAD_SIZE] = {
@@ -59,8 +61,9 @@ enum {
 };
 
 #define COMP_NAME_TO_TYPE(alg_name)					\
+	(!strcmp((alg_name), "deflate") ? HZIP_ALG_TYPE_DEFLATE :	\
 	(!strcmp((alg_name), "zlib-deflate") ? HZIP_ALG_TYPE_ZLIB :	\
-	 !strcmp((alg_name), "gzip") ? HZIP_ALG_TYPE_GZIP : 0)		\
+	 !strcmp((alg_name), "gzip") ? HZIP_ALG_TYPE_GZIP : 0))		\
 
 #define TO_HEAD_SIZE(req_type)						\
 	(((req_type) == HZIP_ALG_TYPE_ZLIB) ? sizeof(zlib_head) :	\
@@ -447,15 +450,17 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_COMP];
 	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct hisi_zip_req *req;
-	int head_size;
+	int head_size = 0;
 	int ret;
 
 	/* let's output compression head now */
-	head_size = add_comp_head(acomp_req->dst, qp_ctx->qp->req_type);
-	if (unlikely(head_size < 0)) {
-		dev_err_ratelimited(dev, "failed to add comp head (%d)!\n",
-				    head_size);
-		return head_size;
+	if (qp_ctx->qp->req_type != HZIP_ALG_TYPE_DEFLATE) {
+		head_size = add_comp_head(acomp_req->dst, qp_ctx->qp->req_type);
+		if (unlikely(head_size < 0)) {
+			dev_err_ratelimited(dev, "failed to add comp head (%d)!\n",
+					head_size);
+			return head_size;
+		}
 	}
 
 	req = hisi_zip_create_req(acomp_req, qp_ctx, head_size, true);
@@ -477,13 +482,15 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
 	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct hisi_zip_req *req;
-	int head_size, ret;
-
-	head_size = get_comp_head_size(acomp_req, qp_ctx->qp->req_type);
-	if (unlikely(head_size < 0)) {
-		dev_err_ratelimited(dev, "failed to get comp head size (%d)!\n",
-				    head_size);
-		return head_size;
+	int head_size = 0, ret;
+
+	if (qp_ctx->qp->req_type != HZIP_ALG_TYPE_DEFLATE) {
+		head_size = get_comp_head_size(acomp_req, qp_ctx->qp->req_type);
+		if (unlikely(head_size < 0)) {
+			dev_err_ratelimited(dev, "failed to get comp head size (%d)!\n",
+					head_size);
+			return head_size;
+		}
 	}
 
 	req = hisi_zip_create_req(acomp_req, qp_ctx, head_size, false);
@@ -745,6 +752,42 @@ static void hisi_zip_acomp_exit(struct crypto_acomp *tfm)
 	hisi_zip_ctx_exit(ctx);
 }
 
+static struct acomp_alg hisi_zip_acomp_deflate = {
+	.init			= hisi_zip_acomp_init,
+	.exit			= hisi_zip_acomp_exit,
+	.compress		= hisi_zip_acompress,
+	.decompress		= hisi_zip_adecompress,
+	.base			= {
+		.cra_name		= "deflate",
+		.cra_driver_name	= "hisi-deflate-acomp",
+		.cra_module		= THIS_MODULE,
+		.cra_priority		= HZIP_ALG_PRIORITY,
+		.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
+	}
+};
+
+static int hisi_zip_register_deflate(struct hisi_qm *qm)
+{
+	int ret;
+
+	if (!hisi_zip_alg_support(qm, HZIP_ALG_DEFLATE))
+		return 0;
+
+	ret = crypto_register_acomp(&hisi_zip_acomp_deflate);
+	if (ret)
+		dev_err(&qm->pdev->dev, "failed to register to deflate (%d)!\n", ret);
+
+	return ret;
+}
+
+static void hisi_zip_unregister_deflate(struct hisi_qm *qm)
+{
+	if (!hisi_zip_alg_support(qm, HZIP_ALG_DEFLATE))
+		return;
+
+	crypto_unregister_acomp(&hisi_zip_acomp_deflate);
+}
+
 static struct acomp_alg hisi_zip_acomp_zlib = {
 	.init			= hisi_zip_acomp_init,
 	.exit			= hisi_zip_acomp_exit,
@@ -821,19 +864,30 @@ int hisi_zip_register_to_crypto(struct hisi_qm *qm)
 {
 	int ret = 0;
 
-	ret = hisi_zip_register_zlib(qm);
+	ret = hisi_zip_register_deflate(qm);
 	if (ret)
 		return ret;
 
+	ret = hisi_zip_register_zlib(qm);
+	if (ret)
+		goto err_unreg_deflate;
+
 	ret = hisi_zip_register_gzip(qm);
 	if (ret)
-		hisi_zip_unregister_zlib(qm);
+		goto err_unreg_zlib;
+
+	return 0;
 
+err_unreg_zlib:
+	hisi_zip_unregister_zlib(qm);
+err_unreg_deflate:
+	hisi_zip_unregister_deflate(qm);
 	return ret;
 }
 
 void hisi_zip_unregister_from_crypto(struct hisi_qm *qm)
 {
+	hisi_zip_unregister_deflate(qm);
 	hisi_zip_unregister_zlib(qm);
 	hisi_zip_unregister_gzip(qm);
 }
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index b70aa6032874e..26a0581e0d393 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -238,8 +238,8 @@ static struct hisi_qm_cap_info zip_basic_cap_info[] = {
 	{ZIP_CLUSTER_DECOMP_NUM_CAP, 0x313C, 0, GENMASK(7, 0), 0x6, 0x6, 0x3},
 	{ZIP_DECOMP_ENABLE_BITMAP, 0x3140, 16, GENMASK(15, 0), 0xFC, 0xFC, 0x1C},
 	{ZIP_COMP_ENABLE_BITMAP, 0x3140, 0, GENMASK(15, 0), 0x3, 0x3, 0x3},
-	{ZIP_DRV_ALG_BITMAP, 0x3144, 0, GENMASK(31, 0), 0xF, 0xF, 0xF},
-	{ZIP_DEV_ALG_BITMAP, 0x3148, 0, GENMASK(31, 0), 0xF, 0xF, 0xFF},
+	{ZIP_DRV_ALG_BITMAP, 0x3144, 0, GENMASK(31, 0), 0xF, 0xF, 0x3F},
+	{ZIP_DEV_ALG_BITMAP, 0x3148, 0, GENMASK(31, 0), 0xF, 0xF, 0x3F},
 	{ZIP_CORE1_ALG_BITMAP, 0x314C, 0, GENMASK(31, 0), 0x5, 0x5, 0xD5},
 	{ZIP_CORE2_ALG_BITMAP, 0x3150, 0, GENMASK(31, 0), 0x5, 0x5, 0xD5},
 	{ZIP_CORE3_ALG_BITMAP, 0x3154, 0, GENMASK(31, 0), 0xA, 0xA, 0x2A},
-- 
2.51.0

