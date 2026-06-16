Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2C047DFB9;
	Tue, 16 Jun 2026 18:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634666; cv=none; b=AK3mRTHqhlMMO6Mu5A01mV9xjPLtVv3/IiMX/tqzSbRut/bBettgzPfou4OWRrHRc1gCNXQC61n5lh5VO504w0iMSdSFU6uzQF+ySMU14PTr8s9OP/8kpf0zcWFYWb/vWQOKQKX2pO1t8fZtZ6Fk8RpbJeaiDP2gpdROyf7dJCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634666; c=relaxed/simple;
	bh=1aXt2QH2HpMPY34QTFSlyOx4+X3hxtkPxeiHBDVRxdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jie6pgkx5RyWndUnRG4PVgyyQHwUESPKS/0JFHFkYH1snlYqZNK1pJ16v0T5Dk7Dlw5NGRYNTcRydQScZvrNkHqcYzzLQ7Vn8NsEuc0trBYUGuXq+MMk2wNxZHllMuoo75b1iPXuruvvBtPlR9gqUCeuIK+yx/yox8lA9giBuXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2TnX1cV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2TnX1cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D9B1F000E9;
	Tue, 16 Jun 2026 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634659;
	bh=TLVBFFcwYTelj+ztK51mGwcDDhCOalW6axBluFpCMgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2TnX1cVLe+uJYtoozBaP59CkXBNHSAGNN+kDCkQrCZIdUUXwNBecGjqBq1Nqcn82
	 1HCRvUI3IoJHFADxU5lGPXSvThXB4z0IpbCn8YdFhNYl0sYLajNut1EHG8TKioLBnf
	 of7vKjlexHYC9nxdvclb7Is9AQxma4K87L2fxUY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/411] net: ipv6: stop checking crypto_ahash_alignmask
Date: Tue, 16 Jun 2026 20:29:06 +0530
Message-ID: <20260616145117.525769531@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 0a6bfaa0e695facb072f2fedfb55df37c4483b50 ]

Now that the alignmask for ahash and shash algorithms is always 0,
crypto_ahash_alignmask() always returns 0 and will be removed.  In
preparation for this, stop checking crypto_ahash_alignmask() in ah6.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: ec54093e6a8f ("xfrm: ah: account for ESN high bits in async callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ah6.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -79,9 +79,7 @@ static void *ah_alloc_tmp(struct crypto_
 {
 	unsigned int len;
 
-	len = size + crypto_ahash_digestsize(ahash) +
-	      (crypto_ahash_alignmask(ahash) &
-	       ~(crypto_tfm_ctx_alignment() - 1));
+	len = size + crypto_ahash_digestsize(ahash);
 
 	len = ALIGN(len, crypto_tfm_ctx_alignment());
 
@@ -103,10 +101,9 @@ static inline u8 *ah_tmp_auth(u8 *tmp, u
 	return tmp + offset;
 }
 
-static inline u8 *ah_tmp_icv(struct crypto_ahash *ahash, void *tmp,
-			     unsigned int offset)
+static inline u8 *ah_tmp_icv(void *tmp, unsigned int offset)
 {
-	return PTR_ALIGN((u8 *)tmp + offset, crypto_ahash_alignmask(ahash) + 1);
+	return tmp + offset;
 }
 
 static inline struct ahash_request *ah_tmp_req(struct crypto_ahash *ahash,
@@ -330,7 +327,7 @@ static void ah6_output_done(struct crypt
 
 	iph_base = AH_SKB_CB(skb)->tmp;
 	iph_ext = ah_tmp_ext(iph_base);
-	icv = ah_tmp_icv(ahp->ahash, iph_ext, extlen);
+	icv = ah_tmp_icv(iph_ext, extlen);
 
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 	memcpy(top_iph, iph_base, IPV6HDR_BASELEN);
@@ -387,7 +384,7 @@ static int ah6_output(struct xfrm_state
 
 	iph_ext = ah_tmp_ext(iph_base);
 	seqhi = (__be32 *)((char *)iph_ext + extlen);
-	icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;
@@ -483,7 +480,7 @@ static void ah6_input_done(struct crypto
 
 	work_iph = AH_SKB_CB(skb)->tmp;
 	auth_data = ah_tmp_auth(work_iph, hdr_len);
-	icv = ah_tmp_icv(ahp->ahash, auth_data, ahp->icv_trunc_len);
+	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
 
 	err = crypto_memneq(icv, auth_data, ahp->icv_trunc_len) ? -EBADMSG : 0;
 	if (err)
@@ -591,7 +588,7 @@ static int ah6_input(struct xfrm_state *
 
 	auth_data = ah_tmp_auth((u8 *)work_iph, hdr_len);
 	seqhi = (__be32 *)(auth_data + ahp->icv_trunc_len);
-	icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;


