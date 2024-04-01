Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F16383BA;
	Mon,  1 Apr 2024 16:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987573; cv=none; b=n63BrVfu5N5KcWWS7DXdFln+2VBv9TXKXvD9fP/GPW+GhX9is7Nv8tYpLDkxwFuJV7v/bQNXurtRGAQK4FMmC7OVtcirXOjM1M9zun2Eqsx4teKlcdY5Yy4817d1OWQlv1nTrpd1O2HG8uWaYhpHUecdiMDPYUhJ0rqaiDbUzB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987573; c=relaxed/simple;
	bh=YWSG5Iq1rxEqIdurn4sWuzsusPyEejfUyhcliYpL5ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cG+RTW7jxNoR01dfgnrJc7a/jad7giy8shL9a6pDaWRSwASMkuAug8GCn58YBQr68szODyJtmUe0O23diy3UjwSDkzishD42Sf5cmAhyYDl7qNDeX1o4v1mAnCRe49nF5zjhgO8X7PYxt6NEC/c3bNGM3lNgex4wTaADXfpZqZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+K/EE6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+K/EE6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60C5C433C7;
	Mon,  1 Apr 2024 16:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987573;
	bh=YWSG5Iq1rxEqIdurn4sWuzsusPyEejfUyhcliYpL5ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+K/EE6jybDc4hmmNkAcv+puJulY1lsdJNEDaIeX6kGVAN7cP3RzuKwx8Xb0oY4Qx
	 9qao7RLWVGdBdozv7pIoe+KPIkeznqh8QpD61CuQIOsRFSwPqv2SqyGzc/Orld1Kek
	 GxCSJBCs3gJ1weO7r8slP6t+KCAuyoPXfJZ4QDg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 298/399] btrfs: zoned: fix use-after-free in do_zone_finish()
Date: Mon,  1 Apr 2024 17:44:24 +0200
Message-ID: <20240401152558.088974919@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 1ec17ef59168a1a6f1105f5dc517f783839a5302 upstream.

Shinichiro reported the following use-after-free triggered by the device
replace operation in fstests btrfs/070.

 BTRFS info (device nullb1): scrub: finished on devid 1 with status: 0
 ==================================================================
 BUG: KASAN: slab-use-after-free in do_zone_finish+0x91a/0xb90 [btrfs]
 Read of size 8 at addr ffff8881543c8060 by task btrfs-cleaner/3494007

 CPU: 0 PID: 3494007 Comm: btrfs-cleaner Tainted: G        W          6.8.0-rc5-kts #1
 Hardware name: Supermicro Super Server/X11SPi-TF, BIOS 3.3 02/21/2020
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5b/0x90
  print_report+0xcf/0x670
  ? __virt_addr_valid+0x200/0x3e0
  kasan_report+0xd8/0x110
  ? do_zone_finish+0x91a/0xb90 [btrfs]
  ? do_zone_finish+0x91a/0xb90 [btrfs]
  do_zone_finish+0x91a/0xb90 [btrfs]
  btrfs_delete_unused_bgs+0x5e1/0x1750 [btrfs]
  ? __pfx_btrfs_delete_unused_bgs+0x10/0x10 [btrfs]
  ? btrfs_put_root+0x2d/0x220 [btrfs]
  ? btrfs_clean_one_deleted_snapshot+0x299/0x430 [btrfs]
  cleaner_kthread+0x21e/0x380 [btrfs]
  ? __pfx_cleaner_kthread+0x10/0x10 [btrfs]
  kthread+0x2e3/0x3c0
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x31/0x70
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1b/0x30
  </TASK>

 Allocated by task 3493983:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  __kasan_kmalloc+0xaa/0xb0
  btrfs_alloc_device+0xb3/0x4e0 [btrfs]
  device_list_add.constprop.0+0x993/0x1630 [btrfs]
  btrfs_scan_one_device+0x219/0x3d0 [btrfs]
  btrfs_control_ioctl+0x26e/0x310 [btrfs]
  __x64_sys_ioctl+0x134/0x1b0
  do_syscall_64+0x99/0x190
  entry_SYSCALL_64_after_hwframe+0x6e/0x76

 Freed by task 3494056:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  kasan_save_free_info+0x3f/0x60
  poison_slab_object+0x102/0x170
  __kasan_slab_free+0x32/0x70
  kfree+0x11b/0x320
  btrfs_rm_dev_replace_free_srcdev+0xca/0x280 [btrfs]
  btrfs_dev_replace_finishing+0xd7e/0x14f0 [btrfs]
  btrfs_dev_replace_by_ioctl+0x1286/0x25a0 [btrfs]
  btrfs_ioctl+0xb27/0x57d0 [btrfs]
  __x64_sys_ioctl+0x134/0x1b0
  do_syscall_64+0x99/0x190
  entry_SYSCALL_64_after_hwframe+0x6e/0x76

 The buggy address belongs to the object at ffff8881543c8000
  which belongs to the cache kmalloc-1k of size 1024
 The buggy address is located 96 bytes inside of
  freed 1024-byte region [ffff8881543c8000, ffff8881543c8400)

 The buggy address belongs to the physical page:
 page:00000000fe2c1285 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1543c8
 head:00000000fe2c1285 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
 flags: 0x17ffffc0000840(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
 page_type: 0xffffffff()
 raw: 0017ffffc0000840 ffff888100042dc0 ffffea0019e8f200 dead000000000002
 raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff8881543c7f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8881543c7f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 >ffff8881543c8000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                        ^
  ffff8881543c8080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8881543c8100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

This UAF happens because we're accessing stale zone information of a
already removed btrfs_device in do_zone_finish().

The sequence of events is as follows:

btrfs_dev_replace_start
  btrfs_scrub_dev
   btrfs_dev_replace_finishing
    btrfs_dev_replace_update_device_in_mapping_tree <-- devices replaced
    btrfs_rm_dev_replace_free_srcdev
     btrfs_free_device                              <-- device freed

cleaner_kthread
 btrfs_delete_unused_bgs
  btrfs_zone_finish
   do_zone_finish              <-- refers the freed device

The reason for this is that we're using a cached pointer to the chunk_map
from the block group, but on device replace this cached pointer can
contain stale device entries.

The staleness comes from the fact, that btrfs_block_group::physical_map is
not a pointer to a btrfs_chunk_map but a memory copy of it.

Also take the fs_info::dev_replace::rwsem to prevent
btrfs_dev_replace_update_device_in_mapping_tree() from changing the device
underneath us again.

Note: btrfs_dev_replace_update_device_in_mapping_tree() is holding
fs_info::mapping_tree_lock, but as this is a spinning read/write lock we
cannot take it as the call to blkdev_zone_mgmt() requires a memory
allocation which may not sleep.
But btrfs_dev_replace_update_device_in_mapping_tree() is always called with
the fs_info::dev_replace::rwsem held in write mode.

Many thanks to Shinichiro for analyzing the bug.

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC: stable@vger.kernel.org # 6.8
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1563,11 +1563,7 @@ int btrfs_load_block_group_zone_info(str
 	if (!map)
 		return -EINVAL;
 
-	cache->physical_map = btrfs_clone_chunk_map(map, GFP_NOFS);
-	if (!cache->physical_map) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	cache->physical_map = map;
 
 	zone_info = kcalloc(map->num_stripes, sizeof(*zone_info), GFP_NOFS);
 	if (!zone_info) {
@@ -1679,7 +1675,6 @@ out:
 	}
 	bitmap_free(active);
 	kfree(zone_info);
-	btrfs_free_chunk_map(map);
 
 	return ret;
 }
@@ -2164,6 +2159,7 @@ static int do_zone_finish(struct btrfs_b
 	struct btrfs_chunk_map *map;
 	const bool is_metadata = (block_group->flags &
 			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
+	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	int ret = 0;
 	int i;
 
@@ -2239,6 +2235,7 @@ static int do_zone_finish(struct btrfs_b
 	btrfs_clear_data_reloc_bg(block_group);
 	spin_unlock(&block_group->lock);
 
+	down_read(&dev_replace->rwsem);
 	map = block_group->physical_map;
 	for (i = 0; i < map->num_stripes; i++) {
 		struct btrfs_device *device = map->stripes[i].dev;
@@ -2253,13 +2250,16 @@ static int do_zone_finish(struct btrfs_b
 				       zinfo->zone_size >> SECTOR_SHIFT,
 				       GFP_NOFS);
 
-		if (ret)
+		if (ret) {
+			up_read(&dev_replace->rwsem);
 			return ret;
+		}
 
 		if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
 			zinfo->reserved_active_zones++;
 		btrfs_dev_clear_active_zone(device, physical);
 	}
+	up_read(&dev_replace->rwsem);
 
 	if (!fully_written)
 		btrfs_dec_block_group_ro(block_group);


