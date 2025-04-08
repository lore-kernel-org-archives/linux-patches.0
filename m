Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA84269B0D;
	Tue,  8 Apr 2025 12:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116332; cv=none; b=LX9MqjqlLz66tVWD0GUjAIrTwLHAcEhpsJB22ZpUl/4dfX+6OkNQJiQKeF7dKK/FmugQURgtzdcCrmIBLHtcM+BfR/Sele9NqsmAmKqmQhJ6iiLaVx5fmOzRt/jAsQ7iSRd72AevGEss8rRcQ9s4CWPjV3Axlpk3iy1FYQw3AKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116332; c=relaxed/simple;
	bh=Gv52cb3jyC2EWhco9FrAERdiOM6apHNCkosHvF6+5Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmX6/uiBux27kFDD5UmVepswy6P+pbpF9m5Oj+l44JCGhr2UvrGrhrcsKBCCqWlBDhLVrQp0fmFclFxl5CDDxjDL/DwC09okL2TMwq2z87p1r6gplKLoJuuTJeQEYjSNFFoTWyqwLRlwc3uwzA07DndbLMmwctHb8ouXORIpFek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWOHqpln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWOHqpln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3E9C4CEE5;
	Tue,  8 Apr 2025 12:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116332;
	bh=Gv52cb3jyC2EWhco9FrAERdiOM6apHNCkosHvF6+5Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWOHqplntXY+xRGrczVtFXI+wMnY9MAi1INM5RRvnskWe+47zvk63hY4dvWr8Ww60
	 i+vVdnP8RLQjBSt00KDFCJNChbJURtx8piQ2PDYCoaTbAQ0mbTa4l6XSAN2C1MvAUC
	 WylhOdbcjLZ3Bs8aBd80r+OKVK3mIDuc+N9pa8DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/423] crypto: tegra - Use HMAC fallback when keyslots are full
Date: Tue,  8 Apr 2025 12:47:08 +0200
Message-ID: <20250408104848.111853669@linuxfoundation.org>
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
index 5aead114bd967..726e30c0e63eb 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -567,13 +567,18 @@ static int tegra_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
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
 
 static int tegra_sha_update(struct ahash_request *req)
-- 
2.39.5



