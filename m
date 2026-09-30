Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633033EB11D;
	Wed, 30 Sep 2026 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795155; cv=none; b=baofri89F5ha5TQeO23ZSvoNDQGrpetaKvFtXWT40LUAxokXCDKFeXLQ4RwNM/uUsJiIjvoSqVc71z3utM7IKCgveQ12DK0uaDaTQ+8Pwq9E6LTOJ9Cw7M4Hvo46zBy5xSK40BEptw7oSh4cDY8TP1ssxIXYqNT4YsYezdU3tSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795155; c=relaxed/simple;
	bh=RYsDbXOcnhUp26k+btVHimr8EQ0JIaTLM6ok1SW1Ao0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzRgsGt4S+s8a6LvI18U+wKYj9EGYMcaSYEMazCEPqMA/Z1RPzK42M+xKfgE0ClBT2GfrrVvLCy6zikrypU/mlv3RqlbkWfDkGSBFFCx0asiWZbCe3bwjsQTWxGGTWXoT65q7qm+aRf5kgZuasFu4M4XQOWT6K7SH6jdt4qGBwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/+1+mIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/+1+mIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5CD1F000FF;
	Wed, 30 Sep 2026 19:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795154;
	bh=xwEi8besTe7vv4iomaZihZu/ysebP5K40qbUm99HWKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/+1+mImu5/rSjyJBcihkJZDlbuPuSi6lZTxvCrGvYK3XnKa1nE/mxCILGuSPKEkl
	 qz1t5LIkQK5Ju6QBZl4M0Xiq4jItb1kQ1IT01B1jFhrxwnKyfxB2i+bM53YFPJJl2g
	 CcRLhQLxC3ywxhJeWATycAmauxTc5+mYRYoh7U40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0460/1193] btrfs: fix the possible bioc_list memory leak during error
Date: Wed, 30 Sep 2026 17:19:04 +0200
Message-ID: <20260930152444.393375055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d04965bbae428..b99f849b3f787 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3300,6 +3300,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	 */
 	btrfs_remove_ordered_extent(inode, ordered_extent);
 
+	/* Cleanup any remaining biocs attached to the OE. */
+	btrfs_cleanup_ordered_bioc_list(ordered_extent);
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 7fe5adce9a100..4c7e6beb8013c 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -64,7 +64,7 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent)
 {
 	struct btrfs_io_context *bioc;
-	int ret;
+	int ret = 0;
 
 	if (!btrfs_fs_incompat(trans->fs_info, RAID_STRIPE_TREE))
 		return 0;
@@ -72,15 +72,21 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
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
diff --git a/fs/btrfs/raid-stripe-tree.h b/fs/btrfs/raid-stripe-tree.h
index 7a169e75ad6df..f613443ee7e0f 100644
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -13,6 +13,7 @@ struct btrfs_trans_handle;
 
 int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent);
+void btrfs_cleanup_ordered_bioc_list(struct btrfs_ordered_extent *ordered);
 
 static inline bool btrfs_need_stripe_tree_update(struct btrfs_fs_info *fs_info,
 						 u64 map_type)
-- 
2.53.0



