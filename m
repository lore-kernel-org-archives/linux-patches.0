Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C251C39A079;
	Thu,  2 Jul 2026 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011093; cv=none; b=Aku4FM9c82BlaZ8C4dxHMeKXKyNrHvKailBLNk5jUbYJxN7/OPdQCuX+NrxS2sx9pI4tpVmxXHXnO69eBkYW/e5S2yzEak0EA9CSlV/nuRdqC5BJgiJPks57w7mq11rw0iMcU9NeCmUsJc0Y2KcT32NUxXCR1kdStCHmU6gooR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011093; c=relaxed/simple;
	bh=5KJF4pHdViQdaahj838Vbgi6Dx7iPXlCzf3AigqBjZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HC4UwdMX43il9hG0nVvZ0B3aBGzOK0/VWW5Yj8BZhyHV3KqwBLEMiTSOUZXcOk5qx+cSs2jMkts35ufzr7EgcL8TZnf/h/b2OFY2ttj+YIAzW6n2MTr07Ea/gkHpNJwWw+O/ojMnZb7NzyBCBIPMz2s7apljeW8mP2pVFV03B8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7H/4meN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7H/4meN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D80F1F000E9;
	Thu,  2 Jul 2026 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011091;
	bh=XVQihK1jPgeAp3E6/6n1E/fRYxit0kFf+xNXWPqzDJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7H/4meNMEmE10DV69d4Curpc7FvPUK749QywjpQ8XloLN8cyIqB5R/8XeSqECm5p
	 3I2S2MnW5/jc7isnW4jp+HPdnd53EgjtE6Xy0EfPljC5cabrC5FY+d/Un/3L5y5grV
	 zKEqOlW8aXO2QNOqP7CeVkbibc8WdlAI9YkmiTVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 154/175] ocfs2: reject oversized group bitmap descriptors
Date: Thu,  2 Jul 2026 18:20:55 +0200
Message-ID: <20260702155119.042335595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

commit 9bd541e09dffff27e5bec0f9f45b0228173a5375 upstream.

ocfs2_validate_gd_parent() only bounds bg_bits against the parent
allocator's chain geometry.  A malicious descriptor can still claim a
bg_size/bg_bits pair that exceeds the bitmap bytes that physically fit in
the group descriptor block, so later bitmap scans and bit updates can run
past bg_bitmap.

Add a physical-cap check based on ocfs2_group_bitmap_size() for the parent
allocator type and reject descriptors whose bg_size or bg_bits exceed that
capacity.  Keep the existing chain geometry check so both the on-disk
bitmap layout and the allocator metadata must agree before the descriptor
is used.

Validation reproduced this kernel report:
KASAN use-after-free in _find_next_bit+0x7f/0xc0
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xd0/0x630 (?:?)
  _find_next_bit+0x7f/0xc0 (?:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x188/0x2f0 (?:?)
  kasan_report+0xe4/0x120 (?:?)
  ocfs2_find_max_contig_free_bits+0x35/0x70 (fs/ocfs2/suballoc.c:1375)
  ocfs2_block_group_set_bits+0x472/0x4b0 (fs/ocfs2/suballoc.c:1457)
  ocfs2_cluster_group_search+0x16b/0x440 (fs/ocfs2/suballoc.c:86)
  ocfs2_bg_discontig_fix_result+0x1ef/0x230 (fs/ocfs2/suballoc.c:1786)
  ocfs2_search_chain+0x8f8/0x10a0 (fs/ocfs2/suballoc.c:1886)
  get_page_from_freelist+0x70e/0x2370 (?:?)
  lock_release+0xc6/0x290 (?:?)
  do_raw_spin_unlock+0x9a/0x100 (?:?)
  kasan_unpoison+0x27/0x60 (?:?)
  __bfs+0x147/0x240 (?:?)
  get_page_from_freelist+0x83d/0x2370 (?:?)
  ocfs2_claim_suballoc_bits+0x38c/0xe70 (fs/ocfs2/suballoc.c:96)
  sched_domains_numa_masks_clear+0x70/0xd0 (?:?)
  check_irq_usage+0xe8/0xb70 (?:?)
  __ocfs2_claim_clusters+0x18d/0x4c0 (fs/ocfs2/suballoc.c:2497)
  check_path+0x24/0x50 (?:?)
  rcu_is_watching+0x20/0x50 (?:?)
  check_prev_add+0xfd/0xd00 (?:?)
  ocfs2_add_clusters_in_btree+0x17d/0x810 (fs/ocfs2/suballoc.c:?)
  __folio_batch_add_and_move+0x1f5/0x3d0 (?:?)
  ocfs2_add_inode_data+0xd9/0x120 (fs/ocfs2/suballoc.c:?)
  filemap_add_folio+0x105/0x1f0 (?:?)
  ocfs2_write_begin_nolock+0x29f7/0x2f80 (fs/ocfs2/suballoc.c:3043)
  ocfs2_read_inode_block+0xb5/0x110 (fs/ocfs2/suballoc.c:?)
  down_write+0xf5/0x180 (?:?)
  ocfs2_write_begin+0x180/0x240 (fs/ocfs2/suballoc.c:?)
  __mark_inode_dirty+0x758/0x9a0 (?:?)
  inode_to_bdi+0x41/0x90 (?:?)
  balance_dirty_pages_ratelimited_flags+0xf8/0x1d0 (?:?)
  generic_perform_write+0x252/0x440 (?:?)
  mnt_put_write_access_file+0x16/0x70 (?:?)
  file_update_time_flags+0xe4/0x200 (?:?)
  ocfs2_file_write_iter+0x80a/0x1320 (fs/ocfs2/suballoc.c:?)
  lock_acquire+0x184/0x2f0 (?:?)
  ksys_write+0xd2/0x170 (?:?)
  apparmor_file_permission+0xf5/0x310 (?:?)
  read_zero+0x8d/0x140 (?:?)
  lock_is_held_type+0x8f/0x100 (?:?)

Link: https://lore.kernel.org/20260524111248.1429884-1-rollkingzzc@gmail.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
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
 fs/ocfs2/suballoc.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -201,8 +201,16 @@ static int ocfs2_validate_gd_parent(stru
 				    int resize)
 {
 	unsigned int max_bits;
+	unsigned int max_bitmap_bits;
+	unsigned int max_bitmap_size;
+	int suballocator;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
+	suballocator = le64_to_cpu(di->i_blkno) != OCFS2_SB(sb)->bitmap_blkno;
+	max_bitmap_size = ocfs2_group_bitmap_size(sb, suballocator,
+						  OCFS2_SB(sb)->s_feature_incompat);
+	max_bitmap_bits = max_bitmap_size * 8;
+
 	if (di->i_blkno != gd->bg_parent_dinode) {
 		do_error("Group descriptor #%llu has bad parent pointer (%llu, expected %llu)\n",
 			 (unsigned long long)bh->b_blocknr,
@@ -210,6 +218,20 @@ static int ocfs2_validate_gd_parent(stru
 			 (unsigned long long)le64_to_cpu(di->i_blkno));
 	}
 
+	if (le16_to_cpu(gd->bg_size) > max_bitmap_size) {
+		do_error("Group descriptor #%llu has bitmap size %u but physical max of %u\n",
+			 (unsigned long long)bh->b_blocknr,
+			 le16_to_cpu(gd->bg_size),
+			 max_bitmap_size);
+	}
+
+	if (le16_to_cpu(gd->bg_bits) > max_bitmap_bits) {
+		do_error("Group descriptor #%llu has bit count %u but physical max of %u\n",
+			 (unsigned long long)bh->b_blocknr,
+			 le16_to_cpu(gd->bg_bits),
+			 max_bitmap_bits);
+	}
+
 	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(gd->bg_bits) > max_bits) {
 		do_error("Group descriptor #%llu has bit count of %u\n",


