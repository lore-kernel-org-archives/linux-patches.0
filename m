Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEB33C3C;
	Fri, 27 Sep 2024 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440433; cv=none; b=Kj6pUgLVVw72J/Gl+EySbjorpKfQc4X5D1voB/NQhdRP/9xZo7A8MK25tYkbvN7KSyTOFrE7o1JFvFaRdIvKz9u+ZoHRg8RXGyB0DGg67LRKlg2H2iJxOmarY4fQupZ9d5VxBpiW0greqveBIUS2GNf+TRznw1vzlXWRWMSQ+VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440433; c=relaxed/simple;
	bh=8/tJ1CDmBaDq4MJnsWYgjByRf6YEfyeYIO/hpBkwAcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri3RcYZviNn3w5c15gCWcFfbiCW3SKPzda0h+GsiQ2Ong37q2RGA1nSLORAy3jicne30fZeY3CQyy3qnWjYV4+6C6rP8nrkuJfmz9P8C3kiFtcFLwya9lRMqGl3nQVg/k9CC+0vZWDcu2rd2Q2FbCzqrLUxAsEhSPl5iVOG+njI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNjCSRPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNjCSRPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2D9C4CEC4;
	Fri, 27 Sep 2024 12:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440433;
	bh=8/tJ1CDmBaDq4MJnsWYgjByRf6YEfyeYIO/hpBkwAcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNjCSRPshY54jtG98Q0MxUGA91xCzMV0UcWOrUYaxgzpaw/z7X36Gchc/wJH5NASp
	 OG5lVSWhWkOB4mYcOWDcIZgGCI/emX2321HUQsUs74/+Z4BVlsQ/O9Dvz+v1xAtVnf
	 ag4UF21XKKEBTSyI9NXlvA180rdOKXk56KicFzGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Diogo Jahchan Koike <djahchankoike@gmail.com>
Subject: [PATCH 6.1 69/73] btrfs: calculate the right space for delayed refs when updating global reserve
Date: Fri, 27 Sep 2024 14:24:20 +0200
Message-ID: <20240927121722.628899970@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Filipe Manana <fdmanana@suse.com>

commit f8f210dc84709804c9f952297f2bfafa6ea6b4bd upstream.

When updating the global block reserve, we account for the 6 items needed
by an unlink operation and the 6 delayed references for each one of those
items. However the calculation for the delayed references is not correct
in case we have the free space tree enabled, as in that case we need to
touch the free space tree as well and therefore need twice the number of
bytes. So use the btrfs_calc_delayed_ref_bytes() helper to calculate the
number of bytes need for the delayed references at
btrfs_update_global_block_rsv().

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[Diogo: this patch has been cherry-picked from the original commit;
conflicts included lack of a define (picked from commit 5630e2bcfe223)
and lack of btrfs_calc_delayed_ref_bytes (picked from commit 0e55a54502b97)
- changed const struct -> struct for compatibility.]
Signed-off-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-rsv.c   |   14 ++++++++------
 fs/btrfs/block-rsv.h   |   12 ++++++++++++
 fs/btrfs/delayed-ref.h |   21 +++++++++++++++++++++
 3 files changed, 41 insertions(+), 6 deletions(-)

--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -384,17 +384,19 @@ void btrfs_update_global_block_rsv(struc
 
 	/*
 	 * But we also want to reserve enough space so we can do the fallback
-	 * global reserve for an unlink, which is an additional 5 items (see the
-	 * comment in __unlink_start_trans for what we're modifying.)
+	 * global reserve for an unlink, which is an additional
+	 * BTRFS_UNLINK_METADATA_UNITS items.
 	 *
 	 * But we also need space for the delayed ref updates from the unlink,
-	 * so its 10, 5 for the actual operation, and 5 for the delayed ref
-	 * updates.
+	 * so add BTRFS_UNLINK_METADATA_UNITS units for delayed refs, one for
+	 * each unlink metadata item.
 	 */
-	min_items += 10;
+	min_items += BTRFS_UNLINK_METADATA_UNITS;
 
 	num_bytes = max_t(u64, num_bytes,
-			  btrfs_calc_insert_metadata_size(fs_info, min_items));
+			  btrfs_calc_insert_metadata_size(fs_info, min_items) +
+			  btrfs_calc_delayed_ref_bytes(fs_info,
+					       BTRFS_UNLINK_METADATA_UNITS));
 
 	spin_lock(&sinfo->lock);
 	spin_lock(&block_rsv->lock);
--- a/fs/btrfs/block-rsv.h
+++ b/fs/btrfs/block-rsv.h
@@ -50,6 +50,18 @@ struct btrfs_block_rsv {
 	u64 qgroup_rsv_reserved;
 };
 
+/*
+ * Number of metadata items necessary for an unlink operation:
+ *
+ * 1 for the possible orphan item
+ * 1 for the dir item
+ * 1 for the dir index
+ * 1 for the inode ref
+ * 1 for the inode
+ * 1 for the parent inode
+ */
+#define BTRFS_UNLINK_METADATA_UNITS		6
+
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, enum btrfs_rsv_type type);
 void btrfs_init_root_block_rsv(struct btrfs_root *root);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_fs_info *fs_info,
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -253,6 +253,27 @@ extern struct kmem_cache *btrfs_delayed_
 int __init btrfs_delayed_ref_init(void);
 void __cold btrfs_delayed_ref_exit(void);
 
+static inline u64 btrfs_calc_delayed_ref_bytes(struct btrfs_fs_info *fs_info,
+					       int num_delayed_refs)
+{
+	u64 num_bytes;
+
+	num_bytes = btrfs_calc_insert_metadata_size(fs_info, num_delayed_refs);
+
+	/*
+	 * We have to check the mount option here because we could be enabling
+	 * the free space tree for the first time and don't have the compat_ro
+	 * option set yet.
+	 *
+	 * We need extra reservations if we have the free space tree because
+	 * we'll have to modify that tree as well.
+	 */
+	if (btrfs_test_opt(fs_info, FREE_SPACE_TREE))
+		num_bytes *= 2;
+
+	return num_bytes;
+}
+
 static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
 				int action, u64 bytenr, u64 len, u64 parent)
 {


