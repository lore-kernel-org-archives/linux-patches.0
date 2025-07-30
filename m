Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B39277CBA;
	Wed, 30 Jul 2025 09:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868863; cv=none; b=p7lWNqdEVtXKr9pBUhDjLYA08x817aNp3teRcQkZnhDjQlTvBGNrNBekKKXNmahBvAGQHA9am03+bB41k+15Nezusbfo8lYHdml0LNdoRQldI+19YaeJlvesHmIzqLaD3aHFHD18Ast/U5PzyXKOZzTDyuEO4db2KDLpNK63X3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868863; c=relaxed/simple;
	bh=ojoqNfQlxoqSvfzFvuH8mnf2rPnaEK090CEjHHO5jN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCUlEAISpdjNvvJUycLUu+fkGZyJcxS3lNWMFj/Sd9oYriGOqynmwKzYde0n6NWCEd7/BIG3Q4XGUIxNEMEU1IznJg85Hq8e9p0sBlnksE8NBItb9MXl3G7qS33WFqTdeb/1qxrjmJM09CBnria1eJU+AmKC3uPKbOxgxyHh1gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5TVH3pH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5TVH3pH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE08EC4CEF5;
	Wed, 30 Jul 2025 09:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868863;
	bh=ojoqNfQlxoqSvfzFvuH8mnf2rPnaEK090CEjHHO5jN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5TVH3pH0TghudOnPM9GLePo3+AaWUt9ZFV6gmYjfOMgO37AK1ro2vvUvit4EgKyL
	 DHBGKgVBpD2LtYitcf7V98GBKCFx6apVJn5wCkDDulaS1ieYTXC/E9gZxDOB+Q9nIY
	 9Ad8bvXIYlC3ZZPsB+VOOJNf1AwiofQckXgyOjaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liebes Wang <wanghaichi0403@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/117] ext4: fix out of bounds punch offset
Date: Wed, 30 Jul 2025 11:36:04 +0200
Message-ID: <20250730093237.488116366@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit b5e58bcd79625423487fa3ecba8e8411b5396327 ]

Punching a hole with a start offset that exceeds max_end is not
permitted and will result in a negative length in the
truncate_inode_partial_folio() function while truncating the page cache,
potentially leading to undesirable consequences.

A simple reproducer:

  truncate -s 9895604649994 /mnt/foo
  xfs_io -c "pwrite 8796093022208 4096" /mnt/foo
  xfs_io -c "fpunch 8796093022213 25769803777" /mnt/foo

  kernel BUG at include/linux/highmem.h:275!
  Oops: invalid opcode: 0000 [#1] SMP PTI
  CPU: 3 UID: 0 PID: 710 Comm: xfs_io Not tainted 6.15.0-rc3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
  RIP: 0010:zero_user_segments.constprop.0+0xd7/0x110
  RSP: 0018:ffffc90001cf3b38 EFLAGS: 00010287
  RAX: 0000000000000005 RBX: ffffea0001485e40 RCX: 0000000000001000
  RDX: 000000000040b000 RSI: 0000000000000005 RDI: 000000000040b000
  RBP: 000000000040affb R08: ffff888000000000 R09: ffffea0000000000
  R10: 0000000000000003 R11: 00000000fffc7fc5 R12: 0000000000000005
  R13: 000000000040affb R14: ffffea0001485e40 R15: ffff888031cd3000
  FS:  00007f4f63d0b780(0000) GS:ffff8880d337d000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000000001ae0b038 CR3: 00000000536aa000 CR4: 00000000000006f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   truncate_inode_partial_folio+0x3dd/0x620
   truncate_inode_pages_range+0x226/0x720
   ? bdev_getblk+0x52/0x3e0
   ? ext4_get_group_desc+0x78/0x150
   ? crc32c_arch+0xfd/0x180
   ? __ext4_get_inode_loc+0x18c/0x840
   ? ext4_inode_csum+0x117/0x160
   ? jbd2_journal_dirty_metadata+0x61/0x390
   ? __ext4_handle_dirty_metadata+0xa0/0x2b0
   ? kmem_cache_free+0x90/0x5a0
   ? jbd2_journal_stop+0x1d5/0x550
   ? __ext4_journal_stop+0x49/0x100
   truncate_pagecache_range+0x50/0x80
   ext4_truncate_page_cache_block_range+0x57/0x3a0
   ext4_punch_hole+0x1fe/0x670
   ext4_fallocate+0x792/0x17d0
   ? __count_memcg_events+0x175/0x2a0
   vfs_fallocate+0x121/0x560
   ksys_fallocate+0x51/0xc0
   __x64_sys_fallocate+0x24/0x40
   x64_sys_call+0x18d2/0x4170
   do_syscall_64+0xa7/0x220
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix this by filtering out cases where the punching start offset exceeds
max_end.

Fixes: 982bf37da09d ("ext4: refactor ext4_punch_hole()")
Reported-by: Liebes Wang <wanghaichi0403@gmail.com>
Closes: https://lore.kernel.org/linux-ext4/ac3a58f6-e686-488b-a9ee-fc041024e43d@huawei.com/
Tested-by: Liebes Wang <wanghaichi0403@gmail.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250506012009.3896990-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4009,7 +4009,7 @@ int ext4_punch_hole(struct file *file, l
 		max_end = EXT4_SB(sb)->s_bitmap_maxbytes - sb->s_blocksize;
 
 	/* No need to punch hole beyond i_size */
-	if (offset >= inode->i_size)
+	if (offset >= inode->i_size || offset >= max_end)
 		return 0;
 
 	/*


