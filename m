Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6411B171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E419EC433EF;
	Mon, 22 May 2023 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782963;
	bh=sSpk2XXZd9W8UWKWR6cD13QqZ1B+caFcKSAYqktW8fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r03hu6GH2ok+gQ7Zo8PPOSFRn2MlTmplHmUKGv0HhPDwnKr76fLEFwHnuWkeGD99H
	 lrHZQY4g5cS2W96jyWGUxLhwx4l62zcWu4jLwe0EXqiPf4J/wLpk0jFmW5dt7nSqcA
	 muYTfU8G6u8tzR1ZpZVhDApygKFbIujzAtKDfyCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/203] f2fs: fix to drop all dirty pages during umount() if cp_error is set
Date: Mon, 22 May 2023 20:08:08 +0100
Message-Id: <20230522190356.764284737@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit c9b3649a934d131151111354bcbb638076f03a30 ]

xfstest generic/361 reports a bug as below:

f2fs_bug_on(sbi, sbi->fsync_node_num);

kernel BUG at fs/f2fs/super.c:1627!
RIP: 0010:f2fs_put_super+0x3a8/0x3b0
Call Trace:
 generic_shutdown_super+0x8c/0x1b0
 kill_block_super+0x2b/0x60
 kill_f2fs_super+0x87/0x110
 deactivate_locked_super+0x39/0x80
 deactivate_super+0x46/0x50
 cleanup_mnt+0x109/0x170
 __cleanup_mnt+0x16/0x20
 task_work_run+0x65/0xa0
 exit_to_user_mode_prepare+0x175/0x190
 syscall_exit_to_user_mode+0x25/0x50
 do_syscall_64+0x4c/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

During umount(), if cp_error is set, f2fs_wait_on_all_pages() should
not stop waiting all F2FS_WB_CP_DATA pages to be writebacked, otherwise,
fsync_node_num can be non-zero after f2fs_wait_on_all_pages() causing
this bug.

In this case, to avoid deadloop in f2fs_wait_on_all_pages(), it needs
to drop all dirty pages rather than redirtying them.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 12 ++++++++++--
 fs/f2fs/data.c       |  3 ++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index c68f1f8000f17..d6ae6de35af20 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -312,8 +312,15 @@ static int __f2fs_write_meta_page(struct page *page,
 
 	trace_f2fs_writepage(page, META);
 
-	if (unlikely(f2fs_cp_error(sbi)))
+	if (unlikely(f2fs_cp_error(sbi))) {
+		if (is_sbi_flag_set(sbi, SBI_IS_CLOSE)) {
+			ClearPageUptodate(page);
+			dec_page_count(sbi, F2FS_DIRTY_META);
+			unlock_page(page);
+			return 0;
+		}
 		goto redirty_out;
+	}
 	if (unlikely(is_sbi_flag_set(sbi, SBI_POR_DOING)))
 		goto redirty_out;
 	if (wbc->for_reclaim && page->index < GET_SUM_BLOCK(sbi, 0))
@@ -1298,7 +1305,8 @@ void f2fs_wait_on_all_pages(struct f2fs_sb_info *sbi, int type)
 		if (!get_pages(sbi, type))
 			break;
 
-		if (unlikely(f2fs_cp_error(sbi)))
+		if (unlikely(f2fs_cp_error(sbi) &&
+			!is_sbi_flag_set(sbi, SBI_IS_CLOSE)))
 			break;
 
 		if (type == F2FS_DIRTY_META)
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d38bffe28b034..3956852ad1de0 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2764,7 +2764,8 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 		 * don't drop any dirty dentry pages for keeping lastest
 		 * directory structure.
 		 */
-		if (S_ISDIR(inode->i_mode))
+		if (S_ISDIR(inode->i_mode) &&
+				!is_sbi_flag_set(sbi, SBI_IS_CLOSE))
 			goto redirty_out;
 		goto out;
 	}
-- 
2.39.2



