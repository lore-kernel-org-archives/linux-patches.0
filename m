Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059788;
	b=HD6RIhjovULiluiVasKUG/1F0qMiGeL+kjheRz0tGMitFzo9JwXvDMEb8wXc8VwveEac
	 Cduwzt5LSlggt1lq/wvauGPbn5aBnPlfW78jJACV+4PhDpT8FDxtq4jnTE3xSmnBNH9O8
	 NMu/ATFyxUDVyaQbDZOQo3L/30rK21qSh0Nli+yQJEWkz5GQRZ6tDUjJBi80XLp3xQv/P
	 7bfbpQet1LTjCYn46EUe5jm2oVqF+H0t4b60j6aWcyXGjftXrhnrx1Eux3VuF0c8CiMSt
	 Mw02MzaObndX8Mh+jN1PchEWBQAtIN66JOaU7nNxYlvi+HeerNyh+JiUTM1iMROEWtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0dSB5G1qEN21qYqBy4KmGVT7shnZSyPcrgyO3jtGHx8=;
	b=gCKjvEkpQmh5ppdDzpqleT3UgzaV9YehsfVj+a4sPhc8oAuLcs23hLhhNh648dafNn4+
	 tKl9EAMREg14iUjqlXSNG0uN+Nt+F8CYEWuglNFvEG2whNB7dnYITyZlzx+LWcdklysAA
	 F92OBZeApDtijqGFnPpQE0qaQv4SUnV9wHXZOstYMAqBtGOc6AwSk0DLre6EH+J0R14WL
	 BrJ81QtESdYsWtWQgAEbEIVF+QY9SGIiivEXZqhF6NHn+lnygYLt2X5iO58PXgC4FCgGB
	 rgtEds3jFMD6macYDXi1MCI+RUpL+KNhufpA4TvcVG5mLjD5ATBeZgNPD3S1G5F01jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3j7arUC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67583606A320;
	Thu, 19 Nov 2026 03:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3j7arUC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDC91F000C5;
	Thu, 19 Nov 2026 03:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059788;
	bh=0dSB5G1qEN21qYqBy4KmGVT7shnZSyPcrgyO3jtGHx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3j7arUCI8ELhzezC9VWqY9b8BnttabifM+TehDuZdyWfEJli0KK768D6BCQM8Lqr
	 pLrtWNeZkI38S7ZFnLtoVcKpdCUyuIyM9XFaCuVrdkI1LqXcvLP2skM9ztsMEEn18Q
	 4BPIgHPgNQJQ90WhuL0m0iLXQVun66p5AX2oJ77Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0966/1848] ip6mr: fix use-after-free in ip6mr_sk_done()
Date: Wed, 18 Nov 2026 15:50:04 +0100
Message-ID: <20261118145957.400897191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7d9b1b578d67a14ae7a7a526ee115b233fa264c4 ]

Apparently addrconf_exit_net() is called before igmp6_net_exit()
and ndisc_net_exit() at netns dismantle time:

 net_namespace: call ip6table_mangle_net_exit()
 net_namespace: call ip6_tables_net_exit()
 net_namespace: call ipv6_sysctl_net_exit()
 net_namespace: call ioam6_net_exit()
 net_namespace: call seg6_net_exit()
 net_namespace: call ping_v6_proc_exit_net()
 net_namespace: call tcpv6_net_exit()
 ip6mr_sk_done sk=ffffa354c78a74c0
 net_namespace: call ipv6_frags_exit_net()
 net_namespace: call addrconf_exit_net()
 net_namespace: call ip6addrlbl_net_exit()
 net_namespace: call ip6_flowlabel_net_exit()
 net_namespace: call ip6_route_net_exit_late()
 net_namespace: call fib6_rules_net_exit()
 net_namespace: call xfrm6_net_exit()
 net_namespace: call fib6_net_exit()
 net_namespace: call ip6_route_net_exit()
 net_namespace: call ipv6_inetpeer_exit()
 net_namespace: call if6_proc_net_exit()
 net_namespace: call ipv6_proc_exit_net()
 net_namespace: call udplite6_proc_exit_net()
 net_namespace: call raw6_exit_net()
 net_namespace: call igmp6_net_exit()
 ip6mr_sk_done sk=ffffa35472b2a180
 ip6mr_sk_done sk=ffffa354c78a7980
 net_namespace: call ndisc_net_exit()
 ip6mr_sk_done sk=ffffa35472b2ab00
 net_namespace: call ip6mr_net_exit()
 net_namespace: call inet6_net_exit()

This was fine because ip6mr_sk_done() would not reach the point decreasing
net->ipv6.devconf_all->mc_forwarding until my patch in ip6mr_sk_done().

To fix this without changing struct pernet_operations ordering,
we can clear net->ipv6.devconf_dflt and net->ipv6.devconf_all
when they are freed from addrconf_exit_net()

BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in ip6mr_sk_done+0x11b/0x410 net/ipv6/ip6mr.c:1578
Read of size 4 at addr ffff88801ff08688 by task kworker/u4:4/963

CPU: 0 PID: 963 Comm: kworker/u4:4 Not tainted 5.17.0-rc2-syzkaller-00650-g5a8fb33e5305 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 ip6mr_sk_done+0x11b/0x410 net/ipv6/ip6mr.c:1578
 rawv6_close+0x58/0x80 net/ipv6/raw.c:1201
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:478
 __sock_release net/socket.c:650 [inline]
 sock_release+0x87/0x1b0 net/socket.c:678
 inet_ctl_sock_destroy include/net/inet_common.h:65 [inline]
 igmp6_net_exit+0x6b/0x170 net/ipv6/mcast.c:3173
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:600
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Fixes: f2f2325ec799 ("ip6mr: ip6mr_sk_done() can exit early in common cases")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6ace56ed7b13 ("ipv6: remove ifaddr from hash during ifdown list cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 net/ipv6/ip6mr.c    | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 0e45127b14cdd..8daa9f564eec7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7188,7 +7188,9 @@ static void __net_exit addrconf_exit_net(struct net *net)
 				     NETCONFA_IFINDEX_ALL);
 #endif
 	kfree(net->ipv6.devconf_dflt);
+	net->ipv6.devconf_dflt = NULL;
 	kfree(net->ipv6.devconf_all);
+	net->ipv6.devconf_all = NULL;
 }
 
 static struct pernet_operations addrconf_ops = {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 555f806b10cb0..40b794cdb5a4e 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1573,15 +1573,17 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 
 int ip6mr_sk_done(struct sock *sk)
 {
-	int err = -EACCES;
 	struct net *net = sock_net(sk);
+	struct ipv6_devconf *devconf;
 	struct mr_table *mrt;
+	int err = -EACCES;
 
 	if (sk->sk_type != SOCK_RAW ||
 	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
 		return err;
 
-	if (!atomic_read(&net->ipv6.devconf_all->mc_forwarding))
+	devconf = net->ipv6.devconf_all;
+	if (!devconf || !atomic_read(&devconf->mc_forwarding))
 		return err;
 
 	rtnl_lock();
@@ -1593,7 +1595,7 @@ int ip6mr_sk_done(struct sock *sk)
 			 * so the RCU grace period before sk freeing
 			 * is guaranteed by sk_destruct()
 			 */
-			atomic_dec(&net->ipv6.devconf_all->mc_forwarding);
+			atomic_dec(&devconf->mc_forwarding);
 			write_unlock_bh(&mrt_lock);
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_MC_FORWARDING,
-- 
2.53.0



