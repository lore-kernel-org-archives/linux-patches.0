Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EE63081C2;
	Wed, 25 Feb 2026 06:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002798; cv=none; b=Pio87En637zp5mk8+CzVDVDXjhOeR99xEdVYOkk66U5If9t7htxI+0Ed827/e8xTGkTDXp5fiNZA9n0roah9QVUZhr1nyDUAOoKqgBFj4WhczIUvmGW63opU8dZSmX2/qGRsEdfrpI9lGT5pQ+LD3eplRa7HpcS7bYcX2yu5xa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002798; c=relaxed/simple;
	bh=S8N1t4UEObLBPphNw1d7VCjlRIevEDZnMjELMVukGyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GR0d+BZAW+pV17q7ISxtnwmrXo3Eo38VQRdVy1BtaRmhOUnuwsdwO96rnlm4P0svkNl8rWpJMMQ6FeQH0ekeruygIFp3ew0ftu3RWZKOvPlJ8HVs3horaHt1se/Pjoy+9gM0Rq6UOmB8vOgxpWt4k/SuZCprI/uKnLqpEbdumBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHZWAy2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHZWAy2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A787AC116D0;
	Wed, 25 Feb 2026 06:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002798;
	bh=S8N1t4UEObLBPphNw1d7VCjlRIevEDZnMjELMVukGyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHZWAy2kOJLiBwRbH19Gadna/IkELEKNOyO4fIc/kgYJGlDIB7fc8EV8cpxfbRMyH
	 EuDhOyVe7EXi/zDM9qwuIyEemR2zrDx6h3IKdyCn2wIe14hnPjbN0gAj37ZEBMEdBL
	 4/MXshNb6ZT/I3wgHWvlWUNA8hbHCTsY3ybMjhW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 604/641] btrfs: reset block group size class when it becomes empty
Date: Tue, 24 Feb 2026 17:25:30 -0800
Message-ID: <20260225012403.150095554@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 144868f02e2aa..f7f6d8cb33114 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3681,6 +3681,14 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
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
@@ -3745,6 +3753,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 		old_val -= num_bytes;
 		cache->used = old_val;
 		cache->pinned += num_bytes;
+		btrfs_maybe_reset_size_class(cache);
 		btrfs_space_info_update_bytes_pinned(space_info, num_bytes);
 		space_info->bytes_used -= num_bytes;
 		space_info->disk_used -= num_bytes * factor;
@@ -3865,6 +3874,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 	spin_lock(&cache->lock);
 	bg_ro = cache->ro;
 	cache->reserved -= num_bytes;
+	btrfs_maybe_reset_size_class(cache);
 	if (is_delalloc)
 		cache->delalloc_bytes -= num_bytes;
 	spin_unlock(&cache->lock);
-- 
2.51.0



