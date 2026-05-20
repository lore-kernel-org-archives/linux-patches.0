Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120EF32B9B5;
	Wed, 20 May 2026 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300397; cv=none; b=iM1xMU3y3qMzk8CbHxCJQmb0XomJV3ClF9EIFgBo3YHllLWSHN9jJXIXiGRqohKyUB97vuINZO+BgTBGp0vMHYIhcAlUvrgRoPMi0mDW8M3hP5ygHsFSh4oPvJ4B+mrTy+r2KeU/UUz3RtjVbMoxe+8auBrNiLTxglPk4o0oDzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300397; c=relaxed/simple;
	bh=HQiB4lnmpojSfvD8zWOW1pvByI69+rch3bY0LooUow8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnRHONLdZ04hI1lp8XXVHUkmlCUUvRUAehVespgL6riatj2kQ+NytN+zSZidfI0SVIuJ+/FFWlAnYSoq2V4CK3pP8Kr5pULDtXiAoN+voF3TKtCy/HfDu7+HR8eQlf4NH/9GqVFivOdG6fidTzDGVFNYiewYcJG8fnPfO2HSq3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxbE+QI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxbE+QI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B5D1F000E9;
	Wed, 20 May 2026 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300396;
	bh=HGTJmbxAAXE73J3ekVY9agRPEe55d5s7GnQRj5lez98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxbE+QI6mq3RYnQlXu/6r717zvtrK2MSAwjrLolMKBFrpLV5sJWnVGUCAqaIyeyr5
	 yKZ21R/yko2tPrYh99UfUDbgmDVkzRpKL5AFT0DUEo9c2XWNGrhfnxeWex4h9amG0t
	 vCDmPywRIf7wn4hY7W8uGrtZBIEnTPis06WfENo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/666] crypto: atmel-aes - guard unregister on error in atmel_aes_register_algs
Date: Wed, 20 May 2026 18:16:09 +0200
Message-ID: <20260520162114.632709816@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 57a13941c0bb06ae24e3b34672d7b6f2172b253f ]

Ensure the device supports XTS and GCM with 'has_xts' and 'has_gcm'
before unregistering algorithms when XTS or authenc registration fails,
which would trigger a WARN in crypto_unregister_alg().

Currently, with the capabilities defined in atmel_aes_get_cap(), this
bug cannot happen because all devices that support XTS and authenc also
support GCM, but the error handling should still be correct regardless
of hardware capabilities.

Fixes: d52db5188a87 ("crypto: atmel-aes - add support to the XTS mode")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index cf923be68a00f..5d35f6de452b7 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2269,10 +2269,12 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
 	crypto_unregister_aeads(aes_authenc_algs, i);
-	crypto_unregister_skcipher(&aes_xts_alg);
+	if (dd->caps.has_xts)
+		crypto_unregister_skcipher(&aes_xts_alg);
 #endif
 err_aes_xts_alg:
-	crypto_unregister_aead(&aes_gcm_alg);
+	if (dd->caps.has_gcm)
+		crypto_unregister_aead(&aes_gcm_alg);
 err_aes_gcm_alg:
 	i = ARRAY_SIZE(aes_algs);
 err_aes_algs:
-- 
2.53.0



