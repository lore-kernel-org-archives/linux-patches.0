Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4056581751;
	Wed,  7 Aug 2024 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043453; cv=none; b=KJk9jgQGaQSHymyBXJssf8o52M2i4eZ52VarFtzIQ3p5v/8td7Gz768OLICRzUPI82IaaCTABKznIi7OgBbShAkhkNA3HSFCr9Tes5S4bgF09mMnVvDYifRnd59/GM4DhrY9PcdrPF2B6x7kmwmhHzXJpjnE4xOyqtsIS0l4rvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043453; c=relaxed/simple;
	bh=om8Pkij2CjO7QJlYBM1IsC5uMSACSdLDkiG/p1QeBV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gynUWDQ7XAuezgdEIRrPUL3MZmyeku5p1tP9BNCRrh86TL6EkUwl0NNxIl9RwU6T2Nt+PUXA+tn3YKQ5yE65PHsZepLBf3dCCXpLLAYLIR8N6AbJNLgiw7+KajPjFE6Md+/+X9F0cmnWJcncSqz3X2y/6CrtQGY3YSns9qlmO7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3m9jfEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3m9jfEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FD5C32781;
	Wed,  7 Aug 2024 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043453;
	bh=om8Pkij2CjO7QJlYBM1IsC5uMSACSdLDkiG/p1QeBV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3m9jfEyYw9oVj32aIp+wBwKXntJv5Vw9Gdm44Q9pv6+wpWxcjrkU3Yx8FsC3HcZL
	 BTdF8vcqGrrR7HcHksaVjILTCG3HURqn3653WTSp1juQunZs6ZRXMcBKwuFbZVCG7K
	 jDudunbPiRdwOtVf65hoRjXuVMrEnEQw4N1IiW1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 097/121] btrfs: zoned: fix zone_unusable accounting on making block group read-write again
Date: Wed,  7 Aug 2024 17:00:29 +0200
Message-ID: <20240807150022.576335004@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 8cd44dd1d17a23d5cc8c443c659ca57aa76e2fa5 upstream.

When btrfs makes a block group read-only, it adds all free regions in the
block group to space_info->bytes_readonly. That free space excludes
reserved and pinned regions. OTOH, when btrfs makes the block group
read-write again, it moves all the unused regions into the block group's
zone_unusable. That unused region includes reserved and pinned regions.
As a result, it counts too much zone_unusable bytes.

Fortunately (or unfortunately), having erroneous zone_unusable does not
affect the calculation of space_info->bytes_readonly, because free
space (num_bytes in btrfs_dec_block_group_ro) calculation is done based on
the erroneous zone_unusable and it reduces the num_bytes just to cancel the
error.

This behavior can be easily discovered by adding a WARN_ON to check e.g,
"bg->pinned > 0" in btrfs_dec_block_group_ro(), and running fstests test
case like btrfs/282.

Fix it by properly considering pinned and reserved in
btrfs_dec_block_group_ro(). Also, add a WARN_ON and introduce
btrfs_space_info_update_bytes_zone_unusable() to catch a similar mistake.

Fixes: 169e0da91a21 ("btrfs: zoned: track unusable bytes for zones")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c       |   13 ++++++++-----
 fs/btrfs/extent-tree.c       |    3 ++-
 fs/btrfs/free-space-cache.c  |    4 +++-
 fs/btrfs/space-info.c        |    2 +-
 fs/btrfs/space-info.h        |    1 +
 include/trace/events/btrfs.h |    8 ++++++++
 6 files changed, 23 insertions(+), 8 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1214,8 +1214,8 @@ int btrfs_remove_block_group(struct btrf
 	block_group->space_info->total_bytes -= block_group->length;
 	block_group->space_info->bytes_readonly -=
 		(block_group->length - block_group->zone_unusable);
-	block_group->space_info->bytes_zone_unusable -=
-		block_group->zone_unusable;
+	btrfs_space_info_update_bytes_zone_unusable(fs_info, block_group->space_info,
+						    -block_group->zone_unusable);
 	block_group->space_info->disk_total -= block_group->length * factor;
 
 	spin_unlock(&block_group->space_info->lock);
@@ -1399,7 +1399,8 @@ static int inc_block_group_ro(struct btr
 		if (btrfs_is_zoned(cache->fs_info)) {
 			/* Migrate zone_unusable bytes to readonly */
 			sinfo->bytes_readonly += cache->zone_unusable;
-			sinfo->bytes_zone_unusable -= cache->zone_unusable;
+			btrfs_space_info_update_bytes_zone_unusable(cache->fs_info, sinfo,
+								    -cache->zone_unusable);
 			cache->zone_unusable = 0;
 		}
 		cache->ro++;
@@ -3023,9 +3024,11 @@ void btrfs_dec_block_group_ro(struct btr
 		if (btrfs_is_zoned(cache->fs_info)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable =
-				(cache->alloc_offset - cache->used) +
+				(cache->alloc_offset - cache->used - cache->pinned -
+				 cache->reserved) +
 				(cache->length - cache->zone_capacity);
-			sinfo->bytes_zone_unusable += cache->zone_unusable;
+			btrfs_space_info_update_bytes_zone_unusable(cache->fs_info, sinfo,
+								    cache->zone_unusable);
 			sinfo->bytes_readonly -= cache->zone_unusable;
 		}
 		num_bytes = cache->length - cache->reserved -
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2749,7 +2749,8 @@ static int unpin_extent_range(struct btr
 			readonly = true;
 		} else if (btrfs_is_zoned(fs_info)) {
 			/* Need reset before reusing in a zoned block group */
-			space_info->bytes_zone_unusable += len;
+			btrfs_space_info_update_bytes_zone_unusable(fs_info, space_info,
+								    len);
 			readonly = true;
 		}
 		spin_unlock(&cache->lock);
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2721,8 +2721,10 @@ static int __btrfs_add_free_space_zoned(
 	 * If the block group is read-only, we should account freed space into
 	 * bytes_readonly.
 	 */
-	if (!block_group->ro)
+	if (!block_group->ro) {
 		block_group->zone_unusable += to_unusable;
+		WARN_ON(block_group->zone_unusable > block_group->length);
+	}
 	spin_unlock(&ctl->tree_lock);
 	if (!used) {
 		spin_lock(&block_group->lock);
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -312,7 +312,7 @@ void btrfs_add_bg_to_space_info(struct b
 	found->bytes_used += block_group->used;
 	found->disk_used += block_group->used * factor;
 	found->bytes_readonly += block_group->bytes_super;
-	found->bytes_zone_unusable += block_group->zone_unusable;
+	btrfs_space_info_update_bytes_zone_unusable(info, found, block_group->zone_unusable);
 	if (block_group->length > 0)
 		found->full = 0;
 	btrfs_try_granting_tickets(info, found);
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -197,6 +197,7 @@ btrfs_space_info_update_##name(struct bt
 
 DECLARE_SPACE_INFO_UPDATE(bytes_may_use, "space_info");
 DECLARE_SPACE_INFO_UPDATE(bytes_pinned, "pinned");
+DECLARE_SPACE_INFO_UPDATE(bytes_zone_unusable, "zone_unusable");
 
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
 void btrfs_add_bg_to_space_info(struct btrfs_fs_info *info,
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -2430,6 +2430,14 @@ DEFINE_EVENT(btrfs__space_info_update, u
 	TP_ARGS(fs_info, sinfo, old, diff)
 );
 
+DEFINE_EVENT(btrfs__space_info_update, update_bytes_zone_unusable,
+
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 const struct btrfs_space_info *sinfo, u64 old, s64 diff),
+
+	TP_ARGS(fs_info, sinfo, old, diff)
+);
+
 DECLARE_EVENT_CLASS(btrfs_raid56_bio,
 
 	TP_PROTO(const struct btrfs_raid_bio *rbio,


