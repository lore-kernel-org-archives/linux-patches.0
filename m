Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A090B18787E;
	Tue, 10 Sep 2024 10:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962606; cv=none; b=ioKCsdIeEy0rktSDjwggs0vmfcPsEu8cf9jqxnb5t/+iYfvRJb+xfdNtZHlmwIpk3XiZXUnZkQELDwFJa6HHuAlHllaabU1vc4UoyCbOdS007ipntYhsaj5w2/RsBUVpDJLJZ0t+bw8nyJZ8mmpIcaMBDoGnHiejzZhry7L2GZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962606; c=relaxed/simple;
	bh=W3/aCDKNW50TXv/mr4zK1Q8gaTwMCRvKikPAP3CwPx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxZogZJIHSl52ofX9JJAUEQAN+KdsN0HV8YWXb+a0A0CyQ9BSvvsedhOzqLwwMurwm7yF4/lfkyk4I2/FkgRzL9P/PfVAEI3xupIeDlpHA3BXov0SwuYWdKGwPLRmto1o+eLOk/Ek15qZzgd6eMfU6zSVpBG+zDb+JOuuFyQO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xje8INGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xje8INGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D8BC4CEC3;
	Tue, 10 Sep 2024 10:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962606;
	bh=W3/aCDKNW50TXv/mr4zK1Q8gaTwMCRvKikPAP3CwPx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xje8INGHDQ/Bxlxxv/2E7HVfkkv+clsVneNgQmTJMec24FRIK5JzjnyBD2KI03tEd
	 z1/c7mfGid1jpY79Rziukrn6BGOeyht0O6qlxekQeDJuCsJUmUseyKL7ifI1Ht4aqL
	 hRt/jsrboi3DrJkgav/M+RcUj6QoyZEb0LgCI41s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/121] net: bridge: fdb: convert is_static to bitops
Date: Tue, 10 Sep 2024 11:32:18 +0200
Message-ID: <20240910092548.842089249@linuxfoundation.org>
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

[ Upstream commit 29e63fffd666f1945756882d4b02bc7bec132101 ]

Convert the is_static to bitops, make use of the combined
test_and_set/clear_bit to simplify expressions in fdb_add_entry.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bee2ef946d31 ("net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_fdb.c     | 40 +++++++++++++++++++---------------------
 net/bridge/br_private.h |  4 ++--
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e67d5eb8bc1d..1c890e2d694b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -75,8 +75,9 @@ static inline unsigned long hold_time(const struct net_bridge *br)
 static inline int has_expired(const struct net_bridge *br,
 				  const struct net_bridge_fdb_entry *fdb)
 {
-	return !fdb->is_static && !fdb->added_by_external_learn &&
-		time_before_eq(fdb->updated + hold_time(br), jiffies);
+	return !test_bit(BR_FDB_STATIC, &fdb->flags) &&
+	       !fdb->added_by_external_learn &&
+	       time_before_eq(fdb->updated + hold_time(br), jiffies);
 }
 
 static void fdb_rcu_free(struct rcu_head *head)
@@ -197,7 +198,7 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
 {
 	trace_fdb_delete(br, f);
 
-	if (f->is_static)
+	if (test_bit(BR_FDB_STATIC, &f->flags))
 		fdb_del_hw_addr(br, f->key.addr.addr);
 
 	hlist_del_init_rcu(&f->fdb_node);
@@ -350,7 +351,8 @@ void br_fdb_cleanup(struct work_struct *work)
 	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
 		unsigned long this_timer;
 
-		if (f->is_static || f->added_by_external_learn)
+		if (test_bit(BR_FDB_STATIC, &f->flags) ||
+		    f->added_by_external_learn)
 			continue;
 		this_timer = f->updated + delay;
 		if (time_after(this_timer, now)) {
@@ -377,7 +379,7 @@ void br_fdb_flush(struct net_bridge *br)
 
 	spin_lock_bh(&br->hash_lock);
 	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
-		if (!f->is_static)
+		if (!test_bit(BR_FDB_STATIC, &f->flags))
 			fdb_delete(br, f, true);
 	}
 	spin_unlock_bh(&br->hash_lock);
@@ -401,7 +403,8 @@ void br_fdb_delete_by_port(struct net_bridge *br,
 			continue;
 
 		if (!do_all)
-			if (f->is_static || (vid && f->key.vlan_id != vid))
+			if (test_bit(BR_FDB_STATIC, &f->flags) ||
+			    (vid && f->key.vlan_id != vid))
 				continue;
 
 		if (test_bit(BR_FDB_LOCAL, &f->flags))
@@ -474,7 +477,7 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 		fe->port_hi = f->dst->port_no >> 8;
 
 		fe->is_local = test_bit(BR_FDB_LOCAL, &f->flags);
-		if (!f->is_static)
+		if (!test_bit(BR_FDB_STATIC, &f->flags))
 			fe->ageing_timer_value = jiffies_delta_to_clock_t(jiffies - f->updated);
 		++fe;
 		++num;
@@ -501,7 +504,8 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 		fdb->flags = 0;
 		if (is_local)
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
-		fdb->is_static = is_static;
+		if (is_static)
+			set_bit(BR_FDB_STATIC, &fdb->flags);
 		fdb->added_by_user = 0;
 		fdb->added_by_external_learn = 0;
 		fdb->offloaded = 0;
@@ -624,7 +628,7 @@ static int fdb_to_nud(const struct net_bridge *br,
 {
 	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
 		return NUD_PERMANENT;
-	else if (fdb->is_static)
+	else if (test_bit(BR_FDB_STATIC, &fdb->flags))
 		return NUD_NOARP;
 	else if (has_expired(br, fdb))
 		return NUD_STALE;
@@ -847,22 +851,16 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 	if (fdb_to_nud(br, fdb) != state) {
 		if (state & NUD_PERMANENT) {
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
-			if (!fdb->is_static) {
-				fdb->is_static = 1;
+			if (!test_and_set_bit(BR_FDB_STATIC, &fdb->flags))
 				fdb_add_hw_addr(br, addr);
-			}
 		} else if (state & NUD_NOARP) {
 			clear_bit(BR_FDB_LOCAL, &fdb->flags);
-			if (!fdb->is_static) {
-				fdb->is_static = 1;
+			if (!test_and_set_bit(BR_FDB_STATIC, &fdb->flags))
 				fdb_add_hw_addr(br, addr);
-			}
 		} else {
 			clear_bit(BR_FDB_LOCAL, &fdb->flags);
-			if (fdb->is_static) {
-				fdb->is_static = 0;
+			if (test_and_clear_bit(BR_FDB_STATIC, &fdb->flags))
 				fdb_del_hw_addr(br, addr);
-			}
 		}
 
 		modified = true;
@@ -1070,7 +1068,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p)
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
 		/* We only care for static entries */
-		if (!f->is_static)
+		if (!test_bit(BR_FDB_STATIC, &f->flags))
 			continue;
 		err = dev_uc_add(p->dev, f->key.addr.addr);
 		if (err)
@@ -1084,7 +1082,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p)
 rollback:
 	hlist_for_each_entry_rcu(tmp, &br->fdb_list, fdb_node) {
 		/* We only care for static entries */
-		if (!tmp->is_static)
+		if (!test_bit(BR_FDB_STATIC, &tmp->flags))
 			continue;
 		if (tmp == f)
 			break;
@@ -1103,7 +1101,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
 		/* We only care for static entries */
-		if (!f->is_static)
+		if (!test_bit(BR_FDB_STATIC, &f->flags))
 			continue;
 
 		dev_uc_del(p->dev, f->key.addr.addr);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 92e0ee4c8253..7b46323584be 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -175,6 +175,7 @@ struct net_bridge_vlan_group {
 /* bridge fdb flags */
 enum {
 	BR_FDB_LOCAL,
+	BR_FDB_STATIC,
 };
 
 struct net_bridge_fdb_key {
@@ -189,8 +190,7 @@ struct net_bridge_fdb_entry {
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
 	unsigned long			flags;
-	unsigned char			is_static:1,
-					is_sticky:1,
+	unsigned char			is_sticky:1,
 					added_by_user:1,
 					added_by_external_learn:1,
 					offloaded:1;
-- 
2.43.0



