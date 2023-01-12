Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4E879C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B979DC433EF;
	Thu, 12 Jan 2023 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534056;
	bh=uqrmqpph4S2aZWEsxmLTKUjD+Ruk03RUMiY/iJnfsqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agMGm3putSkMhDXshUJ75jBI4EKKXGHhhcgtlQM2JE0FnLEVapGC8f+WKQ5Aw49Tt
	 y2rvM1qheX8dV2Gulpimhqtngv74YBvUnaHayBgZsDwpRUTBtyrybJeUGWodq5Momr
	 6GiRtNp3ZK1vl57PHrUNgzgsiVI8QeVK7VOlxGB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 681/783] ext4: fix corruption when online resizing a 1K bigalloc fs
Date: Thu, 12 Jan 2023 14:56:37 +0100
Message-Id: <20230112135555.897311598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baokun Li <libaokun1@huawei.com>

commit 0aeaa2559d6d53358fca3e3fce73807367adca74 upstream.

When a backup superblock is updated in update_backups(), the primary
superblock's offset in the group (that is, sbi->s_sbh->b_blocknr) is used
as the backup superblock's offset in its group. However, when the block
size is 1K and bigalloc is enabled, the two offsets are not equal. This
causes the backup group descriptors to be overwritten by the superblock
in update_backups(). Moreover, if meta_bg is enabled, the file system will
be corrupted because this feature uses backup group descriptors.

To solve this issue, we use a more accurate ext4_group_first_block_no() as
the offset of the backup superblock in its group.

Fixes: d77147ff443b ("ext4: add support for online resizing with bigalloc")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221117040341.1380702-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1545,8 +1545,8 @@ exit_journal:
 		int meta_bg = ext4_has_feature_meta_bg(sb);
 		sector_t old_gdb = 0;
 
-		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
-			       sizeof(struct ext4_super_block), 0);
+		update_backups(sb, ext4_group_first_block_no(sb, 0),
+			       (char *)es, sizeof(struct ext4_super_block), 0);
 		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
 
@@ -1753,7 +1753,7 @@ errout:
 		if (test_opt(sb, DEBUG))
 			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
 			       "blocks\n", ext4_blocks_count(es));
-		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr,
+		update_backups(sb, ext4_group_first_block_no(sb, 0),
 			       (char *)es, sizeof(struct ext4_super_block), 0);
 	}
 	return err;


