Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3A119066C;
	Tue, 10 Sep 2024 10:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962612; cv=none; b=Z9FA8tedzLSsljCd/vkUiv21YSPizQdVwhPkfgZbfGqek0dJRT2k7JGa3mN35jcZAf4GLJ70Ckae/jqnJgHbqOuNsLjyaBd5/JY8srNp76Oor23dmjxu4dtIGO7EPGbfy9NNeLYsZ6MxTRU1KrxzWbH9Jq2dVK10mxXGHvQGWSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962612; c=relaxed/simple;
	bh=fVsWifwhvbNhVtKhlFkwtBI5zTcWYXpDDnyNPFMJ/80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKwtFEFkxj1moYwIIosnAoiWJSCFp//dNTARYd+76N3BN6F0Sy28YFaeZqQrmKjbWqOGEpdHvX3d5v96ig7pWg47OafJtPDbqt7bz6TE3jR4cKt6AHvhGL4xZZX2C1f/8mUcgeMiXFSd6ReUv3OKQZ8m0pU/SSY85QOR32Uz+48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cN4LkHCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cN4LkHCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028FEC4CEC3;
	Tue, 10 Sep 2024 10:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962612;
	bh=fVsWifwhvbNhVtKhlFkwtBI5zTcWYXpDDnyNPFMJ/80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cN4LkHCpPkVN2yM7LMDBzc/AIzQnIemsIiwRjllMGPBRDdn64SjdGoSmoYnLsYNvo
	 e5zcEHP6Wie7dJ+X7dNqR+/t+iI7JrmCksFItgv7Ybr+NCGxNXCNftHUS6Y+866psu
	 GAHEVhnfiDqmtq00lQR8w9sQ2dbdRzdbj4YpNrRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/121] net: bridge: fdb: convert added_by_user to bitops
Date: Tue, 10 Sep 2024 11:32:20 +0200
Message-ID: <20240910092548.945785594@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit ac3ca6af443aa495c7907e5010ac77fbd2450eaa ]

Straight-forward convert of the added_by_user field to bitops.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bee2ef946d31 ("net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_fdb.c       | 25 ++++++++++++-------------
 net/bridge/br_private.h   |  4 ++--
 net/bridge/br_switchdev.c |  6 ++++--
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 3645c1172b50..6f00cca4afc8 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -225,7 +225,7 @@ static void fdb_delete_local(struct net_bridge *br,
 		if (op != p && ether_addr_equal(op->dev->dev_addr, addr) &&
 		    (!vid || br_vlan_find(vg, vid))) {
 			f->dst = op;
-			f->added_by_user = 0;
+			clear_bit(BR_FDB_ADDED_BY_USER, &f->flags);
 			return;
 		}
 	}
@@ -236,7 +236,7 @@ static void fdb_delete_local(struct net_bridge *br,
 	if (p && ether_addr_equal(br->dev->dev_addr, addr) &&
 	    (!vid || (v && br_vlan_should_use(v)))) {
 		f->dst = NULL;
-		f->added_by_user = 0;
+		clear_bit(BR_FDB_ADDED_BY_USER, &f->flags);
 		return;
 	}
 
@@ -252,7 +252,7 @@ void br_fdb_find_delete_local(struct net_bridge *br,
 	spin_lock_bh(&br->hash_lock);
 	f = br_fdb_find(br, addr, vid);
 	if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
-	    !f->added_by_user && f->dst == p)
+	    !test_bit(BR_FDB_ADDED_BY_USER, &f->flags) && f->dst == p)
 		fdb_delete_local(br, p, f);
 	spin_unlock_bh(&br->hash_lock);
 }
@@ -268,7 +268,7 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	vg = nbp_vlan_group(p);
 	hlist_for_each_entry(f, &br->fdb_list, fdb_node) {
 		if (f->dst == p && test_bit(BR_FDB_LOCAL, &f->flags) &&
-		    !f->added_by_user) {
+		    !test_bit(BR_FDB_ADDED_BY_USER, &f->flags)) {
 			/* delete old one */
 			fdb_delete_local(br, p, f);
 
@@ -310,7 +310,7 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 	/* If old entry was unassociated with any port, then delete it. */
 	f = br_fdb_find(br, br->dev->dev_addr, 0);
 	if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
-	    !f->dst && !f->added_by_user)
+	    !f->dst && !test_bit(BR_FDB_ADDED_BY_USER, &f->flags))
 		fdb_delete_local(br, NULL, f);
 
 	fdb_insert(br, NULL, newaddr, 0);
@@ -326,7 +326,7 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 			continue;
 		f = br_fdb_find(br, br->dev->dev_addr, v->vid);
 		if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
-		    !f->dst && !f->added_by_user)
+		    !f->dst && !test_bit(BR_FDB_ADDED_BY_USER, &f->flags))
 			fdb_delete_local(br, NULL, f);
 		fdb_insert(br, NULL, newaddr, v->vid);
 	}
@@ -506,7 +506,6 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 		if (is_static)
 			set_bit(BR_FDB_STATIC, &fdb->flags);
-		fdb->added_by_user = 0;
 		fdb->added_by_external_learn = 0;
 		fdb->offloaded = 0;
 		fdb->updated = fdb->used = jiffies;
@@ -600,7 +599,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			if (now != fdb->updated)
 				fdb->updated = now;
 			if (unlikely(added_by_user))
-				fdb->added_by_user = 1;
+				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 			if (unlikely(fdb_modified)) {
 				trace_br_fdb_update(br, source, addr, vid, added_by_user);
 				fdb_notify(br, fdb, RTM_NEWNEIGH, true);
@@ -611,7 +610,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 		fdb = fdb_create(br, source, addr, vid, 0, 0);
 		if (fdb) {
 			if (unlikely(added_by_user))
-				fdb->added_by_user = 1;
+				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 			trace_br_fdb_update(br, source, addr, vid,
 					    added_by_user);
 			fdb_notify(br, fdb, RTM_NEWNEIGH, true);
@@ -871,7 +870,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 	}
 
-	fdb->added_by_user = 1;
+	set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
 	fdb->used = jiffies;
 	if (modified) {
@@ -1129,7 +1128,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			goto err_unlock;
 		}
 		if (swdev_notify)
-			fdb->added_by_user = 1;
+			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 		fdb->added_by_external_learn = 1;
 		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
@@ -1143,14 +1142,14 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (fdb->added_by_external_learn) {
 			/* Refresh entry */
 			fdb->used = jiffies;
-		} else if (!fdb->added_by_user) {
+		} else if (!test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags)) {
 			/* Take over SW learned entry */
 			fdb->added_by_external_learn = 1;
 			modified = true;
 		}
 
 		if (swdev_notify)
-			fdb->added_by_user = 1;
+			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
 		if (modified)
 			fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b495778911a2..a439e0cfc686 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -177,6 +177,7 @@ enum {
 	BR_FDB_LOCAL,
 	BR_FDB_STATIC,
 	BR_FDB_STICKY,
+	BR_FDB_ADDED_BY_USER,
 };
 
 struct net_bridge_fdb_key {
@@ -191,8 +192,7 @@ struct net_bridge_fdb_entry {
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
 	unsigned long			flags;
-	unsigned char			added_by_user:1,
-					added_by_external_learn:1,
+	unsigned char			added_by_external_learn:1,
 					offloaded:1;
 
 	/* write-heavy members should not affect lookups */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 921310d3cbae..5010fbf74778 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -129,14 +129,16 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		br_switchdev_fdb_call_notifiers(false, fdb->key.addr.addr,
 						fdb->key.vlan_id,
 						fdb->dst->dev,
-						fdb->added_by_user,
+						test_bit(BR_FDB_ADDED_BY_USER,
+							 &fdb->flags),
 						fdb->offloaded);
 		break;
 	case RTM_NEWNEIGH:
 		br_switchdev_fdb_call_notifiers(true, fdb->key.addr.addr,
 						fdb->key.vlan_id,
 						fdb->dst->dev,
-						fdb->added_by_user,
+						test_bit(BR_FDB_ADDED_BY_USER,
+							 &fdb->flags),
 						fdb->offloaded);
 		break;
 	}
-- 
2.43.0



