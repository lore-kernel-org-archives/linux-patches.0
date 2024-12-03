Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8041323CE;
	Tue,  3 Dec 2024 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241762; cv=none; b=cXV07TTcslg7L5In05iroaYn0bmyd+OHOJnRVa7U7CQLSSvZeEQkPNEZVQKnBbrbU4VvC0+kFOn2a4AIXbLw82R7Eai2toglbPkjlaU2UUCo24lUEcfeRWNGyDwtx3tpSt/uF9pv6PMDrWn1cCeyoYQfg78VQTI/lwwFrGpj7bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241762; c=relaxed/simple;
	bh=Ww/xl3QLSn60Ic4rJ1dX8UI+k+JW2lqIy77FnVign3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlG28qP0NAIvqTjg763h48T/WqD8pLKC4Zxdcekr5FK7A4r3aSXiL9qjfEEVO1LqgUMqb5iTeNKbol7ISDhlhDXyclcA2c4EqzwICoT2iIh9Aj1guFsJB/ZOHyoyx4zz5ge0Q+BfW9qr+A6kosgCRIrQI4nWKz2xDyyiNMjxwy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwibIg+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwibIg+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70901C4CECF;
	Tue,  3 Dec 2024 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241761;
	bh=Ww/xl3QLSn60Ic4rJ1dX8UI+k+JW2lqIy77FnVign3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwibIg+gwvkjGJsigVyZiH0wCROK1yxjHYewCUuVWY/+bLW1NrvsS5IvDo1oDP8HS
	 gKOkXmuD4v96e9Xu62UDkEjmvuMfke/8zm7KEyvgGpqefEsx4SAlXpvWm2rfmrb/hF
	 Pdzq5nyLATJLrPhGpzZs90DxOxtVJMTQnpQq+ErM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 507/826] f2fs: fix race in concurrent f2fs_stop_gc_thread
Date: Tue,  3 Dec 2024 15:43:54 +0100
Message-ID: <20241203144803.533570957@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index adc7d64a6f47d..b96403ab7a925 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2343,9 +2343,12 @@ int f2fs_do_shutdown(struct f2fs_sb_info *sbi, unsigned int flag,
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
@@ -2354,7 +2357,7 @@ int f2fs_do_shutdown(struct f2fs_sb_info *sbi, unsigned int flag,
 	clear_opt(sbi, DISCARD);
 
 	if (need_lock)
-		up_read(&sbi->sb->s_umount);
+		up_write(&sbi->sb->s_umount);
 
 	f2fs_update_time(sbi, REQ_TIME);
 out:
-- 
2.43.0



