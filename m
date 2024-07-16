Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5A17CA0E;
	Tue, 16 Jul 2024 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146014; cv=none; b=EUol8jGGmRbgSmRns7D6D8Q6PaNuf1gb+h7zwgy+agk4p9wInFeAv+1UUp+EA8KM9mdINAs7JvWTYoVa6pS/tMBzBrRGliDKmOE8wxnj0fxGbwwf2LRNcWhLJ+VC0FGtCiUHhpOfsNsF0dRz5PMFfhIYdAMN0ndaF76BC/TlV7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146014; c=relaxed/simple;
	bh=NF+K7y9TQmTybo88mTcYwUP93qgRMBONSAofAddKRXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr+N1ZNwpB07XLT6jyd7DCDCq/ob2Zsn8vd4D5qa6kMOgS9pNCnypjhEWij5OiwUSmqBYBxOGrIJrDjacGXwNW7gFmXktAFPqX5S02UOxOxuPiOMPt70fV3g6MWtsDJUecrhS71yKLNekYf5pVAZlVmrGqkIfzuEX8igJhDo/bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEptu1P+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEptu1P+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432FDC116B1;
	Tue, 16 Jul 2024 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146013;
	bh=NF+K7y9TQmTybo88mTcYwUP93qgRMBONSAofAddKRXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEptu1P+XJZAlnExdKH7Lqm8YmPKM6g0QEqvlqZZAKbpVBwODNoXJefGdCBn0YWMX
	 HgGDUl68CIZ0GKqlLjI0+o34A7acCAd6lgxdR7hd6RHPDI7AHxkB7dAKAxpWOu3q2R
	 uR5tFCUswDUVsP8r7584wIXd/IaOa8/Ex6baaktc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hailey Mothershead <hailmo@amazon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/144] crypto: aead,cipher - zeroize key buffer after use
Date: Tue, 16 Jul 2024 17:31:16 +0200
Message-ID: <20240716152752.813199280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 16991095270d2..c4ece86c45bc4 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -35,8 +35,7 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = crypto_aead_alg(tfm)->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 }
 
diff --git a/crypto/cipher.c b/crypto/cipher.c
index b47141ed4a9f3..395f0c2fbb9ff 100644
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



