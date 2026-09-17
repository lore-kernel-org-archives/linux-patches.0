Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236FE4F3EAD;
	Thu, 17 Sep 2026 17:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665504; cv=none; b=CZvNFUcVzl6z1RsAOFs7vB5zwWTlmCsaaGWammENUsuGHktHNgLE5jXhtPETShWSrvMDGH6NIzqhLAXdipNJhGDsHkm7zZnfyneldjKeIIG/dGdICPY4qZEh/BHnNocaobtpsTKBn3qYANBa7SjQ2tbSOTfndqrqQ5E+KH+AxJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665504; c=relaxed/simple;
	bh=6TOvijTIrsnvSZdL/P3/ph6tp+WrlAJZI4L2JVnWbmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGGLAacAbJpYFW7a257VcCkcP80GMrFPSMQjqe39tJVxt0MxrAUUJXO+UBkgHPt+CPNCzQcvyIcOuSGi+jb4NJ5sSP27OT5GATH/UZhkJzTRyeCGksz5PYfW3rB+YVPUjw9jdkDVByfG8ZGNB8ltwIRbACVKI/GUOaBVtDgcnbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1u/229xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1u/229xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F081F00893;
	Thu, 17 Sep 2026 17:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665503;
	bh=0V1pCiNtMGVdmUBRp5nWjUaSU0tmonwqcpPrQQHhyHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1u/229xpO9QuNQcuxPgFbVRC+mlExGH4eyVnW/e2TST+YOGVHVZbYYYOt62V34dyC
	 KrcvhCco7vHXziJ7hSNlv1eaRYGXTy+w56OGZy3nvi1QQty9UqNL29J5Vm7qgP8ydh
	 gzZkVrYpQXAF59uc4wwoCwLf9IREdj9dhwy9FF0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0725/1250] btrfs: fix the possible bioc_list memory leak during error
Date: Thu, 17 Sep 2026 16:08:40 +0100
Message-ID: <20260917151611.539448894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 6795f87314c45..3023e1b504b96 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3380,6 +3380,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	 */
 	btrfs_remove_ordered_extent(inode, ordered_extent);
 
+	/* Cleanup any remaining biocs attached to the OE. */
+	btrfs_cleanup_ordered_bioc_list(ordered_extent);
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 2daf66172e2a8..e3aaf8dc32151 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -344,7 +344,7 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent)
 {
 	struct btrfs_io_context *bioc;
-	int ret;
+	int ret = 0;
 
 	if (!btrfs_fs_incompat(trans->fs_info, RAID_STRIPE_TREE))
 		return 0;
@@ -352,17 +352,23 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
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



