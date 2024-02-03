Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0288417555;
	Sat,  3 Feb 2024 04:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933941; cv=none; b=qNA4K6dnAixG89FtJ0Jp9jgB2wvTXmb1yYWFz0HeoH+aGM0RNJHPYpN4KXe79LnpJlFsVwV6TwWYHGw4Ih+Ax55DHdpyCDjh/keTuc5NXnSpRfPooaBOPnFMnpE0rObNXJc74WsrLz1Tn2mZsh8wau/is+fji0fcY9/R1HJS610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933941; c=relaxed/simple;
	bh=+zmaB9J5kVKrFDSNMRNz63ew1jXMwWDEM2CA8bRT3zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMDcaQVdAnkn8CHN52fKNVOSTQ2y/APUYOSmr0rl9VwSRU5nZuNIXP2pl+usVFRxJz/QaEyMWdoddnalAbbO98OKvLLwAajqkGCt7goPfLstDCxYIVthE6d/MJSEkccaJveWrU5uV5P8XFHhk9im1Ra3+K0ehGA0+BbhPR/Iy84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBwEY6qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBwEY6qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00DDC433F1;
	Sat,  3 Feb 2024 04:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933940;
	bh=+zmaB9J5kVKrFDSNMRNz63ew1jXMwWDEM2CA8bRT3zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBwEY6qyDBOamGjPhq17jzLIn8U90LSODBkyRxlF0qOxATQf9QiOts0RHkpogzDZ4
	 ddHZ+DzOaWX9m66rTjKbbAN4bHyq9tgQSOycASGmxX6z6hvID13pD9GRvgb9YZnggF
	 QdR9TqwG5iJ3U/Fm7YcQwHiC1C3QmxMZTMH292Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 303/353] crypto: caam - fix asynchronous hash
Date: Fri,  2 Feb 2024 20:07:01 -0800
Message-ID: <20240203035413.423218386@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Jain <gaurav.jain@nxp.com>

[ Upstream commit c5a2f74db71a849f3a60bc153d684d6d28a0c665 ]

ahash_alg->setkey is updated to ahash_nosetkey in ahash.c
so checking setkey() function to determine hmac algorithm is not valid.

to fix this added is_hmac variable in structure caam_hash_alg to determine
whether the algorithm is hmac or not.

Fixes: 2f1f34c1bf7b ("crypto: ahash - optimize performance when wrapping shash")
Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg_qi2.c | 7 +++++--
 drivers/crypto/caam/caamhash.c    | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a148ff1f0872..a4f6884416a0 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4545,6 +4545,7 @@ struct caam_hash_alg {
 	struct list_head entry;
 	struct device *dev;
 	int alg_type;
+	bool is_hmac;
 	struct ahash_alg ahash_alg;
 };
 
@@ -4571,7 +4572,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 
 	ctx->dev = caam_hash->dev;
 
-	if (alg->setkey) {
+	if (caam_hash->is_hmac) {
 		ctx->adata.key_dma = dma_map_single_attrs(ctx->dev, ctx->key,
 							  ARRAY_SIZE(ctx->key),
 							  DMA_TO_DEVICE,
@@ -4611,7 +4612,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	 * For keyed hash algorithms shared descriptors
 	 * will be created later in setkey() callback
 	 */
-	return alg->setkey ? 0 : ahash_set_sh_desc(ahash);
+	return caam_hash->is_hmac ? 0 : ahash_set_sh_desc(ahash);
 }
 
 static void caam_hash_cra_exit(struct crypto_tfm *tfm)
@@ -4646,12 +4647,14 @@ static struct caam_hash_alg *caam_hash_alloc(struct device *dev,
 			 template->hmac_name);
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->hmac_driver_name);
+		t_alg->is_hmac = true;
 	} else {
 		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->name);
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->driver_name);
 		t_alg->ahash_alg.setkey = NULL;
+		t_alg->is_hmac = false;
 	}
 	alg->cra_module = THIS_MODULE;
 	alg->cra_init = caam_hash_cra_init;
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 290c8500c247..fdd724228c2f 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1753,6 +1753,7 @@ static struct caam_hash_template driver_hash[] = {
 struct caam_hash_alg {
 	struct list_head entry;
 	int alg_type;
+	bool is_hmac;
 	struct ahash_engine_alg ahash_alg;
 };
 
@@ -1804,7 +1805,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	} else {
 		if (priv->era >= 6) {
 			ctx->dir = DMA_BIDIRECTIONAL;
-			ctx->key_dir = alg->setkey ? DMA_TO_DEVICE : DMA_NONE;
+			ctx->key_dir = caam_hash->is_hmac ? DMA_TO_DEVICE : DMA_NONE;
 		} else {
 			ctx->dir = DMA_TO_DEVICE;
 			ctx->key_dir = DMA_NONE;
@@ -1862,7 +1863,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	 * For keyed hash algorithms shared descriptors
 	 * will be created later in setkey() callback
 	 */
-	return alg->setkey ? 0 : ahash_set_sh_desc(ahash);
+	return caam_hash->is_hmac ? 0 : ahash_set_sh_desc(ahash);
 }
 
 static void caam_hash_cra_exit(struct crypto_tfm *tfm)
@@ -1915,12 +1916,14 @@ caam_hash_alloc(struct caam_hash_template *template,
 			 template->hmac_name);
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->hmac_driver_name);
+		t_alg->is_hmac = true;
 	} else {
 		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->name);
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->driver_name);
 		halg->setkey = NULL;
+		t_alg->is_hmac = false;
 	}
 	alg->cra_module = THIS_MODULE;
 	alg->cra_init = caam_hash_cra_init;
-- 
2.43.0



