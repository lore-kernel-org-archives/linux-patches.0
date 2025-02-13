Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A164126981F;
	Thu, 13 Feb 2025 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458083; cv=none; b=HLCfT6VjcIdTEygKnI01KAbm8Sb92W6VQ8+LEVKmKt9XDhDs7g7zbKmeasxxkSghs3eW4xrnwN+ttyiPxyuBpmijfTB1mbz3QPpd/5bze0WJT9Ew5ulXsFb5yd01Mv5FXsPDOeJpCZSoKVJZJk9Gt57Y8zHZ466L2dOnZrXEpjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458083; c=relaxed/simple;
	bh=plO5H2H/tqw7mqlGSTRCuC1RIGW6en1pqeFdVfzy3KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5VGnekSDjkHoYqdd0Td5TdBIyGRupk1AidIuTqJze71OJBwJ/kdTGPe00P0nqsO5W9sWhkfxJGDTE13EzkX4AcNieHFTxOncfqRuehSbZxyHj7TjfCYn9U8nIGdovgysot9HtvrKJGoltwO2+bBHuKAi9RQ3qqcrJ7in0292UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqOmRiu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqOmRiu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D881C4CEE5;
	Thu, 13 Feb 2025 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458083;
	bh=plO5H2H/tqw7mqlGSTRCuC1RIGW6en1pqeFdVfzy3KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqOmRiu3Z8WQ+B2t38WsbBdGRzqWejX23IcYPFD4H/vs1GfoBrX0QcK+JSSOyuTI1
	 onaB2B4hrZ5Eh8C8PuI8cYJTHhVL/RLVBUvV1bHEn+7bt2kY60/dS7E/RzNG1ihiGS
	 UC14p3iZrvjMjrmZoh8zNlfVCmuLGVMDMVJkpTgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Eric Biggers <ebiggers@google.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 295/422] crypto: qce - fix priority to be less than ARMv8 CE
Date: Thu, 13 Feb 2025 15:27:24 +0100
Message-ID: <20250213142447.926596305@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 49b9258b05b97c6464e1964b6a2fddb3ddb65d17 upstream.

As QCE is an order of magnitude slower than the ARMv8 Crypto Extensions
on the CPU, and is also less well tested, give it a lower priority.
Previously the QCE SHA algorithms had higher priority than the ARMv8 CE
equivalents, and the ciphers such as AES-XTS had the same priority which
meant the QCE versions were chosen if they happened to be loaded later.

Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Cc: stable@vger.kernel.org
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/aead.c     |    2 +-
 drivers/crypto/qce/sha.c      |    2 +-
 drivers/crypto/qce/skcipher.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -786,7 +786,7 @@ static int qce_aead_register_one(const s
 	alg->init			= qce_aead_init;
 	alg->exit			= qce_aead_exit;
 
-	alg->base.cra_priority		= 300;
+	alg->base.cra_priority		= 275;
 	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY |
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -482,7 +482,7 @@ static int qce_ahash_register_one(const
 
 	base = &alg->halg.base;
 	base->cra_blocksize = def->blocksize;
-	base->cra_priority = 300;
+	base->cra_priority = 175;
 	base->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 	base->cra_ctxsize = sizeof(struct qce_sha_ctx);
 	base->cra_alignmask = 0;
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -461,7 +461,7 @@ static int qce_skcipher_register_one(con
 	alg->encrypt			= qce_skcipher_encrypt;
 	alg->decrypt			= qce_skcipher_decrypt;
 
-	alg->base.cra_priority		= 300;
+	alg->base.cra_priority		= 275;
 	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY;


