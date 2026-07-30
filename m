Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E761442107;
	Thu, 30 Jul 2026 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422129; cv=none; b=Mcg6TMn7FfzrgRTwDW215qbe9Hda1OeJwsL9RyqcDXGX46/vsa8cqvURh8tXv6/7N6USHluGf6EQhRxytFsPvcf3Qb1AVy7nDAPy6VrOPjOODtQ+Orj2kXW5+GWF38MG9lZrflU3Shce23d/QL36BGa5LS6QVt0PRvk2bNo+rt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422129; c=relaxed/simple;
	bh=szstiSp//mB3FAxwg1iOg3Qw8JfToad2hEJta62FgLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ae11oy2OrK7Z5eJ/8NAxjQtmIsFtaErovNNJuA8bRmSW8D+KvAcEFJw//7r/OcvR7pt2bTW+BgkTWHLqRJnOh/uAqvk6JDsgwOgZQttNsH7mJJF7gJ8Vo+7MnyJv0exioSC/kH8FB49ogZMHA6s+abaDxJ6lDJfuOZq3l14bNnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjKo+/nF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjKo+/nF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3671F000E9;
	Thu, 30 Jul 2026 14:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422127;
	bh=N0zgfRLZHCuJWv7vHCJMsKtf2+dIfjkwtiIUwg3vgdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjKo+/nFvWsmqRUkEfzIdjXl0yWxCUvIQbh5/6BsLLxXf6gErp3wWTDProJh8w1QE
	 ZDBePZNuIcYYF25z4HusFfIA67pDxJmM6cMHkJ+4FHv8SMch3rIUjTpJxRe4/r0kv7
	 D3wUOI2qRk244mHGhRPAfXHvk0aB8rAa6ufMdkag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 334/744] raw: annotate lockless match fields in raw_v4_match()
Date: Thu, 30 Jul 2026 16:10:07 +0200
Message-ID: <20260730141451.382901470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 18f116931f52e3c3303ad4b15ff41eb89b0e4239 ]

raw_v4_match() is a lockless match helper under sk_for_each_rcu(). It
still reads inet->inet_daddr, inet->inet_rcv_saddr and
sk->sk_bound_dev_if with plain loads while bind, connect and
bind-to-device paths can update the same match fields concurrently.

Annotate only those mutable match fields in raw_v4_match(), and do so
at the point of use instead of hoisting the bound-device read before
the earlier short-circuit tests.

Also annotate the raw bind writer and the shared IPv4 datagram connect
writer used by raw sockets, so the address fields updated on bind and
connect match explicit WRITE_ONCE() updates.

This version intentionally leaves the shared disconnect-side IPv4
writers to follow-up cleanup and limits the writer changes here to the
raw bind path and the datagram connect path directly exercised by raw
sockets.

Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260716142958.3064224-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/datagram.c |  4 ++--
 net/ipv4/raw.c      | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 1614593b6d7270..7d25519a6cdd3f 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -63,12 +63,12 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr_unsized *uaddr, int
 	}
 
 	/* Update addresses before rehashing */
-	inet->inet_daddr = fl4->daddr;
+	WRITE_ONCE(inet->inet_daddr, fl4->daddr);
 	inet->inet_dport = usin->sin_port;
 	if (!inet->inet_saddr)
 		inet->inet_saddr = fl4->saddr;
 	if (!inet->inet_rcv_saddr) {
-		inet->inet_rcv_saddr = fl4->saddr;
+		WRITE_ONCE(inet->inet_rcv_saddr, fl4->saddr);
 		if (sk->sk_prot->rehash)
 			sk->sk_prot->rehash(sk);
 	}
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 68e88cb3e55cbd..f47b8b49da3d12 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -120,13 +120,21 @@ bool raw_v4_match(struct net *net, const struct sock *sk, unsigned short num,
 		  __be32 raddr, __be32 laddr, int dif, int sdif)
 {
 	const struct inet_sock *inet = inet_sk(sk);
+	__be32 daddr, rcv_saddr;
 
-	if (net_eq(sock_net(sk), net) && inet->inet_num == num	&&
-	    !(inet->inet_daddr && inet->inet_daddr != raddr) 	&&
-	    !(inet->inet_rcv_saddr && inet->inet_rcv_saddr != laddr) &&
-	    raw_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
-		return true;
-	return false;
+	if (!net_eq(sock_net(sk), net) || inet->inet_num != num)
+		return false;
+
+	daddr = READ_ONCE(inet->inet_daddr);
+	if (daddr && daddr != raddr)
+		return false;
+
+	rcv_saddr = READ_ONCE(inet->inet_rcv_saddr);
+	if (rcv_saddr && rcv_saddr != laddr)
+		return false;
+
+	return raw_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if),
+				   dif, sdif);
 }
 EXPORT_SYMBOL_GPL(raw_v4_match);
 
@@ -724,7 +732,8 @@ static int raw_bind(struct sock *sk, struct sockaddr_unsized *uaddr,
 					 chk_addr_ret))
 		goto out;
 
-	inet->inet_rcv_saddr = inet->inet_saddr = addr->sin_addr.s_addr;
+	inet->inet_saddr = addr->sin_addr.s_addr;
+	WRITE_ONCE(inet->inet_rcv_saddr, addr->sin_addr.s_addr);
 	if (chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST)
 		inet->inet_saddr = 0;  /* Use device */
 	sk_dst_reset(sk);
-- 
2.53.0



