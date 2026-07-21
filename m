Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1A8472F6C;
	Tue, 21 Jul 2026 21:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667643; cv=none; b=e5LYyOR7ExiT55iq55UdgY6siDOK7BUffIEJVshzqwLPOzTtlny/MG7sH3jgsJPk2wGBTAQdS9Uof83jHzqrpK3eaII00K/7ocY1N5fkkqySycP2sEAGeBX2AeBNlMFBQ+2RJv/i6tM36UmWFi8b4Lf6tkR5hl5QhomjtosWi9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667643; c=relaxed/simple;
	bh=Ldh2b+T/8fbGfbdfhbfRtbg0YrN3K8ZXt9/HmwWuBCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4CE3oUC4okwIRrRNabBLP66TfpsdA5rqQg7DOs/0rIAkaIBvOGq8VVJ/Z9gRDCp6CfpY/7xj81ytj9qo1ZwfZ41IKrwOWrSZSec+dCorMGFAqovbxu/4g3KrCufdgcjjWgqi3jypkDHFzI34QoMt9U/zN1BapyiKYgC0YMaqwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4m2YRcy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4m2YRcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546671F00A3A;
	Tue, 21 Jul 2026 21:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667641;
	bh=crns5aA+dzxKl90+BKHBq8uxw1Xh8rJ7wL7KBU3ZeAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4m2YRcyzca2nrqb2vQCplbQKkLX+znDTYgAFZJEbquecztgHgUDxNx4cXSU2vGFW
	 GFbapjimkF2I/jtk9scQ9c/EAztwp650z6EGGK8PdcQ4tlvFP+m+NGWnYsgY8e6iws
	 /6h+9OZzHXtEeVwtptuyGh5FFOVXyrr+pcZ5aBmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.6 1137/1266] ipvs: reload ip header after head reallocation
Date: Tue, 21 Jul 2026 17:26:14 +0200
Message-ID: <20260721152507.235732604@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit a2f57827bf7c695b8c72dc4511cae8e86582369d upstream.

__ip_vs_get_out_rt() calls skb_ensure_writable() which may
reallocate skb->head.

Fixes: 8d8e20e2d7bb ("ipvs: Decrement ttl")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -707,13 +707,11 @@ int
 ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		  struct ip_vs_protocol *pp, struct ip_vs_iphdr *ipvsh)
 {
-	struct iphdr  *iph = ip_hdr(skb);
-
-	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, iph->daddr,
+	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, ip_hdr(skb)->daddr,
 			       IP_VS_RT_MODE_NON_LOCAL, NULL, ipvsh) < 0)
 		goto tx_error;
 
-	ip_send_check(iph);
+	ip_send_check(ip_hdr(skb));
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;


