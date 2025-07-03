Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A5219F43A;
	Thu,  3 Jul 2025 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554122; cv=none; b=alEbjgai6+tVV9I55TtdbB4rgvey5oyDUZ4tnBFzHdM1uZW65KDa/F2KplpiVRKAL4zh2loEwqP7aiEVUt5VmgGdXq4DNehwQItmu9CNMdlehiJJVdE+9k0DpMgyNEmH78pMEtIccP98KCxxvh9fJRylIX5jWZ0mi3byHzfM4Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554122; c=relaxed/simple;
	bh=UXlIQHWsl50hh5KnJYUbtE/E+qIGLUxIEdk7BiN5Ctk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEKly08EXfPRjSBjzJsIrZY4JOV0Ry3pNN4zOTSuW0dSRp0oLkDLB1D65UE6h4EIDHKU1cRCDHR+gPuFXGiRPJz7OXhT7d9mmPHn2FMe9ZP5UdjdkfIIBlEdjOvDSGSknb9AmyrzMIKm5gJH7LMaCtVDoKq/3/cSkDeHjr8NOdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t14cXiln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t14cXiln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B708C4CEE3;
	Thu,  3 Jul 2025 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554121;
	bh=UXlIQHWsl50hh5KnJYUbtE/E+qIGLUxIEdk7BiN5Ctk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t14cXilnYG4O4UTZPqwB4CF0kAM5aOLwzTgjRPLZ03g2fB/1gVUrYIhu5XXH6NrIB
	 3PB+2MQxZU+SxQxPX5X7bMPpcHzvOm4LYv1MHIZd8AykUMWTHIs5KY3bU/kneqFov/
	 whQKevfa4v8K7ccdRpVBVc+uuwr+4uqodyyI8zXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/218] btrfs: factor out nocow ordered extent and extent map generation into a helper
Date: Thu,  3 Jul 2025 16:40:08 +0200
Message-ID: <20250703143958.344019730@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 10326fdcb3ace2f2dcbc8b9fc50b87e5cab93345 ]

Currently we're doing all the ordered extent and extent map generation
inside a while() loop of run_delalloc_nocow().  This makes it pretty
hard to read, nor doing proper error handling.

So move that part of code into a helper, nocow_one_range().

This should not change anything, but there is a tiny timing change where
btrfs_dec_nocow_writers() is only called after nocow_one_range() helper
exits.

This timing change is small, and makes error handling easier, thus
should be fine.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1f2889f5594a ("btrfs: fix qgroup reservation leak on failure to allocate ordered extent")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 122 +++++++++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 61 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1ab5b0c1b9b76..65517efd3433e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2055,6 +2055,63 @@ static void cleanup_dirty_folios(struct btrfs_inode *inode,
 	mapping_set_error(mapping, error);
 }
 
+static int nocow_one_range(struct btrfs_inode *inode, struct folio *locked_folio,
+			   struct extent_state **cached,
+			   struct can_nocow_file_extent_args *nocow_args,
+			   u64 file_pos, bool is_prealloc)
+{
+	struct btrfs_ordered_extent *ordered;
+	u64 len = nocow_args->file_extent.num_bytes;
+	u64 end = file_pos + len - 1;
+	int ret = 0;
+
+	lock_extent(&inode->io_tree, file_pos, end, cached);
+
+	if (is_prealloc) {
+		struct extent_map *em;
+
+		em = btrfs_create_io_em(inode, file_pos, &nocow_args->file_extent,
+					BTRFS_ORDERED_PREALLOC);
+		if (IS_ERR(em)) {
+			unlock_extent(&inode->io_tree, file_pos, end, cached);
+			return PTR_ERR(em);
+		}
+		free_extent_map(em);
+	}
+
+	ordered = btrfs_alloc_ordered_extent(inode, file_pos, &nocow_args->file_extent,
+					     is_prealloc
+					     ? (1 << BTRFS_ORDERED_PREALLOC)
+					     : (1 << BTRFS_ORDERED_NOCOW));
+	if (IS_ERR(ordered)) {
+		if (is_prealloc)
+			btrfs_drop_extent_map_range(inode, file_pos, end, false);
+		unlock_extent(&inode->io_tree, file_pos, end, cached);
+		return PTR_ERR(ordered);
+	}
+
+	if (btrfs_is_data_reloc_root(inode->root))
+		/*
+		 * Errors are handled later, as we must prevent
+		 * extent_clear_unlock_delalloc() in error handler from freeing
+		 * metadata of the created ordered extent.
+		 */
+		ret = btrfs_reloc_clone_csums(ordered);
+	btrfs_put_ordered_extent(ordered);
+
+	extent_clear_unlock_delalloc(inode, file_pos, end, locked_folio, cached,
+				     EXTENT_LOCKED | EXTENT_DELALLOC |
+				     EXTENT_CLEAR_DATA_RESV,
+				     PAGE_UNLOCK | PAGE_SET_ORDERED);
+
+	/*
+	 * btrfs_reloc_clone_csums() error, now we're OK to call error handler,
+	 * as metadata for created ordered extent will only be freed by
+	 * btrfs_finish_ordered_io().
+	 */
+	return ret;
+}
+
 /*
  * when nowcow writeback call back.  This checks for snapshots or COW copies
  * of the extents that exist in the file, and COWs the file as required.
@@ -2099,15 +2156,12 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 
 	while (cur_offset <= end) {
 		struct btrfs_block_group *nocow_bg = NULL;
-		struct btrfs_ordered_extent *ordered;
 		struct btrfs_key found_key;
 		struct btrfs_file_extent_item *fi;
 		struct extent_buffer *leaf;
 		struct extent_state *cached_state = NULL;
 		u64 extent_end;
-		u64 nocow_end;
 		int extent_type;
-		bool is_prealloc;
 
 		ret = btrfs_lookup_file_extent(NULL, root, path, ino,
 					       cur_offset, 0);
@@ -2242,67 +2296,13 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 			}
 		}
 
-		nocow_end = cur_offset + nocow_args.file_extent.num_bytes - 1;
-		lock_extent(&inode->io_tree, cur_offset, nocow_end, &cached_state);
-
-		is_prealloc = extent_type == BTRFS_FILE_EXTENT_PREALLOC;
-		if (is_prealloc) {
-			struct extent_map *em;
-
-			em = btrfs_create_io_em(inode, cur_offset,
-						&nocow_args.file_extent,
-						BTRFS_ORDERED_PREALLOC);
-			if (IS_ERR(em)) {
-				unlock_extent(&inode->io_tree, cur_offset,
-					      nocow_end, &cached_state);
-				btrfs_dec_nocow_writers(nocow_bg);
-				ret = PTR_ERR(em);
-				goto error;
-			}
-			free_extent_map(em);
-		}
-
-		ordered = btrfs_alloc_ordered_extent(inode, cur_offset,
-				&nocow_args.file_extent,
-				is_prealloc
-				? (1 << BTRFS_ORDERED_PREALLOC)
-				: (1 << BTRFS_ORDERED_NOCOW));
+		ret = nocow_one_range(inode, locked_folio, &cached_state,
+				      &nocow_args, cur_offset,
+				      extent_type == BTRFS_FILE_EXTENT_PREALLOC);
 		btrfs_dec_nocow_writers(nocow_bg);
-		if (IS_ERR(ordered)) {
-			if (is_prealloc) {
-				btrfs_drop_extent_map_range(inode, cur_offset,
-							    nocow_end, false);
-			}
-			unlock_extent(&inode->io_tree, cur_offset,
-				      nocow_end, &cached_state);
-			ret = PTR_ERR(ordered);
+		if (ret < 0)
 			goto error;
-		}
-
-		if (btrfs_is_data_reloc_root(root))
-			/*
-			 * Error handled later, as we must prevent
-			 * extent_clear_unlock_delalloc() in error handler
-			 * from freeing metadata of created ordered extent.
-			 */
-			ret = btrfs_reloc_clone_csums(ordered);
-		btrfs_put_ordered_extent(ordered);
-
-		extent_clear_unlock_delalloc(inode, cur_offset, nocow_end,
-					     locked_folio, &cached_state,
-					     EXTENT_LOCKED | EXTENT_DELALLOC |
-					     EXTENT_CLEAR_DATA_RESV,
-					     PAGE_UNLOCK | PAGE_SET_ORDERED);
-
 		cur_offset = extent_end;
-
-		/*
-		 * btrfs_reloc_clone_csums() error, now we're OK to call error
-		 * handler, as metadata for created ordered extent will only
-		 * be freed by btrfs_finish_ordered_io().
-		 */
-		if (ret)
-			goto error;
 	}
 	btrfs_release_path(path);
 
-- 
2.39.5



