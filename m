Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90A54D0A14;
	Fri,  9 Oct 2026 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555337; cv=none; b=fgda5ky8RAJjiUfzueUeCKg+jPTyOvwES99rVQ5u7Z6yFZrFK7h31WTDohthnhX/xIofTlCXwCKBdLSV0t8OXBT4n5/+o2F8TMpbZa0SDk0BLj2+CawHoy1tSxToe3OM9IxpZc33xpNcYhuPszLT4dHrjMEp+4pCOlamUc5mh64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555337; c=relaxed/simple;
	bh=TMwSAAQb29JelGeE4TSjv9sR8IO5hsBIVnNJdTyk2is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTPKxT7BxQQS9g1/rdYgmZuDslkK6AmsEPLAmwLul5pBqt7b8ETnVm/WYEsC6nNYXtGL8k8oJQTmbpUTiK1jkYqrljhd1njGwQsWazf0Z2YJ7Kul7tmem1RWXBUcDh08lRwvfhbVjnjS9FJdlJz5oxAP6N4Ej7qkJhRPkHotWls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxXTrAQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxXTrAQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2151F00893;
	Fri,  9 Oct 2026 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555330;
	bh=YPrDF2meLbiw6q4SmDpyhQe4AYbp+bQn9+q7Z5ABJ90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxXTrAQJ9OsiXzjk47QLYgQmAsebCfb/tE5Fc8BBbjm/1/QosuefF8qgIuvz6A8sd
	 a1ZqdWS5wS+T789afOHtSWMCn4BFtbMM9Tl+0w8VHbtL4VVRiSQBAjhA8Mk1It2Ztu
	 1Rtxw9fAjdpcu3lhKfs5j8UJYhflZ6uIxlJrw2Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/403] neighbour: Annotate access to neigh_parms fields.
Date: Fri,  9 Oct 2026 16:06:11 +0200
Message-ID: <20261009140952.360657533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 35d7c70870338aa6a367b9e4ed528914320b0be0 ]

NEIGH_VAR() is read locklessly in the fast path, and IPv6 ndisc uses
NEIGH_VAR_SET() locklessly.

The next patch will convert neightbl_dump_info() to RCU.

Let's annotate accesses to neigh_param with READ_ONCE() and WRITE_ONCE().

Note that ndisc_ifinfo_sysctl_change() uses &NEIGH_VAR() and we cannot
use '&' with READ_ONCE(), so NEIGH_VAR_PTR() is introduced.

Note also that NEIGH_VAR_INIT() does not need WRITE_ONCE() as it is before
parms is published.  Also, the only user hippi_neigh_setup_dev() is no
longer called since commit e3804cbebb67 ("net: remove COMPAT_NET_DEV_OPS"),
which looks wrong, but probably no one uses HIPPI and RoadRunner.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251022054004.2514876-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h | 15 ++++++++++++---
 net/core/neighbour.c    | 17 ++++++-----------
 net/ipv6/ndisc.c        |  8 ++++----
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index c13c758aca7e0..862e53007fd2e 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -92,15 +92,17 @@ struct neigh_parms {
 static inline void neigh_var_set(struct neigh_parms *p, int index, int val)
 {
 	set_bit(index, p->data_state);
-	p->data[index] = val;
+	WRITE_ONCE(p->data[index], val);
 }
 
-#define NEIGH_VAR(p, attr) ((p)->data[NEIGH_VAR_ ## attr])
+#define __NEIGH_VAR(p, attr) ((p)->data[NEIGH_VAR_ ## attr])
+#define NEIGH_VAR(p, attr) READ_ONCE(__NEIGH_VAR(p, attr))
+#define NEIGH_VAR_PTR(p, attr) (&(__NEIGH_VAR(p, attr)))
 
 /* In ndo_neigh_setup, NEIGH_VAR_INIT should be used.
  * In other cases, NEIGH_VAR_SET should be used.
  */
-#define NEIGH_VAR_INIT(p, attr, val) (NEIGH_VAR(p, attr) = val)
+#define NEIGH_VAR_INIT(p, attr, val) (__NEIGH_VAR(p, attr) = val)
 #define NEIGH_VAR_SET(p, attr, val) neigh_var_set(p, NEIGH_VAR_ ## attr, val)
 
 static inline void neigh_parms_data_state_setall(struct neigh_parms *p)
@@ -378,6 +380,13 @@ struct net *neigh_parms_net(const struct neigh_parms *parms)
 
 unsigned long neigh_rand_reach_time(unsigned long base);
 
+static inline void neigh_set_reach_time(struct neigh_parms *p)
+{
+	unsigned long base = NEIGH_VAR(p, BASE_REACHABLE_TIME);
+
+	WRITE_ONCE(p->reachable_time, neigh_rand_reach_time(base));
+}
+
 void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
 		    struct sk_buff *skb);
 struct pneigh_entry *pneigh_lookup(struct neigh_table *tbl, struct net *net,
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6afd6490d7847..ce537eca16409 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -996,8 +996,7 @@ static void neigh_periodic_work(struct work_struct *work)
 
 		WRITE_ONCE(tbl->last_rand, jiffies);
 		list_for_each_entry(p, &tbl->parms_list, list)
-			p->reachable_time =
-				neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
+			neigh_set_reach_time(p);
 	}
 
 	if (atomic_read(&tbl->entries) < READ_ONCE(tbl->gc_thresh1))
@@ -1750,8 +1749,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 	if (p) {
 		p->tbl		  = tbl;
 		refcount_set(&p->refcnt, 1);
-		p->reachable_time =
-				neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
+		neigh_set_reach_time(p);
 		p->qlen = 0;
 		netdev_hold(dev, &p->dev_tracker, GFP_KERNEL);
 		p->dev = dev;
@@ -1811,8 +1809,7 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 	list_add(&tbl->parms.list, &tbl->parms_list);
 	write_pnet(&tbl->parms.net, &init_net);
 	refcount_set(&tbl->parms.refcnt, 1);
-	tbl->parms.reachable_time =
-			  neigh_rand_reach_time(NEIGH_VAR(&tbl->parms, BASE_REACHABLE_TIME));
+	neigh_set_reach_time(&tbl->parms);
 	tbl->parms.qlen = 0;
 
 	tbl->stats = alloc_percpu(struct neigh_statistics);
@@ -2195,7 +2192,7 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
 			NEIGH_VAR(parms, MCAST_PROBES)) ||
 	    nla_put_u32(skb, NDTPA_MCAST_REPROBES,
 			NEIGH_VAR(parms, MCAST_REPROBES)) ||
-	    nla_put_msecs(skb, NDTPA_REACHABLE_TIME, parms->reachable_time,
+	    nla_put_msecs(skb, NDTPA_REACHABLE_TIME, READ_ONCE(parms->reachable_time),
 			  NDTPA_PAD) ||
 	    nla_put_msecs(skb, NDTPA_BASE_REACHABLE_TIME,
 			  NEIGH_VAR(parms, BASE_REACHABLE_TIME), NDTPA_PAD) ||
@@ -2474,8 +2471,7 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 				 * only be effective after the next time neigh_periodic_work
 				 * decides to recompute it (can be multiple minutes)
 				 */
-				p->reachable_time =
-					neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
+				neigh_set_reach_time(p);
 				break;
 			case NDTPA_GC_STALETIME:
 				NEIGH_VAR_SET(p, GC_STALETIME,
@@ -3733,8 +3729,7 @@ static int neigh_proc_base_reachable_time(const struct ctl_table *ctl, int write
 		 * only be effective after the next time neigh_periodic_work
 		 * decides to recompute it
 		 */
-		p->reachable_time =
-			neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
+		neigh_set_reach_time(p);
 	}
 	return ret;
 }
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 7262356de10d9..73732ca910fca 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1450,7 +1450,7 @@ static enum skb_drop_reason ndisc_router_discovery(struct sk_buff *skb)
 					      BASE_REACHABLE_TIME, rtime);
 				NEIGH_VAR_SET(in6_dev->nd_parms,
 					      GC_STALETIME, 3 * rtime);
-				in6_dev->nd_parms->reachable_time = neigh_rand_reach_time(rtime);
+				neigh_set_reach_time(in6_dev->nd_parms);
 				in6_dev->tstamp = jiffies;
 				send_ifinfo_notify = true;
 			}
@@ -1951,9 +1951,9 @@ int ndisc_ifinfo_sysctl_change(const struct ctl_table *ctl, int write, void *buf
 		ret = -1;
 
 	if (write && ret == 0 && dev && (idev = in6_dev_get(dev)) != NULL) {
-		if (ctl->data == &NEIGH_VAR(idev->nd_parms, BASE_REACHABLE_TIME))
-			idev->nd_parms->reachable_time =
-					neigh_rand_reach_time(NEIGH_VAR(idev->nd_parms, BASE_REACHABLE_TIME));
+		if (ctl->data == NEIGH_VAR_PTR(idev->nd_parms, BASE_REACHABLE_TIME))
+			neigh_set_reach_time(idev->nd_parms);
+
 		WRITE_ONCE(idev->tstamp, jiffies);
 		inet6_ifinfo_notify(RTM_NEWLINK, idev);
 		in6_dev_put(idev);
-- 
2.53.0



