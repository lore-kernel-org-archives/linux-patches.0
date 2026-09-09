Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4238562600;
	Wed,  9 Sep 2026 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962904; cv=none; b=Ua7S2Swj9S0AeaQ/Q/Xx2YLOOO4CS5aW4N/LDnwy/yec5jnvtsmG0tTDFMGTctlRCBr3N7d80itm+84M3BlpkHF//ehrEV1eR3FCi23XMjzMRiaGdjsgzjlLJ99iIwjygOkbYRSRCzPLPWl/yb6UBGNOmtoKP1MRFYMmXSAZhbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962904; c=relaxed/simple;
	bh=Y9WN+v2wIfutJS/epk1PFfuqbH0ND8pC6y/4/S9HM38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1aOILUnoiQBBSuxIftlFf0iAj4FW58/rlq6HcqklhERxLSz2atwIC3cS+DaIDSOkB1VyjjhFsEDzwNZIAlBbYK6/NqnPtHYY3jz9a+D7UFq9pdNBebh4BkVJCoRgU+2lt1zUHuVaNyGiAW25AEP0DIsMJ4ZhQGDrAn2qS69bdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxKlwgaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxKlwgaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595E51F00A3A;
	Wed,  9 Sep 2026 14:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962902;
	bh=t37k0XkI2bPAo16+8U2+1HXszVLemoCzUO8XdQ4zkzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxKlwgaCE1m25qbhxDMFal4mc1O96ht3w6Z4raF+45VW1fZYuWiYqz8yFHUFP96hK
	 fm8MRaUxc/RhK1kqyezl1dPkuX4ePLZ0yj1J8eH4VWVRApxKwys4IUUDsHnyvdYjSn
	 rZ4qCYbmtJVHihocKBNr1Yht+BDIDCwaNn1YNx1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 451/556] f2fs: dirty directory inodes on mtime/ctime update
Date: Wed,  9 Sep 2026 15:42:11 +0200
Message-ID: <20260909134246.447629132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Chang <joannechien@google.com>

commit 9ec09d5f4b317a417c8655c14056f70cbe71eb6c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c    |    6 +++---
 fs/f2fs/inline.c |    2 +-
 fs/f2fs/namei.c  |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -460,7 +460,7 @@ void f2fs_set_link(struct inode *dir, st
 	folio_mark_dirty(folio);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 	f2fs_folio_put(folio, true);
 }
 
@@ -615,7 +615,7 @@ void f2fs_update_parent_metadata(struct
 		clear_inode_flag(inode, FI_NEW_INODE);
 	}
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (F2FS_I(dir)->i_current_depth != current_depth)
 		f2fs_i_depth_write(dir, current_depth);
@@ -927,7 +927,7 @@ void f2fs_delete_entry(struct f2fs_dir_e
 	f2fs_folio_put(folio, true);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (inode)
 		f2fs_drop_nlink(dir, inode);
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -732,7 +732,7 @@ void f2fs_delete_inline_entry(struct f2f
 	f2fs_folio_put(folio, true);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (inode)
 		f2fs_drop_nlink(dir, inode);
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1077,7 +1077,7 @@ static int f2fs_rename(struct mnt_idmap
 	f2fs_up_write(&F2FS_I(old_inode)->i_sem);
 
 	inode_set_ctime_current(old_inode);
-	f2fs_mark_inode_dirty_sync(old_inode, false);
+	f2fs_mark_inode_dirty_sync(old_inode, true);
 
 	f2fs_delete_entry(old_entry, old_folio, old_dir, NULL);
 	old_folio = NULL;
@@ -1247,7 +1247,7 @@ static int f2fs_cross_rename(struct inod
 		f2fs_i_links_write(old_dir, old_nlink > 0);
 		f2fs_up_write(&F2FS_I(old_dir)->i_sem);
 	}
-	f2fs_mark_inode_dirty_sync(old_dir, false);
+	f2fs_mark_inode_dirty_sync(old_dir, true);
 
 	/* update directory entry info of new dir inode */
 	f2fs_set_link(new_dir, new_entry, new_folio, old_inode);
@@ -1266,7 +1266,7 @@ static int f2fs_cross_rename(struct inod
 		f2fs_i_links_write(new_dir, new_nlink > 0);
 		f2fs_up_write(&F2FS_I(new_dir)->i_sem);
 	}
-	f2fs_mark_inode_dirty_sync(new_dir, false);
+	f2fs_mark_inode_dirty_sync(new_dir, true);
 
 	if (F2FS_OPTION(sbi).fsync_mode == FSYNC_MODE_STRICT) {
 		f2fs_add_ino_entry(sbi, old_dir->i_ino, TRANS_DIR_INO);


