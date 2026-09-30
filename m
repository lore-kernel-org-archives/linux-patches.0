Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F7B51A720;
	Wed, 30 Sep 2026 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788147; cv=none; b=jeRvAf3VA5znJvOFfeqj177hj32V12h5p810RvICVXXw7UDNZqE5C/rABXS28EFdnZPI2B9B/ITBwCYiR6i7+5v7ukpZQzXt43QY8wh9lqEIplN6bwYcHmG737uIAACliEGVFdzCf/7iltbpW+dYm4b8Z65U4jbYntE3/b6Xt/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788147; c=relaxed/simple;
	bh=xyn1eIOQFpKSR7aFcl2yGqCC6XAep5bhQ6g0Ksb/gXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4dfHNCGw1Ptqc0Fx3Wt6XFOd50Z9UZl2MybDdnHeBiad76q1W05RbJI07UuAK0j+ROfH1FmNBj9orV0Z3g62Zg+hcHw4kt+yOrxwlX/sI49Tya19L/sSQWZhC9jSlSL4MJED55qv9bQrMlziaXNmsZOkopikVM8NIrq//LYZVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg7AppsO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg7AppsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAD31F000FF;
	Wed, 30 Sep 2026 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788146;
	bh=egZJmGEIzm1zkxkznED+GyZ5alXxz26gnbS1urjF7P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dg7AppsO5GCB9fbqm7zaBjYZKXlw3NIVphNBz7HY3UgkPPmHv0YT6jZK+/tqpZBDm
	 JluGlzXg3Lh6BXHfYZ7+WYNLmvrMng9XgNHiS5vGDmolI7yTI4egzV/Tacn3P1l40S
	 PVcgZbJcOoRPUlJlOFfZISaWONbK225jjpNRT8j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/877] ipv6: mcast: Dont hold RTNL for IPV6_ADD_MEMBERSHIP and MCAST_JOIN_GROUP.
Date: Wed, 30 Sep 2026 17:15:26 +0200
Message-ID: <20260930152415.073963410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 1767bb2d47b715a106287a8f963d9ec6cbab4e69 ]

In __ipv6_sock_mc_join(), per-socket mld data is protected by lock_sock(),
and only __dev_get_by_index() requires RTNL.

Let's use dev_get_by_index() and drop RTNL for IPV6_ADD_MEMBERSHIP and
MCAST_JOIN_GROUP.

Note that we must call rt6_lookup() and dev_hold() under RCU.

If rt6_lookup() returns an entry from the exception table, dst_dev_put()
could change rt->dev.dst to loopback concurrently, and the original device
could lose the refcount before dev_hold() and unblock device registration.

dst_dev_put() is called from NETDEV_UNREGISTER and synchronize_net() follows
it, so as long as rt6_lookup() and dev_hold() are called within the same
RCU critical section, the dev is alive.

Even if the race happens, they are synchronised by idev->dead and mcast
addresses are cleaned up.

For the racy access to rt->dst.dev, we use dst_dev().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250702230210.3115355-7-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ipv6_sockglue.c |  2 --
 net/ipv6/mcast.c         | 24 +++++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index c2ea92c0f9166..385321a43a19b 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -121,11 +121,9 @@ static bool setsockopt_needs_rtnl(int optname)
 {
 	switch (optname) {
 	case IPV6_ADDRFORM:
-	case IPV6_ADD_MEMBERSHIP:
 	case IPV6_DROP_MEMBERSHIP:
 	case IPV6_JOIN_ANYCAST:
 	case IPV6_LEAVE_ANYCAST:
-	case MCAST_JOIN_GROUP:
 	case MCAST_LEAVE_GROUP:
 	case MCAST_JOIN_SOURCE_GROUP:
 	case MCAST_LEAVE_SOURCE_GROUP:
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 212c2d8efe0f5..61046543302d4 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -172,14 +172,12 @@ static int unsolicited_report_interval(struct inet6_dev *idev)
 static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 			       const struct in6_addr *addr, unsigned int mode)
 {
-	struct net_device *dev = NULL;
-	struct ipv6_mc_socklist *mc_lst;
 	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct ipv6_mc_socklist *mc_lst;
 	struct net *net = sock_net(sk);
+	struct net_device *dev = NULL;
 	int err;
 
-	ASSERT_RTNL();
-
 	if (!ipv6_addr_is_multicast(addr))
 		return -EINVAL;
 
@@ -199,13 +197,18 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 
 	if (ifindex == 0) {
 		struct rt6_info *rt;
+
+		rcu_read_lock();
 		rt = rt6_lookup(net, addr, NULL, 0, NULL, 0);
 		if (rt) {
-			dev = rt->dst.dev;
+			dev = dst_dev(&rt->dst);
+			dev_hold(dev);
 			ip6_rt_put(rt);
 		}
-	} else
-		dev = __dev_get_by_index(net, ifindex);
+		rcu_read_unlock();
+	} else {
+		dev = dev_get_by_index(net, ifindex);
+	}
 
 	if (!dev) {
 		sock_kfree_s(sk, mc_lst, sizeof(*mc_lst));
@@ -216,12 +219,11 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 	mc_lst->sfmode = mode;
 	RCU_INIT_POINTER(mc_lst->sflist, NULL);
 
-	/*
-	 *	now add/increase the group membership on the device
-	 */
-
+	/* now add/increase the group membership on the device */
 	err = __ipv6_dev_mc_inc(dev, addr, mode);
 
+	dev_put(dev);
+
 	if (err) {
 		sock_kfree_s(sk, mc_lst, sizeof(*mc_lst));
 		return err;
-- 
2.53.0



