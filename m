Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF482080FC;
	Thu, 12 Dec 2024 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015750; cv=none; b=TbM5FA92k5pFcJRdWjbqfVGtlztZwGSD3sZBCDkGB9z9fa3anBjPn8Z316ci5y+aKI/K5MWqrX7gT64H4MZ1+SJA6XK4OexmNE2pZXoNrKO5vNWs2TxNUlGka7+PkB5pV0ZY7Rcs3GYdtk7J2DB8WE/CRZqk0mITPVWf3LaBt/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015750; c=relaxed/simple;
	bh=ukne0p010YbibUwfjDNLVoFoijegu/vG7XiEy8EtiPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHQyvOUqdOdWmumRbDBEERcAdAZ7h5xZNKso68u0AZ0oam2h3ck6mCQ69KntBOkDuuobX4F9demtLhMnn/Yd2NSxLPOJfRL6oeb1obwVXl4s7SG2dkGIdsBNkVhWLWYFPHV4yXyNQ+71QXVe3we3lURLQvIL9MxXiDb7YgbdyGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrAurhCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrAurhCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608D6C4CECE;
	Thu, 12 Dec 2024 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015749;
	bh=ukne0p010YbibUwfjDNLVoFoijegu/vG7XiEy8EtiPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrAurhCu5+GNA4doPHCEpe08gtgilE2Ft0HMWcVDRGircz6Ha3MZd4ZpXwAJt3Qy2
	 uODHQ0uk908XG5kwQoOKuyadlY9bd8bjDDz/76yaLzlDmPNAFH7FvDWMz0Hx+2XhbN
	 MQiURt0pEyVu19GhUvUzDkdABzZ7GUr6nNmHrmuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1de74b0794c40c8eb300@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Kui-Feng Lee <thinker.li@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/466] ipv6: avoid possible NULL deref in modify_prefix_route()
Date: Thu, 12 Dec 2024 15:53:15 +0100
Message-ID: <20241212144307.723274511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a747e02430dfb3657141f99aa6b09331283fa493 ]

syzbot found a NULL deref [1] in modify_prefix_route(), caused by one
fib6_info without a fib6_table pointer set.

This can happen for net->ipv6.fib6_null_entry

[1]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 UID: 0 PID: 5837 Comm: syz-executor888 Not tainted 6.12.0-syzkaller-09567-g7eef7e306d3c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
 RIP: 0010:__lock_acquire+0xe4/0x3c40 kernel/locking/lockdep.c:5089
Code: 08 84 d2 0f 85 15 14 00 00 44 8b 0d ca 98 f5 0e 45 85 c9 0f 84 b4 0e 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 0f 85 96 2c 00 00 49 8b 04 24 48 3d a0 07 7f 93 0f 84
RSP: 0018:ffffc900035d7268 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000006 RSI: 1ffff920006bae5f RDI: 0000000000000030
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff90608e17 R11: 0000000000000001 R12: 0000000000000030
R13: ffff888036334880 R14: 0000000000000000 R15: 0000000000000000
FS:  0000555579e90380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc59cc4278 CR3: 0000000072b54000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
  _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
  spin_lock_bh include/linux/spinlock.h:356 [inline]
  modify_prefix_route+0x30b/0x8b0 net/ipv6/addrconf.c:4831
  inet6_addr_modify net/ipv6/addrconf.c:4923 [inline]
  inet6_rtm_newaddr+0x12c7/0x1ab0 net/ipv6/addrconf.c:5055
  rtnetlink_rcv_msg+0x3c7/0xea0 net/core/rtnetlink.c:6920
  netlink_rcv_skb+0x16b/0x440 net/netlink/af_netlink.c:2541
  netlink_unicast_kernel net/netlink/af_netlink.c:1321 [inline]
  netlink_unicast+0x53c/0x7f0 net/netlink/af_netlink.c:1347
  netlink_sendmsg+0x8b8/0xd70 net/netlink/af_netlink.c:1891
  sock_sendmsg_nosec net/socket.c:711 [inline]
  __sock_sendmsg net/socket.c:726 [inline]
  ____sys_sendmsg+0xaaf/0xc90 net/socket.c:2583
  ___sys_sendmsg+0x135/0x1e0 net/socket.c:2637
  __sys_sendmsg+0x16e/0x220 net/socket.c:2669
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd1dcef8b79
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc59cc4378 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd1dcef8b79
RDX: 0000000000040040 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00000000000113fd R08: 0000000000000006 R09: 0000000000000006
R10: 0000000000000006 R11: 0000000000000246 R12: 00007ffc59cc438c
R13: 431bde82d7b634db R14: 0000000000000001 R15: 0000000000000001
 </TASK>

Fixes: 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list of routes.")
Reported-by: syzbot+1de74b0794c40c8eb300@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/67461f7f.050a0220.1286eb.0021.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
CC: Kui-Feng Lee <thinker.li@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 01115e1a34cb6..f7c17388ff6aa 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4821,7 +4821,7 @@ inet6_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			      ifm->ifa_prefixlen, extack);
 }
 
-static int modify_prefix_route(struct inet6_ifaddr *ifp,
+static int modify_prefix_route(struct net *net, struct inet6_ifaddr *ifp,
 			       unsigned long expires, u32 flags,
 			       bool modify_peer)
 {
@@ -4845,7 +4845,9 @@ static int modify_prefix_route(struct inet6_ifaddr *ifp,
 				      ifp->prefix_len,
 				      ifp->rt_priority, ifp->idev->dev,
 				      expires, flags, GFP_KERNEL);
-	} else {
+		return 0;
+	}
+	if (f6i != net->ipv6.fib6_null_entry) {
 		table = f6i->fib6_table;
 		spin_lock_bh(&table->tb6_lock);
 
@@ -4858,9 +4860,8 @@ static int modify_prefix_route(struct inet6_ifaddr *ifp,
 		}
 
 		spin_unlock_bh(&table->tb6_lock);
-
-		fib6_info_release(f6i);
 	}
+	fib6_info_release(f6i);
 
 	return 0;
 }
@@ -4939,7 +4940,7 @@ static int inet6_addr_modify(struct net *net, struct inet6_ifaddr *ifp,
 		int rc = -ENOENT;
 
 		if (had_prefixroute)
-			rc = modify_prefix_route(ifp, expires, flags, false);
+			rc = modify_prefix_route(net, ifp, expires, flags, false);
 
 		/* prefix route could have been deleted; if so restore it */
 		if (rc == -ENOENT) {
@@ -4949,7 +4950,7 @@ static int inet6_addr_modify(struct net *net, struct inet6_ifaddr *ifp,
 		}
 
 		if (had_prefixroute && !ipv6_addr_any(&ifp->peer_addr))
-			rc = modify_prefix_route(ifp, expires, flags, true);
+			rc = modify_prefix_route(net, ifp, expires, flags, true);
 
 		if (rc == -ENOENT && !ipv6_addr_any(&ifp->peer_addr)) {
 			addrconf_prefix_route(&ifp->peer_addr, ifp->prefix_len,
-- 
2.43.0



