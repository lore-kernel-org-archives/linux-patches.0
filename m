Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4E0155389;
	Tue,  9 Jul 2024 11:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523587; cv=none; b=P1eE4iRz/sHSf7hOOFZMtze+LOHwDdXv9e4mVpILMnvSNiJihHlcWzTNU7K6JB6pBsfbaITfPCu0XSAbwpuqJJDw2I0hYjlknkGYG1LRVmEnJS3ch65CIPQGsH6DaI/gMTIvCbTqIIi6Y3EksZ4G698IYYDutz5hunXzIdHxoyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523587; c=relaxed/simple;
	bh=20bRCnxHG2XHA99mrA3m3WN4AEU2pmUKCqnZjawqzT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUHbnQQ0noSRZTs0lsWhgxO3lrBS479IeHGLTdNpBlURpOqwZzmfjOSZUFCI5ULOfq8jAqWzhexRpyyjuBhbqZbiimHPVrrmv6kH25lzsPPrzD+mDLJGjwOpI3E4zLhGrwwFppkAl7rABHLLWRqPM8G3sGZSTZI21dory77tb0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsjbSfj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsjbSfj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25778C3277B;
	Tue,  9 Jul 2024 11:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523587;
	bh=20bRCnxHG2XHA99mrA3m3WN4AEU2pmUKCqnZjawqzT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsjbSfj4lh4FgLfrBA92RtELfUnbMe8qX47e8iiRtXJB3BOnIS3DZMXDGg0bi+lgQ
	 1JnsWJ1DFQPqdCM8MbVZFdbf356aGFIgkI0MNSTJROqD7/9mWn5Kcovxdq84qJujhA
	 J+qN2OOc3/LlkWnkKiur6mMbFdqy6nOFyfr+Xtjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hailey Mothershead <hailmo@amazon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/139] crypto: aead,cipher - zeroize key buffer after use
Date: Tue,  9 Jul 2024 13:08:35 +0200
Message-ID: <20240709110658.749551333@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hailey Mothershead <hailmo@amazon.com>

[ Upstream commit 23e4099bdc3c8381992f9eb975c79196d6755210 ]

I.G 9.7.B for FIPS 140-3 specifies that variables temporarily holding
cryptographic information should be zeroized once they are no longer
needed. Accomplish this by using kfree_sensitive for buffers that
previously held the private key.

Signed-off-by: Hailey Mothershead <hailmo@amazon.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/aead.c   | 3 +--
 crypto/cipher.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index d5ba204ebdbfa..ecab683016b7d 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -45,8 +45,7 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = crypto_aead_alg(tfm)->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 }
 
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 47c77a3e59783..40cae908788ec 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -34,8 +34,7 @@ static int setkey_unaligned(struct crypto_cipher *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = cia->cia_setkey(crypto_cipher_tfm(tfm), alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 
 }
-- 
2.43.0



