Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E07711707
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13792C433C7;
	Mon, 21 Aug 2023 19:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647630;
	bh=CUZD7TBM3P1i3AxAF/t3wheuUBTPNyI/BHB5gGLqoGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZjhl0B/AMlRoPc6dlhj0x57OuVDY6RZIYjr02nWErZ/jBxbXEaQS3C0MdMtoJHm2
	 GMzjQi9yM8tStgC2wi4G67QT9pxytbJbrLieb9zNqVzzIdSmD/VgRnbDEkJL5slcuO
	 AW/ftFw1ANmCc8y3rhOOltWSm1oImqXr80foiGJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/194] btrfs: convert btrfs_block_group::seq_zone to runtime flag
Date: Mon, 21 Aug 2023 21:41:01 +0200
Message-ID: <20230821194126.368061758@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Sterba <dsterba@suse.com>

[ Upstream commit 961f5b8bf48a463ac5fe5b13143426d79eb41817 ]

In zoned mode the sequential status of zone can be also tracked in the
runtime flags of block group.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 0657b20c5a76 ("btrfs: fix use-after-free of new block group that became unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.h | 5 ++---
 fs/btrfs/zoned.c       | 7 ++++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index dcad5e959b920..fb4f4901350bd 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -57,6 +57,8 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
 	/* Does the block group need to be added to the free space tree? */
 	BLOCK_GROUP_FLAG_NEEDS_FREE_SPACE,
+	/* Indicate that the block group is placed on a sequential zone */
+	BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE,
 };
 
 enum btrfs_caching_type {
@@ -206,9 +208,6 @@ struct btrfs_block_group {
 	/* Lock for free space tree operations. */
 	struct mutex free_space_lock;
 
-	/* Flag indicating this block group is placed on a sequential zone */
-	bool seq_zone;
-
 	/*
 	 * Number of extents in this block group used for swap files.
 	 * All accesses protected by the spinlock 'lock'.
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 836babd23db52..9bc7ac06c5177 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1436,7 +1436,7 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (num_sequential > 0)
-		cache->seq_zone = true;
+		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 
 	if (num_conventional > 0) {
 		/* Zone capacity is always zone size in emulation */
@@ -1658,7 +1658,7 @@ bool btrfs_use_zone_append(struct btrfs_inode *inode, u64 start)
 	if (!cache)
 		return false;
 
-	ret = cache->seq_zone;
+	ret = !!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 	btrfs_put_block_group(cache);
 
 	return ret;
@@ -2177,7 +2177,8 @@ static void btrfs_zone_finish_endio_workfn(struct work_struct *work)
 void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb)
 {
-	if (!bg->seq_zone || eb->start + eb->len * 2 <= bg->start + bg->zone_capacity)
+	if (!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags) ||
+	    eb->start + eb->len * 2 <= bg->start + bg->zone_capacity)
 		return;
 
 	if (WARN_ON(bg->zone_finish_work.func == btrfs_zone_finish_endio_workfn)) {
-- 
2.40.1



