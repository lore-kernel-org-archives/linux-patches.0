Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896112D7BF;
	Tue,  3 Dec 2024 15:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240226; cv=none; b=KgZZKor+Oh/zWjyDF7mnl85yM/bOKRG1obl6OzuIJZgW0gWPbkJlIjiv5qajTsoTgEVG0FXmMFjN6ieJhRfnXCqvzKWvpJWKyaYhb+8YkOqpJjCB+NJFr/h7N+S+0Na/J7pzHw3I6nY40+A5uEage/upN9xOybCgDIWj2innrkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240226; c=relaxed/simple;
	bh=DgEyatBajOE88tN493tsPU+1WAyoy3WDyOhkoZP7NC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qg26jaCoIBfnhR6EvuMf3ovG49d78sbA8KTzkMz0LKqIfvIZywQfk9QGyKEczMYxEBYME5uhzfuv9jp5HqX85ciiiFa/yGdR3fqjRGPQXNZwJkMg26c9lNP9UF5cnpmrE+RDDef9Crk9wRMO92aEeQ4fJCxOmVRI6UqVICbwOlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2qLu37R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2qLu37R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104D6C4CED6;
	Tue,  3 Dec 2024 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240226;
	bh=DgEyatBajOE88tN493tsPU+1WAyoy3WDyOhkoZP7NC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2qLu37REDeEuo9rLI+vTlGZ+Js6Z/dMlX+8BG88YH6Nnem3zFgUxL/4E7orTEVso
	 k3wBgtzNgckVeaXtZefoy4Xk7Bm1zWzv1ftBUdMlmZKRuf88C87KRR3oR/6dgeRLWK
	 +CcXzxiSrCMsYe5mexq3ELtbYkR+A9RdHLyy3tsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/826] crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()
Date: Tue,  3 Dec 2024 15:36:32 +0100
Message-ID: <20241203144746.009049516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit a10549fcce2913be7dc581562ffd8ea35653853e ]

The commit 320406cb60b6 ("crypto: inside-secure - Replace generic aes
with libaes") replaced crypto_alloc_cipher() with kmalloc(), but did not
modify the handling of the return value. When kmalloc() returns NULL,
PTR_ERR_OR_ZERO(NULL) returns 0, but in fact, the memory allocation has
failed, and -ENOMEM should be returned.

Fixes: 320406cb60b6 ("crypto: inside-secure - Replace generic aes with libaes")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index e17577b785c33..f44c08f5f5ec4 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2093,7 +2093,7 @@ static int safexcel_xcbcmac_cra_init(struct crypto_tfm *tfm)
 
 	safexcel_ahash_cra_init(tfm);
 	ctx->aes = kmalloc(sizeof(*ctx->aes), GFP_KERNEL);
-	return PTR_ERR_OR_ZERO(ctx->aes);
+	return ctx->aes == NULL ? -ENOMEM : 0;
 }
 
 static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
-- 
2.43.0



