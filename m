Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02167237FFC;
	Thu, 12 Dec 2024 16:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019880; cv=none; b=Zm5/2jelDccIenTPouFxGAOrpKSPEOLKUbpkAkipKPa/atiiZHb1lMD8U5iop3NYNEcRpN7/ZAcVe4P75daZ/krIvUO6WEBmRGe3mivaszlUN0cXGtTJoK3Nv5Hl6u9cKoIHGavHcjPBV3VxRb9o5NyyRj7lgMwfjExieZSB/WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019880; c=relaxed/simple;
	bh=rYkOVz8NFVb1ZT9Anxh1NgqsH+Ur/ibFf3PcDiOnshM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xv5g8Hjmc0lW+zxaq2ooQbu03PBhPxb/PU317br3ixrWWkBfYHcDHHY0CbRr/nij1iK1hVR5DThoTfT/Qrsqc+Oi5SgKpUE6c2z1javyxUvSYP3aN/uiCDkqWH8eXkSLQtduz71hJEP7SveQRXVV+/RxbjNPxm8QoF1hycs/etg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckjrkX+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckjrkX+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D4BC4CECE;
	Thu, 12 Dec 2024 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019877;
	bh=rYkOVz8NFVb1ZT9Anxh1NgqsH+Ur/ibFf3PcDiOnshM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckjrkX+Y76gCmqGbrq5zLFK2yqtgGf6i7FgzBbz35jRnQBCBJbOmUgXaBFTXmsfTd
	 VQ3pu7bcPcx6OBrXGNCo7SwXGfupBxDXk/9COUn26t6+qZkpQm264qT0bJwz+a2SA4
	 pBDhQ6NXQA9Tc5yFiUXdpcf7RvUiJY6HctwE7DoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Simon Horman <simon.horman@corigine.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 319/772] crypto: api - Add crypto_tfm_get
Date: Thu, 12 Dec 2024 15:54:24 +0100
Message-ID: <20241212144403.083796496@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ae131f4970f0778f35ed06aeb15bde2fbc1d9619 ]

Add a crypto_tfm_get interface to allow tfm objects to be shared.
They can still be freed in the usual way.

This should only be done with tfm objects with no keys.  You must
also not modify the tfm flags in any way once it becomes shared.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 1465036b10be ("llc: Improve setsockopt() handling of malformed user input")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/api.c           | 4 ++++
 crypto/internal.h      | 6 ++++++
 include/linux/crypto.h | 1 +
 3 files changed, 11 insertions(+)

diff --git a/crypto/api.c b/crypto/api.c
index 64f2d365a8e94..c58774586d9fb 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -409,6 +409,7 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 		goto out_err;
 
 	tfm->__crt_alg = alg;
+	refcount_set(&tfm->refcnt, 1);
 
 	err = crypto_init_ops(tfm, type, mask);
 	if (err)
@@ -508,6 +509,7 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 	tfm = (struct crypto_tfm *)(mem + tfmsize);
 	tfm->__crt_alg = alg;
 	tfm->node = node;
+	refcount_set(&tfm->refcnt, 1);
 
 	err = frontend->init_tfm(tfm);
 	if (err)
@@ -620,6 +622,8 @@ void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 	if (IS_ERR_OR_NULL(mem))
 		return;
 
+	if (!refcount_dec_and_test(&tfm->refcnt))
+		return;
 	alg = tfm->__crt_alg;
 
 	if (!tfm->exit && alg->cra_exit)
diff --git a/crypto/internal.h b/crypto/internal.h
index c08385571853e..521bc021c54bc 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -10,6 +10,7 @@
 
 #include <crypto/algapi.h>
 #include <linux/completion.h>
+#include <linux/err.h>
 #include <linux/jump_label.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -166,5 +167,10 @@ static inline int crypto_is_test_larval(struct crypto_larval *larval)
 	return larval->alg.cra_driver_name[0];
 }
 
+static inline struct crypto_tfm *crypto_tfm_get(struct crypto_tfm *tfm)
+{
+	return refcount_inc_not_zero(&tfm->refcnt) ? tfm : ERR_PTR(-EOVERFLOW);
+}
+
 #endif	/* _CRYPTO_INTERNAL_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e3c4be29aaccb..d354a2a7ac5ff 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -642,6 +642,7 @@ int crypto_has_alg(const char *name, u32 type, u32 mask);
  */
 
 struct crypto_tfm {
+	refcount_t refcnt;
 
 	u32 crt_flags;
 
-- 
2.43.0



