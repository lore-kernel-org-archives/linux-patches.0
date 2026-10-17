Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE753B0AF0;
	Sat, 17 Oct 2026 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255609; cv=none; b=kJ5hbLfd1UANfw9B3BJ1u9ItrVc+G5REqr7Ov4U6eDrY/k9++RuYAXQD/hwPm2d2Z/Uscm3hVIPWFhUYTVZ7uWKSNSslUcwQ1z5zGtT/Y+pErjV2dXOC/jxpztiPmCdi/k/cIYDrIdgJLVVrp34qrWLTrR6bq4SONDQ9FNP/TWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255609; c=relaxed/simple;
	bh=QNyQHJ5xNQYUaW9/RynDEYFHOlOhVJ24iJOg1tgHgBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+KSj4cwo3CWqzIkXygHO4K4vum3BV+a/pjUAPzcOMYGdtKI13XVYVtyBsDnG9RTwVUE7k39YH/cDt5nDZz6mX8ohmDp4i2LWfOiSnA+Xt4e3NCPI3CY0K715kfLvZhtV/gYeK23v06WNPuewjz65QMLptHYGw3jY8pxrTzHqpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBCZ9jtN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBCZ9jtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497BB1F000C4;
	Sat, 17 Oct 2026 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255607;
	bh=0TKr5vGZ22fpfNUxm5z+n576IAEhGQA8PxLvYpzsL3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBCZ9jtNcqgzbto0Gb1zAKsCXeJYezIL+yIRbogR0QjV42PBm2+d7qwyft/Lb3oxc
	 SG/N2dPTz3UZPbV9uio7kNTpD6bWRobJ8SgVCZQw2mCTEK0gAUctEgpech83fiGSZC
	 meqrgm0lENZF1tUX7fPNeB1nGj7+JPby+b9amaWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 795/869] ipv6: mcast: use rcu_assign_pointer() for __rcu list updates
Date: Sat, 17 Oct 2026 18:00:36 +0200
Message-ID: <20261017160057.287172613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0c8f56c583c3250408367880c98e4d6fbc929315 ]

Several places in net/ipv6/mcast.c update RCU-protected lists
(np->ipv6_mc_list, idev->mc_list, idev->mc_tomb) using direct pointer
assignments instead of rcu_assign_pointer():

1. In __ipv6_dev_mc_dec(), unlinking a group from idev->mc_list did:
       *map = ma->next;
   without rcu_assign_pointer() while concurrent readers traverse
   idev->mc_list locklessly under rcu_read_lock().
2. In ipv6_sock_mc_drop() and __ipv6_sock_mc_close(), unlinking a group
   from np->ipv6_mc_list directly assigned *lnk = mc_lst->next and
   np->ipv6_mc_list = mc_lst->next without rcu_assign_pointer(), racing
   with lockless readers in inet6_mc_check().
3. In __ipv6_sock_mc_join(), mc_lst->next was initialized to
   np->ipv6_mc_list via raw assignment before publishing mc_lst.
4. In mld_del_delrec() and __ipv6_dev_mc_inc(), __rcu source pointers
   passed into rcu_assign_pointer() lacked explicit dereference helpers.

Fix these by consistently using rcu_assign_pointer() along with
mc_dereference() / sock_dereference().

Fixes: 456b61bca8ee ("ipv6: mcast: RCU conversion")
Fixes: 88e2ca308094 ("mld: convert ifmcaddr6 to RCU")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828084531.1826790-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d0eefadea5c33..9326dd3976bf8 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -229,7 +229,8 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 		return err;
 	}
 
-	mc_lst->next = np->ipv6_mc_list;
+	rcu_assign_pointer(mc_lst->next,
+			   sock_dereference(np->ipv6_mc_list, sk));
 	rcu_assign_pointer(np->ipv6_mc_list, mc_lst);
 
 	return 0;
@@ -289,7 +290,8 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	      lnk = &mc_lst->next) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
 		    ipv6_addr_equal(&mc_lst->addr, addr)) {
-			*lnk = mc_lst->next;
+			rcu_assign_pointer(*lnk,
+					   sock_dereference(mc_lst->next, sk));
 			__ipv6_sock_mc_drop(sk, mc_lst);
 			return 0;
 		}
@@ -343,7 +345,8 @@ void __ipv6_sock_mc_close(struct sock *sk)
 	while ((mc_lst = sock_dereference(np->ipv6_mc_list, sk)) != NULL) {
 		struct net_device *dev;
 
-		np->ipv6_mc_list = mc_lst->next;
+		rcu_assign_pointer(np->ipv6_mc_list,
+				   sock_dereference(mc_lst->next, sk));
 
 		dev = __dev_get_by_index(net, mc_lst->ifindex);
 		if (dev) {
@@ -826,9 +829,11 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	}
 	if (pmc) {
 		if (pmc_prev)
-			rcu_assign_pointer(pmc_prev->next, pmc->next);
+			rcu_assign_pointer(pmc_prev->next,
+					   mc_dereference(pmc->next, idev));
 		else
-			rcu_assign_pointer(idev->mc_tomb, pmc->next);
+			rcu_assign_pointer(idev->mc_tomb,
+					   mc_dereference(pmc->next, idev));
 	}
 
 	if (pmc) {
@@ -986,7 +991,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 		return -ENOMEM;
 	}
 
-	rcu_assign_pointer(mc->next, idev->mc_list);
+	rcu_assign_pointer(mc->next, mc_dereference(idev->mc_list, idev));
 	rcu_assign_pointer(idev->mc_list, mc);
 
 	mca_get(mc);
@@ -1018,7 +1023,8 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 	     map = &ma->next) {
 		if (ipv6_addr_equal(&ma->mca_addr, addr)) {
 			if (--ma->mca_users == 0) {
-				*map = ma->next;
+				rcu_assign_pointer(*map,
+						   mc_dereference(ma->next, idev));
 
 				igmp6_group_dropped(ma);
 				ip6_mc_clear_src(ma);
-- 
2.53.0



