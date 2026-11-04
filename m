Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827147;
	b=Uz03GD9GJSywn8Is3TTo6YneziDxjlKKOPIR+oMEX2vjLRLkrq+PbiCPBpbOM1LIb0/u
	 JXMu+zNWpW0vflqvkTFryZxNLMIWna9dqThN492cMOlux+tDEHhr1SbewZ7cPl0PDBsKS
	 LaJVhej6uKwTsJZBdUB4A5jSwzCdDcy/TQcbJ3rB3mD5xsXXUgQeZ7Rtf5yh+N/lCKopd
	 dkg+hG/8kR08wn0W6kOsXfzKv7xb1e650wuTztOKk+hmBGhxUV0Zpu3BkhU4GLXCU7NZ9
	 cyBpPmMWMyWaAesnkbAdkc9AO1B9nAPTVtrbWV/yZ5RYIno/PiupQ2eZnD4iRtQYYSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OW/7EbxzIoJ5EEbKnwc+dgO8/AinioI1xaR5L47qe8E=;
	b=mAVNLEctBsBX2dPTCgaIV+WUiEr72jOw8vXblPazpDzUve+1xwLcAQtAgJGlc55hguwZ
	 GsNQYbTnf5eBaLgTSAO1pzcMOyIZ4DEzJGTBtfHeiV6ih7keb55A9TihuzafJeOfgA35y
	 +UoG4K/KwCKnXJ18O72NJ0CDtfNuom1hBl4eL8U4taMNxGue+kHmJPXNUZS5I5NuQ0POt
	 j08fjJJKrQ8L38VP+AQfcj+sszgSNEkEcFEwVb5pBSeaZGl/P2Jd+xILVv7+MnQ5uUB82
	 VRaFXlJd+92Pd3WPYNorHvhb647S36+fg8EXc85jhgD+9rl6hoS8ky+zFXpqsSQQ59w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LG4oVLso;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90408606AB39;
	Wed,  4 Nov 2026 21:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LG4oVLso
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC2B1F00919;
	Wed,  4 Nov 2026 21:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827147;
	bh=OW/7EbxzIoJ5EEbKnwc+dgO8/AinioI1xaR5L47qe8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LG4oVLsocftT1c/kx3C9GqVsDagn+aLOPgiFf83TC+LberWlf7SCT8BEFGAMMC0wD
	 MqA5xADVBFXOTUwFpoXY7QAK9VGG+KyyRkg3jjwSPLZLasHi4muBgMSOCXzNwQK6Z8
	 CNjbAXm62hdxtC/xz/2/DlPlnupC8TGFHqEyGgtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.3 215/547] fsverity: Set S_VERITY only after rollback is no longer possible
Date: Wed,  4 Nov 2026 16:06:39 -0500
Message-ID: <20261104211044.261570026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit c349b233d6ab0fc3517401a1e2d36f5f90eb8c9b upstream.

Commit f77f281b6118 ("fsverity: use a hashtable to find the
fsverity_info") changed the implementation of FS_IOC_ENABLE_VERITY to
make concurrent reads start going through fsverity verification slightly
earlier than they did before.

Instead of it happening when enable_verity() calls fsverity_set_info(),
it now happens when ->end_enable_verity() sets S_VERITY.

However, ext4 and btrfs can roll back verity after they set S_VERITY,
causing a use-after-free.

Fix that by making ext4 and btrfs set S_VERITY only after rollback is no
longer possible.  On failure, don't roll back S_VERITY, but do roll back
the filesystem-specific verity flag.

Also update enable_verity() to handle any future instances of this bug
more safely by warning and *not* freeing the fsverity_info.

Finally, tweak some comments.  Clarify one, and move information from
another to its proper place in the comment for ->end_enable_verity().

Fixes: f77f281b6118 ("fsverity: use a hashtable to find the fsverity_info")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261025204807.122875-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/verity.c        |    7 ++++---
 fs/ext4/verity.c         |    4 +++-
 fs/verity/enable.c       |   12 +++++-------
 include/linux/fsverity.h |   12 +++++++-----
 4 files changed, 19 insertions(+), 16 deletions(-)

--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -489,8 +489,6 @@ static int rollback_verity(struct btrfs_
 			inode->vfs_inode.i_ino);
 		goto out;
 	}
-	inode->ro_flags &= ~BTRFS_INODE_RO_VERITY;
-	btrfs_sync_inode_flags_to_i_flags(inode);
 	ret = btrfs_update_inode(trans, inode);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
@@ -555,16 +553,19 @@ static int finish_verity(struct btrfs_in
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 	inode->ro_flags |= BTRFS_INODE_RO_VERITY;
-	btrfs_sync_inode_flags_to_i_flags(inode);
 	ret = btrfs_update_inode(trans, inode);
 	if (ret)
 		goto end_trans;
 	ret = del_orphan(trans, inode);
 	if (ret)
 		goto end_trans;
+	/* Now that rollback is no longer possible, set S_VERITY. */
+	btrfs_sync_inode_flags_to_i_flags(inode);
 	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_set_fs_compat_ro(root->fs_info, VERITY);
 end_trans:
+	if (ret)
+		inode->ro_flags &= ~BTRFS_INODE_RO_VERITY;
 	btrfs_end_transaction(trans);
 	return ret;
 
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -242,17 +242,19 @@ static int ext4_end_enable_verity(struct
 		goto stop_and_cleanup;
 
 	ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
-	ext4_set_inode_flags(inode, false);
 	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (err)
 		goto stop_and_cleanup;
 
 	ext4_journal_stop(handle);
 
+	/* Now that rollback is no longer possible, set S_VERITY. */
+	ext4_set_inode_flags(inode, false);
 	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
 	return 0;
 
 stop_and_cleanup:
+	ext4_clear_inode_flag(inode, EXT4_INODE_VERITY);
 	ext4_journal_stop(handle);
 cleanup:
 	/*
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -274,8 +274,8 @@ static int enable_verity(struct file *fi
 	 * initialization so that we don't have to undo the enabling when memory
 	 * allocation for the hash table fails.  This is safe because looking up
 	 * the fsverity_info always first checks the S_VERITY flag on the inode,
-	 * which will only be set at the very end of the ->end_enable_verity
-	 * method.
+	 * which will only be set at the very end of a successful call to
+	 * ->end_enable_verity().
 	 */
 	err = fsverity_set_info(vi);
 	if (err) {
@@ -285,10 +285,7 @@ static int enable_verity(struct file *fi
 
 	/*
 	 * Tell the filesystem to finish enabling verity on the file.
-	 * Serialized with ->begin_enable_verity() by the inode lock.  The file
-	 * system needs to set the S_VERITY flag on the inode at the very end of
-	 * the method, at which point the fsverity information can be accessed
-	 * by other threads.
+	 * Serialized with ->begin_enable_verity() by the inode lock.
 	 */
 	inode_lock(inode);
 	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size);
@@ -296,7 +293,8 @@ static int enable_verity(struct file *fi
 	if (err) {
 		fsverity_err(inode, "%ps() failed with err %d",
 			     vops->end_enable_verity, err);
-		fsverity_remove_info(vi);
+		if (!WARN_ON_ONCE(IS_VERITY(inode)))
+			fsverity_remove_info(vi);
 	} else if (WARN_ON_ONCE(!IS_VERITY(inode))) {
 		fsverity_remove_info(vi);
 		err = -EINVAL;
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -54,11 +54,13 @@ struct fsverity_operations {
 	 * @merkle_tree_size: total bytes the Merkle tree took up
 	 *
 	 * If desc == NULL, then enabling verity failed and the filesystem only
-	 * must do any necessary cleanups.  Else, it must also store the given
-	 * verity descriptor to a fs-specific location associated with the inode
-	 * and do any fs-specific actions needed to mark the inode as a verity
-	 * inode, e.g. setting a bit in the on-disk inode.  The filesystem is
-	 * also responsible for setting the S_VERITY flag in the VFS inode.
+	 * must do any necessary cleanups.
+	 *
+	 * Else, the filesystem must store the given verity descriptor to a
+	 * fs-specific location associated with the inode and do any fs-specific
+	 * actions needed to mark the inode as a verity inode, e.g. set a bit in
+	 * the on-disk inode.  Finally, on success (only when rollback is no
+	 * longer possible!) it must set S_VERITY in the VFS inode.
 	 *
 	 * i_rwsem is held for write, but it may have been dropped between
 	 * ->begin_enable_verity() and ->end_enable_verity().


