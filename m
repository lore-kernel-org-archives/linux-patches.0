Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D266FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3CFC433F0;
	Mon, 16 Jan 2023 16:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886958;
	bh=hmg7EpuIU6hinpiw6IuetjGpXYWNLVFWWmVfdJsCejY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLgxM/oW5xAJCw4bweXjUu1OVAa00glB13au0Cg7sPkFaenAGvODwCvMjg77/45gH
	 xE+yuguhcKvAtdRXeFig6P8JOHOVusSSUAnfqcTlwvKa2Cj1x0WIL91lHZN7qQcr/m
	 0nkY33ed3/S9o/jBSk5BXU13UIIee/U9jGTMuRiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 627/658] ext4: fix use-after-free in ext4_orphan_cleanup
Date: Mon, 16 Jan 2023 16:51:55 +0100
Message-Id: <20230116154938.191260870@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit a71248b1accb2b42e4980afef4fa4a27fa0e36f5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5eb1d9ac269c..0830a4de47bc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4530,7 +4530,8 @@ int ext4_truncate(struct inode *inode)
 
 	/* If we zero-out tail of the page, we have to create jinode for jbd2 */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1)) {
-		if (ext4_inode_attach_jinode(inode) < 0)
+		err = ext4_inode_attach_jinode(inode);
+		if (err)
 			goto out_trace;
 	}
 
-- 
2.35.1



