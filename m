Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DE233F59A;
	Sat, 12 Sep 2026 11:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213045; cv=none; b=N/g/D+t3cK+rWdOLJNA+jgYK+IKa7+03kcOAM+4r/bxXJWQPsKqT+nbu49C5JwOB9NVKoOaReF/gEASVBkn7534Ch34a0GQ3yCEdKRXu3nK7kk8j1g9I1fao5l1q2f4sVS8onD6OQbH0cbuJXc5Q7MSbRQkw3UM7XHNTUY13X48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213045; c=relaxed/simple;
	bh=gxgfh3vNpK4+b1lERPcKz+tMyqOn9TOmOTDuTrqEtTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvlFnb7K4Y9Gr//1lzrLN8n1C5XL9bdGQOuRebGzlPf8Yurl1FFEXNGcOA7E0pQc5egwUJ7sjnXUgwnTOedTgW4oHM9f25a7NE4Un+1ZreHPf0gQLT3EnUjSm1tQN3mLRujOnvBfLc1ifXD3JmbnDfRLXJMXXjrORanohdt0Yzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUMzBkrz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUMzBkrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5952C1F000FF;
	Sat, 12 Sep 2026 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213044;
	bh=o6/0StF0DZTj+6LVcxeWyZKaCBxMhlfsVjFg+qIgZcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUMzBkrzXGyCHv5YzGLfXKZAmwH/aid671BvJWIvCb5b7KXJ/sCRE/T+wHGIAQm2e
	 4FGbMKcjigdOVyJhQPyCxCosz9xmbAPar0q3IOdWYG1vDMF6NU6H8kbKlaJgeY1IHJ
	 poD4N//0syqhSXvQPwy365E6myZ1b00UtIbBcTgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0004/1376] landlock: Require LANDLOCK_ACCESS_FS_MAKE_REG for whiteout creation
Date: Sat, 12 Sep 2026 08:40:30 +0200
Message-ID: <20260912065607.645212423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit 672fa082d48b21e1fb62cdb184fee41513e53421 ]

Whiteout objects are used in the upper layer of an OverlayFS to
indicate that the file with this name does not exist in the unified
view, even if it is present in one of the lower layer file systems.

For the userspace implementations of OverlayFS (fuse-overlayfs),
whiteout objects can be created from userspace as well:

* mknod(2) with S_IFCHR and makedev(0, 0)
* renameat2(2) with RENAME_WHITEOUT,
  creating the whiteout in the old place of the moved file.

This commit guards whiteout creation in both of these cases with
LANDLOCK_ACCESS_FS_MAKE_REG.  Whiteout objects are *not* considered
character devices and are not bound to a driver.

LANDLOCK_ACCESS_FS_MAKE_REG describes the same permission class as a
whiteout object: creating one is the only S_IFCHR creation that the VFS
exempts from CAP_MKNOD, so it is as unprivileged as creating a regular
file, while LANDLOCK_ACCESS_FS_MAKE_CHAR and
LANDLOCK_ACCESS_FS_MAKE_BLOCK keep meaning the creation of devices that
expose a kernel interface [1].

For the mknod(2) case, introduce a Landlock erratum.  The creation of
whiteout objects through mknod(2) was previously guarded using
LANDLOCK_ACCESS_FS_MAKE_CHAR, and it is now guarded using
LANDLOCK_ACCESS_FS_MAKE_REG.

For the renameat2(2) case, fix a bug: Before this commit, renameat2(2)
with RENAME_WHITEOUT would create a directory entry even when all
LANDLOCK_ACCESS_FS_MAKE_* rights were denied.

This does not affect normal renames within layered OverlayFS mounts:
When doing a regular rename() on a mounted fuse-overlayfs, it is the
fuse-overlayfs daemon that exercises renameat2() with RENAME_WHITEOUT,
and only the Landlock domain of that daemon is checked there.

Suggested-by: Christian Brauner <brauner@kernel.org>
Suggested-by: Mickaël Salaün <mic@digikod.net>
Cc: stable@vger.kernel.org
Fixes: cb2c7d1a1776 ("landlock: Support filesystem access-control")
Depends-on: 49c9e09d9610 ("landlock: Fix handling of disconnected directories")
Depends-on: fe72ce6710cb ("landlock: Add errata documentation section")
Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20260720.chow9ohYie5b@digikod.net [1]
Link: https://patch.msgid.link/20260813093157.1436894-3-gnoack@google.com
[mic: Record why LANDLOCK_ACCESS_FS_MAKE_REG is the matching right, and
add link(2) to the user doc]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/landlock.h    |  1 +
 security/landlock/errata/abi-1.h | 23 ++++++++++++++++++
 security/landlock/fs.c           | 40 +++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index c223572f82296..94cfad88082f3 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -177,6 +177,7 @@ struct landlock_net_port_attr {
  *   device.
  * - %LANDLOCK_ACCESS_FS_MAKE_DIR: Create (or rename) a directory.
  * - %LANDLOCK_ACCESS_FS_MAKE_REG: Create (or rename or link) a regular file.
+ *   This also guards the creation of whiteout objects as used in OverlayFS.
  * - %LANDLOCK_ACCESS_FS_MAKE_SOCK: Create (or rename or link) a UNIX domain
  *   socket.
  * - %LANDLOCK_ACCESS_FS_MAKE_FIFO: Create (or rename or link) a named pipe.
diff --git a/security/landlock/errata/abi-1.h b/security/landlock/errata/abi-1.h
index e8a2bff2e5b6a..80930957e84d2 100644
--- a/security/landlock/errata/abi-1.h
+++ b/security/landlock/errata/abi-1.h
@@ -14,3 +14,26 @@
  * actions.
  */
 LANDLOCK_ERRATUM(3)
+
+/**
+ * DOC: erratum_4
+ *
+ * Erratum 4: Creation of whiteout objects
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This fix changes the access rights required for the creation of whiteout
+ * objects through :manpage:`mknod(2)`, :manpage:`renameat2(2)`, or
+ * :manpage:`link(2)`.  Creating whiteout objects is now guarded by
+ * ``LANDLOCK_ACCESS_FS_MAKE_REG`` instead of ``LANDLOCK_ACCESS_FS_MAKE_CHAR``.
+ *
+ * Whiteout objects are used in OverlayFS to mark the absence of a file in an
+ * upper file system.  Despite being created with ``S_IFCHR``, whiteout objects
+ * do not count as character devices.
+ *
+ * Impact:
+ *
+ * Sandboxed programs that create OverlayFS whiteouts (such as fuse-overlayfs)
+ * now require ``LANDLOCK_ACCESS_FS_MAKE_REG`` instead of
+ * ``LANDLOCK_ACCESS_FS_MAKE_CHAR``.
+ */
+LANDLOCK_ERRATUM(4)
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index bb4a9e82156a6..b96a4daa5b2a2 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -20,6 +20,7 @@
 #include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/kdev_t.h>
 #include <linux/kernel.h>
 #include <linux/limits.h>
 #include <linux/list.h>
@@ -954,7 +955,7 @@ static int current_check_access_path(const struct path *const path,
 	return check_access_path(dom, path, access_request);
 }
 
-static access_mask_t get_mode_access(const umode_t mode)
+static access_mask_t get_mode_access(const umode_t mode, const dev_t dev)
 {
 	switch (mode & S_IFMT) {
 	case S_IFLNK:
@@ -962,6 +963,9 @@ static access_mask_t get_mode_access(const umode_t mode)
 	case S_IFDIR:
 		return LANDLOCK_ACCESS_FS_MAKE_DIR;
 	case S_IFCHR:
+		/* Whiteout objects are guarded with MAKE_REG. */
+		if (dev == WHITEOUT_DEV)
+			return LANDLOCK_ACCESS_FS_MAKE_REG;
 		return LANDLOCK_ACCESS_FS_MAKE_CHAR;
 	case S_IFBLK:
 		return LANDLOCK_ACCESS_FS_MAKE_BLOCK;
@@ -978,6 +982,13 @@ static access_mask_t get_mode_access(const umode_t mode)
 	}
 }
 
+static access_mask_t get_dentry_access(const struct dentry *const dentry)
+{
+	const struct inode *const inode = d_backing_inode(dentry);
+
+	return get_mode_access(inode->i_mode, inode->i_rdev);
+}
+
 static access_mask_t maybe_remove(const struct dentry *const dentry)
 {
 	if (d_is_negative(dentry))
@@ -1067,6 +1078,7 @@ static bool collect_domain_accesses(
  * @new_dentry: Destination file or directory.
  * @removable: Sets to true if it is a rename operation.
  * @exchange: Sets to true if it is a rename operation with RENAME_EXCHANGE.
+ * @whiteout: Sets to true if it is a rename operation with RENAME_WHITEOUT.
  *
  * Because of its unprivileged constraints, Landlock relies on file hierarchies
  * (and not only inodes) to tie access rights to files.  Being able to link or
@@ -1115,7 +1127,8 @@ static bool collect_domain_accesses(
 static int current_check_refer_path(struct dentry *const old_dentry,
 				    const struct path *const new_dir,
 				    struct dentry *const new_dentry,
-				    const bool removable, const bool exchange)
+				    const bool removable, const bool exchange,
+				    const bool whiteout)
 {
 	const struct landlock_ruleset *const dom = get_current_fs_domain();
 	bool allow_parent1, allow_parent2;
@@ -1134,18 +1147,25 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 	if (exchange) {
 		if (unlikely(d_is_negative(new_dentry)))
 			return -ENOENT;
-		access_request_parent1 =
-			get_mode_access(d_backing_inode(new_dentry)->i_mode);
+		access_request_parent1 = get_dentry_access(new_dentry);
 	} else {
 		access_request_parent1 = 0;
 	}
-	access_request_parent2 =
-		get_mode_access(d_backing_inode(old_dentry)->i_mode);
+	access_request_parent2 = get_dentry_access(old_dentry);
 	if (removable) {
 		access_request_parent1 |= maybe_remove(old_dentry);
 		access_request_parent2 |= maybe_remove(new_dentry);
 	}
 
+	/*
+	 * In case of renameat2(2) with RENAME_WHITEOUT, a whiteout object is
+	 * created in the source location, so we require an additional access
+	 * right there.
+	 */
+	if (whiteout)
+		access_request_parent1 |=
+			get_mode_access(S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
+
 	/* The mount points are the same for old and new paths, cf. EXDEV. */
 	if (old_dentry->d_parent == new_dir->dentry) {
 		/*
@@ -1417,7 +1437,7 @@ static int hook_path_link(struct dentry *const old_dentry,
 			  struct dentry *const new_dentry)
 {
 	return current_check_refer_path(old_dentry, new_dir, new_dentry, false,
-					false);
+					false, false);
 }
 
 static int hook_path_rename(const struct path *const old_dir,
@@ -1428,7 +1448,8 @@ static int hook_path_rename(const struct path *const old_dir,
 {
 	/* old_dir refers to old_dentry->d_parent and new_dir->mnt */
 	return current_check_refer_path(old_dentry, new_dir, new_dentry, true,
-					!!(flags & RENAME_EXCHANGE));
+					!!(flags & RENAME_EXCHANGE),
+					!!(flags & RENAME_WHITEOUT));
 }
 
 static int hook_path_mkdir(const struct path *const dir,
@@ -1445,7 +1466,8 @@ static int hook_path_mknod(const struct path *const dir,
 
 	if (!dom)
 		return 0;
-	return check_access_path(dom, dir, get_mode_access(mode));
+	return check_access_path(dom, dir,
+				 get_mode_access(mode, new_decode_dev(dev)));
 }
 
 static int hook_path_symlink(const struct path *const dir,
-- 
2.53.0



