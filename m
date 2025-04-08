Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2622686B9;
	Tue,  8 Apr 2025 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112772; cv=none; b=LIJdEFEZZFgAmWlo9/nnkODD3Jzrme8Uql5g1R2opSF2AMbNrQy6EIBgQQv/rZLK7pmG2OaQd/ED45KJi3dzKN+RKP4DF5UjX5AucVrIbRoAwfumveBoVeQl5hr1b3X2yvfu+u9mUSDmn57bTiL15MvOxGh5lpuiLjI95eED81Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112772; c=relaxed/simple;
	bh=gS2hwGKL+/w6zz7VA1eDh05Vt/npvV5PACDGwjSw6oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APvg2zWNJRk3vscNjm9gQVdHm2bRG+6FLcTa63V/G6Qu8tjQw6w2vUUGz/ej2E/DV3xNffnTk+bc0wyFloudcW6ujbJ/WIiSII/NQ6CmZBuzeodQAGSJldU/AdU8913ivIrI2b3C9Nd1sDC5RuvgWjgwCWNsObBdrlCVz7Xz9nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=in8Rb2g8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="in8Rb2g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22EDC4CEE5;
	Tue,  8 Apr 2025 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112772;
	bh=gS2hwGKL+/w6zz7VA1eDh05Vt/npvV5PACDGwjSw6oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=in8Rb2g8NIexN1s+VFlB6TVJbkBeNZTxCmYQLqf0ehVn4e5Bomxd32kLC/UnY+FH+
	 8YMZDmiml1Z+j4LQCDrSQGSlBqI244MnVEsTHneeM7QKUmD+MRC5+hQXNOb/yVUMNa
	 wcNoNNCzCctVlCtW81kj8FXQ07azWRQET5MkYIKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/279] crypto: hisilicon/sec2 - fix for aead auth key length
Date: Tue,  8 Apr 2025 12:49:35 +0200
Message-ID: <20250408104831.522081438@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6de3ccd0fa9b7..915333deae6f0 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1047,11 +1047,6 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
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
@@ -1063,7 +1058,8 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
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



