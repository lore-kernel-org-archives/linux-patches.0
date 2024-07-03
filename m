Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002B1175555;
	Wed,  3 Jul 2024 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003706; cv=none; b=MZcymDt1WPR4VXigvn+kTTnr6LKt6e6IyhmI3VoeX+HOgdGiM0Xb13tgZNA7hP/W3raPrpd2gWrBi79Qgr/qrWG8kBITO8zOdkDfqR5V7wFhjMyCrOI1l9IVEGyq8taThjg7NA+q6zDV6vpIdxqkaEC+JQ4Og8OJ6N42IxAyFKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003706; c=relaxed/simple;
	bh=8zVur7EbOExhQl78GgvGHmXuPfVGkRM+4TKcFMZPphw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QURPhgK9zGRas51JJMedWGByN0D/jK+Gp5rLvsXnZXTLFYdLi4fbmfGlDLDD5/qzr8LYAIa9XcoVwj02UrsRnVn59DUDBH825eSd8dTY3WiV/0oVFu8nqRvGkSZfDqSsBBdYaOw+stCZr5iRrr9K7POQAD54j9sIbd6kZXSc470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZvLArQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZvLArQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD9AC2BD10;
	Wed,  3 Jul 2024 10:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003705;
	bh=8zVur7EbOExhQl78GgvGHmXuPfVGkRM+4TKcFMZPphw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZvLArQGCMktFg0mUSjn6EcJ3wKnvQrt3IPiMxy9DL9PsebNP0a7Uc1r/YtJzeR0E
	 q9IAZiYv3fdJfwjX00k1U5MGijjlWYG5kQ5duBmQ1Ox3EZSKM6sB7oyVhgc21sxFpc
	 EYdLA1/36dMsD8+a9RljUJRTWAv2E6sFQbJ0I9cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kazunori Kobayashi <kazunori.kobayashi@miraclelinux.com>
Subject: [PATCH 4.19 136/139] ipv6: annotate some data-races around sk->sk_prot
Date: Wed,  3 Jul 2024 12:40:33 +0200
Message-ID: <20240703102835.569180528@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 086d49058cd8471046ae9927524708820f5fd1c7 upstream.

Changes from the original is that the applied code to inet6_sendmsg
and inet6_recvmsg is ported to inet_sendmsg and inet_recvmsg because
the same functions are shared between ipv4 and v6 in 4.19 kernel.

The original commit message is as below.

IPv6 has this hack changing sk->sk_prot when an IPv6 socket
is 'converted' to an IPv4 one with IPV6_ADDRFORM option.

This operation is only performed for TCP and UDP, knowing
their 'struct proto' for the two network families are populated
in the same way, and can not disappear while a reader
might use and dereference sk->sk_prot.

If we think about it all reads of sk->sk_prot while
either socket lock or RTNL is not acquired should be using READ_ONCE().

Also note that other layers like MPTCP, XFRM, CHELSIO_TLS also
write over sk->sk_prot.

BUG: KCSAN: data-race in inet6_recvmsg / ipv6_setsockopt

write to 0xffff8881386f7aa8 of 8 bytes by task 26932 on cpu 0:
 do_ipv6_setsockopt net/ipv6/ipv6_sockglue.c:492 [inline]
 ipv6_setsockopt+0x3758/0x3910 net/ipv6/ipv6_sockglue.c:1019
 udpv6_setsockopt+0x85/0x90 net/ipv6/udp.c:1649
 sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3489
 __sys_setsockopt+0x209/0x2a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff8881386f7aa8 of 8 bytes by task 26911 on cpu 1:
 inet6_recvmsg+0x7a/0x210 net/ipv6/af_inet6.c:659
 ____sys_recvmsg+0x16c/0x320
 ___sys_recvmsg net/socket.c:2674 [inline]
 do_recvmmsg+0x3f5/0xae0 net/socket.c:2768
 __sys_recvmmsg net/socket.c:2847 [inline]
 __do_sys_recvmmsg net/socket.c:2870 [inline]
 __se_sys_recvmmsg net/socket.c:2863 [inline]
 __x64_sys_recvmmsg+0xde/0x160 net/socket.c:2863
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffffffff85e0e980 -> 0xffffffff85e01580

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 26911 Comm: syz-executor.3 Not tainted 5.17.0-rc2-syzkaller-00316-g0457e5153e0e-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kazunori Kobayashi <kazunori.kobayashi@miraclelinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/af_inet.c       |   15 +++++++++++----
 net/ipv6/af_inet6.c      |   14 ++++++++++----
 net/ipv6/ipv6_sockglue.c |    6 ++++--
 3 files changed, 25 insertions(+), 10 deletions(-)

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -789,15 +789,19 @@ EXPORT_SYMBOL(inet_getname);
 int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 
 	sock_rps_record_flow(sk);
 
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+
 	/* We may need to bind the socket. */
-	if (!inet_sk(sk)->inet_num && !sk->sk_prot->no_autobind &&
+	if (!inet_sk(sk)->inet_num && !prot->no_autobind &&
 	    inet_autobind(sk))
 		return -EAGAIN;
 
-	return sk->sk_prot->sendmsg(sk, msg, size);
+	return prot->sendmsg(sk, msg, size);
 }
 EXPORT_SYMBOL(inet_sendmsg);
 
@@ -823,14 +827,17 @@ int inet_recvmsg(struct socket *sock, st
 		 int flags)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 	int addr_len = 0;
 	int err;
 
 	if (likely(!(flags & MSG_ERRQUEUE)))
 		sock_rps_record_flow(sk);
 
-	err = sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
-				   flags & ~MSG_DONTWAIT, &addr_len);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+	err = prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+			    flags & ~MSG_DONTWAIT, &addr_len);
 	if (err >= 0)
 		msg->msg_namelen = addr_len;
 	return err;
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -443,11 +443,14 @@ out_unlock:
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 	int err = 0;
 
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
 	/* If the socket has its own bind function then use it. */
-	if (sk->sk_prot->bind)
-		return sk->sk_prot->bind(sk, uaddr, addr_len);
+	if (prot->bind)
+		return prot->bind(sk, uaddr, addr_len);
 
 	if (addr_len < SIN6_LEN_RFC2133)
 		return -EINVAL;
@@ -558,6 +561,7 @@ int inet6_ioctl(struct socket *sock, uns
 {
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
+	const struct proto *prot;
 
 	switch (cmd) {
 	case SIOCGSTAMP:
@@ -578,9 +582,11 @@ int inet6_ioctl(struct socket *sock, uns
 	case SIOCSIFDSTADDR:
 		return addrconf_set_dstaddr(net, (void __user *) arg);
 	default:
-		if (!sk->sk_prot->ioctl)
+		/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+		prot = READ_ONCE(sk->sk_prot);
+		if (!prot->ioctl)
 			return -ENOIOCTLCMD;
-		return sk->sk_prot->ioctl(sk, cmd, arg);
+		return prot->ioctl(sk, cmd, arg);
 	}
 	/*NOTREACHED*/
 	return 0;
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -224,7 +224,8 @@ static int do_ipv6_setsockopt(struct soc
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, &tcp_prot, 1);
 				local_bh_enable();
-				sk->sk_prot = &tcp_prot;
+				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				WRITE_ONCE(sk->sk_prot, &tcp_prot);
 				icsk->icsk_af_ops = &ipv4_specific;
 				sk->sk_socket->ops = &inet_stream_ops;
 				sk->sk_family = PF_INET;
@@ -238,7 +239,8 @@ static int do_ipv6_setsockopt(struct soc
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, prot, 1);
 				local_bh_enable();
-				sk->sk_prot = prot;
+				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				WRITE_ONCE(sk->sk_prot, prot);
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;
 			}


