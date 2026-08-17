Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E434399D7;
	Mon, 17 Aug 2026 13:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974269; cv=none; b=GsoNMKTWIniaLevpqe8Os+KH4bTtW3f0I464zxjSm3i2SNXJZGO96mS5tXYRdmKpzlWoq/1TddZK3suLcGYrz/jlfg854IRt7CcPCuBNteu0siGhHS52KuhW8BM0VYKyVAQwmlMXOjw7w+42T2RwRTv6+t6TD9AhZqDrV2F+fUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974269; c=relaxed/simple;
	bh=WsBXY2Sr0cYFD5ZRnlvcKQVjoPBGShybBffB7pqhI0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTy0Zsgtlbch/InyNiSr+HJ9+ESjYzmQUkUF7w8sRdYzEy4eiyfMUbXwexzt9IXgwxXucHuC7TAhps4MvR/cZhOiFZAuiTxVXDfe8ZbrElgXPYNdfXqsRfkT71sPOw8ravQeZcb2TECK0o5I+nTmr8shlqdgKRGwcsvQ2/ZJWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7Honozg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7Honozg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D071F00A3E;
	Mon, 17 Aug 2026 13:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974264;
	bh=Bgwnz5QBhEEvCUXE7RDuSjPXZ9U8iIzGkZUgOY7GU4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7HonozgDiYa/40zGHGdDoOP0YbRo5d6bcGeIo2ok4DbmJcv1QdQlKSImiAcx8VrB
	 CGIkaWdCj6vE3g2/mrNCjCPvpgV49ES8UUaaI17qZaSDiiQipUPbuchiCcesLTiJHi
	 D743YUy0wPjCsLzhG8FpmvdXg9Z2Aw0WrhhoWxWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.1 146/271] ipvs: properly update the overload flag on dest edit
Date: Mon, 17 Aug 2026 15:31:11 +0200
Message-ID: <20260817132542.875833153@linuxfoundation.org>
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
@@ -983,6 +983,7 @@ struct ip_vs_dest {
 	atomic_t		persistconns;	/* persistent connections */
 	__u32			u_threshold;	/* upper threshold */
 	__u32			l_threshold;	/* lower threshold */
+	__u32			l_threshold_val;/* used lower threshold */
 
 	/* for destination cache */
 	spinlock_t		dst_lock;	/* lock of dst_cache */
@@ -1885,6 +1886,8 @@ static inline void ip_vs_dest_put_and_fr
 		kfree(dest);
 }
 
+void ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode);
+
 /* IPVS sync daemon data and function prototypes
  * (from ip_vs_sync.c)
  */
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1141,22 +1141,22 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, s
 
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
 
 
@@ -1237,27 +1237,20 @@ static inline void ip_vs_unbind_dest(str
 
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
@@ -1304,6 +1304,40 @@ void ip_vs_stats_free(struct ip_vs_stats
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
@@ -1370,10 +1404,19 @@ __ip_vs_update_dest(struct ip_vs_service
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
 
@@ -1486,6 +1529,9 @@ ip_vs_add_dest(struct ip_vs_service *svc
 		return -ERANGE;
 	}
 
+	if (udest->u_threshold > INT_MAX)
+		return -EINVAL;
+
 	if (udest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		if (udest->tun_port == 0) {
 			pr_err("%s(): tunnel port is zero\n", __func__);
@@ -1559,6 +1605,9 @@ ip_vs_edit_dest(struct ip_vs_service *sv
 		return -ERANGE;
 	}
 
+	if (udest->u_threshold > INT_MAX)
+		return -EINVAL;
+
 	if (udest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		if (udest->tun_port == 0) {
 			pr_err("%s(): tunnel port is zero\n", __func__);
@@ -3622,8 +3671,8 @@ __ip_vs_get_dest_entries(struct netns_ip
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
@@ -4232,8 +4281,10 @@ static int ip_vs_genl_fill_dest(struct s
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


