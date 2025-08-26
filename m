Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1B52264A3;
	Tue, 26 Aug 2025 11:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207027; cv=none; b=j41xsz7sNHip52GoExNFDAVT4fgaXO8I1aORDiijtl/vV7tJVkG8sEF8qp6GwskyMMiHUk2dra4wKNEe9gSCoeljPbmQA8I1C5ktEDWzI4FUkUyKE9M4WoRqQG2912ZpO6RtqkNA4Djcp+kF2jACxJkDG8ihTp1nN3h5JEY6cJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207027; c=relaxed/simple;
	bh=la/aBSxLSuMfMhQUsjRlNpAamnEc2itkcDnprhlnQQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdufqxN4qu1emg0F4nkF7S9yHihQEIMqQagsRzDu4nidFBNyXGa0xb9TZalRryzT8wjaMGc+kqcRwSURIFCZmi5jdb3LPKaCQLWcG3oEZEFIuvXl0xQkYd0+SG/M79urNFRvTfnA680Df4i/AL+8kok3lNhQWCCG06XwQg3kmJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVUDvuP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVUDvuP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF89DC4CEF1;
	Tue, 26 Aug 2025 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207027;
	bh=la/aBSxLSuMfMhQUsjRlNpAamnEc2itkcDnprhlnQQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVUDvuP783wFw7Iox29F4/qQ76ViKUz9l2GoegjODlC4GN+FQPGwcpRVUuiCCKYXE
	 ukjzW7LSdVOBMdqhj5OllAmcmmH4fUH8yoaHQlx2ijb//+jF0FbHZzU3dEz8kE+7pF
	 Va4iDFokb1z8T1FxKgq96Ir4v0hnMcG/goIVKt8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.16 023/457] crypto: qat - lower priority for skcipher and aead algorithms
Date: Tue, 26 Aug 2025 13:05:07 +0200
Message-ID: <20250826110937.904144108@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


