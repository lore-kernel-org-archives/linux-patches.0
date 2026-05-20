Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209C43FA5FC;
	Wed, 20 May 2026 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302884; cv=none; b=nHJ6ELitlg68KMbMJvNBBbaKlDk1DmBVabE90/3OFDr2uoLBR0Ra/F6r2JplJOvLpoCB7n5PWqA57mn1R/A+2xbYcqT9fWwYYOuz8gxqC50KpKafeC30OXcHfyVF9smagb5JHIMBtUZ3sjum5g4ys4A6YlnDQrRJ/6TnYpt52Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302884; c=relaxed/simple;
	bh=8Q/1Un4g5OwmQKCNmndtUeItU2VkmXgWjabvU9DnUN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnQPi5/blu6wDltkLHMVTSA9YeW/CtOljIWqDIckpamsZ0Mn7GH4Ju43YdIubtlstIdHRQL2t8aWheER8e8aJ3EcJKmY5ah7noRJcW4mMaIH3Ls+PSp2pJwsYqwUXF2QEESl/87GnwZ1drxm3LUVJKaXMcrUbko/rocGAGqveEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpKAnU5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpKAnU5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768661F000E9;
	Wed, 20 May 2026 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302883;
	bh=F5IUj0TEc6oCrFv3RnTk4+ibHdDEwmOcRKHA/KQbCJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpKAnU5zAeEU6OoBhQdcgpYT/UAs9dvM+YuMMW/EYHu6gnfpS80XtV4AZhIesFCmx
	 SamCCJqVwa/WeM4e3V6zwwqEJgudCUiullJr3lB8OOmGtCLvy4nnGXuMTatNhwQI95
	 aVdHuQR02Nno30qx+304uP3jHjmjJS1XLU/BgAEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 394/508] neighbour: add RCU protection to neigh_tables[]
Date: Wed, 20 May 2026 18:23:37 +0200
Message-ID: <20260520162107.151695510@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8f2eb9de69a1119117d198547c13d7a1123a5a9 ]

In order to remove RTNL protection from neightbl_dump_info()
and neigh_dump_info() later, we need to add
RCU protection to neigh_tables[].

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 4438113be604 ("neigh: let neigh_xmit take skb ownership")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index e6b36df482bc7..8f45692265ce3 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1774,7 +1774,7 @@ static void neigh_parms_destroy(struct neigh_parms *parms)
 
 static struct lock_class_key neigh_table_proxy_queue_class;
 
-static struct neigh_table *neigh_tables[NEIGH_NR_TABLES] __read_mostly;
+static struct neigh_table __rcu *neigh_tables[NEIGH_NR_TABLES] __read_mostly;
 
 void neigh_table_init(int index, struct neigh_table *tbl)
 {
@@ -1831,13 +1831,19 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 	tbl->last_flush = now;
 	tbl->last_rand	= now + tbl->parms.reachable_time * 20;
 
-	neigh_tables[index] = tbl;
+	rcu_assign_pointer(neigh_tables[index], tbl);
 }
 EXPORT_SYMBOL(neigh_table_init);
 
+/*
+ * Only called from ndisc_cleanup(), which means this is dead code
+ * because we no longer can unload IPv6 module.
+ */
 int neigh_table_clear(int index, struct neigh_table *tbl)
 {
-	neigh_tables[index] = NULL;
+	RCU_INIT_POINTER(neigh_tables[index], NULL);
+	synchronize_rcu();
+
 	/* It is not clean... Fix it to unload IPv6 module safely */
 	cancel_delayed_work_sync(&tbl->managed_work);
 	cancel_delayed_work_sync(&tbl->gc_work);
@@ -1869,10 +1875,10 @@ static struct neigh_table *neigh_find_table(int family)
 
 	switch (family) {
 	case AF_INET:
-		tbl = neigh_tables[NEIGH_ARP_TABLE];
+		tbl = rcu_dereference_rtnl(neigh_tables[NEIGH_ARP_TABLE]);
 		break;
 	case AF_INET6:
-		tbl = neigh_tables[NEIGH_ND_TABLE];
+		tbl = rcu_dereference_rtnl(neigh_tables[NEIGH_ND_TABLE]);
 		break;
 	}
 
@@ -2338,7 +2344,7 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ndtmsg = nlmsg_data(nlh);
 
 	for (tidx = 0; tidx < NEIGH_NR_TABLES; tidx++) {
-		tbl = neigh_tables[tidx];
+		tbl = rcu_dereference_rtnl(neigh_tables[tidx]);
 		if (!tbl)
 			continue;
 		if (ndtmsg->ndtm_family && tbl->family != ndtmsg->ndtm_family)
@@ -2526,7 +2532,7 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 	for (tidx = 0; tidx < NEIGH_NR_TABLES; tidx++) {
 		struct neigh_parms *p;
 
-		tbl = neigh_tables[tidx];
+		tbl = rcu_dereference_rtnl(neigh_tables[tidx]);
 		if (!tbl)
 			continue;
 
@@ -2887,7 +2893,7 @@ static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 	s_t = cb->args[0];
 
 	for (t = 0; t < NEIGH_NR_TABLES; t++) {
-		tbl = neigh_tables[t];
+		tbl = rcu_dereference_rtnl(neigh_tables[t]);
 
 		if (!tbl)
 			continue;
@@ -3151,14 +3157,15 @@ int neigh_xmit(int index, struct net_device *dev,
 	       const void *addr, struct sk_buff *skb)
 {
 	int err = -EAFNOSUPPORT;
+
 	if (likely(index < NEIGH_NR_TABLES)) {
 		struct neigh_table *tbl;
 		struct neighbour *neigh;
 
-		tbl = neigh_tables[index];
-		if (!tbl)
-			goto out;
 		rcu_read_lock();
+		tbl = rcu_dereference(neigh_tables[index]);
+		if (!tbl)
+			goto out_unlock;
 		if (index == NEIGH_ARP_TABLE) {
 			u32 key = *((u32 *)addr);
 
@@ -3174,6 +3181,7 @@ int neigh_xmit(int index, struct net_device *dev,
 			goto out_kfree_skb;
 		}
 		err = READ_ONCE(neigh->output)(neigh, skb);
+out_unlock:
 		rcu_read_unlock();
 	}
 	else if (index == NEIGH_LINK_TABLE) {
-- 
2.53.0



