Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102E61EFF93;
	Mon, 17 Aug 2026 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979581; cv=none; b=fhnMESlY7XNaOn6TNLMvhpVANJNER6ttZkuOZ3d2OBND0pJaImaE+724Bg8L1eUjBww3VlHY81yJPttqRnN6gk3kqW2f94j0oybat3Hyt78NDy2UeURE0hjnxSfguudQ9dQ9CoerVA0k0MJVdqhUEmUq+1evzMLqvZB3a/CYzCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979581; c=relaxed/simple;
	bh=/TszUldfTNMzukXWFv78q6d3KN9x0+Qcq4Ga/kjAy6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dqyj5pRJHGdpjM+JQgeYZ0bayU/jnQZHeenUTGFvY4paxw07qbgXxc7sazD6ObYAgj08Fzk1sDaelO10OXpHBBM2kz1IoXFGBF2zeQ7fl98fnt0UwPgXe2SJtFy0Lxw9unjakgQdJLNjDekTxvY8MUnqrwg6PCMRJLSrA3+E5GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmzIrWEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmzIrWEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1CD1F000E9;
	Mon, 17 Aug 2026 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979579;
	bh=Z9GCFhRU93eSRr1CBvu87XEuLxOA/1Rz56UVeK5vmbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmzIrWEgX7ZxPDTQ1bUtEmbml43q1PzZZVgeBSJJYJX+0E3zeogy1xcaP3fdBGP5w
	 7TGztcStHdkNJgrfAAt1MXO0El1n+mz6rGp5tT7o/HOF/DPiuv1u2zpHqLm9v+95Xz
	 49OA5vaO+Kui4buOj2c6vKB49TtyJF0vjjJneFSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 273/609] ila: reload IPv6 header after pskb_may_pull in checksum adjust
Date: Mon, 17 Aug 2026 15:29:29 +0200
Message-ID: <20260817132553.275392497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


