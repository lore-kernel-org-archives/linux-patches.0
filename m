Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBBD3B2D1A;
	Wed, 30 Sep 2026 19:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796531; cv=none; b=uLnqH3DQ0dxoUrSUMchIrdZ65sALoBjYiNAv/Anbxp4hdlWM8Sorsj0Nu/X10uZHljaqK1gBC2Gt6yKWKv7qlABcNGzce3bvnCnhZAD6Ey0tbZfSa/3Pz2QvxL+gfJvKiU7QKAxsVl7LZAF4PaIXj8L4fyWJwGrIbuW05G47ogc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796531; c=relaxed/simple;
	bh=qrNCTtHkxDNiu7Yybw3IgiyA22FxA2e7cYbqOmqOzDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5Ryq4NC54H2aPpeye4RxY1207wqCZUPjKg8ChOTgb+gGPlQVZM09lC44tXpktF6bd0K1ehWtFtUQgzESTHaCCCUDOb3xln0BCgHZ1ISP9vbHiT5zSuiyPXme8nRZ53brHBsFVQE8hs1F9txujPhQf/eFXNCDIdP1c9yhh6P7/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIZ9tnZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIZ9tnZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044471F000FF;
	Wed, 30 Sep 2026 19:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796530;
	bh=50Va8pIpMstt9XWLwafTheH5F2XmHea2vjCzefLfRkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIZ9tnZ9I+EoKCJS6fjge7ZqQzJUQjqXy6w8Uf27Oh80zYMt8PK1B8pSCbrrjLfxm
	 KOoNGQsHjjzn2NTxN7jij5LqBVBkivmYkpSy5U6vilB5w0Rx+gY5bVdwGFp3uwG/nO
	 yFQp3CZp8qg0YcAquiSROt9owwGiLVLqYIauAIkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0944/1193] ipv6: mcast: Dont hold RTNL for IPV6_DROP_MEMBERSHIP and MCAST_LEAVE_GROUP.
Date: Wed, 30 Sep 2026 17:27:08 +0200
Message-ID: <20260930152455.212103284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 2ceb71ce7d34e751f91bbca9da3513a2bc29089c ]

In __ipv6_sock_mc_drop(), per-socket mld data is protected by lock_sock(),
and only __dev_get_by_index() and __in6_dev_get() require RTNL.

Let's use dev_get_by_index() and in6_dev_get() and drop RTNL for
IPV6_ADD_MEMBERSHIP and MCAST_JOIN_GROUP.

Note that __ipv6_sock_mc_drop() is factorised to reuse in the next patch.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250702230210.3115355-8-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ipv6_sockglue.c |  2 --
 net/ipv6/mcast.c         | 47 +++++++++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 59965a0decc44..39835f22f3458 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -121,10 +121,8 @@ static bool setsockopt_needs_rtnl(int optname)
 {
 	switch (optname) {
 	case IPV6_ADDRFORM:
-	case IPV6_DROP_MEMBERSHIP:
 	case IPV6_JOIN_ANYCAST:
 	case IPV6_LEAVE_ANYCAST:
-	case MCAST_LEAVE_GROUP:
 	case MCAST_JOIN_SOURCE_GROUP:
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index a5d3deef4bb1b..cc0a07f8770d3 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -250,14 +250,36 @@ int ipv6_sock_mc_join_ssm(struct sock *sk, int ifindex,
 /*
  *	socket leave on multicast group
  */
+static void __ipv6_sock_mc_drop(struct sock *sk, struct ipv6_mc_socklist *mc_lst)
+{
+	struct net *net = sock_net(sk);
+	struct net_device *dev;
+
+	dev = dev_get_by_index(net, mc_lst->ifindex);
+	if (dev) {
+		struct inet6_dev *idev = in6_dev_get(dev);
+
+		ip6_mc_leave_src(sk, mc_lst, idev);
+
+		if (idev) {
+			__ipv6_dev_mc_dec(idev, &mc_lst->addr);
+			in6_dev_put(idev);
+		}
+
+		dev_put(dev);
+	} else {
+		ip6_mc_leave_src(sk, mc_lst, NULL);
+	}
+
+	atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
+	kfree_rcu(mc_lst, rcu);
+}
+
 int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct ipv6_mc_socklist *mc_lst;
 	struct ipv6_mc_socklist __rcu **lnk;
-	struct net *net = sock_net(sk);
-
-	ASSERT_RTNL();
+	struct ipv6_mc_socklist *mc_lst;
 
 	if (!ipv6_addr_is_multicast(addr))
 		return -EINVAL;
@@ -267,23 +289,8 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	      lnk = &mc_lst->next) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
 		    ipv6_addr_equal(&mc_lst->addr, addr)) {
-			struct net_device *dev;
-
 			*lnk = mc_lst->next;
-
-			dev = __dev_get_by_index(net, mc_lst->ifindex);
-			if (dev) {
-				struct inet6_dev *idev = __in6_dev_get(dev);
-
-				ip6_mc_leave_src(sk, mc_lst, idev);
-				if (idev)
-					__ipv6_dev_mc_dec(idev, &mc_lst->addr);
-			} else {
-				ip6_mc_leave_src(sk, mc_lst, NULL);
-			}
-
-			atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
-			kfree_rcu(mc_lst, rcu);
+			__ipv6_sock_mc_drop(sk, mc_lst);
 			return 0;
 		}
 	}
-- 
2.53.0



