Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E1A217F40;
	Thu, 12 Dec 2024 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018967; cv=none; b=WuEZ1uBslEUMGBYNQbxoX0UjWxBOp9Lh8LCFX1AGRC3dTTW4QysZuZ9QirAN3IiwojrTjjagVOwklYoed/e4HSFOHEtiaSQ4Ky1ak80sn8BfRo3htX4iTUNhREjRszzYSIkeIlmQL3c96rg+/3uRiKWOtvEusYs8pi4ZSFDGCE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018967; c=relaxed/simple;
	bh=dww51fL/45dzJ5icfMRK5p5bdzn5XnwitBHbylnZk5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBFuuqgpuio+ewrrgm+XwNvl8PtKrj+OAq0VLLgEqhDF+cVGxqtYya7nHwzMcfCXUkD3WMsvSfK8esevnVJfWUG+ZQF05Vc1vBakUOt0BUq8/UorCKLJEiwN+RnQTQOgnqIziq/s0fNoVTD9io+Ekl4stNa4TYh0JHvezrxUcRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7PDfQ94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7PDfQ94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFDAC4CECE;
	Thu, 12 Dec 2024 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018967;
	bh=dww51fL/45dzJ5icfMRK5p5bdzn5XnwitBHbylnZk5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7PDfQ94M5mcNyoWTxWooRIq3HfJ7oDWEMNpXjAr0uH8lwE9HxSnoUFM46mg7En0q
	 qCm6cJF+0iFZC8pbVSGPB79MrpWuH9iiwn03smlqd6bybiXtqcl6fWqJ4Wnk+i3ZDq
	 JLqsNZwv1mTxAPd9BYh8gasdA/Yi9HayYEerFQc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/772] crypto: caam - add error check to caam_rsa_set_priv_key_form
Date: Thu, 12 Dec 2024 15:50:26 +0100
Message-ID: <20241212144353.276670019@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit b64140c74e954f1db6eae5548ca3a1f41b6fad79 ]

The caam_rsa_set_priv_key_form did not check for memory allocation errors.
Add the checks to the caam_rsa_set_priv_key_form functions.

Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caampkc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 51b48b57266a6..7881846651d12 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -979,7 +979,7 @@ static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 	return -ENOMEM;
 }
 
-static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
+static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 				       struct rsa_key *raw_key)
 {
 	struct caam_rsa_key *rsa_key = &ctx->key;
@@ -988,7 +988,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
 	if (!rsa_key->p)
-		return;
+		return -ENOMEM;
 	rsa_key->p_sz = p_sz;
 
 	rsa_key->q = caam_read_raw_data(raw_key->q, &q_sz);
@@ -1021,7 +1021,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 	rsa_key->priv_form = FORM3;
 
-	return;
+	return 0;
 
 free_dq:
 	kfree_sensitive(rsa_key->dq);
@@ -1035,6 +1035,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 	kfree_sensitive(rsa_key->q);
 free_p:
 	kfree_sensitive(rsa_key->p);
+	return -ENOMEM;
 }
 
 static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
@@ -1080,7 +1081,9 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_key->e_sz = raw_key.e_sz;
 	rsa_key->n_sz = raw_key.n_sz;
 
-	caam_rsa_set_priv_key_form(ctx, &raw_key);
+	ret = caam_rsa_set_priv_key_form(ctx, &raw_key);
+	if (ret)
+		goto err;
 
 	return 0;
 
-- 
2.43.0



