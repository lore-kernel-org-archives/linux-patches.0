Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7FC40802A;
	Wed, 20 May 2026 18:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303010; cv=none; b=sGJZA0NlpUMfdmLLtc8a34M3DkhIot7Pj7YoG0PBDHBOqOo+uk/2aGH7erU8H46O0O/CWMSQzmqeUT7M0EBq0P8+hpepcziGykVaixy87Q8fRYBKqJF3UAd1eX3Bw4dedd4Gky17wFry5k1FPUf+UrffRwsBOSUQEDDIZVHjp8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303010; c=relaxed/simple;
	bh=nOYY57mc98ZMvSC5UpccqmjbQmiIeZIhVZXSpkdutSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cv60zXD9Ofe+uTI+6wvLwnYaVCBSsDSH5kUQxl2k8zTEv363W9l4fP7EXRl7kbxEdDCDYu3oB/0M0F8DQHtU3q1ETXJB3ddo7TlXwdRNbcRigZLlKtBnlQJ+Iqzvv3628lLhvkqSMAD/EAmBP7B2WrEqhj7cUiCdlIubKlp9/WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pe2cUmbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pe2cUmbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0696A1F000E9;
	Wed, 20 May 2026 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303006;
	bh=zpInWXrG18iHPd5RdwxAP7K3nD2LroyKoneZJ4IIOPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pe2cUmbATccWKfdmIUV5Qz0u3h8YUoHkDIUaf/6frhq+yTgORANzI68ojmmtw2Wws
	 od7UOwn5Wq89Uq2zBgMplsNK/CYkfTqLZ6DsDvUNFfJUA6Yu1lubyvMp7kV9WC0jkr
	 9oLQ1act80ik8IxAm0hFXpCi7oCSrug2rHSB2dAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 441/508] Revert "crypto: nx - Migrate to scomp API"
Date: Wed, 20 May 2026 18:24:24 +0200
Message-ID: <20260520162108.154534848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 268ae55a4c4fbff3ff54f92a4642f497da814f49.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842.c            | 33 ++++++++++++---------------
 drivers/crypto/nx/nx-842.h            | 15 ++++++------
 drivers/crypto/nx/nx-common-powernv.c | 31 +++++++++++++------------
 drivers/crypto/nx/nx-common-pseries.c | 33 ++++++++++++++-------------
 4 files changed, 54 insertions(+), 58 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index b950fcce8a9be..82214cde2bcd9 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -101,13 +101,9 @@ static int update_param(struct nx842_crypto_param *p,
 	return 0;
 }
 
-void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
+int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
 {
-	struct nx842_crypto_ctx *ctx;
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return ERR_PTR(-ENOMEM);
+	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	spin_lock_init(&ctx->lock);
 	ctx->driver = driver;
@@ -118,23 +114,22 @@ void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
 		kfree(ctx->wmem);
 		free_page((unsigned long)ctx->sbounce);
 		free_page((unsigned long)ctx->dbounce);
-		kfree(ctx);
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
-	return ctx;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(nx842_crypto_alloc_ctx);
+EXPORT_SYMBOL_GPL(nx842_crypto_init);
 
-void nx842_crypto_free_ctx(void *p)
+void nx842_crypto_exit(struct crypto_tfm *tfm)
 {
-	struct nx842_crypto_ctx *ctx = p;
+	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	kfree(ctx->wmem);
 	free_page((unsigned long)ctx->sbounce);
 	free_page((unsigned long)ctx->dbounce);
 }
-EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
+EXPORT_SYMBOL_GPL(nx842_crypto_exit);
 
 static void check_constraints(struct nx842_constraints *c)
 {
@@ -251,11 +246,11 @@ static int compress(struct nx842_crypto_ctx *ctx,
 	return update_param(p, slen, dskip + dlen);
 }
 
-int nx842_crypto_compress(struct crypto_scomp *tfm,
+int nx842_crypto_compress(struct crypto_tfm *tfm,
 			  const u8 *src, unsigned int slen,
-			  u8 *dst, unsigned int *dlen, void *pctx)
+			  u8 *dst, unsigned int *dlen)
 {
-	struct nx842_crypto_ctx *ctx = pctx;
+	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct nx842_crypto_header *hdr =
 				container_of(&ctx->header,
 					     struct nx842_crypto_header, hdr);
@@ -436,11 +431,11 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 	return update_param(p, slen + padding, dlen);
 }
 
-int nx842_crypto_decompress(struct crypto_scomp *tfm,
+int nx842_crypto_decompress(struct crypto_tfm *tfm,
 			    const u8 *src, unsigned int slen,
-			    u8 *dst, unsigned int *dlen, void *pctx)
+			    u8 *dst, unsigned int *dlen)
 {
-	struct nx842_crypto_ctx *ctx = pctx;
+	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct nx842_crypto_header *hdr;
 	struct nx842_crypto_param p;
 	struct nx842_constraints c = *ctx->driver->constraints;
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index 58137ffd3835b..25fa70b2112cf 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -3,6 +3,7 @@
 #ifndef __NX_842_H__
 #define __NX_842_H__
 
+#include <crypto/algapi.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -100,8 +101,6 @@
 #define LEN_ON_SIZE(pa, size)	((size) - ((pa) & ((size) - 1)))
 #define LEN_ON_PAGE(pa)		LEN_ON_SIZE(pa, PAGE_SIZE)
 
-struct crypto_scomp;
-
 static inline unsigned long nx842_get_pa(void *addr)
 {
 	if (!is_vmalloc_addr(addr))
@@ -180,13 +179,13 @@ struct nx842_crypto_ctx {
 	struct nx842_driver *driver;
 };
 
-void *nx842_crypto_alloc_ctx(struct nx842_driver *driver);
-void nx842_crypto_free_ctx(void *ctx);
-int nx842_crypto_compress(struct crypto_scomp *tfm,
+int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver);
+void nx842_crypto_exit(struct crypto_tfm *tfm);
+int nx842_crypto_compress(struct crypto_tfm *tfm,
 			  const u8 *src, unsigned int slen,
-			  u8 *dst, unsigned int *dlen, void *ctx);
-int nx842_crypto_decompress(struct crypto_scomp *tfm,
+			  u8 *dst, unsigned int *dlen);
+int nx842_crypto_decompress(struct crypto_tfm *tfm,
 			    const u8 *src, unsigned int slen,
-			    u8 *dst, unsigned int *dlen, void *ctx);
+			    u8 *dst, unsigned int *dlen);
 
 #endif /* __NX_842_H__ */
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index fd0a98b2fb1b2..8c859872c1839 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -9,7 +9,6 @@
 
 #include "nx-842.h"
 
-#include <crypto/internal/scompress.h>
 #include <linux/timer.h>
 
 #include <asm/prom.h>
@@ -1032,21 +1031,23 @@ static struct nx842_driver nx842_powernv_driver = {
 	.decompress =	nx842_powernv_decompress,
 };
 
-static void *nx842_powernv_crypto_alloc_ctx(void)
+static int nx842_powernv_crypto_init(struct crypto_tfm *tfm)
 {
-	return nx842_crypto_alloc_ctx(&nx842_powernv_driver);
+	return nx842_crypto_init(tfm, &nx842_powernv_driver);
 }
 
-static struct scomp_alg nx842_powernv_alg = {
-	.base.cra_name		= "842",
-	.base.cra_driver_name	= "842-nx",
-	.base.cra_priority	= 300,
-	.base.cra_module	= THIS_MODULE,
-
-	.alloc_ctx		= nx842_powernv_crypto_alloc_ctx,
-	.free_ctx		= nx842_crypto_free_ctx,
-	.compress		= nx842_crypto_compress,
-	.decompress		= nx842_crypto_decompress,
+static struct crypto_alg nx842_powernv_alg = {
+	.cra_name		= "842",
+	.cra_driver_name	= "842-nx",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_init		= nx842_powernv_crypto_init,
+	.cra_exit		= nx842_crypto_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= nx842_crypto_compress,
+	.coa_decompress		= nx842_crypto_decompress } }
 };
 
 static __init int nx_compress_powernv_init(void)
@@ -1106,7 +1107,7 @@ static __init int nx_compress_powernv_init(void)
 		nx842_powernv_exec = nx842_exec_vas;
 	}
 
-	ret = crypto_register_scomp(&nx842_powernv_alg);
+	ret = crypto_register_alg(&nx842_powernv_alg);
 	if (ret) {
 		nx_delete_coprocs();
 		return ret;
@@ -1127,7 +1128,7 @@ static void __exit nx_compress_powernv_exit(void)
 	if (!nx842_ct)
 		vas_unregister_api_powernv();
 
-	crypto_unregister_scomp(&nx842_powernv_alg);
+	crypto_unregister_alg(&nx842_powernv_alg);
 
 	nx_delete_coprocs();
 }
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 0d26aafd08863..7e98f174f69b9 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -11,7 +11,6 @@
 #include <asm/vio.h>
 #include <asm/hvcall.h>
 #include <asm/vas.h>
-#include <crypto/internal/scompress.h>
 
 #include "nx-842.h"
 #include "nx_csbcpb.h" /* struct nx_csbcpb */
@@ -1009,21 +1008,23 @@ static struct nx842_driver nx842_pseries_driver = {
 	.decompress =	nx842_pseries_decompress,
 };
 
-static void *nx842_pseries_crypto_alloc_ctx(void)
+static int nx842_pseries_crypto_init(struct crypto_tfm *tfm)
 {
-	return nx842_crypto_alloc_ctx(&nx842_pseries_driver);
+	return nx842_crypto_init(tfm, &nx842_pseries_driver);
 }
 
-static struct scomp_alg nx842_pseries_alg = {
-	.base.cra_name		= "842",
-	.base.cra_driver_name	= "842-nx",
-	.base.cra_priority	= 300,
-	.base.cra_module	= THIS_MODULE,
-
-	.alloc_ctx		= nx842_pseries_crypto_alloc_ctx,
-	.free_ctx		= nx842_crypto_free_ctx,
-	.compress		= nx842_crypto_compress,
-	.decompress		= nx842_crypto_decompress,
+static struct crypto_alg nx842_pseries_alg = {
+	.cra_name		= "842",
+	.cra_driver_name	= "842-nx",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_init		= nx842_pseries_crypto_init,
+	.cra_exit		= nx842_crypto_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= nx842_crypto_compress,
+	.coa_decompress		= nx842_crypto_decompress } }
 };
 
 static int nx842_probe(struct vio_dev *viodev,
@@ -1071,7 +1072,7 @@ static int nx842_probe(struct vio_dev *viodev,
 	if (ret)
 		goto error;
 
-	ret = crypto_register_scomp(&nx842_pseries_alg);
+	ret = crypto_register_alg(&nx842_pseries_alg);
 	if (ret) {
 		dev_err(&viodev->dev, "could not register comp alg: %d\n", ret);
 		goto error;
@@ -1119,7 +1120,7 @@ static void nx842_remove(struct vio_dev *viodev)
 	if (caps_feat)
 		sysfs_remove_group(&viodev->dev.kobj, &nxcop_caps_attr_group);
 
-	crypto_unregister_scomp(&nx842_pseries_alg);
+	crypto_unregister_alg(&nx842_pseries_alg);
 
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
@@ -1251,7 +1252,7 @@ static void __exit nx842_pseries_exit(void)
 
 	vas_unregister_api_pseries();
 
-	crypto_unregister_scomp(&nx842_pseries_alg);
+	crypto_unregister_alg(&nx842_pseries_alg);
 
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
-- 
2.53.0



