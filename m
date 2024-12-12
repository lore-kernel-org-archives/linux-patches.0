Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56391218592;
	Thu, 12 Dec 2024 16:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020032; cv=none; b=tvPAUn831KW58oNKmt6AUzzZZcRitWgW6HDijToXHa4tIIUpxoij+YEi6J4jI5yPneu3akqqMUveL8s5EV3PK9yBDYcUw2SBtDYfcJ5HA3OUbNusToDJ1cF0DopEX0UAL1pYVfWIreQTwl7OBZ2Qoc4bkeVOOyVtVc+CxVuAKeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020032; c=relaxed/simple;
	bh=Z5OpGX3JcheUDWtVG42vW7XQG/m5U0gNjtSeuJ4s2ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr8QgAWEMbws9Otx0H3hPji9i7VQFFiu4RvRsP79Vffjusqv+Bo1KSzchxGr+9TY5JvjHg8jjwrpM5MQbhQM9ww2PQcQd4CS6NHmC1ENlqtmQ2CJ1B9/uFdbxFtqynjk6tcv8d1mAKbjWmuoRQhWnJbO+T5vT3UN+QNIjeZEsOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oU8i0OaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oU8i0OaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EFBC4CECE;
	Thu, 12 Dec 2024 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020032;
	bh=Z5OpGX3JcheUDWtVG42vW7XQG/m5U0gNjtSeuJ4s2ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oU8i0OaU47PbQoin6wHWKwSubB3DRF12chyz3aKMh3KyGe1Nn0NZRRsXkc/ht/eN+
	 ylGQZd/9ZPLotXgq0M8lVD1fZvEawJGl11mOlYYv/PVL5g5mZ3/YwO8ftcuYnSFQOC
	 jCirHnh50D39TqSRNhBBicFz7sOxekahj0Uri2iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Simon Horman <simon.horman@corigine.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 320/772] crypto: api - Add crypto_clone_tfm
Date: Thu, 12 Dec 2024 15:54:25 +0100
Message-ID: <20241212144403.123258296@linuxfoundation.org>
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

[ Upstream commit 3c3a24cb0ae46c9c45e4ce2272f84f0504831f59 ]

This patch adds the helper crypto_clone_tfm.  The purpose is to
allocate a tfm object with GFP_ATOMIC.  As we cannot sleep, the
object has to be cloned from an existing tfm object.

This allows code paths that cannot otherwise allocate a crypto_tfm
object to do so.  Once a new tfm has been obtained its key could
then be changed without impacting other users.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 1465036b10be ("llc: Improve setsockopt() handling of malformed user input")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/api.c      | 59 +++++++++++++++++++++++++++++++++++++++--------
 crypto/internal.h |  2 ++
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index c58774586d9fb..4308b1c8ca2ea 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -489,28 +489,44 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_base);
 
-void *crypto_create_tfm_node(struct crypto_alg *alg,
-			const struct crypto_type *frontend,
-			int node)
+static void *crypto_alloc_tfmmem(struct crypto_alg *alg,
+				 const struct crypto_type *frontend, int node,
+				 gfp_t gfp)
 {
-	char *mem;
-	struct crypto_tfm *tfm = NULL;
+	struct crypto_tfm *tfm;
 	unsigned int tfmsize;
 	unsigned int total;
-	int err = -ENOMEM;
+	char *mem;
 
 	tfmsize = frontend->tfmsize;
 	total = tfmsize + sizeof(*tfm) + frontend->extsize(alg);
 
-	mem = kzalloc_node(total, GFP_KERNEL, node);
+	mem = kzalloc_node(total, gfp, node);
 	if (mem == NULL)
-		goto out_err;
+		return ERR_PTR(-ENOMEM);
 
 	tfm = (struct crypto_tfm *)(mem + tfmsize);
 	tfm->__crt_alg = alg;
 	tfm->node = node;
 	refcount_set(&tfm->refcnt, 1);
 
+	return mem;
+}
+
+void *crypto_create_tfm_node(struct crypto_alg *alg,
+			     const struct crypto_type *frontend,
+			     int node)
+{
+	struct crypto_tfm *tfm;
+	char *mem;
+	int err;
+
+	mem = crypto_alloc_tfmmem(alg, frontend, node, GFP_KERNEL);
+	if (IS_ERR(mem))
+		goto out;
+
+	tfm = (struct crypto_tfm *)(mem + frontend->tfmsize);
+
 	err = frontend->init_tfm(tfm);
 	if (err)
 		goto out_free_tfm;
@@ -526,13 +542,38 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 	if (err == -EAGAIN)
 		crypto_shoot_alg(alg);
 	kfree(mem);
-out_err:
 	mem = ERR_PTR(err);
 out:
 	return mem;
 }
 EXPORT_SYMBOL_GPL(crypto_create_tfm_node);
 
+void *crypto_clone_tfm(const struct crypto_type *frontend,
+		       struct crypto_tfm *otfm)
+{
+	struct crypto_alg *alg = otfm->__crt_alg;
+	struct crypto_tfm *tfm;
+	char *mem;
+
+	mem = ERR_PTR(-ESTALE);
+	if (unlikely(!crypto_mod_get(alg)))
+		goto out;
+
+	mem = crypto_alloc_tfmmem(alg, frontend, otfm->node, GFP_ATOMIC);
+	if (IS_ERR(mem)) {
+		crypto_mod_put(alg);
+		goto out;
+	}
+
+	tfm = (struct crypto_tfm *)(mem + frontend->tfmsize);
+	tfm->crt_flags = otfm->crt_flags;
+	tfm->exit = otfm->exit;
+
+out:
+	return mem;
+}
+EXPORT_SYMBOL_GPL(crypto_clone_tfm);
+
 struct crypto_alg *crypto_find_alg(const char *alg_name,
 				   const struct crypto_type *frontend,
 				   u32 type, u32 mask)
diff --git a/crypto/internal.h b/crypto/internal.h
index 521bc021c54bc..e81cd7594b35e 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -86,6 +86,8 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm_node(struct crypto_alg *alg,
 			const struct crypto_type *frontend, int node);
+void *crypto_clone_tfm(const struct crypto_type *frontend,
+		       struct crypto_tfm *otfm);
 
 static inline void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend)
-- 
2.43.0



