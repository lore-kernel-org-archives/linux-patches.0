Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E4642BC41;
	Thu, 16 Jul 2026 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209946; cv=none; b=C/0pnIkXIJVRd7SXlNWBAr6VmyknlobuQNyvMMIts0xsB3FaandeFYgeJ4vWdSaluoPortzmXl1GVsJ5IoPpeCb3Hie7/UjEGnRU5jgmj1gSt6OHb4FgHaDFttWZy0HH6UXDnkUYlNu4Li47n89P2Gb/PiKW08kSYcppjFNm+Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209946; c=relaxed/simple;
	bh=ZiU6eHzcZ8RhzkVod32KJJQ1PoYl269YgoOGp3JY3cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geCqIS+r7jqyGlrAMNGbOz40u0J711ErOTQbdwRRp3UJuRdu9ZBht7JlKpyJDe+UnbrMbYdWlyxTSzq4/j4xX7OB2VzxPlaWM5AdBOo/guw7FiMJdec7xeAjh4zhIeAbjgJxc9m3b4yWTHJqQULjtOvIij2Q2fNPMB8BE3nrZD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdTvGuif; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdTvGuif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736D41F00A3A;
	Thu, 16 Jul 2026 13:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209944;
	bh=WaGFYf8T7LnrhhT3E945YKujqx4V7W9x40KCHwf82F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdTvGuifMI0TfwRL2lbH4X9HEqWdgXg4Q6MbvWZMieEWLZ1LdrY7AYW6zMljHbrGh
	 kGw/O34WqngL1LNpIHUmFwnDDq3E4WEoe1SLiQEBXos8cUt1Hz2AovEP1L0tZPmNv1
	 ybiXhN//SFTBB570yP2+g0jBr0jM8ODs/nUa6Q9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 378/518] crypto: drbg - Fix drbg_max_addtl() on 64-bit kernels
Date: Thu, 16 Jul 2026 15:30:46 +0200
Message-ID: <20260716133056.097939164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 6f49f00c981bbb9ef602966f19bfdbef46b681d2 upstream.

On 64-bit kernels, drbg_max_addtl() returns 2**35 bytes.  That's too
large, for two reasons:

1. SP800-90A says the maximum limit is 2**35 *bits*, not 2**35 bytes.
   So the implemented limit has confused bits and bytes.

2. When drbg_kcapi_hash() calls crypto_shash_update() on the additional
   information string, the length is implicitly cast to 'unsigned int'.
   That truncates the additional information string to U32_MAX bytes.

Fix the maximum additional information string length to always be
U32_MAX - 1, causing an error to be returned for any longer lengths.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/drbg.h |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -148,19 +148,15 @@ static inline size_t drbg_max_request_by
 	return (1 << 16);
 }
 
+/*
+ * SP800-90A allows implementations to support additional info / personalization
+ * strings of up to 2**35 bits.  Implementations can have a smaller maximum.  We
+ * use 2**35 - 16 bits == U32_MAX - 1 bytes so that the max + 1 always fits in a
+ * size_t, allowing drbg_healthcheck_sanity() to verify its enforcement.
+ */
 static inline size_t drbg_max_addtl(struct drbg_state *drbg)
 {
-	/* SP800-90A requires 2**35 bytes additional info str / pers str */
-#if (__BITS_PER_LONG == 32)
-	/*
-	 * SP800-90A allows smaller maximum numbers to be returned -- we
-	 * return SIZE_MAX - 1 to allow the verification of the enforcement
-	 * of this value in drbg_healthcheck_sanity.
-	 */
-	return (SIZE_MAX - 1);
-#else
-	return (1UL<<35);
-#endif
+	return U32_MAX - 1;
 }
 
 static inline size_t drbg_max_requests(struct drbg_state *drbg)


