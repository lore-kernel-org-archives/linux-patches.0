Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10D147010D;
	Tue, 21 Jul 2026 20:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665433; cv=none; b=A4SoHYWL9aWUoDznMapoA2OR+SxgOeMDfQS9gdpaA9KRrti93nk+OGoMUGSYR57EAXnarP2DZAoSeFVx3pDYzaQ5+HWxHdNaPoHc9RjMw3dupf2B9k+nGFnFs+i/fhZNNl2zKUJ2feR4+auj96YK7z7c1YsdU5To3D8SmvvIFsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665433; c=relaxed/simple;
	bh=3/aN/ZkEL5DLUoHDNVHTKhbk5KodtDRTraJefrCQ8lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ0d1UQwPlDNhFgQPR3Su5J2ahFYejQ5veLIPe7UuCffARmeEAiq1ZqK08d+c8Ux4QUhlWnqPKDRLqzEuGQ5re/jFehNQdFFMj1mefXUxE05zjzCE8Sb+YQRKuJyzOAcbw4qZ9CR/63x3m3exOmR3yXmQ4F25Sz0DtHxihIsjHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+1dhaL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+1dhaL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133001F000E9;
	Tue, 21 Jul 2026 20:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665432;
	bh=pqtciEkaVoRHdoXd0MECVRO/yLODODsIFoNpCqMO33s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+1dhaL8QpKrj2NWsHks/rGd/2vRYoHT59axZ7aiUb4nToRVrV+Y/uVL9Hl37tFEx
	 9Yh47c+jRBMOrxCmDRKuUB5aoAJnvZAdgKa1aUQbFsahuHvPaPGg5bcV4OaHkq5kiK
	 DuIrH8kH+jU5XNHVn+gBG1lyBJ/Xs7OHJy5gosJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0275/1266] crypto: drbg - Fix drbg_max_addtl() on 64-bit kernels
Date: Tue, 21 Jul 2026 17:11:52 +0200
Message-ID: <20260721152447.976795109@linuxfoundation.org>
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


