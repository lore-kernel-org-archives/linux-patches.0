Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF5C47141E;
	Tue, 21 Jul 2026 20:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665462; cv=none; b=TBL6j88UKcBIVXirXqkevQsij+mqwX8fMsIU0H6t5NDu+fl9oRuH/pIaJvOxGb6WD64PsHD+xlt0l4wmJV24TL/FPEyh8NnYSaFUuQecLjgLETQbFzKWgmld8vnYip2p/MacucWYBtM8egxBpkFIHdKAivviPELgnoHvKIb7iog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665462; c=relaxed/simple;
	bh=oh5XayQFmeS79XjW5MlGVPqqsJs2ePNQdDmnyUwNGHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX5Sv49O5ooQmGRnfsfvQXiC1zTFrsoDIikv+Qk0khH4hLlqDcJRVAmatKEMor1hc/nuhJod2GiYaPeOBwBhhZHhZ4bKsf+GS14qBcHU2Yxg32h2JNEY2uz1HIS2WCXm6CxKfmtwdkGPp9SJlwgFeEcmBkCwDb1gXRoJDGLPv4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2tcOYYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2tcOYYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AC21F000E9;
	Tue, 21 Jul 2026 20:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665461;
	bh=BZbRwcmWgNPijVPADA8S+YJ8H11ZNf7YQUXCTyx/Gog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2tcOYYTEvx3fQiz1pLUvq8Y8G50/Wp/BD4pPyQaO2RYC7nY2nDJSfxOgwUQnS93M
	 VooPW4qjItfL41Ri94ghY6NUnrOa8fXM/BjxPM0nBxdfy3w0UbmaOD5xg9+xrNUbb5
	 G6jvlAdb9qQvTzDgrqtd0JnhOav0T2R/we8P+jmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0276/1266] crypto: drbg - Fix the fips_enabled priority boost
Date: Tue, 21 Jul 2026 17:11:53 +0200
Message-ID: <20260721152448.000367567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

commit a8a1f93080efc83a9ff8452954429ae379e9e614 upstream.

When fips_enabled=1, it seems to have been intended for one of the
algorithms defined in crypto/drbg.c to be the highest priority "stdrng"
algorithm, so that it is what is used by "stdrng" users.

However, the code only boosts the priority to 400, which is less than
the priority 500 used in drivers/crypto/caam/caamprng.c.  Thus, the CAAM
RNG could be used instead.

Fix this by boosting the priority by 2000 instead of 200.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2095,7 +2095,7 @@ static inline void __init drbg_fill_arra
 	 * it is selected.
 	 */
 	if (fips_enabled)
-		alg->base.cra_priority += 200;
+		alg->base.cra_priority += 2000;
 
 	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
 	alg->base.cra_module	= THIS_MODULE;


