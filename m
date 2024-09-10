Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2032E18C90B;
	Tue, 10 Sep 2024 09:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961479; cv=none; b=iXqJG5clWzaKU54W1HaeVJOAw31yhlLnr8bFJKg8jrDVtEw06muP6hNaudWmIALHOg7fHeZT6UFqEOzkHK86pvUfVbZCi1qVwKr64gXF204WxW+NY2rIi91B9W6pyuifYi2IRXZECt+2VOlrO5P1kXs9x4RZCVJUBjF/uS2ey+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961479; c=relaxed/simple;
	bh=xWKT/mh8p6g+URRHFxLj7nZcYMt/5c7NGwzmN4xMKTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enY64IXe8Zqgf2a6ago4cnXocLUfdXSLn8+0bdLIw2pffaXsgtaNwEIVb/bBxXx1sb4OgS5lrIXJ2fQWcEr+gOVAKpXUfFWZp5HNz8jjkTaseuqcn5HXzWV3IyKpyMm+OICBDJVbMGixBOAgwIf5VNOsPRBM5hzTLx1DgQQ0TOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvBfI/O5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvBfI/O5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94736C4CEC3;
	Tue, 10 Sep 2024 09:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961479;
	bh=xWKT/mh8p6g+URRHFxLj7nZcYMt/5c7NGwzmN4xMKTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvBfI/O5g87OP/6t3piAvIC8XZItm566H4GejU3Gy5gunl1zY9bQ+3SvZVWQSy+fv
	 Hbo5wRYEzBXAXFU/F5KHfVrjWSDoyPxPBW7u/nqYuR8bTDhdjXTeLd5eXalyemcZ5u
	 E1X615+mSPmMH8OaqevxHLt9v4PPDIdFGYJNhV2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HAN Yuwei <hrx@bupt.moe>,
	Xuefer <xuefer@gmail.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 084/375] btrfs: zoned: handle broken write pointer on zones
Date: Tue, 10 Sep 2024 11:28:01 +0200
Message-ID: <20240910092625.058445989@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit b1934cd6069538db2255dc94ba573771ecf3b560 upstream.

Btrfs rejects to mount a FS if it finds a block group with a broken write
pointer (e.g, unequal write pointers on two zones of RAID1 block group).
Since such case can happen easily with a power-loss or crash of a system,
we need to handle the case more gently.

Handle such block group by making it unallocatable, so that there will be
no writes into it. That can be done by setting the allocation pointer at
the end of allocating region (= block_group->zone_capacity). Then, existing
code handle zone_unusable properly.

Having proper zone_capacity is necessary for the change. So, set it as fast
as possible.

We cannot handle RAID0 and RAID10 case like this. But, they are anyway
unable to read because of a missing stripe.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.1+
Reported-by: HAN Yuwei <hrx@bupt.moe>
Cc: Xuefer <xuefer@gmail.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1408,6 +1408,8 @@ static int btrfs_load_block_group_dup(st
 		return -EINVAL;
 	}
 
+	bg->zone_capacity = min_not_zero(zone_info[0].capacity, zone_info[1].capacity);
+
 	if (zone_info[0].alloc_offset == WP_MISSING_DEV) {
 		btrfs_err(bg->fs_info,
 			  "zoned: cannot recover write pointer for zone %llu",
@@ -1434,7 +1436,6 @@ static int btrfs_load_block_group_dup(st
 	}
 
 	bg->alloc_offset = zone_info[0].alloc_offset;
-	bg->zone_capacity = min(zone_info[0].capacity, zone_info[1].capacity);
 	return 0;
 }
 
@@ -1452,6 +1453,9 @@ static int btrfs_load_block_group_raid1(
 		return -EINVAL;
 	}
 
+	/* In case a device is missing we have a cap of 0, so don't use it. */
+	bg->zone_capacity = min_not_zero(zone_info[0].capacity, zone_info[1].capacity);
+
 	for (i = 0; i < map->num_stripes; i++) {
 		if (zone_info[i].alloc_offset == WP_MISSING_DEV ||
 		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
@@ -1473,9 +1477,6 @@ static int btrfs_load_block_group_raid1(
 			if (test_bit(0, active))
 				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
 		}
-		/* In case a device is missing we have a cap of 0, so don't use it. */
-		bg->zone_capacity = min_not_zero(zone_info[0].capacity,
-						 zone_info[1].capacity);
 	}
 
 	if (zone_info[0].alloc_offset != WP_MISSING_DEV)
@@ -1565,6 +1566,7 @@ int btrfs_load_block_group_zone_info(str
 	unsigned long *active = NULL;
 	u64 last_alloc = 0;
 	u32 num_sequential = 0, num_conventional = 0;
+	u64 profile;
 
 	if (!btrfs_is_zoned(fs_info))
 		return 0;
@@ -1625,7 +1627,8 @@ int btrfs_load_block_group_zone_info(str
 		}
 	}
 
-	switch (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	profile = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	switch (profile) {
 	case 0: /* single */
 		ret = btrfs_load_block_group_single(cache, &zone_info[0], active);
 		break;
@@ -1652,6 +1655,23 @@ int btrfs_load_block_group_zone_info(str
 		goto out;
 	}
 
+	if (ret == -EIO && profile != 0 && profile != BTRFS_BLOCK_GROUP_RAID0 &&
+	    profile != BTRFS_BLOCK_GROUP_RAID10) {
+		/*
+		 * Detected broken write pointer.  Make this block group
+		 * unallocatable by setting the allocation pointer at the end of
+		 * allocatable region. Relocating this block group will fix the
+		 * mismatch.
+		 *
+		 * Currently, we cannot handle RAID0 or RAID10 case like this
+		 * because we don't have a proper zone_capacity value. But,
+		 * reading from this block group won't work anyway by a missing
+		 * stripe.
+		 */
+		cache->alloc_offset = cache->zone_capacity;
+		ret = 0;
+	}
+
 out:
 	/* Reject non SINGLE data profiles without RST */
 	if ((map->type & BTRFS_BLOCK_GROUP_DATA) &&


