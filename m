Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A49C3921EB;
	Wed, 21 Jan 2026 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019634; cv=none; b=Epehvks5z3GkL+wmfSSyBeiMNd4z4+kHScCCLCkW/i7ToG9TdkZ+Kg2F08MTJhIv+B1ktPE9k323dBvjeyS0Rq3cPkS/0RqHAhh8zbARwgX6FNnDCmWKMB762eXiwuZlN0TEWJVQDs1aZz7CTcZ/H4YiT5HhSCbKWDS6Y8ijaqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019634; c=relaxed/simple;
	bh=RWGv7VYoT+GWeU7vZuo3AUnxMJe/GVeqfhUCmVSW6IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxCuJovPgXqTfXHrDatRrYFBPNiN/dTjSGRNp1/h2QDu9qibOIqIn0dlAIap74az+API969dC/7fSk71s/LFJG7DZ3qMXFY9SdRuicGcBEKbmDoizKJ7aqmXKYVHsZeQwh2JGiAHBqOHN8M0WJ56IpWZpEAsyvtSbIXct3euxvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgYQBCSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgYQBCSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E42C4CEF1;
	Wed, 21 Jan 2026 18:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019633;
	bh=RWGv7VYoT+GWeU7vZuo3AUnxMJe/GVeqfhUCmVSW6IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgYQBCSJ8PMc9dEVQPtLTKZFCo2rSfTwxlOdCiXSwMPee+9fF00Xa1plun5ryJfH6
	 FFHRx2cbkxsqWo0j8wB6R+XWcx8mYF2hsPcdt28YtftT5I2T3WfDVM4SqSw9mAauB2
	 If0PuftslEenCL8nzmuPnLI9XTePUYy4lf++JW9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/139] btrfs: introduce btrfs_space_info sub-group
Date: Wed, 21 Jan 2026 19:14:37 +0100
Message-ID: <20260121181412.504734472@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit f92ee31e031c7819126d2febdda0c3e91f5d2eb9 ]

Current code assumes we have only one space_info for each block group type
(DATA, METADATA, and SYSTEM). We sometime need multiple space infos to
manage special block groups.

One example is handling the data relocation block group for the zoned mode.
That block group is dedicated for writing relocated data and we cannot
allocate any regular extent from that block group, which is implemented in
the zoned extent allocator. This block group still belongs to the normal
data space_info. So, when all the normal data block groups are full and
there is some free space in the dedicated block group, the space_info
looks to have some free space, while it cannot allocate normal extent
anymore. That results in a strange ENOSPC error. We need to have a
space_info for the relocation data block group to represent the situation
properly.

Adds a basic infrastructure for having a "sub-group" of a space_info:
creation and removing. A sub-group space_info belongs to one of the
primary space_infos and has the same flags as its parent.

This commit first introduces the relocation data sub-space_info, and the
next commit will introduce tree-log sub-space_info. In the future, it could
be useful to implement tiered storage for btrfs e.g. by implementing a
sub-group space_info for block groups resides on a fast storage.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: a11224a016d6 ("btrfs: fix memory leaks in create_space_info() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 11 +++++++++++
 fs/btrfs/space-info.c  | 44 +++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/space-info.h  |  9 +++++++++
 fs/btrfs/sysfs.c       | 18 ++++++++++++++---
 4 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8dce7046940c4..c3aec02bf199e 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4420,6 +4420,17 @@ static void check_removing_space_info(struct btrfs_space_info *space_info)
 {
 	struct btrfs_fs_info *info = space_info->fs_info;
 
+	if (space_info->subgroup_id == BTRFS_SUB_GROUP_PRIMARY) {
+		/* This is a top space_info, proceed with its children first. */
+		for (int i = 0; i < BTRFS_SPACE_INFO_SUB_GROUP_MAX; i++) {
+			if (space_info->sub_group[i]) {
+				check_removing_space_info(space_info->sub_group[i]);
+				kfree(space_info->sub_group[i]);
+				space_info->sub_group[i] = NULL;
+			}
+		}
+	}
+
 	/*
 	 * Do not hide this behind enospc_debug, this is actually important and
 	 * indicates a real bug if this happens.
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 6497398fb4e2e..9d47678875b76 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -240,16 +240,44 @@ static void init_space_info(struct btrfs_fs_info *info,
 	INIT_LIST_HEAD(&space_info->priority_tickets);
 	space_info->clamp = 1;
 	btrfs_update_space_info_chunk_size(space_info, calc_chunk_size(info, flags));
+	space_info->subgroup_id = BTRFS_SUB_GROUP_PRIMARY;
 
 	if (btrfs_is_zoned(info))
 		space_info->bg_reclaim_threshold = BTRFS_DEFAULT_ZONED_RECLAIM_THRESH;
 }
 
+static int create_space_info_sub_group(struct btrfs_space_info *parent, u64 flags,
+				       enum btrfs_space_info_sub_group id, int index)
+{
+	struct btrfs_fs_info *fs_info = parent->fs_info;
+	struct btrfs_space_info *sub_group;
+	int ret;
+
+	ASSERT(parent->subgroup_id == BTRFS_SUB_GROUP_PRIMARY);
+	ASSERT(id != BTRFS_SUB_GROUP_PRIMARY);
+
+	sub_group = kzalloc(sizeof(*sub_group), GFP_NOFS);
+	if (!sub_group)
+		return -ENOMEM;
+
+	init_space_info(fs_info, sub_group, flags);
+	parent->sub_group[index] = sub_group;
+	sub_group->parent = parent;
+	sub_group->subgroup_id = id;
+
+	ret = btrfs_sysfs_add_space_info_type(fs_info, sub_group);
+	if (ret) {
+		kfree(sub_group);
+		parent->sub_group[index] = NULL;
+	}
+	return ret;
+}
+
 static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 {
 
 	struct btrfs_space_info *space_info;
-	int ret;
+	int ret = 0;
 
 	space_info = kzalloc(sizeof(*space_info), GFP_NOFS);
 	if (!space_info)
@@ -257,6 +285,15 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 
 	init_space_info(info, space_info, flags);
 
+	if (btrfs_is_zoned(info)) {
+		if (flags & BTRFS_BLOCK_GROUP_DATA)
+			ret = create_space_info_sub_group(space_info, flags,
+							  BTRFS_SUB_GROUP_DATA_RELOC,
+							  0);
+		if (ret)
+			return ret;
+	}
+
 	ret = btrfs_sysfs_add_space_info_type(info, space_info);
 	if (ret)
 		return ret;
@@ -554,8 +591,9 @@ static void __btrfs_dump_space_info(const struct btrfs_fs_info *fs_info,
 	lockdep_assert_held(&info->lock);
 
 	/* The free space could be negative in case of overcommit */
-	btrfs_info(fs_info, "space_info %s has %lld free, is %sfull",
-		   flag_str,
+	btrfs_info(fs_info,
+		   "space_info %s (sub-group id %d) has %lld free, is %sfull",
+		   flag_str, info->subgroup_id,
 		   (s64)(info->total_bytes - btrfs_space_info_used(info, true)),
 		   info->full ? "" : "not ");
 	btrfs_info(fs_info,
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index efbecc0c5258d..12c337b473870 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -93,8 +93,17 @@ enum btrfs_flush_state {
 	COMMIT_TRANS		= 11,
 };
 
+enum btrfs_space_info_sub_group {
+	BTRFS_SUB_GROUP_PRIMARY,
+	BTRFS_SUB_GROUP_DATA_RELOC,
+};
+
+#define BTRFS_SPACE_INFO_SUB_GROUP_MAX 1
 struct btrfs_space_info {
 	struct btrfs_fs_info *fs_info;
+	struct btrfs_space_info *parent;
+	struct btrfs_space_info *sub_group[BTRFS_SPACE_INFO_SUB_GROUP_MAX];
+	int subgroup_id;
 	spinlock_t lock;
 
 	u64 total_bytes;	/* total bytes in the space,
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 5912d50577666..ea13e3eee7d90 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1792,16 +1792,28 @@ void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info)
 	kobject_put(&space_info->kobj);
 }
 
-static const char *alloc_name(u64 flags)
+static const char *alloc_name(struct btrfs_space_info *space_info)
 {
+	u64 flags = space_info->flags;
+
 	switch (flags) {
 	case BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA:
 		return "mixed";
 	case BTRFS_BLOCK_GROUP_METADATA:
+		ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_PRIMARY);
 		return "metadata";
 	case BTRFS_BLOCK_GROUP_DATA:
-		return "data";
+		switch (space_info->subgroup_id) {
+		case BTRFS_SUB_GROUP_PRIMARY:
+			return "data";
+		case BTRFS_SUB_GROUP_DATA_RELOC:
+			return "data-reloc";
+		default:
+			WARN_ON_ONCE(1);
+			return "data (unknown sub-group)";
+		}
 	case BTRFS_BLOCK_GROUP_SYSTEM:
+		ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_PRIMARY);
 		return "system";
 	default:
 		WARN_ON(1);
@@ -1820,7 +1832,7 @@ int btrfs_sysfs_add_space_info_type(struct btrfs_fs_info *fs_info,
 
 	ret = kobject_init_and_add(&space_info->kobj, &space_info_ktype,
 				   fs_info->space_info_kobj, "%s",
-				   alloc_name(space_info->flags));
+				   alloc_name(space_info));
 	if (ret) {
 		kobject_put(&space_info->kobj);
 		return ret;
-- 
2.51.0



