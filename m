Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621891;
	b=zKzow9TP3NRmluRsrROL0wDqyQ7w+gb7stih4IuKQlu9TRo9mjX2QkAN9Ij0+HlTIAa3
	 ogKFA10EbicadRGXAR88wNXE3FetH9wjB5GcE7s1LLO/h3YZ8OZkfWxbOEjuqrtCJOyaZ
	 1USiuJxybvJWoNv04+Nwx9xlgscexv0Ajx0UZ1a8JNhC+7x17Nn/LW7JFqeeRHNnXh+kj
	 KjGtZVl6oIeHaZue7upfRsrykfJVkTL0rpGnn0jAjwl7cwJZBZy8RQ+qFazXYmRDQ6cux
	 d66gOaorj4WtozCHtsaEg6lY8qjZOl3fybLzCvCLOUNXLKJJbHJzfuVnRXD62tm/Ydg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S3GWw7xo4Sgpo6C6UOmu7FRwGAGMMGNuW12I8ZhTY1k=;
	b=YnwI/E92wqxKg63cq8phwDXYO1QB3ROEpRsJZrz60ZdEzjmQMhJ++4YmgvRRIKokK4vl
	 dV3+TuAPGZ5s6NufxZGsSLdt7mo09S+xENWGgjsqZRq2GAnj9f/fqjRCCoeR5jQTo9CC1
	 hTqwkiG/exXRc4T7soDFfOF7xsV+741qtXLgNK0eCzjt+YFf/Yu5zXaNW/cYZoqjGRkJV
	 2AxXJwQRgzGcS3mTb79NKi7UARTlgD/bDnf04CN2RdYCqwy3+Lu0WSXAAGGlEu6vd0/MF
	 UUViiL4gt+LcDWlbYkV0wS8hgip7Mb966Ip0t1GDlNfCukaUOYndleaW/g1G7KESTmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P48ThtvN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4E1606A321;
	Wed, 25 Nov 2026 15:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P48ThtvN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF791F000EC;
	Wed, 25 Nov 2026 15:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621891;
	bh=S3GWw7xo4Sgpo6C6UOmu7FRwGAGMMGNuW12I8ZhTY1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P48ThtvNCVqqGizfUfY/2T431a5RCV9Jh8V8eUKc+zoEWpofzexZXDZ+Hk7ruPUi0
	 7/iT9Xeuay4bRNInoHMOjYuZy4wgTSOgyym0k098yGUk3omwUnlAM9/RQ4RA5FHhDl
	 Ip7bm8hAz98W8BfK0pR6GjNFHEN/LqlhuJRtgb1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/990] btrfs: zoned: requeue block group if zone reset bails out
Date: Wed, 25 Nov 2026 15:28:54 +0100
Message-ID: <20261125143830.688090835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit c5f878eefdd4f559422a68bf49b6f59e7c10e70e ]

btrfs_reset_unused_block_groups() drops the block-group from
fs_info->unused_bgs before performing the work that can actually fail,
the actual submission of a REQ_OP_ZONE_RESET.

Every failed operation after this leaves the block-group dangling,
physically reset, but the in-memory structures aren't and it is not
requeued to be reset on fs_info->unused_bgs.

Instead of bailing out, re-add this block-group to fs_info->unused_bgs
list.

Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index fe35bd531f70f..f25cd3ddbd630 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3107,6 +3107,8 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
 	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	LIST_HEAD(retry_list);
+	int ret = 0;
 
 	if (!btrfs_is_zoned(fs_info))
 		return 0;
@@ -3148,11 +3150,10 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		}
 		if (!found) {
 			spin_unlock(&fs_info->unused_bgs_lock);
-			return 0;
+			goto out;
 		}
 
 		list_del_init(&bg->bg_list);
-		btrfs_put_block_group(bg);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
 		/*
@@ -3166,7 +3167,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		for (int i = 0; i < map->num_stripes; i++) {
 			struct btrfs_io_stripe *stripe = &map->stripes[i];
 			unsigned int nofs_flags;
-			int ret;
 
 			nofs_flags = memalloc_nofs_save();
 			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
@@ -3176,7 +3176,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 
 			if (ret) {
 				up_read(&fs_info->dev_replace.rwsem);
-				return ret;
+				goto requeue;
 			}
 		}
 		up_read(&fs_info->dev_replace.rwsem);
@@ -3187,7 +3187,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		if (bg->ro) {
 			spin_unlock(&bg->lock);
 			spin_unlock(&space_info->lock);
-			continue;
+			goto requeue;
 		}
 
 		reclaimed = bg->alloc_offset;
@@ -3215,10 +3215,26 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		btrfs_return_free_space(space_info, reclaimed);
 		spin_unlock(&space_info->lock);
 
+		btrfs_put_block_group(bg);
+
 		if (num_bytes <= reclaimed)
 			break;
 		num_bytes -= reclaimed;
+		continue;
+
+requeue:
+		list_add_tail(&bg->bg_list, &retry_list);
+
+		if (ret)
+			goto out;
 	}
 
-	return 0;
+out:
+	if (!list_empty(&retry_list)) {
+		spin_lock(&fs_info->unused_bgs_lock);
+		list_splice_tail(&retry_list, &fs_info->unused_bgs);
+		spin_unlock(&fs_info->unused_bgs_lock);
+	}
+
+	return ret;
 }
-- 
2.53.0



