Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A2FC0B;
	Wed,  5 Feb 2025 14:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764385; cv=none; b=UnZ6Xm9RVRrkYoGp9YUTv9Ga0qefFmw7YzloHt/YEpg3gqr+7WL7Wv/ifRhHTEYSVi3iLFdBKSuPmJAiM9nmLHPv0eLqQ+uZIareZraa2ado4gGbe2klGgTHV8fXaYUsaFrIUvRO8gFP21ipPWWf1iN3pKvkx0GIo16g11Js3a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764385; c=relaxed/simple;
	bh=Qx2RvgbNITCMaiGr6NQY4j4L3lkalAVeXak+jfys0wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqHlAqyXZsIuQQDZx5EAObQsesLL23PIEc6ZKYyVks2DNWinA/qAhGmle3QzyNf0G+cVvn1qJspHPNth5TfesIsmyUgZBu2oskRyTVeYxeDx7aFpatZ1jMCna8AN/uVIzl3UGshuyTmsmEuIDA9f2XJh0MIVa02b+XQMYeEE4sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3JW7i7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3JW7i7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DBDC4CED1;
	Wed,  5 Feb 2025 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764385;
	bh=Qx2RvgbNITCMaiGr6NQY4j4L3lkalAVeXak+jfys0wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3JW7i7/+jjnGe28wRDwEWrOEiph34xbbEclNR/hniVVRXriFDk9jJGPsi3KeH7N1
	 Y4RbXBdKUcJobarme1ltp1ExO3zk+gV2RgfL76SLW1HrBpLatYTLS5LgIOZm5LD1f7
	 o7ta6umPe9/QGG3F3lw6CjHcGPXzTZ5D1jxaLPOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/393] crypto: hisilicon/sec2 - optimize the error return process
Date: Wed,  5 Feb 2025 14:41:26 +0100
Message-ID: <20250205134426.685691302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 932cc277eb3a5..7b5012cf1ffac 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -849,6 +849,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		ret = sec_skcipher_aes_sm4_setkey(c_ctx, keylen, c_mode);
 		break;
 	default:
+		dev_err(dev, "sec c_alg err!\n");
 		return -EINVAL;
 	}
 
@@ -1174,7 +1175,8 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		return 0;
 	}
 
-	if (crypto_authenc_extractkeys(&keys, key, keylen))
+	ret = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (ret)
 		goto bad_key;
 
 	ret = sec_aead_aes_set_key(c_ctx, &keys);
@@ -1191,6 +1193,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	if ((ctx->a_ctx.mac_len & SEC_SQE_LEN_RATE_MASK)  ||
 	    (ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK)) {
+		ret = -EINVAL;
 		dev_err(dev, "MAC or AUTH key length error!\n");
 		goto bad_key;
 	}
@@ -1199,7 +1202,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 bad_key:
 	memzero_explicit(&keys, sizeof(struct crypto_authenc_keys));
-	return -EINVAL;
+	return ret;
 }
 
 
-- 
2.39.5



