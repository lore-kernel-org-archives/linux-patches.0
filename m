Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C37131E0F2;
	Mon, 27 Oct 2025 19:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592948; cv=none; b=B9W46m9t2LFKEOFM7LC4EsKu0Y8vh+exqkHl0HUH/hKo9ScHCutYmVStv7R7hIXa01v/B9Vt7VOPDQHWOvSTSfgoqHC1TGZ9g0zxiiJzadeBiGastrsQN2XJIKAUoL0Z7X5Zb7QjBosuqFmFbiMj5+Ovjh7BNxCJsYHjjlyd4RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592948; c=relaxed/simple;
	bh=jdpCuNrxVIpVNhaw3Esw95mRfL5wYfvYX2MtJrOl8AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIhGEPuuw0T2G2i6ltOo78RxP/CkGGoll2gOXoEauPY8wbJgwlNpcfBd1FkSK8PbK4kRR745NfnU67skN+6Ay/Ny0gIh6/WA9mWBxo6saBM6a5b7BrPbldYHaoEzqMC72Sc49Vy5e9JpARt+vG5E0/2/1mTlwDFLyJOxl0N7CmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxJwhZsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxJwhZsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6041C4CEF1;
	Mon, 27 Oct 2025 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592948;
	bh=jdpCuNrxVIpVNhaw3Esw95mRfL5wYfvYX2MtJrOl8AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxJwhZsNNOiOO29UVWxDd08XKgXcIwYWtTD/g8X4DYNQVXa8yLhvPIMoSxpXrZ4SC
	 OkqZiFvlzHMfmXzWNN7vhSy01kVX2hf7ScnqywjJeH/Z+S8kTDX2RPOLBS80mjvWSj
	 c0XCzikBdz8mezl8jPkitS1m04hHSwuBOXJ7GVdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f775be4458668f7d220e@syzkaller.appspotmail.com,
	Wang Liang <wangliang74@huawei.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/117] net/smc: fix general protection fault in __smc_diag_dump
Date: Mon, 27 Oct 2025 19:36:03 +0100
Message-ID: <20251027183454.980492985@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit f584239a9ed25057496bf397c370cc5163dde419 ]

The syzbot report a crash:

  Oops: general protection fault, probably for non-canonical address 0xfbd5a5d5a0000003: 0000 [#1] SMP KASAN NOPTI
  KASAN: maybe wild-memory-access in range [0xdead4ead00000018-0xdead4ead0000001f]
  CPU: 1 UID: 0 PID: 6949 Comm: syz.0.335 Not tainted syzkaller #0 PREEMPT(full)
  Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
  RIP: 0010:smc_diag_msg_common_fill net/smc/smc_diag.c:44 [inline]
  RIP: 0010:__smc_diag_dump.constprop.0+0x3ca/0x2550 net/smc/smc_diag.c:89
  Call Trace:
   <TASK>
   smc_diag_dump_proto+0x26d/0x420 net/smc/smc_diag.c:217
   smc_diag_dump+0x27/0x90 net/smc/smc_diag.c:234
   netlink_dump+0x539/0xd30 net/netlink/af_netlink.c:2327
   __netlink_dump_start+0x6d6/0x990 net/netlink/af_netlink.c:2442
   netlink_dump_start include/linux/netlink.h:341 [inline]
   smc_diag_handler_dump+0x1f9/0x240 net/smc/smc_diag.c:251
   __sock_diag_cmd net/core/sock_diag.c:249 [inline]
   sock_diag_rcv_msg+0x438/0x790 net/core/sock_diag.c:285
   netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2552
   netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
   netlink_unicast+0x5a7/0x870 net/netlink/af_netlink.c:1346
   netlink_sendmsg+0x8d1/0xdd0 net/netlink/af_netlink.c:1896
   sock_sendmsg_nosec net/socket.c:714 [inline]
   __sock_sendmsg net/socket.c:729 [inline]
   ____sys_sendmsg+0xa95/0xc70 net/socket.c:2614
   ___sys_sendmsg+0x134/0x1d0 net/socket.c:2668
   __sys_sendmsg+0x16d/0x220 net/socket.c:2700
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xcd/0x4e0 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

The process like this:

               (CPU1)              |             (CPU2)
  ---------------------------------|-------------------------------
  inet_create()                    |
    // init clcsock to NULL        |
    sk = sk_alloc()                |
                                   |
    // unexpectedly change clcsock |
    inet_init_csk_locks()          |
                                   |
    // add sk to hash table        |
    smc_inet_init_sock()           |
      smc_sk_init()                |
        smc_hash_sk()              |
                                   | // traverse the hash table
                                   | smc_diag_dump_proto
                                   |   __smc_diag_dump()
                                   |     // visit wrong clcsock
                                   |     smc_diag_msg_common_fill()
    // alloc clcsock               |
    smc_create_clcsk               |
      sock_create_kern             |

With CONFIG_DEBUG_LOCK_ALLOC=y, the smc->clcsock is unexpectedly changed
in inet_init_csk_locks(). The INET_PROTOSW_ICSK flag is no need by smc,
just remove it.

After removing the INET_PROTOSW_ICSK flag, this patch alse revert
commit 6fd27ea183c2 ("net/smc: fix lacks of icsk_syn_mss with IPPROTO_SMC")
to avoid casting smc_sock to inet_connection_sock.

Reported-by: syzbot+f775be4458668f7d220e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f775be4458668f7d220e
Tested-by: syzbot+f775be4458668f7d220e@syzkaller.appspotmail.com
Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Link: https://patch.msgid.link/20251017024827.3137512-1-wangliang74@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_inet.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/smc/smc_inet.c b/net/smc/smc_inet.c
index a944e7dcb8b96..a94084b4a498e 100644
--- a/net/smc/smc_inet.c
+++ b/net/smc/smc_inet.c
@@ -56,7 +56,6 @@ static struct inet_protosw smc_inet_protosw = {
 	.protocol	= IPPROTO_SMC,
 	.prot		= &smc_inet_prot,
 	.ops		= &smc_inet_stream_ops,
-	.flags		= INET_PROTOSW_ICSK,
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -104,27 +103,15 @@ static struct inet_protosw smc_inet6_protosw = {
 	.protocol	= IPPROTO_SMC,
 	.prot		= &smc_inet6_prot,
 	.ops		= &smc_inet6_stream_ops,
-	.flags		= INET_PROTOSW_ICSK,
 };
 #endif /* CONFIG_IPV6 */
 
-static unsigned int smc_sync_mss(struct sock *sk, u32 pmtu)
-{
-	/* No need pass it through to clcsock, mss can always be set by
-	 * sock_create_kern or smc_setsockopt.
-	 */
-	return 0;
-}
-
 static int smc_inet_init_sock(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
 	/* init common smc sock */
 	smc_sk_init(net, sk, IPPROTO_SMC);
-
-	inet_csk(sk)->icsk_sync_mss = smc_sync_mss;
-
 	/* create clcsock */
 	return smc_create_clcsk(net, sk, sk->sk_family);
 }
-- 
2.51.0



