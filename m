Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B6A79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557A5C433D2;
	Thu, 12 Jan 2023 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534118;
	bh=RXLpoS4LXWjEhZ39Yvz8QyhVpIfnbpkCklpANJQ2qqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdRsoQCeidIGgv7mgzdT4qleTMgEHdXHKNAHqbziLUOHfBQ013j+y0x7REtVqYt2f
	 wvlsrjpR9N0cCYLTlRAscUG7XuRNZ+ozlfnrGmMUdig5BXNKcLTTrC0jdupQOCZ33c
	 bZR54aowtPJ9Hu6EvWPgfVFaLVorHOv/fM1XNQnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 671/783] ext4: fix use-after-free in ext4_orphan_cleanup
Date: Thu, 12 Jan 2023 14:56:27 +0100
Message-Id: <20230112135555.450276464@linuxfoundation.org>
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

commit a71248b1accb2b42e4980afef4fa4a27fa0e36f5 upstream.

I caught a issue as follows:
==================================================================
 BUG: KASAN: use-after-free in __list_add_valid+0x28/0x1a0
 Read of size 8 at addr ffff88814b13f378 by task mount/710

 CPU: 1 PID: 710 Comm: mount Not tainted 6.1.0-rc3-next #370
 Call Trace:
  <TASK>
  dump_stack_lvl+0x73/0x9f
  print_report+0x25d/0x759
  kasan_report+0xc0/0x120
  __asan_load8+0x99/0x140
  __list_add_valid+0x28/0x1a0
  ext4_orphan_cleanup+0x564/0x9d0 [ext4]
  __ext4_fill_super+0x48e2/0x5300 [ext4]
  ext4_fill_super+0x19f/0x3a0 [ext4]
  get_tree_bdev+0x27b/0x450
  ext4_get_tree+0x19/0x30 [ext4]
  vfs_get_tree+0x49/0x150
  path_mount+0xaae/0x1350
  do_mount+0xe2/0x110
  __x64_sys_mount+0xf0/0x190
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  </TASK>
 [...]
==================================================================

Above issue may happen as follows:
-------------------------------------
ext4_fill_super
  ext4_orphan_cleanup
   --- loop1: assume last_orphan is 12 ---
    list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan)
    ext4_truncate --> return 0
      ext4_inode_attach_jinode --> return -ENOMEM
    iput(inode) --> free inode<12>
   --- loop2: last_orphan is still 12 ---
    list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
    // use inode<12> and trigger UAF

To solve this issue, we need to propagate the return value of
ext4_inode_attach_jinode() appropriately.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221102080633.1630225-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4285,7 +4285,8 @@ int ext4_truncate(struct inode *inode)
 
 	/* If we zero-out tail of the page, we have to create jinode for jbd2 */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1)) {
-		if (ext4_inode_attach_jinode(inode) < 0)
+		err = ext4_inode_attach_jinode(inode);
+		if (err)
 			goto out_trace;
 	}
 


