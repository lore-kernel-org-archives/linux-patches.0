Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B556079DD;
	Sat, 30 Dec 2023 12:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6992NIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F83AC433C8;
	Sat, 30 Dec 2023 12:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938269;
	bh=BHA0tbombgZpCzYdfiN18HXvZacHseU1xNMDzo0VVPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6992NIVuFyAhTOIQcPBgQ98ANQ5Fu6vEltadOSTF6hl5CTbysSWhM3gyZsHxB9MH
	 me6U87oeqCeMsIDlrnPx8Re24A7yd8Oodie/7U3QLVM6rNw5v1/0U+IDO5VUB+BUiH
	 ROXEbzvcD4m6hAy9mJszcGlTDPlzyAqGBOe22slE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/112] btrfs: zoned: no longer count fresh BG region as zone unusable
Date: Sat, 30 Dec 2023 12:00:05 +0000
Message-ID: <20231230115809.768207268@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 6a8ebc773ef64c8f12d6d60fd6e53d5ccc81314b ]

Now that we switched to write time activation, we no longer need to (and
must not) count the fresh region as zone unusable. This commit is similar
to revert of commit fa2068d7e922b434eb ("btrfs: zoned: count fresh BG
region as zone unusable").

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c |  8 +-------
 fs/btrfs/zoned.c            | 26 +++-----------------------
 2 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4cd8e44cba4c5..b27795e13ff31 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2685,13 +2685,8 @@ static int __btrfs_add_free_space_zoned(struct btrfs_block_group *block_group,
 		bg_reclaim_threshold = READ_ONCE(sinfo->bg_reclaim_threshold);
 
 	spin_lock(&ctl->tree_lock);
-	/* Count initial region as zone_unusable until it gets activated. */
 	if (!used)
 		to_free = size;
-	else if (initial &&
-		 test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &block_group->fs_info->flags) &&
-		 (block_group->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
-		to_free = 0;
 	else if (initial)
 		to_free = block_group->zone_capacity;
 	else if (offset >= block_group->alloc_offset)
@@ -2719,8 +2714,7 @@ static int __btrfs_add_free_space_zoned(struct btrfs_block_group *block_group,
 	reclaimable_unusable = block_group->zone_unusable -
 			       (block_group->length - block_group->zone_capacity);
 	/* All the region is now unusable. Mark it as unused and reclaim */
-	if (block_group->zone_unusable == block_group->length &&
-	    block_group->alloc_offset) {
+	if (block_group->zone_unusable == block_group->length) {
 		btrfs_mark_bg_unused(block_group);
 	} else if (bg_reclaim_threshold &&
 		   reclaimable_unusable >=
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 675dbed075d8e..99cb690da9893 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1574,19 +1574,9 @@ void btrfs_calc_zone_unusable(struct btrfs_block_group *cache)
 		return;
 
 	WARN_ON(cache->bytes_super != 0);
-
-	/* Check for block groups never get activated */
-	if (test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &cache->fs_info->flags) &&
-	    cache->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM) &&
-	    !test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags) &&
-	    cache->alloc_offset == 0) {
-		unusable = cache->length;
-		free = 0;
-	} else {
-		unusable = (cache->alloc_offset - cache->used) +
-			   (cache->length - cache->zone_capacity);
-		free = cache->zone_capacity - cache->alloc_offset;
-	}
+	unusable = (cache->alloc_offset - cache->used) +
+		   (cache->length - cache->zone_capacity);
+	free = cache->zone_capacity - cache->alloc_offset;
 
 	/* We only need ->free_space in ALLOC_SEQ block groups */
 	cache->cached = BTRFS_CACHE_FINISHED;
@@ -1882,7 +1872,6 @@ struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
-	struct btrfs_space_info *space_info = block_group->space_info;
 	struct map_lookup *map;
 	struct btrfs_device *device;
 	u64 physical;
@@ -1894,7 +1883,6 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 
 	map = block_group->physical_map;
 
-	spin_lock(&space_info->lock);
 	spin_lock(&block_group->lock);
 	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags)) {
 		ret = true;
@@ -1923,14 +1911,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 
 	/* Successfully activated all the zones */
 	set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags);
-	WARN_ON(block_group->alloc_offset != 0);
-	if (block_group->zone_unusable == block_group->length) {
-		block_group->zone_unusable = block_group->length - block_group->zone_capacity;
-		space_info->bytes_zone_unusable -= block_group->zone_capacity;
-	}
 	spin_unlock(&block_group->lock);
-	btrfs_try_granting_tickets(fs_info, space_info);
-	spin_unlock(&space_info->lock);
 
 	/* For the active block group list */
 	btrfs_get_block_group(block_group);
@@ -1943,7 +1924,6 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 
 out_unlock:
 	spin_unlock(&block_group->lock);
-	spin_unlock(&space_info->lock);
 	return ret;
 }
 
-- 
2.43.0



