Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3789442D763;
	Mon, 17 Aug 2026 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975880; cv=none; b=sXa8jM7I/741mbFHrY69Bg3Tact6Vwl8mf4tA9NG1LI5zma0SsGedhvuX1L3QtAb0NZmHQy/ulrvjbJ1zCVYNs/os6D3g/kR+P5vAtslzSVfALdhCmVz+Q5MJESRucmMXxtPocgMo5cxN4hfgmuEFG3sPmEn4f9VGyay0hyV/gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975880; c=relaxed/simple;
	bh=hjTih5ZsjEO8WSODAUNRIoeWKQ/39SzbQnp8PxgAOCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3I8pq9P8vx/oCMdyoPmmuW4lNbgZw4uK56PtVrLsa24zYj4QD03OnCdXA2IQGphwEIKsy+VJJWkFLHxCYnzHLZa4o1avoecnyGfcnexlIsn6xV1Tl8dFlsukKLjvsRY4f6ovXWX2gSCeogZ0MkgmGczrjv50rMFi70cke2VE9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nghPZZSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nghPZZSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3651F000E9;
	Mon, 17 Aug 2026 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975879;
	bh=h3GrqOrh0TmbAGBdnR61Db/7O1PHTDsIY4Cs9Mvwm3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nghPZZSjQxNDSiqszKg4q2uTdDTRNKgHI1Cj1qgHExfDLquHhS6DSNafCX+VJgFS3
	 1JbvUaOIQMfFolKSAsRJIlLpUZlLoYba3RvImxdDxl/dGFU/aPToDJnthNA0JbCwYQ
	 zPwDQU6QbRdZMJcwd2FwSz3HIKTBdxAp1OGhD60s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 179/389] ila: reload IPv6 header after pskb_may_pull in checksum adjust
Date: Mon, 17 Aug 2026 15:30:18 +0200
Message-ID: <20260817132546.169269355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 92d3817649df2b0b6a008a686c8275c88d7ef594 upstream.

ila_csum_adjust_transport() caches ip6h = ipv6_hdr(skb) before calling
pskb_may_pull(). On a non-linear skb whose transport header sits in a page
fragment, pskb_may_pull() can call __pskb_pull_tail() / pskb_expand_head()
and free the old skb head, leaving ip6h dangling; the following
get_csum_diff(ip6h, p) then reads freed memory. ila_update_ipv6_locator()
uses ip6h (and the iaddr derived from it) again after the csum-adjust
call and additionally writes the new locator through that pointer.

Impact: a remote IPv6 packet routed through a configured ILA
csum-adjust-transport route or receive-side mapping triggers a
slab-use-after-free in ila_update_ipv6_locator() (KASAN). The route or
mapping requires CAP_NET_ADMIN to configure, but trigger packets are
unauthenticated once it exists.

Reload ip6h after each pskb_may_pull() in ila_csum_adjust_transport()
before the csum-diff read. In ila_update_ipv6_locator() only the
ILA_CSUM_ADJUST_TRANSPORT case pulls the skb, so reload ip6h and iaddr in
that case alone before the destination-address write; the neutral-map
modes never pull and keep their cached pointers.

Fixes: 33f11d16142b ("ila: Create net/ipv6/ila directory")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20260714114903.3763420-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ila/ila_common.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/ipv6/ila/ila_common.c
+++ b/net/ipv6/ila/ila_common.c
@@ -84,6 +84,7 @@ static void ila_csum_adjust_transport(st
 			struct tcphdr *th = (struct tcphdr *)
 					(skb_network_header(skb) + nhoff);
 
+			ip6h = ipv6_hdr(skb);
 			diff = get_csum_diff(ip6h, p);
 			inet_proto_csum_replace_by_diff(&th->check, skb,
 							diff, true, true);
@@ -95,6 +96,7 @@ static void ila_csum_adjust_transport(st
 					(skb_network_header(skb) + nhoff);
 
 			if (uh->check || skb->ip_summed == CHECKSUM_PARTIAL) {
+				ip6h = ipv6_hdr(skb);
 				diff = get_csum_diff(ip6h, p);
 				inet_proto_csum_replace_by_diff(&uh->check, skb,
 								diff, true, true);
@@ -109,6 +111,7 @@ static void ila_csum_adjust_transport(st
 			struct icmp6hdr *ih = (struct icmp6hdr *)
 					(skb_network_header(skb) + nhoff);
 
+			ip6h = ipv6_hdr(skb);
 			diff = get_csum_diff(ip6h, p);
 			inet_proto_csum_replace_by_diff(&ih->icmp6_cksum, skb,
 							diff, true, true);
@@ -126,6 +129,15 @@ void ila_update_ipv6_locator(struct sk_b
 	switch (p->csum_mode) {
 	case ILA_CSUM_ADJUST_TRANSPORT:
 		ila_csum_adjust_transport(skb, p);
+		/*
+		 * ila_csum_adjust_transport() calls pskb_may_pull(), which can
+		 * reallocate the skb head and leave ip6h (and the iaddr derived
+		 * from it) dangling; reload both before the write below.  The
+		 * other csum modes do not pull, so their cached pointers stay
+		 * valid.
+		 */
+		ip6h = ipv6_hdr(skb);
+		iaddr = ila_a2i(&ip6h->daddr);
 		break;
 	case ILA_CSUM_NEUTRAL_MAP:
 		if (sir2ila) {


