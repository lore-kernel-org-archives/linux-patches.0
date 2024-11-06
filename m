Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1AB1DFDB3;
	Wed,  6 Nov 2024 13:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898145; cv=none; b=Spyw1yCzlMpV2cfgrM3GLNWzyKvu0/Lo1/YjAA8khqW7o1AIrwBmL3tDh8h7EVKu3MJrPb+0w7Nwu6dG1F/7Kh9yA4sxtxT2hOQlk913JrPgM1Pa8765jlPOOBO9Gs0dPd0yUDpnRsr282Zml+t79JfMDPXE9m5UMrozLUBnO3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898145; c=relaxed/simple;
	bh=mX+izFiI+NgByyzRSA0DrqOFTSp7BF4Ga25xh4YSCXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2Qs6m+4GVKlEEiLclUFKa0yKXH4lHDfiuWAepprVRkB4ESG0kVrrOgUQtNhMUpuD722DZjLjyL14zGJi6fykoVtn6e1w4X/9+tZenx/pfGhVX6F7bSADiPTwzkvKQNrmadZXLNzrqfcOeBQF5viqFC7Gn0gDfUkqAAju7eH0Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHYxZc2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHYxZc2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A91FC4CECD;
	Wed,  6 Nov 2024 13:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898145;
	bh=mX+izFiI+NgByyzRSA0DrqOFTSp7BF4Ga25xh4YSCXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHYxZc2aT+zHmV9107a12r/i9wioLz7rVQmliGIFA75e5mMCG+AinOs6gPN28ypu/
	 gy1D5QJLmZZrhO8l0kzLfug7cdcJU0eCChLGRWo0IV/3XCNzYm9iDQNQ1GBLEJp5yi
	 xXBLlx69Aqz6JhdVgpshmIO02gX19ZWYrLyiI79c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hailey Mothershead <hailmo@amazon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.4 138/462] crypto: aead,cipher - zeroize key buffer after use
Date: Wed,  6 Nov 2024 13:00:31 +0100
Message-ID: <20241106120334.916947784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hailey Mothershead <hailmo@amazon.com>

commit 23e4099bdc3c8381992f9eb975c79196d6755210 upstream.

I.G 9.7.B for FIPS 140-3 specifies that variables temporarily holding
cryptographic information should be zeroized once they are no longer
needed. Accomplish this by using kfree_sensitive for buffers that
previously held the private key.

Signed-off-by: Hailey Mothershead <hailmo@amazon.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/aead.c   |    3 +--
 crypto/cipher.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -40,8 +40,7 @@ static int setkey_unaligned(struct crypt
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = crypto_aead_alg(tfm)->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kzfree(buffer);
 	return ret;
 }
 
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -33,8 +33,7 @@ static int setkey_unaligned(struct crypt
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = cia->cia_setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kzfree(buffer);
 	return ret;
 
 }


