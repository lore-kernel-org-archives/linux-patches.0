Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98AD151CDC;
	Tue, 20 Feb 2024 21:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464925; cv=none; b=YxO1H7UQ1XtfZiM3cGTf+Ye9wp/7JXeZuk+/Y6LpaOALfhZGAfLwrHNKGihuRAiOjyJDKVjU8e7Ss83zi9jNvfKKdH6JV3Lg1HPEnZ0O6cmNSpvivM51h8KmVBSL2FGZOvk5U8hKZx+89bvBOQ2wlUM5mmvk+XMQ/+masLdAqiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464925; c=relaxed/simple;
	bh=qs3Y8vfhRKxln8HfP7CKCywGQF9fDZ1Y21ZPF7R4p4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tG8/jU3aoL9UihmG47B7rjEAupBM2dp/rJVOQ+2lSAeumxL70n233jyCSz9Xjl6lBZl7L2m9F6VvhOC3ChU7V2p7MVKRxf9Ho6IY2tk94q3RpKJB17uRkhjuhIwHJRq1AkKSMNptmeTYdNh68R89/wj1/gkN/OwFJsxSzpyi+2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AP0JyOvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AP0JyOvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE4BC433C7;
	Tue, 20 Feb 2024 21:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464925;
	bh=qs3Y8vfhRKxln8HfP7CKCywGQF9fDZ1Y21ZPF7R4p4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AP0JyOvuTK/MRBMhTUPO1rfAsFGzljKd5rKwCe/V6o59Kkb1XBlwBcHFR04RrAEBD
	 uJZhA6vgA2wjj+0i2C9Mm4OndQCarUfg82rL2VMIt+6sZTJJnSyWJHlyLkGWYB9AjC
	 vXj2IhUo8rbwnD2F6+BaZyS/mB8YsNamdvaJsQ3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ajay Kaher <akaher@vmware.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 180/309] eventfs: Stop using dcache_readdir() for getdents()
Date: Tue, 20 Feb 2024 21:55:39 +0100
Message-ID: <20240220205638.782561366@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 493ec81a8fb8e4ada6f223b8b73791a1280d4774 upstream.

The eventfs creates dynamically allocated dentries and inodes. Using the
dcache_readdir() logic for its own directory lookups requires hiding the
cursor of the dcache logic and playing games to allow the dcache_readdir()
to still have access to the cursor while the eventfs saved what it created
and what it needs to release.

Instead, just have eventfs have its own iterate_shared callback function
that will fill in the dent entries. This simplifies the code quite a bit.

Link: https://lore.kernel.org/linux-trace-kernel/20240104015435.682218477@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ajay Kaher <akaher@vmware.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |  194 +++++++++++++++--------------------------------
 1 file changed, 64 insertions(+), 130 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -53,9 +53,7 @@ enum {
 static struct dentry *eventfs_root_lookup(struct inode *dir,
 					  struct dentry *dentry,
 					  unsigned int flags);
-static int dcache_dir_open_wrapper(struct inode *inode, struct file *file);
-static int dcache_readdir_wrapper(struct file *file, struct dir_context *ctx);
-static int eventfs_release(struct inode *inode, struct file *file);
+static int eventfs_iterate(struct file *file, struct dir_context *ctx);
 
 static void update_attr(struct eventfs_attr *attr, struct iattr *iattr)
 {
@@ -213,11 +211,9 @@ static const struct inode_operations eve
 };
 
 static const struct file_operations eventfs_file_operations = {
-	.open		= dcache_dir_open_wrapper,
 	.read		= generic_read_dir,
-	.iterate_shared	= dcache_readdir_wrapper,
+	.iterate_shared	= eventfs_iterate,
 	.llseek		= generic_file_llseek,
-	.release	= eventfs_release,
 };
 
 /* Return the evenfs_inode of the "events" directory */
@@ -672,128 +668,87 @@ static struct dentry *eventfs_root_looku
 	return ret;
 }
 
-struct dentry_list {
-	void			*cursor;
-	struct dentry		**dentries;
-};
-
-/**
- * eventfs_release - called to release eventfs file/dir
- * @inode: inode to be released
- * @file: file to be released (not used)
- */
-static int eventfs_release(struct inode *inode, struct file *file)
-{
-	struct tracefs_inode *ti;
-	struct dentry_list *dlist = file->private_data;
-	void *cursor;
-	int i;
-
-	ti = get_tracefs(inode);
-	if (!(ti->flags & TRACEFS_EVENT_INODE))
-		return -EINVAL;
-
-	if (WARN_ON_ONCE(!dlist))
-		return -EINVAL;
-
-	for (i = 0; dlist->dentries && dlist->dentries[i]; i++) {
-		dput(dlist->dentries[i]);
-	}
-
-	cursor = dlist->cursor;
-	kfree(dlist->dentries);
-	kfree(dlist);
-	file->private_data = cursor;
-	return dcache_dir_close(inode, file);
-}
-
-static int add_dentries(struct dentry ***dentries, struct dentry *d, int cnt)
-{
-	struct dentry **tmp;
-
-	tmp = krealloc(*dentries, sizeof(d) * (cnt + 2), GFP_NOFS);
-	if (!tmp)
-		return -1;
-	tmp[cnt] = d;
-	tmp[cnt + 1] = NULL;
-	*dentries = tmp;
-	return 0;
-}
-
-/**
- * dcache_dir_open_wrapper - eventfs open wrapper
- * @inode: not used
- * @file: dir to be opened (to create it's children)
- *
- * Used to dynamic create file/dir with-in @file, all the
- * file/dir will be created. If already created then references
- * will be increased
+/*
+ * Walk the children of a eventfs_inode to fill in getdents().
  */
-static int dcache_dir_open_wrapper(struct inode *inode, struct file *file)
+static int eventfs_iterate(struct file *file, struct dir_context *ctx)
 {
 	const struct file_operations *fops;
+	struct inode *f_inode = file_inode(file);
 	const struct eventfs_entry *entry;
 	struct eventfs_inode *ei_child;
 	struct tracefs_inode *ti;
 	struct eventfs_inode *ei;
-	struct dentry_list *dlist;
-	struct dentry **dentries = NULL;
-	struct dentry *parent = file_dentry(file);
-	struct dentry *d;
-	struct inode *f_inode = file_inode(file);
-	const char *name = parent->d_name.name;
+	struct dentry *ei_dentry = NULL;
+	struct dentry *dentry;
+	const char *name;
 	umode_t mode;
-	void *data;
-	int cnt = 0;
 	int idx;
-	int ret;
-	int i;
-	int r;
+	int ret = -EINVAL;
+	int ino;
+	int i, r, c;
+
+	if (!dir_emit_dots(file, ctx))
+		return 0;
 
 	ti = get_tracefs(f_inode);
 	if (!(ti->flags & TRACEFS_EVENT_INODE))
 		return -EINVAL;
 
-	if (WARN_ON_ONCE(file->private_data))
-		return -EINVAL;
+	c = ctx->pos - 2;
 
 	idx = srcu_read_lock(&eventfs_srcu);
 
 	mutex_lock(&eventfs_mutex);
 	ei = READ_ONCE(ti->private);
+	if (ei && !ei->is_freed)
+		ei_dentry = READ_ONCE(ei->dentry);
 	mutex_unlock(&eventfs_mutex);
 
-	if (!ei) {
-		srcu_read_unlock(&eventfs_srcu, idx);
-		return -EINVAL;
-	}
-
-
-	data = ei->data;
+	if (!ei || !ei_dentry)
+		goto out;
 
-	dlist = kmalloc(sizeof(*dlist), GFP_KERNEL);
-	if (!dlist) {
-		srcu_read_unlock(&eventfs_srcu, idx);
-		return -ENOMEM;
-	}
+	ret = 0;
 
-	inode_lock(parent->d_inode);
+	/*
+	 * Need to create the dentries and inodes to have a consistent
+	 * inode number.
+	 */
 	list_for_each_entry_srcu(ei_child, &ei->children, list,
 				 srcu_read_lock_held(&eventfs_srcu)) {
-		d = create_dir_dentry(ei, ei_child, parent);
-		if (d) {
-			ret = add_dentries(&dentries, d, cnt);
-			dput(d);
-			if (ret < 0)
-				break;
-			cnt++;
+
+		if (c > 0) {
+			c--;
+			continue;
 		}
+
+		if (ei_child->is_freed)
+			continue;
+
+		name = ei_child->name;
+
+		dentry = create_dir_dentry(ei, ei_child, ei_dentry);
+		if (!dentry)
+			goto out;
+		ino = dentry->d_inode->i_ino;
+		dput(dentry);
+
+		if (!dir_emit(ctx, name, strlen(name), ino, DT_DIR))
+			goto out;
+		ctx->pos++;
 	}
 
 	for (i = 0; i < ei->nr_entries; i++) {
-		void *cdata = data;
+		void *cdata = ei->data;
+
+		if (c > 0) {
+			c--;
+			continue;
+		}
+
 		entry = &ei->entries[i];
 		name = entry->name;
+
 		mutex_lock(&eventfs_mutex);
 		/* If ei->is_freed, then the event itself may be too */
 		if (!ei->is_freed)
@@ -803,42 +758,21 @@ static int dcache_dir_open_wrapper(struc
 		mutex_unlock(&eventfs_mutex);
 		if (r <= 0)
 			continue;
-		d = create_file_dentry(ei, i, parent, name, mode, cdata, fops);
-		if (d) {
-			ret = add_dentries(&dentries, d, cnt);
-			dput(d);
-			if (ret < 0)
-				break;
-			cnt++;
-		}
-	}
-	inode_unlock(parent->d_inode);
-	srcu_read_unlock(&eventfs_srcu, idx);
-	ret = dcache_dir_open(inode, file);
 
-	/*
-	 * dcache_dir_open() sets file->private_data to a dentry cursor.
-	 * Need to save that but also save all the dentries that were
-	 * opened by this function.
-	 */
-	dlist->cursor = file->private_data;
-	dlist->dentries = dentries;
-	file->private_data = dlist;
-	return ret;
-}
+		dentry = create_file_dentry(ei, i, ei_dentry, name, mode, cdata, fops);
+		if (!dentry)
+			goto out;
+		ino = dentry->d_inode->i_ino;
+		dput(dentry);
 
-/*
- * This just sets the file->private_data back to the cursor and back.
- */
-static int dcache_readdir_wrapper(struct file *file, struct dir_context *ctx)
-{
-	struct dentry_list *dlist = file->private_data;
-	int ret;
+		if (!dir_emit(ctx, name, strlen(name), ino, DT_REG))
+			goto out;
+		ctx->pos++;
+	}
+	ret = 1;
+ out:
+	srcu_read_unlock(&eventfs_srcu, idx);
 
-	file->private_data = dlist->cursor;
-	ret = dcache_readdir(file, ctx);
-	dlist->cursor = file->private_data;
-	file->private_data = dlist;
 	return ret;
 }
 


