Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875913CB54E;
	Sat, 12 Sep 2026 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227416; cv=none; b=i4ION11L9OK7Ba9gK9RUh+cd/1hIV32uFCwyZUWFDME5Iy2BWUnb72qGrDUwk/RiEfvI3tWpTffBIHok0ICi75yfDN5XvZuK01x5+k0r3RaYjYhZWzKLs2pj0Qf8QLG2q+SaiSn2am3G5HDginmHbr1yx1xIGBJI9iEm5+CSo4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227416; c=relaxed/simple;
	bh=x3qYs6/ryx9Wa2wQ79kTIStTgVbsZ06GuxdYXoxEulI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQT6Op2DU7zv3lDem3KKScKxijro68mdiM44WOMXbPe4TPzT+HAVf6UQ4Oo2/JN3tS5ae+uBOpjgYtFpW+Vc/3VBc3raNrp5XyBUYaQliJf4h+bPvyql2RDiCzcQaPOSMM/Zx+PobETy/wuw98WWplxI4B0fTp1AFCOm53xw40I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+MFKrxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+MFKrxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710B91F000FF;
	Sat, 12 Sep 2026 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227415;
	bh=eSrpmeMGyDEeC/rSgaJGwASIjq7tHGEXU3fUiLkSPfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+MFKrxlhjDov/brE/xayeu3pPd7N+CpR53sDEYEEQiiktRU4mH82T4rpnQnShJgp
	 eTBHFNg1CCOQw826fVOZY5x0LRHTcZuYIVUs3tkgcF1SGcudV9wdvPZ6NMhoFOuuc9
	 oVJObPmaQHqajkXqmVKpMxw1FShz1sXPwjN5/MbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0149/1191] ocfs2: always run deallocs on copy-on-write completion
Date: Sat, 12 Sep 2026 08:47:57 +0200
Message-ID: <20260912065551.549294384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

commit 82ea9d4fc05fb7a387db547c6a7c0aa6a3719616 upstream.

Local fuzzing of 6.12.94 has found the following memory leak
caused by doing 'copy_file_range()' within the same filesystem:

unreferenced object 0xffff88812192c980 (size 32):
  comm "syz.0.49", pid 12095, jiffies 4294964143
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00  ................
    c0 c5 92 21 81 88 ff ff 00 02 00 00 00 06 00 00  ...!............
  backtrace (crc 7068d63f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    slab_post_alloc_hook mm/slub.c:4152 [inline]
    slab_alloc_node mm/slub.c:4197 [inline]
    __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
    kmalloc_noprof include/linux/slab.h:878 [inline]
    ocfs2_find_per_slot_free_list fs/ocfs2/alloc.c:6618 [inline]
    ocfs2_cache_block_dealloc+0x155/0x4b0 fs/ocfs2/alloc.c:6786
    ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
    ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
    ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
    __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
    ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
    ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
    ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
    ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
    ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
    ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
    ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
    ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
    ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
    ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
    ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
    iter_file_splice_write+0x890/0xf60 fs/splice.c:743
    do_splice_from fs/splice.c:944 [inline]
    direct_splice_actor+0x232/0x480 fs/splice.c:1167
    splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
    do_splice_direct_actor fs/splice.c:1210 [inline]
    do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
    do_sendfile+0x430/0xbf0 fs/read_write.c:1388

unreferenced object 0xffff88812192c5c0 (size 32):
  comm "syz.0.49", pid 12095, jiffies 4294964143
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    29 70 00 00 00 00 00 00 19 00 00 00 00 00 00 00  )p..............
  backtrace (crc afec850f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    slab_post_alloc_hook mm/slub.c:4152 [inline]
    slab_alloc_node mm/slub.c:4197 [inline]
    __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
    kmalloc_noprof include/linux/slab.h:878 [inline]
    kzalloc_noprof include/linux/slab.h:1014 [inline]
    ocfs2_cache_block_dealloc+0x25c/0x4b0 fs/ocfs2/alloc.c:6793
    ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
    ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
    ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
    __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
    ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
    ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
    ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
    ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
    ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
    ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
    ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
    ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
    ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
    ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
    ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
    iter_file_splice_write+0x890/0xf60 fs/splice.c:743
    do_splice_from fs/splice.c:944 [inline]
    direct_splice_actor+0x232/0x480 fs/splice.c:1167
    splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
    do_splice_direct_actor fs/splice.c:1210 [inline]
    do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
    do_sendfile+0x430/0xbf0 fs/read_write.c:1388

This happens when 'ocfs2_cache_block_dealloc()' called from
'ocfs2_cache_extent_block_free()' uses the suballocator to
schedule extent removal, so 'ocfs2_run_deallocs()' should
be run unconditionally to complete the removal with
'ocfs2_free_cached_blocks()'. An extra semi-automated static
analysis [1] suspects that the same scenario looks possible in
'ocfs2_attach_refcount_tree()' and 'ocfs2_reflink_remap_blocks()'
as well, but, since 'ocfs2_run_deallocs()' is a safe no-op for
an empty dealloc context, 'ocfs2_create_reflink_node()' and
'ocfs2_reflink_xattrs()' may be adjusted in the same way too,
thus keeping the code pattern consistent.

Link: https://lore.kernel.org/20260721102840.387663-1-dmantipov@yandex.ru
Link: https://lore.kernel.org/ocfs2-devel/f1d7e266-4b44-41b9-98c0-5b3868a8d9c3@yandex.ru [1]
Fixes: 6f70fa519976 ("ocfs2: Add CoW support.")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/refcounttree.c |   20 ++++++++------------
 fs/ocfs2/xattr.c        |    5 ++---
 2 files changed, 10 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3364,10 +3364,9 @@ static int ocfs2_replace_cow(struct ocfs
 		cow_start += num_clusters;
 	}
 
-	if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&context->dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &context->dealloc);
-	}
+	ocfs2_run_deallocs(osb, &context->dealloc);
 
 	return ret;
 }
@@ -3850,10 +3849,9 @@ unlock:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 
-	if (!ret && ocfs2_dealloc_has_cluster(&dealloc)) {
+	if (!ret && ocfs2_dealloc_has_cluster(&dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &dealloc);
-	}
+	ocfs2_run_deallocs(osb, &dealloc);
 out:
 	/*
 	 * Empty the extent map so that we may get the right extent
@@ -4139,10 +4137,9 @@ out_unlock_refcount:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 out:
-	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &dealloc);
-	}
+	ocfs2_run_deallocs(osb, &dealloc);
 
 	return ret;
 }
@@ -4695,10 +4692,9 @@ loff_t ocfs2_reflink_remap_blocks(struct
 	}
 
 out:
-	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &dealloc);
-	}
+	ocfs2_run_deallocs(osb, &dealloc);
 
 	return ret;
 }
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7200,10 +7200,9 @@ out_unlock:
 				   ref_tree, 1);
 	brelse(ref_root_bh);
 
-	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&dealloc))
 		ocfs2_schedule_truncate_log_flush(OCFS2_SB(old_inode->i_sb), 1);
-		ocfs2_run_deallocs(OCFS2_SB(old_inode->i_sb), &dealloc);
-	}
+	ocfs2_run_deallocs(OCFS2_SB(old_inode->i_sb), &dealloc);
 
 out:
 	return ret;


