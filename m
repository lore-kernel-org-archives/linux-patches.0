Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32544435A97;
	Thu, 16 Jul 2026 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212456; cv=none; b=OXl5+wHveU3nMXSEaBhLxHb7Y9nTw/uWgVmr8D11fPdPmBVvpdFj8AIDYfCMS6dkVVFgN2s0483UBk/X+0yVT7sjtB61XCW4QQJzXzmi+28Q37pwcO3XLYVB0aMVonctE7q7O72zl+PIqgfpX1vgf55nVkx++Si1qtdZR96N8ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212456; c=relaxed/simple;
	bh=Ja1NX9TCQ4Nog+PcK0/eLyssb1yPEpzIc/3Okqk+UZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiJxdlx3sFIO6BR/m6wPPUpcEyaemCw0t/qbVZvincIzbLuSN6pFgYIwqW6DCbwrUGTs4YEYhEWQQTIswM/tgRS7mikSJLfU5JXuW0oimPj56oKLwAHOG7hNv6QlWTPMXErCUq7vEhZvZH55d/RmCVPsLZFjzFFFXRfgN4ktjso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuPfVl5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuPfVl5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BD11F000E9;
	Thu, 16 Jul 2026 14:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212455;
	bh=XBItX+s8fOcyP1gqrRkjF/0GVKN6LxDDlHVsgyMEW/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuPfVl5R41eISAPtBCqWCS6MV0yz7gCtJxDi6WDm9/hygXA4QG3vz0ixnnWwwpTTI
	 QRjW+WogM56E4hAFm4f7+y8KdcQFreY9tOPFCwgjLbUTwgA9XCR8svvrEMgkcg1Nj8
	 oQSEeJT7dFKXvNzjYb8WXFjYi68idbax/rV16+7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 280/349] crypto: drbg - Fix drbg_max_addtl() on 64-bit kernels
Date: Thu, 16 Jul 2026 15:33:34 +0200
Message-ID: <20260716133039.605299135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -171,19 +171,15 @@ static inline size_t drbg_max_request_by
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


