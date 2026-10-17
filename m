Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925093976BA;
	Sat, 17 Oct 2026 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257137; cv=none; b=n1JfyTf4NoH+IpbOthe08AsJf/GakN+PYaTGI6FuEORgLamxk4ZbSkhNlmLNQ9ZsnYB6WZexXi0DWp8wwkIVljGTSaI7hoKA2tcqTHn0kmEHUeP0PaCAIFezNS1TCChxhEKFbNNX3R20a+DqNpxq3hqBj/4qrl58KspHkURDhrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257137; c=relaxed/simple;
	bh=e3rkDvS0x5N/QgppikOnRnBIaD17INCEdSC2mgjxtYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crqz0ASJjKpAAupZVZgycYsZkPeLDSg3zkwKRXslNmxFII26P8YNLre/kDqLH6NrOO0NQFmy0e5IqCD8KcSl3BCByUf3mXtfx0M8IGsGHb8aNM5p+b09yCJ5yeXsqBj6k8ySmwF5454bhi5Gdtccs/mpbZYMI5MpzLwbzcCpr2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLmZyF4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLmZyF4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6551F000C4;
	Sat, 17 Oct 2026 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257136;
	bh=5rYiLMlb0AFMZFrBqSo6PTg2ig15aAIckOxyUuKIR5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLmZyF4T2sKXx5RpO4LLBYEbCPws5x3PNyZGmQ7//NbTJs0jnfwAGKd4oKnhQt4uQ
	 044islP3fsoaCnvhwjbCCXCNjcbmiGFlDcLRBc822Fcg+SvT6Rt9A9m38qm+YOxGEj
	 IEAe4oT14f5SVWdefIBbNGmvTiVV0s5sJiL14ai4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0462/1674] crypto: drbg - Fix ineffective sanity check
Date: Sat, 17 Oct 2026 17:45:34 +0200
Message-ID: <20261017160442.977006752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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
index 211757f3f9723..8d6dff6f8c9d1 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2001,7 +2001,6 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
@@ -2043,12 +2042,12 @@ static inline int __init drbg_healthcheck_sanity(void)
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



