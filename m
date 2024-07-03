Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228771849F4;
	Wed,  3 Jul 2024 11:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006291; cv=none; b=mGoDFIhXDx0a8la0Z4YJZpJ1MdlJ1RaUbk91T5oHJV78WgDkIt/Kgnf6YGfKfJcyEx94qnoGfChUxcRX89TEjRgoDQ0WfiB5nMenWBExIZZSqpXTT1gcsosfmI6zs8jFL43who69AQLY93z/AGZJ1nEjL1t2amVrQIJS+tz4rj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006291; c=relaxed/simple;
	bh=hv7KMXAO+ntzKLd7zIb9n6ziVUZFItxCGsDf6aqrl10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxlJf+ZbCJL/MjS4fVvIWFcJUkr0ReopAr9t7z1kRjMFTrSexydxRBMTi2tJ4Nr/YqOrM335kmT1le1qPOJQEB45UHL8MFZuV6SAz0db6rMffFTDR/Snwg/cSQUn+BEaAMmQtJ+F6Ken7F1K6YEQJc8cPvXn6o4SCOSP8JGiF+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCF09ORR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCF09ORR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99955C32781;
	Wed,  3 Jul 2024 11:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006291;
	bh=hv7KMXAO+ntzKLd7zIb9n6ziVUZFItxCGsDf6aqrl10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCF09ORRupwrhuCKZ8vSTfYYLTfarNKLLkT06zYsb9vZSOtkL6BXqV52M5w6bPW29
	 WOGfE/ujoFeDHl6Nvf93xax3ni5wfWHRpQ1XcYOHTL2gdj49THJjTqZ0c9jzmHm3Cb
	 ZTRJ09Q0GJGbw0A68ow3w0ixuM79TXK6obAtVuKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 346/356] ipv6: Fix data races around sk->sk_prot.
Date: Wed,  3 Jul 2024 12:41:22 +0200
Message-ID: <20240703102926.201266031@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c          |    6 ++++--
 net/ipv4/af_inet.c       |   23 ++++++++++++++++-------
 net/ipv6/ipv6_sockglue.c |    4 ++--
 3 files changed, 22 insertions(+), 11 deletions(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3413,7 +3413,8 @@ int sock_common_getsockopt(struct socket
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	return READ_ONCE(sk->sk_prot)->getsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_getsockopt);
 
@@ -3440,7 +3441,8 @@ int sock_common_setsockopt(struct socket
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	return READ_ONCE(sk->sk_prot)->setsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_setsockopt);
 
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -565,22 +565,27 @@ int inet_dgram_connect(struct socket *so
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
 
 	if (data_race(!inet_sk(sk)->inet_num) && inet_autobind(sk))
 		return -EAGAIN;
-	return sk->sk_prot->connect(sk, uaddr, addr_len);
+	return prot->connect(sk, uaddr, addr_len);
 }
 EXPORT_SYMBOL(inet_dgram_connect);
 
@@ -743,10 +748,11 @@ EXPORT_SYMBOL(inet_stream_connect);
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
 
@@ -834,12 +840,15 @@ ssize_t inet_sendpage(struct socket *soc
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
@@ -475,7 +475,7 @@ static int do_ipv6_setsockopt(struct soc
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, &tcp_prot, 1);
 
-				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				/* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
 				WRITE_ONCE(sk->sk_prot, &tcp_prot);
 				icsk->icsk_af_ops = &ipv4_specific;
 				sk->sk_socket->ops = &inet_stream_ops;
@@ -490,7 +490,7 @@ static int do_ipv6_setsockopt(struct soc
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, prot, 1);
 
-				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				/* Paired with READ_ONCE(sk->sk_prot) in inet6_dgram_ops */
 				WRITE_ONCE(sk->sk_prot, prot);
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;


