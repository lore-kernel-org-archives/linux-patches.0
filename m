Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B4C151CD6;
	Tue, 20 Feb 2024 21:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464276; cv=none; b=aZsVjN99lKr/aXqTMdNgta07otHAvTuxtR68fULNtvlM6SelE/Xc0Eywfddh3T/nRM1gh2LSLO2KbfT90cvNQ2Be2Z2+ZePk8e6zMk9ZGUE9Bu2Dbt+UwKI08GDy1hBVjL7BCHoDQFxyEiXLQ9BORCfQoODeX8waJgtc+NFv94Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464276; c=relaxed/simple;
	bh=s7/xvxQGuXyts+a5dKi2e8F1sUocRjVi8mHLETCdCbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3gIwt01YTWPi95bwzq7hPs/KEY1XRXFBvbBFA7/wm+c0CAVV3lZNy5r45DBmJaIQJjb6MF1bNmFD9sqbpx+yUwvnhB1GsO58tjY5BevrqQTFvYAFv3UPH8NMMdUczmiXrSo9fIzBq55MjYRpgnXtwcktYMsndgiE7cvNMAgEUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IWe+B5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IWe+B5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51FCC433F1;
	Tue, 20 Feb 2024 21:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464276;
	bh=s7/xvxQGuXyts+a5dKi2e8F1sUocRjVi8mHLETCdCbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IWe+B5OuyS/cOIduQ0RdfIz1gc3uyXybKxdO+yLY100BBjvGX1LXsHmH13q6tCr5
	 tz8mEGzTu+ifHtmZdFwgs11jBohe49pITWPUT9w/xusZDB6ItqZ66EW1Uc3ku1V/4b
	 Q5W5smaCC3OjP4veYn9LEF1E15sMCX6LPPKF84sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ajay Kaher <akaher@vmware.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 278/331] eventfs: Delete eventfs_inode when the last dentry is freed
Date: Tue, 20 Feb 2024 21:56:34 +0100
Message-ID: <20240220205646.646785211@linuxfoundation.org>
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

commit 020010fbfa202aa528a52743eba4ab0da3400a4e upstream.

There exists a race between holding a reference of an eventfs_inode dentry
and the freeing of the eventfs_inode. If user space has a dentry held long
enough, it may still be able to access the dentry's eventfs_inode after it
has been freed.

To prevent this, have he eventfs_inode freed via the last dput() (or via
RCU if the eventfs_inode does not have a dentry).

This means reintroducing the eventfs_inode del_list field at a temporary
place to put the eventfs_inode. It needs to mark it as freed (via the
list) but also must invalidate the dentry immediately as the return from
eventfs_remove_dir() expects that they are. But the dentry invalidation
must not be called under the eventfs_mutex, so it must be done after the
eventfs_inode is marked as free (put on a deletion list).

Link: https://lkml.kernel.org/r/20231101172650.123479767@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ajay Kaher <akaher@vmware.com>
Fixes: 5bdcd5f5331a2 ("eventfs: Implement removal of meta data from eventfs")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |  146 +++++++++++++++++++++--------------------------
 fs/tracefs/internal.h    |    2 
 2 files changed, 69 insertions(+), 79 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -85,8 +85,7 @@ static int eventfs_set_attr(struct mnt_i
 
 	mutex_lock(&eventfs_mutex);
 	ei = dentry->d_fsdata;
-	/* The LSB is set when the eventfs_inode is being freed */
-	if (((unsigned long)ei & 1UL) || ei->is_freed) {
+	if (ei->is_freed) {
 		/* Do not allow changes if the event is about to be removed. */
 		mutex_unlock(&eventfs_mutex);
 		return -ENODEV;
@@ -276,35 +275,17 @@ static void free_ei(struct eventfs_inode
 void eventfs_set_ei_status_free(struct tracefs_inode *ti, struct dentry *dentry)
 {
 	struct tracefs_inode *ti_parent;
-	struct eventfs_inode *ei_child, *tmp;
 	struct eventfs_inode *ei;
 	int i;
 
 	/* The top level events directory may be freed by this */
 	if (unlikely(ti->flags & TRACEFS_EVENT_TOP_INODE)) {
-		LIST_HEAD(ef_del_list);
-
 		mutex_lock(&eventfs_mutex);
-
 		ei = ti->private;
-
-		/* Record all the top level files */
-		list_for_each_entry_srcu(ei_child, &ei->children, list,
-					 lockdep_is_held(&eventfs_mutex)) {
-			list_add_tail(&ei_child->del_list, &ef_del_list);
-		}
-
 		/* Nothing should access this, but just in case! */
 		ti->private = NULL;
-
 		mutex_unlock(&eventfs_mutex);
 
-		/* Now safely free the top level files and their children */
-		list_for_each_entry_safe(ei_child, tmp, &ef_del_list, del_list) {
-			list_del(&ei_child->del_list);
-			eventfs_remove_dir(ei_child);
-		}
-
 		free_ei(ei);
 		return;
 	}
@@ -319,14 +300,6 @@ void eventfs_set_ei_status_free(struct t
 	if (!ei)
 		goto out;
 
-	/*
-	 * If ei was freed, then the LSB bit is set for d_fsdata.
-	 * But this should not happen, as it should still have a
-	 * ref count that prevents it. Warn in case it does.
-	 */
-	if (WARN_ON_ONCE((unsigned long)ei & 1))
-		goto out;
-
 	/* This could belong to one of the files of the ei */
 	if (ei->dentry != dentry) {
 		for (i = 0; i < ei->nr_entries; i++) {
@@ -336,6 +309,8 @@ void eventfs_set_ei_status_free(struct t
 		if (WARN_ON_ONCE(i == ei->nr_entries))
 			goto out;
 		ei->d_children[i] = NULL;
+	} else if (ei->is_freed) {
+		free_ei(ei);
 	} else {
 		ei->dentry = NULL;
 	}
@@ -962,13 +937,65 @@ struct eventfs_inode *eventfs_create_eve
 	return ERR_PTR(-ENOMEM);
 }
 
+static LLIST_HEAD(free_list);
+
+static void eventfs_workfn(struct work_struct *work)
+{
+        struct eventfs_inode *ei, *tmp;
+        struct llist_node *llnode;
+
+	llnode = llist_del_all(&free_list);
+        llist_for_each_entry_safe(ei, tmp, llnode, llist) {
+		/* This dput() matches the dget() from unhook_dentry() */
+		for (int i = 0; i < ei->nr_entries; i++) {
+			if (ei->d_children[i])
+				dput(ei->d_children[i]);
+		}
+		/* This should only get here if it had a dentry */
+		if (!WARN_ON_ONCE(!ei->dentry))
+			dput(ei->dentry);
+        }
+}
+
+static DECLARE_WORK(eventfs_work, eventfs_workfn);
+
 static void free_rcu_ei(struct rcu_head *head)
 {
 	struct eventfs_inode *ei = container_of(head, struct eventfs_inode, rcu);
 
+	if (ei->dentry) {
+		/* Do not free the ei until all references of dentry are gone */
+		if (llist_add(&ei->llist, &free_list))
+			queue_work(system_unbound_wq, &eventfs_work);
+		return;
+	}
+
+	/* If the ei doesn't have a dentry, neither should its children */
+	for (int i = 0; i < ei->nr_entries; i++) {
+		WARN_ON_ONCE(ei->d_children[i]);
+	}
+
 	free_ei(ei);
 }
 
+static void unhook_dentry(struct dentry *dentry)
+{
+	if (!dentry)
+		return;
+
+	/* Keep the dentry from being freed yet (see eventfs_workfn()) */
+	dget(dentry);
+
+	dentry->d_fsdata = NULL;
+	d_invalidate(dentry);
+	mutex_lock(&eventfs_mutex);
+	/* dentry should now have at least a single reference */
+	WARN_ONCE((int)d_count(dentry) < 1,
+		  "dentry %px (%s) less than one reference (%d) after invalidate\n",
+		  dentry, dentry->d_name.name, d_count(dentry));
+	mutex_unlock(&eventfs_mutex);
+}
+
 /**
  * eventfs_remove_rec - remove eventfs dir or file from list
  * @ei: eventfs_inode to be removed.
@@ -1006,33 +1033,6 @@ static void eventfs_remove_rec(struct ev
 	list_add_tail(&ei->del_list, head);
 }
 
-static void unhook_dentry(struct dentry **dentry, struct dentry **list)
-{
-	if (*dentry) {
-		unsigned long ptr = (unsigned long)*list;
-
-		/* Keep the dentry from being freed yet */
-		dget(*dentry);
-
-		/*
-		 * Paranoid: The dget() above should prevent the dentry
-		 * from being freed and calling eventfs_set_ei_status_free().
-		 * But just in case, set the link list LSB pointer to 1
-		 * and have eventfs_set_ei_status_free() check that to
-		 * make sure that if it does happen, it will not think
-		 * the d_fsdata is an eventfs_inode.
-		 *
-		 * For this to work, no eventfs_inode should be allocated
-		 * on a odd space, as the ef should always be allocated
-		 * to be at least word aligned. Check for that too.
-		 */
-		WARN_ON_ONCE(ptr & 1);
-
-		(*dentry)->d_fsdata = (void *)(ptr | 1);
-		*list = *dentry;
-		*dentry = NULL;
-	}
-}
 /**
  * eventfs_remove_dir - remove eventfs dir or file from list
  * @ei: eventfs_inode to be removed.
@@ -1043,40 +1043,28 @@ void eventfs_remove_dir(struct eventfs_i
 {
 	struct eventfs_inode *tmp;
 	LIST_HEAD(ei_del_list);
-	struct dentry *dentry_list = NULL;
-	struct dentry *dentry;
-	int i;
 
 	if (!ei)
 		return;
 
+	/*
+	 * Move the deleted eventfs_inodes onto the ei_del_list
+	 * which will also set the is_freed value. Note, this has to be
+	 * done under the eventfs_mutex, but the deletions of
+	 * the dentries must be done outside the eventfs_mutex.
+	 * Hence moving them to this temporary list.
+	 */
 	mutex_lock(&eventfs_mutex);
 	eventfs_remove_rec(ei, &ei_del_list, 0);
+	mutex_unlock(&eventfs_mutex);
 
 	list_for_each_entry_safe(ei, tmp, &ei_del_list, del_list) {
-		for (i = 0; i < ei->nr_entries; i++)
-			unhook_dentry(&ei->d_children[i], &dentry_list);
-		unhook_dentry(&ei->dentry, &dentry_list);
+		for (int i = 0; i < ei->nr_entries; i++)
+			unhook_dentry(ei->d_children[i]);
+		unhook_dentry(ei->dentry);
+		list_del(&ei->del_list);
 		call_srcu(&eventfs_srcu, &ei->rcu, free_rcu_ei);
 	}
-	mutex_unlock(&eventfs_mutex);
-
-	while (dentry_list) {
-		unsigned long ptr;
-
-		dentry = dentry_list;
-		ptr = (unsigned long)dentry->d_fsdata & ~1UL;
-		dentry_list = (struct dentry *)ptr;
-		dentry->d_fsdata = NULL;
-		d_invalidate(dentry);
-		mutex_lock(&eventfs_mutex);
-		/* dentry should now have at least a single reference */
-		WARN_ONCE((int)d_count(dentry) < 1,
-			  "dentry %px (%s) less than one reference (%d) after invalidate\n",
-			  dentry, dentry->d_name.name, d_count(dentry));
-		mutex_unlock(&eventfs_mutex);
-		dput(dentry);
-	}
 }
 
 /**
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -54,10 +54,12 @@ struct eventfs_inode {
 	void				*data;
 	/*
 	 * Union - used for deletion
+	 * @llist:	for calling dput() if needed after RCU
 	 * @del_list:	list of eventfs_inode to delete
 	 * @rcu:	eventfs_inode to delete in RCU
 	 */
 	union {
+		struct llist_node	llist;
 		struct list_head	del_list;
 		struct rcu_head		rcu;
 	};


