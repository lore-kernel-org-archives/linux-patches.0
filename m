Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0601A704B;
	Sun,  7 Sep 2025 20:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277440; cv=none; b=l1UwV07Efvokzhka415imif9GrRM0VzikNtpnJbVu1Q4sf4JIO8peUm2fvXnVVIUBwIilQP/G497VmweP2A++tzTdEob28ijGb50mwryFHf7K48INPNL3KXskEIKYPK65e2DQPuvsLYQ9o9M55wcsMplrhPtV8uSet+JGLu+jF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277440; c=relaxed/simple;
	bh=pOjqnUswq6SgfRUydvotZiZs3oP8tA+UmlUTX+XOTEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cuetw+9nquxhTLppIaDXJo/pVkL66C8lQAp8FVjXYn0OIKn25rfUg9Wqh3ZDaBZcnCu9Qk6Iyyt7AyHsGrc5jjwRivXxNF5oUL9VTJxcMdRzC5avFbsiH14US6rM0TUJpOg3giFKfNHTWeTqdua84X8UodDBdgtTFyUXDLK3doQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ii7ATQbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ii7ATQbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E974CC4CEF0;
	Sun,  7 Sep 2025 20:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277439;
	bh=pOjqnUswq6SgfRUydvotZiZs3oP8tA+UmlUTX+XOTEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ii7ATQbbgs9zESfMTKg+iW9HyXRXWCvzvKgA+bGNnOYttGLw6xSDVL7pInivDP8pp
	 Si/7HNCMxK37lQtlr7wFLiT1nK+NpOBbjfPbhezQj+dQZUsyWa3XCdkuReA376XtLJ
	 ZPA9QA7R8nrll05V2A0yrTCHZKKyIu/ObBi/IKiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 016/183] btrfs: zoned: skip ZONE FINISH of conventional zones
Date: Sun,  7 Sep 2025 21:57:23 +0200
Message-ID: <20250907195616.175559098@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

[ Upstream commit f0ba0e7172a222ea6043b61ecd86723c46d7bcf2 ]

Don't call ZONE FINISH for conventional zones as this will result in I/O
errors. Instead check if the zone that needs finishing is a conventional
zone and if yes skip it.

Also factor out the actual handling of finishing a single zone into a
helper function, as do_zone_finish() is growing ever bigger and the
indentations levels are getting higher.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 55 ++++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index af5ba3ad2eb83..d7a1193332d94 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2252,6 +2252,40 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 	rcu_read_unlock();
 }
 
+static int call_zone_finish(struct btrfs_block_group *block_group,
+			    struct btrfs_io_stripe *stripe)
+{
+	struct btrfs_device *device = stripe->dev;
+	const u64 physical = stripe->physical;
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	int ret;
+
+	if (!device->bdev)
+		return 0;
+
+	if (zinfo->max_active_zones == 0)
+		return 0;
+
+	if (btrfs_dev_is_sequential(device, physical)) {
+		unsigned int nofs_flags;
+
+		nofs_flags = memalloc_nofs_save();
+		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+				       physical >> SECTOR_SHIFT,
+				       zinfo->zone_size >> SECTOR_SHIFT);
+		memalloc_nofs_restore(nofs_flags);
+
+		if (ret)
+			return ret;
+	}
+
+	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
+		zinfo->reserved_active_zones++;
+	btrfs_dev_clear_active_zone(device, physical);
+
+	return 0;
+}
+
 static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_written)
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
@@ -2336,31 +2370,12 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	down_read(&dev_replace->rwsem);
 	map = block_group->physical_map;
 	for (i = 0; i < map->num_stripes; i++) {
-		struct btrfs_device *device = map->stripes[i].dev;
-		const u64 physical = map->stripes[i].physical;
-		struct btrfs_zoned_device_info *zinfo = device->zone_info;
-		unsigned int nofs_flags;
-
-		if (!device->bdev)
-			continue;
-
-		if (zinfo->max_active_zones == 0)
-			continue;
-
-		nofs_flags = memalloc_nofs_save();
-		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-				       physical >> SECTOR_SHIFT,
-				       zinfo->zone_size >> SECTOR_SHIFT);
-		memalloc_nofs_restore(nofs_flags);
 
+		ret = call_zone_finish(block_group, &map->stripes[i]);
 		if (ret) {
 			up_read(&dev_replace->rwsem);
 			return ret;
 		}
-
-		if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
-			zinfo->reserved_active_zones++;
-		btrfs_dev_clear_active_zone(device, physical);
 	}
 	up_read(&dev_replace->rwsem);
 
-- 
2.50.1



