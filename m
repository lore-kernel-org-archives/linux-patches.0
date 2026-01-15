Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803142D73BE;
	Thu, 15 Jan 2026 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496535; cv=none; b=dwOYHlAS8TNE12pZjF2HeEdIwQ1WwZL8M1eO+iwf2AU2Pc0egiKaybSn30ypaYGetfNjgg0sJa/CegNzjAn8TtoA3FcYhqHHfTyqM/cmGYSw78dgpuCXCDKhU/oR3y3L2QHxiS7HW7q2q7NOZJ9L1PtsLozBVoOxGEdHTVjaBbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496535; c=relaxed/simple;
	bh=N3yBfDDSaAU370tf50fSnq6LilCt96MjmQmsgZPcEB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLePxkVd9WNEeyLF9IU056FFqEXFWIMPL2rzYWp4Jj5yYZ+668KeDG3b748umLsivcjEOL3Mxuq9zm+6N+eCjtOwUsMFNMguSpctaisFDoJtTBn2/wcAORoPi4iPV5i7AjlV0YK7/olUxrwmGfAryYVDIqojKNzWcPsO7ShboBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnoHy0U4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnoHy0U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE02C116D0;
	Thu, 15 Jan 2026 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496535;
	bh=N3yBfDDSaAU370tf50fSnq6LilCt96MjmQmsgZPcEB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnoHy0U4zWTzJls1q9h3uYqMyJnLybFIjJqprKVvul2Eh9A+g9TVwhdRQScnylMsJ
	 LgojwIkOZfPpS1me7YijD9w6G4R1JTDTvod/A+7Hmk0s3dY+EpgtCFL8piIEvMzdgq
	 ip0FPjhMDW50ufwPUMe7B9XUlaPfCSYpl8/MHuPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/119] btrfs: tracepoints: use btrfs_root_id() to get the id of a root
Date: Thu, 15 Jan 2026 17:47:42 +0100
Message-ID: <20260115164153.657873323@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 0f987c099d22c3b8c7d94fd13f957792e46f79c9 ]

Instead of open coding btrfs_root_id() to get the ID of a root, use the
helper in the trace points, which also makes the code less verbose.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: f157dd661339 ("btrfs: fix NULL dereference on root when tracing inode eviction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/btrfs.h | 50 +++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 3b16b0cc1b7a6..cc88074914283 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -223,8 +223,7 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 		__entry->generation = BTRFS_I(inode)->generation;
 		__entry->last_trans = BTRFS_I(inode)->last_trans;
 		__entry->logged_trans = BTRFS_I(inode)->logged_trans;
-		__entry->root_objectid =
-				BTRFS_I(inode)->root->root_key.objectid;
+		__entry->root_objectid = btrfs_root_id(BTRFS_I(inode)->root);
 	),
 
 	TP_printk_btrfs("root=%llu(%s) gen=%llu ino=%llu blocks=%llu "
@@ -296,7 +295,7 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(root);
 		__entry->ino		= btrfs_ino(inode);
 		__entry->start		= map->start;
 		__entry->len		= map->len;
@@ -375,7 +374,7 @@ DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular,
 	),
 
 	TP_fast_assign_btrfs(bi->root->fs_info,
-		__entry->root_obj	= bi->root->root_key.objectid;
+		__entry->root_obj	= btrfs_root_id(bi->root);
 		__entry->ino		= btrfs_ino(bi);
 		__entry->isize		= bi->vfs_inode.i_size;
 		__entry->disk_isize	= bi->disk_i_size;
@@ -426,7 +425,7 @@ DECLARE_EVENT_CLASS(
 
 	TP_fast_assign_btrfs(
 		bi->root->fs_info,
-		__entry->root_obj	= bi->root->root_key.objectid;
+		__entry->root_obj	= btrfs_root_id(bi->root);
 		__entry->ino		= btrfs_ino(bi);
 		__entry->isize		= bi->vfs_inode.i_size;
 		__entry->disk_isize	= bi->disk_i_size;
@@ -526,7 +525,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 		__entry->flags		= ordered->flags;
 		__entry->compress_type	= ordered->compress_type;
 		__entry->refs		= refcount_read(&ordered->refs);
-		__entry->root_objectid	= inode->root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(inode->root);
 		__entry->truncated_len	= ordered->truncated_len;
 	),
 
@@ -663,7 +662,7 @@ TRACE_EVENT(btrfs_finish_ordered_extent,
 		__entry->start	= start;
 		__entry->len	= len;
 		__entry->uptodate = uptodate;
-		__entry->root_objectid = inode->root->root_key.objectid;
+		__entry->root_objectid = btrfs_root_id(inode->root);
 	),
 
 	TP_printk_btrfs("root=%llu(%s) ino=%llu start=%llu len=%llu uptodate=%d",
@@ -704,8 +703,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
-		__entry->root_objectid	=
-				 BTRFS_I(inode)->root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
 	),
 
 	TP_printk_btrfs("root=%llu(%s) ino=%llu page_index=%lu "
@@ -749,7 +747,7 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
 		__entry->start	= start;
 		__entry->end	= end;
 		__entry->uptodate = uptodate;
-		__entry->root_objectid = inode->root->root_key.objectid;
+		__entry->root_objectid = btrfs_root_id(inode->root);
 	),
 
 	TP_printk_btrfs("root=%llu(%s) ino=%llu start=%llu end=%llu uptodate=%d",
@@ -779,8 +777,7 @@ TRACE_EVENT(btrfs_sync_file,
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
 		__entry->parent		= btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
 		__entry->datasync	= datasync;
-		__entry->root_objectid	=
-				 BTRFS_I(inode)->root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
 	),
 
 	TP_printk_btrfs("root=%llu(%s) ino=%llu parent=%llu datasync=%d",
@@ -1051,7 +1048,7 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
 		__entry->sub_stripes	= map->sub_stripes;
 		__entry->offset		= offset;
 		__entry->size		= size;
-		__entry->root_objectid	= fs_info->chunk_root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(fs_info->chunk_root);
 	),
 
 	TP_printk_btrfs("root=%llu(%s) offset=%llu size=%llu "
@@ -1096,7 +1093,7 @@ TRACE_EVENT(btrfs_cow_block,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(root);
 		__entry->buf_start	= buf->start;
 		__entry->refs		= atomic_read(&buf->refs);
 		__entry->cow_start	= cow->start;
@@ -1254,7 +1251,7 @@ TRACE_EVENT(find_free_extent,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(root);
 		__entry->num_bytes	= ffe_ctl->num_bytes;
 		__entry->empty_size	= ffe_ctl->empty_size;
 		__entry->flags		= ffe_ctl->flags;
@@ -1283,7 +1280,7 @@ TRACE_EVENT(find_free_extent_search_loop,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(root);
 		__entry->num_bytes	= ffe_ctl->num_bytes;
 		__entry->empty_size	= ffe_ctl->empty_size;
 		__entry->flags		= ffe_ctl->flags;
@@ -1317,7 +1314,7 @@ TRACE_EVENT(find_free_extent_have_block_group,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(root);
 		__entry->num_bytes	= ffe_ctl->num_bytes;
 		__entry->empty_size	= ffe_ctl->empty_size;
 		__entry->flags		= ffe_ctl->flags;
@@ -1671,8 +1668,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
 	),
 
 	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
-		__entry->rootid		=
-			BTRFS_I(inode)->root->root_key.objectid;
+		__entry->rootid		= btrfs_root_id(BTRFS_I(inode)->root);
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
 		__entry->start		= start;
 		__entry->len		= len;
@@ -1862,7 +1858,7 @@ TRACE_EVENT(qgroup_meta_reserve,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->refroot	= root->root_key.objectid;
+		__entry->refroot	= btrfs_root_id(root);
 		__entry->diff		= diff;
 		__entry->type		= type;
 	),
@@ -1884,7 +1880,7 @@ TRACE_EVENT(qgroup_meta_convert,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->refroot	= root->root_key.objectid;
+		__entry->refroot	= btrfs_root_id(root);
 		__entry->diff		= diff;
 	),
 
@@ -1908,7 +1904,7 @@ TRACE_EVENT(qgroup_meta_free_all_pertrans,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->refroot	= root->root_key.objectid;
+		__entry->refroot	= btrfs_root_id(root);
 		spin_lock(&root->qgroup_meta_rsv_lock);
 		__entry->diff		= -(s64)root->qgroup_meta_rsv_pertrans;
 		spin_unlock(&root->qgroup_meta_rsv_lock);
@@ -1990,7 +1986,7 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+		__entry->root_objectid	= btrfs_root_id(root);
 		__entry->ino		= ino;
 		__entry->mod		= mod;
 		__entry->outstanding    = outstanding;
@@ -2075,7 +2071,7 @@ TRACE_EVENT(btrfs_set_extent_bit,
 
 		__entry->owner		= tree->owner;
 		__entry->ino		= inode ? btrfs_ino(inode) : 0;
-		__entry->rootid		= inode ? inode->root->root_key.objectid : 0;
+		__entry->rootid		= inode ? btrfs_root_id(inode->root) : 0;
 		__entry->start		= start;
 		__entry->len		= len;
 		__entry->set_bits	= set_bits;
@@ -2108,7 +2104,7 @@ TRACE_EVENT(btrfs_clear_extent_bit,
 
 		__entry->owner		= tree->owner;
 		__entry->ino		= inode ? btrfs_ino(inode) : 0;
-		__entry->rootid		= inode ? inode->root->root_key.objectid : 0;
+		__entry->rootid		= inode ? btrfs_root_id(inode->root) : 0;
 		__entry->start		= start;
 		__entry->len		= len;
 		__entry->clear_bits	= clear_bits;
@@ -2142,7 +2138,7 @@ TRACE_EVENT(btrfs_convert_extent_bit,
 
 		__entry->owner		= tree->owner;
 		__entry->ino		= inode ? btrfs_ino(inode) : 0;
-		__entry->rootid		= inode ? inode->root->root_key.objectid : 0;
+		__entry->rootid		= inode ? btrfs_root_id(inode->root) : 0;
 		__entry->start		= start;
 		__entry->len		= len;
 		__entry->set_bits	= set_bits;
@@ -2619,7 +2615,7 @@ TRACE_EVENT(btrfs_extent_map_shrinker_remove_em,
 
 	TP_fast_assign_btrfs(inode->root->fs_info,
 		__entry->ino		= btrfs_ino(inode);
-		__entry->root_id	= inode->root->root_key.objectid;
+		__entry->root_id	= btrfs_root_id(inode->root);
 		__entry->start		= em->start;
 		__entry->len		= em->len;
 		__entry->flags		= em->flags;
-- 
2.51.0



