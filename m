Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71254C10E8;
	Thu, 17 Sep 2026 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659108; cv=none; b=nGfPo9kIayEu8ibo8P21gCea7u3LthyJZ1R/HVh5zDucTXA7vuJlVoThMYCm3sBLcJBaL62sdRlL6vqwoCko+88XDHRy2DWO4cLrHAEDImjX5DA3xWhMKgjJfnpYvWvhYN2kb4b+5PcRpnVPitEQYppHvcBu+yZBqAyrM4z7Z3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659108; c=relaxed/simple;
	bh=Jv9fcoSxGaC60/C7jL8R1LMReaTvrKkHJravcMtD1gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fyq7zjJwlu0ZP+58Yq1QxYIZLQ8JwVSfZFqO865ZeRQPayjjHZe+Wd/vR59y11PV/fjazd3qS2YHJNFYlqJ/TL3+XzFWE+5FM4XTkzQ7DLPwx5PtTVZKLMdYoG+Ks+qAgVY7esxJxjqeVaA+ZBu//P0wjfG2yopkqHOhzyn2tnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+luC1YH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+luC1YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00A21F00893;
	Thu, 17 Sep 2026 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659099;
	bh=YdFgrHRY7KBaut9NiEA/kuLLbRHdS4viAJ8s1dRPCtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+luC1YHornEfnQc2a+AV2N3Qkb0hOIqSzWD1T1d0DIXRKl/WkLYzjHRQmgiBNydX
	 mPbiBwIYcGAH61HcW2sC3z60/PkJ9rt6bDDTe0Ad3aRDOrznWqqagPN8cF71NIWkzB
	 BOGEx/j7kTPVBaRrod0EiHY0vAcyOz+LiUrOa3sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 143/733] ipv6: mcast: use rcu_assign_pointer() for __rcu list updates
Date: Thu, 17 Sep 2026 16:07:31 +0100
Message-ID: <20260917151354.603808202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 62c9a1c08b9a2..d5db3b449cd08 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -240,7 +240,8 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 		return err;
 	}
 
-	mc_lst->next = np->ipv6_mc_list;
+	rcu_assign_pointer(mc_lst->next,
+			   sock_dereference(np->ipv6_mc_list, sk));
 	rcu_assign_pointer(np->ipv6_mc_list, mc_lst);
 
 	return 0;
@@ -300,7 +301,8 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	      lnk = &mc_lst->next) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
 		    ipv6_addr_equal(&mc_lst->addr, addr)) {
-			*lnk = mc_lst->next;
+			rcu_assign_pointer(*lnk,
+					   sock_dereference(mc_lst->next, sk));
 			__ipv6_sock_mc_drop(sk, mc_lst);
 			return 0;
 		}
@@ -333,7 +335,8 @@ void __ipv6_sock_mc_close(struct sock *sk)
 	struct ipv6_mc_socklist *mc_lst;
 
 	while ((mc_lst = sock_dereference(np->ipv6_mc_list, sk)) != NULL) {
-		np->ipv6_mc_list = mc_lst->next;
+		rcu_assign_pointer(np->ipv6_mc_list,
+				   sock_dereference(mc_lst->next, sk));
 		__ipv6_sock_mc_drop(sk, mc_lst);
 	}
 }
@@ -798,9 +801,11 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	if (!pmc)
 		return;
 	if (pmc_prev)
-		rcu_assign_pointer(pmc_prev->next, pmc->next);
+		rcu_assign_pointer(pmc_prev->next,
+				   mc_dereference(pmc->next, idev));
 	else
-		rcu_assign_pointer(idev->mc_tomb, pmc->next);
+		rcu_assign_pointer(idev->mc_tomb,
+				   mc_dereference(pmc->next, idev));
 
 	im->idev = pmc->idev;
 	if (im->mca_sfmode == MCAST_INCLUDE) {
@@ -979,7 +984,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 		return -ENOMEM;
 	}
 
-	rcu_assign_pointer(mc->next, idev->mc_list);
+	rcu_assign_pointer(mc->next, mc_dereference(idev->mc_list, idev));
 	rcu_assign_pointer(idev->mc_list, mc);
 
 	mld_del_delrec(idev, mc);
@@ -1013,7 +1018,8 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 
 			WRITE_ONCE(ma->mca_users, new_users);
 			if (new_users == 0) {
-				*map = ma->next;
+				rcu_assign_pointer(*map,
+						   mc_dereference(ma->next, idev));
 
 				igmp6_group_dropped(ma);
 				inet6_ifmcaddr_notify(idev->dev, ma,
-- 
2.53.0



