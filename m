Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5CA19DF71;
	Wed,  3 Jul 2024 10:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004303; cv=none; b=oGWC7dqm+YZ1pETdJFdtfGJtOTMNmP1VLVQucjzrL231EpHrnMu8eH2kI/Ca9yplnU9j4PKQWS7KI4HYJ+g77GqUYd28AzGlI6s+sY2SzNDltFd40zqGPP04gkZAYYxAuM4S1rBgDijXoRE7T/iMIlsMuiIUZpplXLs2ffKn6js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004303; c=relaxed/simple;
	bh=3ADJls7lJDw9+fOsix3CLG5kvm4f4MjiTTACgNWq4hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1yFucUydoTnVoLUMXrf3bG8Nnkl6zYQcbTktOZmDI2WzEPNgJM7b3Rs3hf06LY3D4GkiNajhVwXD6IfC2u1htHMX9WMIcen+/jGtf79xu8LmGZIwaJG2ZNSEjj5cdJywpuKs96HLYFtvEnSIV1V4R4aLrsqWQeqWDZIBTaA1j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GY+V8yEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GY+V8yEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA45C32781;
	Wed,  3 Jul 2024 10:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004303;
	bh=3ADJls7lJDw9+fOsix3CLG5kvm4f4MjiTTACgNWq4hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GY+V8yEo4A53RvfrJ2cKbPS3EefwDmGmDj+3j3Rn0jFZNkUUjfNzYyBh96tTRJqdW
	 dt3k/w3ncnZ6oXdkQTIP6MqwjGe1buK0+ROhtf0LAFHsM3nqBp4orhgwAW/yj60ms5
	 PcG/JiSxWRE0eFBCo6rTuoWC8omh0NDBsy1VASD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kazunori Kobayashi <kazunori.kobayashi@miraclelinux.com>
Subject: [PATCH 5.4 187/189] tcp: Fix data races around icsk->icsk_af_ops.
Date: Wed,  3 Jul 2024 12:40:48 +0200
Message-ID: <20240703102848.531637499@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 upstream.

setsockopt(IPV6_ADDRFORM) and tcp_v6_connect() change icsk->icsk_af_ops
under lock_sock(), but tcp_(get|set)sockopt() read it locklessly.  To
avoid load/store tearing, we need to add READ_ONCE() and WRITE_ONCE()
for the reads and writes.

Thanks to Eric Dumazet for providing the syzbot report:

BUG: KCSAN: data-race in tcp_setsockopt / tcp_v6_connect

write to 0xffff88813c624518 of 8 bytes by task 23936 on cpu 0:
tcp_v6_connect+0x5b3/0xce0 net/ipv6/tcp_ipv6.c:240
__inet_stream_connect+0x159/0x6d0 net/ipv4/af_inet.c:660
inet_stream_connect+0x44/0x70 net/ipv4/af_inet.c:724
__sys_connect_file net/socket.c:1976 [inline]
__sys_connect+0x197/0x1b0 net/socket.c:1993
__do_sys_connect net/socket.c:2003 [inline]
__se_sys_connect net/socket.c:2000 [inline]
__x64_sys_connect+0x3d/0x50 net/socket.c:2000
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88813c624518 of 8 bytes by task 23937 on cpu 1:
tcp_setsockopt+0x147/0x1c80 net/ipv4/tcp.c:3789
sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3585
__sys_setsockopt+0x212/0x2b0 net/socket.c:2252
__do_sys_setsockopt net/socket.c:2263 [inline]
__se_sys_setsockopt net/socket.c:2260 [inline]
__x64_sys_setsockopt+0x62/0x70 net/socket.c:2260
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0xffffffff8539af68 -> 0xffffffff8539aff8

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 23937 Comm: syz-executor.5 Not tainted
6.0.0-rc4-syzkaller-00331-g4ed9c1e971b1-dirty #0

Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 08/26/2022

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kazunori Kobayashi <kazunori.kobayashi@miraclelinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c           |   10 ++++++----
 net/ipv6/ipv6_sockglue.c |    3 ++-
 net/ipv6/tcp_ipv6.c      |    6 ++++--
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3208,8 +3208,9 @@ int tcp_setsockopt(struct sock *sk, int
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 
 	if (level != SOL_TCP)
-		return icsk->icsk_af_ops->setsockopt(sk, level, optname,
-						     optval, optlen);
+		/* Paired with WRITE_ONCE() in do_ipv6_setsockopt() and tcp_v6_connect() */
+		return READ_ONCE(icsk->icsk_af_ops)->setsockopt(sk, level, optname,
+								optval, optlen);
 	return do_tcp_setsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(tcp_setsockopt);
@@ -3733,8 +3734,9 @@ int tcp_getsockopt(struct sock *sk, int
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	if (level != SOL_TCP)
-		return icsk->icsk_af_ops->getsockopt(sk, level, optname,
-						     optval, optlen);
+		/* Paired with WRITE_ONCE() in do_ipv6_setsockopt() and tcp_v6_connect() */
+		return READ_ONCE(icsk->icsk_af_ops)->getsockopt(sk, level, optname,
+								optval, optlen);
 	return do_tcp_getsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(tcp_getsockopt);
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -224,7 +224,8 @@ static int do_ipv6_setsockopt(struct soc
 				local_bh_enable();
 				/* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
 				WRITE_ONCE(sk->sk_prot, &tcp_prot);
-				icsk->icsk_af_ops = &ipv4_specific;
+				/* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
+				WRITE_ONCE(icsk->icsk_af_ops, &ipv4_specific);
 				sk->sk_socket->ops = &inet_stream_ops;
 				sk->sk_family = PF_INET;
 				tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -236,7 +236,8 @@ static int tcp_v6_connect(struct sock *s
 		sin.sin_port = usin->sin6_port;
 		sin.sin_addr.s_addr = usin->sin6_addr.s6_addr32[3];
 
-		icsk->icsk_af_ops = &ipv6_mapped;
+		/* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
+		WRITE_ONCE(icsk->icsk_af_ops, &ipv6_mapped);
 		sk->sk_backlog_rcv = tcp_v4_do_rcv;
 #ifdef CONFIG_TCP_MD5SIG
 		tp->af_specific = &tcp_sock_ipv6_mapped_specific;
@@ -246,7 +247,8 @@ static int tcp_v6_connect(struct sock *s
 
 		if (err) {
 			icsk->icsk_ext_hdr_len = exthdrlen;
-			icsk->icsk_af_ops = &ipv6_specific;
+			/* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
+			WRITE_ONCE(icsk->icsk_af_ops, &ipv6_specific);
 			sk->sk_backlog_rcv = tcp_v6_do_rcv;
 #ifdef CONFIG_TCP_MD5SIG
 			tp->af_specific = &tcp_sock_ipv6_specific;


