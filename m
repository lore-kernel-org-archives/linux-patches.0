Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A7D233706;
	Mon, 10 Mar 2025 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628760; cv=none; b=CjfY8eTMGBA3cpKnJRmE5m+FaFWRP67LgXQlWL1OkOJYzZEQNXp9K7rFbY+bN+RJG3zyv53yKMgbhEZgaHf9NVcQcs5sgqgXvUMCzTDUkT4VrKMOTu80rqiBBC7931JysXAzmbVflbN4GQ9zLNOSC159muSkd3gE03KrBPFWG9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628760; c=relaxed/simple;
	bh=tKKoteUkwmu4+txe1E5X2ABs1hnziPEv8auZNcZqmS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPx/GpTK3J92t6628/LCWbN/gRtpaROrdohEVnV9dUNeBvl6x0Fk95rUCBVGQ5HnnT2MTqXSCLanyol/31yqsee5JZrkFitGatdPUe8VyR3jZPLmuk8sIZny7DTxh2v9c0EqdEoSpGyGeSMhSXKGmHavS/GTb0t2+K94tCH6xdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLnJEOeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLnJEOeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DC3C4CEE5;
	Mon, 10 Mar 2025 17:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628760;
	bh=tKKoteUkwmu4+txe1E5X2ABs1hnziPEv8auZNcZqmS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLnJEOeJAr6grc6h4F9h+hP5rtgnNuYJxK/s4BLo9RPVMZWS36l4wqjHiZ1wG+Blo
	 4lCEfnWTS6ekybZFVhtLP4mpG0SgpLAZ0Jf+JWVzUaIeCOlucK8rHBRO/7jjgU/ZGy
	 GJ/9GpCEWVq7mRYCBgU8yltW42w1iU9M6tqGbB8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/620] landlock: Move filesystem helpers and add a new one
Date: Mon, 10 Mar 2025 17:58:26 +0100
Message-ID: <20250310170547.954519280@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 9da82b20fde95814af721a2a7b1796a5b4a3d78e ]

Move the SB_NOUSER and IS_PRIVATE dentry check to a standalone
is_nouser_or_private() helper.  This will be useful for a following
commit.

Move get_mode_access() and maybe_remove() to make them usable by new
code provided by a following commit.

Reviewed-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20220506161102.525323-6-mic@digikod.net
Stable-dep-of: 49440290a093 ("landlock: Handle weird files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/fs.c | 87 ++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 41 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index c5749301b37d6..7b7860039a08b 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -261,6 +261,18 @@ unmask_layers(const struct landlock_rule *const rule,
 	return false;
 }
 
+/*
+ * Allows access to pseudo filesystems that will never be mountable (e.g.
+ * sockfs, pipefs), but can still be reachable through
+ * /proc/<pid>/fd/<file-descriptor>
+ */
+static inline bool is_nouser_or_private(const struct dentry *dentry)
+{
+	return (dentry->d_sb->s_flags & SB_NOUSER) ||
+	       (d_is_positive(dentry) &&
+		unlikely(IS_PRIVATE(d_backing_inode(dentry))));
+}
+
 static int check_access_path(const struct landlock_ruleset *const domain,
 			     const struct path *const path,
 			     const access_mask_t access_request)
@@ -274,14 +286,7 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 		return 0;
 	if (WARN_ON_ONCE(!domain || !path))
 		return 0;
-	/*
-	 * Allows access to pseudo filesystems that will never be mountable
-	 * (e.g. sockfs, pipefs), but can still be reachable through
-	 * /proc/<pid>/fd/<file-descriptor> .
-	 */
-	if ((path->dentry->d_sb->s_flags & SB_NOUSER) ||
-	    (d_is_positive(path->dentry) &&
-	     unlikely(IS_PRIVATE(d_backing_inode(path->dentry)))))
+	if (is_nouser_or_private(path->dentry))
 		return 0;
 	if (WARN_ON_ONCE(domain->num_layers < 1))
 		return -EACCES;
@@ -360,6 +365,39 @@ static inline int current_check_access_path(const struct path *const path,
 	return check_access_path(dom, path, access_request);
 }
 
+static inline access_mask_t get_mode_access(const umode_t mode)
+{
+	switch (mode & S_IFMT) {
+	case S_IFLNK:
+		return LANDLOCK_ACCESS_FS_MAKE_SYM;
+	case 0:
+		/* A zero mode translates to S_IFREG. */
+	case S_IFREG:
+		return LANDLOCK_ACCESS_FS_MAKE_REG;
+	case S_IFDIR:
+		return LANDLOCK_ACCESS_FS_MAKE_DIR;
+	case S_IFCHR:
+		return LANDLOCK_ACCESS_FS_MAKE_CHAR;
+	case S_IFBLK:
+		return LANDLOCK_ACCESS_FS_MAKE_BLOCK;
+	case S_IFIFO:
+		return LANDLOCK_ACCESS_FS_MAKE_FIFO;
+	case S_IFSOCK:
+		return LANDLOCK_ACCESS_FS_MAKE_SOCK;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+static inline access_mask_t maybe_remove(const struct dentry *const dentry)
+{
+	if (d_is_negative(dentry))
+		return 0;
+	return d_is_dir(dentry) ? LANDLOCK_ACCESS_FS_REMOVE_DIR :
+				  LANDLOCK_ACCESS_FS_REMOVE_FILE;
+}
+
 /* Inode hooks */
 
 static void hook_inode_free_security(struct inode *const inode)
@@ -553,31 +591,6 @@ static int hook_sb_pivotroot(const struct path *const old_path,
 
 /* Path hooks */
 
-static inline access_mask_t get_mode_access(const umode_t mode)
-{
-	switch (mode & S_IFMT) {
-	case S_IFLNK:
-		return LANDLOCK_ACCESS_FS_MAKE_SYM;
-	case 0:
-		/* A zero mode translates to S_IFREG. */
-	case S_IFREG:
-		return LANDLOCK_ACCESS_FS_MAKE_REG;
-	case S_IFDIR:
-		return LANDLOCK_ACCESS_FS_MAKE_DIR;
-	case S_IFCHR:
-		return LANDLOCK_ACCESS_FS_MAKE_CHAR;
-	case S_IFBLK:
-		return LANDLOCK_ACCESS_FS_MAKE_BLOCK;
-	case S_IFIFO:
-		return LANDLOCK_ACCESS_FS_MAKE_FIFO;
-	case S_IFSOCK:
-		return LANDLOCK_ACCESS_FS_MAKE_SOCK;
-	default:
-		WARN_ON_ONCE(1);
-		return 0;
-	}
-}
-
 /*
  * Creating multiple links or renaming may lead to privilege escalations if not
  * handled properly.  Indeed, we must be sure that the source doesn't gain more
@@ -606,14 +619,6 @@ static int hook_path_link(struct dentry *const old_dentry,
 		get_mode_access(d_backing_inode(old_dentry)->i_mode));
 }
 
-static inline access_mask_t maybe_remove(const struct dentry *const dentry)
-{
-	if (d_is_negative(dentry))
-		return 0;
-	return d_is_dir(dentry) ? LANDLOCK_ACCESS_FS_REMOVE_DIR :
-				  LANDLOCK_ACCESS_FS_REMOVE_FILE;
-}
-
 static int hook_path_rename(const struct path *const old_dir,
 			    struct dentry *const old_dentry,
 			    const struct path *const new_dir,
-- 
2.39.5



