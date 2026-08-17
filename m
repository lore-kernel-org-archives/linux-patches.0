Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD1843E07D;
	Mon, 17 Aug 2026 13:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974272; cv=none; b=WALlHVUTGGrOQ4Ml/3mKZ4gh0EqGR9fl4Sk6t70pN0p1PyHVhbm0kKt/s7fPqeO9zQ6k4wu0s19B3tF33LgsHXSyQqkDfsu8RZBrxqSrD/r7MG6nPzm5iuLTqIH2IamIW/GDT30ERbTwEHzST3M6BGGbb0ZLtyJMPAn8dC1M/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974272; c=relaxed/simple;
	bh=Vpmgc1A1Mx1Vp5EIXlCszyqEY+bC7LeHK/Rbc1FKyqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl3PoW5wSzTFDQ4t9IslouRHwaCRozwb+EAF3dwvIZTEwlGJfnkOZDQuIonRmQYUf04lGL6rO3OcKDzWiBjhYCpOA9khmPMzmpFvTEG19r7SSnDcYDICLhHpRwuTu3uRE+EbsclFuoD8YSXSdEnOcO2EKvn2i09AhL9auaZvXV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRRKE3Mw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRRKE3Mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60F61F00A3D;
	Mon, 17 Aug 2026 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974261;
	bh=TZ/iR26Vg53kZEBCYxgUX/RfdeISiPdVOZ70rd8w2uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRRKE3MwAfZQxQZo18DB8ikIB8+LHg1TCAwwTAQufxqmjr4ktVL0cIISwtSOA719b
	 k41MVJAKb04PNel0/EQShgCUjaR8D/eStBmrhs71petEKP33rsAAZ2JS+bs/pg/DDH
	 i2G+oRnaPIugP8J/Lo5A3VOdDY0wavFvgq+z5mYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.1 145/271] ipvs: add totalconns for dest
Date: Mon, 17 Aug 2026 15:31:10 +0200
Message-ID: <20260817132542.829691919@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

commit 04d2feaed8d0103c498727191ba04001d5100e67 upstream.

Replace the inactconns dest counter with totalconns, now
inactconns can be obtained from totalconns - activeconns.
This reduces the atomic inc/dec ops for TCP/SCTP from
6 to 4 if the connection is established and then closed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_vs.h                   |   17 ++++++++++++-----
 net/netfilter/ipvs/ip_vs_conn.c       |   24 +++++++-----------------
 net/netfilter/ipvs/ip_vs_ctl.c        |   10 +++++-----
 net/netfilter/ipvs/ip_vs_lc.c         |    4 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c |    2 --
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |    2 --
 net/netfilter/ipvs/ip_vs_sync.c       |    7 ++-----
 7 files changed, 28 insertions(+), 38 deletions(-)

--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -979,7 +979,7 @@ struct ip_vs_dest {
 
 	/* connection counters and thresholds */
 	atomic_t		activeconns;	/* active connections */
-	atomic_t		inactconns;	/* inactive connections */
+	atomic_t		totalconns;	/* total connections */
 	atomic_t		persistconns;	/* persistent connections */
 	__u32			u_threshold;	/* upper threshold */
 	__u32			l_threshold;	/* lower threshold */
@@ -2198,14 +2198,21 @@ void ip_vs_unregister_hooks(struct netns
 static inline int
 ip_vs_dest_conn_overhead(struct ip_vs_dest *dest)
 {
-	/* We think the overhead of processing active connections is 256
+	/* We think the overhead of processing active connections is 257
 	 * times higher than that of inactive connections in average. (This
-	 * 256 times might not be accurate, we will change it later) We
+	 * 257 times might not be accurate, we will change it later) We
 	 * use the following formula to estimate the overhead now:
-	 *		  dest->activeconns*256 + dest->inactconns
+	 *		  dest->activeconns*256 + dest->totalconns
 	 */
 	return (atomic_read(&dest->activeconns) << 8) +
-		atomic_read(&dest->inactconns);
+		atomic_read(&dest->totalconns);
+}
+
+static inline int
+ip_vs_dest_inactconns(const struct ip_vs_dest *dest)
+{
+	return max(atomic_read(&dest->totalconns) -
+		   atomic_read(&dest->activeconns), 0);
 }
 
 #ifdef CONFIG_IP_VS_PROTO_TCP
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1081,12 +1081,6 @@ static inline void ip_vs_bind_xmit_v6(st
 #endif
 
 
-static inline int ip_vs_dest_totalconns(struct ip_vs_dest *dest)
-{
-	return atomic_read(&dest->activeconns)
-		+ atomic_read(&dest->inactconns);
-}
-
 /*
  *	Bind a connection entry with a virtual service destination
  *	Called just after a new connection entry is created.
@@ -1153,8 +1147,7 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, s
 		 */
 		if (!(flags & IP_VS_CONN_F_INACTIVE))
 			atomic_inc(&dest->activeconns);
-		else
-			atomic_inc(&dest->inactconns);
+		atomic_inc(&dest->totalconns);
 	} else {
 		/* It is a persistent connection/template, so increase
 		   the persistent connection counter */
@@ -1162,7 +1155,7 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, s
 	}
 
 	if (dest->u_threshold != 0 &&
-	    ip_vs_dest_totalconns(dest) >= dest->u_threshold)
+	    atomic_read(&dest->totalconns) >= dest->u_threshold)
 		dest->flags |= IP_VS_DEST_F_OVERLOAD;
 }
 
@@ -1244,13 +1237,10 @@ static inline void ip_vs_unbind_dest(str
 
 	/* Update the connection counters */
 	if (!(cp->flags & IP_VS_CONN_F_TEMPLATE)) {
-		/* It is a normal connection, so decrease the inactconns
-		   or activeconns counter */
-		if (cp->flags & IP_VS_CONN_F_INACTIVE) {
-			atomic_dec(&dest->inactconns);
-		} else {
+		/* It is a normal connection, so decrease the counters */
+		if (!(cp->flags & IP_VS_CONN_F_INACTIVE))
 			atomic_dec(&dest->activeconns);
-		}
+		atomic_dec(&dest->totalconns);
 	} else {
 		/* It is a persistent connection/template, so decrease
 		   the persistent connection counter */
@@ -1258,10 +1248,10 @@ static inline void ip_vs_unbind_dest(str
 	}
 
 	if (dest->l_threshold != 0) {
-		if (ip_vs_dest_totalconns(dest) < dest->l_threshold)
+		if (atomic_read(&dest->totalconns) < dest->l_threshold)
 			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
 	} else if (dest->u_threshold != 0) {
-		if (ip_vs_dest_totalconns(dest) * 4 < dest->u_threshold * 3)
+		if (atomic_read(&dest->totalconns) * 4 < dest->u_threshold * 3)
 			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
 	} else {
 		if (dest->flags & IP_VS_DEST_F_OVERLOAD)
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1445,7 +1445,7 @@ ip_vs_new_dest(struct ip_vs_service *svc
 	dest->port = udest->port;
 
 	atomic_set(&dest->activeconns, 0);
-	atomic_set(&dest->inactconns, 0);
+	atomic_set(&dest->totalconns, 0);
 	atomic_set(&dest->persistconns, 0);
 	refcount_set(&dest->refcnt, 1);
 
@@ -2986,7 +2986,7 @@ static int ip_vs_info_seq_show(struct se
 					   ip_vs_fwd_name(atomic_read(&dest->conn_flags)),
 					   atomic_read(&dest->weight),
 					   atomic_read(&dest->activeconns),
-					   atomic_read(&dest->inactconns));
+					   ip_vs_dest_inactconns(dest));
 			else
 #endif
 				seq_printf(seq,
@@ -2997,7 +2997,7 @@ static int ip_vs_info_seq_show(struct se
 					   ip_vs_fwd_name(atomic_read(&dest->conn_flags)),
 					   atomic_read(&dest->weight),
 					   atomic_read(&dest->activeconns),
-					   atomic_read(&dest->inactconns));
+					   ip_vs_dest_inactconns(dest));
 
 		}
 	}
@@ -3625,7 +3625,7 @@ __ip_vs_get_dest_entries(struct netns_ip
 			entry.u_threshold = dest->u_threshold;
 			entry.l_threshold = dest->l_threshold;
 			entry.activeconns = atomic_read(&dest->activeconns);
-			entry.inactconns = atomic_read(&dest->inactconns);
+			entry.inactconns = ip_vs_dest_inactconns(dest);
 			entry.persistconns = atomic_read(&dest->persistconns);
 			ip_vs_copy_stats(&kstats, &dest->stats);
 			ip_vs_export_stats_user(&entry.stats, &kstats);
@@ -4237,7 +4237,7 @@ static int ip_vs_genl_fill_dest(struct s
 	    nla_put_u32(skb, IPVS_DEST_ATTR_ACTIVE_CONNS,
 			atomic_read(&dest->activeconns)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_INACT_CONNS,
-			atomic_read(&dest->inactconns)) ||
+			ip_vs_dest_inactconns(dest)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_PERSIST_CONNS,
 			atomic_read(&dest->persistconns)) ||
 	    nla_put_u16(skb, IPVS_DEST_ATTR_ADDR_FAMILY, dest->af))
--- a/net/netfilter/ipvs/ip_vs_lc.c
+++ b/net/netfilter/ipvs/ip_vs_lc.c
@@ -30,7 +30,7 @@ ip_vs_lc_schedule(struct ip_vs_service *
 
 	/*
 	 * Simply select the server with the least number of
-	 *        (activeconns<<5) + inactconns
+	 *        (activeconns*256) + totalconns
 	 * Except whose weight is equal to zero.
 	 * If the weight is equal to zero, it means that the server is
 	 * quiesced, the existing connections to the server still get
@@ -56,7 +56,7 @@ ip_vs_lc_schedule(struct ip_vs_service *
 			      IP_VS_DBG_ADDR(least->af, &least->addr),
 			      ntohs(least->port),
 			      atomic_read(&least->activeconns),
-			      atomic_read(&least->inactconns));
+			      ip_vs_dest_inactconns(least));
 
 	return least;
 }
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -446,12 +446,10 @@ set_sctp_state(struct ip_vs_proto_data *
 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
 				(next_state != IP_VS_SCTP_S_ESTABLISHED)) {
 				atomic_dec(&dest->activeconns);
-				atomic_inc(&dest->inactconns);
 				cp->flags |= IP_VS_CONN_F_INACTIVE;
 			} else if ((cp->flags & IP_VS_CONN_F_INACTIVE) &&
 				   (next_state == IP_VS_SCTP_S_ESTABLISHED)) {
 				atomic_inc(&dest->activeconns);
-				atomic_dec(&dest->inactconns);
 				cp->flags &= ~IP_VS_CONN_F_INACTIVE;
 			}
 		}
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -526,12 +526,10 @@ set_tcp_state(struct ip_vs_proto_data *p
 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
 			    !tcp_state_active(new_state)) {
 				atomic_dec(&dest->activeconns);
-				atomic_inc(&dest->inactconns);
 				cp->flags |= IP_VS_CONN_F_INACTIVE;
 			} else if ((cp->flags & IP_VS_CONN_F_INACTIVE) &&
 				   tcp_state_active(new_state)) {
 				atomic_inc(&dest->activeconns);
-				atomic_dec(&dest->inactconns);
 				cp->flags &= ~IP_VS_CONN_F_INACTIVE;
 			}
 		}
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -878,13 +878,10 @@ static void ip_vs_proc_conn(struct netns
 		spin_lock_bh(&cp->lock);
 		if ((cp->flags ^ flags) & IP_VS_CONN_F_INACTIVE &&
 		    !(flags & IP_VS_CONN_F_TEMPLATE) && dest) {
-			if (flags & IP_VS_CONN_F_INACTIVE) {
+			if (flags & IP_VS_CONN_F_INACTIVE)
 				atomic_dec(&dest->activeconns);
-				atomic_inc(&dest->inactconns);
-			} else {
+			else
 				atomic_inc(&dest->activeconns);
-				atomic_dec(&dest->inactconns);
-			}
 		}
 		flags &= IP_VS_CONN_F_BACKUP_UPD_MASK;
 		flags |= cp->flags & ~IP_VS_CONN_F_BACKUP_UPD_MASK;


