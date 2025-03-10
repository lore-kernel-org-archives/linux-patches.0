Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3650F1C4A24;
	Mon, 10 Mar 2025 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629462; cv=none; b=LqMPYE9iRvBR1QRwqct55k42LoVRJOvawfRtN/VeUscbwultR8ncjNGTDw7Yiboo8tRr1aEpMoWLOidVuwLVGrWkrfg7n1z7ohoYtQwCq2mQJjTysOzM0nS/RNGOKQ7rE9ifpE8IUDivFl0FDlNhL/O8jUC47KiAUg9dM0RCIYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629462; c=relaxed/simple;
	bh=Dl7e+2he79y2qusisPzzY/KrasmuMCIogootsXl0TuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3amW8uGQBIY2dnSHrhURGjT1jWsmEtmRgKnbxNi//NHyqg5cj5Xv3R2wcRGCLi6jxGAAd+06XkGxkDv7MfK2axqMj8upAfXE5j9sTC53mIFKewkI2B4ptcCOQCfHTtfR8zx0RTBL30BoU6mEn6eJuHc3gg/iQkgt6+fwLrg5iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lsm0Xm9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lsm0Xm9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AFFC4CEE5;
	Mon, 10 Mar 2025 17:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629461;
	bh=Dl7e+2he79y2qusisPzzY/KrasmuMCIogootsXl0TuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lsm0Xm9W4aMY0xvxRZNuD9S4wDR2d+o5fxlsZQHUzWhMU4s12Pyf+z/U+emWCHxAk
	 zI6FfNXF2PrtYmKyZQM1uAV2PqFQ8+2jg8Sf78SNEbNmZSDM+HaefdRswgZ8kKOj00
	 7bVud14TU2lRYzq6BDTu7EY/kBIrmBce895Ag4Pk=
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
Subject: [PATCH 5.15 302/620] crypto: qce - fix priority to be less than ARMv8 CE
Date: Mon, 10 Mar 2025 18:02:28 +0100
Message-ID: <20250310170557.543017941@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -480,7 +480,7 @@ static int qce_ahash_register_one(const
 
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


