Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A731863D
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06120C433C8;
	Wed, 20 Sep 2023 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213899;
	bh=BK0vNPUrZ+ShkOOpCh0GN25B0XoWtD8Co32PHVQ4Xp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWDCGDcItQX7ytdRQc6Dx8sknq4LW8W4ZfUP2qLurH/8TpiueysMg50iPOEWzzLYk
	 jglzbpT1drASf6tpphnD7ZYxKUyNaKV5LjwwE861dGWF1pjdTCXmNbJQebTvk6p/Cn
	 9Wc1UnhKc05pxQdReczrljXgSUJsMZ6xgfA1LkJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+90a11e6b1e810785c6ff@syzkaller.appspotmail.com,
	Liu Shixin <liushixin2@huawei.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/110] jfs: fix invalid free of JFS_IP(ipimap)->i_imap in diUnmount
Date: Wed, 20 Sep 2023 13:31:37 +0200
Message-ID: <20230920112831.829644709@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Shixin via Jfs-discussion <jfs-discussion@lists.sourceforge.net>

[ Upstream commit 6e2bda2c192d0244b5a78b787ef20aa10cb319b7 ]

syzbot found an invalid-free in diUnmount:

BUG: KASAN: double-free in slab_free mm/slub.c:3661 [inline]
BUG: KASAN: double-free in __kmem_cache_free+0x71/0x110 mm/slub.c:3674
Free of addr ffff88806f410000 by task syz-executor131/3632

 CPU: 0 PID: 3632 Comm: syz-executor131 Not tainted 6.1.0-rc7-syzkaller-00012-gca57f02295f1 #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
 Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
  print_address_description+0x74/0x340 mm/kasan/report.c:284
  print_report+0x107/0x1f0 mm/kasan/report.c:395
  kasan_report_invalid_free+0xac/0xd0 mm/kasan/report.c:460
  ____kasan_slab_free+0xfb/0x120
  kasan_slab_free include/linux/kasan.h:177 [inline]
  slab_free_hook mm/slub.c:1724 [inline]
  slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1750
  slab_free mm/slub.c:3661 [inline]
  __kmem_cache_free+0x71/0x110 mm/slub.c:3674
  diUnmount+0xef/0x100 fs/jfs/jfs_imap.c:195
  jfs_umount+0x108/0x370 fs/jfs/jfs_umount.c:63
  jfs_put_super+0x86/0x190 fs/jfs/super.c:194
  generic_shutdown_super+0x130/0x310 fs/super.c:492
  kill_block_super+0x79/0xd0 fs/super.c:1428
  deactivate_locked_super+0xa7/0xf0 fs/super.c:332
  cleanup_mnt+0x494/0x520 fs/namespace.c:1186
  task_work_run+0x243/0x300 kernel/task_work.c:179
  exit_task_work include/linux/task_work.h:38 [inline]
  do_exit+0x664/0x2070 kernel/exit.c:820
  do_group_exit+0x1fd/0x2b0 kernel/exit.c:950
  __do_sys_exit_group kernel/exit.c:961 [inline]
  __se_sys_exit_group kernel/exit.c:959 [inline]
  __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:959
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[...]

JFS_IP(ipimap)->i_imap is not setting to NULL after free in diUnmount.
If jfs_remount() free JFS_IP(ipimap)->i_imap but then failed at diMount().
JFS_IP(ipimap)->i_imap will be freed once again.
Fix this problem by setting JFS_IP(ipimap)->i_imap to NULL after free.

Reported-by: syzbot+90a11e6b1e810785c6ff@syzkaller.appspotmail.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_imap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 799d3837e7c2b..4899663996d81 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -193,6 +193,7 @@ int diUnmount(struct inode *ipimap, int mounterror)
 	 * free in-memory control structure
 	 */
 	kfree(imap);
+	JFS_IP(ipimap)->i_imap = NULL;
 
 	return (0);
 }
-- 
2.40.1



