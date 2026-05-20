Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34973FC5B1;
	Wed, 20 May 2026 18:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302573; cv=none; b=ufftOte7Go6U5x0usd8Cpwmlij6mu7L3FpNQfFQoLOs0d/AeJhjlKnHL8C70NGbaJKHxMGJ8Me/xoKxuw1Ocr/vVm0sGR6TAVepIgTsyBN32OZI2cUZzQH1APMbjla/ujsY3SGo95WN7KSiFt1OQfPxNqKyB69HTiwEyo+9eWFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302573; c=relaxed/simple;
	bh=AaMdk4L2eKOq0Y0QjnXDfxLtOp750A2XyFL2hkcIC/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCmC5A5mGq8v8iiod0rTbZgjzPyZibsiyCiHb3a8a2o2/wGkyC/jrGzS56FohckG4FS2+LCC/czrHXM/uNBexSGhbR0nYL9Xvx45q0BKT0qTxVV+qtd8TkJ6wTWp4tyv9QHKXsUiZsuepmiKOx3TGxFoW9A24unvmQrNH3LwTxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRdmWUDY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRdmWUDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3321F000E9;
	Wed, 20 May 2026 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302572;
	bh=zmOlqkI3GPrRwmlBxV6TOTw7VFgGtFBSN/JnTet/NX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRdmWUDYcvo4ugyZn3tkVQkwBvoumZnb/yDrs6bxTK1viR/HQ/X1WVUmHqxlQlGJd
	 05OJval3Kd8SfQTJILcceLhQIVI7jxZCUwH3DyUzBUO0QvPnxCy4ctaC3saAxopY/r
	 BAUBJzhJpAekZPsayfWYhrfAWTpLLod0tPqmzK2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/508] crypto: ccp - copy IV using skcipher ivsize
Date: Wed, 20 May 2026 18:22:04 +0200
Message-ID: <20260520162105.164038110@linuxfoundation.org>
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
index 918e223f21b65..5a48155ea796a 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -29,8 +29,11 @@ static int ccp_aes_complete(struct crypto_async_request *async_req, int ret)
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



