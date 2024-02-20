Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D87151CF9;
	Tue, 20 Feb 2024 21:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464282; cv=none; b=Aag61oNvQNRqCGMjmHCPDwOlZQ/LDVnI5Q25yPtHYDODnvqa7c6xNiE+i5l4WObz3isy3eJYcQNLnC2AZqUnKJxTi7Rjw7GPAYbxIDntWHSHxo5ojFgZexOVIRn3RXem0C9MCCfvn10FhikHeDFZEx4adjJpcYSjyuSR9B1KzYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464282; c=relaxed/simple;
	bh=yC6nRGmCJuCIKZUhxcPph8e0/1Qdys4+IdRxZX4LvN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbYdyG/Tc8QQ6TEE4YSiRY8sZDldjvUViZu3NSH68FkKmvVmYiupAv72//Cy4wapmXoU2ROg0NNGGqPv+CFPjnF4ptt4AGAxCB70UY00NtWLIPZ8VXxRLoMCpjfV0A3TkN3WwCRO9rlMOBIXGSGwnGxYo/4hJKPzp7x6frgNA6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zmuee8M3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zmuee8M3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1A3C43390;
	Tue, 20 Feb 2024 21:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464282;
	bh=yC6nRGmCJuCIKZUhxcPph8e0/1Qdys4+IdRxZX4LvN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zmuee8M39jfaxDxSTpMON360H/OmkYMPd8lhf0d5Ui0kDdsTFXOQBGcpcS3vlYBRk
	 EcMvuBAYpoCKtC/3Gm1ddpDBEXZLAknfB9NxnfNbqKlSRBz5EtFLf+qmC1ayYU5axd
	 0mTg1fAkQ+muTBPl/pXjs/BuVJUpw6fCXxDoB6nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 280/331] eventfs: Use simple_recursive_removal() to clean up dentries
Date: Tue, 20 Feb 2024 21:56:36 +0100
Message-ID: <20240220205646.724512381@linuxfoundation.org>
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

commit 407c6726ca71b33330d2d6345d9ea7ebc02575e9 upstream.

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
 fs/tracefs/event_inode.c |   77 ++++++++++++++++++++++++++---------------------
 fs/tracefs/internal.h    |    2 -
 2 files changed, 44 insertions(+), 35 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -967,30 +967,29 @@ static void unhook_dentry(struct dentry
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
  * @ei: eventfs_inode to be removed.
- * @head: the list head to place the deleted @ei and children
  * @level: prevent recursion from going more than 3 levels deep.
  *
  * This function recursively removes eventfs_inodes which
  * contains info of files and/or directories.
  */
-static void eventfs_remove_rec(struct eventfs_inode *ei, struct list_head *head, int level)
+static void eventfs_remove_rec(struct eventfs_inode *ei, int level)
 {
 	struct eventfs_inode *ei_child;
 
@@ -1009,13 +1008,26 @@ static void eventfs_remove_rec(struct ev
 	/* search for nested folders or files */
 	list_for_each_entry_srcu(ei_child, &ei->children, list,
 				 lockdep_is_held(&eventfs_mutex)) {
-		eventfs_remove_rec(ei_child, head, level + 1);
+		/* Children only have dentry if parent does */
+		WARN_ON_ONCE(ei_child->dentry && !ei->dentry);
+		eventfs_remove_rec(ei_child, level + 1);
 	}
 
+
 	ei->is_freed = 1;
 
+	for (int i = 0; i < ei->nr_entries; i++) {
+		if (ei->d_children[i]) {
+			/* Children only have dentry if parent does */
+			WARN_ON_ONCE(!ei->dentry);
+			unhook_dentry(ei->d_children[i]);
+		}
+	}
+
+	unhook_dentry(ei->dentry);
+
 	list_del_rcu(&ei->list);
-	list_add_tail(&ei->del_list, head);
+	call_srcu(&eventfs_srcu, &ei->rcu, free_rcu_ei);
 }
 
 /**
@@ -1026,30 +1038,22 @@ static void eventfs_remove_rec(struct ev
  */
 void eventfs_remove_dir(struct eventfs_inode *ei)
 {
-	struct eventfs_inode *tmp;
-	LIST_HEAD(ei_del_list);
+	struct dentry *dentry;
 
 	if (!ei)
 		return;
 
-	/*
-	 * Move the deleted eventfs_inodes onto the ei_del_list
-	 * which will also set the is_freed value. Note, this has to be
-	 * done under the eventfs_mutex, but the deletions of
-	 * the dentries must be done outside the eventfs_mutex.
-	 * Hence moving them to this temporary list.
-	 */
 	mutex_lock(&eventfs_mutex);
-	eventfs_remove_rec(ei, &ei_del_list, 0);
+	dentry = ei->dentry;
+	eventfs_remove_rec(ei, 0);
 	mutex_unlock(&eventfs_mutex);
 
-	list_for_each_entry_safe(ei, tmp, &ei_del_list, del_list) {
-		for (int i = 0; i < ei->nr_entries; i++)
-			unhook_dentry(ei->d_children[i]);
-		unhook_dentry(ei->dentry);
-		list_del(&ei->del_list);
-		call_srcu(&eventfs_srcu, &ei->rcu, free_rcu_ei);
-	}
+	/*
+	 * If any of the ei children has a dentry, then the ei itself
+	 * must have a dentry.
+	 */
+	if (dentry)
+		simple_recursive_removal(dentry, NULL);
 }
 
 /**
@@ -1060,10 +1064,17 @@ void eventfs_remove_dir(struct eventfs_i
  */
 void eventfs_remove_events_dir(struct eventfs_inode *ei)
 {
-	struct dentry *dentry = ei->dentry;
+	struct dentry *dentry;
 
+	dentry = ei->dentry;
 	eventfs_remove_dir(ei);
 
-	/* Matches the dget() from eventfs_create_events_dir() */
+	/*
+	 * Matches the dget() done by tracefs_start_creating()
+	 * in eventfs_create_events_dir() when it the dentry was
+	 * created. In other words, it's a normal dentry that
+	 * sticks around while the other ei->dentry are created
+	 * and destroyed dynamically.
+	 */
 	dput(dentry);
 }
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -55,12 +55,10 @@ struct eventfs_inode {
 	/*
 	 * Union - used for deletion
 	 * @llist:	for calling dput() if needed after RCU
-	 * @del_list:	list of eventfs_inode to delete
 	 * @rcu:	eventfs_inode to delete in RCU
 	 */
 	union {
 		struct llist_node	llist;
-		struct list_head	del_list;
 		struct rcu_head		rcu;
 	};
 	unsigned int			is_freed:1;


