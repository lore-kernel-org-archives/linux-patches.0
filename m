Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F59446070;
	Thu, 30 Jul 2026 16:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428014; cv=none; b=ldPG5Wg1UI9i7zH+yttbfZ5WHToMQHM63mox1o21O6MeGuTWAymAO+0xM7OeHckRU5MXRJnmtbPj86PfZfBrCXhbwo7aTRB8PI1LH3J5HjU8T9mC7qwiHD9ZkzhaA/MIMQcxJOfs7Hf8rDMZ3mRhlN5xrTu3ObeH99gzyh5KiGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428014; c=relaxed/simple;
	bh=TaQdOYCXmRudO6+Qt/XVWSkMTSnQiJk3SakrLM74LcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8vn8IqPbplH/dl1irvMw/SrwpccEYkf+8EkEhT0cxPMyY/efeO7NghWcGu4cmk3wLIk5g04m9XtImvQcA6o84g56pHn41+0TUXJ9SLLU4klYVUhA89/2DY2AdtIRCflCq6mfmYpBGGJSWPJprm+T74KwDByTyBPgCeGSs6A6tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX2u781t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX2u781t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1468C1F000E9;
	Thu, 30 Jul 2026 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428013;
	bh=bREO9k+OOkgeW1zRXK7Vm0o8tS6A3KN2i5QFB0TN01I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RX2u781teNUL3HVNtCp3IxNKHumaZo7U+48EqrXh/g4bowPQdVdSsAS1xggTCuiRL
	 kzn0+AmV5vfj/8Mv7dly6XaT51AOzI42BW3k9co1X76fPbFkHgHaHr3bgNb6Vq9iD1
	 AjobH9tGo92DnouksaiSB10yk6+XkFa4UCmeHeBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 329/484] ila: reload IPv6 header after pskb_may_pull in checksum adjust
Date: Thu, 30 Jul 2026 16:13:46 +0200
Message-ID: <20260730141430.633292295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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


