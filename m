Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9BC2C327B;
	Tue, 15 Jul 2025 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585785; cv=none; b=mbWg7iikwqe+xSzbFT6jiqjyGTvJoD00PN0lIgKXXUpD0vQxMjM4M7LE8ZUv8BimkMLjtZkglUaJQvmAK8jveUF7aYuLlxZL55r7G322wUmlMYezm5lW6SOyEBmA0xnPj0vIVDEzAl2+ga560V4YqHa+s37+aD8hP4SDNN7o6lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585785; c=relaxed/simple;
	bh=6UbF2ZpCBuekvfc3HYEJfMXU3RRQUtwLgADNkWMauUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSnD576+kIcPX019Hkm/0fjtuLAZbE4PCiB/7Q4E+XP4aw6teM86PDEpU6zE0PfuAvo8ux4Fl3gDfvfViONRFa4QICVL5tabojyJv7kuhU4vUUSNbC2V2iyFGulId0MFhVBAfBu7cJTrjLNjrOv7XkdQkoLdmzBBdDuCEtvRksA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBzpS0rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBzpS0rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F292C4CEE3;
	Tue, 15 Jul 2025 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585784;
	bh=6UbF2ZpCBuekvfc3HYEJfMXU3RRQUtwLgADNkWMauUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBzpS0rkbeRcwgZurZeDDl8SD4Qa1yLqR6sBnWyGmPM8jQOcmxyGw2LAPM2AeMxA4
	 1H4smOt7qIWifXpvrRVJg6tf4D7GDiNvdG526CBoHoRAwmqDKm3Lt3CvqZ9q+1LrSW
	 vBdP6wYS9olpTHeUhXH+P+LIeSdG2KLtLR+vqztk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ff87b095e7ca0c5ac39@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.12 159/163] erofs: fix rare pcluster memory leak after unmounting
Date: Tue, 15 Jul 2025 15:13:47 +0200
Message-ID: <20250715130815.212731690@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit b10a1e5643e505c367c7e16aa6d8a9a0dc07354b upstream.

There may still exist some pcluster with valid reference counts
during unmounting.  Instead of introducing another synchronization
primitive, just try again as unmounting is relatively rare.  This
approach is similar to z_erofs_cache_invalidate_folio().

It was also reported by syzbot as a UAF due to commit f5ad9f9a603f
("erofs: free pclusters if no cached folio is attached"):

BUG: KASAN: slab-use-after-free in do_raw_spin_trylock+0x72/0x1f0 kernel/locking/spinlock_debug.c:123
..
 queued_spin_trylock include/asm-generic/qspinlock.h:92 [inline]
 do_raw_spin_trylock+0x72/0x1f0 kernel/locking/spinlock_debug.c:123
 __raw_spin_trylock include/linux/spinlock_api_smp.h:89 [inline]
 _raw_spin_trylock+0x20/0x80 kernel/locking/spinlock.c:138
 spin_trylock include/linux/spinlock.h:361 [inline]
 z_erofs_put_pcluster fs/erofs/zdata.c:959 [inline]
 z_erofs_decompress_pcluster fs/erofs/zdata.c:1403 [inline]
 z_erofs_decompress_queue+0x3798/0x3ef0 fs/erofs/zdata.c:1425
 z_erofs_decompressqueue_work+0x99/0xe0 fs/erofs/zdata.c:1437
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

However, it seems a long outstanding memory leak.  Fix it now.

Fixes: f5ad9f9a603f ("erofs: free pclusters if no cached folio is attached")
Reported-by: syzbot+7ff87b095e7ca0c5ac39@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/674c1235.050a0220.ad585.0032.GAE@google.com
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241203072821.1885740-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zutil.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -230,9 +230,10 @@ void erofs_shrinker_unregister(struct su
 	struct erofs_sb_info *const sbi = EROFS_SB(sb);
 
 	mutex_lock(&sbi->umount_mutex);
-	/* clean up all remaining pclusters in memory */
-	z_erofs_shrink_scan(sbi, ~0UL);
-
+	while (!xa_empty(&sbi->managed_pslots)) {
+		z_erofs_shrink_scan(sbi, ~0UL);
+		cond_resched();
+	}
 	spin_lock(&erofs_sb_list_lock);
 	list_del(&sbi->list);
 	spin_unlock(&erofs_sb_list_lock);


