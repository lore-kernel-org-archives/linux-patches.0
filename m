Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9523ED5C8;
	Wed, 20 May 2026 17:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298923; cv=none; b=NZ7pJsJ/kwfPRfkeBZm7Zd4gwZVjC067X4btenMQx0o2kMPkm7kKugEtbmxxT9nuo+uKxy6QurTBBxYTAMZsvu17EmWY3czvz5fCyGeJh3UMprdttbMiVK1RX3SQtj6ZlpwRuuojnuzmwlU0wgXv2UGxHo54hvRCiN+Wyhve7dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298923; c=relaxed/simple;
	bh=1yWWrMdYAiJGjfpreWYN4oBTeYmS9DKKI8Hcu2H2MA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjdNMNZ1/InLA5kXl+y5BBIcjZyNqgYxCC25UDRIUkAV9mIQfqvE0MDwNvTOGVFglBInLlyEIWB0CbXcX3k8+tXc8uUN9l1qeh09dPakr45XwbQOXGxKQJwLhjYzfIYa1bKqBM9czTDLpAopt48g3La98pLxkfvNdFCk5L597rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqbkmEvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqbkmEvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D309F1F000E9;
	Wed, 20 May 2026 17:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298922;
	bh=7WaS7wShne1p2mwik4YjKt0gu3zteNj6WbWcIkU/TZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqbkmEvHWUu7wJZ+XEczb3ZuL/CDXxKWaODG2foRmLxkapdS/JfTBZMoTo9TyMKvk
	 Zp4Yu6gsZVLgM2gawyrFSkSexeeGkhHbL0ApWAgWehvUdjSXUTfXnJeVOIhRZ18cv6
	 UYtSm4/M3eDuor8C5qFsndahNoJv68xfrR4eWJ8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 595/957] crypto: ccp - copy IV using skcipher ivsize
Date: Wed, 20 May 2026 18:17:58 +0200
Message-ID: <20260520162147.431587911@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Paul Moses <p@1g4.org>

[ Upstream commit a7a1f3cdd64d8a165d9b8c9e9ad7fb46ac19dfc4 ]

AF_ALG rfc3686-ctr-aes-ccp requests pass an 8-byte IV to the driver.

ccp_aes_complete() restores AES_BLOCK_SIZE bytes into the caller's IV
buffer while RFC3686 skciphers expose an 8-byte IV, so the restore
overruns the provided buffer.

Use crypto_skcipher_ivsize() to copy only the algorithm's IV length.

Fixes: 2b789435d7f3 ("crypto: ccp - CCP AES crypto API support")
Signed-off-by: Paul Moses <p@1g4.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-crypto-aes.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 685d42ec7adea..b5be3af8b2fe5 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -30,8 +30,11 @@ static int ccp_aes_complete(struct crypto_async_request *async_req, int ret)
 	if (ret)
 		return ret;
 
-	if (ctx->u.aes.mode != CCP_AES_MODE_ECB)
-		memcpy(req->iv, rctx->iv, AES_BLOCK_SIZE);
+	if (ctx->u.aes.mode != CCP_AES_MODE_ECB) {
+		size_t ivsize = crypto_skcipher_ivsize(crypto_skcipher_reqtfm(req));
+
+		memcpy(req->iv, rctx->iv, ivsize);
+	}
 
 	return 0;
 }
-- 
2.53.0



