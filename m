Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64B13B2B4;
	Tue, 27 Feb 2024 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043788; cv=none; b=nXuqkCgmovA9TRTGRXvYwvUa4xC6ZWZS9rHpjK9Uvc3QMLKZ+NjePqq/x5xePtdarOr/PMm4KUZUsiCKAYzFNh2f/BXWag17EF6VGhtw1dF6U2jmHhZ2rXVwaZUEtDiYwGBmzDB3WTc8Nm6OephE4tGXC/mtjNsBL3XzMunYCr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043788; c=relaxed/simple;
	bh=u7+6vDuOoU3ip1bEnNktgYXhb2cjNKsU+SwA6gkiFJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LACMXgXdZGpnRLwCoh+RRD+YUyXJ9+sLBFbPUXJSk+9QeGm7RiSR4AmJ2f2Wv0pNncz1ZNQZCW+uLPpdiwIH6Nn4tlbD90+m9P+kz8n4sKTyCCSxtAIVIfYdHzDc/VlVM6VR32CFZNRxrv8wDESzpmpcnm2Z6yHThLn/rKvfUFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Siaq4Uom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Siaq4Uom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AA6C433C7;
	Tue, 27 Feb 2024 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043788;
	bh=u7+6vDuOoU3ip1bEnNktgYXhb2cjNKsU+SwA6gkiFJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Siaq4Uom35jpUENXTBvKbHXTTmOeOFRENhsc5uRRkEiXcSXHckxf36zyxJm72bC66
	 /O2Q72cYxUgn6CchCd4A0nIPEnACuOkmaweOwoyQiLwbzmGa2ajvwIBstsoN9wTFK7
	 jIV0SfWC1BPi7zcKjY/A96Yvj5NW2COoBiKq5L44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/84] tcp: add annotations around sk->sk_shutdown accesses
Date: Tue, 27 Feb 2024 14:27:03 +0100
Message-ID: <20240227131554.044499554@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e14cadfd80d76f01bfaa1a8d745b1db19b57d6be ]

Now sk->sk_shutdown is no longer a bitfield, we can add
standard READ_ONCE()/WRITE_ONCE() annotations to silence
KCSAN reports like the following:

BUG: KCSAN: data-race in tcp_disconnect / tcp_poll

write to 0xffff88814588582c of 1 bytes by task 3404 on cpu 1:
tcp_disconnect+0x4d6/0xdb0 net/ipv4/tcp.c:3121
__inet_stream_connect+0x5dd/0x6e0 net/ipv4/af_inet.c:715
inet_stream_connect+0x48/0x70 net/ipv4/af_inet.c:727
__sys_connect_file net/socket.c:2001 [inline]
__sys_connect+0x19b/0x1b0 net/socket.c:2018
__do_sys_connect net/socket.c:2028 [inline]
__se_sys_connect net/socket.c:2025 [inline]
__x64_sys_connect+0x41/0x50 net/socket.c:2025
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88814588582c of 1 bytes by task 3374 on cpu 0:
tcp_poll+0x2e6/0x7d0 net/ipv4/tcp.c:562
sock_poll+0x253/0x270 net/socket.c:1383
vfs_poll include/linux/poll.h:88 [inline]
io_poll_check_events io_uring/poll.c:281 [inline]
io_poll_task_func+0x15a/0x820 io_uring/poll.c:333
handle_tw_list io_uring/io_uring.c:1184 [inline]
tctx_task_work+0x1fe/0x4d0 io_uring/io_uring.c:1246
task_work_run+0x123/0x160 kernel/task_work.c:179
get_signal+0xe64/0xff0 kernel/signal.c:2635
arch_do_signal_or_restart+0x89/0x2a0 arch/x86/kernel/signal.c:306
exit_to_user_mode_loop+0x6f/0xe0 kernel/entry/common.c:168
exit_to_user_mode_prepare+0x6c/0xb0 kernel/entry/common.c:204
__syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x03 -> 0x00

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c   |  2 +-
 net/ipv4/tcp.c       | 14 ++++++++------
 net/ipv4/tcp_input.c |  4 ++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index e05cdc6088507..d7ebee3c048d5 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -876,7 +876,7 @@ int inet_shutdown(struct socket *sock, int how)
 		   EPOLLHUP, even on eg. unconnected UDP sockets -- RR */
 		/* fall through */
 	default:
-		sk->sk_shutdown |= how;
+		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | how);
 		if (sk->sk_prot->shutdown)
 			sk->sk_prot->shutdown(sk, how);
 		break;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e45c09977c600..8d7933989de0e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -505,6 +505,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	__poll_t mask;
 	struct sock *sk = sock->sk;
 	const struct tcp_sock *tp = tcp_sk(sk);
+	u8 shutdown;
 	int state;
 
 	sock_poll_wait(file, sock, wait);
@@ -547,9 +548,10 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	 * NOTE. Check for TCP_CLOSE is added. The goal is to prevent
 	 * blocking on fresh not-connected or disconnected socket. --ANK
 	 */
-	if (sk->sk_shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
+	shutdown = READ_ONCE(sk->sk_shutdown);
+	if (shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
 		mask |= EPOLLHUP;
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
+	if (shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
 	/* Connected or passive Fast Open socket? */
@@ -565,7 +567,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		if (tcp_stream_is_readable(tp, target, sk))
 			mask |= EPOLLIN | EPOLLRDNORM;
 
-		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
+		if (!(shutdown & SEND_SHUTDOWN)) {
 			if (__sk_stream_is_writeable(sk, 1)) {
 				mask |= EPOLLOUT | EPOLLWRNORM;
 			} else {  /* send SIGIO later */
@@ -2357,7 +2359,7 @@ void __tcp_close(struct sock *sk, long timeout)
 	int data_was_unread = 0;
 	int state;
 
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 
 	if (sk->sk_state == TCP_LISTEN) {
 		tcp_set_state(sk, TCP_CLOSE);
@@ -2629,7 +2631,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
 		inet_reset_saddr(sk);
 
-	sk->sk_shutdown = 0;
+	WRITE_ONCE(sk->sk_shutdown, 0);
 	sock_reset_flag(sk, SOCK_DONE);
 	tp->srtt_us = 0;
 	tp->mdev_us = jiffies_to_usecs(TCP_TIMEOUT_INIT);
@@ -3905,7 +3907,7 @@ void tcp_done(struct sock *sk)
 	if (req)
 		reqsk_fastopen_remove(sk, req, false);
 
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 
 	if (!sock_flag(sk, SOCK_DEAD))
 		sk->sk_state_change(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 982fe464156a4..61243531a7f4c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4216,7 +4216,7 @@ void tcp_fin(struct sock *sk)
 
 	inet_csk_schedule_ack(sk);
 
-	sk->sk_shutdown |= RCV_SHUTDOWN;
+	WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | RCV_SHUTDOWN);
 	sock_set_flag(sk, SOCK_DONE);
 
 	switch (sk->sk_state) {
@@ -6354,7 +6354,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			break;
 
 		tcp_set_state(sk, TCP_FIN_WAIT2);
-		sk->sk_shutdown |= SEND_SHUTDOWN;
+		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | SEND_SHUTDOWN);
 
 		sk_dst_confirm(sk);
 
-- 
2.43.0



