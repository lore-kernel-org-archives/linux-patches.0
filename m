Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC4418026;
	Tue, 14 May 2024 11:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686496; cv=none; b=dHKDKbWIkfdSQ4uTB11j9f36641l1SXi6wnHGnpNdJZpofLe/3AxqAC2F7CQL0wCieZ1U0EEgo3BnZtZKZzSrVswuqGW/SUg7BFn0IUB1TT6H1KFhgWkOE8jAEri/8JTwqLuvrR+pdmLEi0J/bUnVZc4dl8KdUEgTQeYLYqGlIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686496; c=relaxed/simple;
	bh=2uCDugJk8xik5Et5DgHzR4yuuMpROiWvuUi0+pR5x+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwUj00ypeixUnWhVB0D8hAmr0KMR+jZg30tkL5pdClpiw3vZbuCqTLXsIG2hogSyZehoQIhZMXW9+0qwrzUzqixM1Cr73jF8GZ5BcP+Qr4MoujrkAezBXh1sqzrovg9XfZUB4MDGuqs3bPiQACmEEXhG6hEDXLd75/iq6SAMmGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWrr8U1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWrr8U1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404E9C2BD10;
	Tue, 14 May 2024 11:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686496;
	bh=2uCDugJk8xik5Et5DgHzR4yuuMpROiWvuUi0+pR5x+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWrr8U1sAgJeiwKL/wLR2gQzb12knPEZCKzaBsX9yT+PGy9/3g3p2Q2si3h9tjVIa
	 DsKxAUR+7o8CegUjL7AJCcePSUi8/DwQM+3Vt5ixf/7Tn9At5x9d6BNwLHN5sLsVOM
	 YEdqHSsEDpUwwFAhSI8OASlVhtxiwLeB3HuXmR+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/236] ipv6: fib6_rules: avoid possible NULL dereference in fib6_rule_action()
Date: Tue, 14 May 2024 12:18:41 +0200
Message-ID: <20240514101026.398336916@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d101291b2681e5ab938554e3e323f7a7ee33e3aa ]

syzbot is able to trigger the following crash [1],
caused by unsafe ip6_dst_idev() use.

Indeed ip6_dst_idev() can return NULL, and must always be checked.

[1]

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 31648 Comm: syz-executor.0 Not tainted 6.9.0-rc4-next-20240417-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
 RIP: 0010:__fib6_rule_action net/ipv6/fib6_rules.c:237 [inline]
 RIP: 0010:fib6_rule_action+0x241/0x7b0 net/ipv6/fib6_rules.c:267
Code: 02 00 00 49 8d 9f d8 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 f9 32 bf f7 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 e0 32 bf f7 4c 8b 03 48 89 ef 4c
RSP: 0018:ffffc9000fc1f2f0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1a772f98c8186700
RDX: 0000000000000003 RSI: ffffffff8bcac4e0 RDI: ffffffff8c1f9760
RBP: ffff8880673fb980 R08: ffffffff8fac15ef R09: 1ffffffff1f582bd
R10: dffffc0000000000 R11: fffffbfff1f582be R12: dffffc0000000000
R13: 0000000000000080 R14: ffff888076509000 R15: ffff88807a029a00
FS:  00007f55e82ca6c0(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31d23000 CR3: 0000000022b66000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  fib_rules_lookup+0x62c/0xdb0 net/core/fib_rules.c:317
  fib6_rule_lookup+0x1fd/0x790 net/ipv6/fib6_rules.c:108
  ip6_route_output_flags_noref net/ipv6/route.c:2637 [inline]
  ip6_route_output_flags+0x38e/0x610 net/ipv6/route.c:2649
  ip6_route_output include/net/ip6_route.h:93 [inline]
  ip6_dst_lookup_tail+0x189/0x11a0 net/ipv6/ip6_output.c:1120
  ip6_dst_lookup_flow+0xb9/0x180 net/ipv6/ip6_output.c:1250
  sctp_v6_get_dst+0x792/0x1e20 net/sctp/ipv6.c:326
  sctp_transport_route+0x12c/0x2e0 net/sctp/transport.c:455
  sctp_assoc_add_peer+0x614/0x15c0 net/sctp/associola.c:662
  sctp_connect_new_asoc+0x31d/0x6c0 net/sctp/socket.c:1099
  __sctp_connect+0x66d/0xe30 net/sctp/socket.c:1197
  sctp_connect net/sctp/socket.c:4819 [inline]
  sctp_inet_connect+0x149/0x1f0 net/sctp/socket.c:4834
  __sys_connect_file net/socket.c:2048 [inline]
  __sys_connect+0x2df/0x310 net/socket.c:2065
  __do_sys_connect net/socket.c:2075 [inline]
  __se_sys_connect net/socket.c:2072 [inline]
  __x64_sys_connect+0x7a/0x90 net/socket.c:2072
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 5e5f3f0f8013 ("[IPV6] ADDRCONF: Convert ipv6_get_saddr() to ipv6_dev_get_saddr().")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240507163145.835254-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/fib6_rules.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index be52b18e08a6b..6eeab21512ba9 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -233,8 +233,12 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
 	rt = pol_lookup_func(lookup,
 			     net, table, flp6, arg->lookup_data, flags);
 	if (rt != net->ipv6.ip6_null_entry) {
+		struct inet6_dev *idev = ip6_dst_idev(&rt->dst);
+
+		if (!idev)
+			goto again;
 		err = fib6_rule_saddr(net, rule, flags, flp6,
-				      ip6_dst_idev(&rt->dst)->dev);
+				      idev->dev);
 
 		if (err == -EAGAIN)
 			goto again;
-- 
2.43.0



