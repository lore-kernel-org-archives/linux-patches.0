Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E57229B05;
	Tue, 29 Apr 2025 17:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946167; cv=none; b=XD7o9qUlbB8DkJcX4JJ/rMDBhV4UhliwnCG1G80RzPbF9pyY90Kp37KhKAkDeBsSgQG1hvS0tlexTtB7TLWRIXokWRvN8HYu9KVFvcRqawaVffKj/L4sgb9qUH4nkd2i1PVP2WIBDPRrT60wNa2dBZXjPfO18JJIczlE0pqDrGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946167; c=relaxed/simple;
	bh=GJ04eBvDLbt437VUbAvmbD8PEzCTcfQhbdrjmY7Iqa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7nQCUq+fCb2VxUHB9avDXKe02x2hIOJmCWm8ZR3b0A4yIuC6WyKhfwXA8IvZOVAepEfbPsa+YI+Whu36zVFlP7MqsO358m7FzLSQGjMQFwcZFs8jp6/A0slqnzsYfdXDC6XFsXW8l8dyYb21UkUfiNxdy36twz/JXf7RVr2smA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWzWfydK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWzWfydK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD86C4CEE3;
	Tue, 29 Apr 2025 17:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946167;
	bh=GJ04eBvDLbt437VUbAvmbD8PEzCTcfQhbdrjmY7Iqa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWzWfydKh7CycA9Qh3sySDxCcZmo1kAourZfU0Zj9lcJWHkb4GTpcISG5ep5yP/lc
	 82bdGEU9hJu8h2JwoUBtudy4jzpn9q9wGiBgYBupb8FtPouxu12b1KYXqrTwPh9XPQ
	 1DFTxYl9O+/Y5tqTmpsa3jZHaF0U4IEbJxSl5Nks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 177/311] crypto: ecdsa - Harden against integer overflows in DIV_ROUND_UP()
Date: Tue, 29 Apr 2025 18:40:14 +0200
Message-ID: <20250429161128.278346321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit b16510a530d1e6ab9683f04f8fb34f2e0f538275 ]

Herbert notes that DIV_ROUND_UP() may overflow unnecessarily if an ecdsa
implementation's ->key_size() callback returns an unusually large value.
Herbert instead suggests (for a division by 8):

  X / 8 + !!(X & 7)

Based on this formula, introduce a generic DIV_ROUND_UP_POW2() macro and
use it in lieu of DIV_ROUND_UP() for ->key_size() return values.

Additionally, use the macro in ecc_digits_from_bytes(), whose "nbytes"
parameter is a ->key_size() return value in some instances, or a
user-specified ASN.1 length in the case of ecdsa_get_signature_rs().

Link: https://lore.kernel.org/r/Z3iElsILmoSu6FuC@gondor.apana.org.au/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecc.c         |  2 +-
 crypto/ecdsa-p1363.c |  2 +-
 crypto/ecdsa-x962.c  |  4 ++--
 include/linux/math.h | 12 ++++++++++++
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 50ad2d4ed672c..6cf9a945fc6c2 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -71,7 +71,7 @@ EXPORT_SYMBOL(ecc_get_curve);
 void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
 			   u64 *out, unsigned int ndigits)
 {
-	int diff = ndigits - DIV_ROUND_UP(nbytes, sizeof(u64));
+	int diff = ndigits - DIV_ROUND_UP_POW2(nbytes, sizeof(u64));
 	unsigned int o = nbytes & 7;
 	__be64 msd = 0;
 
diff --git a/crypto/ecdsa-p1363.c b/crypto/ecdsa-p1363.c
index eaae7214d69bc..4454f1f8f33f5 100644
--- a/crypto/ecdsa-p1363.c
+++ b/crypto/ecdsa-p1363.c
@@ -22,7 +22,7 @@ static int ecdsa_p1363_verify(struct crypto_sig *tfm,
 {
 	struct ecdsa_p1363_ctx *ctx = crypto_sig_ctx(tfm);
 	unsigned int keylen = crypto_sig_keysize(ctx->child);
-	unsigned int ndigits = DIV_ROUND_UP(keylen, sizeof(u64));
+	unsigned int ndigits = DIV_ROUND_UP_POW2(keylen, sizeof(u64));
 	struct ecdsa_raw_sig sig;
 
 	if (slen != 2 * keylen)
diff --git a/crypto/ecdsa-x962.c b/crypto/ecdsa-x962.c
index 6a77c13e192b1..90a04f4b9a2f5 100644
--- a/crypto/ecdsa-x962.c
+++ b/crypto/ecdsa-x962.c
@@ -81,8 +81,8 @@ static int ecdsa_x962_verify(struct crypto_sig *tfm,
 	struct ecdsa_x962_signature_ctx sig_ctx;
 	int err;
 
-	sig_ctx.ndigits = DIV_ROUND_UP(crypto_sig_keysize(ctx->child),
-				       sizeof(u64));
+	sig_ctx.ndigits = DIV_ROUND_UP_POW2(crypto_sig_keysize(ctx->child),
+					    sizeof(u64));
 
 	err = asn1_ber_decoder(&ecdsasignature_decoder, &sig_ctx, src, slen);
 	if (err < 0)
diff --git a/include/linux/math.h b/include/linux/math.h
index f5f18dc3616b0..0198c92cbe3ef 100644
--- a/include/linux/math.h
+++ b/include/linux/math.h
@@ -34,6 +34,18 @@
  */
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
+/**
+ * DIV_ROUND_UP_POW2 - divide and round up
+ * @n: numerator
+ * @d: denominator (must be a power of 2)
+ *
+ * Divides @n by @d and rounds up to next multiple of @d (which must be a power
+ * of 2). Avoids integer overflows that may occur with __KERNEL_DIV_ROUND_UP().
+ * Performance is roughly equivalent to __KERNEL_DIV_ROUND_UP().
+ */
+#define DIV_ROUND_UP_POW2(n, d) \
+	((n) / (d) + !!((n) & ((d) - 1)))
+
 #define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
 
 #define DIV_ROUND_DOWN_ULL(ll, d) \
-- 
2.39.5



