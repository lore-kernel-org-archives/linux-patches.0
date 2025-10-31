Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB563C17;
	Fri, 31 Oct 2025 14:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919511; cv=none; b=f6qu2aE7CgksrHagZF4Gk44i493/yD45bgv4qWdWH+HgYfbps7O+CXorQ7iTGH6tyFKd15i8AnHegy/pLJ1HvRC/RuKC0zclIyMDKk50FWMbCuxYAsLZq/7GhxtjxASnNUH+/DlsQVao2ujZK1dkDmaTT5BcyvNKx8YNDTl2Gd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919511; c=relaxed/simple;
	bh=PEN52JK4GOVQiigV3qvtG+o+8qy0sch2wG4bL+EBmrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUIW9DZy5VKRgvpCuXsw7b8XnWgSMiUOys6kCrPwnE7+kM5JR/xHlk+PoiHkLc83sZVdd5oX9dB9E3qUrYPWIxe6pAvkZVaLeogDLB4fXUeudxe5vu99Bk0NTFdbemIfOBRuRGr36ctpl78QyHayLZsj+m5vwLPxDSLh0xzemms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8GTQKP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8GTQKP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432ADC4CEE7;
	Fri, 31 Oct 2025 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919511;
	bh=PEN52JK4GOVQiigV3qvtG+o+8qy0sch2wG4bL+EBmrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8GTQKP7ifz5ikDKyBZNvbaR+V10X1DnIQ9ZJ5ZyPUK7E69NsJr81rSD26LvejwFT
	 Lp6WLb+x4vb4wcPfwMyvR8d+XAcPrGVLRGsk9yxLRANM0FJ8vZh0jsX3l5XDUKFS07
	 Ybmn7fHdc70zf7myUhDWJUItZtHTc5tpT62Q0Wyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 14/40] btrfs: zoned: return error from btrfs_zone_finish_endio()
Date: Fri, 31 Oct 2025 15:01:07 +0100
Message-ID: <20251031140044.363484190@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 3c44cd3c79fcb38a86836dea6ff8fec322a9e68c ]

Now that btrfs_zone_finish_endio_workfn() is directly calling
do_zone_finish() the only caller of btrfs_zone_finish_endio() is
btrfs_finish_one_ordered().

btrfs_finish_one_ordered() already has error handling in-place so
btrfs_zone_finish_endio() can return an error if the block group lookup
fails.

Also as btrfs_zone_finish_endio() already checks for zoned filesystems and
returns early, there's no need to do this in the caller.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 7 ++++---
 fs/btrfs/zoned.c | 8 +++++---
 fs/btrfs/zoned.h | 9 ++++++---
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 19c0ec9c327c1..e32dd4193aea1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3174,9 +3174,10 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
-	if (btrfs_is_zoned(fs_info))
-		btrfs_zone_finish_endio(fs_info, ordered_extent->disk_bytenr,
-					ordered_extent->disk_num_bytes);
+	ret = btrfs_zone_finish_endio(fs_info, ordered_extent->disk_bytenr,
+				      ordered_extent->disk_num_bytes);
+	if (ret)
+		goto out;
 
 	if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered_extent->flags)) {
 		truncated = true;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4966b4f5a7d24..64e0a5bf5f9a5 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2384,16 +2384,17 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 	return ret;
 }
 
-void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 length)
+int btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 length)
 {
 	struct btrfs_block_group *block_group;
 	u64 min_alloc_bytes;
 
 	if (!btrfs_is_zoned(fs_info))
-		return;
+		return 0;
 
 	block_group = btrfs_lookup_block_group(fs_info, logical);
-	ASSERT(block_group);
+	if (WARN_ON_ONCE(!block_group))
+		return -ENOENT;
 
 	/* No MIXED_BG on zoned btrfs. */
 	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
@@ -2410,6 +2411,7 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
 
 out:
 	btrfs_put_block_group(block_group);
+	return 0;
 }
 
 static void btrfs_zone_finish_endio_workfn(struct work_struct *work)
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 7612e65726053..f7171ab6ed71e 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -83,7 +83,7 @@ int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 bool btrfs_zone_activate(struct btrfs_block_group *block_group);
 int btrfs_zone_finish(struct btrfs_block_group *block_group);
 bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags);
-void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical,
+int btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical,
 			     u64 length);
 void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
@@ -232,8 +232,11 @@ static inline bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices,
 	return true;
 }
 
-static inline void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info,
-					   u64 logical, u64 length) { }
+static inline int btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info,
+					   u64 logical, u64 length)
+{
+	return 0;
+}
 
 static inline void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 						 struct extent_buffer *eb) { }
-- 
2.51.0



