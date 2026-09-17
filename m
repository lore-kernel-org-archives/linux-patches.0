Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B390375F82;
	Thu, 17 Sep 2026 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659264; cv=none; b=SmmSa2eGSPV6WsUEHGb27hMHlEm9MOZwzHE3W8W/PzesrzhyZEMDAQt7Z1SidTFRyP5p0DYYEISY8rH63dY6dlnyJbuUrXkMj62PjY/joy+cL54wPMPs6F8d8s4OBf59BQZ89GcR/b3dIkSx3TYVBMNfCNJEzHbV1d1tQT7stbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659264; c=relaxed/simple;
	bh=WNgs8IxMc2MhKQm+P0f8NxsOw68fGWXSw5iq23fGd8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V38namhjZNTkB/Owm95JjmRk6plgkkbAUbD/GNrH8/5Py2xTQJ9+mUMEj9wGM/GyyDTV09dWhaxam88R4+K1aE01RsnEDAAeHLets/KMXqgHL4uVjOBqwwktdkJ3q1tbvWYuwdAUnMtX6lgWAZaJbIzV2a3AzQ0j74aDsGKHtT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ot3zPZb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ot3zPZb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400771F00893;
	Thu, 17 Sep 2026 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659258;
	bh=WXttczdxhyMKYcL1kZZOnwO+h7rj1K+wQauailTza68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ot3zPZb5gBe036aQfkRU7Fe0YV7cnJCz2CYO9olhDGwdASnIK96x9paGUL6GDjA97
	 NXHCKrl1qQ3nPVuOfDd6qDYtsUvR5bF0YK/Lv650FHxvuFgsrmw83ssADrBjn4cR+g
	 WYDxYm3fbxImN6ixSYc3tTIuHFMzl2apKWspik+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 195/733] btrfs: zoned: finish active block group cleanup if call_zone_finish() fails
Date: Thu, 17 Sep 2026 16:08:23 +0100
Message-ID: <20260917151356.016211805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit a18a6b93a2843b9d103d3456bbd4b3f90282a379 ]

do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before finishing
the zones. If call_zone_finish() then fails it returned early, leaving the
now inactive block group on fs_info->zone_active_bgs, leaking its
reference, the BTRFS_FS_NEED_ZONE_FINISH waiters are never woken, and as
its alloc_offset equals the zone capacity btrfs_zone_finish_one_bg() keeps
selecting it, spinning btrfs_zoned_activate_one_bg().

Fall through to the cleanup on failure too and return the error, but keep
the block group read-only as its zones are left inconsistent.

Fixes: d70cbdda75da ("btrfs: zoned: consolidate zone finish functions")
Link: https://sashiko.dev/#/patchset/20260818100037.1366563-1-johannes.thumshirn%40wdc.com
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a016cb471beb4..7f0dde6398d4d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2626,16 +2626,13 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	down_read(&dev_replace->rwsem);
 	map = block_group->physical_map;
 	for (i = 0; i < map->num_stripes; i++) {
-
 		ret = call_zone_finish(block_group, &map->stripes[i]);
-		if (ret) {
-			up_read(&dev_replace->rwsem);
-			return ret;
-		}
+		if (ret)
+			break;
 	}
 	up_read(&dev_replace->rwsem);
 
-	if (!fully_written)
+	if (!ret && !fully_written)
 		btrfs_dec_block_group_ro(block_group);
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2648,7 +2645,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
-	return 0;
+	return ret;
 }
 
 int btrfs_zone_finish(struct btrfs_block_group *block_group)
-- 
2.53.0



