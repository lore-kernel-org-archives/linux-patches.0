Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC333CEA2;
	Wed, 20 May 2026 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302028; cv=none; b=Ts14ZM9Qyvuj0q2fzRBgrlPF2p495i1w8eucX+q8cQm32JeVjH5EZ8X0fBXlQikh9mz084L8sDBL/CMusMlrnEcw+SGCPQTke/G66uN9KXag92z7nTIcPOipwB6Sc92Rs67+su7fvshoF01GxOWrCwKLlV7JgkfSufGAKFhkPXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302028; c=relaxed/simple;
	bh=vWHKBJ/inKOGseJ+sfe9yehPbvzGAyd7FK/DdTIjxxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTH+6LiCwuAB5yIq5NtDfEbNJcOzY4c+rfibYu3naxX8czeYsPa1w4Teas7KEC3i6+8q1k1KrrRveRtBT3sElTgGH6feSw5hOopoFudSE9eq59WtcwwhpIL3scda8lAw+9DyWRN8w3WcXwPgnS/iroXuiBMzzFYSJ7jQ+tZElQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAHI6heG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAHI6heG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C481F000E9;
	Wed, 20 May 2026 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302027;
	bh=s8o/3V/ysAnBZoshM1KZfyRNiB6xHlrOwWu7EtVxzts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAHI6heG+FA6XaLKLgoBw0jVM2fbp9gA+YZgfFroMGpyLFE9q6zhENxVpCkha8jle
	 Aeieo3oT0rclqFU+Pyigh3098+rgXeZX18eskVZbTJZt+C0B2ZskFs922a2nkuWXn9
	 TW64S9u3QXSs0sTbz/5XOtq0SP05Ul5HhviTHRgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/508] crypto: atmel - Use unregister_{aeads,ahashes,skciphers}
Date: Wed, 20 May 2026 18:18:53 +0200
Message-ID: <20260520162101.010004962@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 2ffc1ef4e826f0c3274f9ff5eb42bc70a5571afd ]

Replace multiple for loops with calls to crypto_unregister_aeads(),
crypto_unregister_ahashes(), and crypto_unregister_skciphers().

Remove the definition of atmel_tdes_unregister_algs() because it is
equivalent to calling crypto_unregister_skciphers() directly, and the
function parameter 'struct atmel_tdes_dev *' is unused anyway.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 57a13941c0bb ("crypto: atmel-aes - guard unregister on error in atmel_aes_register_algs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c  | 17 ++++++-----------
 drivers/crypto/atmel-sha.c  | 27 ++++++++++-----------------
 drivers/crypto/atmel-tdes.c | 25 ++++++-------------------
 3 files changed, 22 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index f023f27468c0d..9bd18825e1bf2 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2200,12 +2200,10 @@ static irqreturn_t atmel_aes_irq(int irq, void *dev_id)
 
 static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
-	int i;
-
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc)
-		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++)
-			crypto_unregister_aead(&aes_authenc_algs[i]);
+		crypto_unregister_aeads(aes_authenc_algs,
+					ARRAY_SIZE(aes_authenc_algs));
 #endif
 
 	if (dd->caps.has_xts)
@@ -2214,8 +2212,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 	if (dd->caps.has_gcm)
 		crypto_unregister_aead(&aes_gcm_alg);
 
-	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
-		crypto_unregister_skcipher(&aes_algs[i]);
+	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
 static void atmel_aes_crypto_alg_init(struct crypto_alg *alg)
@@ -2228,7 +2225,7 @@ static void atmel_aes_crypto_alg_init(struct crypto_alg *alg)
 
 static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 {
-	int err, i, j;
+	int err, i;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
 		atmel_aes_crypto_alg_init(&aes_algs[i].base);
@@ -2271,8 +2268,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
-	for (j = 0; j < i; j++)
-		crypto_unregister_aead(&aes_authenc_algs[j]);
+	crypto_unregister_aeads(aes_authenc_algs, i);
 	crypto_unregister_skcipher(&aes_xts_alg);
 #endif
 err_aes_xts_alg:
@@ -2280,8 +2276,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 err_aes_gcm_alg:
 	i = ARRAY_SIZE(aes_algs);
 err_aes_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_skcipher(&aes_algs[j]);
+	crypto_unregister_skciphers(aes_algs, i);
 
 	return err;
 }
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 3622120add625..d32fb4e770119 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2418,27 +2418,23 @@ EXPORT_SYMBOL_GPL(atmel_sha_authenc_abort);
 
 static void atmel_sha_unregister_algs(struct atmel_sha_dev *dd)
 {
-	int i;
-
 	if (dd->caps.has_hmac)
-		for (i = 0; i < ARRAY_SIZE(sha_hmac_algs); i++)
-			crypto_unregister_ahash(&sha_hmac_algs[i]);
+		crypto_unregister_ahashes(sha_hmac_algs,
+					  ARRAY_SIZE(sha_hmac_algs));
 
-	for (i = 0; i < ARRAY_SIZE(sha_1_256_algs); i++)
-		crypto_unregister_ahash(&sha_1_256_algs[i]);
+	crypto_unregister_ahashes(sha_1_256_algs, ARRAY_SIZE(sha_1_256_algs));
 
 	if (dd->caps.has_sha224)
 		crypto_unregister_ahash(&sha_224_alg);
 
-	if (dd->caps.has_sha_384_512) {
-		for (i = 0; i < ARRAY_SIZE(sha_384_512_algs); i++)
-			crypto_unregister_ahash(&sha_384_512_algs[i]);
-	}
+	if (dd->caps.has_sha_384_512)
+		crypto_unregister_ahashes(sha_384_512_algs,
+					  ARRAY_SIZE(sha_384_512_algs));
 }
 
 static int atmel_sha_register_algs(struct atmel_sha_dev *dd)
 {
-	int err, i, j;
+	int err, i;
 
 	for (i = 0; i < ARRAY_SIZE(sha_1_256_algs); i++) {
 		atmel_sha_alg_init(&sha_1_256_algs[i]);
@@ -2480,18 +2476,15 @@ static int atmel_sha_register_algs(struct atmel_sha_dev *dd)
 
 	/*i = ARRAY_SIZE(sha_hmac_algs);*/
 err_sha_hmac_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_ahash(&sha_hmac_algs[j]);
+	crypto_unregister_ahashes(sha_hmac_algs, i);
 	i = ARRAY_SIZE(sha_384_512_algs);
 err_sha_384_512_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_ahash(&sha_384_512_algs[j]);
+	crypto_unregister_ahashes(sha_384_512_algs, i);
 	crypto_unregister_ahash(&sha_224_alg);
 err_sha_224_algs:
 	i = ARRAY_SIZE(sha_1_256_algs);
 err_sha_1_256_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_ahash(&sha_1_256_algs[j]);
+	crypto_unregister_ahashes(sha_1_256_algs, i);
 
 	return err;
 }
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 48888b2ff7936..0bf485f350c8f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -897,38 +897,25 @@ static irqreturn_t atmel_tdes_irq(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
-static void atmel_tdes_unregister_algs(struct atmel_tdes_dev *dd)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(tdes_algs); i++)
-		crypto_unregister_skcipher(&tdes_algs[i]);
-}
-
 static int atmel_tdes_register_algs(struct atmel_tdes_dev *dd)
 {
-	int err, i, j;
+	int err, i;
 
 	for (i = 0; i < ARRAY_SIZE(tdes_algs); i++) {
 		atmel_tdes_skcipher_alg_init(&tdes_algs[i]);
 
 		err = crypto_register_skcipher(&tdes_algs[i]);
-		if (err)
-			goto err_tdes_algs;
+		if (err) {
+			crypto_unregister_skciphers(tdes_algs, i);
+			return err;
+		}
 	}
 
 	return 0;
-
-err_tdes_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_skcipher(&tdes_algs[j]);
-
-	return err;
 }
 
 static void atmel_tdes_get_cap(struct atmel_tdes_dev *dd)
 {
-
 	dd->caps.has_dma = 0;
 
 	/* keep only major version number */
@@ -1061,7 +1048,7 @@ static int atmel_tdes_remove(struct platform_device *pdev)
 	list_del(&tdes_dd->list);
 	spin_unlock(&atmel_tdes.lock);
 
-	atmel_tdes_unregister_algs(tdes_dd);
+	crypto_unregister_skciphers(tdes_algs, ARRAY_SIZE(tdes_algs));
 
 	tasklet_kill(&tdes_dd->done_task);
 	tasklet_kill(&tdes_dd->queue_task);
-- 
2.53.0



