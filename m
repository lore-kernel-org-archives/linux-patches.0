Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621898;
	b=a25DbCrmuZESNbHzx5bo10m6djomd2EqaQSMBF8ry6+EvkGOItaRZQZKKQjRdjepQrrP
	 73DQcM+v5ioAoKzDJXh3uLUVXqj7QTs6OZCMondZaqnxacziUHvr9b4lSMZPZvpRh1ZPl
	 +fh97+Io69sWh9NI6uwMm60DBGsB3U6qGHzv0vKd/BTdftWVlVI5uYLDQQ1SgzGQe2dxR
	 UaepMpUZ67R/GLMnX/0O4/jqU2NF/a44f1vMbFzNQikxALlQD4YFYzy85Q0S2EokXtDI1
	 AS7PgD8sBv7K1Ra618Ihou5rDb77qYZ7RG1wyg4/L6NrTSsV66Sd0Wz7yC4FbXYLpAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utxJ5BM88KK3cYoexK/mvGZ7dh0crUu7LTIujShLKng=;
	b=Tr4AMKfEOujeXHZBWNE7MxTVSZwO9sh2MXLObQuU6//0OtpnW3o+YWMcyBjyUAZc3uLR
	 zCVQiVZB5FwO+FRZNziNEuO4MTwXNKH+3QlSkFGjgWxsVl2CTegOwj988ZeKV1uvIV1+2
	 b9qa8gXhx1AirmvZ+1LLyHOHTEe4ROjJnKRV51PL/9RWsZd1LBVadBKVZDWZxubSniEAv
	 J1jY1BTgSJNsQ+EQpLieyqyl1FEGnME4Iw68DMGtSOxAupYG2f/gJFGUVgumV9p5k2tZf
	 6QefRoy9W7LjhoO1rcklqfkL61Pqox2FpeqXPYTh52EtzaPb0sSmKpq2ne6R7VsvR0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wi1qfOwY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8757606A327;
	Wed, 25 Nov 2026 15:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wi1qfOwY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7FE1F000D0;
	Wed, 25 Nov 2026 15:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621898;
	bh=utxJ5BM88KK3cYoexK/mvGZ7dh0crUu7LTIujShLKng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wi1qfOwYet2YgN9p+XB7YRv2aMbPHxcPjpbHf94O9sBkzOVPEOHSuDeVjBNSP0M8y
	 St2tQ+czhuVlZUxnbKK8wzZCt+KJpKX/Hn5jcm49dVE8mTOX3vAls+ci62kpFP0rFw
	 /kUtWSSt2hlA9WzaKRaN9HUbofNy3iA/UXUlQ7kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/990] btrfs: zoned: fix lockdep splat on mount
Date: Wed, 25 Nov 2026 15:28:56 +0100
Message-ID: <20261125143830.734483242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 04df03585f0d8ef2727e043119bba2cdfac2d8d7 ]

When mounting a filesystem on a zoned drive passed into a VM via a
virtio-blk disk lockdep sporadically complains about a possible deadlock
between BTRFS' dev_replace::rwsem and virtio-blk's vdev_mutex:

 ======================================================
 WARNING: possible circular locking dependency detected
 7.3.0-rc6+ #317 Not tainted
 ------------------------------------------------------
 mount/7418 is trying to acquire lock:
 ffff888102c07860 (&vblk->vdev_mutex){+.+.}-{4:4}, at: virtblk_report_zones+0xda/0x440

 but task is already holding lock:
 ffff8881fd725ea8 (&fs_info->dev_replace.rwsem){++++}-{4:4}, at: btrfs_load_block_group_zone_info+0x186/0xe50

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #4 (&fs_info->dev_replace.rwsem){++++}-{4:4}:
        down_read+0x42/0x170
        btrfs_map_block+0x1a6/0xe70
        btrfs_submit_bbio+0x1a3/0x910
        submit_one_bio+0x93/0xd0
        btrfs_readahead+0x1c4/0x200
        read_pages+0x56/0x200
        page_cache_ra_order+0x27c/0x410
        filemap_get_pages+0x12f/0x4a0
        filemap_read+0xed/0x400
        vfs_read+0x240/0x340
        ksys_read+0x61/0xd0
        do_syscall_64+0xa3/0x4f0
        entry_SYSCALL_64_after_hwframe+0x76/0x7e

 -> #3 (mapping.invalidate_lock#3){++++}-{4:4}:
        down_read+0x42/0x170
        filemap_fault+0xb0/0x1a40
        __do_fault+0x34/0xc0
        __handle_mm_fault+0x919/0x1db0
        handle_mm_fault+0x97/0x240
        do_user_addr_fault+0x21d/0x690
        exc_page_fault+0x8e/0x230
        asm_exc_page_fault+0x26/0x30

 -> #2 (vm_lock){++++}-{0:0}:
        __vma_start_exclude_readers+0x91/0x1b0
        __vma_start_write+0x47/0xd0
        vma_expand+0x4c/0x2a0
        relocate_vma_down+0x126/0x200
        setup_arg_pages+0x240/0x3e0
        load_elf_binary+0x1be/0x1860
        bprm_execve+0x2d2/0x7b0
        kernel_execve+0x107/0x130
        kernel_init+0xc2/0x130
        ret_from_fork+0x1ff/0x2f0
        ret_from_fork_asm+0x1a/0x30

 -> #1 (&mm->mmap_lock){++++}-{4:4}:
        __might_fault+0x68/0xa0
        _copy_to_user+0x22/0x70
        blkdev_copy_zone_to_user+0x22/0x40
        virtblk_report_zones+0x297/0x440
        blkdev_report_zones_ioctl+0xfd/0x130
        blkdev_ioctl+0x20f/0x2c0
        __x64_sys_ioctl+0x86/0xd0
        do_syscall_64+0xa3/0x4f0
        entry_SYSCALL_64_after_hwframe+0x76/0x7e

 -> #0 (&vblk->vdev_mutex){+.+.}-{4:4}:
        __lock_acquire+0x15a8/0x2850
        lock_acquire+0xea/0x2f0
        __mutex_lock+0xa7/0x10d0
        virtblk_report_zones+0xda/0x440
        blkdev_report_zones_cached+0x162/0x190
        btrfs_get_dev_zones+0xdc/0x2c0
        btrfs_load_block_group_zone_info+0x2b6/0xe50
        btrfs_read_block_groups+0x338/0xc80
        open_ctree+0x1aca/0x24b3
        btrfs_get_tree.cold+0x105/0x26c
        vfs_get_tree+0x28/0xb0
        __do_sys_fsconfig+0x324/0x690
        do_syscall_64+0xa3/0x4f0
        entry_SYSCALL_64_after_hwframe+0x76/0x7e

 other info that might help us debug this:

 Chain exists of:
   &vblk->vdev_mutex --> mapping.invalidate_lock#3 --> &fs_info->dev_replace.rwsem

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   rlock(&fs_info->dev_replace.rwsem);
                                lock(mapping.invalidate_lock#3);
                                lock(&fs_info->dev_replace.rwsem);
   lock(&vblk->vdev_mutex);

  *** DEADLOCK ***

 locks held by mount/7418: 3, last CPU#0:
  #0: ffff888110aa6868 (&fc->uapi_mutex){+.+.}-{4:4}, at: __do_sys_fsconfig+0x2ae/0x690
  #1: ffff888112ba20e8 (&type->s_umount_key#31/1){+.+.}-{4:4}, at: sget_fc+0x148/0x8d0
  #2: ffff8881fd725ea8 (&fs_info->dev_replace.rwsem){++++}-{4:4}, at: btrfs_load_block_group_zone_info+0x186/0xe50

Holding the rwsem was widened in 0090d6e1b210 ("btrfs: zoned: fix
use-after-free due to race with dev replace"), but it now also covers
calling into blkdev_report_zones_cached(). The device replace ioctl()
only works on a mounted filesystem and the only caller with setting
'new' to false is read_one_block_group() which is only called during
mount, so it is safe to drop the rwsem before calling into
blkdev_report_zones_cached().

Fixes: 0090d6e1b210 ("btrfs: zoned: fix use-after-free due to race with dev replace")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 65c238d38e5d5..a7f1a1b908641 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1378,11 +1378,13 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 		return 0;
 	}
 
+	ASSERT(!test_bit(BTRFS_FS_OPEN, &fs_info->flags));
+	up_read(&dev_replace->rwsem);
+
 	nofs_flag = memalloc_nofs_save();
 	ret = btrfs_get_dev_zone(device, info->physical, &zone);
 	memalloc_nofs_restore(nofs_flag);
 	if (ret) {
-		up_read(&dev_replace->rwsem);
 		if (ret != -EIO && ret != -EOPNOTSUPP)
 			return ret;
 		info->alloc_offset = WP_MISSING_DEV;
@@ -1394,7 +1396,6 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 		"zoned: unexpected conventional zone %llu on device %s (devid %llu)",
 			zone.start << SECTOR_SHIFT, rcu_dereference(device->name),
 			device->devid);
-		up_read(&dev_replace->rwsem);
 		return -EIO;
 	}
 
@@ -1422,8 +1423,6 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 		break;
 	}
 
-	up_read(&dev_replace->rwsem);
-
 	return 0;
 }
 
-- 
2.53.0



