Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343C14F68CF;
	Tue, 13 Oct 2026 12:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895671; cv=none; b=WoEkeqEZ9QVSgE7ZG7Z1Ofc58sl5HgU/suTJ7EET0C2NMoFDmm5ZokdNpo1sALpuK59jfVn6uerjnhBQ2F5W6/44ZQQ+QFoidsQnVglzq7Y5NyJu+1CkHGc8pHbp+e2YJqdCxVdEq1rGf8geRHzGkoEtsUfbAHtEqaguHXmEMn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895671; c=relaxed/simple;
	bh=8JUiCWWNZNZzh6ZFoZJYRXSv1ekEyAe0VmRpF9BTopA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgpK3Q7F1y0tDxLY/7L4N4WlIEllaz7jPr2sg2sg9VTQHQqkm5gcLj+h5kMYtMjhaWPRPKFtFMCAeedF9XDinCw6v40HNHGnrnpjdBlwpAOq359AzEH0KPj9HdmDCXOhSCKa3J6JWUFN8XbQjdmmEHCXGzMY2Yp/RDLb3rZ2Mkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDiwoKBX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDiwoKBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8241F000FF;
	Tue, 13 Oct 2026 12:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895670;
	bh=UGTzOValLUwzunD+6e1oM+xJZQhHdIrDtrPwpZ0JE8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDiwoKBX/j66nYJNoFj5aWFVW4xJFzz4R39xFgv0VvMKOUs2NKqV/I8Ht090whc5z
	 ztXemaToWV6ndFYhclOvQj66BbXTNhZA4ESS0/2Qvl39B1WNd6sVniAgWw451nOpVI
	 oTma41minShodlm+qFkXZZcKbOQ0P2skyxOILcHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/497] crypto: drbg - Fix ineffective sanity check
Date: Tue, 13 Oct 2026 13:38:39 +0200
Message-ID: <20261013112916.262779498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 053a24d064143..36574b1f6c3f9 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1985,7 +1985,6 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
@@ -2029,12 +2028,12 @@ static inline int __init drbg_healthcheck_sanity(void)
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



