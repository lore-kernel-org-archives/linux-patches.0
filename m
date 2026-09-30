Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BAE556B8E;
	Wed, 30 Sep 2026 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790168; cv=none; b=nPv0/NmD0xnbqCK8ErdWpAxAVsCSgY/Y8EB8Ii8P0KeMGYEdhgM7Upwda9qUEfLdyLPI4uhr9OwmIT2ndKEDH1YAMZvZHUkxMiI+NK8CMJo1g8AdsiL3jKgy92W5VoJMFcRsheARg4v7+vzeAcNYKmqsY8rhBIv6gFcF2Sym86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790168; c=relaxed/simple;
	bh=P32J3jnUjI+/BA8UPEUQTbrjjqv1lWKYcEZvxANX6EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRNolZA8UHXLi4clZ33UdDBd9Yc//9lwLvjWABnUjIXnnrE3ustZG/0GGSWvcIOSeOpm878MvS7gB1Wa+iiAepIvpVjxN7KqixAARJR0OxDYTqgZrgRkFDXucwYIQ7RFFiS6ILQle8PXTAh+jcdPUIxXSkxHQ/g/gL7oaajndac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG3+aIpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG3+aIpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1914E1F000FF;
	Wed, 30 Sep 2026 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790167;
	bh=xBLfgqz5tg1YQg0SOgptrdKmrMp/vLuy+GlCoU8vEoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RG3+aIpGxba/iNFbGKCGus+PAL3IbGnS0Uz9uLw+ePg3o49p1AxtwmZO/TNwjHop/
	 /OsqUDAB8p6FFQe5615cgdD0GPFfMnZwCG7i3gUFrsKs6b4lZQF9DAsna0lGYb8AQm
	 N9RVuyWDcjvb5dxqt+Gsi40oLlPJCkBv/k3Voadk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 690/877] f2fs: dirty directory inodes on mtime/ctime update
Date: Wed, 30 Sep 2026 17:26:41 +0200
Message-ID: <20260930152429.567201726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Joanne Chang <joannechien@google.com>

[ Upstream commit 9ec09d5f4b317a417c8655c14056f70cbe71eb6c ]

Xfstests generic/547 sometimes fail with mismatched directory metadata
before and after a power failure. This happens because when a directory
entry is added, renamed, or deleted, its mtime and ctime are updated and
the inode is marked dirty via
f2fs_mark_inode_dirty_sync(dir, sync=false). The sync=false flag means
the dirty inode is not added to the global DIRTY_META list. Therefore,
subsequent checkpoints skip flushing these updated directory blocks,
causing directory timestamps to revert to stale values after a sudden
power failure.

Address this by changing the dirtying parameter to sync=true during
directory entry mutations and renames. This forces F2FS to immediately
queue the updated directory blocks on the global DIRTY_META list,
ensuring timestamps are committed to checkpoints.

Fixes: 7c45729a4d6d ("f2fs: keep dirty inodes selectively for checkpoint")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Chang <joannechien@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Adjusted f2fs_set_link() context to retain f2fs_put_page(page, 1) instead of f2fs_folio_put(folio, true). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c    |    6 +++---
 fs/f2fs/inline.c |    2 +-
 fs/f2fs/namei.c  |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -437,7 +437,7 @@ void f2fs_set_link(struct inode *dir, st
 	set_page_dirty(page);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 	f2fs_put_page(page, 1);
 }
 
@@ -591,7 +591,7 @@ void f2fs_update_parent_metadata(struct
 		clear_inode_flag(inode, FI_NEW_INODE);
 	}
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (F2FS_I(dir)->i_current_depth != current_depth)
 		f2fs_i_depth_write(dir, current_depth);
@@ -903,7 +903,7 @@ void f2fs_delete_entry(struct f2fs_dir_e
 	f2fs_put_page(page, 1);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (inode)
 		f2fs_drop_nlink(dir, inode);
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -727,7 +727,7 @@ void f2fs_delete_inline_entry(struct f2f
 	f2fs_put_page(page, 1);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (inode)
 		f2fs_drop_nlink(dir, inode);
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1038,7 +1038,7 @@ static int f2fs_rename(struct mnt_idmap
 	f2fs_up_write(&F2FS_I(old_inode)->i_sem);
 
 	inode_set_ctime_current(old_inode);
-	f2fs_mark_inode_dirty_sync(old_inode, false);
+	f2fs_mark_inode_dirty_sync(old_inode, true);
 
 	f2fs_delete_entry(old_entry, old_page, old_dir, NULL);
 	old_page = NULL;
@@ -1207,7 +1207,7 @@ static int f2fs_cross_rename(struct inod
 		f2fs_i_links_write(old_dir, old_nlink > 0);
 		f2fs_up_write(&F2FS_I(old_dir)->i_sem);
 	}
-	f2fs_mark_inode_dirty_sync(old_dir, false);
+	f2fs_mark_inode_dirty_sync(old_dir, true);
 
 	/* update directory entry info of new dir inode */
 	f2fs_set_link(new_dir, new_entry, new_page, old_inode);
@@ -1226,7 +1226,7 @@ static int f2fs_cross_rename(struct inod
 		f2fs_i_links_write(new_dir, new_nlink > 0);
 		f2fs_up_write(&F2FS_I(new_dir)->i_sem);
 	}
-	f2fs_mark_inode_dirty_sync(new_dir, false);
+	f2fs_mark_inode_dirty_sync(new_dir, true);
 
 	if (F2FS_OPTION(sbi).fsync_mode == FSYNC_MODE_STRICT) {
 		f2fs_add_ino_entry(sbi, old_dir->i_ino, TRANS_DIR_INO);


