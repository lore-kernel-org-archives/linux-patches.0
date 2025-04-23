Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A2F27D76E;
	Wed, 23 Apr 2025 14:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419694; cv=none; b=Ppn1K884JbyUTQp2S2U/QnXL5EQ/JQSnqpanDWYePnaigH1eWz+MyXjQ80lyzxp5zLFv70GyKW5+qhAjx8CC3NExQ63z2oFfYrje1J9jGHw2lq04nTg4hAoIky+AMF3bGScyrOaFXp4sRsGH48FN9LgdSZr/NAcAuTanGJnE1vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419694; c=relaxed/simple;
	bh=SatHcYa2FZgkrCvRUHQU37nWIIQYlc+Nr9q0dQZuhRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rz21y21NEumTLe7FV1S8FdAGhs0PBFlsnC/kKEYlwt978Wl2ni3Cbxyov+B7/hjswISfouLG/+O0QmrOQozIXagYy8Eccin2GWJiwT0wylODH3P0OypSgpLIfpyPXhena5+cU0OTs93mkH1VRQrweX2O24jFONxPinaeZdjLI68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=in/AOwdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="in/AOwdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637ADC4CEE2;
	Wed, 23 Apr 2025 14:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419694;
	bh=SatHcYa2FZgkrCvRUHQU37nWIIQYlc+Nr9q0dQZuhRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=in/AOwdrGD3XlzLq4lkxPeQBS5xaHUkH6R3J5KOY003fJdxPzDrmslV+AEURV4jI8
	 matlMQuXGp3oB+GZ1UUWJ6w1rqttDR0Gz9R0nnZz2rHPFUzPI7WQVEFWWn6sBZFAiN
	 cZzX+dEVZJXMfRXUKks/gWDeAXzyviSZtfIkx+RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/223] crypto: tegra - Fix IV usage for AES ECB
Date: Wed, 23 Apr 2025 16:41:29 +0200
Message-ID: <20250423142617.820974343@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 46c4dac92dd7a..cd52807e76afd 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -263,7 +263,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	unsigned int cmdlen;
 	int ret;
 
-	rctx->iv = (u32 *)req->iv;
+	rctx->iv = (ctx->alg == SE_ALG_ECB) ? NULL : (u32 *)req->iv;
 	rctx->len = req->cryptlen;
 
 	/* Pad input to AES Block size */
@@ -443,9 +443,6 @@ static int tegra_aes_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->alg == SE_ALG_ECB)
-		req->iv = NULL;
-
 	rctx->encrypt = encrypt;
 	rctx->config = tegra234_aes_cfg(ctx->alg, encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(ctx->alg, encrypt);
-- 
2.39.5



