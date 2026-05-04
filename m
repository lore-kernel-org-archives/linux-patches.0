Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B67377575;
	Mon,  4 May 2026 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903992; cv=none; b=hb/PhO3m7e6Xw+Nay1lpbctSSv2DvxdsMRN3vPh4AurG28mppyrJNCOD05CgFicBJbqtcKulKSmGPuw7/d02rCzZXVTx1Kw3+iF23C3LeMw70mX+Ln2q+nfbbI5yepZitBU0+w7sX6KfkSodc0KSUUpxAoOVBCWj6XiJck1wj6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903992; c=relaxed/simple;
	bh=PiWrmpMgBguGHwWaU9DTf2axadua6xQAn+fnOzWxiAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTAI8i0xCxnpB56ZbTYC2/YySEnReui0enIuRkW89CvTuiULrCPys8aGoKgBxzERIpfvly7hG66orNxorYU7UPKPYqJu5AxvLMPk0G1x/X6Iq59Om8PktpsG7MCZeRLYnv5g6rvJSVStmN4BNWOj8dvYjAi7NnvFfmERcG+aBoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2s0/T2GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2s0/T2GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F10C2BCB8;
	Mon,  4 May 2026 14:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903992;
	bh=PiWrmpMgBguGHwWaU9DTf2axadua6xQAn+fnOzWxiAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2s0/T2GUyyDKYgxHTW3KM08NVucEJ41tVnRqy8fiGodhWzD1u3lBmpSBCkbEzTo/2
	 XQzqQF9I9KrasovzIegzt4/Go2WZ06UzYpstkR9TXRoKudhhXWHWcSH1J9XyvcW0mz
	 t0Xhjj0Yik5Ks+ipdVx/n9NhVJE47ASuRSW24bO4=
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
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 124/275] net: bridge: use a stable FDB dst snapshot in RCU readers
Date: Mon,  4 May 2026 15:51:04 +0200
Message-ID: <20260504135147.511497115@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Zhengchuan Liang <zcliangcn@gmail.com>

commit df4601653201de21b487c3e7fffd464790cab808 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_arp_nd_proxy.c |    8 +++++---
 net/bridge/br_fdb.c          |   28 ++++++++++++++++++----------
 2 files changed, 23 insertions(+), 13 deletions(-)

--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -202,11 +202,12 @@ void br_do_proxy_suppress_arp(struct sk_
 
 		f = br_fdb_find_rcu(br, n->ha, vid);
 		if (f) {
+			const struct net_bridge_port *dst = READ_ONCE(f->dst);
 			bool replied = false;
 
 			if ((p && (p->flags & BR_PROXYARP)) ||
-			    (f->dst && (f->dst->flags & BR_PROXYARP_WIFI)) ||
-			    br_is_neigh_suppress_enabled(f->dst, vid)) {
+			    (dst && (dst->flags & BR_PROXYARP_WIFI)) ||
+			    br_is_neigh_suppress_enabled(dst, vid)) {
 				if (!vid)
 					br_arp_send(br, p, skb->dev, sip, tip,
 						    sha, n->ha, sha, 0, 0);
@@ -470,9 +471,10 @@ void br_do_suppress_nd(struct sk_buff *s
 
 		f = br_fdb_find_rcu(br, n->ha, vid);
 		if (f) {
+			const struct net_bridge_port *dst = READ_ONCE(f->dst);
 			bool replied = false;
 
-			if (br_is_neigh_suppress_enabled(f->dst, vid)) {
+			if (br_is_neigh_suppress_enabled(dst, vid)) {
 				if (vid != 0)
 					br_nd_send(br, p, skb, n,
 						   skb->vlan_proto,
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -236,6 +236,7 @@ struct net_device *br_fdb_find_port(cons
 				    const unsigned char *addr,
 				    __u16 vid)
 {
+	const struct net_bridge_port *dst;
 	struct net_bridge_fdb_entry *f;
 	struct net_device *dev = NULL;
 	struct net_bridge *br;
@@ -248,8 +249,11 @@ struct net_device *br_fdb_find_port(cons
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
@@ -346,7 +350,7 @@ static void fdb_delete_local(struct net_
 		vg = nbp_vlan_group(op);
 		if (op != p && ether_addr_equal(op->dev->dev_addr, addr) &&
 		    (!vid || br_vlan_find(vg, vid))) {
-			f->dst = op;
+			WRITE_ONCE(f->dst, op);
 			clear_bit(BR_FDB_ADDED_BY_USER, &f->flags);
 			return;
 		}
@@ -357,7 +361,7 @@ static void fdb_delete_local(struct net_
 	/* Maybe bridge device has same hw addr? */
 	if (p && ether_addr_equal(br->dev->dev_addr, addr) &&
 	    (!vid || (v && br_vlan_should_use(v)))) {
-		f->dst = NULL;
+		WRITE_ONCE(f->dst, NULL);
 		clear_bit(BR_FDB_ADDED_BY_USER, &f->flags);
 		return;
 	}
@@ -928,6 +932,7 @@ int br_fdb_test_addr(struct net_device *
 int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 		   unsigned long maxnum, unsigned long skip)
 {
+	const struct net_bridge_port *dst;
 	struct net_bridge_fdb_entry *f;
 	struct __fdb_entry *fe = buf;
 	unsigned long delta;
@@ -944,7 +949,8 @@ int br_fdb_fillbuf(struct net_bridge *br
 			continue;
 
 		/* ignore pseudo entry for local MAC address */
-		if (!f->dst)
+		dst = READ_ONCE(f->dst);
+		if (!dst)
 			continue;
 
 		if (skip) {
@@ -956,8 +962,8 @@ int br_fdb_fillbuf(struct net_bridge *br
 		memcpy(fe->mac_addr, f->key.addr.addr, ETH_ALEN);
 
 		/* due to ABI compat need to split into hi/lo */
-		fe->port_no = f->dst->port_no;
-		fe->port_hi = f->dst->port_no >> 8;
+		fe->port_no = dst->port_no;
+		fe->port_hi = dst->port_no >> 8;
 
 		fe->is_local = test_bit(BR_FDB_LOCAL, &f->flags);
 		if (!test_bit(BR_FDB_STATIC, &f->flags)) {
@@ -1083,9 +1089,11 @@ int br_fdb_dump(struct sk_buff *skb,
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
+		const struct net_bridge_port *dst = READ_ONCE(f->dst);
+
 		if (*idx < ctx->fdb_idx)
 			goto skip;
-		if (filter_dev && (!f->dst || f->dst->dev != filter_dev)) {
+		if (filter_dev && (!dst || dst->dev != filter_dev)) {
 			if (filter_dev != dev)
 				goto skip;
 			/* !f->dst is a special case for bridge
@@ -1093,10 +1101,10 @@ int br_fdb_dump(struct sk_buff *skb,
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


