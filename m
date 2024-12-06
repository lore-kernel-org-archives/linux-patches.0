Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B077953A7;
	Fri,  6 Dec 2024 15:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497700; cv=none; b=MNSxOusXmP/H8esP9L4KVPZWt5TTAS8AYUjf0h4RRxFGiUjtuNPkTkaUwEKTV/SL9Qtr0yAv3QU00SRn3e5xQZFolrdvAaWB1eEoxJ3JZR9IP7LCcTEg1MyRHvF8z4HIviXkON1U/DpVk+XJfEGbeJgoPXM7SmM+ebrSg1dBq8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497700; c=relaxed/simple;
	bh=AUEwTA1Y3tIBYip2sfji2k5Lfn+4TJY8BCV2aPPvMRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/goTpO73ysbPtiiTFGB9pEa/DW/P8+ZNAvh6TIE3yQb9Cm+r7SzDuRE/enYJtIqxO7FHSOAIRdv4ZYjZvq8o3cQPOJNcpcfMbOLQd+etrBUdrdYZa0CHu9593raOk5lQWlTARKJP70OgMyt93suRHFNKWAG9fIvaLSeZH1gSC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nD+YZPMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nD+YZPMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB89C4CED1;
	Fri,  6 Dec 2024 15:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497700;
	bh=AUEwTA1Y3tIBYip2sfji2k5Lfn+4TJY8BCV2aPPvMRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nD+YZPMWukNz6bMRyGUiMghq457YUS6g6IPBqp2qXufwk7V8Fg+OwCHVm4iUWYfBd
	 M0lnllVmH5zZJN+951pU1k2uHxXdgYIXhZxsUE0goTEkDNVDrxG+LRwCbWFGPz4pDN
	 olAyUbU1zs7rtisgBM0JuCeHF9c1yRLWD84KRGIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 367/676] f2fs: fix race in concurrent f2fs_stop_gc_thread
Date: Fri,  6 Dec 2024 15:33:06 +0100
Message-ID: <20241206143707.682206393@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 7b0033dbc48340a1c1c3f12448ba17d6587ca092 ]

In my test case, concurrent calls to f2fs shutdown report the following
stack trace:

 Oops: general protection fault, probably for non-canonical address 0xc6cfff63bb5513fc: 0000 [#1] PREEMPT SMP PTI
 CPU: 0 UID: 0 PID: 678 Comm: f2fs_rep_shutdo Not tainted 6.12.0-rc5-next-20241029-g6fb2fa9805c5-dirty #85
 Call Trace:
  <TASK>
  ? show_regs+0x8b/0xa0
  ? __die_body+0x26/0xa0
  ? die_addr+0x54/0x90
  ? exc_general_protection+0x24b/0x5c0
  ? asm_exc_general_protection+0x26/0x30
  ? kthread_stop+0x46/0x390
  f2fs_stop_gc_thread+0x6c/0x110
  f2fs_do_shutdown+0x309/0x3a0
  f2fs_ioc_shutdown+0x150/0x1c0
  __f2fs_ioctl+0xffd/0x2ac0
  f2fs_ioctl+0x76/0xe0
  vfs_ioctl+0x23/0x60
  __x64_sys_ioctl+0xce/0xf0
  x64_sys_call+0x2b1b/0x4540
  do_syscall_64+0xa7/0x240
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The root cause is a race condition in f2fs_stop_gc_thread() called from
different f2fs shutdown paths:

  [CPU0]                       [CPU1]
  ----------------------       -----------------------
  f2fs_stop_gc_thread          f2fs_stop_gc_thread
                                 gc_th = sbi->gc_thread
    gc_th = sbi->gc_thread
    kfree(gc_th)
    sbi->gc_thread = NULL
                                 < gc_th != NULL >
                                 kthread_stop(gc_th->f2fs_gc_task) //UAF

The commit c7f114d864ac ("f2fs: fix to avoid use-after-free in
f2fs_stop_gc_thread()") attempted to fix this issue by using a read
semaphore to prevent races between shutdown and remount threads, but
it fails to prevent all race conditions.

Fix it by converting to write lock of s_umount in f2fs_do_shutdown().

Fixes: 7950e9ac638e ("f2fs: stop gc/discard thread after fs shutdown")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ad26733f1f46c..c6bc4cbd72b9d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2308,9 +2308,12 @@ int f2fs_do_shutdown(struct f2fs_sb_info *sbi, unsigned int flag,
 	if (readonly)
 		goto out;
 
-	/* grab sb->s_umount to avoid racing w/ remount() */
+	/*
+	 * grab sb->s_umount to avoid racing w/ remount() and other shutdown
+	 * paths.
+	 */
 	if (need_lock)
-		down_read(&sbi->sb->s_umount);
+		down_write(&sbi->sb->s_umount);
 
 	f2fs_stop_gc_thread(sbi);
 	f2fs_stop_discard_thread(sbi);
@@ -2319,7 +2322,7 @@ int f2fs_do_shutdown(struct f2fs_sb_info *sbi, unsigned int flag,
 	clear_opt(sbi, DISCARD);
 
 	if (need_lock)
-		up_read(&sbi->sb->s_umount);
+		up_write(&sbi->sb->s_umount);
 
 	f2fs_update_time(sbi, REQ_TIME);
 out:
-- 
2.43.0



