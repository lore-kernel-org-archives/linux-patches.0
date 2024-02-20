Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30BA14A4E6;
	Tue, 20 Feb 2024 21:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464132; cv=none; b=HqzMGvZkIrblYT7bSPPBD9FYSE93Rz+uOAA++RSYZsIWEtP69S4n7/B3rtYkogI8qr8mITWdgGgRDS0zziHwy7Urp2LNw0jC8GPl8MViGtzspZTXMGiDRh9JquVjmJ1ygma28iXG4rTntWuGEcUY+qc54fSET2osGcSR6/YMWA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464132; c=relaxed/simple;
	bh=GJpsMAZ6h4Tfp/okkhbK0Hp/eLo9oqSPH1vjHTFFFrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHWHPD80aDPDctteOw1yrfCgfLAgjCMFv4J2Y21HK7+e9S7qFdRfLafkYg9/SaJ6PT1SSWwrs53UROT/6nDPd2WoK1YIS+8LGRf/aFRw291JpIKfy7nMEGG5wWHX01VjfiQcTL21jbvi9Si36K3rv2jKkLO4RPQCmyFIN6yH1ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1kTc/F9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1kTc/F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609B1C433C7;
	Tue, 20 Feb 2024 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464131;
	bh=GJpsMAZ6h4Tfp/okkhbK0Hp/eLo9oqSPH1vjHTFFFrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1kTc/F90dEl98Oh4da06VCT4WDZrKZdEYZx7cpBAYpSRkk1PmHgZImrlMi3YbC9L
	 er52SD3a/6zlnPn/Qr5s0uNKUaNkckBw3k6C0Ao6idhH8daOjqcQo6aDF0FVFniUOm
	 tpRc7AbNHV1ovX099uSreHK1mkOxQTXn9PemCDmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 261/331] Revert "eventfs: Delete eventfs_inode when the last dentry is freed"
Date: Tue, 20 Feb 2024 21:56:17 +0100
Message-ID: <20240220205646.068543608@linuxfoundation.org>
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

This reverts commit ea4c30a0a73fb5cb2604539db550f1e620bb949c.

The eventfs was not designed properly and may have some hidden bugs in it.
Linus rewrote it properly and I trust his version more than this one. Revert
the backported patches for 6.6 and re-apply all the changes to make it
equivalent to Linus's version.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |  150 +++++++++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 74 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -53,12 +53,10 @@ struct eventfs_file {
 	const struct inode_operations	*iop;
 	/*
 	 * Union - used for deletion
-	 * @llist:	for calling dput() if needed after RCU
 	 * @del_list:	list of eventfs_file to delete
 	 * @rcu:	eventfs_file to delete in RCU
 	 */
 	union {
-		struct llist_node	llist;
 		struct list_head	del_list;
 		struct rcu_head		rcu;
 	};
@@ -115,7 +113,8 @@ static int eventfs_set_attr(struct mnt_i
 
 	mutex_lock(&eventfs_mutex);
 	ef = dentry->d_fsdata;
-	if (ef->is_freed) {
+	/* The LSB is set when the eventfs_inode is being freed */
+	if (((unsigned long)ef & 1UL) || ef->is_freed) {
 		/* Do not allow changes if the event is about to be removed. */
 		mutex_unlock(&eventfs_mutex);
 		return -ENODEV;
@@ -259,13 +258,6 @@ static struct dentry *create_dir(struct
 	return eventfs_end_creating(dentry);
 }
 
-static void free_ef(struct eventfs_file *ef)
-{
-	kfree(ef->name);
-	kfree(ef->ei);
-	kfree(ef);
-}
-
 /**
  * eventfs_set_ef_status_free - set the ef->status to free
  * @ti: the tracefs_inode of the dentry
@@ -278,20 +270,34 @@ void eventfs_set_ef_status_free(struct t
 {
 	struct tracefs_inode *ti_parent;
 	struct eventfs_inode *ei;
-	struct eventfs_file *ef;
+	struct eventfs_file *ef, *tmp;
 
 	/* The top level events directory may be freed by this */
 	if (unlikely(ti->flags & TRACEFS_EVENT_TOP_INODE)) {
+		LIST_HEAD(ef_del_list);
+
 		mutex_lock(&eventfs_mutex);
+
 		ei = ti->private;
 
+		/* Record all the top level files */
+		list_for_each_entry_srcu(ef, &ei->e_top_files, list,
+					 lockdep_is_held(&eventfs_mutex)) {
+			list_add_tail(&ef->del_list, &ef_del_list);
+		}
+
 		/* Nothing should access this, but just in case! */
 		ti->private = NULL;
+
 		mutex_unlock(&eventfs_mutex);
 
-		ef = dentry->d_fsdata;
-		if (ef)
-			free_ef(ef);
+		/* Now safely free the top level files and their children */
+		list_for_each_entry_safe(ef, tmp, &ef_del_list, del_list) {
+			list_del(&ef->del_list);
+			eventfs_remove(ef);
+		}
+
+		kfree(ei);
 		return;
 	}
 
@@ -305,13 +311,16 @@ void eventfs_set_ef_status_free(struct t
 	if (!ef)
 		goto out;
 
-	if (ef->is_freed) {
-		free_ef(ef);
-	} else {
-		ef->dentry = NULL;
-	}
+	/*
+	 * If ef was freed, then the LSB bit is set for d_fsdata.
+	 * But this should not happen, as it should still have a
+	 * ref count that prevents it. Warn in case it does.
+	 */
+	if (WARN_ON_ONCE((unsigned long)ef & 1))
+		goto out;
 
 	dentry->d_fsdata = NULL;
+	ef->dentry = NULL;
 out:
 	mutex_unlock(&eventfs_mutex);
 }
@@ -838,53 +847,13 @@ int eventfs_add_file(const char *name, u
 	return 0;
 }
 
-static LLIST_HEAD(free_list);
-
-static void eventfs_workfn(struct work_struct *work)
-{
-        struct eventfs_file *ef, *tmp;
-        struct llist_node *llnode;
-
-	llnode = llist_del_all(&free_list);
-        llist_for_each_entry_safe(ef, tmp, llnode, llist) {
-		/* This should only get here if it had a dentry */
-		if (!WARN_ON_ONCE(!ef->dentry))
-			dput(ef->dentry);
-        }
-}
-
-static DECLARE_WORK(eventfs_work, eventfs_workfn);
-
-static void free_rcu_ef(struct rcu_head *head)
+static void free_ef(struct rcu_head *head)
 {
 	struct eventfs_file *ef = container_of(head, struct eventfs_file, rcu);
 
-	if (ef->dentry) {
-		/* Do not free the ef until all references of dentry are gone */
-		if (llist_add(&ef->llist, &free_list))
-			queue_work(system_unbound_wq, &eventfs_work);
-		return;
-	}
-
-	free_ef(ef);
-}
-
-static void unhook_dentry(struct dentry *dentry)
-{
-	if (!dentry)
-		return;
-
-	/* Keep the dentry from being freed yet (see eventfs_workfn()) */
-	dget(dentry);
-
-	dentry->d_fsdata = NULL;
-	d_invalidate(dentry);
-	mutex_lock(&eventfs_mutex);
-	/* dentry should now have at least a single reference */
-	WARN_ONCE((int)d_count(dentry) < 1,
-		  "dentry %px (%s) less than one reference (%d) after invalidate\n",
-		  dentry, dentry->d_name.name, d_count(dentry));
-	mutex_unlock(&eventfs_mutex);
+	kfree(ef->name);
+	kfree(ef->ei);
+	kfree(ef);
 }
 
 /**
@@ -936,25 +905,58 @@ void eventfs_remove(struct eventfs_file
 {
 	struct eventfs_file *tmp;
 	LIST_HEAD(ef_del_list);
+	struct dentry *dentry_list = NULL;
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
 	eventfs_remove_rec(ef, &ef_del_list, 0);
+	list_for_each_entry_safe(ef, tmp, &ef_del_list, del_list) {
+		if (ef->dentry) {
+			unsigned long ptr = (unsigned long)dentry_list;
+
+			/* Keep the dentry from being freed yet */
+			dget(ef->dentry);
+
+			/*
+			 * Paranoid: The dget() above should prevent the dentry
+			 * from being freed and calling eventfs_set_ef_status_free().
+			 * But just in case, set the link list LSB pointer to 1
+			 * and have eventfs_set_ef_status_free() check that to
+			 * make sure that if it does happen, it will not think
+			 * the d_fsdata is an event_file.
+			 *
+			 * For this to work, no event_file should be allocated
+			 * on a odd space, as the ef should always be allocated
+			 * to be at least word aligned. Check for that too.
+			 */
+			WARN_ON_ONCE(ptr & 1);
+
+			ef->dentry->d_fsdata = (void *)(ptr | 1);
+			dentry_list = ef->dentry;
+			ef->dentry = NULL;
+		}
+		call_srcu(&eventfs_srcu, &ef->rcu, free_ef);
+	}
 	mutex_unlock(&eventfs_mutex);
 
-	list_for_each_entry_safe(ef, tmp, &ef_del_list, del_list) {
-		unhook_dentry(ef->dentry);
-		list_del(&ef->del_list);
-		call_srcu(&eventfs_srcu, &ef->rcu, free_rcu_ef);
+	while (dentry_list) {
+		unsigned long ptr;
+
+		dentry = dentry_list;
+		ptr = (unsigned long)dentry->d_fsdata & ~1UL;
+		dentry_list = (struct dentry *)ptr;
+		dentry->d_fsdata = NULL;
+		d_invalidate(dentry);
+		mutex_lock(&eventfs_mutex);
+		/* dentry should now have at least a single reference */
+		WARN_ONCE((int)d_count(dentry) < 1,
+			  "dentry %p less than one reference (%d) after invalidate\n",
+			  dentry, d_count(dentry));
+		mutex_unlock(&eventfs_mutex);
+		dput(dentry);
 	}
 }
 


