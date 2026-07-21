Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D059D29CE9;
	Tue, 21 Jul 2026 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658525; cv=none; b=ifrupAgeVIpEAXkIp9gndKv19UKRhGdvKA8iTnqCN8d/K2TfoQqI8TKERFYsLBziGixvswyojz5T5VzZ29Vjff8VVjJUgGnP+Lq+eIh+WEbdA7WpaCk/j9+wBWOecpEbySTgThVJT1oV/UwlFkhUNKrd7hdDEmZ+NXYHsa8AcQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658525; c=relaxed/simple;
	bh=e9KLmsvjdza3EdMk0TUngCOa6i9cQP1H4feGCRjN7wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecKL3TZ5ZbBAnkrLGw+oaSiD3cCUr/svj9JdJWFyaHzZmzGYZNWFsHP2Y06PRMAgDNxNfqlWlker/4QBzk5FMz+ZeNTB/uu0HBFIrHsRdNKDAaUPEv3xRq+34YcSzIsapi3Pin8zYfxXh7QkFqzX9p26KENTf9neu7dBKyg1eWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vmz+7W3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vmz+7W3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF0F1F000E9;
	Tue, 21 Jul 2026 18:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658518;
	bh=1SmVdvtT/B+CdEmr9XSAhd+lo0NdigSk32ju8uks2CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vmz+7W3N1pghFrDBy5qHgABAq6aVtADCjfsSXo02BzeNFh/2LBSS9OEl8o3maMWuA
	 rAWFQUAYelt2bNh/5UJ9spDWn3JMCLHrt8KFJ+tnuaD7uZqX9PIjrKWPih4mpbJX1U
	 mDz29GrJN8E6whbrkUyyNW5rb/LHLrpoyPXJJOvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 1175/1611] netfilter: bridge: fix stale prevhdr pointer in br_ip6_fragment()
Date: Tue, 21 Jul 2026 17:21:31 +0200
Message-ID: <20260721152541.860751619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

commit 86f3ce81dd2b4b0aa2c3016c989a943e4b1b643d upstream.

br_ip6_fragment() gets prevhdr, a pointer into the skb head, from
ip6_find_1stfragopt(), then calls skb_checksum_help().  For a cloned skb
skb_checksum_help() reallocates the head via pskb_expand_head(), leaving
prevhdr dangling.  It is later dereferenced in ip6_frag_next(), causing a
use-after-free write.

Save prevhdr's offset before skb_checksum_help() and recompute it after,
like commit ef0efcd3bd3f ("ipv6: Fix dangling pointer when ipv6
fragment").

  BUG: KASAN: slab-use-after-free in ip6_frag_next (net/ipv6/ip6_output.c:857)
  Write of size 1 at addr ffff888013ff5016 by task exploit/141
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   ip6_frag_next (net/ipv6/ip6_output.c:857)
   br_ip6_fragment (net/ipv6/netfilter.c:212)
   nf_ct_bridge_post (net/bridge/netfilter/nf_conntrack_bridge.c:407)
   nf_hook_slow (net/netfilter/core.c:619)
   br_forward_finish (net/bridge/br_forward.c:66)
   __br_forward (net/bridge/br_forward.c:115)
   maybe_deliver (net/bridge/br_forward.c:191)
   br_flood (net/bridge/br_forward.c:245)
   br_handle_frame_finish (net/bridge/br_input.c:229)
   br_handle_frame (net/bridge/br_input.c:442)
   ...
   packet_sendmsg (net/packet/af_packet.c:3114)
   ...
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Cc: stable@vger.kernel.org
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -134,7 +134,7 @@ int br_ip6_fragment(struct net *net, str
 	ktime_t tstamp = skb->tstamp;
 	struct ip6_frag_state state;
 	u8 *prevhdr, nexthdr = 0;
-	unsigned int mtu, hlen;
+	unsigned int mtu, hlen, nexthdr_offset;
 	int hroom, err = 0;
 	__be32 frag_id;
 
@@ -143,6 +143,7 @@ int br_ip6_fragment(struct net *net, str
 		goto blackhole;
 	hlen = err;
 	nexthdr = *prevhdr;
+	nexthdr_offset = prevhdr - skb_network_header(skb);
 
 	mtu = skb->dev->mtu;
 	if (frag_max_size > mtu ||
@@ -161,6 +162,7 @@ int br_ip6_fragment(struct net *net, str
 	    (err = skb_checksum_help(skb)))
 		goto blackhole;
 
+	prevhdr = skb_network_header(skb) + nexthdr_offset;
 	hroom = LL_RESERVED_SPACE(skb->dev);
 	if (skb_has_frag_list(skb)) {
 		unsigned int first_len = skb_pagelen(skb);


