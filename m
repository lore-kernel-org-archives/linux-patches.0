Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EF03B443F;
	Wed, 30 Sep 2026 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796534; cv=none; b=UWOl+G9ddbDgSo2fYxXNdq1q3jL6UeY2ADAsJ5Kgw9ql9qbWTk+S73cUANZHR3SJ/BlITFPJfiw1G6vYMG0y/f2cZ0Q6EFQFN+QOyh+a+FAwU2G+gP0ZNPY5I8VH+7cqAbcaHL6HXXxr45a3l9j2ZRKgyjOYEBM/jJN4C54TVkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796534; c=relaxed/simple;
	bh=ukmhweLCkmGwD9lWVowyGtYHbOFGPhzFBxp+vVDhamE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhUZZhhAwkFj4mEG26hdbVXwSweqdunrF7K60d1GSLDNW0flWl2bFeUahFJiQrdSGtRDeV4NdzjL5xRPS0POyJe6MVTQc14t5/iMHRe4LRKD7H57S0m/aJ3PPjZyMB+1akcF54Fv1A+/9vjuv4SytwDF/3BhxxEQbKo0yk6YFHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhV3ymHJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhV3ymHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06641F000FF;
	Wed, 30 Sep 2026 19:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796533;
	bh=AqxdnRC4z/YYGPuExZwQrlsx05XVWAyIZUdn8SlAZxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhV3ymHJ3U1iMt6I3C4r7mhKmZ0QMR7ezx6KQR9UWmmJDH+vA9HNJAah8K43kWb6l
	 UF2C4mk9VaWW0JGd1bj51InleU3pB4e1swAfJVRpIGXhlMSirT0R/zZmxjKzR1cxe9
	 2tvPxHaJhU2vIqTU0iJOaNCrwqYyiktdaSSANxH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0945/1193] ipv6: mcast: Dont hold RTNL for MCAST_ socket options.
Date: Wed, 30 Sep 2026 17:27:09 +0200
Message-ID: <20260930152455.235371589@linuxfoundation.org>
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

[ Upstream commit e6e14d582dd2cbee362c48a1865f8d03ca0a5611 ]

In ip6_mc_source() and ip6_mc_msfilter(), per-socket mld data is
protected by lock_sock() and inet6_dev->mc_lock is also held for
some per-interface functions.

ip6_mc_find_dev_rtnl() only depends on RTNL.  If we want to remove
it, we need to check inet6_dev->dead under mc_lock to close the race
with addrconf_ifdown(), as mentioned earlier.

Let's do that and drop RTNL for the rest of MCAST_ socket options.

Note that ip6_mc_msfilter() has unnecessary lock dances and they
are integrated into one to avoid the last-minute error and simplify
the error handling.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250702230210.3115355-10-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ipv6_sockglue.c |  5 ---
 net/ipv6/mcast.c         | 74 ++++++++++++++++++++++++----------------
 2 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 39835f22f3458..48fe3eb42f016 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -123,11 +123,6 @@ static bool setsockopt_needs_rtnl(int optname)
 	case IPV6_ADDRFORM:
 	case IPV6_JOIN_ANYCAST:
 	case IPV6_LEAVE_ANYCAST:
-	case MCAST_JOIN_SOURCE_GROUP:
-	case MCAST_LEAVE_SOURCE_GROUP:
-	case MCAST_BLOCK_SOURCE:
-	case MCAST_UNBLOCK_SOURCE:
-	case MCAST_MSFILTER:
 		return true;
 	}
 	return false;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index cc0a07f8770d3..d61933dd107f8 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -299,31 +299,36 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 }
 EXPORT_SYMBOL(ipv6_sock_mc_drop);
 
-static struct inet6_dev *ip6_mc_find_dev_rtnl(struct net *net,
-					      const struct in6_addr *group,
-					      int ifindex)
+static struct inet6_dev *ip6_mc_find_dev(struct net *net,
+					 const struct in6_addr *group,
+					 int ifindex)
 {
 	struct net_device *dev = NULL;
-	struct inet6_dev *idev = NULL;
+	struct inet6_dev *idev;
 
 	if (ifindex == 0) {
-		struct rt6_info *rt = rt6_lookup(net, group, NULL, 0, NULL, 0);
+		struct rt6_info *rt;
 
+		rcu_read_lock();
+		rt = rt6_lookup(net, group, NULL, 0, NULL, 0);
 		if (rt) {
-			dev = rt->dst.dev;
+			dev = dst_dev(&rt->dst);
+			dev_hold(dev);
 			ip6_rt_put(rt);
 		}
+		rcu_read_unlock();
 	} else {
-		dev = __dev_get_by_index(net, ifindex);
+		dev = dev_get_by_index(net, ifindex);
 	}
-
 	if (!dev)
 		return NULL;
-	idev = __in6_dev_get(dev);
+
+	idev = in6_dev_get(dev);
+	dev_put(dev);
+
 	if (!idev)
 		return NULL;
-	if (idev->dead)
-		return NULL;
+
 	return idev;
 }
 
@@ -371,16 +376,16 @@ void ipv6_sock_mc_close(struct sock *sk)
 }
 
 int ip6_mc_source(int add, int omode, struct sock *sk,
-	struct group_source_req *pgsr)
+		  struct group_source_req *pgsr)
 {
+	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct in6_addr *source, *group;
+	struct net *net = sock_net(sk);
 	struct ipv6_mc_socklist *pmc;
-	struct inet6_dev *idev;
-	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct ip6_sf_socklist *psl;
-	struct net *net = sock_net(sk);
-	int i, j, rv;
+	struct inet6_dev *idev;
 	int leavegroup = 0;
+	int i, j, rv;
 	int err;
 
 	source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
@@ -389,13 +394,19 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	if (!ipv6_addr_is_multicast(group))
 		return -EINVAL;
 
-	idev = ip6_mc_find_dev_rtnl(net, group, pgsr->gsr_interface);
+	idev = ip6_mc_find_dev(net, group, pgsr->gsr_interface);
 	if (!idev)
 		return -ENODEV;
 
+	mutex_lock(&idev->mc_lock);
+
+	if (idev->dead) {
+		err = -ENODEV;
+		goto done;
+	}
+
 	err = -EADDRNOTAVAIL;
 
-	mutex_lock(&idev->mc_lock);
 	for_each_pmc_socklock(inet6, sk, pmc) {
 		if (pgsr->gsr_interface && pmc->ifindex != pgsr->gsr_interface)
 			continue;
@@ -492,6 +503,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	ip6_mc_add_src(idev, group, omode, 1, source, 1);
 done:
 	mutex_unlock(&idev->mc_lock);
+	in6_dev_put(idev);
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, pgsr->gsr_interface, group);
 	return err;
@@ -500,12 +512,12 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		    struct sockaddr_storage *list)
 {
-	const struct in6_addr *group;
-	struct ipv6_mc_socklist *pmc;
-	struct inet6_dev *idev;
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct ip6_sf_socklist *newpsl, *psl;
 	struct net *net = sock_net(sk);
+	const struct in6_addr *group;
+	struct ipv6_mc_socklist *pmc;
+	struct inet6_dev *idev;
 	int leavegroup = 0;
 	int i, err;
 
@@ -517,10 +529,17 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	    gsf->gf_fmode != MCAST_EXCLUDE)
 		return -EINVAL;
 
-	idev = ip6_mc_find_dev_rtnl(net, group, gsf->gf_interface);
+	idev = ip6_mc_find_dev(net, group, gsf->gf_interface);
 	if (!idev)
 		return -ENODEV;
 
+	mutex_lock(&idev->mc_lock);
+
+	if (idev->dead) {
+		err = -ENODEV;
+		goto done;
+	}
+
 	err = 0;
 
 	if (gsf->gf_fmode == MCAST_INCLUDE && gsf->gf_numsrc == 0) {
@@ -553,24 +572,19 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 			psin6 = (struct sockaddr_in6 *)list;
 			newpsl->sl_addr[i] = psin6->sin6_addr;
 		}
-		mutex_lock(&idev->mc_lock);
+
 		err = ip6_mc_add_src(idev, group, gsf->gf_fmode,
 				     newpsl->sl_count, newpsl->sl_addr, 0);
 		if (err) {
-			mutex_unlock(&idev->mc_lock);
 			sock_kfree_s(sk, newpsl, struct_size(newpsl, sl_addr,
 							     newpsl->sl_max));
 			goto done;
 		}
-		mutex_unlock(&idev->mc_lock);
 	} else {
 		newpsl = NULL;
-		mutex_lock(&idev->mc_lock);
 		ip6_mc_add_src(idev, group, gsf->gf_fmode, 0, NULL, 0);
-		mutex_unlock(&idev->mc_lock);
 	}
 
-	mutex_lock(&idev->mc_lock);
 	psl = sock_dereference(pmc->sflist, sk);
 	if (psl) {
 		ip6_mc_del_src(idev, group, pmc->sfmode,
@@ -580,12 +594,14 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	} else {
 		ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
 	}
+
 	rcu_assign_pointer(pmc->sflist, newpsl);
-	mutex_unlock(&idev->mc_lock);
 	kfree_rcu(psl, rcu);
 	pmc->sfmode = gsf->gf_fmode;
 	err = 0;
 done:
+	mutex_unlock(&idev->mc_lock);
+	in6_dev_put(idev);
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, gsf->gf_interface, group);
 	return err;
-- 
2.53.0



