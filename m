Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2494C2E7BB6;
	Thu,  3 Jul 2025 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554529; cv=none; b=oZ2+5CQxaxqZWTETak+ih6odV8NNyvZ5Xux2eWq/3zYBQdq3I7LxiEoeK/2oJQQKJ6AUYJe01vHr5b9vLD9G+inad2mn7+Zkh/hi9UvbLuRHEQ1uIttgJMGhujGCtjIGmjFnUIcH9wdj0Xp1E3WbaJtY0+u58Jb0XpP9xO38XYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554529; c=relaxed/simple;
	bh=MWHiVqRU2TAfZIHs13W0R4UB8pfGo0FNm/XT60vDUPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ip+ZT0BUzMr9W3VWuo+AI+PjIJjzcaFrr03ykQyx4tY4ACVh90ysUiK9LTIRAYv2VDJCMtr/oCNlTmLtHytbEsRuKw3Qj6JxN3dJVshQXEqrK+GnefGBozNNiUKQmuqJLxI4agBzzy7QhqsH0VFB3V+nw/o5sZHOMEWVTpXDwnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVHFXj/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVHFXj/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E150C4CEE3;
	Thu,  3 Jul 2025 14:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554529;
	bh=MWHiVqRU2TAfZIHs13W0R4UB8pfGo0FNm/XT60vDUPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVHFXj/JJ3NHdD6qjnvZo1ppY/HVQtoW1WYeDQAf68J9FWEIJkSv5/TdT6yDrIObY
	 eISyis/PTs/ENhx58RuSbA4MqN6ZzCEu/WEgSoWPVCe0oX77lFcFNmlEnznDkU2m2D
	 y1x3MOZiWM4woerN7kVMHoRX7f47jSYgSHH44vQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/218] btrfs: zoned: fix extent range end unlock in cow_file_range()
Date: Thu,  3 Jul 2025 16:42:44 +0200
Message-ID: <20250703144004.849259374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 5a4041f2c47247575a6c2e53ce14f7b0ac946c33 ]

Running generic/751 on the for-next branch often results in a hang like
below. They are both stack by locking an extent. This suggests someone
forget to unlock an extent.

  INFO: task kworker/u128:1:12 blocked for more than 323 seconds.
        Not tainted 6.13.0-BTRFS-ZNS+ #503
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:kworker/u128:1  state:D stack:0     pid:12    tgid:12    ppid:2      flags:0x00004000
  Workqueue: btrfs-fixup btrfs_work_helper [btrfs]
  Call Trace:
   <TASK>
   __schedule+0x534/0xdd0
   schedule+0x39/0x140
   __lock_extent+0x31b/0x380 [btrfs]
   ? __pfx_autoremove_wake_function+0x10/0x10
   btrfs_writepage_fixup_worker+0xf1/0x3a0 [btrfs]
   btrfs_work_helper+0xff/0x480 [btrfs]
   ? lock_release+0x178/0x2c0
   process_one_work+0x1ee/0x570
   ? srso_return_thunk+0x5/0x5f
   worker_thread+0x1d1/0x3b0
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x10b/0x230
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x30/0x50
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  INFO: task kworker/u134:0:184 blocked for more than 323 seconds.
        Not tainted 6.13.0-BTRFS-ZNS+ #503
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:kworker/u134:0  state:D stack:0     pid:184   tgid:184   ppid:2      flags:0x00004000
  Workqueue: writeback wb_workfn (flush-btrfs-4)
  Call Trace:
   <TASK>
   __schedule+0x534/0xdd0
   schedule+0x39/0x140
   __lock_extent+0x31b/0x380 [btrfs]
   ? __pfx_autoremove_wake_function+0x10/0x10
   find_lock_delalloc_range+0xdb/0x260 [btrfs]
   writepage_delalloc+0x12f/0x500 [btrfs]
   ? srso_return_thunk+0x5/0x5f
   extent_write_cache_pages+0x232/0x840 [btrfs]
   btrfs_writepages+0x72/0x130 [btrfs]
   do_writepages+0xe7/0x260
   ? srso_return_thunk+0x5/0x5f
   ? lock_acquire+0xd2/0x300
   ? srso_return_thunk+0x5/0x5f
   ? find_held_lock+0x2b/0x80
   ? wbc_attach_and_unlock_inode.part.0+0x102/0x250
   ? wbc_attach_and_unlock_inode.part.0+0x102/0x250
   __writeback_single_inode+0x5c/0x4b0
   writeback_sb_inodes+0x22d/0x550
   __writeback_inodes_wb+0x4c/0xe0
   wb_writeback+0x2f6/0x3f0
   wb_workfn+0x32a/0x510
   process_one_work+0x1ee/0x570
   ? srso_return_thunk+0x5/0x5f
   worker_thread+0x1d1/0x3b0
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x10b/0x230
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x30/0x50
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

This happens because we have another success path for the zoned mode. When
there is no active zone available, btrfs_reserve_extent() returns
-EAGAIN. In this case, we have two reactions.

(1) If the given range is never allocated, we can only wait for someone
    to finish a zone, so wait on BTRFS_FS_NEED_ZONE_FINISH bit and retry
    afterward.

(2) Or, if some allocations are already done, we must bail out and let
    the caller to send IOs for the allocation. This is because these IOs
    may be necessary to finish a zone.

The commit 06f364284794 ("btrfs: do proper folio cleanup when
cow_file_range() failed") moved the unlock code from the inside of the
loop to the outside. So, previously, the allocated extents are unlocked
just after the allocation and so before returning from the function.
However, they are no longer unlocked on the case (2) above. That caused
the hang issue.

Fix the issue by modifying the 'end' to the end of the allocated
range. Then, we can exit the loop and the same unlock code can properly
handle the case.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Fixes: 06f364284794 ("btrfs: do proper folio cleanup when cow_file_range() failed")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2f0b2cb2ae6e8..921ec3802648b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1463,8 +1463,13 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 				continue;
 			}
 			if (done_offset) {
-				*done_offset = start - 1;
-				return 0;
+				/*
+				 * Move @end to the end of the processed range,
+				 * and exit the loop to unlock the processed extents.
+				 */
+				end = start - 1;
+				ret = 0;
+				break;
 			}
 			ret = -ENOSPC;
 		}
-- 
2.39.5



