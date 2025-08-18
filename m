Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214B032253B;
	Mon, 18 Aug 2025 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526303; cv=none; b=fymRtOg6bHRj+RXsOiVRymW1/1EHf6E2o+Spg+MsbFKCJ2a0K2eW1n9QC2qTRUZo9DNyrkaGpGlSHRFX0ddyh1zZtev4IyqPO+24Rf1JbcxwOxd40u9GeYf13RaZl0U1fhPyJN4C5+XDgQd9h+zI4N2kF1ALvyGetf36/0RK0mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526303; c=relaxed/simple;
	bh=Oe5huPtc//1F25GPxDcZdu8XS3KQg7Y2LpXoEca92lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5VoPX96Aophwbt5W9ak5SdKcz41wztDYQYUi97Es6qplkF9cldh1vDYEwG9tsgJJQtNxeaIotCwswAIO66vHKZQny+DYdxqqGbGKIsuW+XX8ErMob9QvUv1g5togveh/cu8jO0hCVi61X8vWpL8GKiAkapzNB6J/1B3M3Or27E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TykwtZQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TykwtZQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9844DC4CEEB;
	Mon, 18 Aug 2025 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526303;
	bh=Oe5huPtc//1F25GPxDcZdu8XS3KQg7Y2LpXoEca92lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TykwtZQg/n2j1V7+nG58ZYLuX/LHxZwz8rxeTRlv7I5pj5kLQWG8I7XW1ccmlrlWz
	 oDGxym1SDfdNdCBdRG8H6eEbMtW4bNyB3nc/HVxCEwXgN+vEWBBqynZ0mFWhXxui8e
	 qGKR9immK6eINevhjpFZyfBAKeM2dKP1IXdBeRHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 514/570] btrfs: zoned: reserve data_reloc block group on mount
Date: Mon, 18 Aug 2025 14:48:21 +0200
Message-ID: <20250818124525.661333667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 694ce5e143d67267ad26b04463e790a597500b00 upstream.

Create a block group dedicated for data relocation on mount of a zoned
filesystem.

If there is already more than one empty DATA block group on mount, this
one is picked for the data relocation block group, instead of a newly
created one.

This is done to ensure, there is always space for performing garbage
collection and the filesystem is not hitting ENOSPC under heavy overwrite
workloads.

CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    1 
 fs/btrfs/zoned.c   |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h   |    3 ++
 3 files changed, 65 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3561,6 +3561,7 @@ int __cold open_ctree(struct super_block
 		goto fail_sysfs;
 	}
 
+	btrfs_zoned_reserve_data_reloc_bg(fs_info);
 	btrfs_free_zone_cache(fs_info);
 
 	btrfs_check_active_zone_reservation(fs_info);
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -17,6 +17,7 @@
 #include "fs.h"
 #include "accessors.h"
 #include "bio.h"
+#include "transaction.h"
 
 /* Maximum number of zones to report per blkdev_report_zones() call */
 #define BTRFS_REPORT_NR_ZONES   4096
@@ -2501,6 +2502,66 @@ void btrfs_clear_data_reloc_bg(struct bt
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *space_info = data_sinfo->sub_group[0];
+	struct btrfs_trans_handle *trans;
+	struct btrfs_block_group *bg;
+	struct list_head *bg_list;
+	u64 alloc_flags;
+	bool initial = false;
+	bool did_chunk_alloc = false;
+	int index;
+	int ret;
+
+	if (!btrfs_is_zoned(fs_info))
+		return;
+
+	if (fs_info->data_reloc_bg)
+		return;
+
+	if (sb_rdonly(fs_info->sb))
+		return;
+
+	ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC);
+	alloc_flags = btrfs_get_alloc_profile(fs_info, space_info->flags);
+	index = btrfs_bg_flags_to_raid_index(alloc_flags);
+
+	bg_list = &data_sinfo->block_groups[index];
+again:
+	list_for_each_entry(bg, bg_list, list) {
+		if (bg->used > 0)
+			continue;
+
+		if (!initial) {
+			initial = true;
+			continue;
+		}
+
+		fs_info->data_reloc_bg = bg->start;
+		set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+		btrfs_zone_activate(bg);
+
+		return;
+	}
+
+	if (did_chunk_alloc)
+		return;
+
+	trans = btrfs_join_transaction(fs_info->tree_root);
+	if (IS_ERR(trans))
+		return;
+
+	ret = btrfs_chunk_alloc(trans, space_info, alloc_flags, CHUNK_ALLOC_FORCE);
+	btrfs_end_transaction(trans);
+	if (ret == 1) {
+		did_chunk_alloc = true;
+		bg_list = &space_info->block_groups[index];
+		goto again;
+	}
+}
+
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -88,6 +88,7 @@ void btrfs_zone_finish_endio(struct btrf
 void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
+void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -241,6 +242,8 @@ static inline void btrfs_schedule_zone_f
 
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
+static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info) { }
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)


