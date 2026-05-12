Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137AB25FA29;
	Tue, 12 May 2026 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609082; cv=none; b=HFTTDsBsojdLjeCn5LxZuU7dgfBIcAPmUtT0Uw6guF2Zqj3/Rn1L78TyZy5AwyPA7SbHPexPe8CdtocJNvd6p3ro+Up9C99q+kEskLglL3qyVw36ulEw6Fz8ICcpw9wEbYyZ/3Qx4LeJF45l7e9ud21eeIV9ylMdqr0mK1zMoV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609082; c=relaxed/simple;
	bh=TWZJtv2RW3U+QS8sDJRbdo9eG8YUfoMYovLKMXx8nmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxWTwc/wvKQA1Wgs9S6KBFbmxRhp7EQH7S+Kt/OX1xKG+JfKyDZUVd3bcvlSOH75458v19FayJG7l9s+8/GvYjMxHs6a8e9pNuU5tc73nA+h9AgUvIu39yBx3QawrvDfva6GJOwPGQDdvpdUnB4o9GphZpMcu5LM6X46cFA+yow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJGNJygr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJGNJygr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED10C2BCB0;
	Tue, 12 May 2026 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609082;
	bh=TWZJtv2RW3U+QS8sDJRbdo9eG8YUfoMYovLKMXx8nmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJGNJygrZVy/NqJ6hCnbIkNSyoERJH2e1NFD7nmhDeCvaUAo1trjONndz2BLWKxL2
	 lVxet2imscscrYh5hsh770lex9CHCuEVMaQvl10TSm3xyJRNkCNmKIXvQdtLBamtiE
	 9TxtfI/dxlohXr8Q/RhcCorwwARoLmbzZG+oiCMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.0 057/307] xfrm: ah: account for ESN high bits in async callbacks
Date: Tue, 12 May 2026 19:37:32 +0200
Message-ID: <20260512173941.327288972@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit ec54093e6a8f87e800bb6aa15eb7fc1e33faa524 upstream.

AH allocates its temporary auth/ICV layout differently when ESN is enabled:
the async ahash setup appends a 4-byte seqhi slot before the ICV or
auth_data area, but the async completion callbacks still reconstruct the
temporary layout as if seqhi were absent.

With an async AH implementation selected, that makes AH copy or compare
the wrong bytes on both the IPv4 and IPv6 paths. In UML repro on IPv4 AH
with ESN and forced async hmac(sha1), ping fails with 100% packet loss,
and the callback logs show the pre-fix drift:

  ah4 output_done: esn=1 err=0 icv_off=20 expected_off=24
  ah4 input_done: esn=1 auth_off=20 expected_auth_off=24 icv_off=32 expected_icv_off=36

Reconstruct the callback-side layout the same way the setup path built it
by skipping the ESN seqhi slot before locating the saved auth_data or ICV.
Per RFC 4302, the ESN high-order 32 bits participate in the AH ICV
computation, so the async callbacks must account for the seqhi slot.

Post-fix, the same IPv4 AH+ESN+forced-async-hmac(sha1) UML repro shows
the corrected offset (ah4 output_done: esn=1 err=0 icv_off=24
expected_off=24) and ping succeeds; net/ipv4/ah4.o and net/ipv6/ah6.o
build clean at W=1. IPv6 AH+ESN was not exercised at runtime, and the
change has not been tested against a real async hardware AH engine.

Fixes: d4d573d0334d ("{IPv4,xfrm} Add ESN support for AH egress part")
Fixes: d8b2a8600b0e ("{IPv4,xfrm} Add ESN support for AH ingress part")
Fixes: 26dd70c3fad3 ("{IPv6,xfrm} Add ESN support for AH egress part")
Fixes: 8d6da6f32557 ("{IPv6,xfrm} Add ESN support for AH ingress part")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5-4
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ah4.c |   14 ++++++++++++--
 net/ipv6/ah6.c |   14 ++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -124,9 +124,14 @@ static void ah_output_done(void *data, i
 	struct iphdr *top_iph = ip_hdr(skb);
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	int ihl = ip_hdrlen(skb);
+	int seqhi_len = 0;
+	__be32 *seqhi;
 
+	if (x->props.flags & XFRM_STATE_ESN)
+		seqhi_len = sizeof(*seqhi);
 	iph = AH_SKB_CB(skb)->tmp;
-	icv = ah_tmp_icv(iph, ihl);
+	seqhi = (__be32 *)((char *)iph + ihl);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 
 	top_iph->tos = iph->tos;
@@ -270,12 +275,17 @@ static void ah_input_done(void *data, in
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	int ihl = ip_hdrlen(skb);
 	int ah_hlen = (ah->hdrlen + 2) << 2;
+	int seqhi_len = 0;
+	__be32 *seqhi;
 
 	if (err)
 		goto out;
 
+	if (x->props.flags & XFRM_STATE_ESN)
+		seqhi_len = sizeof(*seqhi);
 	work_iph = AH_SKB_CB(skb)->tmp;
-	auth_data = ah_tmp_auth(work_iph, ihl);
+	seqhi = (__be32 *)((char *)work_iph + ihl);
+	auth_data = ah_tmp_auth(seqhi, seqhi_len);
 	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
 
 	err = crypto_memneq(icv, auth_data, ahp->icv_trunc_len) ? -EBADMSG : 0;
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -317,14 +317,19 @@ static void ah6_output_done(void *data,
 	struct ipv6hdr *top_iph = ipv6_hdr(skb);
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	struct tmp_ext *iph_ext;
+	int seqhi_len = 0;
+	__be32 *seqhi;
 
 	extlen = skb_network_header_len(skb) - sizeof(struct ipv6hdr);
 	if (extlen)
 		extlen += sizeof(*iph_ext);
 
+	if (x->props.flags & XFRM_STATE_ESN)
+		seqhi_len = sizeof(*seqhi);
 	iph_base = AH_SKB_CB(skb)->tmp;
 	iph_ext = ah_tmp_ext(iph_base);
-	icv = ah_tmp_icv(iph_ext, extlen);
+	seqhi = (__be32 *)((char *)iph_ext + extlen);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 	memcpy(top_iph, iph_base, IPV6HDR_BASELEN);
@@ -471,13 +476,18 @@ static void ah6_input_done(void *data, i
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	int hdr_len = skb_network_header_len(skb);
 	int ah_hlen = ipv6_authlen(ah);
+	int seqhi_len = 0;
+	__be32 *seqhi;
 
 	if (err)
 		goto out;
 
+	if (x->props.flags & XFRM_STATE_ESN)
+		seqhi_len = sizeof(*seqhi);
 	work_iph = AH_SKB_CB(skb)->tmp;
 	auth_data = ah_tmp_auth(work_iph, hdr_len);
-	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
+	seqhi = (__be32 *)(auth_data + ahp->icv_trunc_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 
 	err = crypto_memneq(icv, auth_data, ahp->icv_trunc_len) ? -EBADMSG : 0;
 	if (err)


