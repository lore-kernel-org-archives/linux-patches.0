Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA992144C1;
	Wed,  7 May 2025 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644316; cv=none; b=sMGhjQ5TZC8dKeazTIOF9QYF+1Wh0tkfeKtSdcLepYbNTEc5EWitnaHGiXH9p6dU57jhLmU2Jfoytzm6nhvGgPun+psAjw+CqF5DLHy/YRg9cJLWyesSWDjExlVIiddZ7BFBApzXJ7rFN5P6dUWHtsNQhGbTihuBfsV/wXCu0CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644316; c=relaxed/simple;
	bh=eN6mUbaj0eUyJtQcWeRL54ZXrMwnlmlzPdKAfKktX+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avnNEZzXhSgIFhDI+6z+P+bnSb+40qJOAijV27gsKeUPkPDkvJTSGYbixobShhEOMs6t0GEwEzyXO6SjjnY/Y8a1uonL4WvJJlpq+ZuXmwYAI6dNwzBVPUiiE+Vqws7jp4gWtDEdZKc18CPwjZcQ0/Sl8bpdnqTWNt+M9mSc7bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9d3f5Q6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9d3f5Q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809C2C4CEE2;
	Wed,  7 May 2025 18:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644316;
	bh=eN6mUbaj0eUyJtQcWeRL54ZXrMwnlmlzPdKAfKktX+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9d3f5Q6gxH6v11C9TI23IzKWhiakTKeTuIPYS/JK4L0/QmMaU7TqvrSNgwNav4ps
	 wkhgujZUpu5XLMurqgQfTDgK7rTWH2sUc7cdozgYl6SeqSa1P4LAD1IXt5vkSQQ4Pp
	 UHiF17jyWyIKBFgw3FX73kKemHGFVLow+byjb2WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Penglei Jiang <superman.xpt@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 180/183] btrfs: fix the inode leak in btrfs_iget()
Date: Wed,  7 May 2025 20:40:25 +0200
Message-ID: <20250507183832.152633368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Penglei Jiang <superman.xpt@gmail.com>

[ Upstream commit 48c1d1bb525b1c44b8bdc8e7ec5629cb6c2b9fc4 ]

[BUG]
There is a bug report that a syzbot reproducer can lead to the following
busy inode at unmount time:

  BTRFS info (device loop1): last unmount of filesystem 1680000e-3c1e-4c46-84b6-56bd3909af50
  VFS: Busy inodes after unmount of loop1 (btrfs)
  ------------[ cut here ]------------
  kernel BUG at fs/super.c:650!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  CPU: 0 UID: 0 PID: 48168 Comm: syz-executor Not tainted 6.15.0-rc2-00471-g119009db2674 #2 PREEMPT(full)
  Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:generic_shutdown_super+0x2e9/0x390 fs/super.c:650
  Call Trace:
   <TASK>
   kill_anon_super+0x3a/0x60 fs/super.c:1237
   btrfs_kill_super+0x3b/0x50 fs/btrfs/super.c:2099
   deactivate_locked_super+0xbe/0x1a0 fs/super.c:473
   deactivate_super fs/super.c:506 [inline]
   deactivate_super+0xe2/0x100 fs/super.c:502
   cleanup_mnt+0x21f/0x440 fs/namespace.c:1435
   task_work_run+0x14d/0x240 kernel/task_work.c:227
   resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
   exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
   exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
   __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
   syscall_exit_to_user_mode+0x269/0x290 kernel/entry/common.c:218
   do_syscall_64+0xd4/0x250 arch/x86/entry/syscall_64.c:100
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

[CAUSE]
When btrfs_alloc_path() failed, btrfs_iget() directly returned without
releasing the inode already allocated by btrfs_iget_locked().

This results the above busy inode and trigger the kernel BUG.

[FIX]
Fix it by calling iget_failed() if btrfs_alloc_path() failed.

If we hit error inside btrfs_read_locked_inode(), it will properly call
iget_failed(), so nothing to worry about.

Although the iget_failed() cleanup inside btrfs_read_locked_inode() is a
break of the normal error handling scheme, let's fix the obvious bug
and backport first, then rework the error handling later.

Reported-by: Penglei Jiang <superman.xpt@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/20250421102425.44431-1-superman.xpt@gmail.com/
Fixes: 7c855e16ab72 ("btrfs: remove conditional path allocation in btrfs_read_locked_inode()")
CC: stable@vger.kernel.org # 6.13+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f6fc4c9ace28c..3be6f8e8e157d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5660,8 +5660,10 @@ struct inode *btrfs_iget(u64 ino, struct btrfs_root *root)
 		return &inode->vfs_inode;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		iget_failed(&inode->vfs_inode);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	ret = btrfs_read_locked_inode(inode, path);
 	btrfs_free_path(path);
-- 
2.39.5



