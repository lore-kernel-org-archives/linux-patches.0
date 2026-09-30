Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ABB3E1D1A;
	Wed, 30 Sep 2026 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796529; cv=none; b=oZb2XoMXLsYrF5kLUJO4jasW7t8M1eiqFS1jw7RciK6Nv3vo0+XAeleqhpME0m8buzfEGLqInMssv5YSk8hQemztmFSujsselAd7GmuJuN3D2tqbf4YPy+LHamlQqWV9lcf7JAw88Nkd/v2ZJwMERq+r/P+BsjWvqRappeZjOwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796529; c=relaxed/simple;
	bh=vcRveNjEXW6mkO+FD+0J5pTFUOT41HLOuh1ykVb+qv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPOnGetBR4UnHKU3kQq13eKk5q+s/W/e74TJJ2/qjHUsiHtKXtcBGZjJSjyBfbp0nEat4jrICSppfUBbRMJDc5kW9Jrclf2NB+tIwt6rYkJRjAn4NQy4IsL5pPx4xjKBpRC1xTtYWpyQCVMm4/GI9CCHoTm1O4G5dPCYMICPGF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTi3+BV5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTi3+BV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9211F000FF;
	Wed, 30 Sep 2026 19:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796527;
	bh=zPhmUGl2Fc3/q9i5iRzc9yPvIOj/ZLnppcxOOvdKxkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTi3+BV5DnFgCvSyNiG2uvJINuKRPVrjvndTPF4KNMGh0Dy7vXfd4kStTxr1FAcc+
	 4QT+TcBpEvRqMUCQYwZA50CQiG9gRw2u2VgqXUihYDJOCshMCLL8pm1Df7eVbNzJII
	 YFtzqQqN15PFGjrUXIcNBLi1jIq23Pww9pefAGYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0943/1193] ipv6: mcast: Dont hold RTNL for IPV6_ADD_MEMBERSHIP and MCAST_JOIN_GROUP.
Date: Wed, 30 Sep 2026 17:27:07 +0200
Message-ID: <20260930152455.188503852@linuxfoundation.org>
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
index 289cfd11e35b6..59965a0decc44 100644
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
index 5b427150cc416..a5d3deef4bb1b 100644
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



