Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D5C3CE4B9;
	Wed, 30 Sep 2026 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794922; cv=none; b=I9b3OphgiwTIzqNyRA7cepyNKGkJkpIZW2KT2ZLU2v0GXc2AC878KCaMoa1raidFYb4h+dLQd8L/sJyZcCbMjfFXJCIhA5Cd5WRW2nWS1KJ95U++OEbf4iQwwDfDwEFxKE2QtcQ0LlcX7zfKndRAia1SYYHp/HhpNzYJFK1gMY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794922; c=relaxed/simple;
	bh=TMw1AbRdI+CnqEAuhi0PmDRpIqUIFgaoWDqXxZaJC0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqUqxNJNST1abKQM3kmFCN8EtUa+xuk7KYL0UmCyv4C396GnTIYsWOhL9sPPf0JOw/mYIq3/lvHg1h3vBH0Y8JJtPJ3CwkdszlhChXBm5j1iqgeLgShVC2w9cbZdv1YvkhP8TRbk8mMM3zf1M7o43xzlk4LLHuonfIpKbqM3vvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqaorfAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqaorfAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFC11F00898;
	Wed, 30 Sep 2026 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794921;
	bh=xOm8ZFepmFL+mWvlJ9ib4oUYa0iNpvzbml1ll2jLfbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqaorfAdkzEFsSEsLbxx8yAmRuh5X+VfQcTUG0e4d7+iqqZ8SSd6LWwarnqfxUPcK
	 Xp7vvg1bY8yLXCU6kMZ0ZiEWMhEiFbHznnzpPUUR33F3KLlFhxZWHJieBSLp7C/0GX
	 0+0kVfL/+Ya19ztzgqiN+FueuO+thdrsZ7gRLivk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0381/1193] ufs: convert to new timestamp accessors
Date: Wed, 30 Sep 2026 17:17:45 +0200
Message-ID: <20260930152442.649698210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d936d3820658bc2728804482c7a3d07ea5da2a3d ]

Convert to using the new inode timestamp accessor functions.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20231004185347.80880-73-jlayton@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 08edfb34ee9c ("ufs: do not treat unreadable directory blocks as empty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/dir.c    |  6 +++---
 fs/ufs/ialloc.c |  2 +-
 fs/ufs/inode.c  | 42 ++++++++++++++++++++++++------------------
 3 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index fd57f03b6c931..27c85d92d1dc5 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -107,7 +107,7 @@ void ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
 	ufs_commit_chunk(page, pos, len);
 	ufs_put_page(page);
 	if (update_times)
-		dir->i_mtime = inode_set_ctime_current(dir);
+		inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	mark_inode_dirty(dir);
 	ufs_handle_dirsync(dir);
 }
@@ -397,7 +397,7 @@ int ufs_add_link(struct dentry *dentry, struct inode *inode)
 	ufs_set_de_type(sb, de, inode->i_mode);
 
 	ufs_commit_chunk(page, pos, rec_len);
-	dir->i_mtime = inode_set_ctime_current(dir);
+	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 
 	mark_inode_dirty(dir);
 	err = ufs_handle_dirsync(dir);
@@ -539,7 +539,7 @@ int ufs_delete_entry(struct inode *inode, struct ufs_dir_entry *dir,
 		pde->d_reclen = cpu_to_fs16(sb, to - from);
 	dir->d_ino = 0;
 	ufs_commit_chunk(page, pos, to - from);
-	inode->i_mtime = inode_set_ctime_current(inode);
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	mark_inode_dirty(inode);
 	err = ufs_handle_dirsync(inode);
 out:
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index a1e7bd9d1f982..73531827ecee1 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -292,7 +292,7 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
 	inode->i_blocks = 0;
 	inode->i_generation = 0;
-	inode->i_mtime = inode->i_atime = inode_set_ctime_current(inode);
+	simple_inode_init_ts(inode);
 	ufsi->i_flags = UFS_I(dir)->i_flags;
 	ufsi->i_lastfrag = 0;
 	ufsi->i_shadow = 0;
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 21a4779a2de5f..338e4b97312f6 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -579,13 +579,15 @@ static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 	i_gid_write(inode, ufs_get_inode_gid(sb, ufs_inode));
 
 	inode->i_size = fs64_to_cpu(sb, ufs_inode->ui_size);
-	inode->i_atime.tv_sec = (signed)fs32_to_cpu(sb, ufs_inode->ui_atime.tv_sec);
+	inode_set_atime(inode,
+			(signed)fs32_to_cpu(sb, ufs_inode->ui_atime.tv_sec),
+			0);
 	inode_set_ctime(inode,
 			(signed)fs32_to_cpu(sb, ufs_inode->ui_ctime.tv_sec),
 			0);
-	inode->i_mtime.tv_sec = (signed)fs32_to_cpu(sb, ufs_inode->ui_mtime.tv_sec);
-	inode->i_mtime.tv_nsec = 0;
-	inode->i_atime.tv_nsec = 0;
+	inode_set_mtime(inode,
+			(signed)fs32_to_cpu(sb, ufs_inode->ui_mtime.tv_sec),
+			0);
 	inode->i_blocks = fs32_to_cpu(sb, ufs_inode->ui_blocks);
 	inode->i_generation = fs32_to_cpu(sb, ufs_inode->ui_gen);
 	ufsi->i_flags = fs32_to_cpu(sb, ufs_inode->ui_flags);
@@ -626,12 +628,12 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 	i_gid_write(inode, fs32_to_cpu(sb, ufs2_inode->ui_gid));
 
 	inode->i_size = fs64_to_cpu(sb, ufs2_inode->ui_size);
-	inode->i_atime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_atime);
+	inode_set_atime(inode, fs64_to_cpu(sb, ufs2_inode->ui_atime),
+			fs32_to_cpu(sb, ufs2_inode->ui_atimensec));
 	inode_set_ctime(inode, fs64_to_cpu(sb, ufs2_inode->ui_ctime),
 			fs32_to_cpu(sb, ufs2_inode->ui_ctimensec));
-	inode->i_mtime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_mtime);
-	inode->i_atime.tv_nsec = fs32_to_cpu(sb, ufs2_inode->ui_atimensec);
-	inode->i_mtime.tv_nsec = fs32_to_cpu(sb, ufs2_inode->ui_mtimensec);
+	inode_set_mtime(inode, fs64_to_cpu(sb, ufs2_inode->ui_mtime),
+			fs32_to_cpu(sb, ufs2_inode->ui_mtimensec));
 	inode->i_blocks = fs64_to_cpu(sb, ufs2_inode->ui_blocks);
 	inode->i_generation = fs32_to_cpu(sb, ufs2_inode->ui_gen);
 	ufsi->i_flags = fs32_to_cpu(sb, ufs2_inode->ui_flags);
@@ -725,12 +727,14 @@ static void ufs1_update_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 	ufs_set_inode_gid(sb, ufs_inode, i_gid_read(inode));
 
 	ufs_inode->ui_size = cpu_to_fs64(sb, inode->i_size);
-	ufs_inode->ui_atime.tv_sec = cpu_to_fs32(sb, inode->i_atime.tv_sec);
+	ufs_inode->ui_atime.tv_sec = cpu_to_fs32(sb,
+						 inode_get_atime_sec(inode));
 	ufs_inode->ui_atime.tv_usec = 0;
 	ufs_inode->ui_ctime.tv_sec = cpu_to_fs32(sb,
-						 inode_get_ctime(inode).tv_sec);
+						 inode_get_ctime_sec(inode));
 	ufs_inode->ui_ctime.tv_usec = 0;
-	ufs_inode->ui_mtime.tv_sec = cpu_to_fs32(sb, inode->i_mtime.tv_sec);
+	ufs_inode->ui_mtime.tv_sec = cpu_to_fs32(sb,
+						 inode_get_mtime_sec(inode));
 	ufs_inode->ui_mtime.tv_usec = 0;
 	ufs_inode->ui_blocks = cpu_to_fs32(sb, inode->i_blocks);
 	ufs_inode->ui_flags = cpu_to_fs32(sb, ufsi->i_flags);
@@ -770,13 +774,15 @@ static void ufs2_update_inode(struct inode *inode, struct ufs2_inode *ufs_inode)
 	ufs_inode->ui_gid = cpu_to_fs32(sb, i_gid_read(inode));
 
 	ufs_inode->ui_size = cpu_to_fs64(sb, inode->i_size);
-	ufs_inode->ui_atime = cpu_to_fs64(sb, inode->i_atime.tv_sec);
-	ufs_inode->ui_atimensec = cpu_to_fs32(sb, inode->i_atime.tv_nsec);
-	ufs_inode->ui_ctime = cpu_to_fs64(sb, inode_get_ctime(inode).tv_sec);
+	ufs_inode->ui_atime = cpu_to_fs64(sb, inode_get_atime_sec(inode));
+	ufs_inode->ui_atimensec = cpu_to_fs32(sb,
+					      inode_get_atime_nsec(inode));
+	ufs_inode->ui_ctime = cpu_to_fs64(sb, inode_get_ctime_sec(inode));
 	ufs_inode->ui_ctimensec = cpu_to_fs32(sb,
-					      inode_get_ctime(inode).tv_nsec);
-	ufs_inode->ui_mtime = cpu_to_fs64(sb, inode->i_mtime.tv_sec);
-	ufs_inode->ui_mtimensec = cpu_to_fs32(sb, inode->i_mtime.tv_nsec);
+					      inode_get_ctime_nsec(inode));
+	ufs_inode->ui_mtime = cpu_to_fs64(sb, inode_get_mtime_sec(inode));
+	ufs_inode->ui_mtimensec = cpu_to_fs32(sb,
+					      inode_get_mtime_nsec(inode));
 
 	ufs_inode->ui_blocks = cpu_to_fs64(sb, inode->i_blocks);
 	ufs_inode->ui_flags = cpu_to_fs32(sb, ufsi->i_flags);
@@ -1208,7 +1214,7 @@ static int ufs_truncate(struct inode *inode, loff_t size)
 	truncate_setsize(inode, size);
 
 	ufs_truncate_blocks(inode);
-	inode->i_mtime = inode_set_ctime_current(inode);
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	mark_inode_dirty(inode);
 out:
 	UFSD("EXIT: err %d\n", err);
-- 
2.53.0



