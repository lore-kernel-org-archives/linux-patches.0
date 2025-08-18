Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA9627F736;
	Mon, 18 Aug 2025 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522700; cv=none; b=YBQUMMQfPqwBxIuHpax/sVlQtk1cySYCSJ0SpsDfPWShEZyGnZssucNBojLyL/NsCHXMA7KNvdJmxRt7iPc576M5FTA4X/tsXfwM8DVVkeqPtwKX3SPcjYPHNHZhf2QZC4Et4zsjCTpmYDFX7YNjXvrEIOi4psC1k9bMM7dD7MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522700; c=relaxed/simple;
	bh=uWGM5JvcJKT/cc5MOafHkKS7T1IwPxL6fd52KY+NgBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCTHmqivAvES3+kjTNmmwYyqP5T0JWCrfBhj/U9X4gxWzO4Shw9dp4F6UoYvymyNe7pD/vuiTVdTxPprGwqIcOnO7UqH37vIm15kAR4+5zI7e8TfE6FqQVFk0IfbRYaf7vZQHj2YX0n+pphZoQCr1eM+vWV9tmuYVN1jFUn5OyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iF1Vz6FV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iF1Vz6FV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CD7C113D0;
	Mon, 18 Aug 2025 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522700;
	bh=uWGM5JvcJKT/cc5MOafHkKS7T1IwPxL6fd52KY+NgBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iF1Vz6FV5ZINexNzW9jU9lBqcP7VT36j8t36yoWyjt1BD6ANYItCj2wWjDhwNsVTh
	 X3pVoNSipxlUtbc0Rd2pzpI5sh6Dy0d9Kyp5g9XIuMhpEfG7iRYwBa8lJi/CAuZlwT
	 pm7rOmDUtHgfR17vYobJfu6/rV18cJnusXpm05QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 393/444] btrfs: zoned: do not remove unwritten non-data block group
Date: Mon, 18 Aug 2025 14:46:59 +0200
Message-ID: <20250818124503.651323150@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 3061801420469610c8fa6080a950e56770773ef1 upstream.

There are some reports of "unable to find chunk map for logical 2147483648
length 16384" error message appears in dmesg. This means some IOs are
occurring after a block group is removed.

When a metadata tree node is cleaned on a zoned setup, we keep that node
still dirty and write it out not to create a write hole. However, this can
make a block group's used bytes == 0 while there is a dirty region left.

Such an unused block group is moved into the unused_bg list and processed
for removal. When the removal succeeds, the block group is removed from the
transaction->dirty_bgs list, so the unused dirty nodes in the block group
are not sent at the transaction commit time. It will be written at some
later time e.g, sync or umount, and causes "unable to find chunk map"
errors.

This can happen relatively easy on SMR whose zone size is 256MB. However,
calling do_zone_finish() on such block group returns -EAGAIN and keep that
block group intact, which is why the issue is hidden until now.

Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -34,6 +34,19 @@ int btrfs_should_fragment_free_space(con
 }
 #endif
 
+static inline bool has_unwritten_metadata(struct btrfs_block_group *block_group)
+{
+	/* The meta_write_pointer is available only on the zoned setup. */
+	if (!btrfs_is_zoned(block_group->fs_info))
+		return false;
+
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+		return false;
+
+	return block_group->start + block_group->alloc_offset >
+		block_group->meta_write_pointer;
+}
+
 /*
  * Return target flags in extended format or 0 if restripe for this chunk_type
  * is not in progress
@@ -1249,6 +1262,15 @@ int btrfs_remove_block_group(struct btrf
 		goto out;
 
 	spin_lock(&block_group->lock);
+	/*
+	 * Hitting this WARN means we removed a block group with an unwritten
+	 * region. It will cause "unable to find chunk map for logical" errors.
+	 */
+	if (WARN_ON(has_unwritten_metadata(block_group)))
+		btrfs_warn(fs_info,
+			   "block group %llu is removed before metadata write out",
+			   block_group->start);
+
 	set_bit(BLOCK_GROUP_FLAG_REMOVED, &block_group->runtime_flags);
 
 	/*
@@ -1567,8 +1589,9 @@ void btrfs_delete_unused_bgs(struct btrf
 		 * needing to allocate extents from the block group.
 		 */
 		used = btrfs_space_info_used(space_info, true);
-		if (space_info->total_bytes - block_group->length < used &&
-		    block_group->zone_unusable < block_group->length) {
+		if ((space_info->total_bytes - block_group->length < used &&
+		     block_group->zone_unusable < block_group->length) ||
+		    has_unwritten_metadata(block_group)) {
 			/*
 			 * Add a reference for the list, compensate for the ref
 			 * drop under the "next" label for the


