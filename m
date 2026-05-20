Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD82B3EA953;
	Wed, 20 May 2026 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296290; cv=none; b=ohNWDFfkkYV1H6Sx9i19Y61uAOBRGUThZjW0GhMBpvshD5Wi5mf8Q6Dpictuki+YktSzGSLT13z5xQbnfVG7sD+0k/OjxEprF6UvorhSsouVjqtMgPvSKJaPLWGWzYBWi5k698Ps17SNjLYgSmT4gykeZ/W84AQQR9Brwem+Ov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296290; c=relaxed/simple;
	bh=jW4DFsA/O/XWL5Qxu4VnZ+m6xGMzeyGcaEpuJYswEYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV5PsCLl+Rgb1DEHjqDaHQIPLIgfGNHzfOLBZAz0Fi+TchU+cjdUbF53WMwaYAPm3kMaEjJhVjbjnnWc4bcQ6zJU75ICOvspLoPYYkDd77NZr9ZNlop51pdSpEr7iuPq0Hisjb6mlJKlnCE9vZd5DBuBZykwXC8Ecrh9BTeGlhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAR6sma8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAR6sma8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3066F1F000E9;
	Wed, 20 May 2026 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296289;
	bh=ry4NofiHywn/LA0Rdprg0edzkuPDkiHab1kGyTz71vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAR6sma86PJDeJLd3x4QDEGWoeVKqnnGGcbq5pQ+HgThSI9ffT+qAoevj4if1Fdcm
	 LzVqKY11VrZu5Pi0vQDEGla4IAn2/+w9/DjqsaFK2PhYQCa7YE271K8EWGgxZrJLm+
	 8BCvjOA8y9tM19Y96QFbYa0SsGPlXx+mF3yx7vcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0744/1146] crypto: ccp - copy IV using skcipher ivsize
Date: Wed, 20 May 2026 18:16:34 +0200
Message-ID: <20260520162205.044551510@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 01d298350b925..3ad6bb7666f62 100644
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



