Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3C3266583;
	Tue,  8 Apr 2025 11:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111344; cv=none; b=gMNchQqvcLtftJhxiNeSwQlTliFG4q+aVXe36uxc/aCpyoOvMMKokzOorCPVRKhe5QKaORvDbqFrgYBzi7SjU/V1uU18vRlHgjJnHi7urBVgPhIzCVoJHZZhbCcmU7Yp84qZ4a1yKOhW8R1bszXFo2MEsDQ9L4rjHfohgEkX3Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111344; c=relaxed/simple;
	bh=5z3Ib4Q47HsiaKv33QrGHCpWI99KKWkH94PtBt9D9DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQxMMrbavUCEHP9jrHg/9BgmNuTfGnRAbUAmKt2OpieM9tVoYftbUkMbpBdfsc9ZKWv1geMN1f/fM7CXd0OabE01MvQKYx9dxvzsFy0GTkE/YfdR1Tctf12HWadvMg3jfJ9yZj/jY8yZzRC1t7ivfhNO84xVaO8ozWQKYzV4vFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYrdqCLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYrdqCLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1C4C4CEE7;
	Tue,  8 Apr 2025 11:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111344;
	bh=5z3Ib4Q47HsiaKv33QrGHCpWI99KKWkH94PtBt9D9DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYrdqCLkDzsJirjgi9tJSlGSvVGCWusZI2Yaptdsv5yW3hlo18THNGf80LkHZ2m3t
	 z6p7khNZGzhAtpU6MWvHRMk1EXP0z2+Dh9zlrhefQpDhAiuOi0QdYG7c1ZGSap4rll
	 qZa8FrT/M7CVKo+1E8bnOtmrxRa8rzbDJfLU/33s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 381/731] crypto: tegra - Set IV to NULL explicitly for AES ECB
Date: Tue,  8 Apr 2025 12:44:38 +0200
Message-ID: <20250408104923.138363459@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

[ Upstream commit bde558220866e74f19450e16d9a2472b488dfedf ]

It may happen that the variable req->iv may have stale values or
zero sized buffer by default and may end up getting used during
encryption/decryption. This inturn may corrupt the results or break the
operation. Set the req->iv variable to NULL explicitly for algorithms
like AES-ECB where IV is not used.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index cdcf05e235cad..be0a0b51f5a59 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -443,6 +443,9 @@ static int tegra_aes_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
+	if (ctx->alg == SE_ALG_ECB)
+		req->iv = NULL;
+
 	rctx->encrypt = encrypt;
 	rctx->config = tegra234_aes_cfg(ctx->alg, encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(ctx->alg, encrypt);
-- 
2.39.5



