Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DB21509AC;
	Tue, 20 Feb 2024 21:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464128; cv=none; b=AXpDa2A1/Pdith6+XkF3FC5PM5kySW8pH6rNNe/fSlc+bqhKGiLIG5gYuu/ejbpMutjSRKaxYBQE+YAokHjMd7JYTRlF4qojEkSJZD/FfNHhWP75QMMeT0Wg3uEUZ7Nb5KTPrjsGcfssknYbZj6g7gRAjsO+ILMINaqlQkKJWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464128; c=relaxed/simple;
	bh=au50i5Ur79yu9XK5ejn66SGD6+wmmm/Dm3TO9xD9QxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQqvyDmpiBS4zA1ia0pffTWmu5ZKfxVAddYbGXHRPPgCkJZU3ImnfvAD+42KsBZxHSJa+7WnuQ4MVngDnq0qTSWUgWEe6tfMdj1wPDD2uJarMhKeFlrjhR5aDX4aMay5Ie+KLckjf/5BVF11hzcaI8m4dh6Rvt2FxNSejH+9/3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBbWhw/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBbWhw/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1D4C433C7;
	Tue, 20 Feb 2024 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464128;
	bh=au50i5Ur79yu9XK5ejn66SGD6+wmmm/Dm3TO9xD9QxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBbWhw/DZxZnsMtV3AJ4FeexO39H47fKW9rZ8XN1W72p3875K48v38F3QhQd0asxF
	 ZIN6wyTeWY+pZS+ugAnotRCoH7Cj8KYpz+dglFmYIrukiWinblU7Ne4GkrwDOxZBpJ
	 VUBKlGjaBODLcU7fMA5lJUt5oL2eBIl9EwfLz1Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 260/331] Revert "eventfs: Use simple_recursive_removal() to clean up dentries"
Date: Tue, 20 Feb 2024 21:56:16 +0100
Message-ID: <20240220205646.038292109@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This reverts commit 055907ad2c14838c90d63297f7bab8d180a5d844.

The eventfs was not designed properly and may have some hidden bugs in it.
Linus rewrote it properly and I trust his version more than this one. Revert
the backported patches for 6.6 and re-apply all the changes to make it
equivalent to Linus's version.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   71 +++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -54,10 +54,12 @@ struct eventfs_file {
 	/*
 	 * Union - used for deletion
 	 * @llist:	for calling dput() if needed after RCU
+	 * @del_list:	list of eventfs_file to delete
 	 * @rcu:	eventfs_file to delete in RCU
 	 */
 	union {
 		struct llist_node	llist;
+		struct list_head	del_list;
 		struct rcu_head		rcu;
 	};
 	void				*data;
@@ -274,6 +276,7 @@ static void free_ef(struct eventfs_file
  */
 void eventfs_set_ef_status_free(struct tracefs_inode *ti, struct dentry *dentry)
 {
+	struct tracefs_inode *ti_parent;
 	struct eventfs_inode *ei;
 	struct eventfs_file *ef;
 
@@ -294,6 +297,10 @@ void eventfs_set_ef_status_free(struct t
 
 	mutex_lock(&eventfs_mutex);
 
+	ti_parent = get_tracefs(dentry->d_parent->d_inode);
+	if (!ti_parent || !(ti_parent->flags & TRACEFS_EVENT_INODE))
+		goto out;
+
 	ef = dentry->d_fsdata;
 	if (!ef)
 		goto out;
@@ -866,29 +873,30 @@ static void unhook_dentry(struct dentry
 {
 	if (!dentry)
 		return;
-	/*
-	 * Need to add a reference to the dentry that is expected by
-	 * simple_recursive_removal(), which will include a dput().
-	 */
-	dget(dentry);
 
-	/*
-	 * Also add a reference for the dput() in eventfs_workfn().
-	 * That is required as that dput() will free the ei after
-	 * the SRCU grace period is over.
-	 */
+	/* Keep the dentry from being freed yet (see eventfs_workfn()) */
 	dget(dentry);
+
+	dentry->d_fsdata = NULL;
+	d_invalidate(dentry);
+	mutex_lock(&eventfs_mutex);
+	/* dentry should now have at least a single reference */
+	WARN_ONCE((int)d_count(dentry) < 1,
+		  "dentry %px (%s) less than one reference (%d) after invalidate\n",
+		  dentry, dentry->d_name.name, d_count(dentry));
+	mutex_unlock(&eventfs_mutex);
 }
 
 /**
  * eventfs_remove_rec - remove eventfs dir or file from list
  * @ef: eventfs_file to be removed.
+ * @head: to create list of eventfs_file to be deleted
  * @level: to check recursion depth
  *
  * The helper function eventfs_remove_rec() is used to clean up and free the
  * associated data from eventfs for both of the added functions.
  */
-static void eventfs_remove_rec(struct eventfs_file *ef, int level)
+static void eventfs_remove_rec(struct eventfs_file *ef, struct list_head *head, int level)
 {
 	struct eventfs_file *ef_child;
 
@@ -908,16 +916,14 @@ static void eventfs_remove_rec(struct ev
 		/* search for nested folders or files */
 		list_for_each_entry_srcu(ef_child, &ef->ei->e_top_files, list,
 					 lockdep_is_held(&eventfs_mutex)) {
-			eventfs_remove_rec(ef_child, level + 1);
+			eventfs_remove_rec(ef_child, head, level + 1);
 		}
 	}
 
 	ef->is_freed = 1;
 
-	unhook_dentry(ef->dentry);
-
 	list_del_rcu(&ef->list);
-	call_srcu(&eventfs_srcu, &ef->rcu, free_rcu_ef);
+	list_add_tail(&ef->del_list, head);
 }
 
 /**
@@ -928,22 +934,28 @@ static void eventfs_remove_rec(struct ev
  */
 void eventfs_remove(struct eventfs_file *ef)
 {
-	struct dentry *dentry;
+	struct eventfs_file *tmp;
+	LIST_HEAD(ef_del_list);
 
 	if (!ef)
 		return;
 
+	/*
+	 * Move the deleted eventfs_inodes onto the ei_del_list
+	 * which will also set the is_freed value. Note, this has to be
+	 * done under the eventfs_mutex, but the deletions of
+	 * the dentries must be done outside the eventfs_mutex.
+	 * Hence moving them to this temporary list.
+	 */
 	mutex_lock(&eventfs_mutex);
-	dentry = ef->dentry;
-	eventfs_remove_rec(ef, 0);
+	eventfs_remove_rec(ef, &ef_del_list, 0);
 	mutex_unlock(&eventfs_mutex);
 
-	/*
-	 * If any of the ei children has a dentry, then the ei itself
-	 * must have a dentry.
-	 */
-	if (dentry)
-		simple_recursive_removal(dentry, NULL);
+	list_for_each_entry_safe(ef, tmp, &ef_del_list, del_list) {
+		unhook_dentry(ef->dentry);
+		list_del(&ef->del_list);
+		call_srcu(&eventfs_srcu, &ef->rcu, free_rcu_ef);
+	}
 }
 
 /**
@@ -954,8 +966,6 @@ void eventfs_remove(struct eventfs_file
  */
 void eventfs_remove_events_dir(struct dentry *dentry)
 {
-	struct eventfs_file *ef_child;
-	struct eventfs_inode *ei;
 	struct tracefs_inode *ti;
 
 	if (!dentry || !dentry->d_inode)
@@ -965,11 +975,6 @@ void eventfs_remove_events_dir(struct de
 	if (!ti || !(ti->flags & TRACEFS_EVENT_INODE))
 		return;
 
-	mutex_lock(&eventfs_mutex);
-	ei = ti->private;
-	list_for_each_entry_srcu(ef_child, &ei->e_top_files, list,
-				 lockdep_is_held(&eventfs_mutex)) {
-		eventfs_remove_rec(ef_child, 0);
-	}
-	mutex_unlock(&eventfs_mutex);
+	d_invalidate(dentry);
+	dput(dentry);
 }


