Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2E31891B6;
	Wed,  3 Jul 2024 10:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004300; cv=none; b=ahvALEWghXanMExFnTfRTtP/i5U+IoX6f1K5X3DQdYUFBSYkNmTE993H9+4egU/yhL2vHCEOTDqmdAGnmrI6eSuCH55QT20HTK74uAifLw7Pnc8QhOtBZH+LH+ADdjNGg2sNzTI2z21UKgbAXqhQX+PZqJ9rjVLMPpus9z1lu8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004300; c=relaxed/simple;
	bh=CjYwkpMyuCyp3K3M/ANdQK31XthczZFlnBw9oHS6i5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD5o0EQR2nryt3SnbVhyLkPW9fDlc5tkNYF15cXvomdVVEBCIS3oTFqUK+LefxL/i6iKBlMdYKqWtnq6Zo2QilqjbXgJk3hksxPYCSdwIyZ/kEydkM/zyUCGa+lZ1aMR367Zw1mIzOI6BpRuxAD8JIju2KVRIozR5gf5ccyvUDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDWumdo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDWumdo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C07C4AF0B;
	Wed,  3 Jul 2024 10:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004300;
	bh=CjYwkpMyuCyp3K3M/ANdQK31XthczZFlnBw9oHS6i5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDWumdo6l2orsll0rTMyIw3zMqgav841Hk+kyg+AtK/xAmvlMVFTJohNuRBZCn1NC
	 PJyo/G0RxkRlBamOjUHsOU3d3hJOyWGOKwAn6aPUkGB4FoJmMU5U4CmzXXeSdacZYP
	 S52VavLtCJWJjIQOqI/n72/IL8ACEGYSaxq778Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kazunori Kobayashi <kazunori.kobayashi@miraclelinux.com>
Subject: [PATCH 5.4 186/189] ipv6: Fix data races around sk->sk_prot.
Date: Wed,  3 Jul 2024 12:40:47 +0200
Message-ID: <20240703102848.492659343@linuxfoundation.org>
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

commit 364f997b5cfe1db0d63a390fe7c801fa2b3115f6 upstream.

Commit 086d49058cd8 ("ipv6: annotate some data-races around sk->sk_prot")
fixed some data-races around sk->sk_prot but it was not enough.

Some functions in inet6_(stream|dgram)_ops still access sk->sk_prot
without lock_sock() or rtnl_lock(), so they need READ_ONCE() to avoid
load tearing.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kazunori Kobayashi <kazunori.kobayashi@miraclelinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c          |    6 ++++--
 net/ipv4/af_inet.c       |   23 ++++++++++++++++-------
 net/ipv6/ipv6_sockglue.c |    4 ++--
 3 files changed, 22 insertions(+), 11 deletions(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3172,7 +3172,8 @@ int sock_common_getsockopt(struct socket
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	return READ_ONCE(sk->sk_prot)->getsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_getsockopt);
 
@@ -3213,7 +3214,8 @@ int sock_common_setsockopt(struct socket
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	return READ_ONCE(sk->sk_prot)->setsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_setsockopt);
 
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -553,22 +553,27 @@ int inet_dgram_connect(struct socket *so
 		       int addr_len, int flags)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 	int err;
 
 	if (addr_len < sizeof(uaddr->sa_family))
 		return -EINVAL;
+
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+
 	if (uaddr->sa_family == AF_UNSPEC)
-		return sk->sk_prot->disconnect(sk, flags);
+		return prot->disconnect(sk, flags);
 
 	if (BPF_CGROUP_PRE_CONNECT_ENABLED(sk)) {
-		err = sk->sk_prot->pre_connect(sk, uaddr, addr_len);
+		err = prot->pre_connect(sk, uaddr, addr_len);
 		if (err)
 			return err;
 	}
 
 	if (!inet_sk(sk)->inet_num && inet_autobind(sk))
 		return -EAGAIN;
-	return sk->sk_prot->connect(sk, uaddr, addr_len);
+	return prot->connect(sk, uaddr, addr_len);
 }
 EXPORT_SYMBOL(inet_dgram_connect);
 
@@ -731,10 +736,11 @@ EXPORT_SYMBOL(inet_stream_connect);
 int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		bool kern)
 {
-	struct sock *sk1 = sock->sk;
+	struct sock *sk1 = sock->sk, *sk2;
 	int err = -EINVAL;
-	struct sock *sk2 = sk1->sk_prot->accept(sk1, flags, &err, kern);
 
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	sk2 = READ_ONCE(sk1->sk_prot)->accept(sk1, flags, &err, kern);
 	if (!sk2)
 		goto do_err;
 
@@ -815,12 +821,15 @@ ssize_t inet_sendpage(struct socket *soc
 		      size_t size, int flags)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 
 	if (unlikely(inet_send_prepare(sk)))
 		return -EAGAIN;
 
-	if (sk->sk_prot->sendpage)
-		return sk->sk_prot->sendpage(sk, page, offset, size, flags);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot->sendpage)
+		return prot->sendpage(sk, page, offset, size, flags);
 	return sock_no_sendpage(sock, page, offset, size, flags);
 }
 EXPORT_SYMBOL(inet_sendpage);
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -222,7 +222,7 @@ static int do_ipv6_setsockopt(struct soc
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, &tcp_prot, 1);
 				local_bh_enable();
-				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				/* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
 				WRITE_ONCE(sk->sk_prot, &tcp_prot);
 				icsk->icsk_af_ops = &ipv4_specific;
 				sk->sk_socket->ops = &inet_stream_ops;
@@ -237,7 +237,7 @@ static int do_ipv6_setsockopt(struct soc
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, prot, 1);
 				local_bh_enable();
-				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				/* Paired with READ_ONCE(sk->sk_prot) in inet6_dgram_ops */
 				WRITE_ONCE(sk->sk_prot, prot);
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;


