Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882BC31D381;
	Thu, 16 Jul 2026 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211381; cv=none; b=RrcuGUwrQKQN3/2sGBNQ1chwC6eTKFEboTb6EvS5TwR+OxG4mc/QSgfuIQAzJIe5mbsufOSU2YS+92YdLM1/ru0O4pLmZhYzqoFinTDBnagGHnLpy0/ZMN8LJ479DiGkZXPvA79fikUaQxpU6UT11JKzFXWv7R8j5QDSWpGOWiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211381; c=relaxed/simple;
	bh=Kwj6ic09nk0cetNDWFCVUmWrKU3yioBJ7gZkFx96qwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8Q8m1OlPHj2/TeXcZfEePiz72jHVb8hFcoH5ekSkcIHg9mvsoRu3zFlvWtpLXcFyqnLVfvf/OgvQhCwS/WGfVXSqheiXsSMJcc7Z5psaTp2r9QrABO6+kf+L5mVcaBUy1WsEk0Z985RvZ/pBAYdsx3117f4byKHm1msjV9R8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zToIzO+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zToIzO+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC66A1F000E9;
	Thu, 16 Jul 2026 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211380;
	bh=j8Ih4SHiaIYnuvLO7BEoqhuh6R1g4xVgfh1eJVps8Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zToIzO+85OLZ4FD5PyrEgLt9csXl3/H9qCeD9uDx0Ja+sCKlZK3gaKjZ9F0yBx1DS
	 IFu6N5kF5FAIZzNZfCkD3uBgUltPfo2WnrE5fbilbxV/6BGNeoa2UP91O7dho7VaJN
	 ltu86b36NRxkLlHF7TSrTLvLz/lkoag5A35C23/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 405/480] crypto: loongson - Remove broken and unused loongson-rng
Date: Thu, 16 Jul 2026 15:32:32 +0200
Message-ID: <20260716133053.572189774@linuxfoundation.org>
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

commit af3d1bb9a09daf928fc3f173689fb7904d6a6d4f upstream.

The loongson-rng rng_alg has several vulnerabilities, including not
providing forward security, and a use-after-free bug due to the use of
wait_for_completion_interruptible().

Meanwhile, the rng_alg framework doesn't really have any purpose in the
first place other than to access the software algorithms crypto/drbg.c
and crypto/jitterentropy.c.  Hardware-specific rng_algs have no
in-kernel user, and unlike hwrng there's no feed into the actual Linux
RNG.  As such, there's really no point to this code.  There are of
course other rng_alg drivers that are similarly unused, but they're
similarly in the process of being phased out, e.g.
https://lore.kernel.org/r/20260529193648.18172-1-ebiggers@kernel.org and
https://lore.kernel.org/r/20260529220430.34135-1-ebiggers@kernel.org

Given that, there's no point in fixing forward these vulnerabilities,
and it makes much more sense to simply roll back the addition of this
driver.  If this platform provides TRNG (not PRNG) functionality, it
could make sense to add a hwrng driver, but it would be quite different.

Link: https://lore.kernel.org/linux-crypto/20260525145939.GC2018@quark/
Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS                            |    1 
 drivers/crypto/Kconfig                 |    1 
 drivers/crypto/Makefile                |    1 
 drivers/crypto/loongson/Kconfig        |    6 
 drivers/crypto/loongson/Makefile       |    1 
 drivers/crypto/loongson/loongson-rng.c |  209 ---------------------------------
 6 files changed, 219 deletions(-)
 delete mode 100644 drivers/crypto/loongson/Kconfig
 delete mode 100644 drivers/crypto/loongson/Makefile
 delete mode 100644 drivers/crypto/loongson/loongson-rng.c

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14617,7 +14617,6 @@ M:	Qunqin Zhao <zhaoqunqin@loongson.cn>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/char/tpm/tpm_loongson.c
-F:	drivers/crypto/loongson/
 F:	drivers/mfd/loongson-se.c
 F:	include/linux/mfd/loongson-se.h
 
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -852,7 +852,6 @@ config CRYPTO_DEV_CCREE
 	  If unsure say Y.
 
 source "drivers/crypto/hisilicon/Kconfig"
-source "drivers/crypto/loongson/Kconfig"
 
 source "drivers/crypto/amlogic/Kconfig"
 
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -44,7 +44,6 @@ obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
 obj-y += hisilicon/
-obj-y += loongson/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
 obj-y += starfive/
--- a/drivers/crypto/loongson/Kconfig
+++ /dev/null
@@ -1,6 +0,0 @@
-config CRYPTO_DEV_LOONGSON_RNG
-	tristate "Support for Loongson RNG Driver"
-	depends on MFD_LOONGSON_SE
-	select CRYPTO_RNG
-	help
-	  Support for Loongson RNG Driver.
--- a/drivers/crypto/loongson/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_CRYPTO_DEV_LOONGSON_RNG)  += loongson-rng.o
--- a/drivers/crypto/loongson/loongson-rng.c
+++ /dev/null
@@ -1,209 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2019 HiSilicon Limited. */
-/* Copyright (c) 2025 Loongson Technology Corporation Limited. */
-
-#include <linux/crypto.h>
-#include <linux/err.h>
-#include <linux/hw_random.h>
-#include <linux/io.h>
-#include <linux/iopoll.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/mfd/loongson-se.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/platform_device.h>
-#include <linux/random.h>
-#include <crypto/internal/rng.h>
-
-#define SE_SEED_SIZE 32
-
-struct loongson_rng_list {
-	struct mutex lock;
-	struct list_head list;
-	int registered;
-};
-
-struct loongson_rng {
-	u32 used;
-	struct loongson_se_engine *engine;
-	struct list_head list;
-	struct mutex lock;
-};
-
-struct loongson_rng_ctx {
-	struct loongson_rng *rng;
-};
-
-struct loongson_rng_cmd {
-	u32 cmd_id;
-	union {
-		u32 len;
-		u32 ret;
-	} u;
-	u32 seed_off;
-	u32 out_off;
-	u32 pad[4];
-};
-
-static struct loongson_rng_list rng_devices = {
-	.lock = __MUTEX_INITIALIZER(rng_devices.lock),
-	.list = LIST_HEAD_INIT(rng_devices.list),
-};
-
-static int loongson_rng_generate(struct crypto_rng *tfm, const u8 *src,
-			  unsigned int slen, u8 *dstn, unsigned int dlen)
-{
-	struct loongson_rng_ctx *ctx = crypto_rng_ctx(tfm);
-	struct loongson_rng *rng = ctx->rng;
-	struct loongson_rng_cmd *cmd = rng->engine->command;
-	int err, len;
-
-	mutex_lock(&rng->lock);
-	cmd->seed_off = 0;
-	do {
-		len = min(dlen, rng->engine->buffer_size);
-		cmd = rng->engine->command;
-		cmd->u.len = len;
-		err = loongson_se_send_engine_cmd(rng->engine);
-		if (err)
-			break;
-
-		cmd = rng->engine->command_ret;
-		if (cmd->u.ret) {
-			err = -EIO;
-			break;
-		}
-
-		memcpy(dstn, rng->engine->data_buffer, len);
-		dlen -= len;
-		dstn += len;
-	} while (dlen > 0);
-	mutex_unlock(&rng->lock);
-
-	return err;
-}
-
-static int loongson_rng_init(struct crypto_tfm *tfm)
-{
-	struct loongson_rng_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct loongson_rng *rng;
-	u32 min_used = U32_MAX;
-
-	mutex_lock(&rng_devices.lock);
-	list_for_each_entry(rng, &rng_devices.list, list) {
-		if (rng->used < min_used) {
-			ctx->rng = rng;
-			min_used = rng->used;
-		}
-	}
-	ctx->rng->used++;
-	mutex_unlock(&rng_devices.lock);
-
-	return 0;
-}
-
-static void loongson_rng_exit(struct crypto_tfm *tfm)
-{
-	struct loongson_rng_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	mutex_lock(&rng_devices.lock);
-	ctx->rng->used--;
-	mutex_unlock(&rng_devices.lock);
-}
-
-static int loongson_rng_seed(struct crypto_rng *tfm, const u8 *seed,
-			     unsigned int slen)
-{
-	struct loongson_rng_ctx *ctx = crypto_rng_ctx(tfm);
-	struct loongson_rng *rng = ctx->rng;
-	struct loongson_rng_cmd *cmd;
-	int err;
-
-	if (slen < SE_SEED_SIZE)
-		return -EINVAL;
-
-	slen = min(slen, rng->engine->buffer_size);
-
-	mutex_lock(&rng->lock);
-	cmd = rng->engine->command;
-	cmd->u.len = slen;
-	cmd->seed_off = rng->engine->buffer_off;
-	memcpy(rng->engine->data_buffer, seed, slen);
-	err = loongson_se_send_engine_cmd(rng->engine);
-	if (err)
-		goto out;
-
-	cmd = rng->engine->command_ret;
-	if (cmd->u.ret)
-		err = -EIO;
-out:
-	mutex_unlock(&rng->lock);
-
-	return err;
-}
-
-static struct rng_alg loongson_rng_alg = {
-	.generate = loongson_rng_generate,
-	.seed =	loongson_rng_seed,
-	.seedsize = SE_SEED_SIZE,
-	.base = {
-		.cra_name = "stdrng",
-		.cra_driver_name = "loongson_stdrng",
-		.cra_priority = 300,
-		.cra_ctxsize = sizeof(struct loongson_rng_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_init = loongson_rng_init,
-		.cra_exit = loongson_rng_exit,
-	},
-};
-
-static int loongson_rng_probe(struct platform_device *pdev)
-{
-	struct loongson_rng_cmd *cmd;
-	struct loongson_rng *rng;
-	int ret = 0;
-
-	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
-	if (!rng)
-		return -ENOMEM;
-
-	rng->engine = loongson_se_init_engine(pdev->dev.parent, SE_ENGINE_RNG);
-	if (!rng->engine)
-		return -ENODEV;
-	cmd = rng->engine->command;
-	cmd->cmd_id = SE_CMD_RNG;
-	cmd->out_off = rng->engine->buffer_off;
-	mutex_init(&rng->lock);
-
-	mutex_lock(&rng_devices.lock);
-
-	if (!rng_devices.registered) {
-		ret = crypto_register_rng(&loongson_rng_alg);
-		if (ret) {
-			dev_err(&pdev->dev, "failed to register crypto(%d)\n", ret);
-			goto out;
-		}
-		rng_devices.registered = 1;
-	}
-
-	list_add_tail(&rng->list, &rng_devices.list);
-out:
-	mutex_unlock(&rng_devices.lock);
-
-	return ret;
-}
-
-static struct platform_driver loongson_rng_driver = {
-	.probe		= loongson_rng_probe,
-	.driver		= {
-		.name	= "loongson-rng",
-	},
-};
-module_platform_driver(loongson_rng_driver);
-
-MODULE_ALIAS("platform:loongson-rng");
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Yinggang Gu <guyinggang@loongson.cn>");
-MODULE_AUTHOR("Qunqin Zhao <zhaoqunqin@loongson.cn>");
-MODULE_DESCRIPTION("Loongson Random Number Generator driver");


