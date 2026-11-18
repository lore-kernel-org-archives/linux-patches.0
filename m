Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054236;
	b=BJWVem58nrbVmeI8A5Tlfo9OSyROMsi08vGdCCePWCyfj23Fgf78LGE/CrH0B28+R9GF
	 Jo+5+G2leYUSAXnztjBroIaFj1Zn+Ryvg24rS9cqloESwcFV7Zppvf1bQ7dIgPHmztEHk
	 cvbhbxtyK4Ckox9oduHrmGZy/KsPnuH3DthaO4MvXJAvx9X0OBdTjDW8obV1wBtVMrk1C
	 e32X0FsewwYRr8ocnoKzmRk3K5rFrZeMiw68njAa/vQf4EdDh0qXDYeILLxQZVBIooeNU
	 Ee1tRnfKlw8kwJjcvKnKCnKfuYWj8hKL6AWOigtFMFPmttG/20gpzw54V+sFQnlw8kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T97zEejJggxvBODQJ1YDl2+T/1GIkyRsuCxG13/ZZsM=;
	b=NJkGp+7x8Wfny4caRspvJmUpwludyURHrdRzFSQJv2ierffKD5j9h38I8eHgWNvs7hkP
	 XgpWs2QSN5UJAMbhRQbbTdlNwPEE3LhEE/HHQ+xnY2/rs8GDahegyia9QBYPY1YlQsbEo
	 WaVNI43+acicTSEzCDXucaRgxADL/afCLTsHHZsMJ9TcBhnTA6P/T4WaWLuuFMs6Ayrkc
	 Q+EaYCAZjNm4b8jRkk7IWXZ8PFAaOC1S8MyW6yBaEfCPWdhl2f+1XYerp/IzR2U9L8DXx
	 VxkHJF8XefqpBQQcQwZwtq4gan5bPr6VXRaFwsOvkYkvFYgMD2oZYae/0LLnuiIOgAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGQ4vSuc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D5606A31C;
	Thu, 19 Nov 2026 02:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGQ4vSuc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3331F000C5;
	Thu, 19 Nov 2026 02:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054236;
	bh=T97zEejJggxvBODQJ1YDl2+T/1GIkyRsuCxG13/ZZsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGQ4vSucDx3K83S0Yi2uSJcBfR422hnu3sIAoUPGYN8IxG23RtChSpsmqgVgQAefv
	 u/KJ7jDuLtygFAVcSz96aeHD24qG/79/1LAsjbDgVzs5xvs93FGfQmLiM0DIE2fiWt
	 pRD07r7zaSV5jJ4EQfUL6M5A+cr8PmKMrQg29XHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1161/2214] ip6mr: fix use-after-free in ip6mr_sk_done()
Date: Wed, 18 Nov 2026 15:47:17 +0100
Message-ID: <20261118150058.482957705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b4ad40641d249..9bfb98add9889 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7278,7 +7278,9 @@ static void __net_exit addrconf_exit_net(struct net *net)
 				     NETCONFA_IFINDEX_ALL);
 #endif
 	kfree(net->ipv6.devconf_dflt);
+	net->ipv6.devconf_dflt = NULL;
 	kfree(net->ipv6.devconf_all);
+	net->ipv6.devconf_all = NULL;
 }
 
 static struct pernet_operations addrconf_ops = {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 224bb385ef80d..851225931508a 100644
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



