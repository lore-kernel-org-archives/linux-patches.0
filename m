Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FB729BDB8;
	Tue, 26 Aug 2025 11:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208548; cv=none; b=a2OyZ99pkPL9MANQCZRAskTzW7JNmk5CWt0sz67T9VUAZHOsfy1yIW/SpulkpV85ZKdVYNli4vxv/KXqGyuoMW4RaHvWGSOh8MNOuBTfkgKTSiSL7k37/st65a4XT769UN1f7iiNbnPLH4a90ZU+ePwXa6V1vNkNoEX+caFg9D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208548; c=relaxed/simple;
	bh=qQ1d0qWiJbLYIYwS9QA8iO8JBm5PX23CVYBVcwdI8IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9N2JHtBy22cjZZpoBy0KICKpz2oUEEsBpEB2IzeB5y2XNB85Nxv6Of+pXOl4/M5hHhcdFwvl9MiSvLnFdxSXLyn9ZKkyQhbCmcnZTSzUkHOsmPvBR0ObJxb+1eVdY+qtLSH03mVmKq6UPlQJacoyqwI5UZj3PVvz5hlWqVyVKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Po4Bl+Jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Po4Bl+Jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADD6C4CEF1;
	Tue, 26 Aug 2025 11:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208547;
	bh=qQ1d0qWiJbLYIYwS9QA8iO8JBm5PX23CVYBVcwdI8IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Po4Bl+JloL7/YNe5wSdJrdQMYjeiThzYabzk3YHjJq/OWvDGqelLJDaGWZe/NWDFd
	 qgMfXGjqSCGpwHTt8m8Tqk6+CaTBgT9y5+S23Fq1Gp54zuAY7WW8OgqIuWBZXck96Y
	 mxl9kCqiGCRoEd4NSbbgY0c+PiJawa8VxsYtdNUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/322] btrfs: send: keep the current inodes path cached
Date: Tue, 26 Aug 2025 13:09:29 +0200
Message-ID: <20250826110919.620220940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit fc746acb7aa9aeaa2cb5dcba449323319ba5c8eb ]

Whenever we need to send a command for the current inode, like sending
writes, xattr updates, truncates, utimes, etc, we compute the inode's
path each time, which implies doing some memory allocations and traversing
the inode hierarchy to extract the name of the inode and each ancestor
directory, and that implies doing lookups in the subvolume tree amongst
other operations.

Most of the time, by far, the current inode's path doesn't change while
we are processing it (like if we need to issue 100 write commands, the
path remains the same and it's pointless to compute it 100 times).

To avoid this keep the current inode's path cached in the send context
and invalidate it or update it whenever it's needed (after unlinks or
renames).

A performance test, and its results, is mentioned in the next patch in
the series (subject: "btrfs: send: avoid path allocation for the current
inode when issuing commands").

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 005b0a0c24e1 ("btrfs: send: use fallocate for hole punching with send stream v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 5 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -178,6 +178,7 @@ struct send_ctx {
 	u64 cur_inode_rdev;
 	u64 cur_inode_last_extent;
 	u64 cur_inode_next_write_offset;
+	struct fs_path cur_inode_path;
 	bool cur_inode_new;
 	bool cur_inode_new_gen;
 	bool cur_inode_deleted;
@@ -436,6 +437,14 @@ static void fs_path_reset(struct fs_path
 	}
 }
 
+static void init_path(struct fs_path *p)
+{
+	p->reversed = 0;
+	p->buf = p->inline_buf;
+	p->buf_len = FS_PATH_INLINE_SIZE;
+	fs_path_reset(p);
+}
+
 static struct fs_path *fs_path_alloc(void)
 {
 	struct fs_path *p;
@@ -443,10 +452,7 @@ static struct fs_path *fs_path_alloc(voi
 	p = kmalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return NULL;
-	p->reversed = 0;
-	p->buf = p->inline_buf;
-	p->buf_len = FS_PATH_INLINE_SIZE;
-	fs_path_reset(p);
+	init_path(p);
 	return p;
 }
 
@@ -624,6 +630,14 @@ static void fs_path_unreverse(struct fs_
 	p->reversed = 0;
 }
 
+static inline bool is_current_inode_path(const struct send_ctx *sctx,
+					 const struct fs_path *path)
+{
+	const struct fs_path *cur = &sctx->cur_inode_path;
+
+	return (strncmp(path->start, cur->start, fs_path_len(cur)) == 0);
+}
+
 static struct btrfs_path *alloc_path_for_send(void)
 {
 	struct btrfs_path *path;
@@ -2450,6 +2464,14 @@ static int get_cur_path(struct send_ctx
 	u64 parent_inode = 0;
 	u64 parent_gen = 0;
 	int stop = 0;
+	const bool is_cur_inode = (ino == sctx->cur_ino && gen == sctx->cur_inode_gen);
+
+	if (is_cur_inode && fs_path_len(&sctx->cur_inode_path) > 0) {
+		if (dest != &sctx->cur_inode_path)
+			return fs_path_copy(dest, &sctx->cur_inode_path);
+
+		return 0;
+	}
 
 	name = fs_path_alloc();
 	if (!name) {
@@ -2501,8 +2523,12 @@ static int get_cur_path(struct send_ctx
 
 out:
 	fs_path_free(name);
-	if (!ret)
+	if (!ret) {
 		fs_path_unreverse(dest);
+		if (is_cur_inode && dest != &sctx->cur_inode_path)
+			ret = fs_path_copy(&sctx->cur_inode_path, dest);
+	}
+
 	return ret;
 }
 
@@ -3112,6 +3138,11 @@ static int orphanize_inode(struct send_c
 		goto out;
 
 	ret = send_rename(sctx, path, orphan);
+	if (ret < 0)
+		goto out;
+
+	if (ino == sctx->cur_ino && gen == sctx->cur_inode_gen)
+		ret = fs_path_copy(&sctx->cur_inode_path, orphan);
 
 out:
 	fs_path_free(orphan);
@@ -4175,6 +4206,10 @@ static int rename_current_inode(struct s
 	if (ret < 0)
 		return ret;
 
+	ret = fs_path_copy(&sctx->cur_inode_path, new_path);
+	if (ret < 0)
+		return ret;
+
 	return fs_path_copy(current_path, new_path);
 }
 
@@ -4368,6 +4403,7 @@ static int process_recorded_refs(struct
 				if (ret > 0) {
 					orphanized_ancestor = true;
 					fs_path_reset(valid_path);
+					fs_path_reset(&sctx->cur_inode_path);
 					ret = get_cur_path(sctx, sctx->cur_ino,
 							   sctx->cur_inode_gen,
 							   valid_path);
@@ -4567,6 +4603,8 @@ static int process_recorded_refs(struct
 				ret = send_unlink(sctx, cur->full_path);
 				if (ret < 0)
 					goto out;
+				if (is_current_inode_path(sctx, cur->full_path))
+					fs_path_reset(&sctx->cur_inode_path);
 			}
 			ret = dup_ref(cur, &check_dirs);
 			if (ret < 0)
@@ -6902,6 +6940,7 @@ static int changed_inode(struct send_ctx
 	sctx->cur_inode_last_extent = (u64)-1;
 	sctx->cur_inode_next_write_offset = 0;
 	sctx->ignore_cur_inode = false;
+	fs_path_reset(&sctx->cur_inode_path);
 
 	/*
 	 * Set send_progress to current inode. This will tell all get_cur_xxx
@@ -8174,6 +8213,7 @@ long btrfs_ioctl_send(struct btrfs_inode
 		goto out;
 	}
 
+	init_path(&sctx->cur_inode_path);
 	INIT_LIST_HEAD(&sctx->new_refs);
 	INIT_LIST_HEAD(&sctx->deleted_refs);
 
@@ -8459,6 +8499,9 @@ out:
 		btrfs_lru_cache_clear(&sctx->dir_created_cache);
 		btrfs_lru_cache_clear(&sctx->dir_utimes_cache);
 
+		if (sctx->cur_inode_path.buf != sctx->cur_inode_path.inline_buf)
+			kfree(sctx->cur_inode_path.buf);
+
 		kfree(sctx);
 	}
 


