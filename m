Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4022F12BA;
	Fri, 17 Oct 2025 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713594; cv=none; b=iDGLAVeH0hMKWqyehHjxWtBtAKAr9MleDuRD9GtCiuzvxsyGiJCRdD3t6c3PIc9qHiiJyrtZAYFKgXiHGJgPPLmi873t9arYvo2hUW7D9ArM0yuRIE93fYR5k3zihETOBwA4yN2aZocUK/fmBQzgN2G9Xeg0ZBX/E4mRB5pyCUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713594; c=relaxed/simple;
	bh=CE0p/PJBwjeqbTzsjxIFCYBCzR5nL8HYYt6SsDuv6D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYpddePj4BYBYVHALPTvO0wwtk9h2Li+fi1jxw+rsfLdVsB836r9ck7dxVgLjul9folEP9n5HIzm8nxlOSStpwGw+lQyDBtfo5iJfDSyrV/TmJ++RpMr9zDxAm1v96C+x3IRWJgUuCMpQeHUFovVaRetyiqF3nkXG2S2IA1Fztg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZjiWJ/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZjiWJ/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAAFC4CEE7;
	Fri, 17 Oct 2025 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713593;
	bh=CE0p/PJBwjeqbTzsjxIFCYBCzR5nL8HYYt6SsDuv6D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZjiWJ/l0J+afi4OLyDazwFlbtJnzGcVtI0j1tKLx3DrrsCqHinmGQJyN+a/Iu9ap
	 6NgI3hAYpAwQZVmtKnss1DB9v8r2VDGXlmxPWkC5oqCl29FqOTYJGAe97ozxw9VSM1
	 fD/Qy0rNzCXnfEe9aUOlQ8oQ4SdJShklWypwSpkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/201] crypto: essiv - Check ssize for decryption and in-place encryption
Date: Fri, 17 Oct 2025 16:51:53 +0200
Message-ID: <20251017145136.656692687@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 6bb73db6948c2de23e407fe1b7ef94bf02b7529f ]

Move the ssize check to the start in essiv_aead_crypt so that
it's also checked for decryption and in-place encryption.

Reported-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template for ESSIV generation")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/essiv.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index f7d4ef4837e54..4dbec116ddc3e 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -186,9 +186,14 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	const struct essiv_tfm_ctx *tctx = crypto_aead_ctx(tfm);
 	struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
 	struct aead_request *subreq = &rctx->aead_req;
+	int ivsize = crypto_aead_ivsize(tfm);
+	int ssize = req->assoclen - ivsize;
 	struct scatterlist *src = req->src;
 	int err;
 
+	if (ssize < 0)
+		return -EINVAL;
+
 	crypto_cipher_encrypt_one(tctx->essiv_cipher, req->iv, req->iv);
 
 	/*
@@ -198,19 +203,12 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	 */
 	rctx->assoc = NULL;
 	if (req->src == req->dst || !enc) {
-		scatterwalk_map_and_copy(req->iv, req->dst,
-					 req->assoclen - crypto_aead_ivsize(tfm),
-					 crypto_aead_ivsize(tfm), 1);
+		scatterwalk_map_and_copy(req->iv, req->dst, ssize, ivsize, 1);
 	} else {
 		u8 *iv = (u8 *)aead_request_ctx(req) + tctx->ivoffset;
-		int ivsize = crypto_aead_ivsize(tfm);
-		int ssize = req->assoclen - ivsize;
 		struct scatterlist *sg;
 		int nents;
 
-		if (ssize < 0)
-			return -EINVAL;
-
 		nents = sg_nents_for_len(req->src, ssize);
 		if (nents < 0)
 			return -EINVAL;
-- 
2.51.0



