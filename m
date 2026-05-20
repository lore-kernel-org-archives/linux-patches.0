Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD8A402421;
	Wed, 20 May 2026 18:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302902; cv=none; b=BJSr6w/WTPsVEFckiFk0/cLZWHHEFSPpe3IBKIq3gb4eviLESmw9DUqF/mBBD0U/Cvy8wl+WOPpGoPHvjB/4mmEzwKhPGyaw0PE+BKOL/fiLe/Jd2R3geIq10mH4rqTzvomf8xWQyyRJZINrDcINLH50leXl0EPK8pV1yzzWd2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302902; c=relaxed/simple;
	bh=BbWYbEEP2Eh7PDNSxQ9Z//LBBtSaI3aQwYOKL9FrRBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGgr9Bjkt9exhwEWMtH5GIeRa5FFLrZCJcWJMQiUruMZjP2cowKmPpAKRWry3tTwRLBbUp3t9ItH2uD+KXVQQE2Gim8sniZA6mK769Gz0R1LcHBAPRYUmuK8zqJwrHyH5EQBx2evlqCanWLw2FCXm3eCSZfm93dm8FY/dDTVI7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZAstA0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZAstA0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95C41F00893;
	Wed, 20 May 2026 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302901;
	bh=JYBlEYcOnW9950M5zm7PERjWsEFMGDtUm8rybM4Fffk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZAstA0DDazyckyoLgb4kFv8vFnZjcwe90JMxCtxJB3Sxu6alKr+7COHd8FR/icNK
	 HT+ZKcZ+IORpIwnM1QvuieJS2y80LWEqBpjbxWBT8zMcgf+9JwW92wx7OCX7GkJeu4
	 6EkdG8hWQ5PQlwgVOE5iBWo8PrJBsIGW0MWqJ+wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 444/508] crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx
Date: Wed, 20 May 2026 18:24:27 +0200
Message-ID: <20260520162108.219068469@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit adb3faf2db1a66d0f015b44ac909a32dfc7f2f9c ]

The bounce buffers are allocated with __get_free_pages() using
BOUNCE_BUFFER_ORDER (order 2 = 4 pages), but both the allocation error
path and nx842_crypto_free_ctx() release the buffers with free_page().
Use free_pages() with the matching order instead.

Fixes: ed70b479c2c0 ("crypto: nx - add hardware 842 crypto comp alg")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 82214cde2bcd9..3b82b6f67f8c4 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -112,8 +112,8 @@ int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
 		kfree(ctx->wmem);
-		free_page((unsigned long)ctx->sbounce);
-		free_page((unsigned long)ctx->dbounce);
+		free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
+		free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
 		return -ENOMEM;
 	}
 
@@ -126,8 +126,8 @@ void nx842_crypto_exit(struct crypto_tfm *tfm)
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	kfree(ctx->wmem);
-	free_page((unsigned long)ctx->sbounce);
-	free_page((unsigned long)ctx->dbounce);
+	free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
+	free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
 }
 EXPORT_SYMBOL_GPL(nx842_crypto_exit);
 
-- 
2.53.0



