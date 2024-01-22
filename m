Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F41420A4;
	Tue, 23 Jan 2024 00:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969143; cv=none; b=WB5Z6Xy8XYQVnvTnSBCFnzGZXD0yqlJRD5ceBVbAJTsDtFyCZAQzrsSTPFGBHLZ1dfrP9MXQxmhPKWeoQ2hj61DOa7Kk4Es7plF9mIgMb4A8YhRqaPHyp82Rskp0p9A8voZs6tULaVm5BrqPjGNemeRL0Z5QBCwoqlq8GnK76jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969143; c=relaxed/simple;
	bh=IfPRX2bPbdA+ZRnzZ+RI9EvW+Nq3+KnAnc04E0WH/sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvPnu5jxgETvd5o3ODry+vGf0ZIDi5r2kAuf1a4s6gXoryK8veQfh1987e6kHBN8Jad1vtIHzumgHm0a95oQokGLx1YsSbq/Hj+QqsQW9NmeVyZpY4PKEQTMQnvM2Bb5AZlNiBOZ5FvfPlzRnatFUuE3HRld5oDOSDpecUb/Vs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYym6Eru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYym6Eru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07641C433F1;
	Tue, 23 Jan 2024 00:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969143;
	bh=IfPRX2bPbdA+ZRnzZ+RI9EvW+Nq3+KnAnc04E0WH/sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYym6EruHa3418454fRuDQlBwVtdDU+Df5MRc7pngF3LpfYMiEBKzdnFtI8HbAkko
	 I07iSYfcVFJ3mXyV8RFNvckE9771Vy6ZdpDZBYjme9yTEJEZn92vmzyatQY5FVvRg2
	 G4xuxkBTh3IXwlU0EpkAJ41uDj+NnIWlAcyPbYA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 049/641] crypto: sa2ul - Return crypto_aead_setkey to transfer the error
Date: Mon, 22 Jan 2024 15:49:13 -0800
Message-ID: <20240122235819.609551067@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 6846a8429574..78a4930c6480 100644
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



