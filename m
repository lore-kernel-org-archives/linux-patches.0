Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026202;
	b=nUPvm5kzhbdokpR3H2erNdRVqwYjROoyi2wg3fyHwR+UNTjFp2IMWr6kvdBoAMwW3yxY
	 hlJ5QlQvZJhY+lKznaWARm5bAUD+QOKvgEaR3PN9QhrqrgMQvMwleeDzGbl7hZUZMzoW6
	 iwrIB7tXtSlh74lbvZTaiU4vIfzc+QetPOznpFSNutfMcyLsBmXBXyayMCzlV9Djs4PJ/
	 fUpXG32j0B7ncJlNn4XEIl1fzg0Ymsod3DbXFwbqoPij7117xMEoVtm4fh2JUGJu58yVm
	 BimPoYzV4Qe9EoZm28qf8SSiVmhxDuBb4DKWUw40qfZdfIGjwJ7LVk6Tz+sTuM+QLEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ie19DcjZhXDS1KR2St7plNfqlnZaPLr8wYb0oc2Zz4=;
	b=KvFHhl7BS3VtyOnwMB4KID6c4+IEyOpDZyoKBb7jZiD5Xwmrlt8NYcxcGMvzYnZeb14v
	 zZVdbDaQTiryDT563v6PMrUc4CvQzIFaFz0ODVNwggwhhLL9eVmmld7AxCWd1P6NPa+Et
	 cNV1fF9SpVqLdP8/ikSPp7V8fJUpa5aeWZ88NlJsCfABTKKyImdlKSKueLXRk8CTax8zb
	 5fI7pQ7f6b+hcl5MjO9Dp6l0UhP1JQXXYF3Uj9b24fz187p9gcbBGgvrsJ+wsrtCcrCX7
	 he0qtYp2aoGF18wIzjRs6PCL/X4U2q3mwBEe641UreaRROROGoRlZnO5JFoKYq9CrCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGCxqjWL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A126C606A33D;
	Wed, 18 Nov 2026 18:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGCxqjWL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93241F000C4;
	Wed, 18 Nov 2026 18:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026202;
	bh=3ie19DcjZhXDS1KR2St7plNfqlnZaPLr8wYb0oc2Zz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGCxqjWLHbjXXcpbGuxJBNXrV09w7ZX5igwhCSFg3hFQTHb8zWDT1hG+CRQSTw1K7
	 gA6DAUhnVLO9c9PIcpLbFsPFmkNAWij2oY2Jr7xdMqALXajcImO+OWHsvoI0r3bGO3
	 ATa56vfPpIVWBDizlgJnS1xWD/80KN+wO+RazD6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1351/2151] btrfs: add extra device item checks at mount
Date: Wed, 18 Nov 2026 15:51:26 +0100
Message-ID: <20261118150211.250942502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 34308187395ff01f2d54007eb8b222f843bdf445 ]

[BUG]
There is a bug report where after a dev-replace, the replace source
device with devid 4 is properly erased (dump tree shows it's the old
devid 4), but the target device is still using devid 0.

When the user tries to mount the fs degraded, the mount failed with the
following errors:

  BTRFS: device fsid 84a1ed4a-365c-45c3-a9ee-a7df525dc3c9 devid 5 transid 1394395 /dev/sda (8:0) scanned by btrfs (261)
  BTRFS: device fsid 84a1ed4a-365c-45c3-a9ee-a7df525dc3c9 devid 6 transid 1394395 /dev/sde (8:64) scanned by btrfs (261)
  BTRFS: device fsid 84a1ed4a-365c-45c3-a9ee-a7df525dc3c9 devid 0 transid 1394395 /dev/sdd (8:48) scanned by btrfs (261)
  BTRFS: device fsid 84a1ed4a-365c-45c3-a9ee-a7df525dc3c9 devid 3 transid 1394395 /dev/sdf (8:80) scanned by btrfs (261)
  BTRFS info (device sdd): first mount of filesystem 84a1ed4a-365c-45c3-a9ee-a7df525dc3c9
  BTRFS info (device sdd): using crc32c (crc32c-intel) checksum algorithm
  BTRFS warning (device sdd): devid 4 uuid 01e2081c-9c2a-4071-b9f4-e1b27e571ff5 is missing
  BTRFS info (device sdd): bdev <missing disk> errs: wr 84994544, rd 15567, flush 65872, corrupt 0, gen 0
  BTRFS info (device sdd): bdev /dev/sdd errs: wr 71489901, rd 0, flush 30001, corrupt 0, gen 0
  BTRFS error (device sdd): replace without active item, run 'device scan --forget' on the target device
  BTRFS error (device sdd): failed to init dev_replace: -117
  BTRFS error (device sdd): open_ctree failed: -117

[CAUSE]
The devid 0 didn't get its devid updated is its own problem, here I'm
only focusing on the mount failure itself.

The mount is not caused by the missing device, as the fs has RAID1C3 for
metadata and RAID10 for data, thus is completely able to tolerate one
missing device.

The device tree shows the dev-replace has properly finished:

        item 7 key (0 DEV_REPLACE 0) itemoff 15931 itemsize 72
                src devid -1 cursor left 11091821199360 cursor right 11091821199360 mode ALWAYS
                state FINISHED write errors 0 uncorrectable read errors 0
		      ^^^^^^^^

And the chunk tree shows there is no devid 0:

  leaf 37980736602112 items 23 free space 12548 generation 1394388 owner CHUNK_TREE
  leaf 37980736602112 flags 0x1(WRITTEN) backref revision 1
  fs uuid 84a1ed4a-365c-45c3-a9ee-a7df525dc3c9
  chunk uuid d074c661-6311-4570-b59f-a5c83fd37f8e
         item 0 key (DEV_ITEMS DEV_ITEM 3) itemoff 16185 itemsize 98
                 devid 3 total_bytes 20000588955648 bytes_used 8282877984768
                 io_align 4096 io_width 4096 sector_size 4096 type 0
                 generation 0 start_offset 0 dev_group 0
                 seek_speed 0 bandwidth 0
                 uuid 0d596b69-fb0d-4031-b4af-a301d0868b8b
                 fsid 84a1ed4a-365c-45c3-a9ee-a7df525dc3c9
         ...

Which shows the first device is devid 3.

But there is indeed /dev/sdd with devid 0:

  superblock: bytenr=65536, device=/dev/sdd
  ---------------------------------------------------------
  csum_type               0 (crc32c)
  csum_size               4
  csum                    0xd4bed87e [match]
  bytenr                  65536
  flags                   0x1
                          ( WRITTEN )
  magic                   _BHRfS_M [match]
  fsid                    84a1ed4a-365c-45c3-a9ee-a7df525dc3c9
  ...
  uuid_tree_generation    1394388
  dev_item.uuid           ee6532ad-5442-45f7-87fb-7703e29ed934
  dev_item.fsid           84a1ed4a-365c-45c3-a9ee-a7df525dc3c9 [match]
  dev_item.type           0
  dev_item.total_bytes    20000588955648
  dev_item.bytes_used     8292541661184
  dev_item.io_align       0
  dev_item.io_width       0
  dev_item.sector_size    0
  dev_item.devid          0 <<<

So this means device scan will register sdd as devid 0 into the fs, then
during btrfs_init_dev_replace(), we located the replace progress item,
found the previous replace is finished, but we still need to check if
the dev-replace target device (devid 0) exists.

If that device exists, we error out showing that error message.

But to be honest the end user may not really remember which device is
the replace target device, thus not sure what to do in the next step.

[ENHANCEMENT]
To make the error more obvious, and tell the end user which devices
should be unregistered:

- Introduce BTRFS_DEV_STATE_ITEM_FOUND flag
  During device item read from the chunk tree, set the flag for each
  found device item.

- Verify there is no device without the above flag during mount
  Even missing device should have that flag set.
  If we found a device without that flag set, it means it's an
  unexpected one and should be rejected.

- More detailed error message on what to do next
  This will show all unexpected devices and tell the end user to use
  'btrfs dev scan --forget' to forget them or remove them before mount.

There is an example dmesg where a device of a valid filesystem is modified to
have devid 0, then try degraded mount:

  BTRFS info (device dm-6): first mount of filesystem 7c873869-844c-4b39-bd75-a96148bf4656
  BTRFS info (device dm-6): using crc32c checksum algorithm
  BTRFS warning (device dm-6): devid 3 uuid b4a9f35b-db42-4ac4-b55a-cbf81d3b9683 is missing
  BTRFS error (device dm-6): devid 0 path /dev/mapper/test-scratch3 is registered but not found in chunk tree
  BTRFS error (device dm-6): please remove above devices or use 'btrfs device scan --forget <dev>' to unregister them before mount
  BTRFS error (device dm-6): open_ctree failed: -117

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: f5166f53b60b ("btrfs: roll back sprout setup after device add failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c |  4 ++++
 fs/btrfs/volumes.c | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  4 ++++
 3 files changed, 48 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 083be891fc99f..2af30d1009783 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3566,6 +3566,10 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	    fs_info->generation == btrfs_super_uuid_tree_generation(disk_super))
 		set_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags);
 
+	if (unlikely(btrfs_verify_dev_items(fs_info))) {
+		ret = -EUCLEAN;
+		goto fail_block_groups;
+	}
 	ret = btrfs_verify_dev_extents(fs_info);
 	if (ret) {
 		btrfs_err(fs_info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a07b5a4d6e4df..0f5c3d1606a48 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7401,6 +7401,7 @@ static int read_one_dev(struct extent_buffer *leaf,
 			return -EINVAL;
 		}
 	}
+	set_bit(BTRFS_DEV_STATE_ITEM_FOUND, &device->dev_state);
 	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	   !test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
@@ -8227,6 +8228,45 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 	return verify_chunk_dev_extent_mapping(fs_info);
 }
 
+/*
+ * Ensure that all devices registered in the fs have their device items in the
+ * chunk tree.
+ *
+ * Return true if unexpected device is found.
+ * Return false otherwise.
+ */
+bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_fs_devices *seed_devs;
+	struct btrfs_device *dev;
+	bool ret = false;
+
+	mutex_lock(&uuid_mutex);
+	list_for_each_entry(dev, &fs_info->fs_devices->devices, dev_list) {
+		if (!test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
+			btrfs_err(fs_info,
+			"devid %llu path %s is registered but not found in chunk tree",
+				  dev->devid, btrfs_dev_name(dev));
+			ret = true;
+		}
+	}
+	list_for_each_entry(seed_devs, &fs_info->fs_devices->seed_list, seed_list) {
+		list_for_each_entry(dev, &seed_devs->devices, dev_list) {
+			if (!test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
+				btrfs_err(fs_info,
+			"devid %llu path %s is registered but not found in chunk tree",
+					  dev->devid, btrfs_dev_name(dev));
+				ret = true;
+			}
+		}
+	}
+	mutex_unlock(&uuid_mutex);
+	if (ret)
+		btrfs_err(fs_info,
+"remove the above devices or use 'btrfs device scan --forget <dev>' to unregister them before mount");
+	return ret;
+}
+
 /*
  * Check whether the given block group or device is pinned by any inode being
  * used as a swapfile.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2cbf8080eade0..ed900ce46e1fd 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -101,6 +101,9 @@ enum btrfs_raid_types {
 #define BTRFS_DEV_STATE_FLUSH_SENT	(4)
 #define BTRFS_DEV_STATE_NO_READA	(5)
 
+/* Set when the device item is found in chunk tree, used to catch unexpected registered device. */
+#define BTRFS_DEV_STATE_ITEM_FOUND	(7)
+
 /* Special value encoding failure to write primary super block. */
 #define BTRFS_SUPER_PRIMARY_WRITE_ERROR		(INT_MAX / 2)
 
@@ -889,6 +892,7 @@ enum btrfs_raid_types __attribute_const__ btrfs_bg_flags_to_raid_index(u64 flags
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
+bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info);
 bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical);
 
 bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr);
-- 
2.53.0



