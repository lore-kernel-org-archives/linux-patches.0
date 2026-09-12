Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB465416124;
	Sat, 12 Sep 2026 08:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202339; cv=none; b=nbAWcOXrQCOsWxxI6UrTmcdWGjOZMqMNbN4fghAwpOHdM5mmX7ky75Ys8pZXVVtdu1A/Yz3+KxD7IYK68g198afLMqRjPKLFKzVhPmuNydiFN2JyUxKJ89wKyt+mDaCILSPXTIEYllPW6yphjEfPP+qL0372SMlW4EXBkrpugn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202339; c=relaxed/simple;
	bh=5200VMIsqmIQTqrFLQIwlBjAh43eFUwfUgphYeS/6IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8VKXuK8m44rlRd7n8WfWG3insYvlaRG7GN0mxrVHB1c9WzOinIEjsZiC6yKHD9mRpDqF4oyVDR0O2XkGIAgzwVtbzdyOL4jcVkc+K7OVFepQFlaPcxF6tFSt9H7RlmUXfamfeuhGBCls4qpX3fSKR+TxXLaNATKNWiubeTHf38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFNWy9Up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFNWy9Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F52F1F000FF;
	Sat, 12 Sep 2026 08:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202337;
	bh=HAzZ/e1o/OhMucD3Cf2kz00gLZNURbD03JfJRuPR+4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFNWy9Ups2HRn6iyZ1FJ6Ar+pJK0LJB07qr+IiE85pTsYkzlRDraukeOl1t8qL7fS
	 cmyzkquI3z+ZsN86L3UkYKLea5nWOgiByyBkIl/Ll/0HDcpKiIHfdImw3tJyFtxYl3
	 fWyEfiAreiaIPMdir0n1O9yxt2z54g4Ns0suvlgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1180/1815] ext4: teach ext4_meta_trans_blocks() about number of allocated extents
Date: Sat, 12 Sep 2026 08:48:50 +0200
Message-ID: <20260912065716.716889250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 25b2a7e8d420c49fc46f25b6f953603e4dae1dbf ]

So far ext4_meta_trans_blocks() expects that each extent counted in
@pextents will be allocated in the transaction we estimate credits for.
This is correct for the use in ext4_chunk_trans_blocks() and
ext4_chunk_trans_extent() however the use in atomic write path
(ext4_convert_unwritten_extents_atomic() and ext4_iomap_alloc() for
IOMAP_ATOMIC) unnecessarily overestimates the number of necessary
credits as neither of them allocates any data. Add argument to
ext4_meta_trans_blocks() for number of extents that are going to be
allocated in the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260805153605.166545-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 46e8e31771f4 ("ext4: fix transaction overflow during writeback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/extents.c |  2 +-
 fs/ext4/inode.c   | 30 +++++++++++++++---------------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8bf6272c485dc..ed4241797ae34 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3186,7 +3186,7 @@ extern int ext4_normal_submit_inode_data_buffers(struct jbd2_inode *jinode);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
 extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
-				  int pextents);
+				  int pextents, int alloc_extents);
 extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
 extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
 				    loff_t length, bool *did_zero);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91c97af64b317..44ab246a31762 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4976,7 +4976,7 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
 		 * it can tell if the extent in the cache is a split extent.
 		 * But for now let's assume pextents as 2 always.
 		 */
-		credits = ext4_meta_trans_blocks(inode, max_blocks, 2);
+		credits = ext4_meta_trans_blocks(inode, max_blocks, 2, 0);
 	}
 
 	if (credits) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1ce10bbdcfabf..334d018766982 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3709,8 +3709,8 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
 			return ret;
 		if (map->m_len < orig_mlen) {
 			map->m_len = orig_mlen;
-			dio_credits = ext4_meta_trans_blocks(inode, orig_mlen,
-							     map->m_len);
+			dio_credits = ext4_meta_trans_blocks(inode, map->m_len,
+							     map->m_len, 0);
 		} else {
 			dio_credits = ext4_chunk_trans_blocks(inode,
 							      map->m_len);
@@ -6359,17 +6359,17 @@ static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
 }
 
 /*
- * Account for index blocks, block groups bitmaps and block group
- * descriptor blocks if modify datablocks and index blocks
- * worse case, the indexs blocks spread over different block groups
- *
- * If datablocks are discontiguous, they are possible to spread over
- * different block groups too. If they are contiguous, with flexbg,
- * they could still across block group boundary.
- *
- * Also account for superblock, inode, quota and xattr blocks
+ * Calculate number of credits needed in a transaction to:
+ *   * Allocate data blocks from @alloc_extents different groups - note that
+ *     with flexbg a single physical extent can span multiple groups but
+ *     single mballoc request only returns extent within one group.
+ *   * Allocate metatadata (extent tree blocks, indirect blocks) to store
+ *     pointers to @pextents data extents having @lblocks in total.
+ *   * Modify extent tree / indirect block tree, inode, superblock, quota
+ *     tracking, xattr blocks
  */
-int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
+int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents,
+			   int alloc_extents)
 {
 	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
 	int gdpblocks;
@@ -6386,7 +6386,7 @@ int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
 	 * Now let's see how many group bitmaps and group descriptors need
 	 * to account
 	 */
-	groups = idxblocks + pextents;
+	groups = idxblocks + alloc_extents;
 	gdpblocks = groups;
 	if (groups > ngroups)
 		groups = ngroups;
@@ -6412,7 +6412,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
 {
 	int ret;
 
-	ret = ext4_meta_trans_blocks(inode, nrblocks, 1);
+	ret = ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
 	/* Account for data blocks for journalled mode */
 	if (ext4_should_journal_data(inode))
 		ret += nrblocks;
@@ -6430,7 +6430,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
  */
 int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
 {
-	return ext4_meta_trans_blocks(inode, nrblocks, 1);
+	return ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
 }
 
 /*
-- 
2.53.0



