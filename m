Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989501D61B1;
	Wed, 19 Feb 2025 09:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956331; cv=none; b=Ezb6tzqcgKkDUl3uLim83FhLs4xQEDP9GzOn+SrF51ZE+UvoPMugGqCGQjOocu3t6PhxYh5YcsGJiLVX4Rb2ciNO5TW3KCebIxAYnmD7fVLnVja8PgkpIp6tmuo9ocX2WQ75rHzOYznDGzU1SBaXXmA3iwa+7x7sHuvbABiAnbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956331; c=relaxed/simple;
	bh=rnVHnkg0FvbREgJKUWERMJc4rDLfT8uWzuAEKDbqOSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkEZROnDVogmi+120sA0EjNxCfWD64AUqDPr4YbLQM5tHfNT7UOCFApqhjPNNO7S/huAWnPgHlfNQW58FQG1kjCxKPtutcnZUlQyDLN3hpAquw+W8zlkhnaxCoVHEXZKczG+OHpLV8RrrUVEIN+TYDXVw8688R27b9plUNVMRyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGAWp+k1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGAWp+k1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15839C4CED1;
	Wed, 19 Feb 2025 09:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956331;
	bh=rnVHnkg0FvbREgJKUWERMJc4rDLfT8uWzuAEKDbqOSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGAWp+k15E7Wyp/CAC28aklyyZwqcXI++vEub0JA6JFtTD3xvz3hmYQZ5dtextl9p
	 l9fF5o4hfz2xf/lIzJ5cL6rJLrovQw26IOCEMXXJ3DBiWvBXN8HBlV91FO6jP+HdSd
	 aGuMIkIjPxMDjKm6RPPRjbBetxyBMPIgAuzyrJgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/578] crypto: hisilicon/sec2 - optimize the error return process
Date: Wed, 19 Feb 2025 09:21:55 +0100
Message-ID: <20250219082657.349912787@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09a20307d01e3..3bfc183a7ec4c 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -850,6 +850,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		ret = sec_skcipher_aes_sm4_setkey(c_ctx, keylen, c_mode);
 		break;
 	default:
+		dev_err(dev, "sec c_alg err!\n");
 		return -EINVAL;
 	}
 
@@ -1175,7 +1176,8 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		return 0;
 	}
 
-	if (crypto_authenc_extractkeys(&keys, key, keylen))
+	ret = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (ret)
 		goto bad_key;
 
 	ret = sec_aead_aes_set_key(c_ctx, &keys);
@@ -1192,6 +1194,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	if ((ctx->a_ctx.mac_len & SEC_SQE_LEN_RATE_MASK)  ||
 	    (ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK)) {
+		ret = -EINVAL;
 		dev_err(dev, "MAC or AUTH key length error!\n");
 		goto bad_key;
 	}
@@ -1200,7 +1203,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 bad_key:
 	memzero_explicit(&keys, sizeof(struct crypto_authenc_keys));
-	return -EINVAL;
+	return ret;
 }
 
 
-- 
2.39.5



