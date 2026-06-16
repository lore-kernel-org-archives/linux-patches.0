Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AB54657E7;
	Tue, 16 Jun 2026 17:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632425; cv=none; b=hFZwAAYUBB0vEjp3ZQFuZQfy/A/zJAtbGj9Yt3p1V91GM1Bz3asjgFHilz4XtmtxgZj96BDwdaxs4ltU9IJnGg2jbTpER699H3q9UHuP8ji+8jv5M/E6UTqdDDrRqkF8yLbbG9SEnElU+fz1jE58ajnnf46OrW69h0uyGRbDCfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632425; c=relaxed/simple;
	bh=uKh7sACdnvaxcNlMfVorCe43UJQcJc3xjwjK7P2FhOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzxeLdpYyGzzLhA9iR6P0PGjng0kmdlpgfgk3KLA9ChLX9uOYiAYg4A1PwW6IcWIj6ovlCqmoPKK9ITaWCvVxbh82DI1KeA+aCx6EsfYb1fv/zkj2kV3wXInZgAbaS+FHCPhzUNLeh8TTslbV1OXl+1EqpTW+l0BPQa8LS+L+mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Pm8uHmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Pm8uHmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AF11F000E9;
	Tue, 16 Jun 2026 17:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632423;
	bh=Mxpb8+KGxvPKqOtWV+gk4Tc3rS7xLzcRmzfMqlksUIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Pm8uHmpwebFYe3VN3vjxC9Dq27guTIz3zux7luhJvYXTnBiqBMloBb+ZmkBNSeIS
	 FZJc1knr/dYeKJJ8EDpWq1YHTuofIrqKILf1fph4qUUwanouKy+/OJyyIWmbSQmGI7
	 Be6UjDArjeT4PTf8fbpPyB35UrkrAKzHuW5Dmv2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 375/522] net: ipv4: stop checking crypto_ahash_alignmask
Date: Tue, 16 Jun 2026 20:28:42 +0530
Message-ID: <20260616145143.326415700@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit e77f5dd701381cef35b9ea8b6dea6e62c8a7f9f3 ]

Now that the alignmask for ahash and shash algorithms is always 0,
crypto_ahash_alignmask() always returns 0 and will be removed.  In
preparation for this, stop checking crypto_ahash_alignmask() in ah4.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: ec54093e6a8f ("xfrm: ah: account for ESN high bits in async callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ah4.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -27,9 +27,7 @@ static void *ah_alloc_tmp(struct crypto_
 {
 	unsigned int len;
 
-	len = size + crypto_ahash_digestsize(ahash) +
-	      (crypto_ahash_alignmask(ahash) &
-	       ~(crypto_tfm_ctx_alignment() - 1));
+	len = size + crypto_ahash_digestsize(ahash);
 
 	len = ALIGN(len, crypto_tfm_ctx_alignment());
 
@@ -46,10 +44,9 @@ static inline u8 *ah_tmp_auth(void *tmp,
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
@@ -129,7 +126,7 @@ static void ah_output_done(struct crypto
 	int ihl = ip_hdrlen(skb);
 
 	iph = AH_SKB_CB(skb)->tmp;
-	icv = ah_tmp_icv(ahp->ahash, iph, ihl);
+	icv = ah_tmp_icv(iph, ihl);
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 
 	top_iph->tos = iph->tos;
@@ -182,7 +179,7 @@ static int ah_output(struct xfrm_state *
 	if (!iph)
 		goto out;
 	seqhi = (__be32 *)((char *)iph + ihl);
-	icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;
@@ -279,7 +276,7 @@ static void ah_input_done(struct crypto_
 
 	work_iph = AH_SKB_CB(skb)->tmp;
 	auth_data = ah_tmp_auth(work_iph, ihl);
-	icv = ah_tmp_icv(ahp->ahash, auth_data, ahp->icv_trunc_len);
+	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
 
 	err = crypto_memneq(icv, auth_data, ahp->icv_trunc_len) ? -EBADMSG : 0;
 	if (err)
@@ -374,7 +371,7 @@ static int ah_input(struct xfrm_state *x
 
 	seqhi = (__be32 *)((char *)work_iph + ihl);
 	auth_data = ah_tmp_auth(seqhi, seqhi_len);
-	icv = ah_tmp_icv(ahash, auth_data, ahp->icv_trunc_len);
+	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;


