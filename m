Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27C71A0728;
	Fri, 17 Oct 2025 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716350; cv=none; b=giVTNxc2P+EjYN4kzEtduxgwv8nuY9CWm1A+xKQ7p81WD9dB8j2z4FeHcFnzmxUBjfPGECaNtzS+aMlDJyDivdF3mPXCx+5IEnZIs9/jggQitqZa+Cim96Ptr3Xf+TlypqZ23WwV52Tv70cR/EVFlCpjsmLcewX9PHXtYesuJDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716350; c=relaxed/simple;
	bh=p4ghoImUWmuIFTgI7f95GO4qfQWBFOYMJHrua2Q/csc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2Uj/RKllXtH2PseqW3mDIbFVqoXgBoHOTSlGYkvrvBI9WiY+glXU2qdI3nQmXmVQAMmPrIpWc/ZRo/MFR2nGzbKoRAEl1WIWdMXL8YK71NB+GZVUIEs5z2mfvpJrzfDqHLYvNLcVs0Vl3Me46blf5n8SbPMogr9rXi+bqWTRvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czhrkZrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czhrkZrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37386C4CEE7;
	Fri, 17 Oct 2025 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716350;
	bh=p4ghoImUWmuIFTgI7f95GO4qfQWBFOYMJHrua2Q/csc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czhrkZrkcAnxsQftj5ay3u4sE1wztM7Zljj2+o4fwygq5weySAogvI9QqQZsXyOSk
	 wTkYUQCkGCiro7h0v0gtemlvYB+X7xL41hknmqJT3p9+dNO4VDwnBNrqxW16P+0kXR
	 EkR4F5tRSnyUqM9uw26evjD7CWypW6ohVTK88lZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/276] crypto: essiv - Check ssize for decryption and in-place encryption
Date: Fri, 17 Oct 2025 16:54:14 +0200
Message-ID: <20251017145148.351152499@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3505b071e6471..365f3082ea041 100644
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



