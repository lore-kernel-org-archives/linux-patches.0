Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0277E175555;
	Wed,  3 Jul 2024 10:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003709; cv=none; b=b+IddqSv8f54ue0mr5bOeT2VEzvJy/GZd+BW/qXw3G1w+4LyIi7P7qJSdevU06BqKpyC48MLLQZEbc3J7pB6YDgGEVnvrxmDV+rtNb19UI27XZ9GqFc82etRcdTtfBCNWtNdBwasqGBSLYUqVDybadloBv9+FvVaVZMMjjFfiVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003709; c=relaxed/simple;
	bh=Reo4LEH2L5eDwvWmBxZ3DBeJL9dVSr1MYRp2vu5T36I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8LlY+ps99ijrzpn2xkRYkBR5nlOoD8dhuJL14FCMlJ0/HsAB5hZluvN6Jy7Mo8r2/pnD7xdTsLb9Un8Pmw7dloO1Z1yjYyD6W+djwbDuOZ+NEB2ncuEhKprXBQ004cOZeXF/7T20cDE/d23aG1QJuPQQyNzm8k0f8NF4vVKcDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2T5F4Ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2T5F4Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AFFC2BD10;
	Wed,  3 Jul 2024 10:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003708;
	bh=Reo4LEH2L5eDwvWmBxZ3DBeJL9dVSr1MYRp2vu5T36I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2T5F4ApyDRrSDMIL+AR9eKHO7LahDE58Qtdx5DJR8FJGmv7bTWY/6753UdTskNsC
	 SdDhF40fy3Ar6durl8KN5XYxk3lgnYpoVdY49ASL23uEvMczMfq2T8fsHfAj7gtFY0
	 HNY8yIeNYg2B+27l5OISoRLIr8KfR0mhZjVj3ga0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kazunori Kobayashi <kazunori.kobayashi@miraclelinux.com>
Subject: [PATCH 4.19 137/139] ipv6: Fix data races around sk->sk_prot.
Date: Wed,  3 Jul 2024 12:40:34 +0200
Message-ID: <20240703102835.607832004@linuxfoundation.org>
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
@@ -3064,7 +3064,8 @@ int sock_common_getsockopt(struct socket
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	return READ_ONCE(sk->sk_prot)->getsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_getsockopt);
 
@@ -3105,7 +3106,8 @@ int sock_common_setsockopt(struct socket
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
 
@@ -809,6 +815,7 @@ ssize_t inet_sendpage(struct socket *soc
 		      size_t size, int flags)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 
 	sock_rps_record_flow(sk);
 
@@ -817,8 +824,10 @@ ssize_t inet_sendpage(struct socket *soc
 	    inet_autobind(sk))
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
@@ -224,7 +224,7 @@ static int do_ipv6_setsockopt(struct soc
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, &tcp_prot, 1);
 				local_bh_enable();
-				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				/* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
 				WRITE_ONCE(sk->sk_prot, &tcp_prot);
 				icsk->icsk_af_ops = &ipv4_specific;
 				sk->sk_socket->ops = &inet_stream_ops;
@@ -239,7 +239,7 @@ static int do_ipv6_setsockopt(struct soc
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, prot, 1);
 				local_bh_enable();
-				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				/* Paired with READ_ONCE(sk->sk_prot) in inet6_dgram_ops */
 				WRITE_ONCE(sk->sk_prot, prot);
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;


