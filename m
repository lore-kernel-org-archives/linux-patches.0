Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087A1269AE8;
	Tue,  8 Apr 2025 12:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116392; cv=none; b=Gtfp/CRAQJ75L0PqSC+PhXi5Ff3u0Fg/ZN92YV8Tje4HzkjosL7swMJtPZYHAhuriTIizZm/NETNLW5klXMNYOmVr6FstWqUJaCs+qeJZ7kvBzrHb0MD3NuXrhNmY9kxmLDgKOiUHa1H35sxlsbCujkRHdaTe9A2fSRe/9r1Ce0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116392; c=relaxed/simple;
	bh=sCW4+VMU3bYudgNLsHTt5bAw2dOwcC8qsx4hrHR+7E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrhZ4mWld7XjFnMIMK/370HA3+j0rS22mfvmWQTeTekz/WBQi+YORpveSgvDgOhb+nkagQQupn+nZvs1AXaFFPEa81lkEgJ/PO9RKvShB2t3lxmhMDrz4+wrVaBr9Kc92N9Gd9S7mhKN4u20X0MjBzHUtaK3hguCvBmV5UhSWU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3EEVc8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3EEVc8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4A4C4CEE5;
	Tue,  8 Apr 2025 12:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116391;
	bh=sCW4+VMU3bYudgNLsHTt5bAw2dOwcC8qsx4hrHR+7E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3EEVc8K38Eil83aB2/EOl/BdiUCI6G6taO1otYoeA1fdX8kTsyPjKQm1QZBkb39C
	 qp+uDiqVAh/28ri1wrMbuR+m9ujDwhY3x5XHx3+1CweNmG9M381TIB5ffQdvQRdWN4
	 zMbx48g3r68RH4KUt8lPJhDN1VqO9XInCZtIVKVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/423] crypto: tegra - Set IV to NULL explicitly for AES ECB
Date: Tue,  8 Apr 2025 12:47:28 +0200
Message-ID: <20250408104848.567854699@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index 3308962f11c59..0ed0515e1ed54 100644
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



