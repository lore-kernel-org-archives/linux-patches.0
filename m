Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FED1DDCE;
	Tue, 16 Jul 2024 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145883; cv=none; b=t67NSjAN8Oo239p3Y+KKdvpZ0mNLpZ/nEAGpEt1ef6x/ujdWn0aD+zG6Ss+0mLdn+gTIvieEH3fJjOnpJlFMU/6FkS71eakuCUapKMhNOEu0y2dZ1ITIbqt8gJZwEd0d/QhoXlnzTNm0Rn0ENiAfEOM8MR9IwwRGgL0Qbt15CrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145883; c=relaxed/simple;
	bh=gJ2BRvl8eaIBxpHu6wyIn5MdzIBKIw3wjnfTkVVgqLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opZ7IPLzE7e12b5va75QvWXnA2NDe2FyBCgksW7waGzliWkVrHr+xb+0Y7tgIwiiftc5nb85259ks2jbAdaC2SrPkCRfeEwfyCzDS8nzrc4FOS3egL+jB4LQ3gc2YbNpwU8a19Wz6DsJLvyrMsF4S3N+3UIiOt+I/4qPrm5T3X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYEl2FT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYEl2FT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81063C116B1;
	Tue, 16 Jul 2024 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145882;
	bh=gJ2BRvl8eaIBxpHu6wyIn5MdzIBKIw3wjnfTkVVgqLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYEl2FT7PZoAFSUGp1ZtNcuw5xgNnip7VNqSMe6+jlYLDXpVNVG+GeM1MN5Zv1I4W
	 sdKQ7i/NdAKYOgmrBHbuywh0/kJDZ6o1qaVlt7GHFOmmwcICb3/p43h8u54x6NLULJ
	 rR9CCz6Xfi1yzjNEvWywzrYM3KKK+VZewqQPeVP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH 6.6 109/121] btrfs: tree-checker: add type and sequence check for inline backrefs
Date: Tue, 16 Jul 2024 17:32:51 +0200
Message-ID: <20240716152755.523172300@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 1645c283a87c61f84b2bffd81f50724df959b11a upstream.

[BUG]
There is a bug report that ntfs2btrfs had a bug that it can lead to
transaction abort and the filesystem flips to read-only.

[CAUSE]
For inline backref items, kernel has a strict requirement for their
ordered, they must follow the following rules:

- All btrfs_extent_inline_ref::type should be in an ascending order

- Within the same type, the items should follow a descending order by
  their sequence number

  For EXTENT_DATA_REF type, the sequence number is result from
  hash_extent_data_ref().
  For other types, their sequence numbers are
  btrfs_extent_inline_ref::offset.

Thus if there is any code not following above rules, the resulted
inline backrefs can prevent the kernel to locate the needed inline
backref and lead to transaction abort.

[FIX]
Ntrfs2btrfs has already fixed the problem, and btrfs-progs has added the
ability to detect such problems.

For kernel, let's be more noisy and be more specific about the order, so
that the next time kernel hits such problem we would reject it in the
first place, without leading to transaction abort.

Link: https://github.com/kdave/btrfs-progs/pull/622
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ Fix a conflict due to header cleanup. ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -29,6 +29,7 @@
 #include "accessors.h"
 #include "file-item.h"
 #include "inode-item.h"
+#include "extent-tree.h"
 
 /*
  * Error message should follow the following format:
@@ -1274,6 +1275,8 @@ static int check_extent_item(struct exte
 	unsigned long ptr;	/* Current pointer inside inline refs */
 	unsigned long end;	/* Extent item end */
 	const u32 item_size = btrfs_item_size(leaf, slot);
+	u8 last_type = 0;
+	u64 last_seq = U64_MAX;
 	u64 flags;
 	u64 generation;
 	u64 total_refs;		/* Total refs in btrfs_extent_item */
@@ -1320,6 +1323,18 @@ static int check_extent_item(struct exte
 	 *    2.2) Ref type specific data
 	 *         Either using btrfs_extent_inline_ref::offset, or specific
 	 *         data structure.
+	 *
+	 *    All above inline items should follow the order:
+	 *
+	 *    - All btrfs_extent_inline_ref::type should be in an ascending
+	 *      order
+	 *
+	 *    - Within the same type, the items should follow a descending
+	 *      order by their sequence number. The sequence number is
+	 *      determined by:
+	 *      * btrfs_extent_inline_ref::offset for all types  other than
+	 *        EXTENT_DATA_REF
+	 *      * hash_extent_data_ref() for EXTENT_DATA_REF
 	 */
 	if (unlikely(item_size < sizeof(*ei))) {
 		extent_err(leaf, slot,
@@ -1401,6 +1416,7 @@ static int check_extent_item(struct exte
 		struct btrfs_extent_inline_ref *iref;
 		struct btrfs_extent_data_ref *dref;
 		struct btrfs_shared_data_ref *sref;
+		u64 seq;
 		u64 dref_offset;
 		u64 inline_offset;
 		u8 inline_type;
@@ -1414,6 +1430,7 @@ static int check_extent_item(struct exte
 		iref = (struct btrfs_extent_inline_ref *)ptr;
 		inline_type = btrfs_extent_inline_ref_type(leaf, iref);
 		inline_offset = btrfs_extent_inline_ref_offset(leaf, iref);
+		seq = inline_offset;
 		if (unlikely(ptr + btrfs_extent_inline_ref_size(inline_type) > end)) {
 			extent_err(leaf, slot,
 "inline ref item overflows extent item, ptr %lu iref size %u end %lu",
@@ -1444,6 +1461,10 @@ static int check_extent_item(struct exte
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
 			dref_offset = btrfs_extent_data_ref_offset(leaf, dref);
+			seq = hash_extent_data_ref(
+					btrfs_extent_data_ref_root(leaf, dref),
+					btrfs_extent_data_ref_objectid(leaf, dref),
+					btrfs_extent_data_ref_offset(leaf, dref));
 			if (unlikely(!IS_ALIGNED(dref_offset,
 						 fs_info->sectorsize))) {
 				extent_err(leaf, slot,
@@ -1470,6 +1491,24 @@ static int check_extent_item(struct exte
 				   inline_type);
 			return -EUCLEAN;
 		}
+		if (inline_type < last_type) {
+			extent_err(leaf, slot,
+				   "inline ref out-of-order: has type %u, prev type %u",
+				   inline_type, last_type);
+			return -EUCLEAN;
+		}
+		/* Type changed, allow the sequence starts from U64_MAX again. */
+		if (inline_type > last_type)
+			last_seq = U64_MAX;
+		if (seq > last_seq) {
+			extent_err(leaf, slot,
+"inline ref out-of-order: has type %u offset %llu seq 0x%llx, prev type %u seq 0x%llx",
+				   inline_type, inline_offset, seq,
+				   last_type, last_seq);
+			return -EUCLEAN;
+		}
+		last_type = inline_type;
+		last_seq = seq;
 		ptr += btrfs_extent_inline_ref_size(inline_type);
 	}
 	/* No padding is allowed */


