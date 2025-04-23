Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4125280CF6;
	Wed, 23 Apr 2025 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419708; cv=none; b=EnOQUBUQd0xrn/bgO+Z0H5K5o8xjsEXWUyeLNNll32OoxICMUm08El+jKDiJ55Lb+2e5IvvUrxTDVFzjv+rGqqIYGMu0nrFJqmI3IsIexQwSSA2vLuNMnsljMnCGcobXz5q8+3dNyrnQdhnGzDw8DgJRWmqy1lOytHe5FmfD95k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419708; c=relaxed/simple;
	bh=6XySZfHaMNW5XUp1TTt8p9B6xV/NwIMWNBYi6rsh2nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXBTvFfjlCn2koyV/0fbF2rSUvMW/1Z6k4Ibo8vOdRxDVihKlbtDA76meuTonmvuz9zZ3L+7WIG2WHjQVycNcWkhZJyla06CR3ZDNVU62Lm/TZU2rALPakJzDfwkSajCZbkQtm0TP73Do2KmmoGj3UnFdq1n/2oZZ0ke2yL8hH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbJr7NGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbJr7NGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78293C4CEE2;
	Wed, 23 Apr 2025 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419707;
	bh=6XySZfHaMNW5XUp1TTt8p9B6xV/NwIMWNBYi6rsh2nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbJr7NGbmbAVYjd48LooHz4fVnculOHmvnyIbdua3SsGI87tR+lA57a3ZT35SBayI
	 KcI4XRW1R/z8mNnqKhKZZKZREr+XicgGwhGGprHHxlsczYdYiHp+DHNdMMLJ4HXCtk
	 dBDZJZJAKtQz6cO6DfqztwdR4tF5t/KD+52htQQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 013/241] crypto: tegra - Fix IV usage for AES ECB
Date: Wed, 23 Apr 2025 16:41:17 +0200
Message-ID: <20250423142621.062894755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit 1ddaff40c08abb926be5ba713c5efc412d0836c5 ]

Modifying the crypto_request turns out to be not the right way to handle
the stale value issue with the IV. Though the IV is not used for AES ECB,
it eventually get used in algorithms like LRW in the next step after
AES ECB encryption/decryption. Setting req->iv to NULL breaks the
implementation of such algorithms. Hence modify only the local reqctx
to check for IV.

Fixes: bde558220866 ("crypto: tegra - Set IV to NULL explicitly for AES ECB")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index ca9d0cca1f748..0e07d0523291a 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -269,7 +269,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	unsigned int cmdlen, key1_id, key2_id;
 	int ret;
 
-	rctx->iv = (u32 *)req->iv;
+	rctx->iv = (ctx->alg == SE_ALG_ECB) ? NULL : (u32 *)req->iv;
 	rctx->len = req->cryptlen;
 	key1_id = ctx->key1_id;
 	key2_id = ctx->key2_id;
@@ -498,9 +498,6 @@ static int tegra_aes_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->alg == SE_ALG_ECB)
-		req->iv = NULL;
-
 	rctx->encrypt = encrypt;
 
 	return crypto_transfer_skcipher_request_to_engine(ctx->se->engine, req);
-- 
2.39.5



