Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF7519049B;
	Tue, 21 Jul 2026 17:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654417; cv=none; b=cIPbzMLXwQ+jdaOtqUD5xlj3mIlJGVb/sPYxMzVBPk09GXd32GCg+eINPZrFDkzhBY2pWz2xZHtXfo2ZCySvLozL3p+5Ftm+WuRQ8OlMuCUCFNb+SIvn4SlrzTKBMKmdwWIJNYG7EnXtCl5UdzX2oBxlZC3yEJ8+qU/ADVnnYpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654417; c=relaxed/simple;
	bh=boCdVFVgapYNb9j/PytxABwpnXzxdrDydqxyPyvWIdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Apu1+Go6ekZIJgkft6kjZhSVUALR/5X4+bRzqmRhN8aMCfsPMjV/sV85EFydofkj1tghdjB+S7eWZLM64MmN0HPf+C178Jg6Ubd8XqNm5yAy3h5+/PGzxyyquc+wKa7muIDDfyJNWoMyuuoMLolvbw8/3GQTNBTQTLZ+qHmQzKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ATciacE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ATciacE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055101F000E9;
	Tue, 21 Jul 2026 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654415;
	bh=PJ/v95BAo34trdz5Z23mKnN0ztdBzhhHdJwahMjABes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ATciacEb6MPr1whCKfbMTfKKE2df4XLbiXDWOSERhe/VUWO4IZ06yWc9BwGO3r6O
	 pYGYRQfe9SCz/DdnOn4pZxUwCIRLvezbsy2Sy1cGbTi1Hm6ElciSm3fETuhmkAN8If
	 rDLSTeamFVRWrwm+d73/f+0W+KWeHv7klPXG3J5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	woot000 <woot000@woot000.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1695/2077] ntfs: validate index entries on reading
Date: Tue, 21 Jul 2026 17:22:48 +0200
Message-ID: <20260721152632.737260454@linuxfoundation.org>
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

commit 2221b691d7b2e17f08153f95848dacaa5d87e21d upstream.

Validate index entries immediately after reading an index root or index
block from disk. This eliminates repeated checks in lookup and readdir,
and reduce the risk of missing checks in those paths.

Cc: stable@vger.kernel.org # v7.1
Tested-by: woot000 <woot000@woot000.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/dir.c   |   28 +-----------------
 fs/ntfs/index.c |   86 ++++++++++++++++++++++++++++++--------------------------
 fs/ntfs/index.h |    8 +++--
 fs/ntfs/inode.c |    8 +++--
 4 files changed, 61 insertions(+), 69 deletions(-)

--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -135,10 +135,6 @@ u64 ntfs_lookup_inode_by_name(struct ntf
 		/* Key length should not be zero if it is not last entry. */
 		if (!ie->key_length)
 			goto dir_err_out;
-		/* Check the consistency of an index entry */
-		if (ntfs_index_entry_inconsistent(NULL, vol, ie, COLLATION_FILE_NAME,
-				dir_ni->mft_no))
-			goto dir_err_out;
 		/*
 		 * We perform a case sensitive comparison and if that matches
 		 * we are done and return the mft reference of the inode (i.e.
@@ -351,7 +347,8 @@ fast_descend_into_child_node:
 	}
 	err = ntfs_index_block_inconsistent(vol, ia,
 					    dir_ni->itype.index.block_size,
-					    vcn, dir_ni->mft_no);
+					    vcn, COLLATION_FILE_NAME,
+					    dir_ni->mft_no);
 	if (err)
 		goto unm_err_out;
 	index_end = (u8 *)&ia->index + le32_to_cpu(ia->index.index_length);
@@ -364,15 +361,6 @@ fast_descend_into_child_node:
 	 * reach the last entry.
 	 */
 	for (;; ie = (struct index_entry *)((u8 *)ie + le16_to_cpu(ie->length))) {
-		/* Bounds checks. */
-		if ((u8 *)ie < (u8 *)ia ||
-		    (u8 *)ie + sizeof(struct index_entry_header) > index_end ||
-		    (u8 *)ie + sizeof(struct index_entry_header) + le16_to_cpu(ie->key_length) >
-				index_end || (u8 *)ie + le16_to_cpu(ie->length) > index_end) {
-			ntfs_error(sb, "Index entry out of bounds in directory inode 0x%llx.",
-					dir_ni->mft_no);
-			goto unm_err_out;
-		}
 		/*
 		 * The last entry cannot contain a name. It can however contain
 		 * a pointer to a child node in the B+tree so we just break out.
@@ -382,10 +370,6 @@ fast_descend_into_child_node:
 		/* Key length should not be zero if it is not last entry. */
 		if (!ie->key_length)
 			goto unm_err_out;
-		/* Check the consistency of an index entry */
-		if (ntfs_index_entry_inconsistent(NULL, vol, ie, COLLATION_FILE_NAME,
-				dir_ni->mft_no))
-			goto unm_err_out;
 		/*
 		 * We perform a case sensitive comparison and if that matches
 		 * we are done and return the mft reference of the inode (i.e.
@@ -868,6 +852,7 @@ static int ntfs_readdir(struct file *fil
 		ictx->vcn_size_bits = vol->cluster_size_bits;
 	else
 		ictx->vcn_size_bits = NTFS_BLOCK_SIZE_BITS;
+	ictx->cr = ir->collation_rule;
 
 	/* The first index entry. */
 	next = (struct index_entry *)((u8 *)&ir->index +
@@ -905,13 +890,6 @@ static int ntfs_readdir(struct file *fil
 		if (!next)
 			break;
 nextdir:
-		/* Check the consistency of an index entry */
-		if (ntfs_index_entry_inconsistent(ictx, vol, next, COLLATION_FILE_NAME,
-					ndir->mft_no)) {
-			err = -EIO;
-			goto out;
-		}
-
 		if (ie_pos < actor->pos) {
 			ie_pos += le16_to_cpu(next->length);
 			continue;
--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -28,41 +28,10 @@
  * length must have been checked beforehand to not overflow from the
  * index record.
  */
-int ntfs_index_entry_inconsistent(struct ntfs_index_context *icx,
-		struct ntfs_volume *vol, const struct index_entry *ie,
-		__le32 collation_rule, u64 inum)
-{
-	if (icx) {
-		struct index_header *ih;
-		u8 *ie_start, *ie_end;
-
-		if (icx->is_in_root)
-			ih = &icx->ir->index;
-		else
-			ih = &icx->ib->index;
-
-		if ((le32_to_cpu(ih->index_length) > le32_to_cpu(ih->allocated_size)) ||
-				(le32_to_cpu(ih->index_length) > icx->block_size)) {
-			ntfs_error(vol->sb, "%s Index entry(0x%p)'s length is too big.",
-					icx->is_in_root ? "Index root" : "Index block",
-					(u8 *)icx->entry);
-			return -EINVAL;
-		}
-
-		ie_start = (u8 *)ih + le32_to_cpu(ih->entries_offset);
-		ie_end = (u8 *)ih + le32_to_cpu(ih->index_length);
-
-		if (ie_start > (u8 *)ie ||
-		    ie_end <= (u8 *)ie + le16_to_cpu(ie->length) ||
-		    le16_to_cpu(ie->length) > le32_to_cpu(ih->allocated_size) ||
-		    le16_to_cpu(ie->length) > icx->block_size) {
-			ntfs_error(vol->sb, "Index entry(0x%p) is out of range from %s",
-					(u8 *)icx->entry,
-					icx->is_in_root ? "index root" : "index block");
-			return -EIO;
-		}
-	}
-
+static int ntfs_index_entry_inconsistent(const struct ntfs_volume *vol,
+					 const struct index_entry *ie,
+					 __le32 collation_rule, u64 inum)
+{
 	if (ie->key_length &&
 	    ((le16_to_cpu(ie->key_length) + offsetof(struct index_entry, key)) >
 	     le16_to_cpu(ie->length))) {
@@ -355,6 +324,44 @@ static int ntfs_index_header_inconsisten
 	return 0;
 }
 
+int ntfs_index_entries_inconsistent(const struct ntfs_volume *vol,
+				    const struct index_header *ih,
+				    __le32 collation_rule, u64 inum)
+{
+	struct index_entry *ie;
+	u8 *index_end = (u8 *)ih + le32_to_cpu(ih->index_length);
+
+	for (ie = ntfs_ie_get_first((struct index_header *)ih);
+	      ; ie = ntfs_ie_get_next(ie)) {
+		if ((u8 *)ie + sizeof(struct index_entry_header) > index_end ||
+		    (u8 *)ie + le16_to_cpu(ie->length) > index_end) {
+			ntfs_error(vol->sb,
+				   "Index entry out of bounds in inode %llu.",
+				   (unsigned long long)inum);
+			return -EIO;
+		}
+
+		if (le16_to_cpu(ie->length) < sizeof(struct index_entry_header)) {
+			ntfs_error(vol->sb,
+				   "Index etnry too small in inode %llu.",
+				   inum);
+			return -EIO;
+		}
+
+		if (ntfs_ie_end(ie))
+			break;
+
+		if (!ie->key_length)
+			return -EIO;
+
+		if (ntfs_index_entry_inconsistent(vol, ie,
+						  collation_rule, inum))
+			return -EIO;
+	}
+
+	return 0;
+}
+
 /*
  *  Find the last entry in the index block
  */
@@ -506,7 +513,8 @@ static struct index_entry *ntfs_ie_dup_n
  */
 int ntfs_index_block_inconsistent(struct ntfs_volume *vol,
 				  const struct index_block *ib,
-				  u32 block_size, s64 vcn, u64 inum)
+				  u32 block_size, s64 vcn, __le32 cr,
+				  u64 inum)
 {
 	u32 ib_size = (unsigned int)le32_to_cpu(ib->index.allocated_size) +
 		offsetof(struct index_block, index);
@@ -540,7 +548,8 @@ int ntfs_index_block_inconsistent(struct
 					   offsetof(struct index_block, index),
 					   inum))
 		return -EIO;
-
+	if (ntfs_index_entries_inconsistent(vol, &ib->index, cr, inum))
+		return -EIO;
 	return 0;
 }
 
@@ -730,10 +739,9 @@ static int ntfs_ib_read(struct ntfs_inde
 
 	post_read_mst_fixup((struct ntfs_record *)((u8 *)dst), icx->block_size);
 	if (ntfs_index_block_inconsistent(icx->idx_ni->vol, dst,
-					  icx->block_size, vcn,
+					  icx->block_size, vcn, icx->cr,
 					  icx->idx_ni->mft_no))
 		return -EIO;
-
 	return 0;
 }
 
--- a/fs/ntfs/index.h
+++ b/fs/ntfs/index.h
@@ -94,9 +94,11 @@ int ntfs_index_root_inconsistent(struct
 				 const struct index_root *ir, u64 inum);
 int ntfs_index_block_inconsistent(struct ntfs_volume *vol,
 				  const struct index_block *ib,
-				  u32 block_size, s64 vcn, u64 inum);
-int ntfs_index_entry_inconsistent(struct ntfs_index_context *icx, struct ntfs_volume *vol,
-		const struct index_entry *ie, __le32 collation_rule, u64 inum);
+				  u32 block_size, s64 vcn,
+				  __le32 cr, u64 inum);
+int ntfs_index_entries_inconsistent(const struct ntfs_volume *vol,
+				    const struct index_header *ih,
+				    __le32 collation_rule, u64 inum);
 struct ntfs_index_context *ntfs_index_ctx_get(struct ntfs_inode *ni, __le16 *name,
 		u32 name_len);
 void ntfs_index_ctx_put(struct ntfs_index_context *ictx);
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -945,7 +945,9 @@ view_index_meta:
 		}
 		ir = (struct index_root *)((u8 *)a +
 				le16_to_cpu(a->data.resident.value_offset));
-		if (ntfs_index_root_inconsistent(ni->vol, a, ir, ni->mft_no)) {
+		if (ntfs_index_root_inconsistent(ni->vol, a, ir, ni->mft_no) ||
+		    ntfs_index_entries_inconsistent(ni->vol, &ir->index,
+						    ir->collation_rule, ni->mft_no)) {
 			ntfs_error(vi->i_sb, "Directory index is corrupt.");
 			goto unm_err_out;
 		}
@@ -1538,7 +1540,9 @@ static int ntfs_read_locked_index_inode(
 	}
 
 	ir = (struct index_root *)((u8 *)a + le16_to_cpu(a->data.resident.value_offset));
-	if (ntfs_index_root_inconsistent(vol, a, ir, ni->mft_no)) {
+	if (ntfs_index_root_inconsistent(vol, a, ir, ni->mft_no) ||
+	    ntfs_index_entries_inconsistent(vol, &ir->index,
+					    ir->collation_rule, ni->mft_no)) {
 		ntfs_error(vi->i_sb, "Index is corrupt.");
 		goto unm_err_out;
 	}


