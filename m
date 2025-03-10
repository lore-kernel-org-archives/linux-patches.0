Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C87A22D786;
	Mon, 10 Mar 2025 17:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626549; cv=none; b=OnwdTPVSgxIb8mxVouRxs/ANHTKMVyuC5xn1n/eKMx7F+VsWwsI9NOLocFKCTO280OXqjy1+bLw/Dk42YgrzhUYyWx3GnyPft1/FBej0p/rLUbCmTSSQNpT9HVLh8TepbaNiniZN04bs7oCSTIydLYdJWFBnwCzFtraziHz+x9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626549; c=relaxed/simple;
	bh=GsnrNqbvD1zsFSkPgjpEDT0RNddJVtJdb0E7a8Jhjf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RktjYQymdgxG9PDuuK1DXqDrsTayXMg8t5Hsp/y+EXW6Uv886TzyN1f04e8UozwGVEMWQljtf9zM5mxJx8yIqZ8Z3btode2bHa5AJdd3zpEpGPBLHSapvDK4UCfhb6K5Eehy+jNW0MkPAXXb6XX6L91E3j6wYCm4gC76wE96VLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW5GF2N0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW5GF2N0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1825CC4CEE5;
	Mon, 10 Mar 2025 17:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626549;
	bh=GsnrNqbvD1zsFSkPgjpEDT0RNddJVtJdb0E7a8Jhjf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW5GF2N0EZV9ZUSqUoIJ3dyheBYmdQiphmG8nFKX2EUxUp2eSIL+Eu4ln0Jt7CA+m
	 SWZv/Jd3m5OTlIhaocFJ1yRShjzpzp+vYKJNQOkAVR3VIY6fgCvBySEy7JUt0IvBi0
	 1nuuWOyPZeF/2qgrg8kPPNttzMyWUQl2R61KJ+BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 030/207] btrfs: zoned: fix extent range end unlock in cow_file_range()
Date: Mon, 10 Mar 2025 18:03:43 +0100
Message-ID: <20250310170448.971963512@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 5a4041f2c47247575a6c2e53ce14f7b0ac946c33 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1426,8 +1426,13 @@ static noinline int cow_file_range(struc
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


