Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1754F3BB690;
	Sat, 17 Oct 2026 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258122; cv=none; b=b4tx3ErYu4rW3VQh7nIswRTytzZ+6rbf0OXIPEqmK0dgQzOT3O5GHKYrvO9X6B41epHCyZG129020ZcVNC/yJveSILZmYT3hb0hLNYJ9lUksQl4vNdi5nhCJuDWFWLbRXcLKJ2w5k1+Qmikv7ES3XRGvGo4ihvz8zNNob9FxK50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258122; c=relaxed/simple;
	bh=P/AmfJqHFD7PRChe0yx8dha4NHp3GLYG3o0qoVRWcuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUFWJ1BmamC7r0MhD2pK2xrttKIsx0TuKgQq5M7FWLWtsPW8sIky3TzAa0MuSPRh9+uMNDXPpWdIYF41asUPPrBtVLUQNITyAZehuolmYDZ+0aCMNP1tSvqq4swG49jBEuWjN+lyUvQu8ODORkup7E9Q8DPOq6PhXqwOqovufbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lfcbEkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lfcbEkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588E41F000C4;
	Sat, 17 Oct 2026 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258120;
	bh=zpe8vK9SdEsnZdg1CjJ349fT3UvDQXK4RZv7AIqvpuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lfcbEkNebCprtmCJL2JMIS/68oSxraIsURA/2ZxvNujH1nc75OuMaaLLqJ99WfL+
	 /pZ2lLgNiNmz6R4/1T5fgAl2O0oqSpofK4pBLfBdOvJtK8b+50MtK23X6M9YSb7Nz7
	 hY9/Afgn4GXl9Qa+TlhHrKljKdTTj6mMBbcrtouo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0779/1674] crypto: x86/aegis - Add missing error checks
Date: Sat, 17 Oct 2026 17:50:51 +0200
Message-ID: <20261017160451.099793310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 3d9eb180fbe8828cce43bce4c370124685b205c3 ]

The skcipher_walk functions can allocate memory and can fail, so
checking for errors is necessary.

Fixes: 1d373d4e8e15 ("crypto: x86 - Add optimized AEGIS implementations")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aegis128-aesni-glue.c | 36 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index de0aab6997d41..f5bbf274a54e9 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -108,10 +108,12 @@ static void crypto_aegis128_aesni_process_ad(
 	}
 }
 
-static __always_inline void
+static __always_inline int
 crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 				    struct skcipher_walk *walk, bool enc)
 {
+	int err = 0;
+
 	while (walk->nbytes >= AEGIS128_BLOCK_SIZE) {
 		if (enc)
 			aegis128_aesni_enc(state, walk->src.virt.addr,
@@ -124,7 +126,8 @@ crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 					   round_down(walk->nbytes,
 						      AEGIS128_BLOCK_SIZE));
 		kernel_fpu_end();
-		skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SIZE);
+		err = skcipher_walk_done(walk,
+					 walk->nbytes % AEGIS128_BLOCK_SIZE);
 		kernel_fpu_begin();
 	}
 
@@ -138,9 +141,10 @@ crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 						walk->dst.virt.addr,
 						walk->nbytes);
 		kernel_fpu_end();
-		skcipher_walk_done(walk, 0);
+		err = skcipher_walk_done(walk, 0);
 		kernel_fpu_begin();
 	}
+	return err;
 }
 
 static struct aegis_ctx *crypto_aegis128_aesni_ctx(struct crypto_aead *aead)
@@ -173,7 +177,7 @@ static int crypto_aegis128_aesni_setauthsize(struct crypto_aead *tfm,
 	return 0;
 }
 
-static __always_inline void
+static __always_inline int
 crypto_aegis128_aesni_crypt(struct aead_request *req,
 			    struct aegis_block *tag_xor,
 			    unsigned int cryptlen, bool enc)
@@ -182,20 +186,24 @@ crypto_aegis128_aesni_crypt(struct aead_request *req,
 	struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(tfm);
 	struct skcipher_walk walk;
 	struct aegis_state state;
+	int err;
 
 	if (enc)
-		skcipher_walk_aead_encrypt(&walk, req, false);
+		err = skcipher_walk_aead_encrypt(&walk, req, false);
 	else
-		skcipher_walk_aead_decrypt(&walk, req, false);
+		err = skcipher_walk_aead_decrypt(&walk, req, false);
+	if (err)
+		return err;
 
 	kernel_fpu_begin();
 
 	aegis128_aesni_init(&state, &ctx->key, req->iv);
 	crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
-	crypto_aegis128_aesni_process_crypt(&state, &walk, enc);
-	aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
-
+	err = crypto_aegis128_aesni_process_crypt(&state, &walk, enc);
+	if (err == 0)
+		aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
 	kernel_fpu_end();
+	return err;
 }
 
 static int crypto_aegis128_aesni_encrypt(struct aead_request *req)
@@ -204,8 +212,11 @@ static int crypto_aegis128_aesni_encrypt(struct aead_request *req)
 	struct aegis_block tag = {};
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen;
+	int err;
 
-	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, true);
+	err = crypto_aegis128_aesni_crypt(req, &tag, cryptlen, true);
+	if (err)
+		return err;
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst,
 				 req->assoclen + cryptlen, authsize, 1);
@@ -220,11 +231,14 @@ static int crypto_aegis128_aesni_decrypt(struct aead_request *req)
 	struct aegis_block tag;
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen - authsize;
+	int err;
 
 	scatterwalk_map_and_copy(tag.bytes, req->src,
 				 req->assoclen + cryptlen, authsize, 0);
 
-	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, false);
+	err = crypto_aegis128_aesni_crypt(req, &tag, cryptlen, false);
+	if (err)
+		return err;
 
 	return crypto_memneq(tag.bytes, zeros.bytes, authsize) ? -EBADMSG : 0;
 }
-- 
2.53.0



