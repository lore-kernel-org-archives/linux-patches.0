Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2220441BA94;
	Sat, 12 Sep 2026 10:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208016; cv=none; b=tdsoCFIlmmwySUjGv2Za8Dbr31O9raxX++UT4mwp8ahFEpsIwHZDcJ2tvKXh+dXs40JAvaRJVzf320a7zlIkeI3tGLG2a+14Db1xNd7hOuCB8DbnXNmSrPSvC03gP/N5mMZPs3z1GnAelJ7Q6gvpu2XaQoWyoSbG3kvbFyQoRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208016; c=relaxed/simple;
	bh=Pw/Wx8zk96vLveXQmLpP4YVmzwXM1L8koihlc7+kXfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyD0cde6PHQ2SIAQcmvBKJYqtKe8JgtQQQPBpRNy3Awa5SOkGYnsqxErIVlTeCSa6vTsy8kWJvROdmImkgCPPqtS3epauKr7eyH8MeTJ7ghZ7i/hp7bhvk4RM1HRKU9Bj7hcGO3b0zVLXNs7qnFOt/jdN7G17wbdb2HIsMWBGn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkl/V3DX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkl/V3DX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEC01F000FF;
	Sat, 12 Sep 2026 10:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208015;
	bh=hzX1Q4T7XxFLuPxBvzg8abEku/c1XBZ9v2kK2fkZIqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xkl/V3DXgu5AIBlaT7dYNzXXbGLOhUYjfOOhKgnFK88wp0QgZvA305s/SxPSPsigk
	 VYZQjYmgUf564lJoeCpG2CUaAC6rEvvyZyh/LuSXFtn5KQ+jXaKs+JPIwC7xjbn+RW
	 ONeMbjwdxr1vT6fkOPM+/pqs5qHI/x14h8hzF9jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com,
	Yao Kai <yaokai34@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0531/1518] ext4: validate readdir offset before accessing dirent
Date: Sat, 12 Sep 2026 08:45:00 +0200
Message-ID: <20260912065635.457040201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Yao Kai <yaokai34@huawei.com>

[ Upstream commit bc4b7b0414c33b2c8898eb04386df0d21a13dad8 ]

A corrupted directory can trigger the following KASAN report when
ext4_readdir() resumes from an invalid position:

  BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x5ef/0x820
  Read of size 2 at addr ffff88810a646000 by task repro_linear/509

  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   kasan_report+0xce/0x100
   __ext4_check_dir_entry+0x5ef/0x820
   ext4_readdir+0xcde/0x2b70
   iterate_dir+0x1a1/0x520
   __x64_sys_getdents64+0x12b/0x220
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

KASAN reports use-after-free because the out-of-bounds access lands in an
adjacent freed page. The directory buffer itself is still referenced.

ext4_dir_llseek() invalidates the directory cookie so that ext4_readdir()
rescans directory entries from the start of the block. The rescan checks
only the lower bound of rec_len before advancing. A corrupted rec_len can
therefore place the offset where the block has insufficient space for a
complete directory entry. The rescan itself may dereference that truncated
entry, or the main loop may pass it to __ext4_check_dir_entry(). The latter
reads de->rec_len before validating the range. For example:

  block offset  0                           4092  4096
                |---- de1.rec_len = 4092 -----|----|
                                               de2.inode
                                                    | de2.rec_len
                                                    ^ OOB, reported as UAF

de2 starts at offset 4092 in this 4 KiB block. Its four-byte inode fits in
the block, but its rec_len starts at offset 4096 and crosses the boundary.

The minimum safe length is inode-dependent. Encrypted and casefolded
directory entries need eight additional hash bytes, while a valid metadata
checksum tail is only 12 bytes.

Cache the metadata checksum feature state and derive the minimum directory
entry length from the on-disk format. Use it to bound both the rescan and
the offset passed to the main loop. Report an offset in a truncated block
tail and skip the remainder of the block, while continuing to accept an
offset exactly at the block boundary.

Reported-by: syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5322c5c260eb44d209ed
Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Signed-off-by: Yao Kai <yaokai34@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260706041313.708346-1-yaokai34@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/dir.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d4164c507a907..290a9aeac15f1 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -137,6 +137,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	struct buffer_head *bh = NULL;
 	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
 	struct dir_private_info *info = file->private_data;
+	bool has_csum = ext4_has_feature_metadata_csum(sb);
 
 	err = fscrypt_prepare_readdir(inode);
 	if (err)
@@ -148,7 +149,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			return err;
 
 		/* Can we just clear INDEX flag to ignore htree information? */
-		if (!ext4_has_feature_metadata_csum(sb)) {
+		if (!has_csum) {
 			/*
 			 * We don't set the inode dirty flag since it's not
 			 * critical that it gets flushed back to the disk.
@@ -234,7 +235,10 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, info->cookie)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0;
+			     i <= sb->s_blocksize -
+				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
+			     i < offset;) {
 				de = (struct ext4_dir_entry_2 *)
 					(bh->b_data + i);
 				/* It's too expensive to do a full
@@ -256,6 +260,17 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			info->cookie = inode_query_iversion(inode);
 		}
 
+		if (unlikely(offset < sb->s_blocksize &&
+			     offset > sb->s_blocksize -
+			     ext4_dir_rec_len(1, has_csum ? NULL : inode))) {
+			EXT4_ERROR_FILE(file, bh->b_blocknr,
+					"bad entry in directory: %s - offset=%u, size=%lu",
+					"directory entry too close to block end",
+					offset, sb->s_blocksize);
+			ctx->pos = round_up(ctx->pos, sb->s_blocksize);
+			goto next_block;
+		}
+
 		while (ctx->pos < inode->i_size
 		       && offset < sb->s_blocksize) {
 			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);
@@ -311,6 +326,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			ctx->pos += ext4_rec_len_from_disk(de->rec_len,
 						sb->s_blocksize);
 		}
+next_block:
 		if ((ctx->pos < inode->i_size) && !dir_relax_shared(inode))
 			goto done;
 		brelse(bh);
-- 
2.53.0



