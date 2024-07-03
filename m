Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933F31849DD;
	Wed,  3 Jul 2024 11:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005763; cv=none; b=T3wOQ5lMFaI/fL83s7M12TOHrpP4pHz9cgnJC37Io6MVd+EkfiT07sY13Q0r5B9Km93CIV+WGKwu+rk+dXDqQ20u5chKB5//tTvPfHJFy8d3wLi1/eeRA81rKvwtht05ORhjzn3GpCXFKj2mpy8heNb6SmXtTHbE2Qr1QXuTYyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005763; c=relaxed/simple;
	bh=S5XH9xDoztER84J3n793XcQP86JrGNelXmDAOb283FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaRhvJwFwQzEhtyxQ79oWujfT/rT121bbrBzIH9WZzgP4v3XEe3UUUxSb8gBd6uZM3EaqY60PW7uCfiFa1KiGnNt21/kIhWpJvPi+M1eYXctJqLUnviEiaQ9azMe5q7MJJSQm8T+EvZ83S4Ph+ZgqMkkbPhbmQ5SRK0SNybqSTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWv+j1WT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWv+j1WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5113FC2BD10;
	Wed,  3 Jul 2024 11:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005763;
	bh=S5XH9xDoztER84J3n793XcQP86JrGNelXmDAOb283FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWv+j1WTeMTvNWYwhB6e+RtXE/chw5Ac46rVnhW+3FWgumibtyeH4B3Q3xNTMzWrJ
	 h0vZ2XwC7mF+Ua3hvnzXNaRREHiePLx6svVi9odg8nNlj9RcWHGxA/OQ0uPVVHwiK7
	 48QLRhOCcbeUYMolkK7xleeSzoiKtRR8gL0Et80g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/356] ipv6: prevent possible NULL dereference in rt6_probe()
Date: Wed,  3 Jul 2024 12:38:45 +0200
Message-ID: <20240703102920.256533888@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b86762dbe19a62e785c189f313cda5b989931f37 ]

syzbot caught a NULL dereference in rt6_probe() [1]

Bail out if  __in6_dev_get() returns NULL.

[1]
Oops: general protection fault, probably for non-canonical address 0xdffffc00000000cb: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000658-0x000000000000065f]
CPU: 1 PID: 22444 Comm: syz-executor.0 Not tainted 6.10.0-rc2-syzkaller-00383-gb8481381d4e2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
 RIP: 0010:rt6_probe net/ipv6/route.c:656 [inline]
 RIP: 0010:find_match+0x8c4/0xf50 net/ipv6/route.c:758
Code: 14 fd f7 48 8b 85 38 ff ff ff 48 c7 45 b0 00 00 00 00 48 8d b8 5c 06 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 19
RSP: 0018:ffffc900034af070 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90004521000
RDX: 00000000000000cb RSI: ffffffff8990d0cd RDI: 000000000000065c
RBP: ffffc900034af150 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000002 R12: 000000000000000a
R13: 1ffff92000695e18 R14: ffff8880244a1d20 R15: 0000000000000000
FS:  00007f4844a5a6c0(0000) GS:ffff8880b9300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31b27000 CR3: 000000002d42c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  rt6_nh_find_match+0xfa/0x1a0 net/ipv6/route.c:784
  nexthop_for_each_fib6_nh+0x26d/0x4a0 net/ipv4/nexthop.c:1496
  __find_rr_leaf+0x6e7/0xe00 net/ipv6/route.c:825
  find_rr_leaf net/ipv6/route.c:853 [inline]
  rt6_select net/ipv6/route.c:897 [inline]
  fib6_table_lookup+0x57e/0xa30 net/ipv6/route.c:2195
  ip6_pol_route+0x1cd/0x1150 net/ipv6/route.c:2231
  pol_lookup_func include/net/ip6_fib.h:616 [inline]
  fib6_rule_lookup+0x386/0x720 net/ipv6/fib6_rules.c:121
  ip6_route_output_flags_noref net/ipv6/route.c:2639 [inline]
  ip6_route_output_flags+0x1d0/0x640 net/ipv6/route.c:2651
  ip6_dst_lookup_tail.constprop.0+0x961/0x1760 net/ipv6/ip6_output.c:1147
  ip6_dst_lookup_flow+0x99/0x1d0 net/ipv6/ip6_output.c:1250
  rawv6_sendmsg+0xdab/0x4340 net/ipv6/raw.c:898
  inet_sendmsg+0x119/0x140 net/ipv4/af_inet.c:853
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg net/socket.c:745 [inline]
  sock_write_iter+0x4b8/0x5c0 net/socket.c:1160
  new_sync_write fs/read_write.c:497 [inline]
  vfs_write+0x6b6/0x1140 fs/read_write.c:590
  ksys_write+0x1f8/0x260 fs/read_write.c:643
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 52e1635631b3 ("[IPV6]: ROUTE: Add router_probe_interval sysctl.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240615151454.166404-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c7ebb46d803c3..d937ee942a4fc 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -634,6 +634,8 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	rcu_read_lock_bh();
 	last_probe = READ_ONCE(fib6_nh->last_probe);
 	idev = __in6_dev_get(dev);
+	if (!idev)
+		goto out;
 	neigh = __ipv6_neigh_lookup_noref(dev, nh_gw);
 	if (neigh) {
 		if (neigh->nud_state & NUD_VALID)
-- 
2.43.0



