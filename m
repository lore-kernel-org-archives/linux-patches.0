Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337BA226D17;
	Mon, 10 Mar 2025 17:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628838; cv=none; b=JAajteOOXwWzoMtI8L/lcqFbw0EjcoRaXTU0I5CmDeIwi1e9Nil/eWBL32SEy8i8Zfte7NRBtvOKRRS97bIJcIkngI+EfrD/PvO8fvRc+3Splye0bUz7cTqP4gIfFWpSd7UeI8a9gpRpDIkIVJtukP5EWP6hW9HQ/Ov9jP9aBjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628838; c=relaxed/simple;
	bh=OPjvElLfpn2ZFS1mnrJZGsH/55a6g4weq7a0vCj8LOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7HP5XbZ6MiKMvlTA+ChIWkFxSZvaer3FqxCbo87KpVr7cGaQHlkjyC0jnDrfJELTW4UKSjOHARgKCVW01+V4GDE/IpeYBFbauXBImoi01mqG+5Jot0/B3i9wBlNOw0mxLVQMqcwnhKq4aFoHj9zFWP4uRVJxJNw4yPJ4fqWO9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOtIdsZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOtIdsZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B5FC4CEED;
	Mon, 10 Mar 2025 17:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628838;
	bh=OPjvElLfpn2ZFS1mnrJZGsH/55a6g4weq7a0vCj8LOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOtIdsZ/fKBaD+qZmmUlVouyV5g0IQKvgwUtOsw9PRQFwRXZsGvknQ3HnketJTC3S
	 x1WiaLJ2DEdwn1NsLrGA0339r3tdhKli/6Fsfp0JQyojR2ViqlH9jOu5PMLWwYDYJu
	 usth6BiLLp22heegJlYccFfFLlferClgAc/W7QXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/620] crypto: hisilicon/sec2 - optimize the error return process
Date: Mon, 10 Mar 2025 17:58:53 +0100
Message-ID: <20250310170549.016594960@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit 1bed82257b1881b689ee41f14ecb4c20a273cac0 ]

Add the printf of an error message and optimized the handling
process of ret.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: fd337f852b26 ("crypto: hisilicon/sec2 - fix for aead icv error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 72e26a4bfb8e6..dedcc7f743039 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -803,6 +803,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		ret = sec_skcipher_aes_sm4_setkey(c_ctx, keylen, c_mode);
 		break;
 	default:
+		dev_err(dev, "sec c_alg err!\n");
 		return -EINVAL;
 	}
 
@@ -1128,7 +1129,8 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		return 0;
 	}
 
-	if (crypto_authenc_extractkeys(&keys, key, keylen))
+	ret = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (ret)
 		goto bad_key;
 
 	ret = sec_aead_aes_set_key(c_ctx, &keys);
@@ -1145,6 +1147,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	if ((ctx->a_ctx.mac_len & SEC_SQE_LEN_RATE_MASK)  ||
 	    (ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK)) {
+		ret = -EINVAL;
 		dev_err(dev, "MAC or AUTH key length error!\n");
 		goto bad_key;
 	}
@@ -1153,7 +1156,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 bad_key:
 	memzero_explicit(&keys, sizeof(struct crypto_authenc_keys));
-	return -EINVAL;
+	return ret;
 }
 
 
-- 
2.39.5



