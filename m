Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B0C6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A469BC433D2;
	Mon,  3 Apr 2023 14:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532983;
	bh=4dmOU6eOsaNii+aMTV8JVmAALGaTwDsW5D9DFERr/0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/TG051Lk4IarYHNiD/6393nUfoNgk17Mhr1RBxX/VBMUUOPYgrjGzEW2h1hQMAza
	 thhJAPFea03A3Kz1uQc+3rYb/pIT96e5z4fc7GEY6Wljbfiizv0D3RKneLG20ERzRv
	 LAHGbw2hU0nJmzUIr+SEDfiUfVLgRqRAK5E+kz0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 010/187] btrfs: rename BTRFS_FS_NO_OVERCOMMIT to BTRFS_FS_ACTIVE_ZONE_TRACKING
Date: Mon,  3 Apr 2023 16:07:35 +0200
Message-Id: <20230403140416.371692189@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bf1f1fec2724a33b67ec12032402ea75f2a83622 ]

This flag only gets set when we're doing active zone tracking, and we're
going to need to use this flag for things related to this behavior.
Rename the flag to represent what it actually means for the file system
so it can be used in other ways and still make sense.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: e15acc25880c ("btrfs: zoned: drop space_info->active_total_bytes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/fs.h         | 7 ++-----
 fs/btrfs/space-info.c | 2 +-
 fs/btrfs/zoned.c      | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 3d8156fc8523f..f180ca061aef4 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -119,11 +119,8 @@ enum {
 	/* Indicate that we want to commit the transaction. */
 	BTRFS_FS_NEED_TRANS_COMMIT,
 
-	/*
-	 * Indicate metadata over-commit is disabled. This is set when active
-	 * zone tracking is needed.
-	 */
-	BTRFS_FS_NO_OVERCOMMIT,
+	/* This is set when active zone tracking is needed. */
+	BTRFS_FS_ACTIVE_ZONE_TRACKING,
 
 	/*
 	 * Indicate if we have some features changed, this is mostly for
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 69c09508afb50..2237685d1ed0c 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -407,7 +407,7 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
-	if (test_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags) &&
+	if (test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags) &&
 	    (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
 		avail = 0;
 	else
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index f3b7d8ae93a9f..a6a8bc112fc42 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -539,8 +539,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		}
 		atomic_set(&zone_info->active_zones_left,
 			   max_active_zones - nactive);
-		/* Overcommit does not work well with active zone tacking. */
-		set_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags);
+		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
 	}
 
 	/* Validate superblock log */
-- 
2.39.2



