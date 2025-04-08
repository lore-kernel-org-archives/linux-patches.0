Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6B22063FD;
	Tue,  8 Apr 2025 12:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115731; cv=none; b=seyvAumUhpSwbG/8CwBuNxQ5zrRWKIejoiIzr9QtpmWxHUGzDYwugYyuWzxKZosqs6GfGmYfdadJxqJiZhUFmHCa4woMOR4LdT91U6a9dtV60XyIzk9JtiqIC8jrgDldirh+x044N8P20LmTM6bj4VADi4jSOYOd9EoWghhtAik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115731; c=relaxed/simple;
	bh=7wvbVQFvsqUUIKym0niK9B0p7SbDhssgx3qNzxd7IIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kykCzZ/ecfEnvcPjEpMHubfkov1dsq9LZ8sihg+nDUj5bOjWtj1gnTxyy1G0PuP+Cyn9D0bBzQQ2NnLxspnAZj1ZFCiOy0GoN0IxkPhgjYxKIAZ29WCXIv6MVDtvuEouhQ0r6mjuVn1X+Hx13dRX24fxjUfkzpb4IDBWOXDL/sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lsv+oJLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lsv+oJLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D9CC4CEE5;
	Tue,  8 Apr 2025 12:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115730;
	bh=7wvbVQFvsqUUIKym0niK9B0p7SbDhssgx3qNzxd7IIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lsv+oJLbfr03ELi4loJefvkPwdfnLGoexu1gi118XcG814C7vrXNoYbRgrcgVrk1x
	 k+h52bVfCwEcnVwUx0LtuW5AKjkv8QzjKUaLnyVkabMCOKredaHVChL3Q7cJWXGRzM
	 cmqvs9hOwy4bJ+1OpcCja4BwTVPe1T7LN100y9Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/204] crypto: hisilicon/sec2 - fix for aead auth key length
Date: Tue,  8 Apr 2025 12:50:14 +0200
Message-ID: <20250408104822.822104994@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
index 3de8715aad39d..292ab0ff2b07c 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1094,11 +1094,6 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
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
@@ -1110,7 +1105,8 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
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



