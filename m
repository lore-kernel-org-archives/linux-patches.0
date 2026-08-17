Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972B33F0ABE;
	Mon, 17 Aug 2026 13:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975006; cv=none; b=uXhNQsq0fZPveCk889epa7Hxkrr1WnPMeLDBaxD+OseDgBLYE0BdVT/DHqgkyCJj6tBhWsYf1BnWcD40r9KSLFsBJS1Grg0wn6ew5uq5etdxwVW7PTdUb1V3sSOLKeDFioSMTXCYPH+jS4zIkU0UayPN0On+XobX+NFEh2chVMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975006; c=relaxed/simple;
	bh=Xffu3jfAsKjhUWLOJs4ATEiPvkKEXuXr4e/c+XXKSbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HY5C4MB7xIADlsfwcDUccPpAv1p9JI0Wd3FB+1iU4+2ajjqGSbmlJaZEo2b5x+hgaA/S0jSepPByIEIJVQMUoA3QadGJBfDdPxkQW/BynTbVWiRFIf+Ebovu0u7E4GYAALwBXBzLSejuBVnldz7/x2JZ7eoeoGrkXMrFOEYYNH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHEWMQ3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHEWMQ3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E221F000E9;
	Mon, 17 Aug 2026 13:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975004;
	bh=EkQFVKk5nZsGpPNQCzBp4/Y/DHr71u9CSX/f86XNfeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHEWMQ3TQjiQsihdtVaVtuwpSnX8K+xYGL1sLW4TJkQwIfNng71TN6hmQJKoCB/Gt
	 pPc/CCZ2i5AoEorzWC82kK9VVJobAz+miOez4ygK/3+kRVZeRgpU5uoPET2u1zuZ/q
	 QV4oonztX8frfw2UCPZmNQREcr2eI9Qe0bNqXuwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 130/250] ipvs: properly update the overload flag on dest edit
Date: Mon, 17 Aug 2026 15:31:31 +0200
Message-ID: <20260817132541.903596821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

commit 8f843441c4e7eae8ea83491e8c203c2b192edcf5 upstream.

The upper/lower connection thresholds for dest can be changed,
so use ip_vs_dest_update_overload() to properly update the
dest overload flag.

The thresholds were not limited, fit them in the 0 .. INT_MAX
range as already done in ipvsadm.

As the thresholds are also read when connections are created
and expired, use WRITE_ONCE/READ_ONCE to access them.

As the lower threshold is optional, use (u - (u >> 2)) to
calculate the 75% default value based on the upper threshold
by preserving the integer rounding, as suggested by Yizhou Zhao.

Trigger flag update when totalconns reaches one of the
thresholds and use dst_lock to serialize the updating.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_vs.h             |    3 +
 net/netfilter/ipvs/ip_vs_conn.c |   27 +++++-----------
 net/netfilter/ipvs/ip_vs_ctl.c  |   67 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 72 insertions(+), 25 deletions(-)

--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -740,6 +740,7 @@ struct ip_vs_dest {
 	atomic_t		persistconns;	/* persistent connections */
 	__u32			u_threshold;	/* upper threshold */
 	__u32			l_threshold;	/* lower threshold */
+	__u32			l_threshold_val;/* used lower threshold */
 
 	/* for destination cache */
 	spinlock_t		dst_lock;	/* lock of dst_cache */
@@ -1580,6 +1581,8 @@ static inline void ip_vs_dest_put_and_fr
 		kfree(dest);
 }
 
+void ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode);
+
 /* IPVS sync daemon data and function prototypes
  * (from ip_vs_sync.c)
  */
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -621,22 +621,22 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, s
 
 	/* Update the connection counters */
 	if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
+		int tc;
+
 		/* It is a normal connection, so modify the counters
 		 * according to the flags, later the protocol can
 		 * update them on state change
 		 */
 		if (!(flags & IP_VS_CONN_F_INACTIVE))
 			atomic_inc(&dest->activeconns);
-		atomic_inc(&dest->totalconns);
+		tc = atomic_inc_return(&dest->totalconns);
+		if (tc == READ_ONCE(dest->u_threshold))
+			ip_vs_dest_update_overload(dest, 1);
 	} else {
 		/* It is a persistent connection/template, so increase
 		   the persistent connection counter */
 		atomic_inc(&dest->persistconns);
 	}
-
-	if (dest->u_threshold != 0 &&
-	    atomic_read(&dest->totalconns) >= dest->u_threshold)
-		dest->flags |= IP_VS_DEST_F_OVERLOAD;
 }
 
 
@@ -717,27 +717,20 @@ static inline void ip_vs_unbind_dest(str
 
 	/* Update the connection counters */
 	if (!(cp->flags & IP_VS_CONN_F_TEMPLATE)) {
+		int tc;
+
 		/* It is a normal connection, so decrease the counters */
 		if (!(cp->flags & IP_VS_CONN_F_INACTIVE))
 			atomic_dec(&dest->activeconns);
-		atomic_dec(&dest->totalconns);
+		tc = atomic_fetch_dec(&dest->totalconns);
+		if (tc == READ_ONCE(dest->l_threshold_val))
+			ip_vs_dest_update_overload(dest, -1);
 	} else {
 		/* It is a persistent connection/template, so decrease
 		   the persistent connection counter */
 		atomic_dec(&dest->persistconns);
 	}
 
-	if (dest->l_threshold != 0) {
-		if (atomic_read(&dest->totalconns) < dest->l_threshold)
-			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
-	} else if (dest->u_threshold != 0) {
-		if (atomic_read(&dest->totalconns) * 4 < dest->u_threshold * 3)
-			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
-	} else {
-		if (dest->flags & IP_VS_DEST_F_OVERLOAD)
-			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
-	}
-
 	ip_vs_dest_put(dest);
 }
 
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -960,6 +960,40 @@ void ip_vs_stats_free(struct ip_vs_stats
 	}
 }
 
+/* Update overload flag based on number of dest conns and lower/upper
+ * connection thresholds:
+ * - conns reach u_threshold and exceed it: set the flag
+ * - conns go below l_threshold (or 75% of u_threshold): clear the flag
+ */
+static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode)
+{
+	int conns;
+	u32 l, u;
+
+	lockdep_assert_held(&dest->dst_lock);
+	u = READ_ONCE(dest->u_threshold);
+	if (!u)
+		goto unset;
+	l = READ_ONCE(dest->l_threshold_val);
+	conns = atomic_read(&dest->totalconns);
+	if (conns >= (mode > 0 ? l : u)) {
+		dest->flags |= IP_VS_DEST_F_OVERLOAD;
+		return;
+	}
+	if (conns >= (mode < 0 ? u : l))
+		return;
+
+unset:
+	dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
+}
+
+void ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode)
+{
+	spin_lock_bh(&dest->dst_lock);
+	__ip_vs_dest_update_overload(dest, mode);
+	spin_unlock_bh(&dest->dst_lock);
+}
+
 /*
  *	Update a destination in the given service
  */
@@ -1026,10 +1060,19 @@ __ip_vs_update_dest(struct ip_vs_service
 	/* set the dest status flags */
 	dest->flags |= IP_VS_DEST_F_AVAILABLE;
 
-	if (udest->u_threshold == 0 || udest->u_threshold > dest->u_threshold)
-		dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
-	dest->u_threshold = udest->u_threshold;
-	dest->l_threshold = udest->l_threshold;
+	if (READ_ONCE(dest->u_threshold) != udest->u_threshold ||
+	    READ_ONCE(dest->l_threshold) != udest->l_threshold) {
+		spin_lock_bh(&dest->dst_lock);
+		WRITE_ONCE(dest->u_threshold, udest->u_threshold);
+		WRITE_ONCE(dest->l_threshold, udest->l_threshold);
+		/* Low threshold defaults to 75% of upper threshold */
+		WRITE_ONCE(dest->l_threshold_val,
+			   udest->l_threshold ? :
+			   (udest->u_threshold -
+			    (udest->u_threshold >> 2)));
+		__ip_vs_dest_update_overload(dest, 0);
+		spin_unlock_bh(&dest->dst_lock);
+	}
 
 	dest->af = udest->af;
 
@@ -1142,6 +1185,9 @@ ip_vs_add_dest(struct ip_vs_service *svc
 		return -ERANGE;
 	}
 
+	if (udest->u_threshold > INT_MAX)
+		return -EINVAL;
+
 	if (udest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		if (udest->tun_port == 0) {
 			pr_err("%s(): tunnel port is zero\n", __func__);
@@ -1212,6 +1258,9 @@ ip_vs_edit_dest(struct ip_vs_service *sv
 		return -ERANGE;
 	}
 
+	if (udest->u_threshold > INT_MAX)
+		return -EINVAL;
+
 	if (udest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		if (udest->tun_port == 0) {
 			pr_err("%s(): tunnel port is zero\n", __func__);
@@ -2951,8 +3000,8 @@ __ip_vs_get_dest_entries(struct netns_ip
 			entry.port = dest->port;
 			entry.conn_flags = atomic_read(&dest->conn_flags);
 			entry.weight = atomic_read(&dest->weight);
-			entry.u_threshold = dest->u_threshold;
-			entry.l_threshold = dest->l_threshold;
+			entry.u_threshold = READ_ONCE(dest->u_threshold);
+			entry.l_threshold = READ_ONCE(dest->l_threshold);
 			entry.activeconns = atomic_read(&dest->activeconns);
 			entry.inactconns = ip_vs_dest_inactconns(dest);
 			entry.persistconns = atomic_read(&dest->persistconns);
@@ -3553,8 +3602,10 @@ static int ip_vs_genl_fill_dest(struct s
 			 dest->tun_port) ||
 	    nla_put_u16(skb, IPVS_DEST_ATTR_TUN_FLAGS,
 			dest->tun_flags) ||
-	    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH, dest->u_threshold) ||
-	    nla_put_u32(skb, IPVS_DEST_ATTR_L_THRESH, dest->l_threshold) ||
+	    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH,
+			READ_ONCE(dest->u_threshold)) ||
+	    nla_put_u32(skb, IPVS_DEST_ATTR_L_THRESH,
+			READ_ONCE(dest->l_threshold)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_ACTIVE_CONNS,
 			atomic_read(&dest->activeconns)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_INACT_CONNS,


