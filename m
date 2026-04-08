Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E702B2BD030;
	Wed,  8 Apr 2026 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673434; cv=none; b=YsDG2gf34Yp2rWz+UR928iZjzKTehCNuZIlycWXqqj3O+CC36yK638vphauas/hzaWeBxcI7SZLwU0H/zEH/e1/5OJ2t+ve/8pt7WcuHAUiesAbeCfJ9jsz1UQbiW7Z3i+MFLO3FzIBOJbsQ71NsqxmapssNXMHEHstEPW/i4D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673434; c=relaxed/simple;
	bh=ptfFUNd4uyqdiAzKkVYGcTF3os3sl42jIoAxoWrWP4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9dXLhS6uuO/KzbteObv6GXi9TTVwRkgBsQL+5vwziBin7shK7q9xrG355yXaX8b+oak+4nRLmea2qaejpe9OmPLe6ibhppovcHtQObrYK06uj6BV4vcMXiK85P0ba5vbyaZcg/3XxH2k7lJSXfh9P5fRbpGjbwFNLSfwaKx6JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfpRiv7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfpRiv7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D39EC19421;
	Wed,  8 Apr 2026 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673433;
	bh=ptfFUNd4uyqdiAzKkVYGcTF3os3sl42jIoAxoWrWP4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfpRiv7NjPy7993nWrUxpfmuqp3qx2vjNAq+Wj6RJdHwwtddzxFJYCb3wQtnRn2mO
	 nNoWy3Ab+MSYOvrhHz1w1dJUcSzdeuYbhRPx+UoB+mVxo3blV9IxJSbFxBcOHvNLTq
	 C1ljhGL3Zxd7tfX1XNegtw5LLC8r1OSVxTQNV4JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zorro Lang <zlang@redhat.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 231/277] crypto: tegra - Add missing CRYPTO_ALG_ASYNC
Date: Wed,  8 Apr 2026 20:03:36 +0200
Message-ID: <20260408175942.483430554@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 4b56770d345524fc2acc143a2b85539cf7d74bc1 upstream.

The tegra crypto driver failed to set the CRYPTO_ALG_ASYNC on its
asynchronous algorithms, causing the crypto API to select them for users
that request only synchronous algorithms.  This causes crashes (at
least).  Fix this by adding the flag like what the other drivers do.
Also remove the unnecessary CRYPTO_ALG_TYPE_* flags, since those just
get ignored and overridden by the registration function anyway.

Reported-by: Zorro Lang <zlang@redhat.com>
Closes: https://lore.kernel.org/r/20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Cc: stable@vger.kernel.org
Cc: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/tegra/tegra-se-aes.c  |   11 +++++++----
 drivers/crypto/tegra/tegra-se-hash.c |   30 +++++++++++++++++-------------
 2 files changed, 24 insertions(+), 17 deletions(-)

--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -529,7 +529,7 @@ static struct tegra_se_alg tegra_aes_alg
 				.cra_name = "cbc(aes)",
 				.cra_driver_name = "cbc-aes-tegra",
 				.cra_priority = 500,
-				.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_aes_ctx),
 				.cra_alignmask = 0xf,
@@ -550,7 +550,7 @@ static struct tegra_se_alg tegra_aes_alg
 				.cra_name = "ecb(aes)",
 				.cra_driver_name = "ecb-aes-tegra",
 				.cra_priority = 500,
-				.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_aes_ctx),
 				.cra_alignmask = 0xf,
@@ -572,7 +572,7 @@ static struct tegra_se_alg tegra_aes_alg
 				.cra_name = "ctr(aes)",
 				.cra_driver_name = "ctr-aes-tegra",
 				.cra_priority = 500,
-				.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct tegra_aes_ctx),
 				.cra_alignmask = 0xf,
@@ -594,6 +594,7 @@ static struct tegra_se_alg tegra_aes_alg
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-tegra",
 				.cra_priority = 500,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize	   = sizeof(struct tegra_aes_ctx),
 				.cra_alignmask	   = (__alignof__(u64) - 1),
@@ -1922,6 +1923,7 @@ static struct tegra_se_alg tegra_aead_al
 				.cra_name = "gcm(aes)",
 				.cra_driver_name = "gcm-aes-tegra",
 				.cra_priority = 500,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
 				.cra_alignmask = 0xf,
@@ -1944,6 +1946,7 @@ static struct tegra_se_alg tegra_aead_al
 				.cra_name = "ccm(aes)",
 				.cra_driver_name = "ccm-aes-tegra",
 				.cra_priority = 500,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
 				.cra_alignmask = 0xf,
@@ -1971,7 +1974,7 @@ static struct tegra_se_alg tegra_cmac_al
 				.cra_name = "cmac(aes)",
 				.cra_driver_name = "tegra-se-cmac",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_cmac_ctx),
 				.cra_alignmask = 0,
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -761,7 +761,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha1",
 				.cra_driver_name = "tegra-se-sha1",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -786,7 +786,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha224",
 				.cra_driver_name = "tegra-se-sha224",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -811,7 +811,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha256",
 				.cra_driver_name = "tegra-se-sha256",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -836,7 +836,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha384",
 				.cra_driver_name = "tegra-se-sha384",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -861,7 +861,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha512",
 				.cra_driver_name = "tegra-se-sha512",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -886,7 +886,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha3-224",
 				.cra_driver_name = "tegra-se-sha3-224",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA3_224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -911,7 +911,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha3-256",
 				.cra_driver_name = "tegra-se-sha3-256",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA3_256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -936,7 +936,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha3-384",
 				.cra_driver_name = "tegra-se-sha3-384",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA3_384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -961,7 +961,7 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "sha3-512",
 				.cra_driver_name = "tegra-se-sha3-512",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA3_512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -988,7 +988,8 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "hmac(sha224)",
 				.cra_driver_name = "tegra-se-hmac-sha224",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -1015,7 +1016,8 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "tegra-se-hmac-sha256",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -1042,7 +1044,8 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "hmac(sha384)",
 				.cra_driver_name = "tegra-se-hmac-sha384",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
@@ -1069,7 +1072,8 @@ static struct tegra_se_alg tegra_hash_al
 				.cra_name = "hmac(sha512)",
 				.cra_driver_name = "tegra-se-hmac-sha512",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,


