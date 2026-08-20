Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B027347D478;
	Thu, 20 Aug 2026 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243260; cv=none; b=TKmBg1KLt41hN9pGX+rhuICrKPyB/aS8nyKVvnK6UyG2/waBth1Aitcc7IGeHLUzMCl3IlcwyHWn1mXwiD4J4kvGiBIUJjWIfQBnriomTpB/hJkSXipOBEjuZ+EujfSj0+ORQ7DCzQ7a7VvJ6i+RsjcUOy8cTKLqlQ62xS73jUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243260; c=relaxed/simple;
	bh=YLfQr3aVZFalHnpR0FGRt1V/urGgaUDavwRm8EMMxQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfKMabOZrKgaCbJiqpxQMmVAtHiGAW4eQ8ME6VJdVon5dvY7O5/ICHUIqyhbuQJoAMoUdplTyJjH7XvNDocz4IeLM4/3KshDnryA8qn9flRZUNiOWN50eBBbunTQlkuDJDmD1seVH7iZPww1b6UkYW9IWil6vwkvGMyuQFPncn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZzYGMIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZzYGMIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016BE1F000E9;
	Thu, 20 Aug 2026 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243257;
	bh=KKxpRB1f6LZVt90vl96jNog6cHzFcCteZpjNEj0K7Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZzYGMISWtt8v8ps5iBzn0Htv38Yn9sdI1nF+Y1yUDHZp576eQNUwJWVp6I02SgN8
	 rTisQLeSq5kBeHTS8QPhzouvRAUfi40vy3xm1z3WyzuskHB6bJZRADg9sJU+BT8Xzz
	 f85RxqrN8a5s2COck1nomAcgBBAOlqszifGLqv+I=
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
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/272] ipvs: separate destination availability state
Date: Thu, 20 Aug 2026 16:53:09 +0200
Message-ID: <20260820145231.396673865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
(cherry picked from commit cdcc4e46180df8161f4d2f3c6fd6beaf6990133d)
[ Julian: Backport by removing the hunks from ip_vs_xmit.c ]
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h              | 7 +++++++
 include/uapi/linux/ip_vs.h       | 6 ------
 net/netfilter/ipvs/ip_vs_conn.c  | 4 ++--
 net/netfilter/ipvs/ip_vs_core.c  | 6 +++---
 net/netfilter/ipvs/ip_vs_ctl.c   | 4 ++--
 net/netfilter/ipvs/ip_vs_dh.c    | 4 ++--
 net/netfilter/ipvs/ip_vs_lblc.c  | 2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c | 8 ++++----
 8 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 7d32968f2b133..2e3ef3980c01f 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -33,6 +33,12 @@
 #define IP_VS_HDR_INVERSE	1
 #define IP_VS_HDR_ICMP		2
 
+/* Destination Server Flags */
+#define IP_VS_DEST_F_OVERLOAD	0x0002		/* server is overloaded */
+
+/* Destination Server Config Flags */
+#define IP_VS_DEST_CF_AVAILABLE	0x0001		/* server is available */
+
 /* Generic access of ipvs struct */
 static inline struct netns_ipvs *net_ipvs(struct net* net)
 {
@@ -664,6 +670,7 @@ struct ip_vs_dest {
 	volatile unsigned int	flags;		/* dest status flags */
 	atomic_t		conn_flags;	/* flags to copy to conn */
 	atomic_t		weight;		/* server weight */
+	unsigned long		cflags;		/* config flags */
 	atomic_t		last_weight;	/* server latest weight */
 	__u16			tun_type;	/* tunnel type */
 	__be16			tun_port;	/* tunnel port */
diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 4102ddcb4e14e..9e4a762f31d83 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -28,12 +28,6 @@
 #define IP_VS_SVC_F_SCHED_SH_FALLBACK	IP_VS_SVC_F_SCHED1 /* SH fallback */
 #define IP_VS_SVC_F_SCHED_SH_PORT	IP_VS_SVC_F_SCHED2 /* SH use port */
 
-/*
- *      Destination Server Flags
- */
-#define IP_VS_DEST_F_AVAILABLE	0x0001		/* server is available */
-#define IP_VS_DEST_F_OVERLOAD	0x0002		/* server is overloaded */
-
 /*
  *      IPVS sync daemon states
  */
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index b850c254b9588..73361a4df43b4 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -759,7 +759,7 @@ int ip_vs_check_template(struct ip_vs_conn *ct, struct ip_vs_dest *cdest)
 	 * Checking the dest server status.
 	 */
 	if ((dest == NULL) ||
-	    !(dest->flags & IP_VS_DEST_F_AVAILABLE) ||
+	    !(dest->cflags & IP_VS_DEST_CF_AVAILABLE) ||
 	    expire_quiescent_template(ipvs, dest) ||
 	    (cdest && (dest != cdest))) {
 		IP_VS_DBG_BUF(9, "check_template: dest not available for "
@@ -1402,7 +1402,7 @@ void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
 				continue;
 
 			dest = cp->dest;
-			if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
+			if (!dest || (dest->cflags & IP_VS_DEST_CF_AVAILABLE))
 				continue;
 
 			if (atomic_read(&cp->n_control))
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 99cc39036c4e9..aaad3ccb0bb5d 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -124,7 +124,7 @@ ip_vs_in_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 	struct ip_vs_dest *dest = cp->dest;
 	struct netns_ipvs *ipvs = cp->ipvs;
 
-	if (dest && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (dest && (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		struct ip_vs_cpu_stats *s;
 		struct ip_vs_service *svc;
 
@@ -160,7 +160,7 @@ ip_vs_out_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 	struct ip_vs_dest *dest = cp->dest;
 	struct netns_ipvs *ipvs = cp->ipvs;
 
-	if (dest && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (dest && (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		struct ip_vs_cpu_stats *s;
 		struct ip_vs_service *svc;
 
@@ -2084,7 +2084,7 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	}
 
 	/* Check the server status */
-	if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (cp && cp->dest && !(cp->dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		/* the destination server is not available */
 		if (sysctl_expire_nodest_conn(ipvs)) {
 			bool old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 025512d76db06..2ded17b67819a 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -961,7 +961,7 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	}
 
 	/* set the dest status flags */
-	dest->flags |= IP_VS_DEST_F_AVAILABLE;
+	dest->cflags |= IP_VS_DEST_CF_AVAILABLE;
 
 	if (READ_ONCE(dest->u_threshold) != udest->u_threshold ||
 	    READ_ONCE(dest->l_threshold) != udest->l_threshold) {
@@ -1240,7 +1240,7 @@ static void __ip_vs_unlink_dest(struct ip_vs_service *svc,
 				struct ip_vs_dest *dest,
 				int svcupd)
 {
-	dest->flags &= ~IP_VS_DEST_F_AVAILABLE;
+	dest->cflags &= ~IP_VS_DEST_CF_AVAILABLE;
 
 	/*
 	 *  Remove it from the d-linked destination list.
diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
index 5e6ec32aff2b1..6d88bb4bf4ae8 100644
--- a/net/netfilter/ipvs/ip_vs_dh.c
+++ b/net/netfilter/ipvs/ip_vs_dh.c
@@ -220,8 +220,8 @@ ip_vs_dh_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 	s = (struct ip_vs_dh_state *) svc->sched_data;
 	dest = ip_vs_dh_get(svc->af, s, &iph->daddr);
-	if (!dest
-	    || !(dest->flags & IP_VS_DEST_F_AVAILABLE)
+	if (!dest ||
+	    !(dest->cflags & IP_VS_DEST_CF_AVAILABLE)
 	    || atomic_read(&dest->weight) <= 0
 	    || is_overloaded(dest)) {
 		ip_vs_scheduler_err(svc, "no destination available");
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 7ac7473e3804c..e2480f33a1963 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -503,7 +503,7 @@ ip_vs_lblc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		 */
 
 		dest = en->dest;
-		if ((dest->flags & IP_VS_DEST_F_AVAILABLE) &&
+		if ((dest->cflags & IP_VS_DEST_CF_AVAILABLE) &&
 		    atomic_read(&dest->weight) > 0 && !is_overloaded(dest, svc))
 			goto out;
 	}
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 77c323c36a889..7469547c8a440 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -170,8 +170,8 @@ static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
 		if (least->flags & IP_VS_DEST_F_OVERLOAD)
 			continue;
 
-		if ((atomic_read(&least->weight) > 0)
-		    && (least->flags & IP_VS_DEST_F_AVAILABLE)) {
+		if ((atomic_read(&least->weight) > 0) &&
+		    (least->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 			loh = ip_vs_dest_conn_overhead(least);
 			goto nextstage;
 		}
@@ -187,8 +187,8 @@ static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
 
 		doh = ip_vs_dest_conn_overhead(dest);
 		if (((__s64)loh * atomic_read(&dest->weight) >
-		     (__s64)doh * atomic_read(&least->weight))
-		    && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+		     (__s64)doh * atomic_read(&least->weight)) &&
+		    (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 			least = dest;
 			loh = doh;
 		}
-- 
2.53.0



