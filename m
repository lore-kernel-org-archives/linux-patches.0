Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BA6146D40;
	Mon,  6 Jan 2025 15:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177098; cv=none; b=mv2DxoyoBkzdvFHS5AuL6xNSh749kaUwZAVj1StO7Nqy/mGlw2551ZfOxd7nA5PAGsE6xVJ498qRHwNKiLvm08Pf+jvulY1GMq2K4MpSoxhcIZeUhNCqfi+SGUwWdFlx7AoH6K0dOEwqolWnLvxrUkzoX5wYm8RQJj8swJEFI5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177098; c=relaxed/simple;
	bh=WfkFlocDRAt+UryQEZH1phLhbzGvBlarccKNXoG3SwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHbonW8QJS1bfpCqQ/GuzHz+BbMCuegeH+BiUlBN+8AaDF6rKA4vDe+f0i5/SbzL59OvnXcDtuwvNbVgMh0JNW9UnG9ikn6qVUYFaTqFtflbAqzVfNLusu+UFhhk+Z+dI3P2Or5KJkQyMGCUVWd06vnOWDQ3FI+x5Tp6PEXSFks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPMrimer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPMrimer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7CAC4CED2;
	Mon,  6 Jan 2025 15:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177098;
	bh=WfkFlocDRAt+UryQEZH1phLhbzGvBlarccKNXoG3SwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPMrimer7JP8e3rMTxb6XcPwcQuQEcv2eN0fNHRPIvUYsX/B3c7ND72iCWO7gdc+g
	 aj9yHRJ3H8M8RpVqZBk4LOZBF+tlCDgnnoUrQqLKeKZkeu1TCipZyCYAgmVLjPis65
	 VtGAS6CpCM2hagQXrLnzc9cDpk7t2vCXSwy9UBGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/222] crypto: ecdsa - Rename keylen to bufsize where necessary
Date: Mon,  6 Jan 2025 16:13:47 +0100
Message-ID: <20250106151151.480607050@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit 703ca5cda1ea04735e48882a7cccff97d57656c3 ]

In cases where 'keylen' was referring to the size of the buffer used by
a curve's digits, it does not reflect the purpose of the variable anymore
once NIST P521 is used. What it refers to then is the size of the buffer,
which may be a few bytes larger than the size a coordinate of a key.
Therefore, rename keylen to bufsize where appropriate.

Tested-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3b0565c70350 ("crypto: ecdsa - Avoid signed integer overflow on signature decoding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdsa.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index e819d0983bd3..142bed98fa97 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -35,8 +35,8 @@ struct ecdsa_signature_ctx {
 static int ecdsa_get_signature_rs(u64 *dest, size_t hdrlen, unsigned char tag,
 				  const void *value, size_t vlen, unsigned int ndigits)
 {
-	size_t keylen = ndigits * sizeof(u64);
-	ssize_t diff = vlen - keylen;
+	size_t bufsize = ndigits * sizeof(u64);
+	ssize_t diff = vlen - bufsize;
 	const char *d = value;
 	u8 rs[ECC_MAX_BYTES];
 
@@ -58,7 +58,7 @@ static int ecdsa_get_signature_rs(u64 *dest, size_t hdrlen, unsigned char tag,
 		if (diff)
 			return -EINVAL;
 	}
-	if (-diff >= keylen)
+	if (-diff >= bufsize)
 		return -EINVAL;
 
 	if (diff) {
@@ -138,7 +138,7 @@ static int ecdsa_verify(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct ecc_ctx *ctx = akcipher_tfm_ctx(tfm);
-	size_t keylen = ctx->curve->g.ndigits * sizeof(u64);
+	size_t bufsize = ctx->curve->g.ndigits * sizeof(u64);
 	struct ecdsa_signature_ctx sig_ctx = {
 		.curve = ctx->curve,
 	};
@@ -165,14 +165,14 @@ static int ecdsa_verify(struct akcipher_request *req)
 		goto error;
 
 	/* if the hash is shorter then we will add leading zeros to fit to ndigits */
-	diff = keylen - req->dst_len;
+	diff = bufsize - req->dst_len;
 	if (diff >= 0) {
 		if (diff)
 			memset(rawhash, 0, diff);
 		memcpy(&rawhash[diff], buffer + req->src_len, req->dst_len);
 	} else if (diff < 0) {
 		/* given hash is longer, we take the left-most bytes */
-		memcpy(&rawhash, buffer + req->src_len, keylen);
+		memcpy(&rawhash, buffer + req->src_len, bufsize);
 	}
 
 	ecc_swap_digits((u64 *)rawhash, hash, ctx->curve->g.ndigits);
-- 
2.39.5



