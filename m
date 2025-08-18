Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976993203B7;
	Mon, 18 Aug 2025 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524549; cv=none; b=t+Uoa0HvfdWUkT86WefU7KXsSrH/FBxwrCP9jB8yYB9nRPHvq6VVMdci3ggyeAHeFiHjG3zUBeL1LFu6CsDl31v471EFlHFxLUBvWpnoqtJu5TyNxIiS/sMYxm6dVbdnFHQTJcMnxEoTjcjP9sn4WRY8s54zfNvW+/3vuh+BfuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524549; c=relaxed/simple;
	bh=e9TjkbA+9eamqieWBZS9qwSPCauKec+MM2X+JN71ZQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nf5SzmXmcyUT18Hpw+55vi0NimaYNCIWeNJm1nKyy3jomZq+N94njftkve/hPS1ScSq+XGQ2IYqA4410S1Qf+HYy3hQ8MxnOBLCXOAaCFDTAyoFrjDNwfI7WN/I6calb8wSTls/8oyDGkkIMmqpqjeu4wc0yeatSp4ztK9CwOtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT372SE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT372SE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CA9C4CEEB;
	Mon, 18 Aug 2025 13:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524549;
	bh=e9TjkbA+9eamqieWBZS9qwSPCauKec+MM2X+JN71ZQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT372SE9ojt50YJFDyDqLHALFEoQ1OOjvoLNBpGKWqGfPSzrrM1HzlRqmcRH6fpTw
	 WsDB9zcvug7ApUWh/lsLCPWH+Ic+7arR9FSx5liorn1ue6TRL2dicKH6lNc6HMbOB2
	 k0l8TuTcJoQuN3EZ1gD1VJnyGchmp0K2cG9tDW6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 465/515] btrfs: zoned: do not remove unwritten non-data block group
Date: Mon, 18 Aug 2025 14:47:31 +0200
Message-ID: <20250818124516.318382337@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1246,6 +1259,15 @@ int btrfs_remove_block_group(struct btrf
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
@@ -1589,8 +1611,9 @@ void btrfs_delete_unused_bgs(struct btrf
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


