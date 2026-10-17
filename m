Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC0936F90C;
	Sat, 17 Oct 2026 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255553; cv=none; b=SIuMzhabGBJxlgwektuZh0VC22KcbJTBw24AmLDsZYSx8qy4UYaSnCG+tcGSqJe6BXNINYjfJdLf3U8WQIx1NimCFqAbL56T8/dNrE3ysT6HN5VFNQE4GiXcCd7IiJ5COb1EJa4ho0Q4RpreA0vATuWCF8Eme6lidfaPKrw1e8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255553; c=relaxed/simple;
	bh=9ZqOjCGqWUVZ1a7E4y2jnzOWRPX4gvgtub18ctIQlqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6g0EosIS+wY8eig6XKXdu3fqZEPEc9ozQtl1oTTBby4e/zwNwzokToKX4X6Bdls05gKp/Nv+y8GgDb3B278we1xbJc+7XYoYAnLHZZ+K1APaHTARQUYyTgDzVkHRs3EXK9Y5HokRDi7bJtYobA2HiYrKi7NhVQUnu4Z2KiNPn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMxbwMFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMxbwMFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AB81F000C4;
	Sat, 17 Oct 2026 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255552;
	bh=pp9tU7nhTDmPhI7FsdUn+O9c21sJeijVo/Yni9+36E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMxbwMFSdKzG6su5iQi501xm9I/wIt5fFj3o0yux2cOggYLYlKyDJ49msaIbL43Wb
	 JE7hFGtVR8IFY+Un/jDBe40sRu5K4z1CTCvNImHguOQuozDQ0Js0sb4MVh10z9Dy7i
	 1OkITcQuY4RYUzFIkVBPNmkMGo5GW6/JyXNzgGD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 814/869] ocfs2: validate external xattr entries when reading metadata
Date: Sat, 17 Oct 2026 18:00:55 +0200
Message-ID: <20261017160057.761156476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 2cf82b46d5e43be0dfbaac7fa1073cec2fc1f5e6 ]

ocfs2_validate_xattr_block() checks the xattr block header before the
block reaches higher-level xattr users, but it does not verify that a
non-indexed block's xh_count and entry offsets fit inside the block.
Indexed buckets likewise reach list/get consumers after ECC without an
entry-bounds check.

Use the flat xattr entry validator for non-indexed external xattr blocks,
and use a bucket-specific validator for indexed buckets at metadata read
time.  The bucket validator keeps the entry array bounded by the first
bucket block while checking name/value offsets against the bucket block
they target.

Reject corrupted external xattr metadata before listxattr() or getxattr()
can walk out-of-range entry arrays or name/value offsets.

Validation reproduced this kernel report:
BUG: KASAN: use-after-free in ocfs2_xattr_list_entries+0xd7/0x190
Read of size 1 at addr ffff88810a654007 by task ocfs2_xattr_lis/630
Call Trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  kasan_report+0xe0/0x110
  ocfs2_xattr_list_entries+0xd7/0x190
  ocfs2_listxattr+0x3f6/0x610
  listxattr+0x90/0xe0
  path_listxattrat+0xed/0x220
  do_syscall_64+0x115/0x6a0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lore.kernel.org/20260705025311.3429854-3-zzzccc427@gmail.com
Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
Fixes: 0c044f0b24b9 ("ocfs2: Add xattr bucket iteration for large numbers of EAs")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: Codex:gpt-5.5
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1cad9a386705e..5c88f6f800852 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -386,6 +386,12 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	return rc;
 }
 
+static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
+					     struct ocfs2_xattr_header *xh,
+					     size_t region_size);
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno);
+
 /* Read the xattr bucket at xb_blkno */
 static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 				   u64 xb_blkno)
@@ -404,6 +410,8 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 		spin_unlock(&OCFS2_SB(bucket->bu_inode->i_sb)->osb_xattr_lock);
 		if (rc)
 			mlog_errno(rc);
+		else
+			rc = ocfs2_validate_xattr_bucket(bucket, xb_blkno);
 	}
 
 	if (rc)
@@ -505,6 +513,22 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 				   le32_to_cpu(xb->xb_fs_generation));
 	}
 
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		size_t region_offset =
+			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
+
+		if (bh->b_size < region_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr block %llu: block size %zu is too small\n",
+					   (unsigned long long)bh->b_blocknr,
+					   bh->b_size);
+
+		return ocfs2_validate_xattr_entries_flat(sb, bh->b_blocknr,
+							 &xb->xb_attrs.xb_header,
+							 bh->b_size -
+							 region_offset);
+	}
+
 	return 0;
 }
 
@@ -1071,6 +1095,79 @@ int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
 	return ocfs2_validate_xattr_entries_flat(sb, blkno, xh, inline_size);
 }
 
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno)
+{
+	struct super_block *sb = bucket->bu_inode->i_sb;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
+	size_t region_size = (size_t)sb->s_blocksize * bucket->bu_blocks;
+	size_t entries_limit = sb->s_blocksize;
+	size_t nv_limit = sb->s_blocksize;
+	size_t max_entries;
+	int i;
+
+	if (region_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: region size %zu is too small\n",
+				   (unsigned long long)blkno, region_size);
+
+	if (entries_limit < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: entries limit %zu is too small\n",
+				   (unsigned long long)blkno,
+				   entries_limit);
+
+	max_entries = (entries_limit - sizeof(*xh)) /
+		      sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries)
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: entry count %u exceeds maximum %zu\n",
+				   (unsigned long long)blkno,
+				   xattr_count, max_entries);
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
+		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
+		size_t block_off = name_offset >> sb->s_blocksize_bits;
+		size_t block_offset = name_offset % nv_limit;
+		size_t value_offset;
+
+		if (name_offset >= region_size || block_off >= bucket->bu_blocks)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d name is out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (xe->xe_name_len > nv_limit - block_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d name crosses block boundary\n",
+					   (unsigned long long)blkno, i);
+
+		value_offset = block_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (value_offset > nv_limit)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d value starts out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (ocfs2_xattr_is_local(xe)) {
+			if (le64_to_cpu(xe->xe_value_size) >
+			    nv_limit - value_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr bucket %llu: entry %d value is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+		} else if (sizeof(struct ocfs2_xattr_value_root) >
+			   nv_limit - value_offset) {
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d value root is out of bounds\n",
+					   (unsigned long long)blkno, i);
+		}
+	}
+
+	return 0;
+}
+
 int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 					 struct ocfs2_dinode *di)
 {
-- 
2.53.0



