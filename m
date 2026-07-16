Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEE8306754;
	Thu, 16 Jul 2026 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211234; cv=none; b=DoFHsEvj3+NAkBeoJp9XtCPKv8s5wf5ppQub5T8HQVwfYfQFRZYFEl4QU+xhAe0yMyzdwS6Ra0Yk0NZv+kh83+26Z6u+p6D8pYoulprtSkq7XiwAlC19gNSaTbh/Fm7GyF6LzfdB9upt0EeY2tZLcm72eOFbshNQxVaT6sJwfgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211234; c=relaxed/simple;
	bh=KMIoiVTQ+LUWqZgeIhoFZoxewPLYKfcONtfGLwTYmcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVXvx5MsiwIdBaye91OWstOZbLgGiRtae/RvDLvNoE+9lllf078Y82EgoLgEn6ezTFm2LdRSFmNEqHK2qkh6C8XMTCgTsgwgXnUt4u4oKffsEbHN3pqv0uTH2xVSYpbf9t/NbXZkHRcsj8z6ZJpfhsjXERydrNzHW29HaNNrpsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNbNx8Fp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNbNx8Fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790711F000E9;
	Thu, 16 Jul 2026 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211233;
	bh=UvjkDmf2V0NItd5jtIT63h7SYedqRnVpzoLJIni1w/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNbNx8FpQ1tLCa6HLColcltfK5VoNKaCBEDV2LdTd/apnpBG4gz6JVqfklcdQSPG8
	 FdnxW6Ew48pHkif/ebwEMPHzTdnw8YnYgHX6SgAaUGSyEfHlXVU5RBbJqzGSd3JUiT
	 itts1woI52X3w8x32dj45Bym9qo7Y0/p7FJIsMGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Christian Lamparter <chunkeey@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 350/480] crypto: crypto4xx - Remove insecure and unused rng_alg
Date: Thu, 16 Jul 2026 15:31:37 +0200
Message-ID: <20260716133052.379144256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 7811ec9e973d2c9e465083699f0c8240b98cb8c4 upstream.

Remove crypto4xx_rng, as it is insecure and unused:

- It has only a 64-bit security strength, which is highly inadequate.
  This can be seen by the fact that crypto4xx_hw_init() seeds it with
  only 64 bits of entropy, and the fact that the original commit
  mentions that it implements ANSI X9.17 Annex C.

  Another issue was that this driver didn't implement the crypto_rng API
  correctly, as crypto4xx_prng_generate() didn't return 0 on success.

- No user of this code is known.  It's usable only theoretically via the
  "rng" algorithm type of AF_ALG.  But userspace actually just uses the
  actual Linux RNG (/dev/random etc) instead.  And rng_algs don't
  contribute entropy to the actual Linux RNG either.  (This may have
  been confused with hwrng, which does contribute entropy.)

Fixes: d072bfa48853 ("crypto: crypto4xx - add prng crypto support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/amcc/crypto4xx_core.c    |   88 --------------------------------
 drivers/crypto/amcc/crypto4xx_core.h    |    4 -
 drivers/crypto/amcc/crypto4xx_reg_def.h |   11 ----
 3 files changed, 103 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -31,11 +31,9 @@
 #include <crypto/ctr.h>
 #include <crypto/gcm.h>
 #include <crypto/sha1.h>
-#include <crypto/rng.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
 #include <crypto/internal/aead.h>
-#include <crypto/internal/rng.h>
 #include <crypto/internal/skcipher.h>
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_core.h"
@@ -986,10 +984,6 @@ static int crypto4xx_register_alg(struct
 			rc = crypto_register_aead(&alg->alg.u.aead);
 			break;
 
-		case CRYPTO_ALG_TYPE_RNG:
-			rc = crypto_register_rng(&alg->alg.u.rng);
-			break;
-
 		default:
 			rc = crypto_register_skcipher(&alg->alg.u.cipher);
 			break;
@@ -1015,10 +1009,6 @@ static void crypto4xx_unregister_alg(str
 			crypto_unregister_aead(&alg->alg.u.aead);
 			break;
 
-		case CRYPTO_ALG_TYPE_RNG:
-			crypto_unregister_rng(&alg->alg.u.rng);
-			break;
-
 		default:
 			crypto_unregister_skcipher(&alg->alg.u.cipher);
 		}
@@ -1077,69 +1067,6 @@ static irqreturn_t crypto4xx_ce_interrup
 		PPC4XX_TMO_ERR_INT);
 }
 
-static int ppc4xx_prng_data_read(struct crypto4xx_device *dev,
-				 u8 *data, unsigned int max)
-{
-	unsigned int i, curr = 0;
-	u32 val[2];
-
-	do {
-		/* trigger PRN generation */
-		writel(PPC4XX_PRNG_CTRL_AUTO_EN,
-		       dev->ce_base + CRYPTO4XX_PRNG_CTRL);
-
-		for (i = 0; i < 1024; i++) {
-			/* usually 19 iterations are enough */
-			if ((readl(dev->ce_base + CRYPTO4XX_PRNG_STAT) &
-			     CRYPTO4XX_PRNG_STAT_BUSY))
-				continue;
-
-			val[0] = readl_be(dev->ce_base + CRYPTO4XX_PRNG_RES_0);
-			val[1] = readl_be(dev->ce_base + CRYPTO4XX_PRNG_RES_1);
-			break;
-		}
-		if (i == 1024)
-			return -ETIMEDOUT;
-
-		if ((max - curr) >= 8) {
-			memcpy(data, &val, 8);
-			data += 8;
-			curr += 8;
-		} else {
-			/* copy only remaining bytes */
-			memcpy(data, &val, max - curr);
-			break;
-		}
-	} while (curr < max);
-
-	return curr;
-}
-
-static int crypto4xx_prng_generate(struct crypto_rng *tfm,
-				   const u8 *src, unsigned int slen,
-				   u8 *dstn, unsigned int dlen)
-{
-	struct rng_alg *alg = crypto_rng_alg(tfm);
-	struct crypto4xx_alg *amcc_alg;
-	struct crypto4xx_device *dev;
-	int ret;
-
-	amcc_alg = container_of(alg, struct crypto4xx_alg, alg.u.rng);
-	dev = amcc_alg->dev;
-
-	mutex_lock(&dev->core_dev->rng_lock);
-	ret = ppc4xx_prng_data_read(dev, dstn, dlen);
-	mutex_unlock(&dev->core_dev->rng_lock);
-	return ret;
-}
-
-
-static int crypto4xx_prng_seed(struct crypto_rng *tfm, const u8 *seed,
-			unsigned int slen)
-{
-	return 0;
-}
-
 /*
  * Supported Crypto Algorithms
  */
@@ -1269,18 +1196,6 @@ static struct crypto4xx_alg_common crypt
 			.cra_module	= THIS_MODULE,
 		},
 	} },
-	{ .type = CRYPTO_ALG_TYPE_RNG, .u.rng = {
-		.base = {
-			.cra_name		= "stdrng",
-			.cra_driver_name        = "crypto4xx_rng",
-			.cra_priority		= 300,
-			.cra_ctxsize		= 0,
-			.cra_module		= THIS_MODULE,
-		},
-		.generate               = crypto4xx_prng_generate,
-		.seed                   = crypto4xx_prng_seed,
-		.seedsize               = 0,
-	} },
 };
 
 /*
@@ -1354,9 +1269,6 @@ static int crypto4xx_probe(struct platfo
 	core_dev->dev->core_dev = core_dev;
 	core_dev->dev->is_revb = is_revb;
 	core_dev->device = dev;
-	rc = devm_mutex_init(&ofdev->dev, &core_dev->rng_lock);
-	if (rc)
-		return rc;
 	spin_lock_init(&core_dev->lock);
 	INIT_LIST_HEAD(&core_dev->dev->alg_list);
 	ratelimit_default_init(&core_dev->dev->aead_ratelimit);
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -14,10 +14,8 @@
 #define __CRYPTO4XX_CORE_H__
 
 #include <linux/ratelimit.h>
-#include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <crypto/internal/aead.h>
-#include <crypto/internal/rng.h>
 #include <crypto/internal/skcipher.h>
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_sa.h"
@@ -111,7 +109,6 @@ struct crypto4xx_core_device {
 	u32 irq;
 	struct tasklet_struct tasklet;
 	spinlock_t lock;
-	struct mutex rng_lock;
 };
 
 struct crypto4xx_ctx {
@@ -135,7 +132,6 @@ struct crypto4xx_alg_common {
 	union {
 		struct skcipher_alg cipher;
 		struct aead_alg aead;
-		struct rng_alg rng;
 	} u;
 };
 
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -90,20 +90,9 @@
 #define CRYPTO4XX_BYTE_ORDER_CFG 		0x000600d8
 #define CRYPTO4XX_ENDIAN_CFG			0x000600d8
 
-#define CRYPTO4XX_PRNG_STAT			0x00070000
-#define CRYPTO4XX_PRNG_STAT_BUSY		0x1
 #define CRYPTO4XX_PRNG_CTRL			0x00070004
 #define CRYPTO4XX_PRNG_SEED_L			0x00070008
 #define CRYPTO4XX_PRNG_SEED_H			0x0007000c
-
-#define CRYPTO4XX_PRNG_RES_0			0x00070020
-#define CRYPTO4XX_PRNG_RES_1			0x00070024
-#define CRYPTO4XX_PRNG_RES_2			0x00070028
-#define CRYPTO4XX_PRNG_RES_3			0x0007002C
-
-#define CRYPTO4XX_PRNG_LFSR_L			0x00070030
-#define CRYPTO4XX_PRNG_LFSR_H			0x00070034
-
 /*
  * Initialize CRYPTO ENGINE registers, and memory bases.
  */


