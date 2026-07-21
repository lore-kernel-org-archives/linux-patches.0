Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BBA402444;
	Tue, 21 Jul 2026 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654393; cv=none; b=ZKMJ3Vcgw+uDBvvZ+2Z0g7xDEpp0wGE07qkcbC9R95nlN06qX0Z2b8Wh6ZZIcpjUz4cnqfDVCkD7Vr/0THPAmBihVF9Do3TIvQVBTm5+1JJlOj5TRnIzLA0/q+JvuFfQ2DzqrHglVUskmLQvX+l0oRXuWe4HoqSB0yPiOw3SNEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654393; c=relaxed/simple;
	bh=Bm0O2+pEHzsfAwwDa2Kk6Q4v0nvjMiFKvcmeytBGrWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0zLpbBqUH6TdmXT2BqoqIz0g6CD5NHc5EGbEeFJ+xH3QuWiJb3uFFQTOlW4Lzv7K+kTVxUtUvM1UwSMW8qVGdL1MGBL//Fe7zvpqB0kkOOxoGdwXGQ4hgstMe4cSG7vLfw5N50MNjBD+GMjm+Lvk3CZx62gC1lNCbEBlySpewc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peH5o8mk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peH5o8mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B2F1F00A3A;
	Tue, 21 Jul 2026 17:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654391;
	bh=XiVpzRz7P71XAjYUVo6v3aj2KJKYfJlV059JtSIFMpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peH5o8mkVm9bUWxrJ4LxAIFFcjTjR0cRXkJmNtTE4TDAgqbmcPTuqv0C3Svqe1k2O
	 3TcbHc4hUVYlHSOpk9C35uq81NyhBII10Xb2vZRDIF7naWA1Mj6LGp1IcCLO5iIri3
	 QjeZ9xawTPnrerMD39JlX6WhQIA2yYMtfAV7rjI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	woot000 <woot000@woot000.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1687/2077] ntfs: validate index block header more strictly
Date: Tue, 21 Jul 2026 17:22:40 +0200
Message-ID: <20260721152632.543016693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 14bc34fe948523dc2b0174691f9af9e74eb4f3fd upstream.

Modify ntfs_index_block_inconsisent() to perform stricter validation of
INDEX_HEADER geometry in INDX blocks, and update
ntfs_lookup_inode_by_name() to use that function to validate INDX
blocks.

Cc: stable@vger.kernel.org # v7.1
Tested-by: woot000 <woot000@woot000.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/dir.c   |   38 +++-----------------
 fs/ntfs/index.c |  103 +++++++++++++++++++++++++++++++++++++++-----------------
 fs/ntfs/index.h |    3 +
 3 files changed, 82 insertions(+), 62 deletions(-)

--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -342,43 +342,19 @@ fast_descend_into_child_node:
 			dir_ni->mft_no);
 		goto unm_err_out;
 	}
-	/* Catch multi sector transfer fixup errors. */
-	if (unlikely(!ntfs_is_indx_record(ia->magic))) {
-		ntfs_error(sb,
-			"Directory index record with vcn 0x%llx is corrupt.  Corrupt inode 0x%llx.  Run chkdsk.",
-			vcn, dir_ni->mft_no);
-		goto unm_err_out;
-	}
-	if (le64_to_cpu(ia->index_block_vcn) != vcn) {
-		ntfs_error(sb,
-			"Actual VCN (0x%llx) of index buffer is different from expected VCN (0x%llx). Directory inode 0x%llx is corrupt or driver bug.",
-			le64_to_cpu(ia->index_block_vcn),
-			vcn, dir_ni->mft_no);
-		goto unm_err_out;
-	}
-	if (le32_to_cpu(ia->index.allocated_size) + 0x18 !=
-			dir_ni->itype.index.block_size) {
-		ntfs_error(sb,
-			"Index buffer (VCN 0x%llx) of directory inode 0x%llx has a size (%u) differing from the directory specified size (%u). Directory inode is corrupt or driver bug.",
-			vcn, dir_ni->mft_no,
-			le32_to_cpu(ia->index.allocated_size) + 0x18,
-			dir_ni->itype.index.block_size);
-		goto unm_err_out;
-	}
 	index_end = (u8 *)ia + dir_ni->itype.index.block_size;
 	if (index_end > kaddr + PAGE_SIZE) {
 		ntfs_error(sb,
-			"Index buffer (VCN 0x%llx) of directory inode 0x%llx crosses page boundary. Impossible! Cannot access! This is probably a bug in the driver.",
-			vcn, dir_ni->mft_no);
+			   "Index buffer (VCN 0x%llx) of directory inode 0x%llx crosses page boundary. Impossible! Cannot access! This is probably a bug in the driver.",
+			   vcn, dir_ni->mft_no);
 		goto unm_err_out;
 	}
-	index_end = (u8 *)&ia->index + le32_to_cpu(ia->index.index_length);
-	if (index_end > (u8 *)ia + dir_ni->itype.index.block_size) {
-		ntfs_error(sb,
-			"Size of index buffer (VCN 0x%llx) of directory inode 0x%llx exceeds maximum size.",
-			vcn, dir_ni->mft_no);
+	err = ntfs_index_block_inconsistent(vol, ia,
+					    dir_ni->itype.index.block_size,
+					    vcn, dir_ni->mft_no);
+	if (err)
 		goto unm_err_out;
-	}
+	index_end = (u8 *)&ia->index + le32_to_cpu(ia->index.index_length);
 	/* The first index entry. */
 	ie = (struct index_entry *)((u8 *)&ia->index +
 			le32_to_cpu(ia->index.entries_offset));
--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -306,6 +306,55 @@ static int ntfs_ie_end(struct index_entr
 	return ie->flags & INDEX_ENTRY_END || !ie->length;
 }
 
+static int ntfs_index_header_inconsistent(struct ntfs_volume *vol,
+					  const struct index_header *ih,
+					  u32 bytes_available, u64 inum)
+{
+	u32 entries_offset, index_length, allocated_size;
+
+	if (bytes_available < sizeof(struct index_header)) {
+		ntfs_error(vol->sb,
+			   "index block in inode %llu is smaller than an index header.",
+			   (unsigned long long)inum);
+		return -EIO;
+	}
+
+	entries_offset = le32_to_cpu(ih->entries_offset);
+	index_length = le32_to_cpu(ih->index_length);
+	allocated_size = le32_to_cpu(ih->allocated_size);
+
+	if (entries_offset < sizeof(struct index_header) ||
+	    entries_offset > bytes_available) {
+		ntfs_error(vol->sb,
+			   "Invalid index entry offset in inode %llu.",
+			   (unsigned long long)inum);
+		return -EIO;
+	}
+
+	if (index_length <= entries_offset) {
+		ntfs_error(vol->sb,
+			   "No space for index entries in inode %llu.",
+			   (unsigned long long)inum);
+		return -EIO;
+	}
+
+	if (allocated_size < index_length) {
+		ntfs_error(vol->sb,
+			   "Index entries overflow in inode %llu.",
+			   (unsigned long long)inum);
+		return -EIO;
+	}
+
+	if (allocated_size > bytes_available || index_length > bytes_available) {
+		ntfs_error(vol->sb,
+			   "Index entries in inode %llu exceed the available buffer.",
+			   (unsigned long long)inum);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /*
  *  Find the last entry in the index block
  */
@@ -440,7 +489,7 @@ static struct index_entry *ntfs_ie_dup_n
  * The size of block is assumed to have been checked to be what is
  * defined in the index root.
  *
- * Returns 0 if no error was found -1 otherwise (with errno unchanged)
+ * Returns 0 if no error was found, -EIO otherwise
  *
  * |<--->|  offsetof(struct index_block, index)
  * |     |<--->|  sizeof(struct index_header)
@@ -455,21 +504,20 @@ static struct index_entry *ntfs_ie_dup_n
  *
  * size(struct index_header) <= ent_offset < ind_length <= alloc_size < bk_size
  */
-static int ntfs_index_block_inconsistent(struct ntfs_index_context *icx,
-		struct index_block *ib, s64 vcn)
+int ntfs_index_block_inconsistent(struct ntfs_volume *vol,
+				  const struct index_block *ib,
+				  u32 block_size, s64 vcn, u64 inum)
 {
 	u32 ib_size = (unsigned int)le32_to_cpu(ib->index.allocated_size) +
 		offsetof(struct index_block, index);
-	struct super_block *sb = icx->idx_ni->vol->sb;
-	unsigned long long inum = icx->idx_ni->mft_no;
+	struct super_block *sb = vol->sb;
 
 	ntfs_debug("Entering\n");
 
 	if (!ntfs_is_indx_record(ib->magic)) {
-
 		ntfs_error(sb, "Corrupt index block signature: vcn %lld inode %llu\n",
-				vcn, (unsigned long long)icx->idx_ni->mft_no);
-		return -1;
+			   vcn, (unsigned long long)inum);
+		return -EIO;
 	}
 
 	if (le64_to_cpu(ib->index_block_vcn) != vcn) {
@@ -477,31 +525,22 @@ static int ntfs_index_block_inconsistent
 			"Corrupt index block: s64 (%lld) is different from expected s64 (%lld) in inode %llu\n",
 			(long long)le64_to_cpu(ib->index_block_vcn),
 			vcn, inum);
-		return -1;
+		return -EIO;
 	}
 
-	if (ib_size != icx->block_size) {
+	if (ib_size != block_size) {
 		ntfs_error(sb,
-			"Corrupt index block : s64 (%lld) of inode %llu has a size (%u) differing from the index specified size (%u)\n",
-			vcn, inum, ib_size, icx->block_size);
-		return -1;
-	}
-
-	if (le32_to_cpu(ib->index.entries_offset) < sizeof(struct index_header)) {
-		ntfs_error(sb, "Invalid index entry offset in inode %lld\n", inum);
-		return -1;
-	}
-	if (le32_to_cpu(ib->index.index_length) <=
-	    le32_to_cpu(ib->index.entries_offset)) {
-		ntfs_error(sb, "No space for index entries in inode %lld\n", inum);
-		return -1;
-	}
-	if (le32_to_cpu(ib->index.allocated_size) <
-	    le32_to_cpu(ib->index.index_length)) {
-		ntfs_error(sb, "Index entries overflow in inode %lld\n", inum);
-		return -1;
+			   "Corrupt index block : s64 (%lld) of inode %llu has a size (%u) differing from the index specified size (%u)\n",
+			   vcn, inum, ib_size, block_size);
+		return -EIO;
 	}
 
+	if (ntfs_index_header_inconsistent(vol, &ib->index,
+					   block_size -
+					   offsetof(struct index_block, index),
+					   inum))
+		return -EIO;
+
 	return 0;
 }
 
@@ -668,12 +707,14 @@ static int ntfs_ib_read(struct ntfs_inde
 		else
 			ntfs_error(icx->idx_ni->vol->sb,
 				"Failed to read full index block at %lld\n", pos);
-		return -1;
+		return -EIO;
 	}
 
 	post_read_mst_fixup((struct ntfs_record *)((u8 *)dst), icx->block_size);
-	if (ntfs_index_block_inconsistent(icx, dst, vcn))
-		return -1;
+	if (ntfs_index_block_inconsistent(icx->idx_ni->vol, dst,
+					  icx->block_size, vcn,
+					  icx->idx_ni->mft_no))
+		return -EIO;
 
 	return 0;
 }
--- a/fs/ntfs/index.h
+++ b/fs/ntfs/index.h
@@ -89,6 +89,9 @@ struct ntfs_index_context {
 	bool sync_write;
 };
 
+int ntfs_index_block_inconsistent(struct ntfs_volume *vol,
+				  const struct index_block *ib,
+				  u32 block_size, s64 vcn, u64 inum);
 int ntfs_index_entry_inconsistent(struct ntfs_index_context *icx, struct ntfs_volume *vol,
 		const struct index_entry *ie, __le32 collation_rule, u64 inum);
 struct ntfs_index_context *ntfs_index_ctx_get(struct ntfs_inode *ni, __le16 *name,


