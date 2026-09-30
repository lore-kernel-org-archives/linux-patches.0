Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF3C51991A;
	Wed, 30 Sep 2026 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787909; cv=none; b=ntsx8lBwFXivZnE0XbJCvbhyetebwWQ7JKH9vkEt3QqQ66y+xRTZ5BJ7lz3XW9d3gYktkDSUSWmFxiMOPxPewQSeMRt/EmLcRA/g4ppXoDCaHjFgQbNBiiOIFAdIbGQQNaQ1Sdo4lFoVdKnCg38hRjCvkRiH5FC2lVJz7Z3GDcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787909; c=relaxed/simple;
	bh=EO5gPyt5z7K59qvZfz1P43CPDilSb6Q1B0ab0iyVKU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuXdrmjSE1mtMaSMZf6eRultvMsJfL8IIlto5rpMyYVpkJSI4H1+O9HvFjUJ/1daCL7hKI8Sw8mymaOGclRqMZFrAERTXj5EBLpE+3ebITw9HiASZi5zWDBYoSaXLVJzySCbA2QRt+VLhOKRNz+0tquEEj3ejf1m6D5+zap3KnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNIwbXhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNIwbXhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E7A1F000FF;
	Wed, 30 Sep 2026 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787907;
	bh=lJIrYSK1nvUyffdMUXxcyxYsOpDAYKLFybDyZyGU5yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNIwbXhY70DPcs020T4qycrAydR5Mh3hAZTUSAAZTOpMfxT3SaB7hm47w4jYhqwSL
	 lcDgNtzxTA5KPr3gjh3VSpga9zMLEnuA+fjdMjkmEPzDQZfqL3uqpjOt1fPToPfvTl
	 n1osg6JnhUgUxsqrS/1ViOg5K/VmxYoMpZqc3bis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+459f67f4d8af8ce6@bugs.sh,
	Florian Westphal <fw@strlen.de>,
	Weiming Shi <bestswngs@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.2 350/457] netfilter: ip6t_rpfilter: reject routes without inet6_dev
Date: Wed, 30 Sep 2026 17:27:35 +0200
Message-ID: <20260930152353.566176528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 1b9b5323725e458906c7620a3bc10398b51ad954 upstream.

ip6_route_lookup() can return an error-free route whose rt6i_idev is
NULL. Lowering an external nexthop device's MTU below IPV6_MIN_MTU tears
down its inet6_dev while fib6_ifdown() leaves routes using nexthop objects
in the FIB. An unprivileged user can construct this state with rtnetlink
in a private user and network namespace, then trigger a NULL dereference
through an IPv6 rpfilter lookup:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000000
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: rpfilter_mt (net/ipv6/netfilter/ip6t_rpfilter.c:75)
  Call Trace:
  ip6t_do_table (net/ipv6/netfilter/ip6_tables.c:316)
  nf_hook_slow (net/netfilter/core.c:619)
  ipv6_rcv (net/ipv6/ip6_input.c:351)
  __netif_receive_skb_one_core (net/core/dev.c:6216)
  process_backlog (net/core/dev.c:6680)
  __napi_poll (net/core/dev.c:7739)
  net_rx_action (net/core/dev.c:7959)
  handle_softirqs (kernel/softirq.c:622)
  do_softirq.part.0 (kernel/softirq.c:523)
  __local_bh_enable_ip (kernel/softirq.c:450)
  __dev_queue_xmit (net/core/dev.c:4913)
  packet_sendmsg (net/packet/af_packet.c:3139)
  __sys_sendto (net/socket.c:2252)
  __x64_sys_sendto (net/socket.c:2259)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  Kernel panic - not syncing: Fatal exception in interrupt

Reject routes without an inet6_dev immediately after lookup. Such routes
are not eligible for reverse-path filtering, and the check protects all
later rt6i_idev dereferences.

Fixes: e26f9a480fb6 ("netfilter: add ipv6 reverse path filter match")
Reported-by: co+459f67f4d8af8ce6@bugs.sh
Closes: https://lore.kernel.org/all/VtWUkE8QzJt5CroTj2V2v3ZQ0gwbXZ7nq7I3@bugs.sh/
Suggested-by: Florian Westphal <fw@strlen.de>
Assisted-by: Claude:gpt-5
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter/ip6t_rpfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -61,7 +61,7 @@ static bool rpfilter_lookup_reverse6(str
 		fl6.flowi6_oif = dev->ifindex;
 
 	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
-	if (rt->dst.error)
+	if (rt->dst.error || !rt->rt6i_idev)
 		goto out;
 
 	if (rt->rt6i_flags & (RTF_REJECT|RTF_ANYCAST))


