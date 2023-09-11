Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0751711710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5158AC433C8;
	Mon, 11 Sep 2023 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445804;
	bh=S4OWzz0lL1qfhHIGb2K/utBL1Q5pjLUg/ORTHnb9Mr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0DyvZ0t8CAjfCCSc4dwNTfpaRIocIH4bbn7CKxveh8fCtI6sGcEsiOOddMrGWKrE
	 PdsjjEYvsBh8zItUVMv79AZD4Z3Hm7rUlVAAVb1fWMshLq9flqTOcSjTS3Y+h3PnUe
	 RLnHexKGU4h+7CbHZOTeqW+pFtzNQThj7XzgmV6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+601018296973a481f302@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 477/600] Revert "f2fs: fix to do sanity check on extent cache correctly"
Date: Mon, 11 Sep 2023 15:48:30 +0200
Message-ID: <20230911134647.723045536@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 958ccbbf1ce716d77c7cfa79ace50a421c1eed73 ]

syzbot reports a f2fs bug as below:

UBSAN: array-index-out-of-bounds in fs/f2fs/f2fs.h:3275:19
index 1409 is out of range for type '__le32[923]' (aka 'unsigned int[923]')
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:217 [inline]
 __ubsan_handle_out_of_bounds+0x11c/0x150 lib/ubsan.c:348
 inline_data_addr fs/f2fs/f2fs.h:3275 [inline]
 __recover_inline_status fs/f2fs/inode.c:113 [inline]
 do_read_inode fs/f2fs/inode.c:480 [inline]
 f2fs_iget+0x4730/0x48b0 fs/f2fs/inode.c:604
 f2fs_fill_super+0x640e/0x80c0 fs/f2fs/super.c:4601
 mount_bdev+0x276/0x3b0 fs/super.c:1391
 legacy_get_tree+0xef/0x190 fs/fs_context.c:611
 vfs_get_tree+0x8c/0x270 fs/super.c:1519
 do_new_mount+0x28f/0xae0 fs/namespace.c:3335
 do_mount fs/namespace.c:3675 [inline]
 __do_sys_mount fs/namespace.c:3884 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3861
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The issue was bisected to:

commit d48a7b3a72f121655d95b5157c32c7d555e44c05
Author: Chao Yu <chao@kernel.org>
Date:   Mon Jan 9 03:49:20 2023 +0000

    f2fs: fix to do sanity check on extent cache correctly

The root cause is we applied both v1 and v2 of the patch, v2 is the right
fix, so it needs to revert v1 in order to fix reported issue.

v1:
commit d48a7b3a72f1 ("f2fs: fix to do sanity check on extent cache correctly")
https://lore.kernel.org/lkml/20230109034920.492914-1-chao@kernel.org/

v2:
commit 269d11948100 ("f2fs: fix to do sanity check on extent cache correctly")
https://lore.kernel.org/lkml/20230207134808.1827869-1-chao@kernel.org/

Reported-by: syzbot+601018296973a481f302@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/000000000000fcf0690600e4d04d@google.com/
Fixes: d48a7b3a72f1 ("f2fs: fix to do sanity check on extent cache correctly")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index aab3b8b3ab0a7..1fc7760499f10 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -397,6 +397,12 @@ static int do_read_inode(struct inode *inode)
 		fi->i_inline_xattr_size = 0;
 	}
 
+	if (!sanity_check_inode(inode, node_page)) {
+		f2fs_put_page(node_page, 1);
+		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
+		return -EFSCORRUPTED;
+	}
+
 	/* check data exist */
 	if (f2fs_has_inline_data(inode) && !f2fs_exist_data(inode))
 		__recover_inline_status(inode, node_page);
@@ -459,12 +465,6 @@ static int do_read_inode(struct inode *inode)
 	/* Need all the flag bits */
 	f2fs_init_read_extent_tree(inode, node_page);
 
-	if (!sanity_check_inode(inode, node_page)) {
-		f2fs_put_page(node_page, 1);
-		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
-		return -EFSCORRUPTED;
-	}
-
 	if (!sanity_check_extent_cache(inode)) {
 		f2fs_put_page(node_page, 1);
 		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
-- 
2.40.1



