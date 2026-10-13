Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57C84F93D6;
	Tue, 13 Oct 2026 12:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894333; cv=none; b=FWBCu+LWw68m3zpqdC4uK/0GJuOZE187Daz4deZWLgRbgy69rHMlKP/20YAeo5kFuwN0xn2KNbdZWx8V7vIg3zUXispqrX6MdkkEOCS7QQFzHqU5rJUldw9KEeu9jNURcVcz7Qpfy8RLyji38nCexyLLDPLKvTGOvKFhLSr0FYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894333; c=relaxed/simple;
	bh=Am6e2L6Nxxdhh/sjTbMZRDrelvW2TZlcEdMV0m+q4cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfEHvg2GIDZTDecfSCAWH6Wb0f2tqkCyNu28ySiZyqrtJYBaoIX8Z7S3f4qMUbRUcUWa65Sgst147Ht+8HL9cQDPhZPoBHHA21BTTEIVUBNRqPUbmbEdvbrfZ6cH3i3XN0U6ora9q2OOHzZNP8NOP4AZB984FZLNW3hVzVQd4Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8WlrBuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8WlrBuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CEA1F000FF;
	Tue, 13 Oct 2026 12:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894332;
	bh=Fv1EK5mrP+iBNR1U4akRIfKepXe1N0/9BepUa4WGfp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8WlrBuVOhnD2F4+1H/qN1WRhFuydbqXesmXO1rc54+npgCkG4nqpewqUPM3PFvtZ
	 zFdlF8qcu2wDxPrfx10VMeJWbZbQLoGlMh7JPLQx6/8W0Wb8+gvD6zPvGRNBaHTeS1
	 Y8xzgKkMehwpB5bPwTLubzvlgA8LfX7X42SHCwdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 523/621] ipv6: mcast: use rcu_assign_pointer() for __rcu list updates
Date: Tue, 13 Oct 2026 13:38:38 +0200
Message-ID: <20261013112933.232380803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6d1653da17c4c..f37357f24a88f 100644
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



