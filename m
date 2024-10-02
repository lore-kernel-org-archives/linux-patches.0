Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DDE1D551;
	Wed,  2 Oct 2024 14:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880556; cv=none; b=oJ3vPx4vOzi/bP4xxV3aRPZphXWD3XfwGOPVVn6NtBkV/+x72kXdHVacQUa2z2Kaq4joVGVEvdZGfaapjcUTrUJoz89f+ZgcSssc62CXGhCzicgU5da8FMbBO6snajEqbG1/2LQWxHUOq+O3fP67ucf8x8XWR+GfFrQfBmi/3Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880556; c=relaxed/simple;
	bh=OmYjSKLkROlHOd6ms9uPlBRzNbHP0gr8XkwmFQVDvGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXkYxAjSHwv38Njhw3sI5dQSOBHT2TcnPwhU218zD5xF+TojS+IUewjddACAmpuDmUoKirH11aMgXeL+eOLhN+oxJqfiWJArtcZKrABG9KeXxtl7UcnJ17rsYNBkIovNrD1iBB2CR93Om/qZTwNRNJlxzTraJHhBiz6hjZUKY6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3navnQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3navnQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44414C4CEC2;
	Wed,  2 Oct 2024 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880556;
	bh=OmYjSKLkROlHOd6ms9uPlBRzNbHP0gr8XkwmFQVDvGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3navnQASyyicTlr5c+XLczoKHhXqEbVB/52m7W4XLzyJKcHvjWagnvHPKBBB8bDg
	 uhCdBKg9GWdElygMs6iE4mapcRBII5qa7f5YH1QELD4ZdMrGQ5xmkET/B5OGIXeA5M
	 +iBbXXUAJDdFiTNch1BlwlafLdT2CEJwpT7OUISU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 498/538] btrfs: update comment for struct btrfs_inode::lock
Date: Wed,  2 Oct 2024 15:02:17 +0200
Message-ID: <20241002125812.097411404@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 68539bd0e73b457f88a9d00cabb6533ec8582dc9 ]

Update the comment for the lock named "lock" in struct btrfs_inode because
it does not mention that the fields "delalloc_bytes", "defrag_bytes",
"csum_bytes", "outstanding_extents" and "disk_i_size" are also protected
by that lock.

Also add a comment on top of each field protected by this lock to mention
that the lock protects them.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7ee85f5515e8 ("btrfs: fix race setting file private on concurrent lseek using same fd")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index b75c7f5934780..e9a979d0a9585 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -82,8 +82,9 @@ struct btrfs_inode {
 	/*
 	 * Lock for counters and all fields used to determine if the inode is in
 	 * the log or not (last_trans, last_sub_trans, last_log_commit,
-	 * logged_trans), to access/update new_delalloc_bytes and to update the
-	 * VFS' inode number of bytes used.
+	 * logged_trans), to access/update delalloc_bytes, new_delalloc_bytes,
+	 * defrag_bytes, disk_i_size, outstanding_extents, csum_bytes and to
+	 * update the VFS' inode number of bytes used.
 	 */
 	spinlock_t lock;
 
@@ -106,7 +107,7 @@ struct btrfs_inode {
 	 * Counters to keep track of the number of extent item's we may use due
 	 * to delalloc and such.  outstanding_extents is the number of extent
 	 * items we think we'll end up using, and reserved_extents is the number
-	 * of extent items we've reserved metadata for.
+	 * of extent items we've reserved metadata for. Protected by 'lock'.
 	 */
 	unsigned outstanding_extents;
 
@@ -130,28 +131,31 @@ struct btrfs_inode {
 	u64 generation;
 
 	/*
-	 * transid of the trans_handle that last modified this inode
+	 * ID of the transaction handle that last modified this inode.
+	 * Protected by 'lock'.
 	 */
 	u64 last_trans;
 
 	/*
-	 * transid that last logged this inode
+	 * ID of the transaction that last logged this inode.
+	 * Protected by 'lock'.
 	 */
 	u64 logged_trans;
 
 	/*
-	 * log transid when this inode was last modified
+	 * Log transaction ID when this inode was last modified.
+	 * Protected by 'lock'.
 	 */
 	int last_sub_trans;
 
-	/* a local copy of root's last_log_commit */
+	/* A local copy of root's last_log_commit. Protected by 'lock'. */
 	int last_log_commit;
 
 	union {
 		/*
 		 * Total number of bytes pending delalloc, used by stat to
 		 * calculate the real block usage of the file. This is used
-		 * only for files.
+		 * only for files. Protected by 'lock'.
 		 */
 		u64 delalloc_bytes;
 		/*
@@ -169,7 +173,7 @@ struct btrfs_inode {
 		 * Total number of bytes pending delalloc that fall within a file
 		 * range that is either a hole or beyond EOF (and no prealloc extent
 		 * exists in the range). This is always <= delalloc_bytes and this
-		 * is used only for files.
+		 * is used only for files. Protected by 'lock'.
 		 */
 		u64 new_delalloc_bytes;
 		/*
@@ -180,15 +184,15 @@ struct btrfs_inode {
 	};
 
 	/*
-	 * total number of bytes pending defrag, used by stat to check whether
-	 * it needs COW.
+	 * Total number of bytes pending defrag, used by stat to check whether
+	 * it needs COW. Protected by 'lock'.
 	 */
 	u64 defrag_bytes;
 
 	/*
-	 * the size of the file stored in the metadata on disk.  data=ordered
+	 * The size of the file stored in the metadata on disk.  data=ordered
 	 * means the in-memory i_size might be larger than the size on disk
-	 * because not all the blocks are written yet.
+	 * because not all the blocks are written yet. Protected by 'lock'.
 	 */
 	u64 disk_i_size;
 
@@ -222,7 +226,7 @@ struct btrfs_inode {
 
 	/*
 	 * Number of bytes outstanding that are going to need csums.  This is
-	 * used in ENOSPC accounting.
+	 * used in ENOSPC accounting. Protected by 'lock'.
 	 */
 	u64 csum_bytes;
 
-- 
2.43.0



