Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4A1189F58;
	Tue, 10 Sep 2024 09:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961083; cv=none; b=fiXFYN1hVYdJF2stglF472/rR1WJMw1OBsyTdXhroZpI4P1JeQo3FtmangDVcyIJRN24qHivIqt/c1IqRac8doSnCsg/SgvJWmKC3DVKaRXkPFyMrUMxwYPVdZrGy/r+ghz+YdwpWT2aBBdcqA/+tq7McmGJqPOSyCihpeZtrws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961083; c=relaxed/simple;
	bh=HDirkgMuhnQr3zSGDspZ65vRHFJYzbjTdttwimAd8Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L37Fto8E9KOIIXz6IExEL7vyoXvgWXaqvQe0A1MAS7pdYrEErlrP5c5Wq0Ok7MlA8cJCC3ywySKi/9Ttn9FFdI2lL5Uy6GTNrxwwxZjaj1h7PZU6rPGR4A8lHKRRDD2NfjJPEg2KdQtpBIvrqW9OQLj2VclxZLfXwoZWTDmBCMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqcuKDVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqcuKDVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CF6C4CEC3;
	Tue, 10 Sep 2024 09:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961083;
	bh=HDirkgMuhnQr3zSGDspZ65vRHFJYzbjTdttwimAd8Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqcuKDVySmAgK9Utdk069sVAO567uoaZE98ltxIDHyWxYNzocJJzM6iY2xZp3dmyn
	 psnFvVCUJsg5yuIrcYEtv2w3E0hVJxy5eWWRqih0B48Dd4J5OTexTnjVOZa2TaLI1k
	 1BXwX9UyDf3FLmPtHPerVZ4kPCOi6VbeiBZe2DQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/96] net: bridge: fdb: convert added_by_user to bitops
Date: Tue, 10 Sep 2024 11:31:50 +0200
Message-ID: <20240910092543.637295133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 25aeaedce762..7ae27569ced9 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -230,7 +230,7 @@ static void fdb_delete_local(struct net_bridge *br,
 		if (op != p && ether_addr_equal(op->dev->dev_addr, addr) &&
 		    (!vid || br_vlan_find(vg, vid))) {
 			f->dst = op;
-			f->added_by_user = 0;
+			clear_bit(BR_FDB_ADDED_BY_USER, &f->flags);
 			return;
 		}
 	}
@@ -241,7 +241,7 @@ static void fdb_delete_local(struct net_bridge *br,
 	if (p && ether_addr_equal(br->dev->dev_addr, addr) &&
 	    (!vid || (v && br_vlan_should_use(v)))) {
 		f->dst = NULL;
-		f->added_by_user = 0;
+		clear_bit(BR_FDB_ADDED_BY_USER, &f->flags);
 		return;
 	}
 
@@ -257,7 +257,7 @@ void br_fdb_find_delete_local(struct net_bridge *br,
 	spin_lock_bh(&br->hash_lock);
 	f = br_fdb_find(br, addr, vid);
 	if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
-	    !f->added_by_user && f->dst == p)
+	    !test_bit(BR_FDB_ADDED_BY_USER, &f->flags) && f->dst == p)
 		fdb_delete_local(br, p, f);
 	spin_unlock_bh(&br->hash_lock);
 }
@@ -273,7 +273,7 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	vg = nbp_vlan_group(p);
 	hlist_for_each_entry(f, &br->fdb_list, fdb_node) {
 		if (f->dst == p && test_bit(BR_FDB_LOCAL, &f->flags) &&
-		    !f->added_by_user) {
+		    !test_bit(BR_FDB_ADDED_BY_USER, &f->flags)) {
 			/* delete old one */
 			fdb_delete_local(br, p, f);
 
@@ -315,7 +315,7 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 	/* If old entry was unassociated with any port, then delete it. */
 	f = br_fdb_find(br, br->dev->dev_addr, 0);
 	if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
-	    !f->dst && !f->added_by_user)
+	    !f->dst && !test_bit(BR_FDB_ADDED_BY_USER, &f->flags))
 		fdb_delete_local(br, NULL, f);
 
 	fdb_insert(br, NULL, newaddr, 0);
@@ -331,7 +331,7 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 			continue;
 		f = br_fdb_find(br, br->dev->dev_addr, v->vid);
 		if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
-		    !f->dst && !f->added_by_user)
+		    !f->dst && !test_bit(BR_FDB_ADDED_BY_USER, &f->flags))
 			fdb_delete_local(br, NULL, f);
 		fdb_insert(br, NULL, newaddr, v->vid);
 	}
@@ -511,7 +511,6 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 		if (is_static)
 			set_bit(BR_FDB_STATIC, &fdb->flags);
-		fdb->added_by_user = 0;
 		fdb->added_by_external_learn = 0;
 		fdb->offloaded = 0;
 		fdb->updated = fdb->used = jiffies;
@@ -605,7 +604,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			if (now != fdb->updated)
 				fdb->updated = now;
 			if (unlikely(added_by_user))
-				fdb->added_by_user = 1;
+				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 			if (unlikely(fdb_modified)) {
 				trace_br_fdb_update(br, source, addr, vid, added_by_user);
 				fdb_notify(br, fdb, RTM_NEWNEIGH, true);
@@ -616,7 +615,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 		fdb = fdb_create(br, source, addr, vid, 0, 0);
 		if (fdb) {
 			if (unlikely(added_by_user))
-				fdb->added_by_user = 1;
+				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 			trace_br_fdb_update(br, source, addr, vid,
 					    added_by_user);
 			fdb_notify(br, fdb, RTM_NEWNEIGH, true);
@@ -850,7 +849,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 	}
 
-	fdb->added_by_user = 1;
+	set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
 	fdb->used = jiffies;
 	if (modified) {
@@ -1107,7 +1106,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			goto err_unlock;
 		}
 		if (swdev_notify)
-			fdb->added_by_user = 1;
+			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 		fdb->added_by_external_learn = 1;
 		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
@@ -1121,14 +1120,14 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
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
index 131e5be58468..9132f11db683 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -173,6 +173,7 @@ enum {
 	BR_FDB_LOCAL,
 	BR_FDB_STATIC,
 	BR_FDB_STICKY,
+	BR_FDB_ADDED_BY_USER,
 };
 
 struct net_bridge_fdb_key {
@@ -187,8 +188,7 @@ struct net_bridge_fdb_entry {
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
 	unsigned long			flags;
-	unsigned char			added_by_user:1,
-					added_by_external_learn:1,
+	unsigned char			added_by_external_learn:1,
 					offloaded:1;
 
 	/* write-heavy members should not affect lookups */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index b993df770675..e8948d49e5fc 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -127,14 +127,16 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
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



