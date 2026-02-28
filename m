Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AAB39B94E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302526; cv=none; b=bbM42YX5mUa4idGCHRUoW6m8RldloQLueGlWOEBrfm1NNSKRjKU8k0brTIDtGIPVL2kfGTP1RVgu68/nCxgSaJfTbINLLnr+wM6MBv+ZLDZuO+DiQM6ie+A6UCZWXciaksZPrV3X1KcmC6RgDBk8qPReO0jC+CU2ATFNC4FkHnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302526; c=relaxed/simple;
	bh=En+tCRzhSwfjPjlKagIsLL9M2CQwvabDxRoZXlF8dEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EggbJegFyvzv/iqutcX5/FSxCBb3QuEinic8CaZ66MqxE5fbxWLHNwbWlexMeBMsNg34ylp6m1x2eUVSG0w1PwRDZsYjjwN102x/pR+olXw84VnZ4XfaJbwAoNYsdVFtn8Gw+0sLr3gKQikeWe+dRKGLVhIJr3C3ZybS8TGT0RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QABWuyRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QABWuyRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB6AC19423;
	Sat, 28 Feb 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302526;
	bh=En+tCRzhSwfjPjlKagIsLL9M2CQwvabDxRoZXlF8dEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QABWuyRYDgsQEsgsOFzqmhcCn7AvIN6c8jFBx0BjiRvDB+QaJZvqwl6p6euz5y6Fh
	 HoQq065HcsWCZ6EGVuKn/3AukW2aroVeIJYBL1c7qtH8bS1L+vIFp9PUW6oqqW7J4Y
	 KW6fQT0yaLw34b7E/12JZoHonsBsGQ0xDjfO1ahdVmdxKckLwEgUcT1XX2OK1cLd2w
	 dEv2qzaN5hPw2MCdX4/L35AraibaPtv4tQDHPP55rgj0fSYfV1oPFnwNLarE4CTQ0L
	 Q178kcJ5VRw2UR+1uazOvO3Xgbo5wEtuABnImuKsSwGgnrbD0OR+8CuDbikCxZfke/
	 6r4m1Crebi0TQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Weili Qian <qianweili@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/164] crypto: hisilicon/trng - support tfms sharing the device
Date: Sat, 28 Feb 2026 13:12:44 -0500
Message-ID: <20260228181505.1600663-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 3d3135057ff567d5c09fff4c9ef6391a684e8042 ]

Since the number of devices is limited, and the number
of tfms may exceed the number of devices, to ensure that
tfms can be successfully allocated, support tfms
sharing the same device.

Fixes: e4d9d10ef4be ("crypto: hisilicon/trng - add support for PRNG")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/trng/trng.c | 121 +++++++++++++++++++--------
 1 file changed, 86 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index 71cf7c9e9a338..687705ae50ab5 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -40,6 +40,7 @@
 #define SEED_SHIFT_24		24
 #define SEED_SHIFT_16		16
 #define SEED_SHIFT_8		8
+#define SW_MAX_RANDOM_BYTES	65520
 
 struct hisi_trng_list {
 	struct mutex lock;
@@ -53,8 +54,10 @@ struct hisi_trng {
 	struct list_head list;
 	struct hwrng rng;
 	u32 ver;
-	bool is_used;
-	struct mutex mutex;
+	u32 ctx_num;
+	/* The bytes of the random number generated since the last seeding. */
+	u32 random_bytes;
+	struct mutex lock;
 };
 
 struct hisi_trng_ctx {
@@ -63,10 +66,14 @@ struct hisi_trng_ctx {
 
 static atomic_t trng_active_devs;
 static struct hisi_trng_list trng_devices;
+static int hisi_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait);
 
-static void hisi_trng_set_seed(struct hisi_trng *trng, const u8 *seed)
+static int hisi_trng_set_seed(struct hisi_trng *trng, const u8 *seed)
 {
 	u32 val, seed_reg, i;
+	int ret;
+
+	writel(0x0, trng->base + SW_DRBG_BLOCKS);
 
 	for (i = 0; i < SW_DRBG_SEED_SIZE;
 	     i += SW_DRBG_SEED_SIZE / SW_DRBG_SEED_REGS_NUM) {
@@ -78,6 +85,20 @@ static void hisi_trng_set_seed(struct hisi_trng *trng, const u8 *seed)
 		seed_reg = (i >> SW_DRBG_NUM_SHIFT) % SW_DRBG_SEED_REGS_NUM;
 		writel(val, trng->base + SW_DRBG_SEED(seed_reg));
 	}
+
+	writel(SW_DRBG_BLOCKS_NUM | (0x1 << SW_DRBG_ENABLE_SHIFT),
+	       trng->base + SW_DRBG_BLOCKS);
+	writel(0x1, trng->base + SW_DRBG_INIT);
+	ret = readl_relaxed_poll_timeout(trng->base + SW_DRBG_STATUS,
+					 val, val & BIT(0), SLEEP_US, TIMEOUT_US);
+	if (ret) {
+		pr_err("failed to init trng(%d)\n", ret);
+		return -EIO;
+	}
+
+	trng->random_bytes = 0;
+
+	return 0;
 }
 
 static int hisi_trng_seed(struct crypto_rng *tfm, const u8 *seed,
@@ -85,8 +106,7 @@ static int hisi_trng_seed(struct crypto_rng *tfm, const u8 *seed,
 {
 	struct hisi_trng_ctx *ctx = crypto_rng_ctx(tfm);
 	struct hisi_trng *trng = ctx->trng;
-	u32 val = 0;
-	int ret = 0;
+	int ret;
 
 	if (slen < SW_DRBG_SEED_SIZE) {
 		pr_err("slen(%u) is not matched with trng(%d)\n", slen,
@@ -94,43 +114,45 @@ static int hisi_trng_seed(struct crypto_rng *tfm, const u8 *seed,
 		return -EINVAL;
 	}
 
-	writel(0x0, trng->base + SW_DRBG_BLOCKS);
-	hisi_trng_set_seed(trng, seed);
+	mutex_lock(&trng->lock);
+	ret = hisi_trng_set_seed(trng, seed);
+	mutex_unlock(&trng->lock);
 
-	writel(SW_DRBG_BLOCKS_NUM | (0x1 << SW_DRBG_ENABLE_SHIFT),
-	       trng->base + SW_DRBG_BLOCKS);
-	writel(0x1, trng->base + SW_DRBG_INIT);
+	return ret;
+}
 
-	ret = readl_relaxed_poll_timeout(trng->base + SW_DRBG_STATUS,
-					val, val & BIT(0), SLEEP_US, TIMEOUT_US);
-	if (ret)
-		pr_err("fail to init trng(%d)\n", ret);
+static int hisi_trng_reseed(struct hisi_trng *trng)
+{
+	u8 seed[SW_DRBG_SEED_SIZE];
+	int size;
 
-	return ret;
+	if (!trng->random_bytes)
+		return 0;
+
+	size = hisi_trng_read(&trng->rng, seed, SW_DRBG_SEED_SIZE, false);
+	if (size != SW_DRBG_SEED_SIZE)
+		return -EIO;
+
+	return hisi_trng_set_seed(trng, seed);
 }
 
-static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
-			      unsigned int slen, u8 *dstn, unsigned int dlen)
+static int hisi_trng_get_bytes(struct hisi_trng *trng, u8 *dstn, unsigned int dlen)
 {
-	struct hisi_trng_ctx *ctx = crypto_rng_ctx(tfm);
-	struct hisi_trng *trng = ctx->trng;
 	u32 data[SW_DRBG_DATA_NUM];
 	u32 currsize = 0;
 	u32 val = 0;
 	int ret;
 	u32 i;
 
-	if (dlen > SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES || dlen == 0) {
-		pr_err("dlen(%u) exceeds limit(%d)!\n", dlen,
-			SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES);
-		return -EINVAL;
-	}
+	ret = hisi_trng_reseed(trng);
+	if (ret)
+		return ret;
 
 	do {
 		ret = readl_relaxed_poll_timeout(trng->base + SW_DRBG_STATUS,
-		     val, val & BIT(1), SLEEP_US, TIMEOUT_US);
+						 val, val & BIT(1), SLEEP_US, TIMEOUT_US);
 		if (ret) {
-			pr_err("fail to generate random number(%d)!\n", ret);
+			pr_err("failed to generate random number(%d)!\n", ret);
 			break;
 		}
 
@@ -145,30 +167,57 @@ static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
 			currsize = dlen;
 		}
 
+		trng->random_bytes += SW_DRBG_BYTES;
 		writel(0x1, trng->base + SW_DRBG_GEN);
 	} while (currsize < dlen);
 
 	return ret;
 }
 
+static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
+			      unsigned int slen, u8 *dstn, unsigned int dlen)
+{
+	struct hisi_trng_ctx *ctx = crypto_rng_ctx(tfm);
+	struct hisi_trng *trng = ctx->trng;
+	unsigned int currsize = 0;
+	unsigned int block_size;
+	int ret;
+
+	if (!dstn || !dlen) {
+		pr_err("output is error, dlen %u!\n", dlen);
+		return -EINVAL;
+	}
+
+	do {
+		block_size = min_t(unsigned int, dlen - currsize, SW_MAX_RANDOM_BYTES);
+		mutex_lock(&trng->lock);
+		ret = hisi_trng_get_bytes(trng, dstn + currsize, block_size);
+		mutex_unlock(&trng->lock);
+		if (ret)
+			return ret;
+		currsize += block_size;
+	} while (currsize < dlen);
+
+	return 0;
+}
+
 static int hisi_trng_init(struct crypto_tfm *tfm)
 {
 	struct hisi_trng_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct hisi_trng *trng;
-	int ret = -EBUSY;
+	u32 ctx_num = ~0;
 
 	mutex_lock(&trng_devices.lock);
 	list_for_each_entry(trng, &trng_devices.list, list) {
-		if (!trng->is_used) {
-			trng->is_used = true;
+		if (trng->ctx_num < ctx_num) {
+			ctx_num = trng->ctx_num;
 			ctx->trng = trng;
-			ret = 0;
-			break;
 		}
 	}
+	ctx->trng->ctx_num++;
 	mutex_unlock(&trng_devices.lock);
 
-	return ret;
+	return 0;
 }
 
 static void hisi_trng_exit(struct crypto_tfm *tfm)
@@ -176,7 +225,7 @@ static void hisi_trng_exit(struct crypto_tfm *tfm)
 	struct hisi_trng_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	mutex_lock(&trng_devices.lock);
-	ctx->trng->is_used = false;
+	ctx->trng->ctx_num--;
 	mutex_unlock(&trng_devices.lock);
 }
 
@@ -238,7 +287,7 @@ static int hisi_trng_del_from_list(struct hisi_trng *trng)
 	int ret = -EBUSY;
 
 	mutex_lock(&trng_devices.lock);
-	if (!trng->is_used) {
+	if (!trng->ctx_num) {
 		list_del(&trng->list);
 		ret = 0;
 	}
@@ -262,7 +311,9 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	if (IS_ERR(trng->base))
 		return PTR_ERR(trng->base);
 
-	trng->is_used = false;
+	trng->ctx_num = 0;
+	trng->random_bytes = SW_MAX_RANDOM_BYTES;
+	mutex_init(&trng->lock);
 	trng->ver = readl(trng->base + HISI_TRNG_VERSION);
 	if (!trng_devices.is_init) {
 		INIT_LIST_HEAD(&trng_devices.list);
-- 
2.51.0

