Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49619503BF3;
	Wed, 30 Sep 2026 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785636; cv=none; b=QIMdoB0jG3vyQJcfuCZtUJ6PeRvWz6+Djf0XA8IbIwqGbg25iwxL46D1Z4Qyr85T9N3ZNclAkYtDd7alg+YUD42t0zzYHdALPAdCLmVsOfxtL0jKgGL+k9V5aW7vbQenrdgJljsRZLzfruych7aqx6nj4YeZcmV6iPARqB+f3ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785636; c=relaxed/simple;
	bh=tXxl0oaZ3/6VXwMNt9Cs+k81DPdNLykcP+1pcLJvjoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BWYvAEB+T/ZqmsgkWmhCI90iYFKeQrky6O07/UBbZ0chdS2ipqiAII7Sb+enTRcTou29mDohKmj6vWYtX3zbJfvmvRKFa5MS6A10RBdWw9/jngAOguuP3BSwhkb4y4WTSA0u10W3HkLmgKRhJwdBsA1yEYMBS+h0IurMUlme2vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh42N06K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh42N06K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B48D1F00898;
	Wed, 30 Sep 2026 16:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785631;
	bh=r6dsx5aohK6F/UVsxr6OsNh3zxQNtUbKPJ/vIKT1jwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eh42N06K/lg8dWpKx93Z+Et9o6cOM8kNFlGVTR4c9RUfE/zdvoIZpdgntJEJbp+62
	 OP6P9LIgUktHo/Hlpr5VlJL3l/QzAbIDHkEXPH2haiaDRwi/dhjczZRBkUWeA0/sEK
	 zHSSpOxmew9TCWwM0qqE1cnabmIS5EgIin9ENH0I=
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
Subject: [PATCH 6.1 576/982] landlock: Fix handling of disconnected directories
Date: Wed, 30 Sep 2026 17:21:52 +0200
Message-ID: <20260930152429.145032331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
[mic: Backport: adjust the filesystem walk and errata insertion context]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/errata/abi-1.h | 15 ++++++++++++
 security/landlock/fs.c           | 40 +++++++++++++++++++++++---------
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/security/landlock/errata/abi-1.h b/security/landlock/errata/abi-1.h
index 53c96c2057fa0..80930957e84d2 100644
--- a/security/landlock/errata/abi-1.h
+++ b/security/landlock/errata/abi-1.h
@@ -1,5 +1,20 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 
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
+
 /**
  * DOC: erratum_4
  *
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index dd7f0fd921cf6..8f20a146648cf 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -607,19 +607,31 @@ static int check_access_path_dual(
 				break;
 			}
 		}
+
 		if (unlikely(IS_ROOT(walker_path.dentry))) {
+			if (likely(walker_path.mnt->mnt_flags & MNT_INTERNAL)) {
+				/*
+				 * Stops and allows access when reaching disconnected root
+				 * directories that are part of internal filesystems (e.g. nsfs,
+				 * which is reachable through /proc/<pid>/ns/<namespace>).
+				 */
+				allowed_parent1 = true;
+				allowed_parent2 = true;
+				break;
+			}
+
 			/*
-			 * Stops at disconnected root directories.  Only allows
-			 * access to internal filesystems (e.g. nsfs, which is
-			 * reachable through /proc/<pid>/ns/<namespace>).
+			 * We reached a disconnected root directory from a bind mount.
+			 * Let's continue the walk with the mount point we missed.
 			 */
-			allowed_parent1 = allowed_parent2 =
-				!!(walker_path.mnt->mnt_flags & MNT_INTERNAL);
-			break;
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
 
@@ -721,6 +733,9 @@ static inline access_mask_t maybe_remove(const struct dentry *const dentry)
  * file.  While walking from @dir to @mnt_root, we record all the domain's
  * allowed accesses in @layer_masks_dom.
  *
+ * Because of disconnected directories, this walk may not reach @mnt_dir.  In
+ * this case, the walk will continue to @mnt_dir after this call.
+ *
  * This is similar to check_access_path_dual() but much simpler because it only
  * handles walking on the same mount point and only checks one set of accesses.
  *
@@ -759,8 +774,11 @@ static bool collect_domain_accesses(
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
2.53.0



