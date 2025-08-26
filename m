Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7713124A066;
	Tue, 26 Aug 2025 13:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213726; cv=none; b=pXUz47UfRbzYx7HDsOT8y2amfrEz9zEK4EhJlxQyRMcdxJJTXSsOfJ4IhHOUzD39K5fCIOIAPh3/hpgi4/PfVk+EJ3m85jQZmWUOfTSWjK3SDgpSycSbIqoW1ZmWnhgvKnMJbvKlg48zk/Iph8aeR0zvjQGtWp9cZbmmyUtK4iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213726; c=relaxed/simple;
	bh=PvvlqgNRZjRueoTIsDjePHJX0H/0j6bvCKV4gKZBJ7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCtCuXYQJEc9rkJn+OdorS+3xsMA3UWc3a5ShbmNt1wb2YMg6SxbhDcvx0n0j4+5zOS46F8Gs2XR5oWDi+0WqBQLUG6uv3+9210nZxTU80YkrnrsFwsmQr37CMwOSm/uL4nFyuQ90kCb9du151s/rbQCoRIbVL3Up1aeAa7EA0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeF1uFbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeF1uFbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09888C4CEF1;
	Tue, 26 Aug 2025 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213726;
	bh=PvvlqgNRZjRueoTIsDjePHJX0H/0j6bvCKV4gKZBJ7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeF1uFbLpuvY6CDnGVsEEu0QyVFj1Q3XhMnCbj92YqRIWaXK01xvRgFKvw+j9vLXF
	 EE61JL+H2AryD3fEV2Uxj6onkXEOMIQhr1BKWS53ipbLu0tEsDqxNCw7WIPRv0wjmQ
	 tPtTKGFqSN3C9eCsA2lEeMTFkA+n8v+HKsnfZQb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 457/587] btrfs: send: keep the current inodes path cached
Date: Tue, 26 Aug 2025 13:10:06 +0200
Message-ID: <20250826111004.594138128@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -179,6 +179,7 @@ struct send_ctx {
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
 
@@ -3113,6 +3139,11 @@ static int orphanize_inode(struct send_c
 		goto out;
 
 	ret = send_rename(sctx, path, orphan);
+	if (ret < 0)
+		goto out;
+
+	if (ino == sctx->cur_ino && gen == sctx->cur_inode_gen)
+		ret = fs_path_copy(&sctx->cur_inode_path, orphan);
 
 out:
 	fs_path_free(orphan);
@@ -4176,6 +4207,10 @@ static int rename_current_inode(struct s
 	if (ret < 0)
 		return ret;
 
+	ret = fs_path_copy(&sctx->cur_inode_path, new_path);
+	if (ret < 0)
+		return ret;
+
 	return fs_path_copy(current_path, new_path);
 }
 
@@ -4369,6 +4404,7 @@ static int process_recorded_refs(struct
 				if (ret > 0) {
 					orphanized_ancestor = true;
 					fs_path_reset(valid_path);
+					fs_path_reset(&sctx->cur_inode_path);
 					ret = get_cur_path(sctx, sctx->cur_ino,
 							   sctx->cur_inode_gen,
 							   valid_path);
@@ -4568,6 +4604,8 @@ static int process_recorded_refs(struct
 				ret = send_unlink(sctx, cur->full_path);
 				if (ret < 0)
 					goto out;
+				if (is_current_inode_path(sctx, cur->full_path))
+					fs_path_reset(&sctx->cur_inode_path);
 			}
 			ret = dup_ref(cur, &check_dirs);
 			if (ret < 0)
@@ -6900,6 +6938,7 @@ static int changed_inode(struct send_ctx
 	sctx->cur_inode_last_extent = (u64)-1;
 	sctx->cur_inode_next_write_offset = 0;
 	sctx->ignore_cur_inode = false;
+	fs_path_reset(&sctx->cur_inode_path);
 
 	/*
 	 * Set send_progress to current inode. This will tell all get_cur_xxx
@@ -8190,6 +8229,7 @@ long btrfs_ioctl_send(struct inode *inod
 		goto out;
 	}
 
+	init_path(&sctx->cur_inode_path);
 	INIT_LIST_HEAD(&sctx->new_refs);
 	INIT_LIST_HEAD(&sctx->deleted_refs);
 
@@ -8475,6 +8515,9 @@ out:
 		btrfs_lru_cache_clear(&sctx->dir_created_cache);
 		btrfs_lru_cache_clear(&sctx->dir_utimes_cache);
 
+		if (sctx->cur_inode_path.buf != sctx->cur_inode_path.inline_buf)
+			kfree(sctx->cur_inode_path.buf);
+
 		kfree(sctx);
 	}
 


