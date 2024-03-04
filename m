Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472E51F92C;
	Mon,  4 Mar 2024 21:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588453; cv=none; b=CUf0nJaDpPoh+f7lXy+wRqVZKjTZVWVh37hO6/UzP0vJZ1ffjPVJegQuXBM76jDwe4d90YAnEmkb2tBoHFiV/2Th3H9JDZu1gbTOeS4fjqs0ui49JwpmfxvZoB2VqWfrq4GThIvBuUvqfEM7fELZY0BktGxiHaoU2xuObyABAkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588453; c=relaxed/simple;
	bh=Z0pPBS8gFSQh9ruJpjaIFAdv/BOKayL8MsTJZ1ZE2tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8TvJbECus8e3ro4sRYgEfHyKRkpVg90l2iA/ncsVC7qdEnuR3x038ke4xloz8Hd/rrEIG0xIwvlwFxAMNPAz2PhX+f8r7Gow4/oPuAHL91XmP9dZfi3tkSCudTbcBQ9ej23UKBSIUl0sXtPz+oNx+VJ/SaZ4t0fDAbW2Ell+c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeC6I7Ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeC6I7Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5598C433C7;
	Mon,  4 Mar 2024 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588453;
	bh=Z0pPBS8gFSQh9ruJpjaIFAdv/BOKayL8MsTJZ1ZE2tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeC6I7KuLEYmKLCxwKH5aoKQpiijUIbdUqy9pjzRjK4UeAnx1x7Tb7g6Ape3v0nxP
	 UR4SpBl/r7w255pBpxaN4o0/dXqB9+7JN1EwJayxomNHREkB5MwL3yOkQ6bzZfM/8S
	 GgFNm0C9+x53+ASlapj8oxnIeO9+9Vglr9tJK/y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 113/143] mptcp: fix possible deadlock in subflow diag
Date: Mon,  4 Mar 2024 21:23:53 +0000
Message-ID: <20240304211553.531938323@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit d6a9608af9a75d13243d217f6ce1e30e57d56ffe upstream.

Syzbot and Eric reported a lockdep splat in the subflow diag:

   WARNING: possible circular locking dependency detected
   6.8.0-rc4-syzkaller-00212-g40b9385dd8e6 #0 Not tainted

   syz-executor.2/24141 is trying to acquire lock:
   ffff888045870130 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at:
   tcp_diag_put_ulp net/ipv4/tcp_diag.c:100 [inline]
   ffff888045870130 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at:
   tcp_diag_get_aux+0x738/0x830 net/ipv4/tcp_diag.c:137

   but task is already holding lock:
   ffffc9000135e488 (&h->lhash2[i].lock){+.+.}-{2:2}, at: spin_lock
   include/linux/spinlock.h:351 [inline]
   ffffc9000135e488 (&h->lhash2[i].lock){+.+.}-{2:2}, at:
   inet_diag_dump_icsk+0x39f/0x1f80 net/ipv4/inet_diag.c:1038

   which lock already depends on the new lock.

   the existing dependency chain (in reverse order) is:

   -> #1 (&h->lhash2[i].lock){+.+.}-{2:2}:
   lock_acquire+0x1e3/0x530 kernel/locking/lockdep.c:5754
   __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
   spin_lock include/linux/spinlock.h:351 [inline]
   __inet_hash+0x335/0xbe0 net/ipv4/inet_hashtables.c:743
   inet_csk_listen_start+0x23a/0x320 net/ipv4/inet_connection_sock.c:1261
   __inet_listen_sk+0x2a2/0x770 net/ipv4/af_inet.c:217
   inet_listen+0xa3/0x110 net/ipv4/af_inet.c:239
   rds_tcp_listen_init+0x3fd/0x5a0 net/rds/tcp_listen.c:316
   rds_tcp_init_net+0x141/0x320 net/rds/tcp.c:577
   ops_init+0x352/0x610 net/core/net_namespace.c:136
   __register_pernet_operations net/core/net_namespace.c:1214 [inline]
   register_pernet_operations+0x2cb/0x660 net/core/net_namespace.c:1283
   register_pernet_device+0x33/0x80 net/core/net_namespace.c:1370
   rds_tcp_init+0x62/0xd0 net/rds/tcp.c:735
   do_one_initcall+0x238/0x830 init/main.c:1236
   do_initcall_level+0x157/0x210 init/main.c:1298
   do_initcalls+0x3f/0x80 init/main.c:1314
   kernel_init_freeable+0x42f/0x5d0 init/main.c:1551
   kernel_init+0x1d/0x2a0 init/main.c:1441
   ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
   ret_from_fork_asm+0x1b/0x30 arch/x86/entry/entry_64.S:242

   -> #0 (k-sk_lock-AF_INET6){+.+.}-{0:0}:
   check_prev_add kernel/locking/lockdep.c:3134 [inline]
   check_prevs_add kernel/locking/lockdep.c:3253 [inline]
   validate_chain+0x18ca/0x58e0 kernel/locking/lockdep.c:3869
   __lock_acquire+0x1345/0x1fd0 kernel/locking/lockdep.c:5137
   lock_acquire+0x1e3/0x530 kernel/locking/lockdep.c:5754
   lock_sock_fast include/net/sock.h:1723 [inline]
   subflow_get_info+0x166/0xd20 net/mptcp/diag.c:28
   tcp_diag_put_ulp net/ipv4/tcp_diag.c:100 [inline]
   tcp_diag_get_aux+0x738/0x830 net/ipv4/tcp_diag.c:137
   inet_sk_diag_fill+0x10ed/0x1e00 net/ipv4/inet_diag.c:345
   inet_diag_dump_icsk+0x55b/0x1f80 net/ipv4/inet_diag.c:1061
   __inet_diag_dump+0x211/0x3a0 net/ipv4/inet_diag.c:1263
   inet_diag_dump_compat+0x1c1/0x2d0 net/ipv4/inet_diag.c:1371
   netlink_dump+0x59b/0xc80 net/netlink/af_netlink.c:2264
   __netlink_dump_start+0x5df/0x790 net/netlink/af_netlink.c:2370
   netlink_dump_start include/linux/netlink.h:338 [inline]
   inet_diag_rcv_msg_compat+0x209/0x4c0 net/ipv4/inet_diag.c:1405
   sock_diag_rcv_msg+0xe7/0x410
   netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2543
   sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:280
   netlink_unicast_kernel net/netlink/af_netlink.c:1341 [inline]
   netlink_unicast+0x7ea/0x980 net/netlink/af_netlink.c:1367
   netlink_sendmsg+0xa3b/0xd70 net/netlink/af_netlink.c:1908
   sock_sendmsg_nosec net/socket.c:730 [inline]
   __sock_sendmsg+0x221/0x270 net/socket.c:745
   ____sys_sendmsg+0x525/0x7d0 net/socket.c:2584
   ___sys_sendmsg net/socket.c:2638 [inline]
   __sys_sendmsg+0x2b0/0x3a0 net/socket.c:2667
   do_syscall_64+0xf9/0x240
   entry_SYSCALL_64_after_hwframe+0x6f/0x77

As noted by Eric we can break the lock dependency chain avoid
dumping any extended info for the mptcp subflow listener:
nothing actually useful is presented there.

Fixes: b8adb69a7d29 ("mptcp: fix lockless access in subflow ULP diag")
Cc: stable@vger.kernel.org
Reported-by: Eric Dumazet <edumazet@google.com>
Closes: https://lore.kernel.org/netdev/CANn89iJ=Oecw6OZDwmSYc9HJKQ_G32uN11L+oUcMu+TOD5Xiaw@mail.gmail.com/
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-9-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/diag.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/diag.c
+++ b/net/mptcp/diag.c
@@ -21,6 +21,9 @@ static int subflow_get_info(struct sock
 	bool slow;
 	int err;
 
+	if (inet_sk_state_load(sk) == TCP_LISTEN)
+		return 0;
+
 	start = nla_nest_start_noflag(skb, INET_ULP_INFO_MPTCP);
 	if (!start)
 		return -EMSGSIZE;


