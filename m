Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A7B256C84;
	Wed, 25 Feb 2026 01:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983650; cv=none; b=HKUiZjqNcuaGh9TOjlwyKijKyslMVcelWnhSPyWycb+ms8gsau/Lt58oNHkY/vLZZnOhA6MXBLcSHbzSwi4ieimrhXoEV+rwbuO7QiTf+L/NRyxiy1H/iOzTJ21rWCDleOifDwqo3HWx4uPEBKeXpsVKXGBe/JaGEtw5BfLxPWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983650; c=relaxed/simple;
	bh=oMz0Mw8R8v8quEDbYYfKCSB9rqIHjUsDUtcWFZe7p+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvlPoTtrKmtx5Ao+ifujkV+1rzDIrAA/frI1A94BWgSYS91sPweBcMEwiOs7pfNLH2URoiFgd12mGEOgpR9myap/Ja1qWZVsDHJkipJKbqpNUoNys8SDqumbUVgy5SuZRdBURG1t6GcSvFI9DMvvYvWWE+rQnDdK2V6bTU0KJ5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eJp/zvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eJp/zvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D9FC19423;
	Wed, 25 Feb 2026 01:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983649;
	bh=oMz0Mw8R8v8quEDbYYfKCSB9rqIHjUsDUtcWFZe7p+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eJp/zvf62RtV5Ik/Eswkfx/+l6yx7m6U3r3d17LYY/SJvkjtkZGxaUPEy9CfQVEH
	 gQlhHwMWnFL08lPQW8sgP7dnpkcbRfdIbkGMaigBpE4boEo5hxkl3U7J9aTBX414/L
	 CexKAfj9mSj5gB7oICCQpM5m4doC52up3BYMJmO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 736/781] btrfs: reset block group size class when it becomes empty
Date: Tue, 24 Feb 2026 17:24:05 -0800
Message-ID: <20260225012417.783049442@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 5870ec7c8fe57a8b2c65005e5da5efc054faa3e6 ]

Block group size classes are managed consistently everywhere.
Currently, btrfs_use_block_group_size_class() sets a block group's size
class to specialize it for a specific allocation size. However, this
size class remains "stale" even if the block group becomes completely
empty (both used and reserved bytes reach zero).

This happens in two scenarios:

1. When space reservations are freed (e.g., due to errors or transaction
   aborts) via btrfs_free_reserved_bytes().
2. When the last extent in a block group is freed via
   btrfs_update_block_group().

While size classes are advisory, a stale size class can cause
find_free_extent to unnecessarily skip candidate block groups during
initial search loops. This undermines the purpose of size classes to
reduce fragmentation by keeping block groups restricted to a specific
size class when they could be reused for any size.

Fix this by resetting the size class to BTRFS_BG_SZ_NONE whenever a
block group's used and reserved counts both reach zero. This ensures
that empty block groups are fully available for any allocation size in
the next cycle.

Fixes: 52bb7a2166af ("btrfs: introduce size class to block group allocator")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 08b14449fabeb..c7be37bcbc48d 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3675,6 +3675,14 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 	return ret;
 }
 
+static void btrfs_maybe_reset_size_class(struct btrfs_block_group *bg)
+{
+	lockdep_assert_held(&bg->lock);
+	if (btrfs_block_group_should_use_size_class(bg) &&
+	    bg->used == 0 && bg->reserved == 0)
+		bg->size_class = BTRFS_BG_SZ_NONE;
+}
+
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     u64 bytenr, u64 num_bytes, bool alloc)
 {
@@ -3739,6 +3747,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 		old_val -= num_bytes;
 		cache->used = old_val;
 		cache->pinned += num_bytes;
+		btrfs_maybe_reset_size_class(cache);
 		btrfs_space_info_update_bytes_pinned(space_info, num_bytes);
 		space_info->bytes_used -= num_bytes;
 		space_info->disk_used -= num_bytes * factor;
@@ -3867,6 +3876,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 	spin_lock(&cache->lock);
 	bg_ro = cache->ro;
 	cache->reserved -= num_bytes;
+	btrfs_maybe_reset_size_class(cache);
 	if (is_delalloc)
 		cache->delalloc_bytes -= num_bytes;
 	spin_unlock(&cache->lock);
-- 
2.51.0



