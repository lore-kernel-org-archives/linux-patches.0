Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCF5269AE4;
	Tue,  8 Apr 2025 12:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114555; cv=none; b=t61luWYLkKx/H+RhAMaFxinxC/kR70CjOfHajpcX+KPHtvqsM0WtdEpENCQT+xKUlrxrnjVLlzRoC2fHvhoDxKiW6D8LEqArGdROTO7EgVsz2SfOOM09tO/bNqbR3dCcFs2E5AJ8mVIc+Hu9hvRNjleEWMvkPaxELiFkKg2nbQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114555; c=relaxed/simple;
	bh=y8k6Zf5UNw9wSJlG2462UKk6NDSsn27GMisr/IJ+bjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJeZDEGYM0ekoakPDjg6WPHL9xSPC5RQWiFwQ4FD64T5ikl29LCJP3kMc9329dYYp5QNVyJZMemi3hbMZ08Lc+R+X645PEyanv4hj9/x42RmSEX7FY6/CL50KKLpU1rCGTPbGEPMO8eL0v8VMnvcaa3rMBu57FSf4upY/R6lQUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vttTAULk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vttTAULk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C48AC4CEE5;
	Tue,  8 Apr 2025 12:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114554;
	bh=y8k6Zf5UNw9wSJlG2462UKk6NDSsn27GMisr/IJ+bjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vttTAULk0L8YgnbHF+qieEF1mms1ok/fTWUWvJAanbJuy6b5F7D/OSXLU03DwOkd1
	 UX64TnBqmhX0mTEyp4qRQn0sC9LMwzjnoQZ19YGAO1+cJo6qGIGIRY9zmRlM72Yx/2
	 9OnPKwQLR5DutWbxY3HjY5J3cU1OKv9ui/8n0KnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 150/499] crypto: tegra - Set IV to NULL explicitly for AES ECB
Date: Tue,  8 Apr 2025 12:46:02 +0200
Message-ID: <20250408104854.926546323@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



