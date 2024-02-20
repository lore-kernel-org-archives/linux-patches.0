Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38F92DF9F;
	Tue, 20 Feb 2024 21:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464238; cv=none; b=DqlZmZYOwfYfeDUsxP57VYiITrfY3NKGc3Kb1juuXd543i9adryD8+w3EKwEo/9S/UiXHqMQzSwjQMscVSzohQuGazot1UvA9x3FDa9LsONMQJb5k/N2AqKuQsyLruG5rY2ARW4n24vlXnPqO1G224MipO/MkqS1sIXBR1x5EO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464238; c=relaxed/simple;
	bh=oZmxknuVjCaivSsmgozYpSqrohUEYbc2ev3ISsUvv0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbjPdetDTKJFYc6Pe46jyF9CHNHUq9lxyc5SpYN6e0oIvADtQhZ42S/KU0D6yyeiS4YWkIBeS65UMvIjUeViTc0avUI/6nOAOnw/gMK0V+VgRpN5e1FbfNd8Rrp8lbpGo+EI2E7s+zyWQJ9HQ7NvOIThzlWFDO15taZ2oKAzcvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxzTIHEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxzTIHEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF92C433C7;
	Tue, 20 Feb 2024 21:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464238;
	bh=oZmxknuVjCaivSsmgozYpSqrohUEYbc2ev3ISsUvv0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxzTIHEncocu3knc/JedXReF9tv/n92WCdETynUCPLBchUuqxvyaxk5JILeY4KY+V
	 61NdKV8UPaPLDcY8XR+ICj27WMRYXUZ4WvMzJJzIRpCrBleQtSA2Yc01szzTdDAH2s
	 m2wHpj0d30650419T1+MwyAec/COSrVzEeLMkPm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 294/331] tracefs/eventfs: Use root and instance inodes as default ownership
Date: Tue, 20 Feb 2024 21:56:50 +0100
Message-ID: <20240220205647.280522786@linuxfoundation.org>
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

commit 8186fff7ab649085e2c60d032d9a20a85af1d87c upstream.

Instead of walking the dentries on mount/remount to update the gid values of
all the dentries if a gid option is specified on mount, just update the root
inode. Add .getattr, .setattr, and .permissions on the tracefs inode
operations to update the permissions of the files and directories.

For all files and directories in the top level instance:

 /sys/kernel/tracing/*

It will use the root inode as the default permissions. The inode that
represents: /sys/kernel/tracing (or wherever it is mounted).

When an instance is created:

 mkdir /sys/kernel/tracing/instance/foo

The directory "foo" and all its files and directories underneath will use
the default of what foo is when it was created. A remount of tracefs will
not affect it.

If a user were to modify the permissions of any file or directory in
tracefs, it will also no longer be modified by a change in ownership of a
remount.

The events directory, if it is in the top level instance, will use the
tracefs root inode as the default ownership for itself and all the files and
directories below it.

For the events directory in an instance ("foo"), it will keep the ownership
of what it was when it was created, and that will be used as the default
ownership for the files and directories beneath it.

Link: https://lore.kernel.org/linux-trace-kernel/CAHk-=wjVdGkjDXBbvLn2wbZnqP4UsH46E3gqJ9m7UG6DpX2+WA@mail.gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240103215016.1e0c9811@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   79 ++++++++++++++++++
 fs/tracefs/inode.c       |  198 ++++++++++++++++++++++++++---------------------
 fs/tracefs/internal.h    |    3 
 3 files changed, 190 insertions(+), 90 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -45,6 +45,7 @@ enum {
 	EVENTFS_SAVE_MODE	= BIT(16),
 	EVENTFS_SAVE_UID	= BIT(17),
 	EVENTFS_SAVE_GID	= BIT(18),
+	EVENTFS_TOPLEVEL	= BIT(19),
 };
 
 #define EVENTFS_MODE_MASK	(EVENTFS_SAVE_MODE - 1)
@@ -115,10 +116,17 @@ static int eventfs_set_attr(struct mnt_i
 		 * The events directory dentry is never freed, unless its
 		 * part of an instance that is deleted. It's attr is the
 		 * default for its child files and directories.
-		 * Do not update it. It's not used for its own mode or ownership
+		 * Do not update it. It's not used for its own mode or ownership.
 		 */
-		if (!ei->is_events)
+		if (ei->is_events) {
+			/* But it still needs to know if it was modified */
+			if (iattr->ia_valid & ATTR_UID)
+				ei->attr.mode |= EVENTFS_SAVE_UID;
+			if (iattr->ia_valid & ATTR_GID)
+				ei->attr.mode |= EVENTFS_SAVE_GID;
+		} else {
 			update_attr(&ei->attr, iattr);
+		}
 
 	} else {
 		name = dentry->d_name.name;
@@ -136,9 +144,66 @@ static int eventfs_set_attr(struct mnt_i
 	return ret;
 }
 
+static void update_top_events_attr(struct eventfs_inode *ei, struct dentry *dentry)
+{
+	struct inode *inode;
+
+	/* Only update if the "events" was on the top level */
+	if (!ei || !(ei->attr.mode & EVENTFS_TOPLEVEL))
+		return;
+
+	/* Get the tracefs root inode. */
+	inode = d_inode(dentry->d_sb->s_root);
+	ei->attr.uid = inode->i_uid;
+	ei->attr.gid = inode->i_gid;
+}
+
+static void set_top_events_ownership(struct inode *inode)
+{
+	struct tracefs_inode *ti = get_tracefs(inode);
+	struct eventfs_inode *ei = ti->private;
+	struct dentry *dentry;
+
+	/* The top events directory doesn't get automatically updated */
+	if (!ei || !ei->is_events || !(ei->attr.mode & EVENTFS_TOPLEVEL))
+		return;
+
+	dentry = ei->dentry;
+
+	update_top_events_attr(ei, dentry);
+
+	if (!(ei->attr.mode & EVENTFS_SAVE_UID))
+		inode->i_uid = ei->attr.uid;
+
+	if (!(ei->attr.mode & EVENTFS_SAVE_GID))
+		inode->i_gid = ei->attr.gid;
+}
+
+static int eventfs_get_attr(struct mnt_idmap *idmap,
+			    const struct path *path, struct kstat *stat,
+			    u32 request_mask, unsigned int flags)
+{
+	struct dentry *dentry = path->dentry;
+	struct inode *inode = d_backing_inode(dentry);
+
+	set_top_events_ownership(inode);
+
+	generic_fillattr(idmap, request_mask, inode, stat);
+	return 0;
+}
+
+static int eventfs_permission(struct mnt_idmap *idmap,
+			      struct inode *inode, int mask)
+{
+	set_top_events_ownership(inode);
+	return generic_permission(idmap, inode, mask);
+}
+
 static const struct inode_operations eventfs_root_dir_inode_operations = {
 	.lookup		= eventfs_root_lookup,
 	.setattr	= eventfs_set_attr,
+	.getattr	= eventfs_get_attr,
+	.permission	= eventfs_permission,
 };
 
 static const struct inode_operations eventfs_file_inode_operations = {
@@ -174,6 +239,8 @@ static struct eventfs_inode *eventfs_fin
 	} while (!ei->is_events);
 	mutex_unlock(&eventfs_mutex);
 
+	update_top_events_attr(ei, dentry);
+
 	return ei;
 }
 
@@ -887,6 +954,14 @@ struct eventfs_inode *eventfs_create_eve
 	uid = d_inode(dentry->d_parent)->i_uid;
 	gid = d_inode(dentry->d_parent)->i_gid;
 
+	/*
+	 * If the events directory is of the top instance, then parent
+	 * is NULL. Set the attr.mode to reflect this and its permissions will
+	 * default to the tracefs root dentry.
+	 */
+	if (!parent)
+		ei->attr.mode = EVENTFS_TOPLEVEL;
+
 	/* This is used as the default ownership of the files and directories */
 	ei->attr.uid = uid;
 	ei->attr.gid = gid;
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -91,6 +91,7 @@ static int tracefs_syscall_mkdir(struct
 				 struct inode *inode, struct dentry *dentry,
 				 umode_t mode)
 {
+	struct tracefs_inode *ti;
 	char *name;
 	int ret;
 
@@ -99,6 +100,15 @@ static int tracefs_syscall_mkdir(struct
 		return -ENOMEM;
 
 	/*
+	 * This is a new directory that does not take the default of
+	 * the rootfs. It becomes the default permissions for all the
+	 * files and directories underneath it.
+	 */
+	ti = get_tracefs(inode);
+	ti->flags |= TRACEFS_INSTANCE_INODE;
+	ti->private = inode;
+
+	/*
 	 * The mkdir call can call the generic functions that create
 	 * the files within the tracefs system. It is up to the individual
 	 * mkdir routine to handle races.
@@ -141,10 +151,76 @@ static int tracefs_syscall_rmdir(struct
 	return ret;
 }
 
-static const struct inode_operations tracefs_dir_inode_operations = {
+static void set_tracefs_inode_owner(struct inode *inode)
+{
+	struct tracefs_inode *ti = get_tracefs(inode);
+	struct inode *root_inode = ti->private;
+
+	/*
+	 * If this inode has never been referenced, then update
+	 * the permissions to the superblock.
+	 */
+	if (!(ti->flags & TRACEFS_UID_PERM_SET))
+		inode->i_uid = root_inode->i_uid;
+
+	if (!(ti->flags & TRACEFS_GID_PERM_SET))
+		inode->i_gid = root_inode->i_gid;
+}
+
+static int tracefs_permission(struct mnt_idmap *idmap,
+			      struct inode *inode, int mask)
+{
+	set_tracefs_inode_owner(inode);
+	return generic_permission(idmap, inode, mask);
+}
+
+static int tracefs_getattr(struct mnt_idmap *idmap,
+			   const struct path *path, struct kstat *stat,
+			   u32 request_mask, unsigned int flags)
+{
+	struct inode *inode = d_backing_inode(path->dentry);
+
+	set_tracefs_inode_owner(inode);
+	generic_fillattr(idmap, request_mask, inode, stat);
+	return 0;
+}
+
+static int tracefs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+			   struct iattr *attr)
+{
+	unsigned int ia_valid = attr->ia_valid;
+	struct inode *inode = d_inode(dentry);
+	struct tracefs_inode *ti = get_tracefs(inode);
+
+	if (ia_valid & ATTR_UID)
+		ti->flags |= TRACEFS_UID_PERM_SET;
+
+	if (ia_valid & ATTR_GID)
+		ti->flags |= TRACEFS_GID_PERM_SET;
+
+	return simple_setattr(idmap, dentry, attr);
+}
+
+static const struct inode_operations tracefs_instance_dir_inode_operations = {
 	.lookup		= simple_lookup,
 	.mkdir		= tracefs_syscall_mkdir,
 	.rmdir		= tracefs_syscall_rmdir,
+	.permission	= tracefs_permission,
+	.getattr	= tracefs_getattr,
+	.setattr	= tracefs_setattr,
+};
+
+static const struct inode_operations tracefs_dir_inode_operations = {
+	.lookup		= simple_lookup,
+	.permission	= tracefs_permission,
+	.getattr	= tracefs_getattr,
+	.setattr	= tracefs_setattr,
+};
+
+static const struct inode_operations tracefs_file_inode_operations = {
+	.permission	= tracefs_permission,
+	.getattr	= tracefs_getattr,
+	.setattr	= tracefs_setattr,
 };
 
 struct inode *tracefs_get_inode(struct super_block *sb)
@@ -183,87 +259,6 @@ struct tracefs_fs_info {
 	struct tracefs_mount_opts mount_opts;
 };
 
-static void change_gid(struct dentry *dentry, kgid_t gid)
-{
-	if (!dentry->d_inode)
-		return;
-	dentry->d_inode->i_gid = gid;
-}
-
-/*
- * Taken from d_walk, but without he need for handling renames.
- * Nothing can be renamed while walking the list, as tracefs
- * does not support renames. This is only called when mounting
- * or remounting the file system, to set all the files to
- * the given gid.
- */
-static void set_gid(struct dentry *parent, kgid_t gid)
-{
-	struct dentry *this_parent;
-	struct list_head *next;
-
-	this_parent = parent;
-	spin_lock(&this_parent->d_lock);
-
-	change_gid(this_parent, gid);
-repeat:
-	next = this_parent->d_subdirs.next;
-resume:
-	while (next != &this_parent->d_subdirs) {
-		struct tracefs_inode *ti;
-		struct list_head *tmp = next;
-		struct dentry *dentry = list_entry(tmp, struct dentry, d_child);
-		next = tmp->next;
-
-		/* Note, getdents() can add a cursor dentry with no inode */
-		if (!dentry->d_inode)
-			continue;
-
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-
-		change_gid(dentry, gid);
-
-		/* If this is the events directory, update that too */
-		ti = get_tracefs(dentry->d_inode);
-		if (ti && (ti->flags & TRACEFS_EVENT_INODE))
-			eventfs_update_gid(dentry, gid);
-
-		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, _RET_IP_);
-			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
-			goto repeat;
-		}
-		spin_unlock(&dentry->d_lock);
-	}
-	/*
-	 * All done at this level ... ascend and resume the search.
-	 */
-	rcu_read_lock();
-ascend:
-	if (this_parent != parent) {
-		struct dentry *child = this_parent;
-		this_parent = child->d_parent;
-
-		spin_unlock(&child->d_lock);
-		spin_lock(&this_parent->d_lock);
-
-		/* go into the first sibling still alive */
-		do {
-			next = child->d_child.next;
-			if (next == &this_parent->d_subdirs)
-				goto ascend;
-			child = list_entry(next, struct dentry, d_child);
-		} while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED));
-		rcu_read_unlock();
-		goto resume;
-	}
-	rcu_read_unlock();
-	spin_unlock(&this_parent->d_lock);
-	return;
-}
-
 static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 {
 	substring_t args[MAX_OPT_ARGS];
@@ -336,10 +331,8 @@ static int tracefs_apply_options(struct
 	if (!remount || opts->opts & BIT(Opt_uid))
 		inode->i_uid = opts->uid;
 
-	if (!remount || opts->opts & BIT(Opt_gid)) {
-		/* Set all the group ids to the mount option */
-		set_gid(sb->s_root, opts->gid);
-	}
+	if (!remount || opts->opts & BIT(Opt_gid))
+		inode->i_gid = opts->gid;
 
 	return 0;
 }
@@ -573,6 +566,26 @@ struct dentry *eventfs_end_creating(stru
 	return dentry;
 }
 
+/* Find the inode that this will use for default */
+static struct inode *instance_inode(struct dentry *parent, struct inode *inode)
+{
+	struct tracefs_inode *ti;
+
+	/* If parent is NULL then use root inode */
+	if (!parent)
+		return d_inode(inode->i_sb->s_root);
+
+	/* Find the inode that is flagged as an instance or the root inode */
+	while (!IS_ROOT(parent)) {
+		ti = get_tracefs(d_inode(parent));
+		if (ti->flags & TRACEFS_INSTANCE_INODE)
+			break;
+		parent = parent->d_parent;
+	}
+
+	return d_inode(parent);
+}
+
 /**
  * tracefs_create_file - create a file in the tracefs filesystem
  * @name: a pointer to a string containing the name of the file to create.
@@ -603,6 +616,7 @@ struct dentry *tracefs_create_file(const
 				   struct dentry *parent, void *data,
 				   const struct file_operations *fops)
 {
+	struct tracefs_inode *ti;
 	struct dentry *dentry;
 	struct inode *inode;
 
@@ -621,7 +635,11 @@ struct dentry *tracefs_create_file(const
 	if (unlikely(!inode))
 		return tracefs_failed_creating(dentry);
 
+	ti = get_tracefs(inode);
+	ti->private = instance_inode(parent, inode);
+
 	inode->i_mode = mode;
+	inode->i_op = &tracefs_file_inode_operations;
 	inode->i_fop = fops ? fops : &tracefs_file_operations;
 	inode->i_private = data;
 	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
@@ -634,6 +652,7 @@ struct dentry *tracefs_create_file(const
 static struct dentry *__create_dir(const char *name, struct dentry *parent,
 				   const struct inode_operations *ops)
 {
+	struct tracefs_inode *ti;
 	struct dentry *dentry = tracefs_start_creating(name, parent);
 	struct inode *inode;
 
@@ -651,6 +670,9 @@ static struct dentry *__create_dir(const
 	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
 	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 
+	ti = get_tracefs(inode);
+	ti->private = instance_inode(parent, inode);
+
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	d_instantiate(dentry, inode);
@@ -681,7 +703,7 @@ struct dentry *tracefs_create_dir(const
 	if (security_locked_down(LOCKDOWN_TRACEFS))
 		return NULL;
 
-	return __create_dir(name, parent, &simple_dir_inode_operations);
+	return __create_dir(name, parent, &tracefs_dir_inode_operations);
 }
 
 /**
@@ -712,7 +734,7 @@ __init struct dentry *tracefs_create_ins
 	if (WARN_ON(tracefs_ops.mkdir || tracefs_ops.rmdir))
 		return NULL;
 
-	dentry = __create_dir(name, parent, &tracefs_dir_inode_operations);
+	dentry = __create_dir(name, parent, &tracefs_instance_dir_inode_operations);
 	if (!dentry)
 		return NULL;
 
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -5,6 +5,9 @@
 enum {
 	TRACEFS_EVENT_INODE		= BIT(1),
 	TRACEFS_EVENT_TOP_INODE		= BIT(2),
+	TRACEFS_GID_PERM_SET		= BIT(3),
+	TRACEFS_UID_PERM_SET		= BIT(4),
+	TRACEFS_INSTANCE_INODE		= BIT(5),
 };
 
 struct tracefs_inode {


