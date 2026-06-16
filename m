Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF31243CEC7;
	Tue, 16 Jun 2026 18:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634512; cv=none; b=Rt6B3nz+3V9NU+DagoUDYPaEoZXKeLsWyKbW6+zQRv6J2pCRwpUlSs9NeEvpxdWG9p5QxaVc2kkrgmFpnko456yHe3Jb5+Sb0Ac0ThPxk4ckXSaS9MY8O/03F+kxl1plOStNh+l8qa7OWFSwvI43rp4GvZp6zhhVUYBekVfIlBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634512; c=relaxed/simple;
	bh=lm6DL8KZ1/xgxKNUpzVuxE8LScdr3c0nBh9kLEMLJTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icKIOWOhUBnCmwYWh8olI6wMeOeFzxFzom8QlhxXbMXkWcAVaiSghgPP7o7A4trk78zEMEYjQhPXuADbr9HxgSCkFe1kxT4VSX2DSoS0A/gghOjH7/0SXMWPsJ8yOKwATYfRhuu5lOQ6CD0/zeb41GjKwfmUQbO60Xx8qFQ9YK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zx3fqFVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zx3fqFVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BE51F000E9;
	Tue, 16 Jun 2026 18:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634511;
	bh=MZcEq8crLZIm2jpLQVdsv4+CmNXfC9lqmyOjWgZyJcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zx3fqFVamfxcS8mLigedu11VW2m9e3qiJuxml/Zkd1umPD6Fz7Ho479TTdcvtwjNR
	 PhvvpbIGd1dHBvd7v4XvmFlit6CwL+qXu8/OUzeB/WIwYSm6qqpUBGU5VNLfrSy9EH
	 dytwQYyV5Wv+Y85HuqVo90biRrNCNIH9IEocOzZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/411] net: bridge: use a stable FDB dst snapshot in RCU readers
Date: Tue, 16 Jun 2026 20:28:37 +0530
Message-ID: <20260616145115.979248465@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit df4601653201de21b487c3e7fffd464790cab808 ]

Local FDB entries can be rewritten in place by `fdb_delete_local()`, which
updates `f->dst` to another port or to `NULL` while keeping the entry
alive. Several bridge RCU readers inspect `f->dst`, including
`br_fdb_fillbuf()` through the `brforward_read()` sysfs path.

These readers currently load `f->dst` multiple times and can therefore
observe inconsistent values across the check and later dereference.
In `br_fdb_fillbuf()`, this means a concurrent local-FDB update can change
`f->dst` after the NULL check and before the `port_no` dereference,
leading to a NULL-ptr-deref.

Fix this by taking a single `READ_ONCE()` snapshot of `f->dst` in each
affected RCU reader and using that snapshot for the rest of the access
sequence. Also publish the in-place `f->dst` updates in `fdb_delete_local()`
with `WRITE_ONCE()` so the readers and writer use matching access patterns.

Fixes: 960b589f86c7 ("bridge: Properly check if local fdb entry can be deleted in br_fdb_change_mac_address")
Cc: stable@kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/6570fabb85ecadb8baaf019efe856f407711c7b9.1776043229.git.zcliangcn@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ kept combined-flag check `(dst->flags & (BR_PROXYARP_WIFI | BR_NEIGH_SUPPRESS))` and `cb->args[2]` indexing instead of `br_is_neigh_suppress_enabled()` helper and `ctx->fdb_idx` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_arp_nd_proxy.c |    8 +++++---
 net/bridge/br_fdb.c          |   28 ++++++++++++++++++----------
 2 files changed, 23 insertions(+), 13 deletions(-)

--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -199,11 +199,12 @@ void br_do_proxy_suppress_arp(struct sk_
 
 		f = br_fdb_find_rcu(br, n->ha, vid);
 		if (f) {
+			const struct net_bridge_port *dst = READ_ONCE(f->dst);
 			bool replied = false;
 
 			if ((p && (p->flags & BR_PROXYARP)) ||
-			    (f->dst && (f->dst->flags & (BR_PROXYARP_WIFI |
-							 BR_NEIGH_SUPPRESS)))) {
+			    (dst && (dst->flags & (BR_PROXYARP_WIFI |
+						   BR_NEIGH_SUPPRESS)))) {
 				if (!vid)
 					br_arp_send(br, p, skb->dev, sip, tip,
 						    sha, n->ha, sha, 0, 0);
@@ -463,9 +464,10 @@ void br_do_suppress_nd(struct sk_buff *s
 
 		f = br_fdb_find_rcu(br, n->ha, vid);
 		if (f) {
+			const struct net_bridge_port *dst = READ_ONCE(f->dst);
 			bool replied = false;
 
-			if (f->dst && (f->dst->flags & BR_NEIGH_SUPPRESS)) {
+			if (dst && (dst->flags & BR_NEIGH_SUPPRESS)) {
 				if (vid != 0)
 					br_nd_send(br, p, skb, n,
 						   skb->vlan_proto,
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -121,6 +121,7 @@ struct net_device *br_fdb_find_port(cons
 				    const unsigned char *addr,
 				    __u16 vid)
 {
+	const struct net_bridge_port *dst;
 	struct net_bridge_fdb_entry *f;
 	struct net_device *dev = NULL;
 	struct net_bridge *br;
@@ -133,8 +134,11 @@ struct net_device *br_fdb_find_port(cons
 	br = netdev_priv(br_dev);
 	rcu_read_lock();
 	f = br_fdb_find_rcu(br, addr, vid);
-	if (f && f->dst)
-		dev = f->dst->dev;
+	if (f) {
+		dst = READ_ONCE(f->dst);
+		if (dst)
+			dev = dst->dev;
+	}
 	rcu_read_unlock();
 
 	return dev;
@@ -224,7 +228,7 @@ static void fdb_delete_local(struct net_
 		vg = nbp_vlan_group(op);
 		if (op != p && ether_addr_equal(op->dev->dev_addr, addr) &&
 		    (!vid || br_vlan_find(vg, vid))) {
-			f->dst = op;
+			WRITE_ONCE(f->dst, op);
 			clear_bit(BR_FDB_ADDED_BY_USER, &f->flags);
 			return;
 		}
@@ -235,7 +239,7 @@ static void fdb_delete_local(struct net_
 	/* Maybe bridge device has same hw addr? */
 	if (p && ether_addr_equal(br->dev->dev_addr, addr) &&
 	    (!vid || (v && br_vlan_should_use(v)))) {
-		f->dst = NULL;
+		WRITE_ONCE(f->dst, NULL);
 		clear_bit(BR_FDB_ADDED_BY_USER, &f->flags);
 		return;
 	}
@@ -462,6 +466,7 @@ int br_fdb_test_addr(struct net_device *
 int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 		   unsigned long maxnum, unsigned long skip)
 {
+	const struct net_bridge_port *dst;
 	struct net_bridge_fdb_entry *f;
 	struct __fdb_entry *fe = buf;
 	int num = 0;
@@ -477,7 +482,8 @@ int br_fdb_fillbuf(struct net_bridge *br
 			continue;
 
 		/* ignore pseudo entry for local MAC address */
-		if (!f->dst)
+		dst = READ_ONCE(f->dst);
+		if (!dst)
 			continue;
 
 		if (skip) {
@@ -489,8 +495,8 @@ int br_fdb_fillbuf(struct net_bridge *br
 		memcpy(fe->mac_addr, f->key.addr.addr, ETH_ALEN);
 
 		/* due to ABI compat need to split into hi/lo */
-		fe->port_no = f->dst->port_no;
-		fe->port_hi = f->dst->port_no >> 8;
+		fe->port_no = dst->port_no;
+		fe->port_hi = dst->port_no >> 8;
 
 		fe->is_local = test_bit(BR_FDB_LOCAL, &f->flags);
 		if (!test_bit(BR_FDB_STATIC, &f->flags))
@@ -836,9 +842,11 @@ int br_fdb_dump(struct sk_buff *skb,
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
+		const struct net_bridge_port *dst = READ_ONCE(f->dst);
+
 		if (*idx < cb->args[2])
 			goto skip;
-		if (filter_dev && (!f->dst || f->dst->dev != filter_dev)) {
+		if (filter_dev && (!dst || dst->dev != filter_dev)) {
 			if (filter_dev != dev)
 				goto skip;
 			/* !f->dst is a special case for bridge
@@ -846,10 +854,10 @@ int br_fdb_dump(struct sk_buff *skb,
 			 * Therefore need a little more filtering
 			 * we only want to dump the !f->dst case
 			 */
-			if (f->dst)
+			if (dst)
 				goto skip;
 		}
-		if (!filter_dev && f->dst)
+		if (!filter_dev && dst)
 			goto skip;
 
 		err = fdb_fill_info(skb, br, f,


