Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E353D75C9;
	Wed,  8 Apr 2026 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674451; cv=none; b=QKgyi0SHJ1yBn0XJMhLllBHnaxbYsxO/UpFbzEm0Iv9EzhO3bEI7KUEuhr4sz+d0xRvDLbgKX9YITz2UCs54rPAXnv4CLwClWqBgJkBGps7B85t8yv/x1ZfaJtVpxfDaGWiQOHiI9MmFkKWxCAiylfErc4LjpdyXOBsBHjSOJWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674451; c=relaxed/simple;
	bh=VNw/ELLYAHcPX5+2Rm3zsV5nRTsaIcRiBJJw+4JRYCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTbH1vJ82l1tkDzVxk/jGCpdH0arSEvlefTk1sxBegr5pmTejXkkaTb+fCDWN/K9KPUtrmdow/5v/5mi2JTr+fs684wierosQzLP9AgKD7VEWH83JAjpi0JKVDrdGi6nM2VKgz9UJZDfxpQ1ois5Qr/SsaO0/qIbbrDH4cAI970=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5gsbuy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5gsbuy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DECDC19421;
	Wed,  8 Apr 2026 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674451;
	bh=VNw/ELLYAHcPX5+2Rm3zsV5nRTsaIcRiBJJw+4JRYCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5gsbuy+/wvpbiJhUgcbzTwdyXD7d54+0Ciiz4qeBj9E2h5SEp/G/JdbNNDkKKr9p
	 UZurRfRDidl+PupIUlwKdLJ5HhOTxDxU6SeD76bHpaI1uRX4zm+RhvWZqQArxB23sU
	 D1LoMo47hZDvyzEX7noFtwlRUX7+zHXCA9wV2Pcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 070/311] crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption
Date: Wed,  8 Apr 2026 20:01:10 +0200
Message-ID: <20260408175942.027871231@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit e02494114ebf7c8b42777c6cd6982f113bfdbec7 ]

When decrypting data that is not in-place (src != dst), there is
no need to save the high-order sequence bits in dst as it could
simply be re-copied from the source.

However, the data to be hashed need to be rearranged accordingly.

Reported-by: Taeyang Lee <0wn@theori.io>
Fixes: 104880a6b470 ("crypto: authencesn - Convert to new AEAD interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/authencesn.c | 48 +++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 542a978663b9e..c0a01d738d9bc 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -207,6 +207,7 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	u8 *ohash = areq_ctx->tail;
 	unsigned int cryptlen = req->cryptlen - authsize;
 	unsigned int assoclen = req->assoclen;
+	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
 	u32 tmp[2];
@@ -214,23 +215,27 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	if (!authsize)
 		goto decrypt;
 
-	/* Move high-order bits of sequence number back. */
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	if (src == dst) {
+		/* Move high-order bits of sequence number back. */
+		scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
+		scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	} else
+		memcpy_sglist(dst, src, assoclen);
 
 	if (crypto_memneq(ihash, ohash, authsize))
 		return -EBADMSG;
 
 decrypt:
 
-	sg_init_table(areq_ctx->dst, 2);
+	if (src != dst)
+		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, flags,
 				      req->base.complete, req->base.data);
-	skcipher_request_set_crypt(skreq, dst, dst, cryptlen, req->iv);
+	skcipher_request_set_crypt(skreq, src, dst, cryptlen, req->iv);
 
 	return crypto_skcipher_decrypt(skreq);
 }
@@ -255,6 +260,7 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
+	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	u32 tmp[2];
 	int err;
@@ -262,24 +268,28 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	if (assoclen < 8)
 		return -EINVAL;
 
-	cryptlen -= authsize;
-
-	if (req->src != dst)
-		memcpy_sglist(dst, req->src, assoclen + cryptlen);
+	if (!authsize)
+		goto tail;
 
+	cryptlen -= authsize;
 	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
 				 authsize, 0);
 
-	if (!authsize)
-		goto tail;
-
 	/* Move high-order bits of sequence number to the end. */
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
-
-	sg_init_table(areq_ctx->dst, 2);
-	dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+	scatterwalk_map_and_copy(tmp, src, 0, 8, 0);
+	if (src == dst) {
+		scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
+		dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+	} else {
+		scatterwalk_map_and_copy(tmp, dst, 0, 4, 1);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen - 4, 4, 1);
+
+		src = scatterwalk_ffwd(areq_ctx->src, src, 8);
+		dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+		memcpy_sglist(dst, src, assoclen + cryptlen - 8);
+		dst = req->dst;
+	}
 
 	ahash_request_set_tfm(ahreq, auth);
 	ahash_request_set_crypt(ahreq, dst, ohash, assoclen + cryptlen);
-- 
2.53.0



