Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F9D6311D;
	Tue, 14 May 2024 11:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685984; cv=none; b=XaAS5KL7da5mUueyhMOkBgeZlKy66tvtzDNtlz0wLsP1/jdM7/m367HvJFE8ZZ9B/rJ78j3EqezgV0kPn+TpUXj49Zh2URhE0gvaEcPBYb4IYF0EOumN3NvJ+KDis6g+ufrY0xWDCjtSPWwLTtb21shB03B71YXYHjvW+dm3Yr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685984; c=relaxed/simple;
	bh=m2SYZmHyzsuKbk5/JeJBXbg7rVehdzOCcik8fR9J1lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAdQmXtwRxUKrw8UNrE2GuJhDK744HOSe7dvGktIhVvweXIaswY1AociaCbHZuztnZWJX5qyETxAEnK17dGKSBAGZCzOGXIFoVIrS9wMI+paC0wiVQ8+M9ZR6nOD46fSZ0KTirp8BPPaKvdRv8siE/YS2Msm6OvjId4KnW64158=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXA095WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXA095WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52926C2BD10;
	Tue, 14 May 2024 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685983;
	bh=m2SYZmHyzsuKbk5/JeJBXbg7rVehdzOCcik8fR9J1lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXA095WSnEwhMR+Ao0XbePYtwhkihzVAnTShTnk0Jc1QeU5Zeo+fmc1NX+I7hVuMf
	 T/kEPOZSS138B0lnalr9lhGAbn4aBQcbpqxwiogcGnnLd0OwYvgLYQWbom1tsVqG8I
	 VT9Cyf+8SQ9IpPOt6M3lDx/XzO2CQMvqcF9ce3Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 290/301] tracefs: Reset permissions on remount if permissions are options
Date: Tue, 14 May 2024 12:19:21 +0200
Message-ID: <20240514101043.210851216@linuxfoundation.org>
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

commit baa23a8d4360d981a49913841a726edede5cdd54 upstream.

There's an inconsistency with the way permissions are handled in tracefs.
Because the permissions are generated when accessed, they default to the
root inode's permission if they were never set by the user. If the user
sets the permissions, then a flag is set and the permissions are saved via
the inode (for tracefs files) or an internal attribute field (for
eventfs).

But if a remount happens that specify the permissions, all the files that
were not changed by the user gets updated, but the ones that were are not.
If the user were to remount the file system with a given permission, then
all files and directories within that file system should be updated.

This can cause security issues if a file's permission was updated but the
admin forgot about it. They could incorrectly think that remounting with
permissions set would update all files, but miss some.

For example:

 # cd /sys/kernel/tracing
 # chgrp 1002 current_tracer
 # ls -l
[..]
 -rw-r-----  1 root root 0 May  1 21:25 buffer_size_kb
 -rw-r-----  1 root root 0 May  1 21:25 buffer_subbuf_size_kb
 -r--r-----  1 root root 0 May  1 21:25 buffer_total_size_kb
 -rw-r-----  1 root lkp  0 May  1 21:25 current_tracer
 -rw-r-----  1 root root 0 May  1 21:25 dynamic_events
 -r--r-----  1 root root 0 May  1 21:25 dyn_ftrace_total_info
 -r--r-----  1 root root 0 May  1 21:25 enabled_functions

Where current_tracer now has group "lkp".

 # mount -o remount,gid=1001 .
 # ls -l
 -rw-r-----  1 root tracing 0 May  1 21:25 buffer_size_kb
 -rw-r-----  1 root tracing 0 May  1 21:25 buffer_subbuf_size_kb
 -r--r-----  1 root tracing 0 May  1 21:25 buffer_total_size_kb
 -rw-r-----  1 root lkp     0 May  1 21:25 current_tracer
 -rw-r-----  1 root tracing 0 May  1 21:25 dynamic_events
 -r--r-----  1 root tracing 0 May  1 21:25 dyn_ftrace_total_info
 -r--r-----  1 root tracing 0 May  1 21:25 enabled_functions

Everything changed but the "current_tracer".

Add a new link list that keeps track of all the tracefs_inodes which has
the permission flags that tell if the file/dir should use the root inode's
permission or not. Then on remount, clear all the flags so that the
default behavior of using the root inode's permission is done for all
files and directories.

Link: https://lore.kernel.org/linux-trace-kernel/20240502200905.529542160@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 8186fff7ab649 ("tracefs/eventfs: Use root and instance inodes as default ownership")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   29 ++++++++++++++++++++
 fs/tracefs/inode.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/tracefs/internal.h    |    7 ++++-
 3 files changed, 99 insertions(+), 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -265,6 +265,35 @@ static const struct file_operations even
 	.llseek		= generic_file_llseek,
 };
 
+/*
+ * On a remount of tracefs, if UID or GID options are set, then
+ * the mount point inode permissions should be used.
+ * Reset the saved permission flags appropriately.
+ */
+void eventfs_remount(struct tracefs_inode *ti, bool update_uid, bool update_gid)
+{
+	struct eventfs_inode *ei = ti->private;
+
+	if (!ei)
+		return;
+
+	if (update_uid)
+		ei->attr.mode &= ~EVENTFS_SAVE_UID;
+
+	if (update_gid)
+		ei->attr.mode &= ~EVENTFS_SAVE_GID;
+
+	if (!ei->entry_attrs)
+		return;
+
+	for (int i = 0; i < ei->nr_entries; i++) {
+		if (update_uid)
+			ei->entry_attrs[i].mode &= ~EVENTFS_SAVE_UID;
+		if (update_gid)
+			ei->entry_attrs[i].mode &= ~EVENTFS_SAVE_GID;
+	}
+}
+
 /* Return the evenfs_inode of the "events" directory */
 static struct eventfs_inode *eventfs_find_events(struct dentry *dentry)
 {
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -30,20 +30,47 @@ static struct vfsmount *tracefs_mount;
 static int tracefs_mount_count;
 static bool tracefs_registered;
 
+/*
+ * Keep track of all tracefs_inodes in order to update their
+ * flags if necessary on a remount.
+ */
+static DEFINE_SPINLOCK(tracefs_inode_lock);
+static LIST_HEAD(tracefs_inodes);
+
 static struct inode *tracefs_alloc_inode(struct super_block *sb)
 {
 	struct tracefs_inode *ti;
+	unsigned long flags;
 
 	ti = kmem_cache_alloc(tracefs_inode_cachep, GFP_KERNEL);
 	if (!ti)
 		return NULL;
 
+	spin_lock_irqsave(&tracefs_inode_lock, flags);
+	list_add_rcu(&ti->list, &tracefs_inodes);
+	spin_unlock_irqrestore(&tracefs_inode_lock, flags);
+
 	return &ti->vfs_inode;
 }
 
+static void tracefs_free_inode_rcu(struct rcu_head *rcu)
+{
+	struct tracefs_inode *ti;
+
+	ti = container_of(rcu, struct tracefs_inode, rcu);
+	kmem_cache_free(tracefs_inode_cachep, ti);
+}
+
 static void tracefs_free_inode(struct inode *inode)
 {
-	kmem_cache_free(tracefs_inode_cachep, get_tracefs(inode));
+	struct tracefs_inode *ti = get_tracefs(inode);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tracefs_inode_lock, flags);
+	list_del_rcu(&ti->list);
+	spin_unlock_irqrestore(&tracefs_inode_lock, flags);
+
+	call_rcu(&ti->rcu, tracefs_free_inode_rcu);
 }
 
 static ssize_t default_read_file(struct file *file, char __user *buf,
@@ -313,6 +340,8 @@ static int tracefs_apply_options(struct
 	struct tracefs_fs_info *fsi = sb->s_fs_info;
 	struct inode *inode = d_inode(sb->s_root);
 	struct tracefs_mount_opts *opts = &fsi->mount_opts;
+	struct tracefs_inode *ti;
+	bool update_uid, update_gid;
 	umode_t tmp_mode;
 
 	/*
@@ -332,6 +361,25 @@ static int tracefs_apply_options(struct
 	if (!remount || opts->opts & BIT(Opt_gid))
 		inode->i_gid = opts->gid;
 
+	if (remount && (opts->opts & BIT(Opt_uid) || opts->opts & BIT(Opt_gid))) {
+
+		update_uid = opts->opts & BIT(Opt_uid);
+		update_gid = opts->opts & BIT(Opt_gid);
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(ti, &tracefs_inodes, list) {
+			if (update_uid)
+				ti->flags &= ~TRACEFS_UID_PERM_SET;
+
+			if (update_gid)
+				ti->flags &= ~TRACEFS_GID_PERM_SET;
+
+			if (ti->flags & TRACEFS_EVENT_INODE)
+				eventfs_remount(ti, update_uid, update_gid);
+		}
+		rcu_read_unlock();
+	}
+
 	return 0;
 }
 
@@ -398,7 +446,22 @@ static int tracefs_d_revalidate(struct d
 	return !(ei && ei->is_freed);
 }
 
+static void tracefs_d_iput(struct dentry *dentry, struct inode *inode)
+{
+	struct tracefs_inode *ti = get_tracefs(inode);
+
+	/*
+	 * This inode is being freed and cannot be used for
+	 * eventfs. Clear the flag so that it doesn't call into
+	 * eventfs during the remount flag updates. The eventfs_inode
+	 * gets freed after an RCU cycle, so the content will still
+	 * be safe if the iteration is going on now.
+	 */
+	ti->flags &= ~TRACEFS_EVENT_INODE;
+}
+
 static const struct dentry_operations tracefs_dentry_operations = {
+	.d_iput = tracefs_d_iput,
 	.d_revalidate = tracefs_d_revalidate,
 	.d_release = tracefs_d_release,
 };
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -11,8 +11,12 @@ enum {
 };
 
 struct tracefs_inode {
-	struct inode            vfs_inode;
+	union {
+		struct inode            vfs_inode;
+		struct rcu_head		rcu;
+	};
 	/* The below gets initialized with memset_after(ti, 0, vfs_inode) */
+	struct list_head	list;
 	unsigned long           flags;
 	void                    *private;
 };
@@ -75,6 +79,7 @@ struct dentry *tracefs_end_creating(stru
 struct dentry *tracefs_failed_creating(struct dentry *dentry);
 struct inode *tracefs_get_inode(struct super_block *sb);
 
+void eventfs_remount(struct tracefs_inode *ti, bool update_uid, bool update_gid);
 void eventfs_d_release(struct dentry *dentry);
 
 #endif /* _TRACEFS_INTERNAL_H */


