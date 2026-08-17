Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18BB3CB546;
	Mon, 17 Aug 2026 13:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974276; cv=none; b=SKyrZTQhr3JCMibvX3BtdbibMnJ3hlafXw0yqwBAWM1HbI4dyS6LKq1Nv7NkaY/imDC0h5+2QIWAwReTzZgvhM/HiAN1tPOBFKWXpv9BzeWWukEF2xeDH5zGtC8z/Ke446C2dWv8cae3TdIEw8tM3PBwkM9WDvs6Ta8YnjDARDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974276; c=relaxed/simple;
	bh=QvW1Dfi3tXtDEr7LC0N/oTQfIAY26GAPHMdaU21D/pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSOFI/HZBhcVZDOd+7oVMsveOUiH/ZOoZYBdNVhaNJPKrL6opPB+I59Y6PBHYH1rWoikJcTj4GjdAJTSanN2nN3UpL+V7pUPmZx+sMsEjcksUmIADpt9qzL3NK79IA5o5lN6WvETe+uHc7fePg9RbU2mZc0PYfsq2FPGb/3zzb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oa4+LO3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oa4+LO3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10331F000E9;
	Mon, 17 Aug 2026 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974267;
	bh=v++Kp2VEan2xR5wz02o+BOYkAHaDYDsoI3QpZj7WRBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oa4+LO3KuHEt/xrR6mTGaopVSil1hrhF/bKAwsnIEsLXbZp0z8tOAlJeMSw4bsUb1
	 ivzbjyWi16yqlh+83AY+dXmeASs1u4k45JyektRz6+aAWP5PrdDuTYVeLQ2LpYOa5c
	 SA/s50RgeffK85hVIT7apYi/25VYhCsIPI2R3yNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.1 147/271] ipvs: separate destination availability state
Date: Mon, 17 Aug 2026 15:31:12 +0200
Message-ID: <20260817132542.913020249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit cdcc4e46180df8161f4d2f3c6fd6beaf6990133d upstream.

IPVS configuration paths update destination availability while connection
accounting updates destination overload state. The two independent states
share dest->flags, so their read-modify-write updates can race and lose one
another.

Keep OVERLOAD in flags, where the preceding patch serializes its updates
with dst_lock, and move AVAILABLE to cflags. This keeps configuration-
controlled availability out of the scheduler hot cacheline until a
scheduler needs to check it. It also prevents availability updates from
clobbering overload state.

The destination status bits are not exposed through the IPVS sockopt or
netlink interfaces, so keep their definitions in the internal IPVS header.

Readers can still observe stale destination state; this does not provide a
cross-field snapshot.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Link: https://lore.kernel.org/all/8913381c-1e02-35c7-0ec4-61de5a12fd35@ssi.bg/
Assisted-by: Claude-Code:GLM-5.2
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_vs.h              |    7 +++++++
 include/uapi/linux/ip_vs.h       |    6 ------
 net/netfilter/ipvs/ip_vs_conn.c  |    4 ++--
 net/netfilter/ipvs/ip_vs_core.c  |    6 +++---
 net/netfilter/ipvs/ip_vs_ctl.c   |    4 ++--
 net/netfilter/ipvs/ip_vs_dh.c    |    4 ++--
 net/netfilter/ipvs/ip_vs_lblc.c  |    2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c |    8 ++++----
 net/netfilter/ipvs/ip_vs_xmit.c  |    4 ++--
 9 files changed, 23 insertions(+), 22 deletions(-)

--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -36,6 +36,12 @@
 #define IP_VS_HDR_INVERSE	1
 #define IP_VS_HDR_ICMP		2
 
+/* Destination Server Flags */
+#define IP_VS_DEST_F_OVERLOAD	0x0002		/* server is overloaded */
+
+/* Destination Server Config Flags */
+#define IP_VS_DEST_CF_AVAILABLE	0x0001		/* server is available */
+
 /* conn_tab limits (as per Kconfig) */
 #define IP_VS_CONN_TAB_MIN_BITS	8
 #if BITS_PER_LONG > 32
@@ -968,6 +974,7 @@ struct ip_vs_dest {
 	volatile unsigned int	flags;		/* dest status flags */
 	atomic_t		conn_flags;	/* flags to copy to conn */
 	atomic_t		weight;		/* server weight */
+	unsigned long		cflags;		/* config flags */
 	atomic_t		last_weight;	/* server latest weight */
 	__u16			tun_type;	/* tunnel type */
 	__be16			tun_port;	/* tunnel port */
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -29,12 +29,6 @@
 #define IP_VS_SVC_F_SCHED_SH_PORT	IP_VS_SVC_F_SCHED2 /* SH use port */
 
 /*
- *      Destination Server Flags
- */
-#define IP_VS_DEST_F_AVAILABLE	0x0001		/* server is available */
-#define IP_VS_DEST_F_OVERLOAD	0x0002		/* server is overloaded */
-
-/*
  *      IPVS sync daemon states
  */
 #define IP_VS_STATE_NONE	0x0000		/* daemon is stopped */
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1279,7 +1279,7 @@ int ip_vs_check_template(struct ip_vs_co
 	 * Checking the dest server status.
 	 */
 	if ((dest == NULL) ||
-	    !(dest->flags & IP_VS_DEST_F_AVAILABLE) ||
+	    !(dest->cflags & IP_VS_DEST_CF_AVAILABLE) ||
 	    expire_quiescent_template(ipvs, dest) ||
 	    (cdest && (dest != cdest))) {
 		IP_VS_DBG_BUF(9, "check_template: dest not available for "
@@ -2012,7 +2012,7 @@ repeat:
 			cp = ip_vs_hn0_to_conn(hn);
 			resched_score++;
 			dest = cp->dest;
-			if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
+			if (!dest || (dest->cflags & IP_VS_DEST_CF_AVAILABLE))
 				continue;
 
 			if (atomic_read(&cp->n_control))
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -302,7 +302,7 @@ ip_vs_in_stats(struct ip_vs_conn *cp, st
 	struct ip_vs_dest *dest = cp->dest;
 	struct netns_ipvs *ipvs = cp->ipvs;
 
-	if (dest && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (dest && (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		struct ip_vs_cpu_stats *s;
 		struct ip_vs_service *svc;
 
@@ -338,7 +338,7 @@ ip_vs_out_stats(struct ip_vs_conn *cp, s
 	struct ip_vs_dest *dest = cp->dest;
 	struct netns_ipvs *ipvs = cp->ipvs;
 
-	if (dest && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (dest && (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		struct ip_vs_cpu_stats *s;
 		struct ip_vs_service *svc;
 
@@ -2210,7 +2210,7 @@ ip_vs_in_hook(void *priv, struct sk_buff
 	}
 
 	/* Check the server status */
-	if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (cp && cp->dest && !(cp->dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		/* the destination server is not available */
 		if (sysctl_expire_nodest_conn(ipvs)) {
 			bool old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1402,7 +1402,7 @@ __ip_vs_update_dest(struct ip_vs_service
 	}
 
 	/* set the dest status flags */
-	dest->flags |= IP_VS_DEST_F_AVAILABLE;
+	dest->cflags |= IP_VS_DEST_CF_AVAILABLE;
 
 	if (READ_ONCE(dest->u_threshold) != udest->u_threshold ||
 	    READ_ONCE(dest->l_threshold) != udest->l_threshold) {
@@ -1662,7 +1662,7 @@ static void __ip_vs_unlink_dest(struct i
 				struct ip_vs_dest *dest,
 				int svcupd)
 {
-	dest->flags &= ~IP_VS_DEST_F_AVAILABLE;
+	dest->cflags &= ~IP_VS_DEST_CF_AVAILABLE;
 
 	spin_lock_bh(&dest->dst_lock);
 	__ip_vs_dst_cache_reset(dest);
--- a/net/netfilter/ipvs/ip_vs_dh.c
+++ b/net/netfilter/ipvs/ip_vs_dh.c
@@ -219,8 +219,8 @@ ip_vs_dh_schedule(struct ip_vs_service *
 
 	s = (struct ip_vs_dh_state *) svc->sched_data;
 	dest = ip_vs_dh_get(svc->af, s, &iph->daddr);
-	if (!dest
-	    || !(dest->flags & IP_VS_DEST_F_AVAILABLE)
+	if (!dest ||
+	    !(dest->cflags & IP_VS_DEST_CF_AVAILABLE)
 	    || atomic_read(&dest->weight) <= 0
 	    || is_overloaded(dest)) {
 		ip_vs_scheduler_err(svc, "no destination available");
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -502,7 +502,7 @@ ip_vs_lblc_schedule(struct ip_vs_service
 		 */
 
 		dest = en->dest;
-		if ((dest->flags & IP_VS_DEST_F_AVAILABLE) &&
+		if ((dest->cflags & IP_VS_DEST_CF_AVAILABLE) &&
 		    atomic_read(&dest->weight) > 0 && !is_overloaded(dest, svc))
 			goto out;
 	}
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -169,8 +169,8 @@ static inline struct ip_vs_dest *ip_vs_d
 		if (least->flags & IP_VS_DEST_F_OVERLOAD)
 			continue;
 
-		if ((atomic_read(&least->weight) > 0)
-		    && (least->flags & IP_VS_DEST_F_AVAILABLE)) {
+		if ((atomic_read(&least->weight) > 0) &&
+		    (least->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 			loh = ip_vs_dest_conn_overhead(least);
 			goto nextstage;
 		}
@@ -186,8 +186,8 @@ static inline struct ip_vs_dest *ip_vs_d
 
 		doh = ip_vs_dest_conn_overhead(dest);
 		if (((__s64)loh * atomic_read(&dest->weight) >
-		     (__s64)doh * atomic_read(&least->weight))
-		    && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+		     (__s64)doh * atomic_read(&least->weight)) &&
+		    (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 			least = dest;
 			loh = doh;
 		}
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -351,7 +351,7 @@ __ip_vs_get_out_rt(struct netns_ipvs *ip
 			 * stored in dest_trash.
 			 */
 			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
-			    dest->flags & IP_VS_DEST_F_AVAILABLE)
+			    dest->cflags & IP_VS_DEST_CF_AVAILABLE)
 				__ip_vs_dst_set(dest, dest_dst, &rt->dst, 0);
 			else
 				noref = 0;
@@ -530,7 +530,7 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs
 			 * stored in dest_trash.
 			 */
 			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
-			    dest->flags & IP_VS_DEST_F_AVAILABLE)
+			    dest->cflags & IP_VS_DEST_CF_AVAILABLE)
 				__ip_vs_dst_set(dest, dest_dst, &rt->dst, cookie);
 			else
 				noref = 0;


