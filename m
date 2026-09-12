Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A9725A640;
	Sat, 12 Sep 2026 15:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227793; cv=none; b=gapsjlCghHRJA7eobSG5w2al4ySOdTKl9mxUyxKgEtvBobqQeRyvWebVatO7Us5gSf4HOlhs1DCjymoGgEN4EkyDj5ynzxWmOlKQadt3itoRz+cuTOJlrDwBogOOWTFQMU6r+Ttp3Qq58TJNoGS/FEiIIM/zHdcho3nfJ1sSzHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227793; c=relaxed/simple;
	bh=u2BwvyQVxQREzKJkzt7uE5Qjr/IjBB4dmJPurki2st8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fl2PJt3Q8EmF9J6jlAF283VW2B7OwaiKvs8YJRpTJmoozEZ2K0ym0RKkee5BvV08ET7fqH1gSZloz9Xzj81wJha/nXm1S4Y8Aw83hujvF2kBKLNNhQsnOXAPtiYrrOgTyQCifcnk0rfQxOwlp1DiBm425hz2Snqhz8ULP05KV9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mh52GsbI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mh52GsbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC131F000FF;
	Sat, 12 Sep 2026 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227792;
	bh=N3Uv+pw/5nEXhXJK+cgEEeXfpY4umspynfqJTYQFLd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mh52GsbIERKZXmGC7b3h+UxlLA8NK03eeDe8s7UFNRmS4ukJz39r5D3YC2P/pqayz
	 /USMdUA/S+yTUpMr1a1h1HZDrCLRZyvGb+XyvpX2bQXqOwzuERfMN/gYc+AJg2SXLr
	 vjL1Aolsj7NdruMbqfVs0ThMf/ukUOS2gc3eIMuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0255/1191] landlock: Require LANDLOCK_ACCESS_FS_MAKE_REG for whiteout creation
Date: Sat, 12 Sep 2026 08:49:43 +0200
Message-ID: <20260912065553.946578807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 security/landlock/errata/abi-1.h | 24 +++++++++++++++++++
 security/landlock/fs.c           | 40 +++++++++++++++++++++++++-------
 3 files changed, 56 insertions(+), 9 deletions(-)
 create mode 100644 security/landlock/errata/abi-1.h

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index 17bdfaa9eb876..d7a974f80cb96 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -115,6 +115,7 @@ struct landlock_path_beneath_attr {
  *   device.
  * - %LANDLOCK_ACCESS_FS_MAKE_DIR: Create (or rename) a directory.
  * - %LANDLOCK_ACCESS_FS_MAKE_REG: Create (or rename or link) a regular file.
+ *   This also guards the creation of whiteout objects as used in OverlayFS.
  * - %LANDLOCK_ACCESS_FS_MAKE_SOCK: Create (or rename or link) a UNIX domain
  *   socket.
  * - %LANDLOCK_ACCESS_FS_MAKE_FIFO: Create (or rename or link) a named pipe.
diff --git a/security/landlock/errata/abi-1.h b/security/landlock/errata/abi-1.h
new file mode 100644
index 0000000000000..53c96c2057fa0
--- /dev/null
+++ b/security/landlock/errata/abi-1.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 7b95afcc6b437..dd7f0fd921cf6 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/kdev_t.h>
 #include <linux/kernel.h>
 #include <linux/limits.h>
 #include <linux/list.h>
@@ -664,7 +665,7 @@ static inline int current_check_access_path(const struct path *const path,
 	return check_access_path(dom, path, access_request);
 }
 
-static inline access_mask_t get_mode_access(const umode_t mode)
+static inline access_mask_t get_mode_access(const umode_t mode, const dev_t dev)
 {
 	switch (mode & S_IFMT) {
 	case S_IFLNK:
@@ -672,6 +673,9 @@ static inline access_mask_t get_mode_access(const umode_t mode)
 	case S_IFDIR:
 		return LANDLOCK_ACCESS_FS_MAKE_DIR;
 	case S_IFCHR:
+		/* Whiteout objects are guarded with MAKE_REG. */
+		if (dev == WHITEOUT_DEV)
+			return LANDLOCK_ACCESS_FS_MAKE_REG;
 		return LANDLOCK_ACCESS_FS_MAKE_CHAR;
 	case S_IFBLK:
 		return LANDLOCK_ACCESS_FS_MAKE_BLOCK;
@@ -688,6 +692,13 @@ static inline access_mask_t get_mode_access(const umode_t mode)
 	}
 }
 
+static inline access_mask_t get_dentry_access(const struct dentry *const dentry)
+{
+	const struct inode *const inode = d_backing_inode(dentry);
+
+	return get_mode_access(inode->i_mode, inode->i_rdev);
+}
+
 static inline access_mask_t maybe_remove(const struct dentry *const dentry)
 {
 	if (d_is_negative(dentry))
@@ -768,6 +779,7 @@ static bool collect_domain_accesses(
  * @new_dentry: Destination file or directory.
  * @removable: Sets to true if it is a rename operation.
  * @exchange: Sets to true if it is a rename operation with RENAME_EXCHANGE.
+ * @whiteout: Sets to true if it is a rename operation with RENAME_WHITEOUT.
  *
  * Because of its unprivileged constraints, Landlock relies on file hierarchies
  * (and not only inodes) to tie access rights to files.  Being able to link or
@@ -816,7 +828,8 @@ static bool collect_domain_accesses(
 static int current_check_refer_path(struct dentry *const old_dentry,
 				    const struct path *const new_dir,
 				    struct dentry *const new_dentry,
-				    const bool removable, const bool exchange)
+				    const bool removable, const bool exchange,
+				    const bool whiteout)
 {
 	const struct landlock_ruleset *const dom =
 		landlock_get_current_domain();
@@ -836,18 +849,25 @@ static int current_check_refer_path(struct dentry *const old_dentry,
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
@@ -1099,7 +1119,7 @@ static int hook_path_link(struct dentry *const old_dentry,
 			  struct dentry *const new_dentry)
 {
 	return current_check_refer_path(old_dentry, new_dir, new_dentry, false,
-					false);
+					false, false);
 }
 
 static int hook_path_rename(const struct path *const old_dir,
@@ -1110,7 +1130,8 @@ static int hook_path_rename(const struct path *const old_dir,
 {
 	/* old_dir refers to old_dentry->d_parent and new_dir->mnt */
 	return current_check_refer_path(old_dentry, new_dir, new_dentry, true,
-					!!(flags & RENAME_EXCHANGE));
+					!!(flags & RENAME_EXCHANGE),
+					!!(flags & RENAME_WHITEOUT));
 }
 
 static int hook_path_mkdir(const struct path *const dir,
@@ -1128,7 +1149,8 @@ static int hook_path_mknod(const struct path *const dir,
 
 	if (!dom)
 		return 0;
-	return check_access_path(dom, dir, get_mode_access(mode));
+	return check_access_path(dom, dir,
+				 get_mode_access(mode, new_decode_dev(dev)));
 }
 
 static int hook_path_symlink(const struct path *const dir,
-- 
2.53.0



