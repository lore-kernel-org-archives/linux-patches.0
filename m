Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CEB3F2101;
	Tue, 13 Oct 2026 12:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894182; cv=none; b=tGu3zOaXDxYoiwgnyNhiyDB2ysfmUa2jHgVjoE7+tdsl8Xj2Ry7ve2LMwLgBHPcRb93QIowQPRHxQ8Iu2JUJios0zzH3o5/H/29sUvkIt69ybriplxKcS14W7j+2VjH2wJnd07448G60HlHO/EjoUPGxr+SW5yPghvN84NOtnU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894182; c=relaxed/simple;
	bh=EbPWDrDHG3aX+gdWskCxWyIHp69FWfIHEA3vQCfo5Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk+XRQzIe7r0+BF72LG08KKr03VzR1bUubNnsDlBl+xNkvXfVmQ+6+giMNNSLSEth6Dzrsh3Wcun+j+POQruiHT4SgfUzWBNuo+qhINo39nfB+QeOSir7wq/zNfKYyIzyABJJOimFmi3slRRQmw6ChjXosQaLRbArqriM7A48LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9Z/moiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9Z/moiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829D61F000FF;
	Tue, 13 Oct 2026 12:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894180;
	bh=GSRl874Xq1ETfAdniQM6cV1U57S3NjRsCa/NAP3UM0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9Z/moiCWK7oNxXYinVLap3hdaJmlrMy2QHrqYcxDyfcAV3NMtcV0gfFJxJ2m9Dbd
	 GexDfZ6CCDTirMDK3OnwMd3wW2TAvrg1tv68yeQvV6PPaPj0j6jFsHsstrxxVzBr0c
	 SXPi4i3TQcMAeWKZM9mFKAt42SPybmkKzzCqYJI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Colin Ian King <colin.i.king@gmail.com>,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 473/621] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Tue, 13 Oct 2026 13:37:48 +0200
Message-ID: <20261013112932.058980699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

[ Upstream commit 03438084a7b8621fb5c762dd3d04cff5f2630fb2 ]

Syzbot/stress-ng reported an ABBA deadlock in ext4 when exercising
concurrent xattr workloads (using the ea_inode mount/format option).

The deadlock occurs between the running transaction and the eviction
thread:
- Task 1 (stress-ng): Holds a reference to a shared mbcache_entry (ce)
  and calls ext4_xattr_inode_cache_find() -> ext4_iget() to retrieve
  the corresponding EA inode. Since the EA inode is currently being
  evicted, ext4_iget() blocks in __wait_on_freeing_inode() waiting for
  eviction to complete.
- Task 2 (eviction thread): Currently evicting the same EA inode in
  ext4_evict_ea_inode(). It calls mb_cache_entry_wait_unused(oe) which
  blocks waiting for Task 1 to release the reference to the mbcache_entry.

To break this deadlock, implement a new ext4_iget() configuration flag
named EXT4_IGET_NOWAIT. When set, perform a non-blocking lookup of the
inode via VFS's find_inode_nowait() API.

If the inode is currently being evicted (marked with I_FREEING or
I_WILL_FREE) or created (I_CREATING), or if it is not present in the VFS
inode cache (cache miss), simply skip it (returning -ENOENT) rather than
waiting for eviction/creation to complete, breaking the ABBA cycle.

Since we return -ENOENT immediately on a cache miss, we never attempt to
allocate a new inode or call iget_locked(), completely eliminating any
TOCTOU race window.

If the returned inode is I_NEW, wait for its initialization to clear via
wait_on_new_inode(). If initialization fails and the inode is unhashed
during wait_on_new_inode() waking up (e.g., due to an I/O read error in
another thread), safely drop the reference and return -ENOENT. This
unhashed check is executed unconditionally on all cache-hit pathways to
properly handle concurrent initialization failures.

Finally, standard validation checks (including is_bad_inode,
EXT4_EA_INODE_FL, file_acl, and xattr flags) are executed as normal inside
check_igot_inode() to fully guarantee VFS-layer safety.

In ext4_xattr_inode_cache_find(), invoke ext4_iget() with the new
EXT4_IGET_NOWAIT flag to perform the non-blocking cache search.

Suggested-by: Jan Kara <jack@suse.cz>
Reported-by: Colin Ian King <colin.i.king@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Tested-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260626054821.1729-1-aditya.ansh182@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h  |  3 ++-
 fs/ext4/inode.c | 35 ++++++++++++++++++++++++++++++++---
 fs/ext4/xattr.c |  2 +-
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 996ffdc2dd13d..da6428312c36b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3081,7 +3081,8 @@ typedef enum {
 	EXT4_IGET_SPECIAL =	0x0001, /* OK to iget a system inode */
 	EXT4_IGET_HANDLE = 	0x0002,	/* Inode # is from a handle */
 	EXT4_IGET_BAD =		0x0004, /* Allow to iget a bad inode */
-	EXT4_IGET_EA_INODE =	0x0008	/* Inode should contain an EA value */
+	EXT4_IGET_EA_INODE =	0x0008,	/* Inode should contain an EA value */
+	EXT4_IGET_NOWAIT =	0x0010	/* Non-blocking lookup (skip if freeing) */
 } ext4_iget_flags;
 
 extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d2977c560c96b..bbc437be5e63b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5210,6 +5210,20 @@ void ext4_set_inode_mapping_order(struct inode *inode)
 				      EXT4_MAX_PAGECACHE_ORDER(inode));
 }
 
+static int ext4_iget_match(struct inode *inode, unsigned long ino, void *data)
+{
+	if (inode->i_ino != ino)
+		return 0;
+	spin_lock(&inode->i_lock);
+	if (inode->i_state & (I_FREEING | I_WILL_FREE | I_CREATING)) {
+		spin_unlock(&inode->i_lock);
+		return -1;
+	}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	return 1;
+}
+
 struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 			  ext4_iget_flags flags, const char *function,
 			  unsigned int line)
@@ -5238,9 +5252,24 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	inode = iget_locked(sb, ino);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (flags & EXT4_IGET_NOWAIT) {
+		inode = find_inode_nowait(sb, ino, ext4_iget_match, NULL);
+		if (!inode)
+			return ERR_PTR(-ENOENT);
+
+		if (inode->i_state & I_NEW)
+			wait_on_inode(inode);
+
+		if (unlikely(inode_unhashed(inode))) {
+			iput(inode);
+			return ERR_PTR(-ENOENT);
+		}
+	} else {
+		inode = iget_locked(sb, ino);
+		if (!inode)
+			return ERR_PTR(-ENOMEM);
+	}
+
 	if (!(inode->i_state & I_NEW)) {
 		ret = check_igot_inode(inode, flags, function, line);
 		if (ret) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 02095ca17be0f..789e7087a5490 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1550,7 +1550,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 
 	while (ce) {
 		ea_inode = ext4_iget(inode->i_sb, ce->e_value,
-				     EXT4_IGET_EA_INODE);
+				     EXT4_IGET_EA_INODE | EXT4_IGET_NOWAIT);
 		if (IS_ERR(ea_inode))
 			goto next_entry;
 		ext4_xattr_inode_set_class(ea_inode);
-- 
2.53.0



