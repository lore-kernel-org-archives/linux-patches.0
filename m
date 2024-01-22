Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0992627F7;
	Tue, 23 Jan 2024 00:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971079; cv=none; b=AYFpBxf4VBOaBbyIMl4DWEudr3g5ny7pepyXkWGJ2Ojz10isxaCRTpvVBTJRjcWwraeox3snPsw6+0bzIfdJwmnWKYkUjxImzTuKH+6xyJ/c3jR7YCuhDwCsgf+QuAQE09leX7OG6ZBs06mAkf86J//EzPj2jIqgjz5nYbShstc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971079; c=relaxed/simple;
	bh=+wUjYnoHsj2axSQlyPwjIlcZvjTC32HIGULzW+BfNs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnrmEInhXR2o+AQi2q6oze6jzKpmsEHTZvY9REAjCwQNxqf5Eq2IXRn5CjZ+L+/ZEjUtMvLWeJ0H7z0dewNX1JOP1XjHDcOOnZLfNzXbjMXPu152NZZrAbExT5crkm9gYuhenJAlXCSRRT8aDpSmcreBHDC8w9kSUHvvJoigAT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lbc1l8Ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lbc1l8Ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07903C433F1;
	Tue, 23 Jan 2024 00:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971079;
	bh=+wUjYnoHsj2axSQlyPwjIlcZvjTC32HIGULzW+BfNs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lbc1l8Tyd297C6hoyhE6HwH387G0Gfwmf2lsU8BlkfR1oB6/8TnKAiO+8XOPRblEc
	 tgBByp4p9TkW+kx8x7KQ35MbL6+DHPHR4KBG5P0WLkBtK6r8ieZariVecFvNCkWB7X
	 ryKs+OFMDg7e523B1B3vnBMInNK1wGtkok3c+qYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/286] crypto: sa2ul - Return crypto_aead_setkey to transfer the error
Date: Mon, 22 Jan 2024 15:56:30 -0800
Message-ID: <20240122235735.272745490@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f15fc1fb3707..0888f4489a76 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1848,9 +1848,8 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
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



