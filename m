Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A2E30ACF6;
	Sat, 12 Sep 2026 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789233035; cv=none; b=kThV6D/7tQZKY5pZRVkHOLmcdhwhqzFi5EXZn6TTVvJWN5kaQV7WYhYOmzrUZKIxo60b/fOo1VtZy27wGEVM/GRDWbaxumwSknbFM11ucoVKPix+RZY4NDOwaCoQUEMN1AvSudDpXGijGnLoLWsPGdJOG0vu05vcy1wn5rr9044=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789233035; c=relaxed/simple;
	bh=8Vrr517ZJTxCQUTsaIxktO4UXfkpQ0Q4bjsUv/ZiRrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/+gB0QVxrFVEf1paTIToMrDS4KXFkaHUics17EUPHM0ClrJyVbsW8XNnswgl5DZznpT5NAXTJrUB3/lvNYKoJ/SBeTPo6viUTM3S1nwjU5yzP4mo0hS2MtHgWFjqCYfMd71z7PDUPafycVxI38kYYjT0gi9kIEH2DZxQIGIbCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvuMvU2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvuMvU2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4EA1F000FF;
	Sat, 12 Sep 2026 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789233033;
	bh=xC0LQ1v10MOVY6NkCh7bOkzfUaLgR9JXu+BQyo8aU/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvuMvU2N8eTn5nAEcEO3p1sUcgcQfNt8No2/Y38KRPNk3wpKZ1RxmmiIuv/qNbJtn
	 RatPYnupV8OHeHpfli4zKS1sAEFrrwRscgH1fYN47ELqpJINveOXZcLsX2X76kUsis
	 Pf/1NvNJairnQTXtdyegsVD4xg6Wm6p0vFzaxSCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Heming Zhao <heming.zhao@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 133/935] ocfs2: cluster: avoid lock order inversion in o2hb_region_pin() from drop_item
Date: Sat, 12 Sep 2026 08:52:43 +0200
Message-ID: <20260912065529.874506921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit cd789996db3c87427343f54f509d17810bd7ba7c upstream.

o2hb_heartbeat_group_drop_item() is called from configfs rmdir with the
parent directory's inode_lock held.  It calls o2hb_region_pin() ->
o2nm_depend_item() -> configfs_depend_item(), which acquires the configfs
root inode_lock.  This creates a parent -> root inode_lock nesting that
could deadlock against paths taking root -> parent (e.g.  subsystem
unregistration).

Fix this by using configfs_depend_item_unlocked() when o2hb_region_pin()
is called from a configfs callback context.  This variant skips the root
inode_lock when caller and target are in the same subsystem, which is safe
because VFS already holds a lock preventing unregistration.

Add o2nm_depend_item_unlocked() wrapper and a from_callback parameter to
o2hb_region_pin() to select the appropriate variant.

Link: https://lore.kernel.org/20260722124933.430554-3-joseph.qi@linux.alibaba.com
Fixes: 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/cluster/heartbeat.c   |   17 ++++++++++-------
 fs/ocfs2/cluster/nodemanager.c |    6 ++++++
 fs/ocfs2/cluster/nodemanager.h |    1 +
 3 files changed, 17 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -145,7 +145,7 @@ static unsigned int o2hb_dependent_users
  * In global heartbeat mode, we pin/unpin all o2hb regions. This solution
  * works for both file system and userdlm domains.
  */
-static int o2hb_region_pin(const char *region_uuid);
+static int o2hb_region_pin(const char *region_uuid, bool from_callback);
 static void o2hb_region_unpin(const char *region_uuid);
 
 /* Only sets a new threshold if there are no active regions.
@@ -2131,7 +2131,7 @@ static void o2hb_heartbeat_group_drop_it
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
-		o2hb_region_pin(NULL);
+		o2hb_region_pin(NULL, true);
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
@@ -2272,7 +2272,7 @@ EXPORT_SYMBOL_GPL(o2hb_setup_callback);
  * In local, we only pin the matching region. In global we pin all the active
  * regions.
  */
-static int o2hb_region_pin(const char *region_uuid)
+static int o2hb_region_pin(const char *region_uuid, bool from_callback)
 {
 	int ret = 0, found;
 	struct o2hb_region *reg, *pinned;
@@ -2327,7 +2327,10 @@ static int o2hb_region_pin(const char *r
 		spin_unlock(&o2hb_live_lock);
 
 		/* Ignore ENOENT only for local hb (userdlm domain) */
-		ret = o2nm_depend_item(&pinned->hr_item);
+		if (from_callback)
+			ret = o2nm_depend_item_unlocked(&pinned->hr_item);
+		else
+			ret = o2nm_depend_item(&pinned->hr_item);
 
 		spin_lock(&o2hb_live_lock);
 		if (!ret) {
@@ -2425,8 +2428,8 @@ static int o2hb_region_inc_user(const ch
 
 	/* local heartbeat */
 	if (!o2hb_global_heartbeat_active()) {
-	    ret = o2hb_region_pin(region_uuid);
-	    goto unlock;
+		ret = o2hb_region_pin(region_uuid, false);
+		goto unlock;
 	}
 
 	/*
@@ -2439,7 +2442,7 @@ static int o2hb_region_inc_user(const ch
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
-		ret = o2hb_region_pin(NULL);
+		ret = o2hb_region_pin(NULL, false);
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -776,6 +776,12 @@ int o2nm_depend_item(struct config_item
 	return configfs_depend_item(&o2nm_cluster_group.cs_subsys, item);
 }
 
+int o2nm_depend_item_unlocked(struct config_item *item)
+{
+	return configfs_depend_item_unlocked(&o2nm_cluster_group.cs_subsys,
+					     item);
+}
+
 void o2nm_undepend_item(struct config_item *item)
 {
 	configfs_undepend_item(item);
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -64,6 +64,7 @@ void o2nm_node_get(struct o2nm_node *nod
 void o2nm_node_put(struct o2nm_node *node);
 
 int o2nm_depend_item(struct config_item *item);
+int o2nm_depend_item_unlocked(struct config_item *item);
 void o2nm_undepend_item(struct config_item *item);
 int o2nm_depend_this_node(void);
 void o2nm_undepend_this_node(void);


