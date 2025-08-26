Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF7A22A4E5;
	Tue, 26 Aug 2025 13:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213523; cv=none; b=jPLJjUf6It3Tjxn7awW/NkeFEkjHOqv8HNt2X2tDcM29suA64a7L46LkGbJxOr9dxcTdRhTb76uBG5xaXyWoPOWhbcS/1tbC1pdC7npq3pSa2Zj7bPf3FXWW4Z+6TCdUkxJ2CM5rXa4nS2Xkwf7LxHlWNWOpBgbeG2HJ8cyurgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213523; c=relaxed/simple;
	bh=aQN8c0l4/RS7SWsFuEPLuPJKnoKYky4NNJQDc5xNkkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkrDCZkEAT0FCLZgb4Z70sL9vrVvcyvtGQ3wcOITZNLzq08DIfEk0r3nyte/E/A7KZ3hE+SawJLwTieABz7xXWBbvn0FSoHiUhSPv8+kogxmVFXPVCEXmbibAJgpRhlj0E6nMmBYRE2hTScV13OF7ij94oEsb8w3lz7QvhvrSIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lYEaegt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lYEaegt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72852C113CF;
	Tue, 26 Aug 2025 13:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213522;
	bh=aQN8c0l4/RS7SWsFuEPLuPJKnoKYky4NNJQDc5xNkkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lYEaegtf9/rEvqBlBdYPoa9CGaOTxvA6QFHVc2U7yEmKkhNEttD5WJJ8XH5bXd5Q
	 fQ7KtL2prnsqBk3FuUYZ6tkTWV3nxHLFgrl5LXXRJ6pMmBm1p0CfY8cbWb5+M8vLcu
	 Nc+H0Whf/FihOvYvhhUBpedV11dqGvuD7NV3bZiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 342/587] crypto: qat - lower priority for skcipher and aead algorithms
Date: Tue, 26 Aug 2025 13:08:11 +0200
Message-ID: <20250826111001.615416150@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit 8024774190a5ef2af2c5846f60a50b23e0980a32 upstream.

Most kernel applications utilizing the crypto API operate synchronously
and on small buffer sizes, therefore do not benefit from QAT acceleration.

Reduce the priority of QAT implementations for both skcipher and aead
algorithms, allowing more suitable alternatives to be selected by default.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Link: https://lore.kernel.org/all/20250613012357.GA3603104@google.com/
Cc: stable@vger.kernel.org
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/qat_algs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -1277,7 +1277,7 @@ static struct aead_alg qat_aeads[] = { {
 	.base = {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
-		.cra_priority = 4001,
+		.cra_priority = 100,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
@@ -1294,7 +1294,7 @@ static struct aead_alg qat_aeads[] = { {
 	.base = {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
-		.cra_priority = 4001,
+		.cra_priority = 100,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
@@ -1311,7 +1311,7 @@ static struct aead_alg qat_aeads[] = { {
 	.base = {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
-		.cra_priority = 4001,
+		.cra_priority = 100,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
@@ -1329,7 +1329,7 @@ static struct aead_alg qat_aeads[] = { {
 static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "qat_aes_cbc",
-	.base.cra_priority = 4001,
+	.base.cra_priority = 100,
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
@@ -1347,7 +1347,7 @@ static struct skcipher_alg qat_skciphers
 }, {
 	.base.cra_name = "ctr(aes)",
 	.base.cra_driver_name = "qat_aes_ctr",
-	.base.cra_priority = 4001,
+	.base.cra_priority = 100,
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
@@ -1365,7 +1365,7 @@ static struct skcipher_alg qat_skciphers
 }, {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "qat_aes_xts",
-	.base.cra_priority = 4001,
+	.base.cra_priority = 100,
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK |
 			  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,


