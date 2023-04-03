Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB3E6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0D8C433A0;
	Mon,  3 Apr 2023 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532651;
	bh=1bW3CiB4W5uRQrP1wR4ElqtFy6vDv3VaJnYYvDBUriU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4m2JK+WrrSRa1Nmq6siLwIkHVUUZlHAUkeJhtDQA3m5k48NTmTJfH5KzRO6duDn+
	 LVmLwIStoFmRbz5E8OmBgCDBZgJcrdzQkBHVikYifJOPTCTHInWcGxupgIrM0l2Nz8
	 vNlmn78QBaiJ9LjODK9YuGGyzNKTdnIPL0ttZe74=
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
Subject: [PATCH 6.1 065/181] btrfs: use temporary variable for space_info in btrfs_update_block_group
Date: Mon,  3 Apr 2023 16:08:20 +0200
Message-Id: <20230403140417.251023950@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
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

[ Upstream commit df384da5a49cace5c5e3100803dfd563fd982f93 ]

We do

  cache->space_info->counter += num_bytes;

everywhere in here.  This is makes the lines longer than they need to
be, and will be especially noticeable when we add the active tracking in,
so add a temp variable for the space_info so this is cleaner.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 380cb10f0d37b..f33ddd5922b8c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3259,6 +3259,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	spin_unlock(&info->delalloc_root_lock);
 
 	while (total) {
+		struct btrfs_space_info *space_info;
 		bool reclaim = false;
 
 		cache = btrfs_lookup_block_group(info, bytenr);
@@ -3266,6 +3267,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			ret = -ENOENT;
 			break;
 		}
+		space_info = cache->space_info;
 		factor = btrfs_bg_type_to_factor(cache->flags);
 
 		/*
@@ -3280,7 +3282,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 		byte_in_group = bytenr - cache->start;
 		WARN_ON(byte_in_group > cache->length);
 
-		spin_lock(&cache->space_info->lock);
+		spin_lock(&space_info->lock);
 		spin_lock(&cache->lock);
 
 		if (btrfs_test_opt(info, SPACE_CACHE) &&
@@ -3293,23 +3295,23 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			old_val += num_bytes;
 			cache->used = old_val;
 			cache->reserved -= num_bytes;
-			cache->space_info->bytes_reserved -= num_bytes;
-			cache->space_info->bytes_used += num_bytes;
-			cache->space_info->disk_used += num_bytes * factor;
+			space_info->bytes_reserved -= num_bytes;
+			space_info->bytes_used += num_bytes;
+			space_info->disk_used += num_bytes * factor;
 			spin_unlock(&cache->lock);
-			spin_unlock(&cache->space_info->lock);
+			spin_unlock(&space_info->lock);
 		} else {
 			old_val -= num_bytes;
 			cache->used = old_val;
 			cache->pinned += num_bytes;
-			btrfs_space_info_update_bytes_pinned(info,
-					cache->space_info, num_bytes);
-			cache->space_info->bytes_used -= num_bytes;
-			cache->space_info->disk_used -= num_bytes * factor;
+			btrfs_space_info_update_bytes_pinned(info, space_info,
+							     num_bytes);
+			space_info->bytes_used -= num_bytes;
+			space_info->disk_used -= num_bytes * factor;
 
 			reclaim = should_reclaim_block_group(cache, num_bytes);
 			spin_unlock(&cache->lock);
-			spin_unlock(&cache->space_info->lock);
+			spin_unlock(&space_info->lock);
 
 			set_extent_dirty(&trans->transaction->pinned_extents,
 					 bytenr, bytenr + num_bytes - 1,
-- 
2.39.2



