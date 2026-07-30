Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1913932E0;
	Thu, 30 Jul 2026 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428024; cv=none; b=Vn2HKjO7PklGvYpuSOofSZ54X9mpC5LEhvLbmnaNBxFPHWnjM9RjLG7E7nKJ9nDIc9ItwpIO1q5G2uE3jESgVKjAGIlesl3LCpgmhgiwt/jx+k0iFoe4HTlBRKkepxYKXYua7Abb0JYgLwu0vJtFCounN0a4epT2j4d0AUN94Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428024; c=relaxed/simple;
	bh=UUJ+ppLMOif93161g3KpXhDQFbTHaxwCo47fq+VAwxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRFzmZb7xVP3fhjfCBkpwU939YS9z+gmOWiKBKVAJbQTH7oeCSW9qGcoX1WyQZHzJtcjOnsMKONLT2wy2aNST1TN+AzHvm5XIYZEZR6arX2WwcEplPmYF0wCByPfk51F7theBADkQym5p+izo5aH4/HSB0nweEKNVK/CoIwCzUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1S4Wwg0/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1S4Wwg0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44A61F000E9;
	Thu, 30 Jul 2026 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428022;
	bh=0BiC1mGZIMaDL59alosJtPrl9bJK9qN6bhzU94oohMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1S4Wwg0/It/0gmtt3VnlwOxst4t0Yy8O/WfgcDbHb2EhnpPgEZodqSOOTQzQA25gJ
	 2s4TcugOCxGY9E78ajzjqa93mFMmch5SI1VGrYeAi7soedn5O91GC6fJSEy9PZrV8c
	 sYUzvl+3aqMU+Mtc/QDxIraAaWVYxG5i3gLCmEug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 369/484] VFS/audit: introduce kern_path_parent() for audit
Date: Thu, 30 Jul 2026 16:14:26 +0200
Message-ID: <20260730141431.491128368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: NeilBrown <neil@brown.name>

[ Upstream commit 76a53de6f7ff0641570364234fb4489f4d4fc8e9 ]

audit_alloc_mark() and audit_get_nd() both need to perform a path
lookup getting the parent dentry (which must exist) and the final
target (following a LAST_NORM name) which sometimes doesn't need to
exist.

They don't need the parent to be locked, but use kern_path_locked() or
kern_path_locked_negative() anyway.  This is somewhat misleading to the
casual reader.

This patch introduces a more targeted function, kern_path_parent(),
which returns not holding locks.  On success the "path" will
be set to the parent, which must be found, and the return value is the
dentry of the target, which might be negative.

This will clear the way to rename kern_path_locked() which is
otherwise only used to prepare for removing something.

It also allows us to remove kern_path_locked_negative(), which is
transformed into the new kern_path_parent().

Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 81905b5acbe7 ("audit: fix recursive locking deadlock in audit_dupe_exe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c              |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/namei.h   |    1 +
 kernel/audit.h          |    4 ++--
 kernel/audit_fsnotify.c |    9 +++------
 kernel/audit_watch.c    |    9 ++++++---
 5 files changed, 55 insertions(+), 11 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2603,6 +2603,49 @@ static struct dentry *__kern_path_locked
 	return d;
 }
 
+/**
+ * kern_path_parent: lookup path returning parent and target
+ * @name: path name
+ * @path: path to store parent in
+ *
+ * The path @name should end with a normal component, not "." or ".." or "/".
+ * A lookup is performed and if successful the parent information
+ * is store in @parent and the dentry is returned.
+ *
+ * The dentry maybe negative, the parent will be positive.
+ *
+ * Returns:  dentry or error.
+ */
+struct dentry *kern_path_parent(const char *name, struct path *path)
+{
+	struct filename *filename = getname_kernel(name);
+	struct path parent_path;
+	struct dentry *d;
+	struct qstr last;
+	int type, error;
+
+	error = filename_parentat(AT_FDCWD, filename, 0, &parent_path, &last, &type);
+	if (error) {
+		d = ERR_PTR(error);
+		goto out;
+	}
+	if (unlikely(type != LAST_NORM)) {
+		path_put(&parent_path);
+		d = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	d = lookup_one_len_unlocked(last.name, parent_path.dentry, last.len);
+	if (IS_ERR(d)) {
+		path_put(&parent_path);
+		goto out;
+	}
+	*path = parent_path;
+out:
+	putname(filename);
+	return d;
+}
+
 struct dentry *kern_path_locked(const char *name, struct path *path)
 {
 	struct filename *filename = getname_kernel(name);
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -61,6 +61,7 @@ struct dentry *lookup_one_qstr_excl(cons
 				    struct dentry *base,
 				    unsigned int flags);
 extern int kern_path(const char *, unsigned, struct path *);
+struct dentry *kern_path_parent(const char *name, struct path *parent);
 
 extern struct dentry *kern_path_create(int, const char *, struct path *, unsigned int);
 extern struct dentry *user_path_create(int, const char __user *, struct path *, unsigned int);
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -279,8 +279,8 @@ extern struct audit_fsnotify_mark *audit
 extern char *audit_mark_path(struct audit_fsnotify_mark *mark);
 extern void audit_remove_mark(struct audit_fsnotify_mark *audit_mark);
 extern void audit_remove_mark_rule(struct audit_krule *krule);
-extern int audit_mark_compare(struct audit_fsnotify_mark *mark,
-			      unsigned long ino, dev_t dev);
+extern int audit_mark_compare(struct audit_fsnotify_mark *mark, u64 ino,
+			      dev_t dev);
 extern int audit_dupe_exe(struct audit_krule *new, struct audit_krule *old);
 extern int audit_exe_compare(struct task_struct *tsk,
 			     struct audit_fsnotify_mark *mark);
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -57,7 +57,7 @@ char *audit_mark_path(struct audit_fsnot
 	return mark->path;
 }
 
-int audit_mark_compare(struct audit_fsnotify_mark *mark, unsigned long ino, dev_t dev)
+int audit_mark_compare(struct audit_fsnotify_mark *mark, u64 ino, dev_t dev)
 {
 	if (mark->ino == AUDIT_INO_UNSET)
 		return 0;
@@ -76,17 +76,14 @@ struct audit_fsnotify_mark *audit_alloc_
 	struct audit_fsnotify_mark *audit_mark;
 	struct path path;
 	struct dentry *dentry;
-	struct inode *inode;
 	int ret;
 
 	if (pathname[0] != '/' || pathname[len-1] == '/')
 		return ERR_PTR(-EINVAL);
 
-	dentry = kern_path_locked(pathname, &path);
+	dentry = kern_path_parent(pathname, &path);
 	if (IS_ERR(dentry))
 		return ERR_CAST(dentry); /* returning an error */
-	inode = path.dentry->d_inode;
-	inode_unlock(inode);
 
 	audit_mark = kzalloc(sizeof(*audit_mark), GFP_KERNEL);
 	if (unlikely(!audit_mark)) {
@@ -100,7 +97,7 @@ struct audit_fsnotify_mark *audit_alloc_
 	audit_update_mark(audit_mark, dentry->d_inode);
 	audit_mark->rule = krule;
 
-	ret = fsnotify_add_inode_mark(&audit_mark->mark, inode, 0);
+	ret = fsnotify_add_inode_mark(&audit_mark->mark, path.dentry->d_inode, 0);
 	if (ret < 0) {
 		audit_mark->path = NULL;
 		fsnotify_put_mark(&audit_mark->mark);
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -244,7 +244,7 @@ static void audit_watch_log_rule_change(
 /* Update inode info in audit rules based on filesystem event. */
 static void audit_update_watch(struct audit_parent *parent,
 			       const struct qstr *dname, dev_t dev,
-			       unsigned long ino, unsigned invalidating)
+			       u64 ino, unsigned int invalidating)
 {
 	struct audit_watch *owatch, *nwatch, *nextw;
 	struct audit_krule *r, *nextr;
@@ -347,15 +347,18 @@ static void audit_remove_parent_watches(
 /* Get path information necessary for adding watches. */
 static int audit_get_nd(struct audit_watch *watch, struct path *parent)
 {
-	struct dentry *d = kern_path_locked(watch->path, parent);
+	struct dentry *d;
+
+	d = kern_path_parent(watch->path, parent);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
+
 	if (d_is_positive(d)) {
 		/* update watch filter fields */
 		watch->dev = d->d_sb->s_dev;
 		watch->ino = d_backing_inode(d)->i_ino;
 	}
-	inode_unlock(d_backing_inode(parent->dentry));
+
 	dput(d);
 	return 0;
 }


