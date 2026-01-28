Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0339D280CF6;
	Wed, 28 Jan 2026 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613912; cv=none; b=Njd9S8VpHhqTZUYn935ylyVl5wUk8B81uMwUKFkSmjN74tIwJkuH0Jt59ubnTv5bB8845HxnPCnc5bTEqMxCDHu918zfmFa5wINeasYbTYurLTiEMWJEktraGP8weW2G6XLCm8uX4k4p5fExgWHbTRDjRIw9kK6Lj2TT99DHq0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613912; c=relaxed/simple;
	bh=LE23TSO6u2IfCdmd15nAY6KNK+Gjtc01DonOGyWsAvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAVsxd3O+8xaNloG/EFp6Jj1Nzz03/XyOeR4QESFHZRAOaz3WpB/M9MQQtU+OZIsz2QeUz5yb6wX2yfdgl1wKQiO4fdQdTkS7HQBw9+F1YaFfVkyUTAKkVrNs8SVim9oZvdIGTjFMeyJ7JksFhZw4+cgUGsfFrh9hSszX2+GvRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAKXa7Cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAKXa7Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5F1C4CEF7;
	Wed, 28 Jan 2026 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769613911;
	bh=LE23TSO6u2IfCdmd15nAY6KNK+Gjtc01DonOGyWsAvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAKXa7CsLVTeoERmE6ycCcy3O8vKw8lb1n/93+3NqoX0ywOPl7l3yCHS4bMKZYKYj
	 PQU6e6BfdLtYtvB1Yln0RQiz7xasFOGPAnP3WXGnaRVTJUYGYbawFN6iQPbUsybAIr
	 3G6jnp5Jx71tRZNWXhUML04r/ko6D6H/krHaPh24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfab43087ad57222ce96@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/254] net: bridge: annotate data-races around fdb->{updated,used}
Date: Wed, 28 Jan 2026 16:19:48 +0100
Message-ID: <20260128145345.147898558@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b25a0b4a2193407aa72a4cd1df66a7ed07dd4f1e ]

fdb->updated and fdb->used are read and written locklessly.

Add READ_ONCE()/WRITE_ONCE() annotations.

Fixes: 31cbc39b6344 ("net: bridge: add option to allow activity notifications for any fdb entries")
Reported-by: syzbot+bfab43087ad57222ce96@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/695e3d74.050a0220.1c677c.035f.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260108093806.834459-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_fdb.c   | 28 ++++++++++++++++------------
 net/bridge/br_input.c |  4 ++--
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 91903076d30bd..fa2970db21301 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -73,7 +73,7 @@ static inline int has_expired(const struct net_bridge *br,
 {
 	return !test_bit(BR_FDB_STATIC, &fdb->flags) &&
 	       !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags) &&
-	       time_before_eq(fdb->updated + hold_time(br), jiffies);
+	       time_before_eq(READ_ONCE(fdb->updated) + hold_time(br), jiffies);
 }
 
 static void fdb_rcu_free(struct rcu_head *head)
@@ -136,9 +136,9 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 	if (nla_put_u32(skb, NDA_FLAGS_EXT, ext_flags))
 		goto nla_put_failure;
 
-	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
+	ci.ndm_used	 = jiffies_to_clock_t(now - READ_ONCE(fdb->used));
 	ci.ndm_confirmed = 0;
-	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
+	ci.ndm_updated	 = jiffies_to_clock_t(now - READ_ONCE(fdb->updated));
 	ci.ndm_refcnt	 = 0;
 	if (nla_put(skb, NDA_CACHEINFO, sizeof(ci), &ci))
 		goto nla_put_failure;
@@ -534,7 +534,7 @@ void br_fdb_cleanup(struct work_struct *work)
 	 */
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
-		unsigned long this_timer = f->updated + delay;
+		unsigned long this_timer = READ_ONCE(f->updated) + delay;
 
 		if (test_bit(BR_FDB_STATIC, &f->flags) ||
 		    test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags)) {
@@ -792,6 +792,7 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 {
 	struct net_bridge_fdb_entry *f;
 	struct __fdb_entry *fe = buf;
+	unsigned long delta;
 	int num = 0;
 
 	memset(buf, 0, maxnum*sizeof(struct __fdb_entry));
@@ -821,8 +822,11 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 		fe->port_hi = f->dst->port_no >> 8;
 
 		fe->is_local = test_bit(BR_FDB_LOCAL, &f->flags);
-		if (!test_bit(BR_FDB_STATIC, &f->flags))
-			fe->ageing_timer_value = jiffies_delta_to_clock_t(jiffies - f->updated);
+		if (!test_bit(BR_FDB_STATIC, &f->flags)) {
+			delta = jiffies - READ_ONCE(f->updated);
+			fe->ageing_timer_value =
+				jiffies_delta_to_clock_t(delta);
+		}
 		++fe;
 		++num;
 	}
@@ -870,8 +874,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			unsigned long now = jiffies;
 			bool fdb_modified = false;
 
-			if (now != fdb->updated) {
-				fdb->updated = now;
+			if (now != READ_ONCE(fdb->updated)) {
+				WRITE_ONCE(fdb->updated, now);
 				fdb_modified = __fdb_mark_active(fdb);
 			}
 
@@ -1103,10 +1107,10 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 	if (fdb_handle_notify(fdb, notify))
 		modified = true;
 
-	fdb->used = jiffies;
+	WRITE_ONCE(fdb->used, jiffies);
 	if (modified) {
 		if (refresh)
-			fdb->updated = jiffies;
+			WRITE_ONCE(fdb->updated, jiffies);
 		fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 	}
 
@@ -1419,7 +1423,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			goto err_unlock;
 		}
 
-		fdb->updated = jiffies;
+		WRITE_ONCE(fdb->updated, jiffies);
 
 		if (READ_ONCE(fdb->dst) != p) {
 			WRITE_ONCE(fdb->dst, p);
@@ -1428,7 +1432,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 
 		if (test_and_set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags)) {
 			/* Refresh entry */
-			fdb->used = jiffies;
+			WRITE_ONCE(fdb->used, jiffies);
 		} else {
 			modified = true;
 		}
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 951330c1a813b..2d5b81ebbaa6d 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -207,8 +207,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		if (test_bit(BR_FDB_LOCAL, &dst->flags))
 			return br_pass_frame_up(skb, false);
 
-		if (now != dst->used)
-			dst->used = now;
+		if (now != READ_ONCE(dst->used))
+			WRITE_ONCE(dst->used, now);
 		br_forward(dst->dst, skb, local_rcv, false);
 	} else {
 		if (!mcast_hit)
-- 
2.51.0



