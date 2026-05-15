Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCC03F44D5;
	Fri, 15 May 2026 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861678; cv=none; b=Vr09yY7KhV52FD3MrcUJiUMo5xMRxRRb/5ba6ABjEcji9p9llxvyOUo7zv7nyBcUDy73XHeN1tbuueJRkSrzcYWOXLV0DeGEXYYIR9O+CUhd+4l5REB7QaXD/iM9QjHmso7Nr5hNCA6ttsi9VdKCCaqFXDDIyVKK2yBaQ9xe93w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861678; c=relaxed/simple;
	bh=3HMstwH/5fPFu7XplU8uy0Z+YYDWh5GvnvjrKSlqRsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzhoJ+3jKyDZ1e7WZzfjp9qF5uczKNb+fSx1WCHSm1mZKB+wO7EUJ8sw+gGIQwO0N1bpbsiPHg+DNqjnCk946B3JgW7dEsbmq0Bcs1VU5Ao6pncmPeCOtG33LD1gJhpCNs0XnkqQcWJbGD/sTzEqjtKHFlK3/lvIl1bdZHsRuJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkf6ehRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkf6ehRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B46C2BCB0;
	Fri, 15 May 2026 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861678;
	bh=3HMstwH/5fPFu7XplU8uy0Z+YYDWh5GvnvjrKSlqRsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkf6ehRyv3jImAGlh10xuS94QOjReHZULsp7FcLeHyPa91mEZfjxx6ArJjo5YJY0x
	 P0dZbizEYxlHVcP8WpLLWzdBhmrpVbDSAmcXRz/oqylwyuFwzJV1jlWnuIJDL7WIg3
	 hXZ1+THwKIolE5lRWxtw9Y2PTF4haZHESy0IHPFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 419/474] net: ipv6: stop checking crypto_ahash_alignmask
Date: Fri, 15 May 2026 17:48:48 +0200
Message-ID: <20260515154724.127843562@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -327,7 +324,7 @@ static void ah6_output_done(void *data,
 
 	iph_base = AH_SKB_CB(skb)->tmp;
 	iph_ext = ah_tmp_ext(iph_base);
-	icv = ah_tmp_icv(ahp->ahash, iph_ext, extlen);
+	icv = ah_tmp_icv(iph_ext, extlen);
 
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 	memcpy(top_iph, iph_base, IPV6HDR_BASELEN);
@@ -384,7 +381,7 @@ static int ah6_output(struct xfrm_state
 
 	iph_ext = ah_tmp_ext(iph_base);
 	seqhi = (__be32 *)((char *)iph_ext + extlen);
-	icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;
@@ -480,7 +477,7 @@ static void ah6_input_done(void *data, i
 
 	work_iph = AH_SKB_CB(skb)->tmp;
 	auth_data = ah_tmp_auth(work_iph, hdr_len);
-	icv = ah_tmp_icv(ahp->ahash, auth_data, ahp->icv_trunc_len);
+	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
 
 	err = crypto_memneq(icv, auth_data, ahp->icv_trunc_len) ? -EBADMSG : 0;
 	if (err)
@@ -588,7 +585,7 @@ static int ah6_input(struct xfrm_state *
 
 	auth_data = ah_tmp_auth((u8 *)work_iph, hdr_len);
 	seqhi = (__be32 *)(auth_data + ahp->icv_trunc_len);
-	icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;


