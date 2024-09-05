Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF4914A08E;
	Thu,  5 Sep 2024 09:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529764; cv=none; b=phTkX/YMJD3u9P5524QsM782vrvRIh9RyP2ff46dSzxt2h6rCka/VDzfyLq55lVqZF+7pMtW8tPTC6BzUae+vtNCly7ETZZGsUjK51NYnTVGRBvUr7HxutQrS4yt00EMgK9XlE8ZGg+F+e9WUZAus0MFa/GM3o/SMtxapCpS/pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529764; c=relaxed/simple;
	bh=puLLS8VqHBNYAisw5Plz/y7rjdwYXoq2bS3OJBJV1yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8mMLQBCWpJCPbKhrc6mz6117fP8xkZgo9WoCfKL3vjO7mavo5Txr++dRc7jj89Mme3Qi8oJWyPB7agD40+b0Dra33dM42mbQpdzxQVINne3/eMnECWErxrwtRvsaVxA8bK7lmO5+HuYutG07kWM9QAH6zBYQhDutYDeDO3aMWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVkUmKp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVkUmKp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13260C4CEC3;
	Thu,  5 Sep 2024 09:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529764;
	bh=puLLS8VqHBNYAisw5Plz/y7rjdwYXoq2bS3OJBJV1yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVkUmKp3yAM8Y6btpV7y4zj7nyVieCme9RHBfIDPuGi1SbUNikQnlk7ferpJuFzAX
	 dHdBLT8F6WuVuXEkMQAVsTcNGijMmOSOEWCgnEJH8O+mDGPRLeeLSeXKIU8si+dx6M
	 UQzNAPFnPRyVwQvZewqs2B44quFNpXtN1DXwpYLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 136/184] fsnotify: clear PARENT_WATCHED flags lazily
Date: Thu,  5 Sep 2024 11:40:49 +0200
Message-ID: <20240905093737.529330966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 172e422ffea20a89bfdc672741c1aad6fbb5044e ]

In some setups directories can have many (usually negative) dentries.
Hence __fsnotify_update_child_dentry_flags() function can take a
significant amount of time. Since the bulk of this function happens
under inode->i_lock this causes a significant contention on the lock
when we remove the watch from the directory as the
__fsnotify_update_child_dentry_flags() call from fsnotify_recalc_mask()
races with __fsnotify_update_child_dentry_flags() calls from
__fsnotify_parent() happening on children. This can lead upto softlockup
reports reported by users.

Fix the problem by calling fsnotify_update_children_dentry_flags() to
set PARENT_WATCHED flags only when parent starts watching children.

When parent stops watching children, clear false positive PARENT_WATCHED
flags lazily in __fsnotify_parent() for each accessed child.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fsnotify.c             | 31 +++++++++++++++++++++----------
 fs/notify/fsnotify.h             |  2 +-
 fs/notify/mark.c                 | 32 +++++++++++++++++++++++++++++---
 include/linux/fsnotify_backend.h |  8 +++++---
 4 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index ff69ae24c4e8..272c8a1dab3c 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -117,17 +117,13 @@ void fsnotify_sb_free(struct super_block *sb)
  * parent cares.  Thus when an event happens on a child it can quickly tell
  * if there is a need to find a parent and send the event to the parent.
  */
-void __fsnotify_update_child_dentry_flags(struct inode *inode)
+void fsnotify_set_children_dentry_flags(struct inode *inode)
 {
 	struct dentry *alias;
-	int watched;
 
 	if (!S_ISDIR(inode->i_mode))
 		return;
 
-	/* determine if the children should tell inode about their events */
-	watched = fsnotify_inode_watches_children(inode);
-
 	spin_lock(&inode->i_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
@@ -143,10 +139,7 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 				continue;
 
 			spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
-			if (watched)
-				child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
-			else
-				child->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+			child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
 			spin_unlock(&child->d_lock);
 		}
 		spin_unlock(&alias->d_lock);
@@ -154,6 +147,24 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 	spin_unlock(&inode->i_lock);
 }
 
+/*
+ * Lazily clear false positive PARENT_WATCHED flag for child whose parent had
+ * stopped watching children.
+ */
+static void fsnotify_clear_child_dentry_flag(struct inode *pinode,
+					     struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	/*
+	 * d_lock is a sufficient barrier to prevent observing a non-watched
+	 * parent state from before the fsnotify_set_children_dentry_flags()
+	 * or fsnotify_update_flags() call that had set PARENT_WATCHED.
+	 */
+	if (!fsnotify_inode_watches_children(pinode))
+		dentry->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+	spin_unlock(&dentry->d_lock);
+}
+
 /* Are inode/sb/mount interested in parent and name info with this event? */
 static bool fsnotify_event_needs_parent(struct inode *inode, __u32 mnt_mask,
 					__u32 mask)
@@ -228,7 +239,7 @@ int __fsnotify_parent(struct dentry *dentry, __u32 mask, const void *data,
 	p_inode = parent->d_inode;
 	p_mask = fsnotify_inode_watches_children(p_inode);
 	if (unlikely(parent_watched && !p_mask))
-		__fsnotify_update_child_dentry_flags(p_inode);
+		fsnotify_clear_child_dentry_flag(p_inode, dentry);
 
 	/*
 	 * Include parent/name in notification either if some notification
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 2d059f789ee3..663759ed6fbc 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -93,7 +93,7 @@ static inline void fsnotify_clear_marks_by_sb(struct super_block *sb)
  * update the dentry->d_flags of all of inode's children to indicate if inode cares
  * about events that happen to its children.
  */
-extern void __fsnotify_update_child_dentry_flags(struct inode *inode);
+extern void fsnotify_set_children_dentry_flags(struct inode *inode);
 
 extern struct kmem_cache *fsnotify_mark_connector_cachep;
 
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index c3eefa70633c..5e170e713088 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -250,6 +250,24 @@ static void *__fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 	return fsnotify_update_iref(conn, want_iref);
 }
 
+static bool fsnotify_conn_watches_children(
+					struct fsnotify_mark_connector *conn)
+{
+	if (conn->type != FSNOTIFY_OBJ_TYPE_INODE)
+		return false;
+
+	return fsnotify_inode_watches_children(fsnotify_conn_inode(conn));
+}
+
+static void fsnotify_conn_set_children_dentry_flags(
+					struct fsnotify_mark_connector *conn)
+{
+	if (conn->type != FSNOTIFY_OBJ_TYPE_INODE)
+		return;
+
+	fsnotify_set_children_dentry_flags(fsnotify_conn_inode(conn));
+}
+
 /*
  * Calculate mask of events for a list of marks. The caller must make sure
  * connector and connector->obj cannot disappear under us.  Callers achieve
@@ -258,15 +276,23 @@ static void *__fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
  */
 void fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 {
+	bool update_children;
+
 	if (!conn)
 		return;
 
 	spin_lock(&conn->lock);
+	update_children = !fsnotify_conn_watches_children(conn);
 	__fsnotify_recalc_mask(conn);
+	update_children &= fsnotify_conn_watches_children(conn);
 	spin_unlock(&conn->lock);
-	if (conn->type == FSNOTIFY_OBJ_TYPE_INODE)
-		__fsnotify_update_child_dentry_flags(
-					fsnotify_conn_inode(conn));
+	/*
+	 * Set children's PARENT_WATCHED flags only if parent started watching.
+	 * When parent stops watching, we clear false positive PARENT_WATCHED
+	 * flags lazily in __fsnotify_parent().
+	 */
+	if (update_children)
+		fsnotify_conn_set_children_dentry_flags(conn);
 }
 
 /* Free all connectors queued for freeing once SRCU period ends */
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 4dd6143db271..8be029bc50b1 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -594,12 +594,14 @@ static inline __u32 fsnotify_parent_needed_mask(__u32 mask)
 
 static inline int fsnotify_inode_watches_children(struct inode *inode)
 {
+	__u32 parent_mask = READ_ONCE(inode->i_fsnotify_mask);
+
 	/* FS_EVENT_ON_CHILD is set if the inode may care */
-	if (!(inode->i_fsnotify_mask & FS_EVENT_ON_CHILD))
+	if (!(parent_mask & FS_EVENT_ON_CHILD))
 		return 0;
 	/* this inode might care about child events, does it care about the
 	 * specific set of events that can happen on a child? */
-	return inode->i_fsnotify_mask & FS_EVENTS_POSS_ON_CHILD;
+	return parent_mask & FS_EVENTS_POSS_ON_CHILD;
 }
 
 /*
@@ -613,7 +615,7 @@ static inline void fsnotify_update_flags(struct dentry *dentry)
 	/*
 	 * Serialisation of setting PARENT_WATCHED on the dentries is provided
 	 * by d_lock. If inotify_inode_watched changes after we have taken
-	 * d_lock, the following __fsnotify_update_child_dentry_flags call will
+	 * d_lock, the following fsnotify_set_children_dentry_flags call will
 	 * find our entry, so it will spin until we complete here, and update
 	 * us with the new state.
 	 */
-- 
2.43.0



