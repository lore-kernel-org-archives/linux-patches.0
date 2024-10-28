Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC6118FC75;
	Mon, 28 Oct 2024 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098401; cv=none; b=OZsQg5g+fWIY0jwnU1BQyKbDcxTz72yOP6tEybbti3FwSqk0xB3ONTcsOXeQp6kgb/b5VbpO9aWTA3bgOIhPD2PcSWZFjkAXYKL39xGlKkSmAYbwO02+wfuwELsaRXNWnUwBruM6PYuA/lywddRb7o3/+xpUxqYPTGMyTXzm+C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098401; c=relaxed/simple;
	bh=CvhKbypc4yuQLXrGP/z1TU9WavEnE4XrbaE2SG2I3A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdGW2KVdQpUHexda5zxNycFBi9rQrzQEw9TB9SwbJWaN1zAWh07l/DzB4LW4wsVjGVfriuoE2wSbdeKFjBTZ507b+qKmA7aMfgr+OnhXJV0spjs8LGrMhjx4BxgBZsh0/hC9sQXebPX/2ITZJEo1BeTPwAV7sH6J9N5UOFC8F1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhGA2OgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhGA2OgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB5EC4CEC3;
	Mon, 28 Oct 2024 06:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098401;
	bh=CvhKbypc4yuQLXrGP/z1TU9WavEnE4XrbaE2SG2I3A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhGA2OgWB/YXCtUyIOLWnsQFxLMxdynFqU/7byXQPnaHlSNVZBXqnOqoCpyAoMF/L
	 9KCh7TU9HsLvVOygtq0bKlY1LL6U+QuBn7zmL3tRSWbIt4NeuKFsXNKXXRGlaen65u
	 pnOGlquAHrjTLbZw+LpvNb1hTEZdImK0IwF4/W5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Omar Sandoval <osandov@fb.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 209/261] btrfs: fix read corruption due to race with extent map merging
Date: Mon, 28 Oct 2024 07:25:51 +0100
Message-ID: <20241028062317.314861262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 7a2339058ed71f54c1e12e1b3c25aab1b1ba7943 upstream.

In debugging some corrupt squashfs files, we observed symptoms of
corrupt page cache pages but correct on-disk contents. Further
investigation revealed that the exact symptom was a correct page
followed by an incorrect, duplicate, page. This got us thinking about
extent maps.

commit ac05ca913e9f ("Btrfs: fix race between using extent maps and merging them")
enforces a reference count on the primary `em` extent_map being merged,
as that one gets modified.

However, since,
commit 3d2ac9922465 ("btrfs: introduce new members for extent_map")
both 'em' and 'merge' get modified, which started modifying 'merge'
and thus introduced the same race.

We were able to reproduce this by looping the affected squashfs workload
in parallel on a bunch of separate btrfs-es while also dropping caches.
We are still working on a simple enough reproducer to make into an fstest.

The simplest fix is to stop modifying 'merge', which is not essential,
as it is dropped immediately after the merge. This behavior is simply
a consequence of the order of the two extent maps being important in
computing the new values. Modify merge_ondisk_extents to take prev and
next by const* and also take a third merged parameter that it puts the
results in. Note that this introduces the rather odd behavior of passing
'em' to merge_ondisk_extents as a const * and as a regular ptr.

Fixes: 3d2ac9922465 ("btrfs: introduce new members for extent_map")
CC: stable@vger.kernel.org # 6.11+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_map.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -240,13 +240,19 @@ static bool mergeable_maps(const struct
 /*
  * Handle the on-disk data extents merge for @prev and @next.
  *
+ * @prev:    left extent to merge
+ * @next:    right extent to merge
+ * @merged:  the extent we will not discard after the merge; updated with new values
+ *
+ * After this, one of the two extents is the new merged extent and the other is
+ * removed from the tree and likely freed. Note that @merged is one of @prev/@next
+ * so there is const/non-const aliasing occurring here.
+ *
  * Only touches disk_bytenr/disk_num_bytes/offset/ram_bytes.
  * For now only uncompressed regular extent can be merged.
- *
- * @prev and @next will be both updated to point to the new merged range.
- * Thus one of them should be removed by the caller.
  */
-static void merge_ondisk_extents(struct extent_map *prev, struct extent_map *next)
+static void merge_ondisk_extents(const struct extent_map *prev, const struct extent_map *next,
+				 struct extent_map *merged)
 {
 	u64 new_disk_bytenr;
 	u64 new_disk_num_bytes;
@@ -281,15 +287,10 @@ static void merge_ondisk_extents(struct
 			     new_disk_bytenr;
 	new_offset = prev->disk_bytenr + prev->offset - new_disk_bytenr;
 
-	prev->disk_bytenr = new_disk_bytenr;
-	prev->disk_num_bytes = new_disk_num_bytes;
-	prev->ram_bytes = new_disk_num_bytes;
-	prev->offset = new_offset;
-
-	next->disk_bytenr = new_disk_bytenr;
-	next->disk_num_bytes = new_disk_num_bytes;
-	next->ram_bytes = new_disk_num_bytes;
-	next->offset = new_offset;
+	merged->disk_bytenr = new_disk_bytenr;
+	merged->disk_num_bytes = new_disk_num_bytes;
+	merged->ram_bytes = new_disk_num_bytes;
+	merged->offset = new_offset;
 }
 
 static void dump_extent_map(struct btrfs_fs_info *fs_info, const char *prefix,
@@ -358,7 +359,7 @@ static void try_merge_map(struct btrfs_i
 			em->generation = max(em->generation, merge->generation);
 
 			if (em->disk_bytenr < EXTENT_MAP_LAST_BYTE)
-				merge_ondisk_extents(merge, em);
+				merge_ondisk_extents(merge, em, em);
 			em->flags |= EXTENT_FLAG_MERGED;
 
 			validate_extent_map(fs_info, em);
@@ -375,7 +376,7 @@ static void try_merge_map(struct btrfs_i
 	if (rb && can_merge_extent_map(merge) && mergeable_maps(em, merge)) {
 		em->len += merge->len;
 		if (em->disk_bytenr < EXTENT_MAP_LAST_BYTE)
-			merge_ondisk_extents(em, merge);
+			merge_ondisk_extents(em, merge, em);
 		validate_extent_map(fs_info, em);
 		rb_erase(&merge->rb_node, &tree->root);
 		RB_CLEAR_NODE(&merge->rb_node);


