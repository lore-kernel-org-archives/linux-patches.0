Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD635684;
	Thu, 13 Feb 2025 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459648; cv=none; b=AgvwwLZkwc/fmgh92iMLi0E//Lvo3GKJtsX7q9w2CzpeY0UgowflrynBFnRlUcKPbsfcjsMHIU69tqAFLSeaf042gUKU0BX0wEHnKemCQL5X6pWAC96PzDFgQHT36CrqtfqHSq6nARiBwtt4BCxk5xn8NkeFRiKtUyw3h33rQHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459648; c=relaxed/simple;
	bh=jSVFFf7/vCI1uib/BU+g1PSRwOM62QGL/b5tsgWTA9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOo5tu7XxSlTM+bMBepBNFIfGy+OtARQkP827JsY+HB6XCBBl/26VYDmm8Lf7EAebszpDm5O9kLqNbGhYn0hwQDDhLb2y6kLGuxyVbdd/PLjdwt1e67kEIYjh3D5Wo/P0KUtNuBg39Vl74I68bsMUenjvv1HD2HaGtj2y5nl08U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uknhho/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uknhho/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E63C4CED1;
	Thu, 13 Feb 2025 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459648;
	bh=jSVFFf7/vCI1uib/BU+g1PSRwOM62QGL/b5tsgWTA9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uknhho/UIz80batZCyWq5cxCWYCoG1ZfkzaOC5ueTfq7AqBvOeDSNaupqTFp/ax9x
	 yYrw+hIqGzfNOn+jfV5tMYlKYpZOXbW7GLfNgkfyxK6QvoAvZGaEvR2BhBwVc3Ivq+
	 QFrK7eFYvSUi1ZzZgL9GadWTeircfCc6wFyv4ryE=
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
Subject: [PATCH 6.13 324/443] crypto: qce - fix priority to be less than ARMv8 CE
Date: Thu, 13 Feb 2025 15:28:09 +0100
Message-ID: <20250213142453.121707628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


