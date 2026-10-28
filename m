Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208994;
	b=e8aJzAwS77XjNSWU8b4YLUlpOokeTZTFtJPK9a2eQclXe43SIukxRYLLxKWpIdKXdUqC
	 RTjH6ZE0KmkPvz7+sL9NuosZjAGtmu+J5ueSP+EXWdx08SCdIRcadtZJTHgENj0LCQc7d
	 mSsk/m2HlZ9zax8H+8GdTdK2JZPUb/3nCDwQPn3zFZsVu/FH6oi5Fv4Gm/oqn20J8naBK
	 gfLEhLvwfqDPp20wQXuAxJUHS7r4bmXNkHpJ1whDGlcPjpQaI74WfL+u6dCjci5Q2tR4a
	 IemOvVNbeotXUj1NFpP/SSuwEQL5fz6fcSdpuanruYbqxeRtSc8foQEYiiWpi7KxRTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKjz2RpFqbMSdRvdxrOZvNItHT0erc0acJOFLBrVVJQ=;
	b=kEPpUTYQheQ6l7CVDT69FCxzhU+itrvRrpJQgn/c5HV6ngsSHIBfKUJEOaXVy9HO1WtR
	 Ost9oVxsumq6So5LXjAC82c9pMQBJvHcFKPrkyl41jF6bUHx+gRReI7BN4Nt8s4XHPuEn
	 Ux1Tr7/TevcolMFJbz9RaXvidt6X4UsAzCe0NWWdFC/O42ss55NSdxpRquJwImQpoaFkP
	 H6MBKY+7AkTmqcmJYiOs9YGz2ZaTsdGEwEDtODd/CNcbUHRCW7Ew6KfJezwrif03FJbHQ
	 8Xa9nsfqL9pUcb3fbqBTX/kOcl2cXqDVXKE1NFN7QKkJw+7Nf1Wwd5CHNKM+MU//XSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPJgUuwb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C30B606A31C;
	Wed, 28 Oct 2026 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPJgUuwb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE931F01825;
	Wed, 28 Oct 2026 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208993;
	bh=cKjz2RpFqbMSdRvdxrOZvNItHT0erc0acJOFLBrVVJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPJgUuwbLqFitRu5eZZ6Wx4/Xp6/uzn7J5VmfHhmSZQMzPblUp32wIS9wIeyOvZ5V
	 6fo7UXkOuai4++XvWwfdjrMqIpFFFVjZIuf6bmyEP43uAt0RlHoEcE57lu22PTOq63
	 HCbShWCW4aZCHWJo2RjjJ6pln4HR3+Jluhm08SJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/516] crypto: drbg - Fix ineffective sanity check
Date: Wed, 28 Oct 2026 17:57:46 +0100
Message-ID: <20261028170010.928308675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 crypto/drbg.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1975,7 +1975,6 @@ static int drbg_kcapi_seed(struct crypto
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
@@ -2017,12 +2016,12 @@ static inline int __init drbg_healthchec
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


