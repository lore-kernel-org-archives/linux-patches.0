Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8D126B09C;
	Thu, 13 Feb 2025 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458637; cv=none; b=NcLUawGaFTY11Gl4i/+gm7je4oASPCY95c12YsDyeKAhtZhpoYGtFpp8JkQmYrabLz30qFrN7yO6mdUSQZE/aZ5eJfnW13VHLAIl3G2uydPVCICPllQQmKl5QeEvaohtSKMaiAcwgZhTIdEc8H3c8FPdgql2zpYay5GUtDzQQY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458637; c=relaxed/simple;
	bh=jhoZfP6U5Sz0bYTt/H/dc3jnE2D6wLc4dmCwC1Ckeco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAcS4QsnbZwm1CJ/qgohfTfmzT+5IhldyjDl/j0yTnqcSP6fFluY2xLpqpVetpphFt31X/FkeUPNaPRGeSoyLP0too/75hsWjut/gRzjwq4isYyRI65aGWHK9vq77eKuiMHlZ3hRQ2k9Q2I340xdWPVk0pyuA9ddTJ4KnnqIah8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzCWIogm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzCWIogm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DB6C4CED1;
	Thu, 13 Feb 2025 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458636;
	bh=jhoZfP6U5Sz0bYTt/H/dc3jnE2D6wLc4dmCwC1Ckeco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzCWIogmqIwHHbWn6K6Tj0a6+g7ORpGe4jea8/blAUXz7xg2vCEsbj3IHD4Fneq53
	 NXs0bUxt7/7xPs7IcVrtxK8TlRdmt9htLEsg6smBl8n1xqh10wt4XQnuJdIQCBhtHB
	 3k/KNAzamZ/4Re2VrP2kGOY/Su6Qvx8XT7Jn3LMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Hao-ran Zheng <zhenghaoran154@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 009/443] btrfs: fix data race when accessing the inodes disk_i_size at btrfs_drop_extents()
Date: Thu, 13 Feb 2025 15:22:54 +0100
Message-ID: <20250213142440.980241513@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-ran Zheng <zhenghaoran154@gmail.com>

[ Upstream commit 5324c4e10e9c2ce307a037e904c0d9671d7137d9 ]

A data race occurs when the function `insert_ordered_extent_file_extent()`
and the function `btrfs_inode_safe_disk_i_size_write()` are executed
concurrently. The function `insert_ordered_extent_file_extent()` is not
locked when reading inode->disk_i_size, causing
`btrfs_inode_safe_disk_i_size_write()` to cause data competition when
writing inode->disk_i_size, thus affecting the value of `modify_tree`.

The specific call stack that appears during testing is as follows:

  ============DATA_RACE============
   btrfs_drop_extents+0x89a/0xa060 [btrfs]
   insert_reserved_file_extent+0xb54/0x2960 [btrfs]
   insert_ordered_extent_file_extent+0xff5/0x1760 [btrfs]
   btrfs_finish_one_ordered+0x1b85/0x36a0 [btrfs]
   btrfs_finish_ordered_io+0x37/0x60 [btrfs]
   finish_ordered_fn+0x3e/0x50 [btrfs]
   btrfs_work_helper+0x9c9/0x27a0 [btrfs]
   process_scheduled_works+0x716/0xf10
   worker_thread+0xb6a/0x1190
   kthread+0x292/0x330
   ret_from_fork+0x4d/0x80
   ret_from_fork_asm+0x1a/0x30
  ============OTHER_INFO============
   btrfs_inode_safe_disk_i_size_write+0x4ec/0x600 [btrfs]
   btrfs_finish_one_ordered+0x24c7/0x36a0 [btrfs]
   btrfs_finish_ordered_io+0x37/0x60 [btrfs]
   finish_ordered_fn+0x3e/0x50 [btrfs]
   btrfs_work_helper+0x9c9/0x27a0 [btrfs]
   process_scheduled_works+0x716/0xf10
   worker_thread+0xb6a/0x1190
   kthread+0x292/0x330
   ret_from_fork+0x4d/0x80
   ret_from_fork_asm+0x1a/0x30
  =================================

The main purpose of the check of the inode's disk_i_size is to avoid
taking write locks on a btree path when we have a write at or beyond
EOF, since in these cases we don't expect to find extent items in the
root to drop. However if we end up taking write locks due to a data
race on disk_i_size, everything is still correct, we only add extra
lock contention on the tree in case there's concurrency from other tasks.
If the race causes us to not take write locks when we actually need them,
then everything is functionally correct as well, since if we find out we
have extent items to drop and we took read locks (modify_tree set to 0),
we release the path and retry again with write locks.

Since this data race does not affect the correctness of the function,
it is a harmless data race, use data_race() to check inode->disk_i_size.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Hao-ran Zheng <zhenghaoran154@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 14e27473c5bce..4d7c7a296d2d1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -224,7 +224,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	if (args->drop_cache)
 		btrfs_drop_extent_map_range(inode, args->start, args->end - 1, false);
 
-	if (args->start >= inode->disk_i_size && !args->replace_extent)
+	if (data_race(args->start >= inode->disk_i_size) && !args->replace_extent)
 		modify_tree = 0;
 
 	update_refs = (btrfs_root_id(root) != BTRFS_TREE_LOG_OBJECTID);
-- 
2.39.5



