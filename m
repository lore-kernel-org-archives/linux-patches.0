Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357DC284662;
	Tue, 21 Jul 2026 19:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663460; cv=none; b=bWihosBF+Pp3LcwN5TksX15UFnABmhGVRjem+UmCNcxdKJuny4f2bcfGZkAPJPEIdwf3dPB1RGf9VtnpWf1Dp9lmADFIufPIqpHKNOLIFZdc56W+3vtHkh9keYx3LBMa3GgKwmYHS4MO/N8QUMHyy2aAWManRtb9AG7t9bc7/ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663460; c=relaxed/simple;
	bh=W2KlRhvwNGkpdZsZ3/EsxwvVPM1Zak9Kg00tpciRiog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE9rS8kCy72jA/ZCMp3jd7ZqncIe7jOPXTt2WhULG3O8jL4F9hKFzvPz+guiSKOTXMlCJ4FSfru+E5qssJE+1djmL1Dvfkwg4hfMRt7VDOYi4zfoYkPA/OhAhiB3p9P+edzcw/Fm9ouTgZ0eEaFEEdntort1UtbHfShpelarFhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9htnWmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9htnWmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1BB1F000E9;
	Tue, 21 Jul 2026 19:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663459;
	bh=FLn/DQlBHtV9XdX8iXDiTERoRQogFa7uWbEnPMPApmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9htnWmmXSUpwDvNKK+GGDxYxlHnLR53sLDXcn+y80w3WzEy0e0eZy00qkRSxrnSu
	 4EY8O2YpQTuK58w1vq5myV7BiNfwukkBBHMCK0mkV2R8fRfdlSPelCLZ5Tics4r7rg
	 ozy/Afvyl7I+NyBHbPvsTCmnfAMS50g6lfcspK5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0788/1276] ipv6: mcast: Replace locking comments with lockdep annotations.
Date: Tue, 21 Jul 2026 17:20:31 +0200
Message-ID: <20260721152503.712905864@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 818ae1a5ecb41d82ad180a99c39111f051894d90 ]

Commit 63ed8de4be81 ("mld: add mc_lock for protecting per-interface
mld data") added the same comments regarding locking to many functions.

Let's replace the comments with lockdep annotation, which is more helpful.

Note that we just remove the comment for mld_clear_zeros() and
mld_send_cr(), where mc_dereference() is used in the entry of the
function.

While at it, a comment for __ipv6_sock_mc_join() is moved back to the
correct place.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250702230210.3115355-3-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9b26518b6896 ("ipv6: mcast: Fix potential UAF in MLD delayed work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 125 +++++++++++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 54 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index b769e856a068d2..f2cf5f584524fc 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -105,9 +105,9 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 int sysctl_mld_max_msf __read_mostly = IPV6_MLD_MAX_MSF;
 int sysctl_mld_qrv __read_mostly = MLD_QRV_DEFAULT;
 
-/*
- *	socket join on multicast group
- */
+#define mc_assert_locked(idev)			\
+	lockdep_assert_held(&(idev)->mc_lock)
+
 #define mc_dereference(e, idev) \
 	rcu_dereference_protected(e, lockdep_is_held(&(idev)->mc_lock))
 
@@ -166,6 +166,9 @@ static int unsolicited_report_interval(struct inet6_dev *idev)
 	return iv > 0 ? iv : 1;
 }
 
+/*
+ *	socket join on multicast group
+ */
 static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 			       const struct in6_addr *addr, unsigned int mode)
 {
@@ -665,12 +668,13 @@ bool inet6_mc_check(const struct sock *sk, const struct in6_addr *mc_addr,
 	return rv;
 }
 
-/* called with mc_lock */
 static void igmp6_group_added(struct ifmcaddr6 *mc)
 {
 	struct net_device *dev = mc->idev->dev;
 	char buf[MAX_ADDR_LEN];
 
+	mc_assert_locked(mc->idev);
+
 	if (IPV6_ADDR_MC_SCOPE(&mc->mca_addr) <
 	    IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
@@ -700,12 +704,13 @@ static void igmp6_group_added(struct ifmcaddr6 *mc)
 	mld_ifc_event(mc->idev);
 }
 
-/* called with mc_lock */
 static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 {
 	struct net_device *dev = mc->idev->dev;
 	char buf[MAX_ADDR_LEN];
 
+	mc_assert_locked(mc->idev);
+
 	if (IPV6_ADDR_MC_SCOPE(&mc->mca_addr) <
 	    IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
@@ -726,14 +731,13 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 		refcount_dec(&mc->mca_refcnt);
 }
 
-/*
- * deleted ifmcaddr6 manipulation
- * called with mc_lock
- */
+/* deleted ifmcaddr6 manipulation */
 static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 {
 	struct ifmcaddr6 *pmc;
 
+	mc_assert_locked(idev);
+
 	/* this is an "ifmcaddr6" for convenience; only the fields below
 	 * are actually used. In particular, the refcnt and users are not
 	 * used for management of the delete list. Using the same structure
@@ -767,13 +771,14 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	rcu_assign_pointer(idev->mc_tomb, pmc);
 }
 
-/* called with mc_lock */
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 {
 	struct ip6_sf_list *psf, *sources, *tomb;
 	struct in6_addr *pmca = &im->mca_addr;
 	struct ifmcaddr6 *pmc, *pmc_prev;
 
+	mc_assert_locked(idev);
+
 	pmc_prev = NULL;
 	for_each_mc_tomb(idev, pmc) {
 		if (ipv6_addr_equal(&pmc->mca_addr, pmca))
@@ -810,11 +815,12 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	}
 }
 
-/* called with mc_lock */
 static void mld_clear_delrec(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *pmc, *nextpmc;
 
+	mc_assert_locked(idev);
+
 	pmc = mc_dereference(idev->mc_tomb, idev);
 	RCU_INIT_POINTER(idev->mc_tomb, NULL);
 
@@ -871,13 +877,14 @@ static void ma_put(struct ifmcaddr6 *mc)
 	}
 }
 
-/* called with mc_lock */
 static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 				   const struct in6_addr *addr,
 				   unsigned int mode)
 {
 	struct ifmcaddr6 *mc;
 
+	mc_assert_locked(idev);
+
 	mc = kzalloc(sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return NULL;
@@ -1047,46 +1054,51 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 	return rv;
 }
 
-/* called with mc_lock */
 static void mld_gq_start_work(struct inet6_dev *idev)
 {
 	unsigned long tv = get_random_u32_below(idev->mc_maxdelay);
 
+	mc_assert_locked(idev);
+
 	idev->mc_gq_running = 1;
 	if (!mod_delayed_work(mld_wq, &idev->mc_gq_work, tv + 2))
 		in6_dev_hold(idev);
 }
 
-/* called with mc_lock */
 static void mld_gq_stop_work(struct inet6_dev *idev)
 {
+	mc_assert_locked(idev);
+
 	idev->mc_gq_running = 0;
 	if (cancel_delayed_work(&idev->mc_gq_work))
 		__in6_dev_put(idev);
 }
 
-/* called with mc_lock */
 static void mld_ifc_start_work(struct inet6_dev *idev, unsigned long delay)
 {
 	unsigned long tv = get_random_u32_below(delay);
 
+	mc_assert_locked(idev);
+
 	if (!mod_delayed_work(mld_wq, &idev->mc_ifc_work, tv + 2))
 		in6_dev_hold(idev);
 }
 
-/* called with mc_lock */
 static void mld_ifc_stop_work(struct inet6_dev *idev)
 {
+	mc_assert_locked(idev);
+
 	idev->mc_ifc_count = 0;
 	if (cancel_delayed_work(&idev->mc_ifc_work))
 		__in6_dev_put(idev);
 }
 
-/* called with mc_lock */
 static void mld_dad_start_work(struct inet6_dev *idev, unsigned long delay)
 {
 	unsigned long tv = get_random_u32_below(delay);
 
+	mc_assert_locked(idev);
+
 	if (!mod_delayed_work(mld_wq, &idev->mc_dad_work, tv + 2))
 		in6_dev_hold(idev);
 }
@@ -1111,14 +1123,13 @@ static void mld_report_stop_work(struct inet6_dev *idev)
 		__in6_dev_put(idev);
 }
 
-/*
- * IGMP handling (alias multicast ICMPv6 messages)
- * called with mc_lock
- */
+/* IGMP handling (alias multicast ICMPv6 messages) */
 static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
 {
 	unsigned long delay = resptime;
 
+	mc_assert_locked(ma->idev);
+
 	/* Do not start work for these addresses */
 	if (ipv6_addr_is_ll_all_nodes(&ma->mca_addr) ||
 	    IPV6_ADDR_MC_SCOPE(&ma->mca_addr) < IPV6_ADDR_SCOPE_LINKLOCAL)
@@ -1137,15 +1148,15 @@ static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
 	ma->mca_flags |= MAF_TIMER_RUNNING;
 }
 
-/* mark EXCLUDE-mode sources
- * called with mc_lock
- */
+/* mark EXCLUDE-mode sources */
 static bool mld_xmarksources(struct ifmcaddr6 *pmc, int nsrcs,
 			     const struct in6_addr *srcs)
 {
 	struct ip6_sf_list *psf;
 	int i, scount;
 
+	mc_assert_locked(pmc->idev);
+
 	scount = 0;
 	for_each_psf_mclock(pmc, psf) {
 		if (scount == nsrcs)
@@ -1168,13 +1179,14 @@ static bool mld_xmarksources(struct ifmcaddr6 *pmc, int nsrcs,
 	return true;
 }
 
-/* called with mc_lock */
 static bool mld_marksources(struct ifmcaddr6 *pmc, int nsrcs,
 			    const struct in6_addr *srcs)
 {
 	struct ip6_sf_list *psf;
 	int i, scount;
 
+	mc_assert_locked(pmc->idev);
+
 	if (pmc->mca_sfmode == MCAST_EXCLUDE)
 		return mld_xmarksources(pmc, nsrcs, srcs);
 
@@ -1869,7 +1881,6 @@ static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 
 #define AVAILABLE(skb)	((skb) ? skb_availroom(skb) : 0)
 
-/* called with mc_lock */
 static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 				int type, int gdeleted, int sdeleted,
 				int crsend)
@@ -1883,6 +1894,8 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	struct mld2_report *pmr;
 	unsigned int mtu;
 
+	mc_assert_locked(idev);
+
 	if (pmc->mca_flags & MAF_NOREPORT)
 		return skb;
 
@@ -2001,12 +2014,13 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	return skb;
 }
 
-/* called with mc_lock */
 static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 {
 	struct sk_buff *skb = NULL;
 	int type;
 
+	mc_assert_locked(idev);
+
 	if (!pmc) {
 		for_each_mc_mclock(idev, pmc) {
 			if (pmc->mca_flags & MAF_NOREPORT)
@@ -2028,10 +2042,7 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 		mld_sendpack(skb);
 }
 
-/*
- * remove zero-count source records from a source filter list
- * called with mc_lock
- */
+/* remove zero-count source records from a source filter list */
 static void mld_clear_zeros(struct ip6_sf_list __rcu **ppsf, struct inet6_dev *idev)
 {
 	struct ip6_sf_list *psf_prev, *psf_next, *psf;
@@ -2055,7 +2066,6 @@ static void mld_clear_zeros(struct ip6_sf_list __rcu **ppsf, struct inet6_dev *i
 	}
 }
 
-/* called with mc_lock */
 static void mld_send_cr(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *pmc, *pmc_prev, *pmc_next;
@@ -2219,13 +2229,14 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 	goto out;
 }
 
-/* called with mc_lock */
 static void mld_send_initial_cr(struct inet6_dev *idev)
 {
-	struct sk_buff *skb;
 	struct ifmcaddr6 *pmc;
+	struct sk_buff *skb;
 	int type;
 
+	mc_assert_locked(idev);
+
 	if (mld_in_v1_mode(idev))
 		return;
 
@@ -2272,13 +2283,14 @@ static void mld_dad_work(struct work_struct *work)
 	in6_dev_put(idev);
 }
 
-/* called with mc_lock */
 static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
-	const struct in6_addr *psfsrc)
+			   const struct in6_addr *psfsrc)
 {
 	struct ip6_sf_list *psf, *psf_prev;
 	int rv = 0;
 
+	mc_assert_locked(pmc->idev);
+
 	psf_prev = NULL;
 	for_each_psf_mclock(pmc, psf) {
 		if (ipv6_addr_equal(&psf->sf_addr, psfsrc))
@@ -2315,7 +2327,6 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 	return rv;
 }
 
-/* called with mc_lock */
 static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
 			  int delta)
@@ -2327,6 +2338,8 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 	if (!idev)
 		return -ENODEV;
 
+	mc_assert_locked(idev);
+
 	for_each_mc_mclock(idev, pmc) {
 		if (ipv6_addr_equal(pmca, &pmc->mca_addr))
 			break;
@@ -2368,15 +2381,14 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 	return err;
 }
 
-/*
- * Add multicast single-source filter to the interface list
- * called with mc_lock
- */
+/* Add multicast single-source filter to the interface list */
 static int ip6_mc_add1_src(struct ifmcaddr6 *pmc, int sfmode,
-	const struct in6_addr *psfsrc)
+			   const struct in6_addr *psfsrc)
 {
 	struct ip6_sf_list *psf, *psf_prev;
 
+	mc_assert_locked(pmc->idev);
+
 	psf_prev = NULL;
 	for_each_psf_mclock(pmc, psf) {
 		if (ipv6_addr_equal(&psf->sf_addr, psfsrc))
@@ -2399,11 +2411,12 @@ static int ip6_mc_add1_src(struct ifmcaddr6 *pmc, int sfmode,
 	return 0;
 }
 
-/* called with mc_lock */
 static void sf_markstate(struct ifmcaddr6 *pmc)
 {
-	struct ip6_sf_list *psf;
 	int mca_xcount = pmc->mca_sfcount[MCAST_EXCLUDE];
+	struct ip6_sf_list *psf;
+
+	mc_assert_locked(pmc->idev);
 
 	for_each_psf_mclock(pmc, psf) {
 		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
@@ -2416,14 +2429,15 @@ static void sf_markstate(struct ifmcaddr6 *pmc)
 	}
 }
 
-/* called with mc_lock */
 static int sf_setstate(struct ifmcaddr6 *pmc)
 {
-	struct ip6_sf_list *psf, *dpsf;
 	int mca_xcount = pmc->mca_sfcount[MCAST_EXCLUDE];
+	struct ip6_sf_list *psf, *dpsf;
 	int qrv = pmc->idev->mc_qrv;
 	int new_in, rv;
 
+	mc_assert_locked(pmc->idev);
+
 	rv = 0;
 	for_each_psf_mclock(pmc, psf) {
 		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
@@ -2482,10 +2496,7 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 	return rv;
 }
 
-/*
- * Add multicast source filter list to the interface list
- * called with mc_lock
- */
+/* Add multicast source filter list to the interface list */
 static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
 			  int delta)
@@ -2497,6 +2508,8 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 	if (!idev)
 		return -ENODEV;
 
+	mc_assert_locked(idev);
+
 	for_each_mc_mclock(idev, pmc) {
 		if (ipv6_addr_equal(pmca, &pmc->mca_addr))
 			break;
@@ -2542,11 +2555,12 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 	return err;
 }
 
-/* called with mc_lock */
 static void ip6_mc_clear_src(struct ifmcaddr6 *pmc)
 {
 	struct ip6_sf_list *psf, *nextpsf;
 
+	mc_assert_locked(pmc->idev);
+
 	for (psf = mc_dereference(pmc->mca_tomb, pmc->idev);
 	     psf;
 	     psf = nextpsf) {
@@ -2566,11 +2580,12 @@ static void ip6_mc_clear_src(struct ifmcaddr6 *pmc)
 	pmc->mca_sfcount[MCAST_EXCLUDE] = 1;
 }
 
-/* called with mc_lock */
 static void igmp6_join_group(struct ifmcaddr6 *ma)
 {
 	unsigned long delay;
 
+	mc_assert_locked(ma->idev);
+
 	if (ma->mca_flags & MAF_NOREPORT)
 		return;
 
@@ -2617,9 +2632,10 @@ static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 	return err;
 }
 
-/* called with mc_lock */
 static void igmp6_leave_group(struct ifmcaddr6 *ma)
 {
+	mc_assert_locked(ma->idev);
+
 	if (mld_in_v1_mode(ma->idev)) {
 		if (ma->mca_flags & MAF_LAST_REPORTER) {
 			igmp6_send(&ma->mca_addr, ma->idev->dev,
@@ -2664,9 +2680,10 @@ static void mld_ifc_work(struct work_struct *work)
 	in6_dev_put(idev);
 }
 
-/* called with mc_lock */
 static void mld_ifc_event(struct inet6_dev *idev)
 {
+	mc_assert_locked(idev);
+
 	if (mld_in_v1_mode(idev))
 		return;
 
-- 
2.53.0



