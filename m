Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC44211493;
	Thu, 12 Dec 2024 17:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023761; cv=none; b=XAP3D5S74RFupaCBQvGR2EUMHQtLEghw4g+iidyNUkfS8QMhCx3Xa2PKnx1XKAWHCzamWmJ+ARNhSbgOyBTqrwkRjx7dxLzDyJ46FxW59/qTpal3qvpP3MeuAnnODllA+asQ4k6S5R/Zjih5va1OiamzeEZ84eoAsQCTSquR/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023761; c=relaxed/simple;
	bh=lshbM1FzpGUcUzkbd2h5efTyM/fVNoMn4CBCsIg53yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GKiT+85zhhvmhQw4Oj4E9EdIJjBKdrGx4bxFkbrsNYhZ3B2Xo+1sqli+5yUE/s4p2tTQVp0pSpgHgRVacszE/9hGa5pMp6prtWOBXQCzlXR76Ry0jME3GVx3/y+peBdQSAb0brL1itFOQzoALNQp40KSQDSvh4AblGiGArMQKtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpRCSG6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpRCSG6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF3BC4CECE;
	Thu, 12 Dec 2024 17:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023761;
	bh=lshbM1FzpGUcUzkbd2h5efTyM/fVNoMn4CBCsIg53yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpRCSG6GUtq4sgHW2ibajrwYs2BKerHDgxptEHPCztL7pXapOajLpwR93OgQgl112
	 AqVyKvfjghJrMNk6Haw2ZqZx/uRwCiT4eWb4RHIcpog4h95TQ6tLbnwoOaVmJTXC4q
	 lj/Q4EPxmdCJaD+/bALDPBy24IXnMqwvDc350FE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/459] crypto: caam - add error check to caam_rsa_set_priv_key_form
Date: Thu, 12 Dec 2024 15:56:51 +0100
Message-ID: <20241212144256.406957030@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5bd70a59f4ce2..c3c47756f25fe 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -975,7 +975,7 @@ static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 	return -ENOMEM;
 }
 
-static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
+static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 				       struct rsa_key *raw_key)
 {
 	struct caam_rsa_key *rsa_key = &ctx->key;
@@ -984,7 +984,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
 	if (!rsa_key->p)
-		return;
+		return -ENOMEM;
 	rsa_key->p_sz = p_sz;
 
 	rsa_key->q = caam_read_raw_data(raw_key->q, &q_sz);
@@ -1017,7 +1017,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 	rsa_key->priv_form = FORM3;
 
-	return;
+	return 0;
 
 free_dq:
 	kfree_sensitive(rsa_key->dq);
@@ -1031,6 +1031,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 	kfree_sensitive(rsa_key->q);
 free_p:
 	kfree_sensitive(rsa_key->p);
+	return -ENOMEM;
 }
 
 static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
@@ -1076,7 +1077,9 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_key->e_sz = raw_key.e_sz;
 	rsa_key->n_sz = raw_key.n_sz;
 
-	caam_rsa_set_priv_key_form(ctx, &raw_key);
+	ret = caam_rsa_set_priv_key_form(ctx, &raw_key);
+	if (ret)
+		goto err;
 
 	return 0;
 
-- 
2.43.0



