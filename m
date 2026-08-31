Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD234A1DF2;
	Mon, 31 Aug 2026 13:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183709; cv=none; b=WFqREQ4ML/7tYjjSwfbgEWP2l1sDew87xtmyjDpwZbuNpKHTVt//FabZRVaV7dokqsRPE0J7jq/Xki9C+yYYOunTKN3hdWdtILP2/EblIjpb6oZIGYQF3RFu99GkbT0DUPG+U5eRBMqGvoG18f+N5hjxuqyj30CIh9zcF7DvogM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183709; c=relaxed/simple;
	bh=FG/fsIoIMMoS87wA4omvhuGwX5+3KG3AvvjTIOkTfwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWf/P2n4EnFsR//N+cT/pyjBsFVdiIHyRjFfVfNZdLSFLNc3zPtAqp2C1Zaxq8E3vLVeUrJqlS6kqRRQIO1DL4vAlIRDwPauaC4wsiAqUHvMwwBfT5Q45qVWXbcjTOxoUZ98oc0HeA8qA4LMR02Jrd/5/hw2TNf93P+cm5PCHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbDLhrvM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbDLhrvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615781F000E9;
	Mon, 31 Aug 2026 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183707;
	bh=p4s/Hnh5++Agj4t2D/GP7M4Zq1JtoNx/8SajR8m/QnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbDLhrvM/n47XyjayPs3Wa1gi96cSJ/HNmCSMljU2nWhhPlKwpliVTRlLRc9DsUA8
	 uvv3ejYmEm/JavKCXafIis/xF7Y8EZ34nY+wgRP1gYo6r+YKhgYEsf4vMpoadMNWC1
	 EiAxCYYbTCIsWLf1oeC7R+jFEQL4O4iaDeE6H0k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 16/76] ext4: track partial-zero outcome per edge in ext4_zero_partial_blocks()
Date: Mon, 31 Aug 2026 15:33:48 +0200
Message-ID: <20260831133400.033345640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 4c1f6931395ad026415cbdb924ffc240f86eb557 ]

Replace the single bool did_zero output of ext4_zero_partial_blocks()
with a bitmask that records which edge (start, end, or both in the
single-block case) was actually partial-zeroed. This allows callers to
distinguish which edges have been zeroed, preparing for unaligned
FALLOC_FL_WRITE_ZEROES handling in later patches.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-7-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a5179156ac1d ("ext4: zero out whole block for clean edges in WRITE_ZEROES")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h    |    5 ++++-
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |   36 ++++++++++++++++++++++++++++++------
 3 files changed, 35 insertions(+), 8 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3119,8 +3119,11 @@ extern int ext4_chunk_trans_extent(struc
 extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 				  int pextents);
 extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
+
+#define EXT4_PARTIAL_ZERO_START	0x1
+#define EXT4_PARTIAL_ZERO_END	0x2
 extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
-				    loff_t length, bool *did_zero);
+				    loff_t length, unsigned int *partial_zeroed);
 extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4777,7 +4777,7 @@ static long ext4_zero_range(struct file
 	loff_t align_start, align_end, new_size = 0;
 	loff_t end = offset + len;
 	unsigned int blocksize = i_blocksize(inode);
-	bool partial_zeroed = false;
+	unsigned int partial_zeroed = 0;
 	int ret, flags;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4254,13 +4254,26 @@ int ext4_block_zero_eof(struct inode *in
 	return 0;
 }
 
+/*
+ * Zero out the unaligned head and tail of the [lstart, lstart+length)
+ * range.
+ *
+ * On return, @partial_zeroed records which edges actually got
+ * partial-zeroed.  Set EXT4_PARTIAL_ZERO_START/EXT4_PARTIAL_ZERO_END if
+ * the head/tail block got actually partially zeroed (in written, dirty
+ * unwritten or delalloc state).  Cleared if the head/tail block is a
+ * hole or a clean unwritten block, in which case there is nothing that
+ * needs zeroing.  When the head and tail land in the same block, both
+ * bits are set together on a successful zeroing.
+ */
 int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length,
-			     bool *did_zero)
+			     unsigned int *partial_zeroed)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned partial_start, partial_end;
 	ext4_fsblk_t start, end;
 	loff_t byte_end = (lstart + length - 1);
+	bool did_zero = false;
 	int err = 0;
 
 	partial_start = lstart & (sb->s_blocksize - 1);
@@ -4272,21 +4285,32 @@ int ext4_zero_partial_blocks(struct inod
 	/* Handle partial zero within the single block */
 	if (start == end &&
 	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
-		err = ext4_block_zero_range(inode, lstart, length, did_zero,
+		err = ext4_block_zero_range(inode, lstart, length, &did_zero,
 					    NULL);
+		if (did_zero)
+			*partial_zeroed |= (EXT4_PARTIAL_ZERO_START |
+					    EXT4_PARTIAL_ZERO_END);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
 	if (partial_start) {
 		err = ext4_block_zero_range(inode, lstart, sb->s_blocksize,
-					    did_zero, NULL);
+					    &did_zero, NULL);
 		if (err)
 			return err;
+		if (did_zero)
+			*partial_zeroed |= EXT4_PARTIAL_ZERO_START;
 	}
 	/* Handle partial zero out on the end of the range */
-	if (partial_end != sb->s_blocksize - 1)
+	if (partial_end != sb->s_blocksize - 1) {
+		did_zero = false;
 		err = ext4_block_zero_range(inode, byte_end - partial_end,
-					    partial_end + 1, did_zero, NULL);
+					    partial_end + 1, &did_zero, NULL);
+		if (err)
+			return err;
+		if (did_zero)
+			*partial_zeroed |= EXT4_PARTIAL_ZERO_END;
+	}
 	return err;
 }
 
@@ -4435,7 +4459,7 @@ int ext4_punch_hole(struct file *file, l
 	loff_t end = offset + length;
 	handle_t *handle;
 	unsigned int credits;
-	bool partial_zeroed = false;
+	unsigned int partial_zeroed = 0;
 	int ret;
 
 	trace_ext4_punch_hole(inode, offset, length, 0);


