Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5D013DDC0;
	Wed, 19 Jun 2024 13:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804063; cv=none; b=kNV+04cd3H6iSNrEQX2OE8AFViH6T8UkHyf5YdzNenLgrg6c1XUIePsmUrBjHD9tWBcvK8RiEcy0mSYM2LKqQAqioVfUshCga1KjPvkF40ID7tkg3SxtiS+/QU1jjvYQCu7K3wBL3LI/JTwi95LcOvFN6iRLSQqhKZXrJzDy+PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804063; c=relaxed/simple;
	bh=Nq2FmWu+OI0y7phbCcGSqobAoe5FrRNfOPc+VVLWmoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htoid2pWVi+vRRwjfAISZz4IhI3l4Mm6ejcj8ZbRa7E54C8hYQmpLS5rJbyGzlTx5VG9uEgcuyDJh1+M00425OMXNpoZFs1MrZGrb9hFbVMsW4ClR/gpAXBDV7qyzVbW3f4Jeo8V2Z0npWXigPe8FF8ha4UqEIAhtigEkZXyjkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eB0ZMUND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eB0ZMUND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EFEC2BBFC;
	Wed, 19 Jun 2024 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804062;
	bh=Nq2FmWu+OI0y7phbCcGSqobAoe5FrRNfOPc+VVLWmoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eB0ZMUNDsdz7efmGPt7fBZQisBKkJEUYLnXVX9JhOc+owZe+SMtcevjAa4gXF2Tx8
	 kSb3QISqBPtnWCXIZYPyGogAHIuw+acj9G4iFfcVdvLP+i//Q6KJjhYPHZhVuK3n7k
	 GmoiZV5a9WHKdpzsTRuhIgS72o11Gkr1aYhgh5tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 196/217] btrfs: zoned: factor out single bg handling from btrfs_load_block_group_zone_info
Date: Wed, 19 Jun 2024 14:57:19 +0200
Message-ID: <20240619125604.247479182@linuxfoundation.org>
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

commit 9e0e3e74dc6928a0956f4e27e24d473c65887e96 upstream.

Split the code handling a type single block group from
btrfs_load_block_group_zone_info to make the code more readable.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1362,6 +1362,24 @@ static int btrfs_load_zone_info(struct b
 	return 0;
 }
 
+static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
+					 struct zone_info *info,
+					 unsigned long *active)
+{
+	if (info->alloc_offset == WP_MISSING_DEV) {
+		btrfs_err(bg->fs_info,
+			"zoned: cannot recover write pointer for zone %llu",
+			info->physical);
+		return -EIO;
+	}
+
+	bg->alloc_offset = info->alloc_offset;
+	bg->zone_capacity = info->capacity;
+	if (test_bit(0, active))
+		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+	return 0;
+}
+
 int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
@@ -1448,17 +1466,7 @@ int btrfs_load_block_group_zone_info(str
 
 	switch (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 	case 0: /* single */
-		if (zone_info[0].alloc_offset == WP_MISSING_DEV) {
-			btrfs_err(fs_info,
-			"zoned: cannot recover write pointer for zone %llu",
-				zone_info[0].physical);
-			ret = -EIO;
-			goto out;
-		}
-		cache->alloc_offset = zone_info[0].alloc_offset;
-		cache->zone_capacity = zone_info[0].capacity;
-		if (test_bit(0, active))
-			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags);
+		ret = btrfs_load_block_group_single(cache, &zone_info[0], active);
 		break;
 	case BTRFS_BLOCK_GROUP_DUP:
 		if (map->type & BTRFS_BLOCK_GROUP_DATA) {


