Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E667267B10;
	Tue,  8 Apr 2025 11:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111541; cv=none; b=gm6aoBNqnaRhhXlw9ufABb9uZ0CcK4nICJiQignTS7pthWqX7jNcEkuWZRu5/yn9c0AP4oEFtGlZhlrz/9w+SgO7EHW3y1zGbNmYhBnPqKQcW6lQhzRhBKhyvLk6pnfJN1HE81pkHGYneQGrbzu4ub8e106NKPd6Fd58iCiISKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111541; c=relaxed/simple;
	bh=kIAAdZvDHEPAmaaE4g8+QORGVJSnKIbJwV9F8kLLzD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1ZDU9iizh/tGlDaRyc8IYlCenQdDUMYJvwvH2XulVlJCq3OIjA2m6VODGgRDRI6IDVySMUnfOCw/mfCcJ/YuiJNm/9TjBZYmth6Iylg8gmkkfm2UjlK85MO/Vyz9TxllR2Ms/iGHyOhnPpQ6PAxzb3K8uXUcvXb+SJEOzhaivs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/xPv+m6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/xPv+m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F53C4CEEA;
	Tue,  8 Apr 2025 11:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111541;
	bh=kIAAdZvDHEPAmaaE4g8+QORGVJSnKIbJwV9F8kLLzD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/xPv+m6/CcTKqhFVIz8m+85TAVIwuuJEJ2X2eiAs28P/dCN4srBSSKgX4L/DDfcz
	 oL9FdNoPqnEALmJNZYYCSSfe29FXifrBA8QSp2eRJKAWwmP9iGUqnfpPo8T2iHhVnG
	 NBjSQMHqRX6r7zqi1INjunrDkO267Kgw0mR/yI0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 429/731] crypto: hisilicon/sec2 - fix for aead auth key length
Date: Tue,  8 Apr 2025 12:45:26 +0200
Message-ID: <20250408104924.253714986@linuxfoundation.org>
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

From: Wenkai Lin <linwenkai6@hisilicon.com>

[ Upstream commit 1b284ffc30b02808a0de698667cbcf5ce5f9144e ]

According to the HMAC RFC, the authentication key
can be 0 bytes, and the hardware can handle this
scenario. Therefore, remove the incorrect validation
for this case.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 82827d637492a..8ea5305bc320f 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1085,11 +1085,6 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
 	struct crypto_shash *hash_tfm = ctx->hash_tfm;
 	int blocksize, digestsize, ret;
 
-	if (!keys->authkeylen) {
-		pr_err("hisi_sec2: aead auth key error!\n");
-		return -EINVAL;
-	}
-
 	blocksize = crypto_shash_blocksize(hash_tfm);
 	digestsize = crypto_shash_digestsize(hash_tfm);
 	if (keys->authkeylen > blocksize) {
@@ -1101,7 +1096,8 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
 		}
 		ctx->a_key_len = digestsize;
 	} else {
-		memcpy(ctx->a_key, keys->authkey, keys->authkeylen);
+		if (keys->authkeylen)
+			memcpy(ctx->a_key, keys->authkey, keys->authkeylen);
 		ctx->a_key_len = keys->authkeylen;
 	}
 
-- 
2.39.5



