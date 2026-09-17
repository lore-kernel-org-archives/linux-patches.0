Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7594D599C;
	Thu, 17 Sep 2026 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659256; cv=none; b=SN3bkwUpRiVwPIKnoMZxQBVY+GR3vkW30ATdMCMztpRi1+mUQneTNDA0xcFq09Uba1ih1oQBGMga6hyl7VrU/gFsmIcH+NhymDe4JczbWjJkhu3my66wrHs5JNj+FFIBkwZxbtOjoVD/1c90XIGQQaP96V8CZMy3uY1soA3+5iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659256; c=relaxed/simple;
	bh=3QlDIgl/Iz6FgJJ73WS2zdCRW5L4ElXGm5NXY806D9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONyuocGXs/rpYwyMa9P/TfoqIewRkaMgDcB4lhuai9xl4Q3viNgeWG7L8a0br1df74abDmpvKPfojhKHpcDuQybeB//3wlX3XHlCEBj1zwh5QrJ3nBcl0qRvYLwn/XCG34KSQeAhWHA463mmX49BDOhpIuQcxphLVgaZLITpPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/blhtG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/blhtG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2011F00893;
	Thu, 17 Sep 2026 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659251;
	bh=gIWGd7h1pq12Q22jsmJQDNcswNur0eyQKhJFvldOx9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/blhtG5vDyB8lELvfuAXciaEdVFsJ0IddYLvZ7BlJN2rI9wl3yBe3pVknxmQbyLf
	 5ADISdyZi/sZswpbIgcT/erU1jH3sn750zLWggcgoONdvA1rMdxsWvWk8ZFQHvPRSs
	 z24zUu36aNTacoHShHHAsyrHulmsp95mA59z3npc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 193/733] btrfs: fix the possible bioc_list memory leak during error
Date: Thu, 17 Sep 2026 16:08:21 +0100
Message-ID: <20260917151355.959727107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit afbe73778338e6d1ac8c4486fbdf33f0cc1f2624 ]

There are two possible ways to leak bioc memory on
btrfs_ordered_extent::bioc_list:

- An error occurred for btrfs_insert_one_raid_extent()
  Then the function btrfs_insert_raid_extent() immediately return
  without freeing any bioc in the bioc_list.

- An ordered extent hit an IO error
  In that case the ordered extent will have BTRFS_ORDERED_IOERR set, and
  skip the call on btrfs_insert_raid_extent() completely.

Fix the problem by:

- Introduce a new helper, btrfs_cleanup_ordered_bioc_list()
  Which will remove all bioc from the bioc_list, and release the bioc.

- Call the above helper for btrfs_insert_raid_extent()
  So that the cleanup helper is always called no matter what.

- Call the above helper for btrfs_finish_one_ordered()
  This is called just before the final release on the ordered extent.

This was reported by Sashiko when reviewing another patch.

Link: https://sashiko.dev/#/patchset/20260817021512.3010812-1-shuangpeng.kernel%40gmail.com
Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c            |  3 +++
 fs/btrfs/raid-stripe-tree.c | 18 ++++++++++++------
 fs/btrfs/raid-stripe-tree.h |  1 +
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 39a01f9cf6b51..188b4ac9889fc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3435,6 +3435,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	 */
 	btrfs_remove_ordered_extent(ordered_extent);
 
+	/* Cleanup any remaining biocs attached to the OE. */
+	btrfs_cleanup_ordered_bioc_list(ordered_extent);
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 89e259a47d8de..6291775dbe0e7 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -373,7 +373,7 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent)
 {
 	struct btrfs_io_context *bioc;
-	int ret;
+	int ret = 0;
 
 	if (!btrfs_fs_incompat(trans->fs_info, RAID_STRIPE_TREE))
 		return 0;
@@ -381,17 +381,23 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 	list_for_each_entry(bioc, &ordered_extent->bioc_list, rst_ordered_entry) {
 		ret = btrfs_insert_one_raid_extent(trans, bioc);
 		if (ret)
-			return ret;
+			break;
 	}
 
-	while (!list_empty(&ordered_extent->bioc_list)) {
-		bioc = list_first_entry(&ordered_extent->bioc_list,
+	btrfs_cleanup_ordered_bioc_list(ordered_extent);
+	return ret;
+}
+
+void btrfs_cleanup_ordered_bioc_list(struct btrfs_ordered_extent *ordered)
+{
+	while (!list_empty(&ordered->bioc_list)) {
+		struct btrfs_io_context *bioc;
+
+		bioc = list_first_entry(&ordered->bioc_list,
 					typeof(*bioc), rst_ordered_entry);
 		list_del(&bioc->rst_ordered_entry);
 		btrfs_put_bioc(bioc);
 	}
-
-	return 0;
 }
 
 int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/raid-stripe-tree.h b/fs/btrfs/raid-stripe-tree.h
index 69942ad431408..eb02cf48511bc 100644
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -28,6 +28,7 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 				 u32 stripe_index, struct btrfs_io_stripe *stripe);
 int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent);
+void btrfs_cleanup_ordered_bioc_list(struct btrfs_ordered_extent *ordered);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
-- 
2.53.0



