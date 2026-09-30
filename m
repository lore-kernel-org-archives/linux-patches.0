Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920A5345EDD;
	Wed, 30 Sep 2026 18:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791347; cv=none; b=g+5Wb2CXTh2yaUe8WwlNwqhN8FKHZhfNuKAKtrFz1FPkyxk1FnWBevGIRL/ifwCqHdzNA8BxH78q29a70S9l9eFQvq4NNZ5Lvk1twKMyVd5y+GCAr9Nq+OOS6hfD8n4xDa5YYYgyGDIZjFGQVPcd+AT+88OzSmaCxwurKU/Tgqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791347; c=relaxed/simple;
	bh=cvpCQXe8XyhMdxrnmb3UVtxL6ks3QJkHucDxWz8a3O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOjmsFxYufC1V9xtCIRs6BX9kSfeW5k9JEGdFJ/o3OnGuIFqbNxoSRJwbatsqTa7XUCMJ9JFz5c2au8YrU8EPORVEM07iyDBeBr8FiA8jIfWqFQ2BLdds7N/A5Fs/yfj8gOGmVeNG7nl6TfEbfn4BVAL13Whk+xnGdX+W7N3e+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCeb+Uwy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCeb+Uwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94B81F000FF;
	Wed, 30 Sep 2026 18:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791346;
	bh=q7PGnbjhYi8UQ3AuJtmhCqfRs0Ty91+I9oBxJ9at4JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCeb+UwyWNb3++fhC6cRpW94Hg/dGdg5y3I/EgFR3hW6hYHsTP3V1AqJHDLwaGvAF
	 P0MQdxuQxcV5Veyo7EfemfKCSJMsjRdPmI7D3ZzSal9aalDk0/BMqT8Nm2GcXfw4oV
	 wVqcqFYVbQP81EY6uRYFeBhWErVt1IeT1RLEh0D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/752] btrfs: consolidate device_list_mutex in prepare_sprout to its parent
Date: Wed, 30 Sep 2026 17:22:18 +0200
Message-ID: <20260930152404.082908337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit 849eae5e57a703105aa6cdce0d860ab95f44d81c ]

btrfs_prepare_sprout() splices seed devices into its own struct fs_devices,
so that its parent function btrfs_init_new_device() can add the new sprout
device to fs_info->fs_devices.

Both btrfs_prepare_sprout() and btrfs_init_new_device() need
device_list_mutex. But they are holding it separately, thus create a
small race window. Close it and hold device_list_mutex across both
functions btrfs_init_new_device() and btrfs_prepare_sprout().

Split btrfs_prepare_sprout() into btrfs_init_sprout() and
btrfs_setup_sprout(). This split is essential because device_list_mutex
must not be held for allocations in btrfs_init_sprout() but must be held
for btrfs_setup_sprout(). So now a common device_list_mutex can be used
between btrfs_init_new_device() and btrfs_setup_sprout().

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: e0b54613aabe ("btrfs: restore active device pointers after failed sprout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 69 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 51 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e62faf34cf877..794b8ccd683ab 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2525,21 +2525,15 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 	return device;
 }
 
-/*
- * does all the dirty work required for changing file system's UUID.
- */
-static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
+static struct btrfs_fs_devices *btrfs_init_sprout(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_fs_devices *old_devices;
 	struct btrfs_fs_devices *seed_devices;
-	struct btrfs_super_block *disk_super = fs_info->super_copy;
-	struct btrfs_device *device;
-	u64 super_flags;
 
 	lockdep_assert_held(&uuid_mutex);
 	if (!fs_devices->seeding)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	/*
 	 * Private copy of the seed devices, anchored at
@@ -2547,7 +2541,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	 */
 	seed_devices = alloc_fs_devices(NULL, NULL);
 	if (IS_ERR(seed_devices))
-		return PTR_ERR(seed_devices);
+		return seed_devices;
 
 	/*
 	 * It's necessary to retain a copy of the original seed fs_devices in
@@ -2558,7 +2552,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	old_devices = clone_fs_devices(fs_devices);
 	if (IS_ERR(old_devices)) {
 		kfree(seed_devices);
-		return PTR_ERR(old_devices);
+		return old_devices;
 	}
 
 	list_add(&old_devices->fs_list, &fs_uuids);
@@ -2569,7 +2563,41 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	INIT_LIST_HEAD(&seed_devices->alloc_list);
 	mutex_init(&seed_devices->device_list_mutex);
 
-	mutex_lock(&fs_devices->device_list_mutex);
+	return seed_devices;
+}
+
+/*
+ * Splice seed devices into the sprout fs_devices.
+ * Generate a new fsid for the sprouted read-write filesystem.
+ */
+static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
+			       struct btrfs_fs_devices *seed_devices)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_super_block *disk_super = fs_info->super_copy;
+	struct btrfs_device *device;
+	u64 super_flags;
+
+	/*
+	 * We are updating the fsid, the thread leading to device_list_add()
+	 * could race, so uuid_mutex is needed.
+	 */
+	lockdep_assert_held(&uuid_mutex);
+
+	/*
+	 * The threads listed below may traverse dev_list but can do that without
+	 * device_list_mutex:
+	 * - All device ops and balance - as we are in btrfs_exclop_start.
+	 * - Various dev_list readers - are using RCU.
+	 * - btrfs_ioctl_fitrim() - is using RCU.
+	 *
+	 * For-read threads as below are using device_list_mutex:
+	 * - Readonly scrub btrfs_scrub_dev()
+	 * - Readonly scrub btrfs_scrub_progress()
+	 * - btrfs_get_dev_stats()
+	 */
+	lockdep_assert_held(&fs_devices->device_list_mutex);
+
 	list_splice_init_rcu(&fs_devices->devices, &seed_devices->devices,
 			      synchronize_rcu);
 	list_for_each_entry(device, &seed_devices->devices, dev_list)
@@ -2585,13 +2613,10 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
-	mutex_unlock(&fs_devices->device_list_mutex);
 
 	super_flags = btrfs_super_flags(disk_super) &
 		      ~BTRFS_SUPER_FLAG_SEEDING;
 	btrfs_set_super_flags(disk_super, super_flags);
-
-	return 0;
 }
 
 /*
@@ -2682,6 +2707,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	struct super_block *sb = fs_info->sb;
 	struct rcu_string *name;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_fs_devices *seed_devices;
 	u64 orig_super_total_bytes;
 	u64 orig_super_num_devices;
 	int seeding_dev = 0;
@@ -2765,18 +2791,25 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	if (seeding_dev) {
 		btrfs_clear_sb_rdonly(sb);
-		ret = btrfs_prepare_sprout(fs_info);
-		if (ret) {
+
+		/* GFP_KERNEL allocation must not be under device_list_mutex */
+		seed_devices = btrfs_init_sprout(fs_info);
+		if (IS_ERR(seed_devices)) {
+			ret = PTR_ERR(seed_devices);
 			btrfs_abort_transaction(trans, ret);
 			goto error_trans;
 		}
+	}
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	if (seeding_dev) {
+		btrfs_setup_sprout(fs_info, seed_devices);
 		btrfs_assign_next_active_device(fs_info->fs_devices->latest_dev,
 						device);
 	}
 
 	device->fs_devices = fs_devices;
 
-	mutex_lock(&fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
 	list_add_rcu(&device->dev_list, &fs_devices->devices);
 	list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
@@ -2838,7 +2871,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 		/*
 		 * fs_devices now represents the newly sprouted filesystem and
-		 * its fsid has been changed by btrfs_prepare_sprout
+		 * its fsid has been changed by btrfs_sprout_splice().
 		 */
 		btrfs_sysfs_update_sprout_fsid(fs_devices);
 	}
-- 
2.53.0



