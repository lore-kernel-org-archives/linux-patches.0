Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F543F23C5;
	Wed, 20 May 2026 18:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301110; cv=none; b=MQsjf1/BWIQ82pw9Yn9uZopMtD4CUxOHhwsBlIK7KqbmDPH5w0g1vJeOKNM4slcBVPL36wxf7JlF2JN/LEqPqepvr82cLf9Ik/mgaiDye5d9qj2Zh0bRAMFpqYEbiYpTzgUtzc2rz1RDxFYbOFtrn10GtkjPYvSVMVyFHNcSUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301110; c=relaxed/simple;
	bh=P6A++E6kgAlDAE7CjHiW1/blm0PFS6c+5vJm9qI+TZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWjSINuOkNVNFTNe176ufAWyVQcRD6SJ/l8fWPFY4N39xq5zw/bsZAQgC7UF292QpQtz6SsbrcrV0pDMypvLBIWRAzUqd+CZXIfBbrBjCsQScYNhYW0mNTCVHsqFbXsyoFp+OmoseuiOP1S0z7wHlfphmiuS3HBcxESX4S72yJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+U3xheS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+U3xheS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137B21F000E9;
	Wed, 20 May 2026 18:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301109;
	bh=czGnA3hjFZpNFe0fhYFLmDYfgVt72mlyWU4JnE5HLWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+U3xheSZxgzzRXWe5zlsnHxxfpZG2E5/YLBbMTG6mY/AhMv2WuXT70BWYR5SmJvH
	 9WrDhw8HmC+JAQ6FRp5F88PpUjhUOweZFHaG4qvfP3CQ3NGHXslihu62QMTRr4IvWg
	 8FWXWVjc4HtmS5LiaprSeapr/1+oAce9//YABwb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/666] crypto: ccp - copy IV using skcipher ivsize
Date: Wed, 20 May 2026 18:20:39 +0200
Message-ID: <20260520162120.548282779@linuxfoundation.org>
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
index d11daaf47f068..871886826cf00 100644
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



