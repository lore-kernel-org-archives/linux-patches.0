Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211336;
	b=u22uB8424i0pblM0LTWvb3AL+mDRgjG1FtvYHz71HwBu63ZqxKY+pImbdE4gu/iX6Wes
	 Oh7D5Vq/pDICfwcIM+n8GaAP8GDDzsGK1sTSk5vKwbFR93aCnrHOUSRFMj1EPO58CZd5w
	 cDwgI87rp8ZX1gGiXJwrlCIphP2igFaD7XN9sizvn2jDI9IcHKgm7VgZ69Sy97YyCJGSB
	 5Y3M1LKiR/sS5TtKRvQJKmTHLlEBj7fUphfnb8BVc8Ye18rR50NsRBnnN3N83c/ohF5oM
	 Q9LdL8rDiocgaSVjcpWJTwkX9ygDQuFr1lsyTVp0cVrOFS9RJmQxeMoVsLw5nlhLFkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sIa49CNg4hBsA7J8KldyS9NeBCHkhMCzJwq/u71+qPE=;
	b=pRuw3bJdgnnzZB9Ta1KucmkR1otZFsUIAtx2KJnHVgg27IS0Q7IBq6feeGaUCV+b19zS
	 Os/VUb2Eoe7ZFvQFXlkqpSNw8/YWdp0urag3XBVTJV1jY/yuTP+LelusJ2VsqTqyi1NFN
	 RtdP9A6Lpf6mjm+UP/mau6xArXOqD9lZ/MQTaxpWnS7HmIiQwJuvSiII4VXYa8Q9md0Em
	 MhICRxvps+qEB4psxPpDpZN5JSr7wO2x6Kucq9TqYykXgN0d7cM+Qgb6L0jlFkb1dv89n
	 ZgdMGOfEh9Pyk9b50+x3/f33aWehogHAfdO+7lEv9TQXPNg8mAEk5BiUXUfCiQvrjJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1b4MDDZe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AEA606A32E;
	Wed, 28 Oct 2026 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1b4MDDZe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35281F01825;
	Wed, 28 Oct 2026 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211336;
	bh=sIa49CNg4hBsA7J8KldyS9NeBCHkhMCzJwq/u71+qPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1b4MDDZeyzR0pKjjJ1q9e51qUIRjBO5cWUz10AMQdrAWTaDZYZeDXJW2E4JVNFwHE
	 yTLe5bUmt/DsLNXHUHKPqfp4ZX1d046eFs6iP5CB6vtjmShj6ALdke6Pskm7v0FO/4
	 QDU5jMX/XeCsjR7KbpSbyK8VorDjNd5DWshkcTgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/571] crypto: drbg - Fix ineffective sanity check
Date: Wed, 28 Oct 2026 17:58:09 +0100
Message-ID: <20261028170016.133553570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 040ad83b0e8aa065fd2fc641cacba8491a8b186d upstream.

Fix drbg_healthcheck_sanity() to correctly check the return value of
drbg_generate().  drbg_generate() returns 0 on success, or a negative
errno value on failure.  drbg_healthcheck_sanity() incorrectly assumed
that it returned a positive value on success.

This didn't make the sanity check fail, but it made it ineffective.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/drbg.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 0111396601722..1dfa927a27eab 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1976,7 +1976,6 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
@@ -2018,12 +2017,12 @@ static inline int __init drbg_healthcheck_sanity(void)
 	max_addtllen = drbg_max_addtl(drbg);
 	max_request_bytes = drbg_max_request_bytes(drbg);
 	drbg_string_fill(&addtl, buf, max_addtllen + 1);
-	/* overflow addtllen with additonal info string */
-	len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
-	BUG_ON(0 < len);
+	/* overflow addtllen with additional info string */
+	ret = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
+	BUG_ON(ret == 0);
 	/* overflow max_bits */
-	len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
-	BUG_ON(0 < len);
+	ret = drbg_generate(drbg, buf, max_request_bytes + 1, NULL);
+	BUG_ON(ret == 0);
 
 	/* overflow max addtllen with personalization string */
 	ret = drbg_seed(drbg, &addtl, false);
-- 
2.53.0



