Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CF419068E;
	Tue, 10 Sep 2024 10:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962615; cv=none; b=NYX60BJjvp4q2Y+Wl5nBDBArQbpY3MR7Cl3Jmgom/hs8pG8kc7+81CulWqhyi/Hyu0o4XGQQ+WrjLBLwVpdAMzTyAnQrxFggrKPcX0XPcKteaV7xCQUWA8yGkSIwfHwf086R5jc6wVYnAquFtH7hqvRJMc0vySqXYiksCu57DvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962615; c=relaxed/simple;
	bh=zS5Lpxm3XjKGERTiklaQ/mn3k+nNidP9A3HM+EKW4AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YK3kmK+iUpOAN6oSZX7QYPNKoJyL9GdmFygDkyWntb8t7y+eC5BeJ+yOsGpZQ6+Sad7RDYh8wRYCvo+OhI7jaT+/r+odl6vIyCMzboicK+5eBzSeJEvFNgEkDm/GxSRCAaLvkejOVLmh5mzZQhdT7eo6i5XBLFFkW00zSrECMNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DY9e7ACA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DY9e7ACA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54F0C4CEC3;
	Tue, 10 Sep 2024 10:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962615;
	bh=zS5Lpxm3XjKGERTiklaQ/mn3k+nNidP9A3HM+EKW4AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DY9e7ACA3ALYmaCp0a6oLzUgV0A8tbxMK9UZEtAiJ4bIO+++yQ72Nts3+y92ad/B9
	 IIjjsz1N+YAKE7DzQoF2RoEC9I3TvZ+jzczfTzGie3jfV1hzngF0se3F9J0UQIrcA1
	 WUpThvIKXCO3N8alfVRMeUrExs+lKF7LGoTEEcj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/121] net: bridge: fdb: convert added_by_external_learn to use bitops
Date: Tue, 10 Sep 2024 11:32:21 +0200
Message-ID: <20240910092548.986198995@linuxfoundation.org>
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

[ Upstream commit b5cd9f7c42480ede119a390607a9dbe6263f6795 ]

Convert the added_by_external_learn field to a flag and use bitops.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bee2ef946d31 ("net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_fdb.c     | 19 +++++++++----------
 net/bridge/br_private.h |  4 ++--
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6f00cca4afc8..83d6be3f87f1 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -76,7 +76,7 @@ static inline int has_expired(const struct net_bridge *br,
 				  const struct net_bridge_fdb_entry *fdb)
 {
 	return !test_bit(BR_FDB_STATIC, &fdb->flags) &&
-	       !fdb->added_by_external_learn &&
+	       !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags) &&
 	       time_before_eq(fdb->updated + hold_time(br), jiffies);
 }
 
@@ -352,7 +352,7 @@ void br_fdb_cleanup(struct work_struct *work)
 		unsigned long this_timer;
 
 		if (test_bit(BR_FDB_STATIC, &f->flags) ||
-		    f->added_by_external_learn)
+		    test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags))
 			continue;
 		this_timer = f->updated + delay;
 		if (time_after(this_timer, now)) {
@@ -506,7 +506,6 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 		if (is_static)
 			set_bit(BR_FDB_STATIC, &fdb->flags);
-		fdb->added_by_external_learn = 0;
 		fdb->offloaded = 0;
 		fdb->updated = fdb->used = jiffies;
 		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
@@ -593,8 +592,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
-				if (unlikely(fdb->added_by_external_learn))
-					fdb->added_by_external_learn = 0;
+				test_and_clear_bit(BR_FDB_ADDED_BY_EXT_LEARN,
+						   &fdb->flags);
 			}
 			if (now != fdb->updated)
 				fdb->updated = now;
@@ -659,7 +658,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 
 	if (fdb->offloaded)
 		ndm->ndm_flags |= NTF_OFFLOADED;
-	if (fdb->added_by_external_learn)
+	if (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
 	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
@@ -1129,7 +1128,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		}
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-		fdb->added_by_external_learn = 1;
+		set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags);
 		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
 		fdb->updated = jiffies;
@@ -1139,12 +1138,12 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			modified = true;
 		}
 
-		if (fdb->added_by_external_learn) {
+		if (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags)) {
 			/* Refresh entry */
 			fdb->used = jiffies;
 		} else if (!test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags)) {
 			/* Take over SW learned entry */
-			fdb->added_by_external_learn = 1;
+			set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags);
 			modified = true;
 		}
 
@@ -1171,7 +1170,7 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 	spin_lock_bh(&br->hash_lock);
 
 	fdb = br_fdb_find(br, addr, vid);
-	if (fdb && fdb->added_by_external_learn)
+	if (fdb && test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
 		fdb_delete(br, fdb, swdev_notify);
 	else
 		err = -ENOENT;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a439e0cfc686..5ba4620727a7 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -178,6 +178,7 @@ enum {
 	BR_FDB_STATIC,
 	BR_FDB_STICKY,
 	BR_FDB_ADDED_BY_USER,
+	BR_FDB_ADDED_BY_EXT_LEARN,
 };
 
 struct net_bridge_fdb_key {
@@ -192,8 +193,7 @@ struct net_bridge_fdb_entry {
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
 	unsigned long			flags;
-	unsigned char			added_by_external_learn:1,
-					offloaded:1;
+	unsigned char			offloaded:1;
 
 	/* write-heavy members should not affect lookups */
 	unsigned long			updated ____cacheline_aligned_in_smp;
-- 
2.43.0



