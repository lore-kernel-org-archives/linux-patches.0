Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B259D43B490;
	Tue, 21 Jul 2026 22:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674214; cv=none; b=AomCgCavZbaWDa9PhuNMOoCYwLtY2m+esUXXf5ApirpcB1LWioZg71vd34FtfByHA09fBqjcaCYNVEgJ7zkRcgHzV9pYNy9uF2qcEh/wAszECy59e6qkaJH6kB6tavZhWBy7SGJn9QyE4JUWeEx9Dtei7C5JGsO16lBbLbyc0gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674214; c=relaxed/simple;
	bh=gdhs4+5bLokKaEXFzm3fBf47j95epvBe3GqQaD+XO4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7SkMguZeC9gl0lmfUNTfnQ7wxqcszC19nYcgJXoA8FkesdRzMP8+7s/qdCAk9O9Z+sfa3nQaBz981by2fGlj1h83+JuPzfVdSbil7RHXcb2acVILVGOmb5BWSid5tgP+SFpmmo2U7W6weuHgJjiqWvz8MPZ8QvctL6TSBEn04s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nk8GYYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nk8GYYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC01D1F000E9;
	Tue, 21 Jul 2026 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674210;
	bh=ZEg9HdH+b1BGIZDqOd56yG6QLRh0G7MucfhY56YA5R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nk8GYYtY52RInSiZW5dHSjZtiDctYmB6XCNRKyFpZF7Ros4gxFzMu0FqqHAwq5Ur
	 UO5HQYWXiCRHeeFhN4AgjgM2mfqk8aYWbylfm9w1w1zFMXxRVD5xL3W5dy8YS7zm6F
	 E/nv7SbqQhsJTsj+quFrhh1Fvs/87A5z5pqF+SMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Taehee Yoo <ap420073@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/699] mld: convert ipv6_mc_socklist->sflist to RCU
Date: Tue, 21 Jul 2026 17:22:51 +0200
Message-ID: <20260721152404.986934675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 882ba1f73c06831f2a21044ebd8864c485ac04f2 ]

The sflist has been protected by rwlock so that the critical section
is atomic context.
In order to switch this context, changing locking is needed.
The sflist actually already protected by RTNL So if it's converted
to use RCU, its control path context can be switched to sleepable.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9b26518b6896 ("ipv6: mcast: Fix potential UAF in MLD delayed work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/if_inet6.h |  4 ++--
 net/ipv6/mcast.c       | 52 ++++++++++++++++++------------------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 6ae15539d09d9b..f91e62cf126661 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -82,6 +82,7 @@ struct inet6_ifaddr {
 struct ip6_sf_socklist {
 	unsigned int		sl_max;
 	unsigned int		sl_count;
+	struct rcu_head		rcu;
 	struct in6_addr		sl_addr[];
 };
 
@@ -95,8 +96,7 @@ struct ipv6_mc_socklist {
 	int			ifindex;
 	unsigned int		sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
 	struct ipv6_mc_socklist __rcu *next;
-	rwlock_t		sflock;
-	struct ip6_sf_socklist	*sflist;
+	struct ip6_sf_socklist	__rcu *sflist;
 	struct rcu_head		rcu;
 };
 
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index f5e01bfdfc46a9..2a08c1e1ebc5f6 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -178,8 +178,7 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 
 	mc_lst->ifindex = dev->ifindex;
 	mc_lst->sfmode = mode;
-	rwlock_init(&mc_lst->sflock);
-	mc_lst->sflist = NULL;
+	RCU_INIT_POINTER(mc_lst->sflist, NULL);
 
 	/*
 	 *	now add/increase the group membership on the device
@@ -335,7 +334,6 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	struct net *net = sock_net(sk);
 	int i, j, rv;
 	int leavegroup = 0;
-	int pmclocked = 0;
 	int err;
 
 	source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
@@ -364,7 +362,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		goto done;
 	}
 	/* if a source filter was set, must be the same mode as before */
-	if (pmc->sflist) {
+	if (rcu_access_pointer(pmc->sflist)) {
 		if (pmc->sfmode != omode) {
 			err = -EINVAL;
 			goto done;
@@ -376,10 +374,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		pmc->sfmode = omode;
 	}
 
-	write_lock(&pmc->sflock);
-	pmclocked = 1;
-
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	if (!add) {
 		if (!psl)
 			goto done;	/* err = -EADDRNOTAVAIL */
@@ -429,9 +424,11 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		if (psl) {
 			for (i = 0; i < psl->sl_count; i++)
 				newpsl->sl_addr[i] = psl->sl_addr[i];
-			sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
+			atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+			kfree_rcu(psl, rcu);
 		}
-		pmc->sflist = psl = newpsl;
+		psl = newpsl;
+		rcu_assign_pointer(pmc->sflist, psl);
 	}
 	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
 	for (i = 0; i < psl->sl_count; i++) {
@@ -447,8 +444,6 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	/* update the interface list */
 	ip6_mc_add_src(idev, group, omode, 1, source, 1);
 done:
-	if (pmclocked)
-		write_unlock(&pmc->sflock);
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
 	if (leavegroup)
@@ -526,17 +521,16 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		(void) ip6_mc_add_src(idev, group, gsf->gf_fmode, 0, NULL, 0);
 	}
 
-	write_lock(&pmc->sflock);
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	if (psl) {
 		(void) ip6_mc_del_src(idev, group, pmc->sfmode,
 			psl->sl_count, psl->sl_addr, 0);
-		sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
+		atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+		kfree_rcu(psl, rcu);
 	} else
 		(void) ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
-	pmc->sflist = newpsl;
+	rcu_assign_pointer(pmc->sflist, newpsl);
 	pmc->sfmode = gsf->gf_fmode;
-	write_unlock(&pmc->sflock);
 	err = 0;
 done:
 	read_unlock_bh(&idev->lock);
@@ -585,16 +579,14 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	if (!pmc)		/* must have a prior join */
 		goto done;
 	gsf->gf_fmode = pmc->sfmode;
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	count = psl ? psl->sl_count : 0;
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
 
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
-	/* changes to psl require the socket lock, and a write lock
-	 * on pmc->sflock. We have the socket lock so reading here is safe.
-	 */
+
 	for (i = 0; i < copycount; i++, p++) {
 		struct sockaddr_in6 *psin6;
 		struct sockaddr_storage ss;
@@ -630,8 +622,7 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		rcu_read_unlock();
 		return np->mc_all;
 	}
-	read_lock(&mc->sflock);
-	psl = mc->sflist;
+	psl = rcu_dereference(mc->sflist);
 	if (!psl) {
 		rv = mc->sfmode == MCAST_EXCLUDE;
 	} else {
@@ -646,7 +637,6 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		if (mc->sfmode == MCAST_EXCLUDE && i < psl->sl_count)
 			rv = false;
 	}
-	read_unlock(&mc->sflock);
 	rcu_read_unlock();
 
 	return rv;
@@ -2419,19 +2409,21 @@ static void igmp6_join_group(struct ifmcaddr6 *ma)
 static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 			    struct inet6_dev *idev)
 {
+	struct ip6_sf_socklist *psl;
 	int err;
 
-	write_lock_bh(&iml->sflock);
-	if (!iml->sflist) {
+	psl = rtnl_dereference(iml->sflist);
+
+	if (!psl) {
 		/* any-source empty exclude case */
 		err = ip6_mc_del_src(idev, &iml->addr, iml->sfmode, 0, NULL, 0);
 	} else {
 		err = ip6_mc_del_src(idev, &iml->addr, iml->sfmode,
-				iml->sflist->sl_count, iml->sflist->sl_addr, 0);
-		sock_kfree_s(sk, iml->sflist, IP6_SFLSIZE(iml->sflist->sl_max));
-		iml->sflist = NULL;
+				psl->sl_count, psl->sl_addr, 0);
+		RCU_INIT_POINTER(iml->sflist, NULL);
+		atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+		kfree_rcu(psl, rcu);
 	}
-	write_unlock_bh(&iml->sflock);
 	return err;
 }
 
-- 
2.53.0



