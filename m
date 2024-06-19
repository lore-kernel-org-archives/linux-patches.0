Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23FB13DDC0;
	Wed, 19 Jun 2024 13:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804068; cv=none; b=hNmOGvYd9LZhbi5jE4RkghDhJ5F85C0uo8KGS7sErmMa3Q66D+mhmpP7LT5A4lkfpqNAiTT3hD+smXaDVBgimLxSVQqrSrB0iSWSvDEUuxHUxbvKDC+kG4oMNggaNiYmdVw1aZg+SdZ+o8w5nEeClqx/do2JGElX3MGInLPdCU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804068; c=relaxed/simple;
	bh=bei5RIhcBRpuFB6iBmELw8A+80lj/U5x1cNCXWyIFpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgraRLGBDlWha2a7QQxZG2sA1MCf0m8lP/6+fBlmIh2IqcXqk1+OOreOpV0Wq6dxH+iHgJO4ZKwnhwSYz9FoirqJgv0rgiU3SH93SCwUwWHRwNA/KOiBsd7USfK2FnIl4lY6qs2LW2uOyQyLcaA0GKz8X+7n3zPUAKvti31nRk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsoAHJLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsoAHJLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571EBC2BBFC;
	Wed, 19 Jun 2024 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804068;
	bh=bei5RIhcBRpuFB6iBmELw8A+80lj/U5x1cNCXWyIFpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsoAHJLzx4fA+eocQGsLU001BfNiouqFPKnpCREIj7uSegbRhV70/pCtTIq76Dyeq
	 fMrHZ7TGAUx8YRN+9Rbg0UVyJOH3MSCJP29OivuOks8g5C7o+UkZVqzn6d1mMGizkI
	 FYwSI/Wh64oPi/7ur8mlUAQarVJc0Sqk8f5UXyPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 197/217] btrfs: zoned: factor out DUP bg handling from btrfs_load_block_group_zone_info
Date: Wed, 19 Jun 2024 14:57:20 +0200
Message-ID: <20240619125604.286005585@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 87463f7e0250d471fac41e7c9c45ae21d83b5f85 upstream.

Split the code handling a type DUP block group from
btrfs_load_block_group_zone_info to make the code more readable.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   79 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 37 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1380,6 +1380,47 @@ static int btrfs_load_block_group_single
 	return 0;
 }
 
+static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
+				      struct map_lookup *map,
+				      struct zone_info *zone_info,
+				      unsigned long *active)
+{
+	if (map->type & BTRFS_BLOCK_GROUP_DATA) {
+		btrfs_err(bg->fs_info,
+			  "zoned: profile DUP not yet supported on data bg");
+		return -EINVAL;
+	}
+
+	if (zone_info[0].alloc_offset == WP_MISSING_DEV) {
+		btrfs_err(bg->fs_info,
+			  "zoned: cannot recover write pointer for zone %llu",
+			  zone_info[0].physical);
+		return -EIO;
+	}
+	if (zone_info[1].alloc_offset == WP_MISSING_DEV) {
+		btrfs_err(bg->fs_info,
+			  "zoned: cannot recover write pointer for zone %llu",
+			  zone_info[1].physical);
+		return -EIO;
+	}
+	if (zone_info[0].alloc_offset != zone_info[1].alloc_offset) {
+		btrfs_err(bg->fs_info,
+			  "zoned: write pointer offset mismatch of zones in DUP profile");
+		return -EIO;
+	}
+
+	if (test_bit(0, active) != test_bit(1, active)) {
+		if (!btrfs_zone_activate(bg))
+			return -EIO;
+	} else if (test_bit(0, active)) {
+		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+	}
+
+	bg->alloc_offset = zone_info[0].alloc_offset;
+	bg->zone_capacity = min(zone_info[0].capacity, zone_info[1].capacity);
+	return 0;
+}
+
 int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
@@ -1469,43 +1510,7 @@ int btrfs_load_block_group_zone_info(str
 		ret = btrfs_load_block_group_single(cache, &zone_info[0], active);
 		break;
 	case BTRFS_BLOCK_GROUP_DUP:
-		if (map->type & BTRFS_BLOCK_GROUP_DATA) {
-			btrfs_err(fs_info, "zoned: profile DUP not yet supported on data bg");
-			ret = -EINVAL;
-			goto out;
-		}
-		if (zone_info[0].alloc_offset == WP_MISSING_DEV) {
-			btrfs_err(fs_info,
-			"zoned: cannot recover write pointer for zone %llu",
-				zone_info[0].physical);
-			ret = -EIO;
-			goto out;
-		}
-		if (zone_info[1].alloc_offset == WP_MISSING_DEV) {
-			btrfs_err(fs_info,
-			"zoned: cannot recover write pointer for zone %llu",
-				zone_info[1].physical);
-			ret = -EIO;
-			goto out;
-		}
-		if (zone_info[0].alloc_offset != zone_info[1].alloc_offset) {
-			btrfs_err(fs_info,
-			"zoned: write pointer offset mismatch of zones in DUP profile");
-			ret = -EIO;
-			goto out;
-		}
-		if (test_bit(0, active) != test_bit(1, active)) {
-			if (!btrfs_zone_activate(cache)) {
-				ret = -EIO;
-				goto out;
-			}
-		} else {
-			if (test_bit(0, active))
-				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
-					&cache->runtime_flags);
-		}
-		cache->alloc_offset = zone_info[0].alloc_offset;
-		cache->zone_capacity = min(zone_info[0].capacity, zone_info[1].capacity);
+		ret = btrfs_load_block_group_dup(cache, map, zone_info, active);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID1:
 	case BTRFS_BLOCK_GROUP_RAID0:


