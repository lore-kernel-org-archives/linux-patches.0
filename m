Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D898639A11E;
	Tue, 16 Dec 2025 12:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888384; cv=none; b=cW9FpYg4X4U4WYshtK5iH0M5FdQ03ptQNTsGT+rJlMfYqHTfW6nx1Xr7WpwAGkB5VEy/j/EVGDyZjF0Ox2Hwus6UL1IohNsUDxSFz0ByyfKuQ25eI6mI5xaSBbaG0W+WjF91nUK7V0bRthzI0Z4jM/3VOW9//Jd9/C9sPx/1R7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888384; c=relaxed/simple;
	bh=aWpiBfDJt7lAjbZMaXmjmlooq843iOb66p8zGGTc/aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1MWecfGKLWpeBhZB+yfZWuhHb0m/qLa/+0opi3xZnfshXq7oCvFaHNpv0IDySC0dSDUS666Po6me2g5LgGIdryQIjfev6YD16TrqVKLtdGHCWQ/2efypd6qaz3b+96nJ4ZQxCRs1yP0Yf9oFnbKTqxCI+/CS0OwbDQxXxtKSDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUY/EWPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUY/EWPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D26C4CEF1;
	Tue, 16 Dec 2025 12:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888384;
	bh=aWpiBfDJt7lAjbZMaXmjmlooq843iOb66p8zGGTc/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUY/EWPwfafO9oZJVaUdPqjh37Etghkv+5b/O7VXvNdwp8wliYIqVxHf+EtSnPWA8
	 /N5MbbRTB+8v+nBKhp3xWB9nI35eGulg/h5BTGl40nDhE6N5gGm60SPxkXSRZ5RNMy
	 Al+o3fDZvem5zuOcwOaIIZW5LRej2htc+3o4MfG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Song Liu <song@kernel.org>,
	Tingmao Wang <m@maowtm.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 491/614] landlock: Fix handling of disconnected directories
Date: Tue, 16 Dec 2025 12:14:18 +0100
Message-ID: <20251216111419.159564506@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 49c9e09d961025b22e61ef9ad56aa1c21b6ce2f1 ]

Disconnected files or directories can appear when they are visible and
opened from a bind mount, but have been renamed or moved from the source
of the bind mount in a way that makes them inaccessible from the mount
point (i.e. out of scope).

Previously, access rights tied to files or directories opened through a
disconnected directory were collected by walking the related hierarchy
down to the root of the filesystem, without taking into account the
mount point because it couldn't be found. This could lead to
inconsistent access results, potential access right widening, and
hard-to-debug renames, especially since such paths cannot be printed.

For a sandboxed task to create a disconnected directory, it needs to
have write access (i.e. FS_MAKE_REG, FS_REMOVE_FILE, and FS_REFER) to
the underlying source of the bind mount, and read access to the related
mount point.   Because a sandboxed task cannot acquire more access
rights than those defined by its Landlock domain, this could lead to
inconsistent access rights due to missing permissions that should be
inherited from the mount point hierarchy, while inheriting permissions
from the filesystem hierarchy hidden by this mount point instead.

Landlock now handles files and directories opened from disconnected
directories by taking into account the filesystem hierarchy when the
mount point is not found in the hierarchy walk, and also always taking
into account the mount point from which these disconnected directories
were opened.  This ensures that a rename is not allowed if it would
widen access rights [1].

The rationale is that, even if disconnected hierarchies might not be
visible or accessible to a sandboxed task, relying on the collected
access rights from them improves the guarantee that access rights will
not be widened during a rename because of the access right comparison
between the source and the destination (see LANDLOCK_ACCESS_FS_REFER).
It may look like this would grant more access on disconnected files and
directories, but the security policies are always enforced for all the
evaluated hierarchies.  This new behavior should be less surprising to
users and safer from an access control perspective.

Remove a wrong WARN_ON_ONCE() canary in collect_domain_accesses() and
fix the related comment.

Because opened files have their access rights stored in the related file
security properties, there is no impact for disconnected or unlinked
files.

Cc: Christian Brauner <brauner@kernel.org>
Cc: Günther Noack <gnoack@google.com>
Cc: Song Liu <song@kernel.org>
Reported-by: Tingmao Wang <m@maowtm.org>
Closes: https://lore.kernel.org/r/027d5190-b37a-40a8-84e9-4ccbc352bcdf@maowtm.org
Closes: https://lore.kernel.org/r/09b24128f86973a6022e6aa8338945fcfb9a33e4.1749925391.git.m@maowtm.org
Fixes: b91c3e4ea756 ("landlock: Add support for file reparenting with LANDLOCK_ACCESS_FS_REFER")
Fixes: cb2c7d1a1776 ("landlock: Support filesystem access-control")
Link: https://lore.kernel.org/r/b0f46246-f2c5-42ca-93ce-0d629702a987@maowtm.org [1]
Reviewed-by: Tingmao Wang <m@maowtm.org>
Link: https://lore.kernel.org/r/20251128172200.760753-2-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/errata/abi-1.h | 16 +++++++++++++
 security/landlock/fs.c           | 40 ++++++++++++++++++++++----------
 2 files changed, 44 insertions(+), 12 deletions(-)
 create mode 100644 security/landlock/errata/abi-1.h

diff --git a/security/landlock/errata/abi-1.h b/security/landlock/errata/abi-1.h
new file mode 100644
index 0000000000000..e8a2bff2e5b6a
--- /dev/null
+++ b/security/landlock/errata/abi-1.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+/**
+ * DOC: erratum_3
+ *
+ * Erratum 3: Disconnected directory handling
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This fix addresses an issue with disconnected directories that occur when a
+ * directory is moved outside the scope of a bind mount.  The change ensures
+ * that evaluated access rights include both those from the disconnected file
+ * hierarchy down to its filesystem root and those from the related mount point
+ * hierarchy.  This prevents access right widening through rename or link
+ * actions.
+ */
+LANDLOCK_ERRATUM(3)
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index d9c12b993fa7d..a2ed0e76938aa 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -909,21 +909,31 @@ static bool is_access_to_paths_allowed(
 				break;
 			}
 		}
+
 		if (unlikely(IS_ROOT(walker_path.dentry))) {
-			/*
-			 * Stops at disconnected root directories.  Only allows
-			 * access to internal filesystems (e.g. nsfs, which is
-			 * reachable through /proc/<pid>/ns/<namespace>).
-			 */
-			if (walker_path.mnt->mnt_flags & MNT_INTERNAL) {
+			if (likely(walker_path.mnt->mnt_flags & MNT_INTERNAL)) {
+				/*
+				 * Stops and allows access when reaching disconnected root
+				 * directories that are part of internal filesystems (e.g. nsfs,
+				 * which is reachable through /proc/<pid>/ns/<namespace>).
+				 */
 				allowed_parent1 = true;
 				allowed_parent2 = true;
+				break;
 			}
-			break;
+
+			/*
+			 * We reached a disconnected root directory from a bind mount.
+			 * Let's continue the walk with the mount point we missed.
+			 */
+			dput(walker_path.dentry);
+			walker_path.dentry = walker_path.mnt->mnt_root;
+			dget(walker_path.dentry);
+		} else {
+			parent_dentry = dget_parent(walker_path.dentry);
+			dput(walker_path.dentry);
+			walker_path.dentry = parent_dentry;
 		}
-		parent_dentry = dget_parent(walker_path.dentry);
-		dput(walker_path.dentry);
-		walker_path.dentry = parent_dentry;
 	}
 	path_put(&walker_path);
 
@@ -1021,6 +1031,9 @@ static access_mask_t maybe_remove(const struct dentry *const dentry)
  * file.  While walking from @dir to @mnt_root, we record all the domain's
  * allowed accesses in @layer_masks_dom.
  *
+ * Because of disconnected directories, this walk may not reach @mnt_dir.  In
+ * this case, the walk will continue to @mnt_dir after this call.
+ *
  * This is similar to is_access_to_paths_allowed() but much simpler because it
  * only handles walking on the same mount point and only checks one set of
  * accesses.
@@ -1062,8 +1075,11 @@ static bool collect_domain_accesses(
 			break;
 		}
 
-		/* We should not reach a root other than @mnt_root. */
-		if (dir == mnt_root || WARN_ON_ONCE(IS_ROOT(dir)))
+		/*
+		 * Stops at the mount point or the filesystem root for a disconnected
+		 * directory.
+		 */
+		if (dir == mnt_root || unlikely(IS_ROOT(dir)))
 			break;
 
 		parent_dentry = dget_parent(dir);
-- 
2.51.0



