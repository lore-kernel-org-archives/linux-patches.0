Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6928386C39;
	Tue, 21 Jul 2026 19:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663021; cv=none; b=HsjFW2jc4dLhO2tEv3cg43tQp4pWcdjrqTyZ4VnfWehFWaO7FadyzXICgJszji7MgsCr6XTp0q2TVnPZW909Af3EAsWG1ECuCltEXIFQCdmWstVHjui7PReI6YOtIlA5O1bFvUNdvlxIu8JqEpJPvrv0wV6zOOErqjEM4YX+DBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663021; c=relaxed/simple;
	bh=kbUem1kE3afrbafuq7osgng2egC69ma7b2GuOL6S0Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPKMcaCvTBWoqJiVABiMDUFVvh5RLS0O1x11XykkOK7tK8GiTMhO22Dc0L9rgBTW2npsBWNWzWgN9MDG5nueO/tYlwmxjIRHtMvzKOGdWxjG8RMT7ychVLcA9MqpesvAN/ezkj4BY5VqPciL+nSAx6o2KiP5QGKb+nmU2YWdgyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqV9P6Or; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqV9P6Or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562311F000E9;
	Tue, 21 Jul 2026 19:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663019;
	bh=olSW7tj2o1RMOBmQC6YILcEDhX4cQCNFKc782O9h9/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqV9P6OrdAbTDTXnzSmUJm+GM5js5uAnCqxDQbm4s8NOlLy1R52mWprch9SL8U/0C
	 xsDrVauDP97w+4jnykVQZaV89iRo777bFfkD2sRckuD/qy59Daae4y8yJ6ynCorysK
	 yEGI99KYFsxVdPE+jNNTD7yk/VgrMlFY2tRi1MOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0665/1276] ipv6: Convert net.ipv6.conf.${DEV}.XXX sysctl to per-netns RTNL.
Date: Tue, 21 Jul 2026 17:18:28 +0200
Message-ID: <20260721152500.986565613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 93c839e3edbe2cdf59d3bc12d776cce4cdf159ce ]

net.ipv6.conf.${DEV}.XXX sysctl are changed under RTNL:

  * forwarding
  * ignore_routes_with_linkdown
  * disable_ipv6
  * proxy_ndp
  * addr_gen_mode
  * stable_secret
  * disable_policy

Let's use rtnl_net_lock() there.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250115080608.28127-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 17dc3b245de4 ("ipv6: fix missing notification for ignore_routes_with_linkdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 60 ++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cbf5a51567e44b..d957a6ce3305cc 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -852,7 +852,7 @@ static void addrconf_forward_change(struct net *net, __s32 newf)
 	struct inet6_dev *idev;
 
 	for_each_netdev(net, dev) {
-		idev = __in6_dev_get(dev);
+		idev = __in6_dev_get_rtnl_net(dev);
 		if (idev) {
 			int changed = (!idev->cnf.forwarding) ^ (!newf);
 
@@ -865,13 +865,12 @@ static void addrconf_forward_change(struct net *net, __s32 newf)
 
 static int addrconf_fixup_forwarding(const struct ctl_table *table, int *p, int newf)
 {
-	struct net *net;
+	struct net *net = (struct net *)table->extra2;
 	int old;
 
-	if (!rtnl_trylock())
+	if (!rtnl_net_trylock(net))
 		return restart_syscall();
 
-	net = (struct net *)table->extra2;
 	old = *p;
 	WRITE_ONCE(*p, newf);
 
@@ -881,7 +880,7 @@ static int addrconf_fixup_forwarding(const struct ctl_table *table, int *p, int
 						     NETCONFA_FORWARDING,
 						     NETCONFA_IFINDEX_DEFAULT,
 						     net->ipv6.devconf_dflt);
-		rtnl_unlock();
+		rtnl_net_unlock(net);
 		return 0;
 	}
 
@@ -903,7 +902,7 @@ static int addrconf_fixup_forwarding(const struct ctl_table *table, int *p, int
 						     net->ipv6.devconf_all);
 	} else if ((!newf) ^ (!old))
 		dev_forward_change((struct inet6_dev *)table->extra1);
-	rtnl_unlock();
+	rtnl_net_unlock(net);
 
 	if (newf)
 		rt6_purge_dflt_routers(net);
@@ -916,7 +915,7 @@ static void addrconf_linkdown_change(struct net *net, __s32 newf)
 	struct inet6_dev *idev;
 
 	for_each_netdev(net, dev) {
-		idev = __in6_dev_get(dev);
+		idev = __in6_dev_get_rtnl_net(dev);
 		if (idev) {
 			int changed = (!idev->cnf.ignore_routes_with_linkdown) ^ (!newf);
 
@@ -933,13 +932,12 @@ static void addrconf_linkdown_change(struct net *net, __s32 newf)
 
 static int addrconf_fixup_linkdown(const struct ctl_table *table, int *p, int newf)
 {
-	struct net *net;
+	struct net *net = (struct net *)table->extra2;
 	int old;
 
-	if (!rtnl_trylock())
+	if (!rtnl_net_trylock(net))
 		return restart_syscall();
 
-	net = (struct net *)table->extra2;
 	old = *p;
 	WRITE_ONCE(*p, newf);
 
@@ -950,7 +948,7 @@ static int addrconf_fixup_linkdown(const struct ctl_table *table, int *p, int ne
 						     NETCONFA_IGNORE_ROUTES_WITH_LINKDOWN,
 						     NETCONFA_IFINDEX_DEFAULT,
 						     net->ipv6.devconf_dflt);
-		rtnl_unlock();
+		rtnl_net_unlock(net);
 		return 0;
 	}
 
@@ -964,7 +962,8 @@ static int addrconf_fixup_linkdown(const struct ctl_table *table, int *p, int ne
 						     NETCONFA_IFINDEX_ALL,
 						     net->ipv6.devconf_all);
 	}
-	rtnl_unlock();
+
+	rtnl_net_unlock(net);
 
 	return 1;
 }
@@ -6406,7 +6405,7 @@ static void addrconf_disable_change(struct net *net, __s32 newf)
 	struct inet6_dev *idev;
 
 	for_each_netdev(net, dev) {
-		idev = __in6_dev_get(dev);
+		idev = __in6_dev_get_rtnl_net(dev);
 		if (idev) {
 			int changed = (!idev->cnf.disable_ipv6) ^ (!newf);
 
@@ -6427,7 +6426,7 @@ static int addrconf_disable_ipv6(const struct ctl_table *table, int *p, int newf
 		return 0;
 	}
 
-	if (!rtnl_trylock())
+	if (!rtnl_net_trylock(net))
 		return restart_syscall();
 
 	old = *p;
@@ -6436,10 +6435,11 @@ static int addrconf_disable_ipv6(const struct ctl_table *table, int *p, int newf
 	if (p == &net->ipv6.devconf_all->disable_ipv6) {
 		WRITE_ONCE(net->ipv6.devconf_dflt->disable_ipv6, newf);
 		addrconf_disable_change(net, newf);
-	} else if ((!newf) ^ (!old))
+	} else if ((!newf) ^ (!old)) {
 		dev_disable_change((struct inet6_dev *)table->extra1);
+	}
 
-	rtnl_unlock();
+	rtnl_net_unlock(net);
 	return 0;
 }
 
@@ -6484,20 +6484,20 @@ static int addrconf_sysctl_proxy_ndp(const struct ctl_table *ctl, int write,
 	if (write && old != new) {
 		struct net *net = ctl->extra2;
 
-		if (!rtnl_trylock())
+		if (!rtnl_net_trylock(net))
 			return restart_syscall();
 
-		if (valp == &net->ipv6.devconf_dflt->proxy_ndp)
+		if (valp == &net->ipv6.devconf_dflt->proxy_ndp) {
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_PROXY_NEIGH,
 						     NETCONFA_IFINDEX_DEFAULT,
 						     net->ipv6.devconf_dflt);
-		else if (valp == &net->ipv6.devconf_all->proxy_ndp)
+		} else if (valp == &net->ipv6.devconf_all->proxy_ndp) {
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_PROXY_NEIGH,
 						     NETCONFA_IFINDEX_ALL,
 						     net->ipv6.devconf_all);
-		else {
+		} else {
 			struct inet6_dev *idev = ctl->extra1;
 
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
@@ -6505,7 +6505,7 @@ static int addrconf_sysctl_proxy_ndp(const struct ctl_table *ctl, int write,
 						     idev->dev->ifindex,
 						     &idev->cnf);
 		}
-		rtnl_unlock();
+		rtnl_net_unlock(net);
 	}
 
 	return ret;
@@ -6525,7 +6525,7 @@ static int addrconf_sysctl_addr_gen_mode(const struct ctl_table *ctl, int write,
 		.mode = ctl->mode,
 	};
 
-	if (!rtnl_trylock())
+	if (!rtnl_net_trylock(net))
 		return restart_syscall();
 
 	new_val = *((u32 *)ctl->data);
@@ -6555,7 +6555,7 @@ static int addrconf_sysctl_addr_gen_mode(const struct ctl_table *ctl, int write,
 
 			WRITE_ONCE(net->ipv6.devconf_dflt->addr_gen_mode, new_val);
 			for_each_netdev(net, dev) {
-				idev = __in6_dev_get(dev);
+				idev = __in6_dev_get_rtnl_net(dev);
 				if (idev &&
 				    idev->cnf.addr_gen_mode != new_val) {
 					WRITE_ONCE(idev->cnf.addr_gen_mode,
@@ -6569,7 +6569,7 @@ static int addrconf_sysctl_addr_gen_mode(const struct ctl_table *ctl, int write,
 	}
 
 out:
-	rtnl_unlock();
+	rtnl_net_unlock(net);
 
 	return ret;
 }
@@ -6591,7 +6591,7 @@ static int addrconf_sysctl_stable_secret(const struct ctl_table *ctl, int write,
 	lctl.maxlen = IPV6_MAX_STRLEN;
 	lctl.data = str;
 
-	if (!rtnl_trylock())
+	if (!rtnl_net_trylock(net))
 		return restart_syscall();
 
 	if (!write && !secret->initialized) {
@@ -6621,7 +6621,7 @@ static int addrconf_sysctl_stable_secret(const struct ctl_table *ctl, int write,
 		struct net_device *dev;
 
 		for_each_netdev(net, dev) {
-			struct inet6_dev *idev = __in6_dev_get(dev);
+			struct inet6_dev *idev = __in6_dev_get_rtnl_net(dev);
 
 			if (idev) {
 				WRITE_ONCE(idev->cnf.addr_gen_mode,
@@ -6636,7 +6636,7 @@ static int addrconf_sysctl_stable_secret(const struct ctl_table *ctl, int write,
 	}
 
 out:
-	rtnl_unlock();
+	rtnl_net_unlock(net);
 
 	return err;
 }
@@ -6722,7 +6722,7 @@ int addrconf_disable_policy(const struct ctl_table *ctl, int *valp, int val)
 		return 0;
 	}
 
-	if (!rtnl_trylock())
+	if (!rtnl_net_trylock(net))
 		return restart_syscall();
 
 	WRITE_ONCE(*valp, val);
@@ -6731,7 +6731,7 @@ int addrconf_disable_policy(const struct ctl_table *ctl, int *valp, int val)
 		struct net_device *dev;
 
 		for_each_netdev(net, dev) {
-			idev = __in6_dev_get(dev);
+			idev = __in6_dev_get_rtnl_net(dev);
 			if (idev)
 				addrconf_disable_policy_idev(idev, val);
 		}
@@ -6740,7 +6740,7 @@ int addrconf_disable_policy(const struct ctl_table *ctl, int *valp, int val)
 		addrconf_disable_policy_idev(idev, val);
 	}
 
-	rtnl_unlock();
+	rtnl_net_unlock(net);
 	return 0;
 }
 
-- 
2.53.0



