Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6601ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFA1C433C8;
	Tue, 25 Jul 2023 11:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285183;
	bh=36xunk0bCtU8L7nauYx48DMxyHj6svzZAjQ5zjRTUT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g25krBOROicMJ5dIR+Xcv/VxAXERJXqcFwQMMSY4pmu6jBNnZpBieocl+SQ/INfez
	 REO47KqT7wWj/74OVdM/SiAD/QVeviE73kT5EWQEZXlnzetoUQnRL4hGzO1Sn+FiCu
	 Ln2gaJGETbvQxQwaYWnduXKPt9/CRauwZsjukFOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/313] crypto: skcipher - unify the crypto_has_skcipher*() functions
Date: Tue, 25 Jul 2023 12:44:26 +0200
Message-ID: <20230725104525.907419883@linuxfoundation.org>
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

[ Upstream commit d3ca75a8b3d77f2788e6c119ea7c3e3a1ab1e1ca ]

crypto_has_skcipher() and crypto_has_skcipher2() do the same thing: they
check for the availability of an algorithm of type skcipher, blkcipher,
or ablkcipher, which also meets any non-type constraints the caller
specified.  And they have exactly the same prototype.

Therefore, eliminate the redundancy by removing crypto_has_skcipher()
and renaming crypto_has_skcipher2() to crypto_has_skcipher().

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: efbc7764c444 ("crypto: marvell/cesa - Fix type mismatch warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/skcipher.c         |  4 ++--
 include/crypto/skcipher.h | 19 +------------------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 22753c1c72022..233678d078169 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -1017,12 +1017,12 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_sync_skcipher);
 
-int crypto_has_skcipher2(const char *alg_name, u32 type, u32 mask)
+int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_skcipher_type2,
 				   type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_has_skcipher2);
+EXPORT_SYMBOL_GPL(crypto_has_skcipher);
 
 static int skcipher_prepare_alg(struct skcipher_alg *alg)
 {
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 0bce6005d325d..6514e32e7c2fd 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -220,30 +220,13 @@ static inline void crypto_free_sync_skcipher(struct crypto_sync_skcipher *tfm)
  * crypto_has_skcipher() - Search for the availability of an skcipher.
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
  *	      skcipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Return: true when the skcipher is known to the kernel crypto API; false
- *	   otherwise
- */
-static inline int crypto_has_skcipher(const char *alg_name, u32 type,
-					u32 mask)
-{
-	return crypto_has_alg(alg_name, crypto_skcipher_type(type),
-			      crypto_skcipher_mask(mask));
-}
-
-/**
- * crypto_has_skcipher2() - Search for the availability of an skcipher.
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      skcipher
  * @type: specifies the type of the skcipher
  * @mask: specifies the mask for the skcipher
  *
  * Return: true when the skcipher is known to the kernel crypto API; false
  *	   otherwise
  */
-int crypto_has_skcipher2(const char *alg_name, u32 type, u32 mask);
+int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask);
 
 static inline const char *crypto_skcipher_driver_name(
 	struct crypto_skcipher *tfm)
-- 
2.39.2



