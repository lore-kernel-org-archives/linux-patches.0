Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AEC1C695;
	Thu,  2 Jul 2026 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011345; cv=none; b=dZVx5HnEyT342fFN9imo8w5pfl86WrImPi2YaO/ni5PMRV/zbMSeC3DSXAtkr/ed/gieUcYcRIskSlg+DzbxCJvU72wx48zDvErOzx+q5UcFXIsrqoXfebZAjYNPTDvIYOMvCDVmxEyiJbw8vhlR8OHtf60cG8uM1180vR9PTKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011345; c=relaxed/simple;
	bh=R09lQMWz1o3IQZMddEn8sdFTt+n7rtkZTDqQPaBHI94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+0+iZio0rROtIncE+RE8BQ9+tMCKyqtcexmepd4xrsEJtynxgUBVlJKQSiPZcGXyhhaw0/1t/WjX3o+jVm6XVc2Nt2VfNTYKhMu87reJmltZRBv3H6Hl/YHySr2pXptFakuBsIs7yd2OdSQpVdka3vTH2fBi4PdXDVzqh6847I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NT/8HOOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NT/8HOOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAFC1F000E9;
	Thu,  2 Jul 2026 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011344;
	bh=WZdo2KjgzWCIK22XgJ4ZGeBb1tslf7Qa9ws+9wFGXwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NT/8HOOkby4WoeGttcPXmgIAJMbjKv8+3nq0H+9TsXmsN2JHhYBDhpusKTQ8Q8FDG
	 im8088uZMoaZ4sSt5lrCOKfcF1NfLNPAXtpbKYrPYNvnFwqcIqXn41oAPAlJ19E/e5
	 ZMsZjlHvCD3BPY9/8ehzHAG0bEEn8y6sstXirgsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Calvin Buckley <calvin@cmpct.info>,
	Brad Spengler <brad.spengler@opensrcsec.com>,
	Sam James <sam@gentoo.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 073/108] crypto: nx - fix nx_crypto_ctx_exit argument
Date: Thu,  2 Jul 2026 18:21:10 +0200
Message-ID: <20260702155113.623281511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Sam James <sam@gentoo.org>

commit 4e67f504ee9ded15e256b64f4fde150e917381d7 upstream.

nx_crypto_ctx_shash_exit calls nx_crypto_ctx_exit with crypto_shash_ctx(...)
but crypto_shash_ctx gives a nx_crypto_ctx *, not a crypto_tfm *.

Fix the type in nx_crypto_ctx_exit and drop the bogus crypto_tfm_ctx
call.

This fixes the following oops:

  BUG: Unable to handle kernel data access at 0xc0403effffffffc8
  Faulting instruction address: 0xc000000000396cb4
  Oops: Kernel access of bad area, sig: 11 [#15]
  Call Trace:
   nx_crypto_ctx_shash_exit+0x24/0x60
   crypto_shash_exit_tfm+0x28/0x40
   crypto_destroy_tfm+0x98/0x140
   crypto_exit_ahash_using_shash+0x20/0x40
   crypto_destroy_tfm+0x98/0x140
   hash_release+0x1c/0x30
   alg_sock_destruct+0x38/0x60
   __sk_destruct+0x48/0x2b0
   af_alg_release+0x58/0xb0
   __sock_release+0x68/0x150
   sock_close+0x20/0x40
   __fput+0x110/0x3a0
   sys_close+0x48/0xa0
   system_call_exception+0x140/0x2d0
   system_call_common+0xf4/0x258

.. which came from hardlink(1) opportunistically using AF_ALG.

The same problem exists with nx_crypto_ctx_skcipher_exit getting a context
it wasn't expecting, but apparently nobody hit that for years.

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org
Fixes: bfd9efddf990 ("crypto: nx - convert AES-ECB to skcipher API")
Fixes: 9420e628e7d8 ("crypto: nx - Use API partial block handling")
Acked-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Reported-by: Calvin Buckley <calvin@cmpct.info>
Tested-by: Calvin Buckley <calvin@cmpct.info>
Suggested-by: Brad Spengler <brad.spengler@opensrcsec.com>
Signed-off-by: Sam James <sam@gentoo.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/nx/nx.c |    6 ++----
 drivers/crypto/nx/nx.h |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -714,15 +714,13 @@ int nx_crypto_ctx_aes_xcbc_init(struct c
 /**
  * nx_crypto_ctx_exit - destroy a crypto api context
  *
- * @tfm: the crypto transform pointer for the context
+ * @nx_ctx: the crypto api context
  *
  * As crypto API contexts are destroyed, this exit hook is called to free the
  * memory associated with it.
  */
-void nx_crypto_ctx_exit(struct crypto_tfm *tfm)
+void nx_crypto_ctx_exit(struct nx_crypto_ctx *nx_ctx)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
-
 	kfree_sensitive(nx_ctx->kmem);
 	nx_ctx->csbcpb = NULL;
 	nx_ctx->csbcpb_aead = NULL;
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -153,7 +153,7 @@ int nx_crypto_ctx_aes_ctr_init(struct cr
 int nx_crypto_ctx_aes_cbc_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_sha_init(struct crypto_shash *tfm);
-void nx_crypto_ctx_exit(struct crypto_tfm *tfm);
+void nx_crypto_ctx_exit(struct nx_crypto_ctx *nx_ctx);
 void nx_crypto_ctx_skcipher_exit(struct crypto_skcipher *tfm);
 void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm);
 void nx_crypto_ctx_shash_exit(struct crypto_shash *tfm);


