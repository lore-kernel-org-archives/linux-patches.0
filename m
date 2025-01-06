Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65EC149C7B;
	Mon,  6 Jan 2025 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177065; cv=none; b=qoG+VmM9oEzUb+4ZRP86PzmzNPTGkH6HqzSZpzJBXlnOXsxgbdcXCuxy1W31KVKv2yKox+h6R8+nPU3jUCW/XZlCMliwkB/DcJ/Da5G6QYZ0wo+it5Ryl6thSCue+vo4Cn4VdNqvToAkC4Bg3zMM4Yye0tM2TTbYtBI7loBrmP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177065; c=relaxed/simple;
	bh=mYlST/GUzMnTOwfFK5KD5WbLFMk9awUzEP7+rJ7ZGfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAKYl2DkJqW4JEQEhi46Nd5+c5V8lJIsmJ8dliKgSHrAjtk3/JZvwOcdeLZBgCxBaDrvc6nwXXv6RKLiM0md3RiAE5mqt8iIAS0FC1MKORfpVpFZN5A+wn/4dKB9e8eFBZKAsNd4rKFIw/nEcQNpAXbtdp2mJvfbSSMXtjiVCtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBHggYU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBHggYU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7A1C4CEDF;
	Mon,  6 Jan 2025 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177065;
	bh=mYlST/GUzMnTOwfFK5KD5WbLFMk9awUzEP7+rJ7ZGfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBHggYU+b1AxkgwXpkzhqx5tNr12RlHfQJ0CWUXBePqPVkAdQnaOTF0RwenoZRBai
	 XAnLN8QLbVP5NyC3PpG/SBm5obpWHNzia6yW8zWVL+izaaBpjIAAQ6fBSZpmmrJBeP
	 wBW0k0AaZGLE4qawEpx3O5KT0KLbgEdhrUKetVgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/222] crypto: ecdsa - Convert byte arrays with key coordinates to digits
Date: Mon,  6 Jan 2025 16:13:46 +0100
Message-ID: <20250106151151.443565564@linuxfoundation.org>
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

[ Upstream commit d67c96fb97b5811e15c881d5cb72e293faa5f8e1 ]

For NIST P192/256/384 the public key's x and y parameters could be copied
directly from a given array since both parameters filled 'ndigits' of
digits (a 'digit' is a u64). For support of NIST P521 the key parameters
need to have leading zeros prepended to the most significant digit since
only 2 bytes of the most significant digit are provided.

Therefore, implement ecc_digits_from_bytes to convert a byte array into an
array of digits and use this function in ecdsa_set_pub_key where an input
byte array needs to be converted into digits.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Tested-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3b0565c70350 ("crypto: ecdsa - Avoid signed integer overflow on signature decoding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdsa.c                | 14 +++++++++-----
 include/crypto/internal/ecc.h | 21 +++++++++++++++++++++
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index 3f9ec273a121..e819d0983bd3 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -222,9 +222,8 @@ static int ecdsa_ecc_ctx_reset(struct ecc_ctx *ctx)
 static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *key, unsigned int keylen)
 {
 	struct ecc_ctx *ctx = akcipher_tfm_ctx(tfm);
+	unsigned int digitlen, ndigits;
 	const unsigned char *d = key;
-	const u64 *digits = (const u64 *)&d[1];
-	unsigned int ndigits;
 	int ret;
 
 	ret = ecdsa_ecc_ctx_reset(ctx);
@@ -238,12 +237,17 @@ static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *key, unsig
 		return -EINVAL;
 
 	keylen--;
-	ndigits = (keylen >> 1) / sizeof(u64);
+	digitlen = keylen >> 1;
+
+	ndigits = DIV_ROUND_UP(digitlen, sizeof(u64));
 	if (ndigits != ctx->curve->g.ndigits)
 		return -EINVAL;
 
-	ecc_swap_digits(digits, ctx->pub_key.x, ndigits);
-	ecc_swap_digits(&digits[ndigits], ctx->pub_key.y, ndigits);
+	d++;
+
+	ecc_digits_from_bytes(d, digitlen, ctx->pub_key.x, ndigits);
+	ecc_digits_from_bytes(&d[digitlen], digitlen, ctx->pub_key.y, ndigits);
+
 	ret = ecc_is_pubkey_valid_full(ctx->curve, &ctx->pub_key);
 
 	ctx->pub_key_set = ret == 0;
diff --git a/include/crypto/internal/ecc.h b/include/crypto/internal/ecc.h
index 4f6c1a68882f..ab722a8986b7 100644
--- a/include/crypto/internal/ecc.h
+++ b/include/crypto/internal/ecc.h
@@ -56,6 +56,27 @@ static inline void ecc_swap_digits(const void *in, u64 *out, unsigned int ndigit
 		out[i] = get_unaligned_be64(&src[ndigits - 1 - i]);
 }
 
+/**
+ * ecc_digits_from_bytes() - Create ndigits-sized digits array from byte array
+ * @in:       Input byte array
+ * @nbytes    Size of input byte array
+ * @out       Output digits array
+ * @ndigits:  Number of digits to create from byte array
+ */
+static inline void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
+					 u64 *out, unsigned int ndigits)
+{
+	unsigned int o = nbytes & 7;
+	__be64 msd = 0;
+
+	if (o) {
+		memcpy((u8 *)&msd + sizeof(msd) - o, in, o);
+		out[--ndigits] = be64_to_cpu(msd);
+		in += o;
+	}
+	ecc_swap_digits(in, out, ndigits);
+}
+
 /**
  * ecc_is_key_valid() - Validate a given ECDH private key
  *
-- 
2.39.5



