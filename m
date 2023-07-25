Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C3E1ED45
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F094C433C7;
	Tue, 25 Jul 2023 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285185;
	bh=5BrznzGhnrBVpE7x8nBDWPFGkMXS6gt2jkqV5yEw3Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzAOu39LX7QF2hrKXilEeVS1ZkhqJu6GpjAurGA6jMDK/VWqQN5Xb5xSwuNkCEo1W
	 PEvE53Pji38l/2+O1SolptimMr2RjcOxcJz3JtvGrcVdZJzSz4A/vMqJqyLKrRuGLl
	 QdVP2dSeZR1if92scp/AMCZ7i+dH1zTcnROM83Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/313] crypto: skcipher - remove crypto_has_ablkcipher()
Date: Tue, 25 Jul 2023 12:44:27 +0200
Message-ID: <20230725104525.956502242@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit cec0cb8a28f9060367099beeafd0dbdb76fdfae2 ]

crypto_has_ablkcipher() has no users, and it does the same thing as
crypto_has_skcipher() anyway.  So remove it.  This also removes the last
user of crypto_skcipher_type() and crypto_skcipher_mask(), so remove
those too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: efbc7764c444 ("crypto: marvell/cesa - Fix type mismatch warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/crypto/api-skcipher.rst |  2 +-
 include/linux/crypto.h                | 31 ---------------------------
 2 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index 20ba08dddf2ec..55e0851f6fed9 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -41,7 +41,7 @@ Asynchronous Block Cipher API - Deprecated
    :doc: Asynchronous Block Cipher API
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_free_ablkcipher crypto_has_ablkcipher crypto_ablkcipher_ivsize crypto_ablkcipher_blocksize crypto_ablkcipher_setkey crypto_ablkcipher_reqtfm crypto_ablkcipher_encrypt crypto_ablkcipher_decrypt
+   :functions: crypto_free_ablkcipher crypto_ablkcipher_ivsize crypto_ablkcipher_blocksize crypto_ablkcipher_setkey crypto_ablkcipher_reqtfm crypto_ablkcipher_encrypt crypto_ablkcipher_decrypt
 
 Asynchronous Cipher Request Handle - Deprecated
 -----------------------------------------------
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 0c720a2982ae4..019ddf7596534 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -903,20 +903,6 @@ static inline struct crypto_ablkcipher *__crypto_ablkcipher_cast(
 	return (struct crypto_ablkcipher *)tfm;
 }
 
-static inline u32 crypto_skcipher_type(u32 type)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	return type;
-}
-
-static inline u32 crypto_skcipher_mask(u32 mask)
-{
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
-	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
-	return mask;
-}
-
 /**
  * DOC: Asynchronous Block Cipher API
  *
@@ -962,23 +948,6 @@ static inline void crypto_free_ablkcipher(struct crypto_ablkcipher *tfm)
 	crypto_free_tfm(crypto_ablkcipher_tfm(tfm));
 }
 
-/**
- * crypto_has_ablkcipher() - Search for the availability of an ablkcipher.
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      ablkcipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Return: true when the ablkcipher is known to the kernel crypto API; false
- *	   otherwise
- */
-static inline int crypto_has_ablkcipher(const char *alg_name, u32 type,
-					u32 mask)
-{
-	return crypto_has_alg(alg_name, crypto_skcipher_type(type),
-			      crypto_skcipher_mask(mask));
-}
-
 static inline struct ablkcipher_tfm *crypto_ablkcipher_crt(
 	struct crypto_ablkcipher *tfm)
 {
-- 
2.39.2



