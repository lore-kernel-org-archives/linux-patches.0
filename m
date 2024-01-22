Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992605B5D2;
	Tue, 23 Jan 2024 01:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974320; cv=none; b=iOD37XP6tn0Sm9yy6+i9UoktjYqmJfoQ0o33fsMiR0eeBKLG7MuZheb/HCN2F5/Y0bWV0uZODinJlQO2R2peeuT6WsXluElPwBQyqV9WoDT0dUZy5I/BCZVJQ9dGF+vIPPaRhkBHRKiIJWNkDN5DZu7Al55IAA7rCi2U6OSnPmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974320; c=relaxed/simple;
	bh=SBmchOqXTqBfsYDPI8OmhvfXjmcEJPEvfueDeQ7IjiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clghkl1eOXTJ058WzDbNUyWxmzcIQWG7+L2hIrpG29seoqZIW9n4DyFZGzAmUX1WHwsBqApz3pD5FPXbsroGMD5Eo8VK5JYKduOXIhGqPRPnt9Dkr6D3aGieGJTAI7pmatBskoKuXFqCT4zQQ4EIm48lDouDVgJQdEXdN9oFhHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBveZdgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBveZdgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FCFC433C7;
	Tue, 23 Jan 2024 01:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974320;
	bh=SBmchOqXTqBfsYDPI8OmhvfXjmcEJPEvfueDeQ7IjiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBveZdgZaGc6z6PTKZLpbQqUFEKt9uHIMOPFJ0Lt3ujWfswj4Flm7IRwNghgma8Ad
	 WLZYN44bZk8c4yndQRczIYGHmznkCihkMWuGYQrz+GlVE5S776FQpkBov+y4WQOGwA
	 zQhVIR4FshduBCed2jSfXTvJBJCbI0yOaUuKIAQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/583] crypto: sa2ul - Return crypto_aead_setkey to transfer the error
Date: Mon, 22 Jan 2024 15:51:36 -0800
Message-ID: <20240122235813.517695760@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit ce852f1308ac738e61c5b2502517deea593a1554 ]

Return crypto_aead_setkey() in order to transfer the error if
it fails.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 6238d34f8db2..94eb6f6afa25 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1869,9 +1869,8 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	crypto_aead_set_flags(ctx->fallback.aead,
 			      crypto_aead_get_flags(authenc) &
 			      CRYPTO_TFM_REQ_MASK);
-	crypto_aead_setkey(ctx->fallback.aead, key, keylen);
 
-	return 0;
+	return crypto_aead_setkey(ctx->fallback.aead, key, keylen);
 }
 
 static int sa_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
-- 
2.43.0



