Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3B141A80
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yn7vwxCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C161C433C7;
	Wed, 15 Nov 2023 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076738;
	bh=dYwC4wQrc704SnDeZUYp6YFyrzEB1t6K9L4DRGfZpOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yn7vwxCSziGXGsx52W83mLQ+dv3OWpCPRxD4Zb3iYIBm1pqcggQkqSib4dsrYpoRW
	 zZwu8zlSnFCaCb2l51eHgQGv/zlTpMAfNHcF3tn1DTyrl2lZ1c0P52bsYK/nPgwBGd
	 ehDyyFXXnutbAtk2y/OOptwMD/kiNeK09i/d6m3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ebd7072191e2eddd7d6e@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 385/550] f2fs: fix to drop meta_inodes page cache in f2fs_put_super()
Date: Wed, 15 Nov 2023 14:16:09 -0500
Message-ID: <20231115191627.538138753@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit a4639380bbe66172df329f8b54aa7d2e943f0f64 ]

syzbot reports a kernel bug as below:

F2FS-fs (loop1): detect filesystem reference count leak during umount, type: 10, count: 1
kernel BUG at fs/f2fs/super.c:1639!
CPU: 0 PID: 15451 Comm: syz-executor.1 Not tainted 6.5.0-syzkaller-09338-ge0152e7481c6 #0
RIP: 0010:f2fs_put_super+0xce1/0xed0 fs/f2fs/super.c:1639
Call Trace:
 generic_shutdown_super+0x161/0x3c0 fs/super.c:693
 kill_block_super+0x3b/0x70 fs/super.c:1646
 kill_f2fs_super+0x2b7/0x3d0 fs/f2fs/super.c:4879
 deactivate_locked_super+0x9a/0x170 fs/super.c:481
 deactivate_super+0xde/0x100 fs/super.c:514
 cleanup_mnt+0x222/0x3d0 fs/namespace.c:1254
 task_work_run+0x14d/0x240 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x60 kernel/entry/common.c:296
 do_syscall_64+0x44/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

In f2fs_put_super(), it tries to do sanity check on dirty and IO
reference count of f2fs, once there is any reference count leak,
it will trigger panic.

The root case is, during f2fs_put_super(), if there is any IO error
in f2fs_wait_on_all_pages(), we missed to truncate meta_inode's page
cache later, result in panic, fix this case.

Fixes: 20872584b8c0 ("f2fs: fix to drop all dirty meta/node pages during umount()")
Reported-by: syzbot+ebd7072191e2eddd7d6e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/000000000000a14f020604a62a98@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 68895be6407f0..c03a73ff36e79 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1662,7 +1662,7 @@ static void f2fs_put_super(struct super_block *sb)
 
 	f2fs_wait_on_all_pages(sbi, F2FS_WB_CP_DATA);
 
-	if (err) {
+	if (err || f2fs_cp_error(sbi)) {
 		truncate_inode_pages_final(NODE_MAPPING(sbi));
 		truncate_inode_pages_final(META_MAPPING(sbi));
 	}
-- 
2.42.0



