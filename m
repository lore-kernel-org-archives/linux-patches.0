Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8572727F3;
	Wed,  8 Apr 2026 18:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674221; cv=none; b=Ec0Gb7HiiBmkTFXDConjh2nk+c/TglVkUOKyXuERceC3xy1yEwKCtVjSLEpC/eKSfzHWzuiREZlyQ1cSpM7HgrOgp9B6DJuLTE5eq1KPgV2EqLm+jpNpjIhTVSqGfcIiQEiYMW4JHD5jfXYY8qW0ZB4TihL/n2X1gMWh3ui2Oh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674221; c=relaxed/simple;
	bh=E04Jgw2YZyBFafs8/KFi2a6DvYjOzYMhngpZg9gmOQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaXnFsUOqjzlMrHEF/6Kd/7OnogiG6g/aR0wKS/d90ylupkgIv7V1cHp0zD4u2DoDMhi2OivScTe+1XcZ1YHoC20LwD06rFEUNLM6XMDHYWGIv0LpZVhCfktFj7u/0kwCyypP8FWHri+yOeD3/b10l7W2ubqJcHscblHoYb6Gck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQsp46rX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQsp46rX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F1BC19421;
	Wed,  8 Apr 2026 18:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674221;
	bh=E04Jgw2YZyBFafs8/KFi2a6DvYjOzYMhngpZg9gmOQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQsp46rX5/5iw3cRXkSC7DrXLZ7C6a6W4ebCilcUtFc21OGB/7RdRQuJkdPfGgRRb
	 /1AZ67prZFTmiHSSOBn/5W7659Y4PGp3XaHpr8WccZeUsAcRYGMOmEJAteDDlAwLYZ
	 RG4aIrbizTQPMceS4YlzKVC9Ui8rQCevICOYns04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 014/311] btrfs: dont take device_list_mutex when querying zone info
Date: Wed,  8 Apr 2026 20:00:14 +0200
Message-ID: <20260408175939.945592370@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 77603ab10429fe713a03345553ca8dbbfb1d91c6 ]

Shin'ichiro reported sporadic hangs when running generic/013 in our CI
system. When enabling lockdep, there is a lockdep splat when calling
btrfs_get_dev_zone_info_all_devices() in the mount path that can be
triggered by i.e. generic/013:

  ======================================================
  WARNING: possible circular locking dependency detected
  7.0.0-rc1+ #355 Not tainted
  ------------------------------------------------------
  mount/1043 is trying to acquire lock:
  ffff8881020b5470 (&vblk->vdev_mutex){+.+.}-{4:4}, at: virtblk_report_zones+0xda/0x430

  but task is already holding lock:
  ffff888102a738e0 (&fs_devs->device_list_mutex){+.+.}-{4:4}, at: btrfs_get_dev_zone_info_all_devices+0x45/0x90

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #4 (&fs_devs->device_list_mutex){+.+.}-{4:4}:
	 __mutex_lock+0xa3/0x1360
	 btrfs_create_pending_block_groups+0x1f4/0x9d0
	 __btrfs_end_transaction+0x3e/0x2e0
	 btrfs_zoned_reserve_data_reloc_bg+0x2f8/0x390
	 open_ctree+0x1934/0x23db
	 btrfs_get_tree.cold+0x105/0x26c
	 vfs_get_tree+0x28/0xb0
	 __do_sys_fsconfig+0x324/0x680
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #3 (btrfs_trans_num_extwriters){++++}-{0:0}:
	 join_transaction+0xc2/0x5c0
	 start_transaction+0x17c/0xbc0
	 btrfs_zoned_reserve_data_reloc_bg+0x2b4/0x390
	 open_ctree+0x1934/0x23db
	 btrfs_get_tree.cold+0x105/0x26c
	 vfs_get_tree+0x28/0xb0
	 __do_sys_fsconfig+0x324/0x680
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #2 (btrfs_trans_num_writers){++++}-{0:0}:
	 lock_release+0x163/0x4b0
	 __btrfs_end_transaction+0x1c7/0x2e0
	 btrfs_dirty_inode+0x6f/0xd0
	 touch_atime+0xe5/0x2c0
	 btrfs_file_mmap_prepare+0x65/0x90
	 __mmap_region+0x4b9/0xf00
	 mmap_region+0xf7/0x120
	 do_mmap+0x43d/0x610
	 vm_mmap_pgoff+0xd6/0x190
	 ksys_mmap_pgoff+0x7e/0xc0
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #1 (&mm->mmap_lock){++++}-{4:4}:
	 __might_fault+0x68/0xa0
	 _copy_to_user+0x22/0x70
	 blkdev_copy_zone_to_user+0x22/0x40
	 virtblk_report_zones+0x282/0x430
	 blkdev_report_zones_ioctl+0xfd/0x130
	 blkdev_ioctl+0x20f/0x2c0
	 __x64_sys_ioctl+0x86/0xd0
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #0 (&vblk->vdev_mutex){+.+.}-{4:4}:
	 __lock_acquire+0x1522/0x2680
	 lock_acquire+0xd5/0x2f0
	 __mutex_lock+0xa3/0x1360
	 virtblk_report_zones+0xda/0x430
	 blkdev_report_zones_cached+0x162/0x190
	 btrfs_get_dev_zones+0xdc/0x2e0
	 btrfs_get_dev_zone_info+0x219/0xe80
	 btrfs_get_dev_zone_info_all_devices+0x62/0x90
	 open_ctree+0x1200/0x23db
	 btrfs_get_tree.cold+0x105/0x26c
	 vfs_get_tree+0x28/0xb0
	 __do_sys_fsconfig+0x324/0x680
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  other info that might help us debug this:

  Chain exists of:
    &vblk->vdev_mutex --> btrfs_trans_num_extwriters --> &fs_devs->device_list_mutex

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(&fs_devs->device_list_mutex);
				 lock(btrfs_trans_num_extwriters);
				 lock(&fs_devs->device_list_mutex);
    lock(&vblk->vdev_mutex);

   *** DEADLOCK ***

  3 locks held by mount/1043:
   #0: ffff88811063e878 (&fc->uapi_mutex){+.+.}-{4:4}, at: __do_sys_fsconfig+0x2ae/0x680
   #1: ffff88810cb9f0e8 (&type->s_umount_key#31/1){+.+.}-{4:4}, at: alloc_super+0xc0/0x3e0
   #2: ffff888102a738e0 (&fs_devs->device_list_mutex){+.+.}-{4:4}, at: btrfs_get_dev_zone_info_all_devices+0x45/0x90

  stack backtrace:
  CPU: 2 UID: 0 PID: 1043 Comm: mount Not tainted 7.0.0-rc1+ #355 PREEMPT(full)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-9.fc43 06/10/2025
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5b/0x80
   print_circular_bug.cold+0x18d/0x1d8
   check_noncircular+0x10d/0x130
   __lock_acquire+0x1522/0x2680
   ? vmap_small_pages_range_noflush+0x3ef/0x820
   lock_acquire+0xd5/0x2f0
   ? virtblk_report_zones+0xda/0x430
   ? lock_is_held_type+0xcd/0x130
   __mutex_lock+0xa3/0x1360
   ? virtblk_report_zones+0xda/0x430
   ? virtblk_report_zones+0xda/0x430
   ? __pfx_copy_zone_info_cb+0x10/0x10
   ? virtblk_report_zones+0xda/0x430
   virtblk_report_zones+0xda/0x430
   ? __pfx_copy_zone_info_cb+0x10/0x10
   blkdev_report_zones_cached+0x162/0x190
   ? __pfx_copy_zone_info_cb+0x10/0x10
   btrfs_get_dev_zones+0xdc/0x2e0
   btrfs_get_dev_zone_info+0x219/0xe80
   btrfs_get_dev_zone_info_all_devices+0x62/0x90
   open_ctree+0x1200/0x23db
   btrfs_get_tree.cold+0x105/0x26c
   ? rcu_is_watching+0x18/0x50
   vfs_get_tree+0x28/0xb0
   __do_sys_fsconfig+0x324/0x680
   do_syscall_64+0x92/0x4f0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f615e27a40e
  RSP: 002b:00007fff11b18fb8 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
  RAX: ffffffffffffffda RBX: 000055572e92ab10 RCX: 00007f615e27a40e
  RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
  RBP: 00007fff11b19100 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  R13: 000055572e92bc40 R14: 00007f615e3faa60 R15: 000055572e92bd08
   </TASK>

Don't hold the device_list_mutex while calling into
btrfs_get_dev_zone_info() in btrfs_get_dev_zone_info_all_devices() to
mitigate the issue. This is safe, as no other thread can touch the device
list at the moment of execution.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 392e6ad874cc7..ab7cc30212702 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -337,7 +337,10 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 	if (!btrfs_fs_incompat(fs_info, ZONED))
 		return 0;
 
-	mutex_lock(&fs_devices->device_list_mutex);
+	/*
+	 * No need to take the device_list mutex here, we're still in the mount
+	 * path and devices cannot be added to or removed from the list yet.
+	 */
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		/* We can skip reading of zone info for missing devices */
 		if (!device->bdev)
@@ -347,7 +350,6 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 		if (ret)
 			break;
 	}
-	mutex_unlock(&fs_devices->device_list_mutex);
 
 	return ret;
 }
-- 
2.53.0



