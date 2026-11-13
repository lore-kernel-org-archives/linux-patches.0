Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585412;
	b=tLRrFmYfNQSDYmkaeXvXbUEhCwZxbtuf9cFWEnBn99QvwaBsvrma6DOXTPyCo5xkuaZN
	 Koys3ez0FGL+2ysK4U8nPFU+6dd1GKZEYcAJ59EoWGR+CqP6PzIpk7MEpFJ+85NxFDpoF
	 PsVyiBjm5JLDAds4yns/n4rG3uDJolskKoRGc0s4M9IBaRb1Ye9acUqYiZivVKfkS22z1
	 4qyrUhBYbdPaaoClCIarpUguvdx6MU5PHL3TjiQ5Jy4NBZq5OOJVFRTy2t0trAQCAuMhp
	 +Ed3kO2P+jLJlD6NUUFuGqrW4DlkcqrebqgHg32ASKdyQ8dqnHTyTOFRn5I113WxOiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0mbwtwBeorc71MwitENPrSqJwvAJVpcbTrgMfUN/ywg=;
	b=rkt6k5/N13SUZjZYYpZhqoyiKZiTck/iudBo2dJqu+0qIci45SraYRMybnyf/6TRqH8R
	 mPUsNOD7FjCd79iyace+vSL1R8gP70j4MPqL/GhGQXWK1fGUnJxEEno4WpbOo9/qjKjB8
	 i2VYdQ+BoMFsJPdTO6v8tQIoQJ6sx+r9/yncvYDeBtN4P+04zkhlxaS1CPH/rQXZbxeut
	 4ryStYYb94+2mHB1w1SrG6HSXo7exS+7G+8ukiV28owv4ak2GM0HUdh2MVLAmgVwUFVHU
	 hr4tUodBxikZCA0PeZVbb5jtS7CuQL7vZTHqsLaJxR2hCUK7KGQPYvnig4Z62Lg+I0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5fvFXxa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461D0606B2EA;
	Fri, 13 Nov 2026 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5fvFXxa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CDF1F000C4;
	Fri, 13 Nov 2026 15:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585412;
	bh=0mbwtwBeorc71MwitENPrSqJwvAJVpcbTrgMfUN/ywg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5fvFXxayfXnBZs/5SNeU7WSqp0d+IlmmQAj+IYfm3Me8okKE7KGzol5BeQnooi3L
	 iEisrz7/obxh4J89Ok18h9dcpCLfsE07SU91M+FbFkoeN6maTqEELhgWPtM9xduT3A
	 jxPrR9kn9vm210HgCHmpeuP0pErmxTpgy1I2SbNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 079/507] lib/crypto: mldsa: Check pk_len before doing pointer arithmetic
Date: Fri, 13 Nov 2026 10:46:23 -0500
Message-ID: <20261113153756.386228492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 5c140c870044af2f4b79e87b42d078cf7c318582 ]

Though common in the kernel and benign in practice (not even triggering
UBSAN warnings), taking an address past the end of an array is undefined
behavior according to the C specification.

Therefore, compute &pk[RHO_LEN] only after pk_len has been validated,
since pk_len could be less than RHO_LEN if an incorrectly sized public
key is provided.

(Also fix a typo that isn't worth its own commit.)

Fixes: 64edccea594c ("lib/crypto: Add ML-DSA verification support")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20261029054534.68481-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/crypto/mldsa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/mldsa.c b/lib/crypto/mldsa.c
index c96fddc4e7dcf..68a1b432315b1 100644
--- a/lib/crypto/mldsa.c
+++ b/lib/crypto/mldsa.c
@@ -306,7 +306,7 @@ static const u8 *decode_t1_elem(struct mldsa_ring_elem *out,
  * Reference: FIPS 204 Algorithm 27, sigDecode.
  *
  * This also validates that the coefficients of z are in range, corresponding
- * the infinity norm check at the end of Algorithm 8, ML-DSA.Verify_internal.
+ * to the infinity norm check at the end of Algorithm 8, ML-DSA.Verify_internal.
  *
  * Finally, this also converts z to NTT form.
  */
@@ -533,7 +533,7 @@ int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 	/* For now this just does pure ML-DSA with an empty context string. */
 	static const u8 msg_prefix[2] = { /* dom_sep= */ 0, /* ctx_len= */ 0 };
 	const u8 *ctilde; /* The signer's commitment hash */
-	const u8 *t1_encoded = &pk[RHO_LEN]; /* Next encoded element of t_1 */
+	const u8 *t1_encoded; /* Next encoded element of t_1 */
 	u8 *h; /* The signer's hint vector, length k * N */
 	size_t w1_enc_len;
 
@@ -587,6 +587,7 @@ int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 	 * The computation is the same for each of the k rows.  Just do each row
 	 * before moving on to the next, resulting in only one loop over k.
 	 */
+	t1_encoded = &pk[RHO_LEN];
 	for (int i = 0; i < k; i++) {
 		/*
 		 * tmp = NTT(A) * NTT(z) * 2^-32
-- 
2.53.0



