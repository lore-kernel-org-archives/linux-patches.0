Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDFD20B7EE;
	Tue, 26 Aug 2025 11:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207040; cv=none; b=Ckcrlj9QdLdNtWfL3DgHj5Aeln6CvVWcj+m6dohrtXQGIKyGDTEPMI0JWc3VdrpAJo8v1idCEQeOFRo/KO/KfprUzbw1yH9BJJ/YLE2pBnSfiyuUJ67qZe1HpsY2B8DaMgDP+v6nsPFC5lYT2TNRYbXCR3ymq6Htd0HXJ8z9d1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207040; c=relaxed/simple;
	bh=Xi4zulE/eX9qJzvKbxyJRNQ4ZdZttUcxh2i+PdwuI8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VslH9eksDwRDXG1HddLJvE4QuR7ZZhFjjccE7M4QdWkz7okVwVpkwFi7Fv7JRt+C6OpOkaKFMhhtg8CWRpPo6GLGA8zQqdZpZNzuVHUyzy2Zx3WjvihWBqHVYbYVsmWcHbd1cwi2RKJR5hKVKzTPdU/4eMYgMoxIAFhYgvh4RKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxbow7iJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxbow7iJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE43C4CEF1;
	Tue, 26 Aug 2025 11:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207040;
	bh=Xi4zulE/eX9qJzvKbxyJRNQ4ZdZttUcxh2i+PdwuI8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxbow7iJlFe5A9aPo5aDq0IIKmY5xHRA3lJveQRrRttE9hHtX6PSsKv5mMtMzHayl
	 4n9lArWmIQKJAiclHr6WQzcP+inFLzewIYcXvGYG4MKBYKgres8iBiDqbEL+NohQtI
	 t0qlR9MqVGt0XyeOodqQATqk6V4Qi9Xn7Qmw/nYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.16 028/457] crypto: x86/aegis - Add missing error checks
Date: Tue, 26 Aug 2025 13:05:12 +0200
Message-ID: <20250826110938.031567028@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 3d9eb180fbe8828cce43bce4c370124685b205c3 upstream.

The skcipher_walk functions can allocate memory and can fail, so
checking for errors is necessary.

Fixes: 1d373d4e8e15 ("crypto: x86 - Add optimized AEGIS implementations")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aegis128-aesni-glue.c |   36 +++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -104,10 +104,12 @@ static void crypto_aegis128_aesni_proces
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
@@ -120,7 +122,8 @@ crypto_aegis128_aesni_process_crypt(stru
 					   round_down(walk->nbytes,
 						      AEGIS128_BLOCK_SIZE));
 		kernel_fpu_end();
-		skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SIZE);
+		err = skcipher_walk_done(walk,
+					 walk->nbytes % AEGIS128_BLOCK_SIZE);
 		kernel_fpu_begin();
 	}
 
@@ -134,9 +137,10 @@ crypto_aegis128_aesni_process_crypt(stru
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
@@ -169,7 +173,7 @@ static int crypto_aegis128_aesni_setauth
 	return 0;
 }
 
-static __always_inline void
+static __always_inline int
 crypto_aegis128_aesni_crypt(struct aead_request *req,
 			    struct aegis_block *tag_xor,
 			    unsigned int cryptlen, bool enc)
@@ -178,20 +182,24 @@ crypto_aegis128_aesni_crypt(struct aead_
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
@@ -200,8 +208,11 @@ static int crypto_aegis128_aesni_encrypt
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
@@ -216,11 +227,14 @@ static int crypto_aegis128_aesni_decrypt
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


