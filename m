Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7228C13B7A0;
	Tue, 27 Feb 2024 13:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041317; cv=none; b=RZn59li0SPYpNDMVdsTxA5VSH7k/4q9VRiOlLrOiCDhpeAB6XdHaREOrKZ8nkCfFHbxEHJ1Jrt3LYupLVZIht1ovqyaQUnkAt7MvUoYAi+V4eVC2e7cetSnQhJ75TG7ae6a/mOMmhLueTDbtStBQy4torBS94wM05RFW7YSe6Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041317; c=relaxed/simple;
	bh=q+K2RkcAoQldeDIhsWJ2xxtolLVdzeDgphPO1C+ln/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCg0E1oHh4K4OcVu8FxLxHjJSdOUR5KHj4cT0LvYM45+56E9bpsQqvtbCOy1YPAfPBy3jKhl9Ric2YFn0LVCYeTlFeqfWqm6yd7gdTRIrTHteExio4fas4fjw5MxefjTZsR10N+DshpL+WsWA8QG+LPVG2iCir/WZ1yxLWJicEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2X60QsYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2X60QsYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA97BC433C7;
	Tue, 27 Feb 2024 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041317;
	bh=q+K2RkcAoQldeDIhsWJ2xxtolLVdzeDgphPO1C+ln/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2X60QsYZXH/zdqpUAdzOWqrjSRitOshNZvVO7TXRPLbl3aGDmZMRp54F9cfstXxXf
	 lkzUdaZQ1a345i1b8Xv2vnsPfj/FCG58nPCVenPebC0jW06+UhQuQ+UelTBJNQWWCQ
	 NhO4Ro7hgL5O6jVOMwnZh43/a2FtOkwv1y7MPwcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 296/334] net: implement lockless setsockopt(SO_PEEK_OFF)
Date: Tue, 27 Feb 2024 14:22:34 +0100
Message-ID: <20240227131640.594841376@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 56667da7399eb19af857e30f41bea89aa6fa812c ]

syzbot reported a lockdep violation [1] involving af_unix
support of SO_PEEK_OFF.

Since SO_PEEK_OFF is inherently not thread safe (it uses a per-socket
sk_peek_off field), there is really no point to enforce a pointless
thread safety in the kernel.

After this patch :

- setsockopt(SO_PEEK_OFF) no longer acquires the socket lock.

- skb_consume_udp() no longer has to acquire the socket lock.

- af_unix no longer needs a special version of sk_set_peek_off(),
  because it does not lock u->iolock anymore.

As a followup, we could replace prot->set_peek_off to be a boolean
and avoid an indirect call, since we always use sk_set_peek_off().

[1]

WARNING: possible circular locking dependency detected
6.8.0-rc4-syzkaller-00267-g0f1dd5e91e2b #0 Not tainted

syz-executor.2/30025 is trying to acquire lock:
 ffff8880765e7d80 (&u->iolock){+.+.}-{3:3}, at: unix_set_peek_off+0x26/0xa0 net/unix/af_unix.c:789

but task is already holding lock:
 ffff8880765e7930 (sk_lock-AF_UNIX){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1691 [inline]
 ffff8880765e7930 (sk_lock-AF_UNIX){+.+.}-{0:0}, at: sockopt_lock_sock net/core/sock.c:1060 [inline]
 ffff8880765e7930 (sk_lock-AF_UNIX){+.+.}-{0:0}, at: sk_setsockopt+0xe52/0x3360 net/core/sock.c:1193

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (sk_lock-AF_UNIX){+.+.}-{0:0}:
        lock_acquire+0x1e3/0x530 kernel/locking/lockdep.c:5754
        lock_sock_nested+0x48/0x100 net/core/sock.c:3524
        lock_sock include/net/sock.h:1691 [inline]
        __unix_dgram_recvmsg+0x1275/0x12c0 net/unix/af_unix.c:2415
        sock_recvmsg_nosec+0x18e/0x1d0 net/socket.c:1046
        ____sys_recvmsg+0x3c0/0x470 net/socket.c:2801
        ___sys_recvmsg net/socket.c:2845 [inline]
        do_recvmmsg+0x474/0xae0 net/socket.c:2939
        __sys_recvmmsg net/socket.c:3018 [inline]
        __do_sys_recvmmsg net/socket.c:3041 [inline]
        __se_sys_recvmmsg net/socket.c:3034 [inline]
        __x64_sys_recvmmsg+0x199/0x250 net/socket.c:3034
       do_syscall_64+0xf9/0x240
       entry_SYSCALL_64_after_hwframe+0x6f/0x77

-> #0 (&u->iolock){+.+.}-{3:3}:
        check_prev_add kernel/locking/lockdep.c:3134 [inline]
        check_prevs_add kernel/locking/lockdep.c:3253 [inline]
        validate_chain+0x18ca/0x58e0 kernel/locking/lockdep.c:3869
        __lock_acquire+0x1345/0x1fd0 kernel/locking/lockdep.c:5137
        lock_acquire+0x1e3/0x530 kernel/locking/lockdep.c:5754
        __mutex_lock_common kernel/locking/mutex.c:608 [inline]
        __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
        unix_set_peek_off+0x26/0xa0 net/unix/af_unix.c:789
       sk_setsockopt+0x207e/0x3360
        do_sock_setsockopt+0x2fb/0x720 net/socket.c:2307
        __sys_setsockopt+0x1ad/0x250 net/socket.c:2334
        __do_sys_setsockopt net/socket.c:2343 [inline]
        __se_sys_setsockopt net/socket.c:2340 [inline]
        __x64_sys_setsockopt+0xb5/0xd0 net/socket.c:2340
       do_syscall_64+0xf9/0x240
       entry_SYSCALL_64_after_hwframe+0x6f/0x77

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(sk_lock-AF_UNIX);
                               lock(&u->iolock);
                               lock(sk_lock-AF_UNIX);
  lock(&u->iolock);

 *** DEADLOCK ***

1 lock held by syz-executor.2/30025:
  #0: ffff8880765e7930 (sk_lock-AF_UNIX){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1691 [inline]
  #0: ffff8880765e7930 (sk_lock-AF_UNIX){+.+.}-{0:0}, at: sockopt_lock_sock net/core/sock.c:1060 [inline]
  #0: ffff8880765e7930 (sk_lock-AF_UNIX){+.+.}-{0:0}, at: sk_setsockopt+0xe52/0x3360 net/core/sock.c:1193

stack backtrace:
CPU: 0 PID: 30025 Comm: syz-executor.2 Not tainted 6.8.0-rc4-syzkaller-00267-g0f1dd5e91e2b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/25/2024
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x1e7/0x2e0 lib/dump_stack.c:106
  check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2187
  check_prev_add kernel/locking/lockdep.c:3134 [inline]
  check_prevs_add kernel/locking/lockdep.c:3253 [inline]
  validate_chain+0x18ca/0x58e0 kernel/locking/lockdep.c:3869
  __lock_acquire+0x1345/0x1fd0 kernel/locking/lockdep.c:5137
  lock_acquire+0x1e3/0x530 kernel/locking/lockdep.c:5754
  __mutex_lock_common kernel/locking/mutex.c:608 [inline]
  __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
  unix_set_peek_off+0x26/0xa0 net/unix/af_unix.c:789
 sk_setsockopt+0x207e/0x3360
  do_sock_setsockopt+0x2fb/0x720 net/socket.c:2307
  __sys_setsockopt+0x1ad/0x250 net/socket.c:2334
  __do_sys_setsockopt net/socket.c:2343 [inline]
  __se_sys_setsockopt net/socket.c:2340 [inline]
  __x64_sys_setsockopt+0xb5/0xd0 net/socket.c:2340
 do_syscall_64+0xf9/0x240
 entry_SYSCALL_64_after_hwframe+0x6f/0x77
RIP: 0033:0x7f78a1c7dda9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f78a0fde0c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f78a1dac050 RCX: 00007f78a1c7dda9
RDX: 000000000000002a RSI: 0000000000000001 RDI: 0000000000000006
RBP: 00007f78a1cca47a R08: 0000000000000004 R09: 0000000000000000
R10: 0000000020000180 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007f78a1dac050 R15: 00007ffe5cd81ae8

Fixes: 859051dd165e ("bpf: Implement cgroup sockaddr hooks for unix sockets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c    | 23 +++++++++++------------
 net/ipv4/udp.c     |  7 +------
 net/unix/af_unix.c | 19 +++----------------
 3 files changed, 15 insertions(+), 34 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index e5d43a068f8ed..20160865ede9c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1192,6 +1192,17 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		 */
 		WRITE_ONCE(sk->sk_txrehash, (u8)val);
 		return 0;
+	case SO_PEEK_OFF:
+		{
+		int (*set_peek_off)(struct sock *sk, int val);
+
+		set_peek_off = READ_ONCE(sock->ops)->set_peek_off;
+		if (set_peek_off)
+			ret = set_peek_off(sk, val);
+		else
+			ret = -EOPNOTSUPP;
+		return ret;
+		}
 	}
 
 	sockopt_lock_sock(sk);
@@ -1434,18 +1445,6 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		sock_valbool_flag(sk, SOCK_WIFI_STATUS, valbool);
 		break;
 
-	case SO_PEEK_OFF:
-		{
-		int (*set_peek_off)(struct sock *sk, int val);
-
-		set_peek_off = READ_ONCE(sock->ops)->set_peek_off;
-		if (set_peek_off)
-			ret = set_peek_off(sk, val);
-		else
-			ret = -EOPNOTSUPP;
-		break;
-		}
-
 	case SO_NOFCS:
 		sock_valbool_flag(sk, SOCK_NOFCS, valbool);
 		break;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index f631b0a21af4c..e474b201900f9 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1589,12 +1589,7 @@ int udp_init_sock(struct sock *sk)
 
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
 {
-	if (unlikely(READ_ONCE(sk->sk_peek_off) >= 0)) {
-		bool slow = lock_sock_fast(sk);
-
-		sk_peek_offset_bwd(sk, len);
-		unlock_sock_fast(sk, slow);
-	}
+	sk_peek_offset_bwd(sk, len);
 
 	if (!skb_unref(skb))
 		return;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 30b178ebba60a..0748e7ea5210e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -782,19 +782,6 @@ static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_seqpacket_recvmsg(struct socket *, struct msghdr *, size_t,
 				  int);
 
-static int unix_set_peek_off(struct sock *sk, int val)
-{
-	struct unix_sock *u = unix_sk(sk);
-
-	if (mutex_lock_interruptible(&u->iolock))
-		return -EINTR;
-
-	WRITE_ONCE(sk->sk_peek_off, val);
-	mutex_unlock(&u->iolock);
-
-	return 0;
-}
-
 #ifdef CONFIG_PROC_FS
 static int unix_count_nr_fds(struct sock *sk)
 {
@@ -862,7 +849,7 @@ static const struct proto_ops unix_stream_ops = {
 	.read_skb =	unix_stream_read_skb,
 	.mmap =		sock_no_mmap,
 	.splice_read =	unix_stream_splice_read,
-	.set_peek_off =	unix_set_peek_off,
+	.set_peek_off =	sk_set_peek_off,
 	.show_fdinfo =	unix_show_fdinfo,
 };
 
@@ -886,7 +873,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.read_skb =	unix_read_skb,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
-	.set_peek_off =	unix_set_peek_off,
+	.set_peek_off =	sk_set_peek_off,
 	.show_fdinfo =	unix_show_fdinfo,
 };
 
@@ -909,7 +896,7 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.sendmsg =	unix_seqpacket_sendmsg,
 	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
-	.set_peek_off =	unix_set_peek_off,
+	.set_peek_off =	sk_set_peek_off,
 	.show_fdinfo =	unix_show_fdinfo,
 };
 
-- 
2.43.0



