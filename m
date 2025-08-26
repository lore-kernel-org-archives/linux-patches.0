Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AAD3314DF;
	Tue, 26 Aug 2025 11:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208197; cv=none; b=Al+lS1TGyaMgGkOZKnCYKUjueEcVPQF+ro67CvwTei6kCR8xu7OCQQ8snhiouZKjSJR4y1dKEzFyCwDu3Y8O8f/yfVsBOnOxeueweYKq9dQDU0f4OE1p2JC7SzLqakt5hesMC7N3ZsN6rlrUjn6MLo4S2g1nnUP6ImVuBSx7dew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208197; c=relaxed/simple;
	bh=OUoK7VZfn3Yu5leZZOPHtqBuZJ+uWjfAMGjCsildkL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZjnto4wOeTpARhlrvEvUYq+41VL/Usm+59YmiMVxFS++BADDSaFR5lFtyNwKDv+ZVGBlG/YdUMrCA3NzmGFXopldrdpE0dXztMfVuIPoZFDF+ricdH0bvIAax9TMCAR96IHldzetj5vCMS3NeAA4+zOpSKGbmcDkt2jZwJin7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tFTU0Wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tFTU0Wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A94C4CEF1;
	Tue, 26 Aug 2025 11:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208197;
	bh=OUoK7VZfn3Yu5leZZOPHtqBuZJ+uWjfAMGjCsildkL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tFTU0WrvfGsM1qCCLCSCWCIVgUE+vPzLBce/gHAu3rnhsIt3vuRc4DLP++kcrRhZ
	 Npr/neyplbKUFndQMkQiPQvyZ9pF4kh/GvGr41O+UWgmFrVPyu9d5Fpx+ceW2JHuR6
	 0RMZJX5qIYuXDBZZzhlfomQSbnDc6Adse/o+fdOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 019/322] crypto: qat - lower priority for skcipher and aead algorithms
Date: Tue, 26 Aug 2025 13:07:14 +0200
Message-ID: <20250826110915.733514485@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


