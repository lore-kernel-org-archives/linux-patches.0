Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EED447010D;
	Tue, 21 Jul 2026 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664388; cv=none; b=p5bkTnK2doWuo5N4GbWOKBpbBfrs2gsJAWx2sa0MCB4dhn4LAgYrAr8WTI+TQxwa4MZUlWCYKMdFfetH99bYtzpdOci27/K2LzYOSxZr/KW3oES9Cjzncbw202+1Ue/g60+9bcSDhWDL9yptfNZp/+F3aY6UCWoLaGNbiZnuN3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664388; c=relaxed/simple;
	bh=q9/vxvpZO4TxWGjlosrGW9oCtQ6aY4aBto3jlXNZvlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqcT+Y0m6bEqFpTupLsrpg3qsl0bKIiYDIJoMCPw76LSNSXX5PYbL3KFldpI8LHHfaIF6BinWEZMEAcXJ+zeKT5NKRDovWIPF2Kk8HH83PJXQs+ucrPkjxA+h8yzJfhuPhtMLxaLoOwv4Trs8d2ZNFtk2Q9jNHccbPHj6OyGZiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/eU55zY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/eU55zY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785C31F000E9;
	Tue, 21 Jul 2026 20:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664386;
	bh=4KDdIsHPcFM20vhKsoG/MMZgXfRsJrZgh7eNcikw6NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/eU55zYu0dUZXKX48LOQhZCXbHhhGufDkX1MNum0vhzoOO99aKdT4+nt/XQDUg07
	 7mqF3CWNVaoCPpUE9pt5tJynqc94hdD7CRfJLAqctpBYYHpRXBtzsG2ljs05oWpGfr
	 Au2/Bhz412HKbbJ1zkU13fmlCRHhDBwj3jBC78jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Amir Goldstein <amir73il@gmail.com>,
	NeilBrown <neil@brown.name>,
	Namjae Jeon <linkinjeon@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1181/1276] vfs: make LAST_XXX private to fs/namei.c
Date: Tue, 21 Jul 2026 17:27:04 +0200
Message-ID: <20260721152512.462316166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit f2f1dddccae50f7a1d088285c53c376e26cedf67 ]

The only user of LAST_XXX outside of fs/namei.c is fs/smb/server/vfs.c;
ksmbd_vfs_path_lookup() calls vfs_path_parent_lookup() and expects a
LAST_NORM last type (or it will be ENOENT). ksmbd_vfs_rename() also calls
vfs_path_parent_lookup() but forgets the LAST_NORM check.

It does not really make sense to have vfs_path_parent_lookup() expose
the last_type because it is only needed to ensure it is LAST_NORM. So
let's do this check in vfs_path_parent_lookup() instead and keep the
LAST_XXX internal to fs/namei.c. This changes the ENOENT errno in
ksmbd_vfs_path_lookup() to EINVAL, which matches better with how this is
handled by callers of filename_parentat().

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Link: https://patch.msgid.link/20260528175854.57626-1-jkoolstra@xs4all.nl
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 1c8951963d8e ("ksmbd: fix path resolution in ksmbd_vfs_kern_path_create")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c            |   20 ++++++++++++++++----
 fs/smb/server/vfs.c   |   15 +++------------
 include/linux/namei.h |    7 +------
 3 files changed, 20 insertions(+), 22 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -125,6 +125,11 @@
 
 #define EMBEDDED_NAME_MAX	(PATH_MAX - offsetof(struct filename, iname))
 
+/*
+ * Type of the last component on LOOKUP_PARENT
+ */
+enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
+
 struct filename *
 getname_flags(const char __user *filename, int flags)
 {
@@ -2736,15 +2741,22 @@ EXPORT_SYMBOL(kern_path);
  * @flags: lookup flags
  * @parent: pointer to struct path to fill
  * @last: last component
- * @type: type of the last component
  * @root: pointer to struct path of the base directory
  */
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
-			   struct path *parent, struct qstr *last, int *type,
+			   struct path *parent, struct qstr *last,
 			   const struct path *root)
 {
-	return  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
-				    type, root);
+	int type;
+	int err =  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
+				       &type, root);
+	if (err)
+		return err;
+	if (unlikely(type != LAST_NORM)) {
+		path_put(parent);
+		return -EINVAL;
+	}
+	return 0;
 }
 EXPORT_SYMBOL(vfs_path_parent_lookup);
 
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -18,7 +18,6 @@
 #include <linux/vmalloc.h>
 #include <linux/sched/xacct.h>
 #include <linux/crc32c.h>
-#include <linux/namei.h>
 
 #include "glob.h"
 #include "oplock.h"
@@ -73,7 +72,7 @@ static int ksmbd_vfs_path_lookup_locked(
 	struct qstr last;
 	struct filename *filename;
 	struct path *root_share_path = &share_conf->vfs_path;
-	int err, type;
+	int err;
 	struct dentry *d;
 
 	if (pathname[0] == '\0') {
@@ -88,19 +87,13 @@ static int ksmbd_vfs_path_lookup_locked(
 		return PTR_ERR(filename);
 
 	err = vfs_path_parent_lookup(filename, flags,
-				     parent_path, &last, &type,
+				     parent_path, &last,
 				     root_share_path);
 	if (err) {
 		putname(filename);
 		return err;
 	}
 
-	if (unlikely(type != LAST_NORM)) {
-		path_put(parent_path);
-		putname(filename);
-		return -ENOENT;
-	}
-
 	err = mnt_want_write(parent_path->mnt);
 	if (err) {
 		path_put(parent_path);
@@ -708,7 +701,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *
 	struct filename *to;
 	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
 	struct ksmbd_file *parent_fp;
-	int new_type;
 	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
 
 	if (ksmbd_override_fsids(work))
@@ -718,8 +710,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *
 
 retry:
 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
-				     &new_path, &new_last, &new_type,
-				     &share_conf->vfs_path);
+				     &new_path, &new_last, &share_conf->vfs_path);
 	if (err)
 		goto out1;
 
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -12,11 +12,6 @@ enum { MAX_NESTED_LINKS = 8 };
 
 #define MAXSYMLINKS 40
 
-/*
- * Type of the last component on LOOKUP_PARENT
- */
-enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
-
 /* pathwalk mode */
 #define LOOKUP_FOLLOW		0x0001	/* follow links at the end */
 #define LOOKUP_DIRECTORY	0x0002	/* require a directory */
@@ -63,7 +58,7 @@ extern void done_path_create(struct path
 extern struct dentry *kern_path_locked(const char *, struct path *);
 extern struct dentry *user_path_locked_at(int , const char __user *, struct path *);
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
-			   struct path *parent, struct qstr *last, int *type,
+			   struct path *parent, struct qstr *last,
 			   const struct path *root);
 int vfs_path_lookup(struct dentry *, struct vfsmount *, const char *,
 		    unsigned int, struct path *);


