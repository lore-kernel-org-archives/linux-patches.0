Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF34B269B12;
	Tue,  8 Apr 2025 11:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113281; cv=none; b=aUunw6fAonHuwevTI3URMGP/LMO27bINwsIYH32uUINOlYsCmuQPJgJUAOk7adpJ4tqdJTpb040ZscsD6RIpBGsjFRRI5cXmMgyXbeZECFLMI+J4FWmteyI+HRJiBYRKxIk3YDF4SfBB6uCaH8/ZGl/JuRSojMkdte7E2MpJF1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113281; c=relaxed/simple;
	bh=fDdZ8j2ogzMGhBoHLMXAzpNOgL3xAQuvLc/bLHhXcRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKM3Y34uW4mPAZHWtN8c8c9KGPBo/Q1Oybhb8kPtGZ4m2MLQPlmuqFgCJN2aVnlmdh0zlwBH8BsMowoQnbLsPaGmwV31Qp1HIQPxjDavq+R77WV+bsKDLCjpIIGetk0H06xA2IA8M8/s3RdUZ37myQ2spOWd64tfChEh7LBH4W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFE4TNf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFE4TNf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38268C4CEE5;
	Tue,  8 Apr 2025 11:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113281;
	bh=fDdZ8j2ogzMGhBoHLMXAzpNOgL3xAQuvLc/bLHhXcRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFE4TNf4PFkMR5pNBQeTwGVzNkb5qRPPZOqdznpE1KM7sMr5JnrMbTXq9zSR4o9iy
	 CCCCA71MnRbVRFmjK2VMfWqEYbJLV5yXz1ljTXSgIkNCQ3Uf85KFOm5ywFWzpT9V0C
	 mB8of4DnqLlnOewa33GCWofMmZfHy+xLrEcklxwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/268] crypto: hisilicon/sec2 - fix for aead auth key length
Date: Tue,  8 Apr 2025 12:48:31 +0200
Message-ID: <20250408104831.193967926@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index 789e566b3bf90..d6727b8ff582b 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1089,11 +1089,6 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
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
@@ -1105,7 +1100,8 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
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



