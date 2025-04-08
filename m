Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F7B267B7F;
	Tue,  8 Apr 2025 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111238; cv=none; b=nQcJ7BlGvQCeP2LkE9uMqJuYv3U57C3+vU++fOy3un6gAnCVPwJHKrUfpuDIjww4KG9+lMeePYY+3tUsqhYkphCIGH5p+/2CymbzJJsCopcLDMFwuKFUwVGNuIe1LF9+gS/Ql+dgakmkJo/lnVD6FL1nNGBbuxaGPLqZdXm/F/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111238; c=relaxed/simple;
	bh=AdDONNAPUeDd7ueiBc6DSdomyniH6b7Q0949TLCOpaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipZsPRCrr2Y9mHOtS9M858QGxvbOJdqR6MI5ILtWK39DthBSh55T0Kd38vySrwWjlMWTvk/X9Xv6ej/DyUYPqVvPpTT4WnsRfqPkL28CGwj1tvTAOd30Am1d4P1XMuhlziAMsiMpiW+ncnM1OKOJPYlsMyexoCekA6ttLOCSlM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wi1nDtoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wi1nDtoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5A7C4CEE5;
	Tue,  8 Apr 2025 11:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111237;
	bh=AdDONNAPUeDd7ueiBc6DSdomyniH6b7Q0949TLCOpaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wi1nDtoRmQtLKXTIR1hHCV8I7r9jxlELCXbCaqFXpFK+yhkw4zPmW4dBBCxhjdgkP
	 Ni7Bqeh+sWmCbxfu/kPn80bm+kWu7atZzSV3VdXN1B1IYTlfPpC9jYz8yuiiamkqGx
	 HMfOHRhrtQx4rqny+mG6Zzof0B4qrEqaAOIM8+m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 359/731] crypto: tegra - Use HMAC fallback when keyslots are full
Date: Tue,  8 Apr 2025 12:44:16 +0200
Message-ID: <20250408104922.623504992@linuxfoundation.org>
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

[ Upstream commit f80a2e2e77bedd0aa645a60f89b4f581c70accda ]

The intermediate results for HMAC is stored in the allocated keyslot by
the hardware. Dynamic allocation of keyslot during an operation is hence
not possible. As the number of keyslots are limited in the hardware,
fallback to the HMAC software implementation if keyslots are not available

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-hash.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 8bed13552ab9e..65a50f29bd7e6 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -632,13 +632,18 @@ static int tegra_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 			     unsigned int keylen)
 {
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
+	int ret;
 
 	if (aes_check_keylen(keylen))
 		return tegra_hmac_fallback_setkey(ctx, key, keylen);
 
+	ret = tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
+	if (ret)
+		return tegra_hmac_fallback_setkey(ctx, key, keylen);
+
 	ctx->fallback = false;
 
-	return tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
+	return 0;
 }
 
 static int tegra_sha_init(struct ahash_request *req)
-- 
2.39.5



