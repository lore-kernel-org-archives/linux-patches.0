Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9858F200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="us/M8d4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177CCC433C9;
	Mon,  6 Nov 2023 13:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276142;
	bh=fpKJIAemHMnVurcYwhsyAB6B0QlhESpQIRZiJ8bNs9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=us/M8d4sVOGnbJ8gQppdjLKNcyvBymuVYL6RhmnJZmpbUbpG2Q8yFsDF6TI7HmH+v
	 wZR0LbiuDld3ZCjJMed3pqD/vtEbjewb/LvqIOOUt0ROvw8tMeUmNO+UhhF5K4gqLY
	 IjvrqvsZHgiGLQSydwFJceHqi0SF6qFSnaCVtdnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 08/30] eventfs: Use simple_recursive_removal() to clean up dentries
Date: Mon,  6 Nov 2023 14:03:26 +0100
Message-ID: <20231106130258.225254857@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
References: <20231106130257.903265688@linuxfoundation.org>
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

commit 407c6726ca71b33330d2d6345d9ea7ebc02575e9 upstream

Looking at how dentry is removed via the tracefs system, I found that
eventfs does not do everything that it did under tracefs. The tracefs
removal of a dentry calls simple_recursive_removal() that does a lot more
than a simple d_invalidate().

As it should be a requirement that any eventfs_inode that has a dentry, so
does its parent. When removing a eventfs_inode, if it has a dentry, a call
to simple_recursive_removal() on that dentry should clean up all the
dentries underneath it.

Add WARN_ON_ONCE() to check for the parent having a dentry if any children
do.

Link: https://lore.kernel.org/all/20231101022553.GE1957730@ZenIV/
Link: https://lkml.kernel.org/r/20231101172650.552471568@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Fixes: 5bdcd5f5331a2 ("eventfs: Implement removal of meta data from eventfs")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   71 +++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 38 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -54,12 +54,10 @@ struct eventfs_file {
 	/*
 	 * Union - used for deletion
 	 * @llist:	for calling dput() if needed after RCU
-	 * @del_list:	list of eventfs_file to delete
 	 * @rcu:	eventfs_file to delete in RCU
 	 */
 	union {
 		struct llist_node	llist;
-		struct list_head	del_list;
 		struct rcu_head		rcu;
 	};
 	void				*data;
@@ -276,7 +274,6 @@ static void free_ef(struct eventfs_file
  */
 void eventfs_set_ef_status_free(struct tracefs_inode *ti, struct dentry *dentry)
 {
-	struct tracefs_inode *ti_parent;
 	struct eventfs_inode *ei;
 	struct eventfs_file *ef;
 
@@ -297,10 +294,6 @@ void eventfs_set_ef_status_free(struct t
 
 	mutex_lock(&eventfs_mutex);
 
-	ti_parent = get_tracefs(dentry->d_parent->d_inode);
-	if (!ti_parent || !(ti_parent->flags & TRACEFS_EVENT_INODE))
-		goto out;
-
 	ef = dentry->d_fsdata;
 	if (!ef)
 		goto out;
@@ -873,30 +866,29 @@ static void unhook_dentry(struct dentry
 {
 	if (!dentry)
 		return;
-
-	/* Keep the dentry from being freed yet (see eventfs_workfn()) */
+	/*
+	 * Need to add a reference to the dentry that is expected by
+	 * simple_recursive_removal(), which will include a dput().
+	 */
 	dget(dentry);
 
-	dentry->d_fsdata = NULL;
-	d_invalidate(dentry);
-	mutex_lock(&eventfs_mutex);
-	/* dentry should now have at least a single reference */
-	WARN_ONCE((int)d_count(dentry) < 1,
-		  "dentry %px (%s) less than one reference (%d) after invalidate\n",
-		  dentry, dentry->d_name.name, d_count(dentry));
-	mutex_unlock(&eventfs_mutex);
+	/*
+	 * Also add a reference for the dput() in eventfs_workfn().
+	 * That is required as that dput() will free the ei after
+	 * the SRCU grace period is over.
+	 */
+	dget(dentry);
 }
 
 /**
  * eventfs_remove_rec - remove eventfs dir or file from list
  * @ef: eventfs_file to be removed.
- * @head: to create list of eventfs_file to be deleted
  * @level: to check recursion depth
  *
  * The helper function eventfs_remove_rec() is used to clean up and free the
  * associated data from eventfs for both of the added functions.
  */
-static void eventfs_remove_rec(struct eventfs_file *ef, struct list_head *head, int level)
+static void eventfs_remove_rec(struct eventfs_file *ef, int level)
 {
 	struct eventfs_file *ef_child;
 
@@ -916,14 +908,16 @@ static void eventfs_remove_rec(struct ev
 		/* search for nested folders or files */
 		list_for_each_entry_srcu(ef_child, &ef->ei->e_top_files, list,
 					 lockdep_is_held(&eventfs_mutex)) {
-			eventfs_remove_rec(ef_child, head, level + 1);
+			eventfs_remove_rec(ef_child, level + 1);
 		}
 	}
 
 	ef->is_freed = 1;
 
+	unhook_dentry(ef->dentry);
+
 	list_del_rcu(&ef->list);
-	list_add_tail(&ef->del_list, head);
+	call_srcu(&eventfs_srcu, &ef->rcu, free_rcu_ef);
 }
 
 /**
@@ -934,28 +928,22 @@ static void eventfs_remove_rec(struct ev
  */
 void eventfs_remove(struct eventfs_file *ef)
 {
-	struct eventfs_file *tmp;
-	LIST_HEAD(ef_del_list);
+	struct dentry *dentry;
 
 	if (!ef)
 		return;
 
-	/*
-	 * Move the deleted eventfs_inodes onto the ei_del_list
-	 * which will also set the is_freed value. Note, this has to be
-	 * done under the eventfs_mutex, but the deletions of
-	 * the dentries must be done outside the eventfs_mutex.
-	 * Hence moving them to this temporary list.
-	 */
 	mutex_lock(&eventfs_mutex);
-	eventfs_remove_rec(ef, &ef_del_list, 0);
+	dentry = ef->dentry;
+	eventfs_remove_rec(ef, 0);
 	mutex_unlock(&eventfs_mutex);
 
-	list_for_each_entry_safe(ef, tmp, &ef_del_list, del_list) {
-		unhook_dentry(ef->dentry);
-		list_del(&ef->del_list);
-		call_srcu(&eventfs_srcu, &ef->rcu, free_rcu_ef);
-	}
+	/*
+	 * If any of the ei children has a dentry, then the ei itself
+	 * must have a dentry.
+	 */
+	if (dentry)
+		simple_recursive_removal(dentry, NULL);
 }
 
 /**
@@ -966,6 +954,8 @@ void eventfs_remove(struct eventfs_file
  */
 void eventfs_remove_events_dir(struct dentry *dentry)
 {
+	struct eventfs_file *ef_child;
+	struct eventfs_inode *ei;
 	struct tracefs_inode *ti;
 
 	if (!dentry || !dentry->d_inode)
@@ -975,6 +965,11 @@ void eventfs_remove_events_dir(struct de
 	if (!ti || !(ti->flags & TRACEFS_EVENT_INODE))
 		return;
 
-	d_invalidate(dentry);
-	dput(dentry);
+	mutex_lock(&eventfs_mutex);
+	ei = ti->private;
+	list_for_each_entry_srcu(ef_child, &ei->e_top_files, list,
+				 lockdep_is_held(&eventfs_mutex)) {
+		eventfs_remove_rec(ef_child, 0);
+	}
+	mutex_unlock(&eventfs_mutex);
 }


