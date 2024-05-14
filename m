Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76B35028C;
	Tue, 14 May 2024 11:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685997; cv=none; b=E+8hc/0cPC1HBcY4T/4u6MxCcD39ramHubvTYC4RMr5dBb6meHkgbatunHwzAsIxyTpmigHuPq6HNPKig13U264j0Qb5TCgDxg+1Q1lSWdVVOOwbhzyLk1B8tgm4PWlc1rbwUuBoigsa2m9RKs8jA4ezxqL3TMt3MWFpT0U0wCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685997; c=relaxed/simple;
	bh=6epk6uQ1/B02hZMjBiS3ieyBIYhZo/BqRBDd2TY/+Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbqhVQO3OL99hpOtWTQe/634yFe44nZmoFNQ2LhZNsXQ6Z8j89XvILORwU9Qtdu0SvUhMm9apiqQ5un4/gIGo2q9EOqVF4qJz5ko/s6JVfivtpQRMrYbchKcFvgSV+H0gAjJX3kvEaUiwa7A9rAuj/h+iUso0GSSksABPqZDYpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4Va3GR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4Va3GR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA43FC2BD10;
	Tue, 14 May 2024 11:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685996;
	bh=6epk6uQ1/B02hZMjBiS3ieyBIYhZo/BqRBDd2TY/+Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4Va3GR9lYXdqdHLRLY9+LpS093bqESWRDmG5QiL43JwxZJ7DruCa1B0nCfnwjUSm
	 Mqmk2JMEfkxjC2/XtDrOBLzAG7Y+D4xULgqOkxNmN+LCiTdlbsgH7ZRCgi2tKBUyBb
	 mkihVo+wfTKjqVabE8FnmoJ4YyZ+QaiDO1hqzfQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 292/301] eventfs: Do not differentiate the toplevel events directory
Date: Tue, 14 May 2024 12:19:23 +0200
Message-ID: <20240514101043.285854666@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit d53891d348ac3eceaf48f4732a1f4f5c0e0a55ce upstream.

The toplevel events directory is really no different than the events
directory of instances. Having the two be different caused
inconsistencies and made it harder to fix the permissions bugs.

Make all events directories act the same.

Link: https://lore.kernel.org/linux-trace-kernel/20240502200905.846448710@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 8186fff7ab649 ("tracefs/eventfs: Use root and instance inodes as default ownership")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   29 ++++++++---------------------
 fs/tracefs/internal.h    |    7 +++----
 2 files changed, 11 insertions(+), 25 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -57,7 +57,6 @@ enum {
 	EVENTFS_SAVE_MODE	= BIT(16),
 	EVENTFS_SAVE_UID	= BIT(17),
 	EVENTFS_SAVE_GID	= BIT(18),
-	EVENTFS_TOPLEVEL	= BIT(19),
 };
 
 #define EVENTFS_MODE_MASK	(EVENTFS_SAVE_MODE - 1)
@@ -196,14 +195,10 @@ static int eventfs_set_attr(struct mnt_i
 	return ret;
 }
 
-static void update_top_events_attr(struct eventfs_inode *ei, struct super_block *sb)
+static void update_events_attr(struct eventfs_inode *ei, struct super_block *sb)
 {
 	struct inode *root;
 
-	/* Only update if the "events" was on the top level */
-	if (!ei || !(ei->attr.mode & EVENTFS_TOPLEVEL))
-		return;
-
 	/* Get the tracefs root inode. */
 	root = d_inode(sb->s_root);
 	ei->attr.uid = root->i_uid;
@@ -216,10 +211,10 @@ static void set_top_events_ownership(str
 	struct eventfs_inode *ei = ti->private;
 
 	/* The top events directory doesn't get automatically updated */
-	if (!ei || !ei->is_events || !(ei->attr.mode & EVENTFS_TOPLEVEL))
+	if (!ei || !ei->is_events)
 		return;
 
-	update_top_events_attr(ei, inode->i_sb);
+	update_events_attr(ei, inode->i_sb);
 
 	if (!(ei->attr.mode & EVENTFS_SAVE_UID))
 		inode->i_uid = ei->attr.uid;
@@ -248,7 +243,7 @@ static int eventfs_permission(struct mnt
 	return generic_permission(idmap, inode, mask);
 }
 
-static const struct inode_operations eventfs_root_dir_inode_operations = {
+static const struct inode_operations eventfs_dir_inode_operations = {
 	.lookup		= eventfs_root_lookup,
 	.setattr	= eventfs_set_attr,
 	.getattr	= eventfs_get_attr,
@@ -316,7 +311,7 @@ static struct eventfs_inode *eventfs_fin
 		// Walk upwards until you find the events inode
 	} while (!ei->is_events);
 
-	update_top_events_attr(ei, dentry->d_sb);
+	update_events_attr(ei, dentry->d_sb);
 
 	return ei;
 }
@@ -420,7 +415,7 @@ static struct dentry *lookup_dir_entry(s
 	update_inode_attr(dentry, inode, &ei->attr,
 			  S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO);
 
-	inode->i_op = &eventfs_root_dir_inode_operations;
+	inode->i_op = &eventfs_dir_inode_operations;
 	inode->i_fop = &eventfs_file_operations;
 
 	/* All directories will have the same inode number */
@@ -769,14 +764,6 @@ struct eventfs_inode *eventfs_create_eve
 	uid = d_inode(dentry->d_parent)->i_uid;
 	gid = d_inode(dentry->d_parent)->i_gid;
 
-	/*
-	 * If the events directory is of the top instance, then parent
-	 * is NULL. Set the attr.mode to reflect this and its permissions will
-	 * default to the tracefs root dentry.
-	 */
-	if (!parent)
-		ei->attr.mode = EVENTFS_TOPLEVEL;
-
 	/* This is used as the default ownership of the files and directories */
 	ei->attr.uid = uid;
 	ei->attr.gid = gid;
@@ -785,13 +772,13 @@ struct eventfs_inode *eventfs_create_eve
 	INIT_LIST_HEAD(&ei->list);
 
 	ti = get_tracefs(inode);
-	ti->flags |= TRACEFS_EVENT_INODE | TRACEFS_EVENT_TOP_INODE;
+	ti->flags |= TRACEFS_EVENT_INODE;
 	ti->private = ei;
 
 	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	inode->i_uid = uid;
 	inode->i_gid = gid;
-	inode->i_op = &eventfs_root_dir_inode_operations;
+	inode->i_op = &eventfs_dir_inode_operations;
 	inode->i_fop = &eventfs_file_operations;
 
 	dentry->d_fsdata = get_ei(ei);
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -4,10 +4,9 @@
 
 enum {
 	TRACEFS_EVENT_INODE		= BIT(1),
-	TRACEFS_EVENT_TOP_INODE		= BIT(2),
-	TRACEFS_GID_PERM_SET		= BIT(3),
-	TRACEFS_UID_PERM_SET		= BIT(4),
-	TRACEFS_INSTANCE_INODE		= BIT(5),
+	TRACEFS_GID_PERM_SET		= BIT(2),
+	TRACEFS_UID_PERM_SET		= BIT(3),
+	TRACEFS_INSTANCE_INODE		= BIT(4),
 };
 
 struct tracefs_inode {


