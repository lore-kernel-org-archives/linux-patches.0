Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2580B3E49F0;
	Tue, 21 Jul 2026 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655405; cv=none; b=RytVwsNhvaqb8iPgaXnbwQwAEIAXqpc7MEWe9e0bbx5cg3he1aJmEwf18Q/HxSzUaqIn/4Kbg1mLYTqBDipcOxPsbH/f1fr814RA2yYQoyqS81RqF/2Y9VIBmCNU59GbJvYYtTG4XWHOlC4DI+/V7PiFugx1MaP0QzkfKcxrRRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655405; c=relaxed/simple;
	bh=t5UkgYvH2fWoa5Hj/QufXrit1IFmq3xxEm5bCctg5bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhoBnudfxz0n7jFtDO6s1MIjhKfZbroCi1uImlM5JE0/X9RWJYBChass7p3WpL5crv7XkW9VqlgPm8E9gJCGc/pdHHWKZ0yjbcKQ3X9q/CdogswWpvGwi2O/4t4I9QhgyY0dfvDHwOsGFFanBhjFtKfy5RuCx/M+feEYydehvfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NB2gD9nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NB2gD9nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD881F000E9;
	Tue, 21 Jul 2026 17:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655404;
	bh=o/uJJjLrcqvjlm0FiLz603HWXRmVfVvaUimmLBlmQSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NB2gD9nn0F4hY+EGwWP8wqh4bNGBWjHzVLHl41OWynfRSYLu/KTXDQh0ZhuQSILaP
	 /1/VnC/SP+W86tETxknm5IMi69dVjRZ4A5JMvo/7NHJaSXiHXlG29mH1kVfrh7W52b
	 wZCjYkEfzZ01jaPsXFlTUL5SWfy7nH2BbW+hMQbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 2069/2077] crypto: xilinx-trng - Remove crypto_rng interface
Date: Tue, 21 Jul 2026 17:29:02 +0200
Message-ID: <20260721152641.502456504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 32b4d29280ed2a991dc196d5845b892acedc63b8 upstream.

Implementing the crypto_rng interface has no purpose, as it isn't used
in practice.  It's being removed from other drivers too.  Just remove
it.  This leaves hwrng, which is actually used.

Tagging with 'Cc stable' due to the bugs that this removes:

  - xtrng_trng_generate() sometimes returned success even when it didn't
    fill in all the bytes.

  - It was possible for xtrng_trng_generate() and
    xtrng_hwrng_trng_read() to run concurrently and interfere with each
    other, as the locking code in xtrng_hwrng_trng_read() was broken.

Fixes: 8979744aca80 ("crypto: xilinx - Add TRNG driver for Versal")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/Kconfig              |    1 
 drivers/crypto/xilinx/xilinx-trng.c |   85 +-----------------------------------
 2 files changed, 4 insertions(+), 82 deletions(-)

--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -721,7 +721,6 @@ config CRYPTO_DEV_XILINX_TRNG
 	tristate "Support for Xilinx True Random Generator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
 	select CRYPTO_DF80090A
-	select CRYPTO_RNG
 	select HW_RANDOM
 	help
 	  Xilinx Versal SoC driver provides kernel-side support for True Random Number
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -6,7 +6,6 @@
 
 #include <linux/bitfield.h>
 #include <linux/clk.h>
-#include <linux/crypto.h>
 #include <linux/delay.h>
 #include <linux/firmware/xlnx-zynqmp.h>
 #include <linux/hw_random.h>
@@ -14,14 +13,12 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <crypto/aes.h>
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/drbg.h>
 #include <crypto/internal/cipher.h>
-#include <crypto/internal/rng.h>
 
 /* TRNG Registers Offsets */
 #define TRNG_STATUS_OFFSET			0x4U
@@ -61,16 +58,9 @@ struct xilinx_rng {
 	struct device *dev;
 	unsigned char *scratchpadbuf;
 	struct aes_enckey *aeskey;
-	struct mutex lock;	/* Protect access to TRNG device */
 	struct hwrng trng;
 };
 
-struct xilinx_rng_ctx {
-	struct xilinx_rng *rng;
-};
-
-static struct xilinx_rng *xilinx_rng_dev;
-
 static void xtrng_readwrite32(void __iomem *addr, u32 mask, u8 value)
 {
 	u32 val;
@@ -246,47 +236,6 @@ static int xtrng_random_bytes_generate(s
 	return nbytes;
 }
 
-static int xtrng_trng_generate(struct crypto_rng *tfm, const u8 *src, u32 slen,
-			       u8 *dst, u32 dlen)
-{
-	struct xilinx_rng_ctx *ctx = crypto_rng_ctx(tfm);
-	int ret;
-
-	mutex_lock(&ctx->rng->lock);
-	ret = xtrng_random_bytes_generate(ctx->rng, dst, dlen, true);
-	mutex_unlock(&ctx->rng->lock);
-
-	return ret < 0 ? ret : 0;
-}
-
-static int xtrng_trng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
-{
-	return 0;
-}
-
-static int xtrng_trng_init(struct crypto_tfm *rtfm)
-{
-	struct xilinx_rng_ctx *ctx = crypto_tfm_ctx(rtfm);
-
-	ctx->rng = xilinx_rng_dev;
-
-	return 0;
-}
-
-static struct rng_alg xtrng_trng_alg = {
-	.generate = xtrng_trng_generate,
-	.seed = xtrng_trng_seed,
-	.seedsize = 0,
-	.base = {
-		.cra_name = "stdrng",
-		.cra_driver_name = "xilinx-trng",
-		.cra_priority = 300,
-		.cra_ctxsize = sizeof(struct xilinx_rng_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_init = xtrng_trng_init,
-	},
-};
-
 static int xtrng_hwrng_trng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
 {
 	u8 buf[TRNG_SEC_STRENGTH_BYTES];
@@ -294,12 +243,6 @@ static int xtrng_hwrng_trng_read(struct
 	int ret = -EINVAL, i = 0;
 
 	rng = container_of(hwrng, struct xilinx_rng, trng);
-	/* Return in case wait not set and lock not available. */
-	if (!mutex_trylock(&rng->lock) && !wait)
-		return 0;
-	else if (!mutex_is_locked(&rng->lock) && wait)
-		mutex_lock(&rng->lock);
-
 	while (i < max) {
 		ret = xtrng_random_bytes_generate(rng, buf, TRNG_SEC_STRENGTH_BYTES, wait);
 		if (ret < 0)
@@ -308,8 +251,6 @@ static int xtrng_hwrng_trng_read(struct
 		memcpy(data + i, buf, min_t(int, ret, (max - i)));
 		i += min_t(int, ret, (max - i));
 	}
-	mutex_unlock(&rng->lock);
-
 	return ret;
 }
 
@@ -355,40 +296,24 @@ static int xtrng_probe(struct platform_d
 
 	sb_size = crypto_drbg_ctr_df_datalen(TRNG_SEED_LEN_BYTES, AES_BLOCK_SIZE);
 	rng->scratchpadbuf = devm_kzalloc(&pdev->dev, sb_size, GFP_KERNEL);
-	if (!rng->scratchpadbuf) {
-		ret = -ENOMEM;
-		goto end;
-	}
+	if (!rng->scratchpadbuf)
+		return -ENOMEM;
 
 	xtrng_trng_reset(rng->rng_base);
 	ret = xtrng_reseed_internal(rng);
 	if (ret) {
 		dev_err(&pdev->dev, "TRNG Seed fail\n");
-		goto end;
-	}
-
-	xilinx_rng_dev = rng;
-	mutex_init(&rng->lock);
-	ret = crypto_register_rng(&xtrng_trng_alg);
-	if (ret) {
-		dev_err(&pdev->dev, "Crypto Random device registration failed: %d\n", ret);
-		goto end;
+		return ret;
 	}
 
 	ret = xtrng_hwrng_register(&rng->trng);
 	if (ret) {
 		dev_err(&pdev->dev, "HWRNG device registration failed: %d\n", ret);
-		goto crypto_rng_free;
+		return ret;
 	}
 	platform_set_drvdata(pdev, rng);
 
 	return 0;
-
-crypto_rng_free:
-	crypto_unregister_rng(&xtrng_trng_alg);
-
-end:
-	return ret;
 }
 
 static void xtrng_remove(struct platform_device *pdev)
@@ -398,13 +323,11 @@ static void xtrng_remove(struct platform
 
 	rng = platform_get_drvdata(pdev);
 	xtrng_hwrng_unregister(&rng->trng);
-	crypto_unregister_rng(&xtrng_trng_alg);
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET, zero,
 				       TRNG_NUM_INIT_REGS);
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_PER_STRNG_OFFSET, zero,
 				       TRNG_NUM_INIT_REGS);
 	xtrng_hold_reset(rng->rng_base);
-	xilinx_rng_dev = NULL;
 }
 
 static const struct of_device_id xtrng_of_match[] = {


