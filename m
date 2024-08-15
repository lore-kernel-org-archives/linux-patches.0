Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994DF210FB;
	Thu, 15 Aug 2024 14:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732362; cv=none; b=f0xMVB+In+leKZmtmgrAjn2Jx3qx5h/c+NqEChrnOZoORS90B06yRlmrHc6/rTs32YCylXIAHuTM3tdNvV4zkD7EYpn+6FBVF5r9z1jRg238I5jjpeSrM6aZCwK44nm9qq2F8K3RnUztCNdulFeoACo8y72em80PKzhwvmUXh1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732362; c=relaxed/simple;
	bh=BuzLdfX/vf1DYMRcqNYHx6n08trhZfUSD09cG+fflNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaZKGQ082vVVJJMqOdc0t+BfA0zpN3XVdAkbuhVI3VDIeoS8ki8OSkuHzl8rXvcn3cKJ/R1opREtKUcrJRZG4SMl6P5biFm6KqeEXRn7yOi9oQvgRVmj03In7uDKG+Gp2M0jEcNsoM2l3zUTLdEuwYdwqgZduUAaz8rdg/tevjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riGMPcxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riGMPcxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC65AC32786;
	Thu, 15 Aug 2024 14:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732362;
	bh=BuzLdfX/vf1DYMRcqNYHx6n08trhZfUSD09cG+fflNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riGMPcxDpimHSOSYTSmOFSkXy2ba/jfoRVm7u/antMOARSxnszir6gl5JmVbbZ2zR
	 /dVl20qoEEyClHHI5M65Zvfrl+SX0WXKqpec4YJwuiAzup/7ANsZ4vNAzQjsofgQvW
	 0CkLAM5IEfU2q+aYo3+/jz+ZDwLy/jxO6wQQq3sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+31e4659a3fe953aec2f4@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 157/352] f2fs: fix to dont dirty inode for readonly filesystem
Date: Thu, 15 Aug 2024 15:23:43 +0200
Message-ID: <20240815131925.336800830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 192b8fb8d1c8ca3c87366ebbef599fa80bb626b8 upstream.

syzbot reports f2fs bug as below:

kernel BUG at fs/f2fs/inode.c:933!
RIP: 0010:f2fs_evict_inode+0x1576/0x1590 fs/f2fs/inode.c:933
Call Trace:
 evict+0x2a4/0x620 fs/inode.c:664
 dispose_list fs/inode.c:697 [inline]
 evict_inodes+0x5f8/0x690 fs/inode.c:747
 generic_shutdown_super+0x9d/0x2c0 fs/super.c:675
 kill_block_super+0x44/0x90 fs/super.c:1667
 kill_f2fs_super+0x303/0x3b0 fs/f2fs/super.c:4894
 deactivate_locked_super+0xc1/0x130 fs/super.c:484
 cleanup_mnt+0x426/0x4c0 fs/namespace.c:1256
 task_work_run+0x24a/0x300 kernel/task_work.c:180
 ptrace_notify+0x2cd/0x380 kernel/signal.c:2399
 ptrace_report_syscall include/linux/ptrace.h:411 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:473 [inline]
 syscall_exit_work kernel/entry/common.c:251 [inline]
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:278 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x15c/0x280 kernel/entry/common.c:296
 do_syscall_64+0x50/0x110 arch/x86/entry/common.c:88
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

The root cause is:
- do_sys_open
 - f2fs_lookup
  - __f2fs_find_entry
   - f2fs_i_depth_write
    - f2fs_mark_inode_dirty_sync
     - f2fs_dirty_inode
      - set_inode_flag(inode, FI_DIRTY_INODE)

- umount
 - kill_f2fs_super
  - kill_block_super
   - generic_shutdown_super
    - sync_filesystem
    : sb is readonly, skip sync_filesystem()
    - evict_inodes
     - iput
      - f2fs_evict_inode
       - f2fs_bug_on(sbi, is_inode_flag_set(inode, FI_DIRTY_INODE))
       : trigger kernel panic

When we try to repair i_current_depth in readonly filesystem, let's
skip dirty inode to avoid panic in later f2fs_evict_inode().

Cc: stable@vger.kernel.org
Reported-by: syzbot+31e4659a3fe953aec2f4@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/000000000000e890bc0609a55cff@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -23,6 +23,9 @@ void f2fs_mark_inode_dirty_sync(struct i
 	if (is_inode_flag_set(inode, FI_NEW_INODE))
 		return;
 
+	if (f2fs_readonly(F2FS_I_SB(inode)->sb))
+		return;
+
 	if (f2fs_inode_dirtied(inode, sync))
 		return;
 


