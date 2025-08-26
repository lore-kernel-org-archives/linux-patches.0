Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C601227599;
	Tue, 26 Aug 2025 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207770; cv=none; b=ZVmjMTv+7oGGZFcIrJXrfPO3AgOMMKkioo+5Xp9tfuWFTlYwP2uZ/44ZpqCeMBejOa9x8BCES6EejzUPIfTd8skm/X6PRA6GO8D66KBrRdjNtYefpJYASY7xj7XfcSax+JYVFc2G1vmP6EnHOxWRWZDypMT5r0ia1xPPAt3AfdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207770; c=relaxed/simple;
	bh=YZWPnhNTjowTmlPHfebG01vuJoGwaz3XPGDTWK0LAsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5GHCSWo/tsz/0RB8I3thgUO7uqA+K7nKVDTINDhANHR1XW1dpT3CANr02FJvEMB4jbc1XatVZ9WF4u9GV/eS4xJG+bOvA/YukjuGAFj28+WNtTHAbQl4b7QR571iyslpDldZONp5upe/w+Q5SdFpkX9qJZbl3lznlGtOB8XoqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpF6o3I0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpF6o3I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30C3C4CEF1;
	Tue, 26 Aug 2025 11:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207770;
	bh=YZWPnhNTjowTmlPHfebG01vuJoGwaz3XPGDTWK0LAsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpF6o3I0VR5kSMS5UZ3+tF4NUP+WD93+f3KcOZ6sDsMOntfmdh96xgvusobIgIPdw
	 Slds1K3Exu9gdNjQpZmcg3NV+or1n4uQ+OewL5FjIMXJSgl8hRyrNrRzjbyVUOXDB0
	 zKbAQYO4I+I33cGisGY8UJIbFp77LE3Il3N4dUc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 283/457] btrfs: zoned: fix data relocation block group reservation
Date: Tue, 26 Aug 2025 13:09:27 +0200
Message-ID: <20250826110944.372048240@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit daa0fde322350b467bc62bc1b141bf62df6123f8 ]

btrfs_zoned_reserve_data_reloc_bg() is called on mount and at that point,
all data block groups belong to the primary data space_info. So, we don't
find anything in the data relocation space_info.

Also, the condition "bg->used > 0" can select a block group with full of
zone_unusable bytes for the candidate. As we cannot allocate from the block
group, it is useless to reserve it as the data relocation block group.

Furthermore, because of the space_info separation, we need to migrate the
selected block group to the data relocation space_info. If not, the extent
allocator cannot use the block group to do the allocation.

This commit fixes these three issues.

Fixes: e606ff985ec7 ("btrfs: zoned: reserve data_reloc block group on mount")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 55 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 936448b1f716..af5ba3ad2eb8 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -18,6 +18,7 @@
 #include "accessors.h"
 #include "bio.h"
 #include "transaction.h"
+#include "sysfs.h"
 
 /* Maximum number of zones to report per blkdev_report_zones() call */
 #define BTRFS_REPORT_NR_ZONES   4096
@@ -2510,12 +2511,12 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
-	struct btrfs_space_info *space_info = data_sinfo->sub_group[0];
+	struct btrfs_space_info *space_info = data_sinfo;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_block_group *bg;
 	struct list_head *bg_list;
 	u64 alloc_flags;
-	bool initial = false;
+	bool first = true;
 	bool did_chunk_alloc = false;
 	int index;
 	int ret;
@@ -2529,21 +2530,52 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	if (sb_rdonly(fs_info->sb))
 		return;
 
-	ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC);
 	alloc_flags = btrfs_get_alloc_profile(fs_info, space_info->flags);
 	index = btrfs_bg_flags_to_raid_index(alloc_flags);
 
-	bg_list = &data_sinfo->block_groups[index];
+	/* Scan the data space_info to find empty block groups. Take the second one. */
 again:
+	bg_list = &space_info->block_groups[index];
 	list_for_each_entry(bg, bg_list, list) {
-		if (bg->used > 0)
+		if (bg->alloc_offset != 0)
 			continue;
 
-		if (!initial) {
-			initial = true;
+		if (first) {
+			first = false;
 			continue;
 		}
 
+		if (space_info == data_sinfo) {
+			/* Migrate the block group to the data relocation space_info. */
+			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
+			int factor;
+
+			ASSERT(reloc_sinfo->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC);
+			factor = btrfs_bg_type_to_factor(bg->flags);
+
+			down_write(&space_info->groups_sem);
+			list_del_init(&bg->list);
+			/* We can assume this as we choose the second empty one. */
+			ASSERT(!list_empty(&space_info->block_groups[index]));
+			up_write(&space_info->groups_sem);
+
+			spin_lock(&space_info->lock);
+			space_info->total_bytes -= bg->length;
+			space_info->disk_total -= bg->length * factor;
+			/* There is no allocation ever happened. */
+			ASSERT(bg->used == 0);
+			ASSERT(bg->zone_unusable == 0);
+			/* No super block in a block group on the zoned setup. */
+			ASSERT(bg->bytes_super == 0);
+			spin_unlock(&space_info->lock);
+
+			bg->space_info = reloc_sinfo;
+			if (reloc_sinfo->block_group_kobjs[index] == NULL)
+				btrfs_sysfs_add_block_group_type(bg);
+
+			btrfs_add_bg_to_space_info(fs_info, bg);
+		}
+
 		fs_info->data_reloc_bg = bg->start;
 		set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
 		btrfs_zone_activate(bg);
@@ -2558,11 +2590,18 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	if (IS_ERR(trans))
 		return;
 
+	/* Allocate new BG in the data relocation space_info. */
+	space_info = data_sinfo->sub_group[0];
+	ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC);
 	ret = btrfs_chunk_alloc(trans, space_info, alloc_flags, CHUNK_ALLOC_FORCE);
 	btrfs_end_transaction(trans);
 	if (ret == 1) {
+		/*
+		 * We allocated a new block group in the data relocation space_info. We
+		 * can take that one.
+		 */
+		first = false;
 		did_chunk_alloc = true;
-		bg_list = &space_info->block_groups[index];
 		goto again;
 	}
 }
-- 
2.50.1



