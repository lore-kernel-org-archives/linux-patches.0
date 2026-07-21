Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B5744AB8E;
	Tue, 21 Jul 2026 22:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674346; cv=none; b=My7knWa86y0nXV+I5ppGVHXiMhD3837QYuBkgkXF80QmWdqKqE8s4Jnyu7QIzAK9QhIvp8Zyys/QeWAY90sYIrv32zPbL4C45dRGHQoaLtLUUraZAPKaKyNVBfCa7AmgetmiL/PQ50hghLhrYLEG7VUdEdaDkNPDuBHsfwlOT8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674346; c=relaxed/simple;
	bh=avlnzJm0XBOf9AHeaLNk+9ZT8qjXY/AM6OPz164qWH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpAMnrF/T15sIWx1Kx5DLiyXt18SLQagTkIEYgPJtC5HlEFhgwAmpKZqTFE79MznFstKhvECkv2uT6o/PUDe3M4UAg6BKujRQj0wGl7GIikUSdlFyuqksBZn4kLBbJTqHO8qHaUbx2qcM1czHp09XfIjwUJvwvcjwaNAZFG3ASs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJi6L0lQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJi6L0lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A7F1F000E9;
	Tue, 21 Jul 2026 22:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674344;
	bh=JP1sf1Atv5Cwai0CMPKqj/MtVbt4vWSx3ZAlEFFVko8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJi6L0lQcLe/gpJqGM6u5xOEVCYOox/92TO54u8uhkM7GIG2NNfVcC5q/LruAeDCZ
	 igblBzoP5Ha9keodzsth3B4tr2ezwcdywOR6y6Llv6j6U99Y+ApQaaVmQ2zUbaSixZ
	 oeS/lsnqmZqVRnPwUNBYPldb3Tzf6/LYcQskBGxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 507/699] dm thin metadata: fix metadata snapshot consistency on commit failure
Date: Tue, 21 Jul 2026 17:24:26 +0200
Message-ID: <20260721152407.132126348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

commit 5bcd4d3058ebaf46ad2e163829d87dd4870c7a45 upstream.

__reserve_metadata_snap() and __release_metadata_snap() modify the
superblock's held_root directly in the block_manager's buffer. If the
subsequent metadata commit fails, the held_root gets flushed to disk
through the abort_transaction path, resulting in inconsistent metadata.

Reproducer 1: __reserve_metadata_snap()

1. Create a 2 MiB metadata device and make the region after the 14th
   block inaccessible, to trigger metadata commit failure in the
   subsequent reserve_metadata_snap operation. The 14th block will be
   the shadow destination for the index block.

dmsetup create tmeta --table "0 112 linear /dev/sdc 0
112 3984 error"

2. Create a 16 MiB thin-pool

dmsetup create tdata --table "0 32768 zero"
dd if=/dev/zero of=/dev/mapper/tmeta bs=4k count=1
dmsetup create tpool --table "0 32768 thin-pool /dev/mapper/tmeta \
/dev/mapper/tdata 128 0 1 skip_block_zeroing"

3. Take a metadata snapshot to trigger metadata commit failure and
   transaction abort. However, the held_root is written to disk,
   breaking metadata consistency.

dmsetup message tpool 0 "reserve_metadata_snap"

thin_check v1.2.2 result:

Bad reference count for metadata block 6.  Expected 2, but space map contains 1.
Bad reference count for metadata block 7.  Expected 2, but space map contains 1.
Bad reference count for metadata block 13.  Expected 1, but space map contains 0.

Reproducer 2: __release_metadata_snap()

1. Create a 2 MiB metadata device and make the region after the 16th
   block inaccessible, to trigger metadata commit failure in the
   subsequent release_metadata_snap operation. The 16th block will be
   the shadow destination for the index block.

dmsetup create tmeta --table "0 128 linear /dev/sdc 0
128 3968 error"

2. Create a 16 MiB thin-pool

dmsetup create tdata --table "0 32768 zero"
dd if=/dev/zero of=/dev/mapper/tmeta bs=4k count=1
dmsetup create tpool --table "0 32768 thin-pool /dev/mapper/tmeta \
/dev/mapper/tdata 128 0 1 skip_block_zeroing"

3. Reserve then release the metadata snapshot, to trigger metadata
   commit failure and transaction abort. The held_root gets removed
   from the on-disk superblock, causing inconsistent metadata.

dmsetup message tpool 0 "reserve_metadata_snap"
dmsetup message tpool 0 "release_metadata_snap"

thin_check v1.2.2 result:

Bad reference count for metadata block 6.  Expected 1, but space map contains 2.
Bad reference count for metadata block 7.  Expected 1, but space map contains 2.
1 metadata blocks have leaked.

Fix by deferring the held_root update to commit time.

Additionally, move the existing-snapshot check in __reserve_metadata_snap
before the shadow operation to avoid unnecessary work. In
__release_metadata_snap, clear pmd->held_root before btree deletion so
partial failure leaks blocks rather than leaving a stale reference, and
unlock the snapshot block before decrementing its refcount.

Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Cc: stable@vger.kernel.org
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |   63 ++++++++++++------------------------------
 1 file changed, 18 insertions(+), 45 deletions(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -183,6 +183,7 @@ struct dm_pool_metadata {
 	uint32_t time;
 	dm_block_t root;
 	dm_block_t details_root;
+	dm_block_t held_root;
 	struct list_head thin_devices;
 	uint64_t trans_id;
 	unsigned long flags;
@@ -709,6 +710,7 @@ static int __open_metadata(struct dm_poo
 	 */
 	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
 	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+	pmd->held_root = le64_to_cpu(disk_super->held_root);
 
 	__setup_btree_details(pmd);
 	dm_bm_unlock(sblock);
@@ -792,6 +794,7 @@ static int __begin_transaction(struct dm
 	pmd->time = le32_to_cpu(disk_super->time);
 	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
 	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+	pmd->held_root = le64_to_cpu(disk_super->held_root);
 	pmd->trans_id = le64_to_cpu(disk_super->trans_id);
 	pmd->flags = le32_to_cpu(disk_super->flags);
 	pmd->data_block_size = le32_to_cpu(disk_super->data_block_size);
@@ -882,6 +885,7 @@ static int __commit_transaction(struct d
 	disk_super->time = cpu_to_le32(pmd->time);
 	disk_super->data_mapping_root = cpu_to_le64(pmd->root);
 	disk_super->device_details_root = cpu_to_le64(pmd->details_root);
+	disk_super->held_root = cpu_to_le64(pmd->held_root);
 	disk_super->trans_id = cpu_to_le64(pmd->trans_id);
 	disk_super->flags = cpu_to_le32(pmd->flags);
 
@@ -1288,9 +1292,14 @@ static int __reserve_metadata_snap(struc
 {
 	int r, inc;
 	struct thin_disk_superblock *disk_super;
-	struct dm_block *copy, *sblock;
+	struct dm_block *copy;
 	dm_block_t held_root;
 
+	if (pmd->held_root) {
+		DMWARN("Pool metadata snapshot already exists: release this before taking another.");
+		return -EBUSY;
+	}
+
 	/*
 	 * We commit to ensure the btree roots which we increment in a
 	 * moment are up to date.
@@ -1318,14 +1327,6 @@ static int __reserve_metadata_snap(struc
 	held_root = dm_block_location(copy);
 	disk_super = dm_block_data(copy);
 
-	if (le64_to_cpu(disk_super->held_root)) {
-		DMWARN("Pool metadata snapshot already exists: release this before taking another.");
-
-		dm_tm_dec(pmd->tm, held_root);
-		dm_tm_unlock(pmd->tm, copy);
-		return -EBUSY;
-	}
-
 	/*
 	 * Wipe the spacemap since we're not publishing this.
 	 */
@@ -1341,18 +1342,8 @@ static int __reserve_metadata_snap(struc
 	dm_tm_inc(pmd->tm, le64_to_cpu(disk_super->device_details_root));
 	dm_tm_unlock(pmd->tm, copy);
 
-	/*
-	 * Write the held root into the superblock.
-	 */
-	r = superblock_lock(pmd, &sblock);
-	if (r) {
-		dm_tm_dec(pmd->tm, held_root);
-		return r;
-	}
+	pmd->held_root = held_root;
 
-	disk_super = dm_block_data(sblock);
-	disk_super->held_root = cpu_to_le64(held_root);
-	dm_bm_unlock(sblock);
 	return 0;
 }
 
@@ -1372,18 +1363,10 @@ static int __release_metadata_snap(struc
 {
 	int r;
 	struct thin_disk_superblock *disk_super;
-	struct dm_block *sblock, *copy;
+	struct dm_block *copy;
 	dm_block_t held_root;
 
-	r = superblock_lock(pmd, &sblock);
-	if (r)
-		return r;
-
-	disk_super = dm_block_data(sblock);
-	held_root = le64_to_cpu(disk_super->held_root);
-	disk_super->held_root = cpu_to_le64(0);
-
-	dm_bm_unlock(sblock);
+	held_root = pmd->held_root;
 
 	if (!held_root) {
 		DMWARN("No pool metadata snapshot found: nothing to release.");
@@ -1394,13 +1377,15 @@ static int __release_metadata_snap(struc
 	if (r)
 		return r;
 
+	pmd->held_root = 0;
+
 	disk_super = dm_block_data(copy);
 	dm_btree_del(&pmd->info, le64_to_cpu(disk_super->data_mapping_root));
 	dm_btree_del(&pmd->details_info, le64_to_cpu(disk_super->device_details_root));
-	dm_sm_dec_block(pmd->metadata_sm, held_root);
-
 	dm_tm_unlock(pmd->tm, copy);
 
+	dm_sm_dec_block(pmd->metadata_sm, held_root);
+
 	return 0;
 }
 
@@ -1419,19 +1404,7 @@ int dm_pool_release_metadata_snap(struct
 static int __get_metadata_snap(struct dm_pool_metadata *pmd,
 			       dm_block_t *result)
 {
-	int r;
-	struct thin_disk_superblock *disk_super;
-	struct dm_block *sblock;
-
-	r = dm_bm_read_lock(pmd->bm, THIN_SUPERBLOCK_LOCATION,
-			    &sb_validator, &sblock);
-	if (r)
-		return r;
-
-	disk_super = dm_block_data(sblock);
-	*result = le64_to_cpu(disk_super->held_root);
-
-	dm_bm_unlock(sblock);
+	*result = pmd->held_root;
 
 	return 0;
 }


