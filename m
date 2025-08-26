Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133C61B87E8;
	Tue, 26 Aug 2025 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214830; cv=none; b=WuNZkbYFI+Kh6fNQF+T3TLk/T6SaY6JGSxoaJ//TrsfgioS0AeqElHyWSZoT2RdVAgkLS+NS3KEEsORioJf0U9rCkeNlrZcmUSHDifT64AW53qeomjb3GI3f+rxckDJzoxo/3oJ0hnojR56A6OoiXJ59hGk6jbtJn5e7hKgxixo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214830; c=relaxed/simple;
	bh=NKn1m8j40a3kjLhL7slFUw2FVdwPY+Ha/hRLGYmrDSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx5uYux7gIaO804O2g1sysIHc8AB2bnL579hu0zSw4HbRr2/UkM3IyI6sYeqmtXQGjowN3bThonbuBUuf4CmLmhQmE9Yx6eJPo5ORiOAp8R2RzcM6N8bWkMoq9YJhJeTxXLhIw8QiU2AFhtVuUBMsC/V4yLL0PBRnPh2IQeYGYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+VdSEnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+VdSEnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E408C4CEF1;
	Tue, 26 Aug 2025 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214830;
	bh=NKn1m8j40a3kjLhL7slFUw2FVdwPY+Ha/hRLGYmrDSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+VdSEnuWVhOnGi83GEPP9pGoqzbBp0IcvNZxDm3i2cQvo9I39Z/WXC8ort7crUfq
	 jKzxc5dKi3xAQXoTlwn4dPT+mGKi+qY7mGNhWTkozNrSeFOrNwFOl67hN1DcIWl0dv
	 4tfMEM3qNInspF826CHYT3rwDF2VOBNQ7+5Fh1Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 254/482] btrfs: zoned: do not remove unwritten non-data block group
Date: Tue, 26 Aug 2025 13:08:27 +0200
Message-ID: <20250826110937.042746911@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -46,6 +46,19 @@ static u64 get_restripe_target(struct bt
 	return target;
 }
 
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
  * @flags: available profiles in extended format (see ctree.h)
  *
@@ -1091,6 +1104,15 @@ int btrfs_remove_block_group(struct btrf
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
@@ -1414,8 +1436,9 @@ void btrfs_delete_unused_bgs(struct btrf
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


