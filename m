Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E037A3FFF82;
	Tue, 21 Jul 2026 17:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653683; cv=none; b=rUUM30sQC7ea7oOb6qacJsEvGAA5Byuafb7m9mnitOirYCH2lhdIIWRuEdP4IG8bglD580pBUwENEhH4jpmfu39F4Rp+Z3WqXm7a986W0SX3xxoPCZMzX20IKZy3YRVi05fZV98PbjV3NrwRHjJXylBxebp7V07laOBvET2fnrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653683; c=relaxed/simple;
	bh=FKgykLW/iPjqTZd1PmlVOswmRLUYQ1YZ4U7TdPVW0pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkLz0YOiQR7kFssAhHf+gVqLIZSXd9lKlNLig2ChBtkg2JjXoBbdqcKc9I12E18tFeTRsmkJb6fwRax09IRSiiwK3iB5r+NJZCa8SgkokQix/uFT2KoZNeTfBK0gAHxUEyg1N2dLBNHvXafblUcJ0xmKXF0peyKrVuUEH/mHk6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAvRgFCt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAvRgFCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425821F000E9;
	Tue, 21 Jul 2026 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653681;
	bh=rR61oR1ka0goAHdHqvlGqpY6KmcdsFTs5NG9OvTZYMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAvRgFCto+fxT+0njNPlGoBFZsEnkY63XRZj9CHPpoRACSQ4noARq0uvz3AY4+ULL
	 ZP3MMO1FFP9mE4rSsW4RzI1xSCA/KZwpMJ5lENbrLpWEh5VnaiPW5EqOpjalffO6ra
	 PcnNhVIOqWEAGrh5gxpMU4QusX5KjC2xaabiLnYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1418/2077] ntfs: avoid stale runlist element dereference in fallocate
Date: Tue, 21 Jul 2026 17:18:11 +0200
Message-ID: <20260721152626.248986608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 88496c4ac5a6ade75619f4b1015706a8b924d50a ]

ntfs_attr_fallocate() allocates holes and delayed allocations inside
initialized size by looking up the current runlist element under
ni->runlist.lock. The returned struct runlist_element is only a borrowed
pointer into ni->runlist.rl. A writer can replace and free that array
after the read lock is dropped, so later reads of rl->lcn, rl->length and
rl->vcn can touch freed memory.

The buggy scenario involves two paths, with each column showing the order
within that path:

ntfs_attr_fallocate():
  1. Take ni->runlist.lock for read.
  2. Get rl from ntfs_attr_find_vcn_nolock().
  3. Drop ni->runlist.lock.
  4. Read rl->lcn, rl->length and rl->vcn.

mmap page_mkwrite:
  1. Enter ntfs_filemap_page_mkwrite().
  2. Reach __ntfs_write_iomap_begin() and ntfs_attr_map_cluster().
  3. Merge allocation state with ntfs_runlists_merge().
  4. Reallocate ni->runlist.rl in ntfs_rl_realloc(), freeing the old array.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in ntfs_attr_fallocate+0xbb8/0xd00

Call Trace:
 <TASK>
 dump_stack_lvl+0x66/0xa0
 print_report+0xce/0x630
 ? ntfs_attr_fallocate+0xbb8/0xd00
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __virt_addr_valid+0x20d/0x410
 ? ntfs_attr_fallocate+0xbb8/0xd00
 kasan_report+0xe0/0x110
 ? ntfs_attr_fallocate+0xbb8/0xd00
 ntfs_attr_fallocate+0xbb8/0xd00
 ? lock_acquire+0x2b8/0x2f0
 ? __pfx_ntfs_attr_fallocate+0x10/0x10
 ? 0xffffffffc0000095
 ? down_write+0x10d/0x1e0
 ntfs_fallocate+0x5c9/0x1d00
 ? __pfx_ntfs_fallocate+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? lock_acquire+0x2b8/0x2f0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? selinux_file_permission+0x3a7/0x510
 vfs_fallocate+0x29d/0xd30
 __x64_sys_fallocate+0xc7/0x150
 ? do_syscall_64+0x81/0x6a0
 do_syscall_64+0x115/0x6a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Allocated by task 410:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0xaa/0xb0
 __kvmalloc_node_noprof+0x353/0x920
 ntfs_rl_realloc+0x3f/0x110
 ntfs_runlists_merge+0xaa3/0x3010
 ntfs_attr_map_cluster+0x4e5/0xf80
 ntfs_attr_fallocate+0x53f/0xd00
 ntfs_fallocate+0x5c9/0x1d00
 vfs_fallocate+0x29d/0xd30
 __x64_sys_fallocate+0xc7/0x150
 do_syscall_64+0x115/0x6a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 424:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x5f/0x80
 kfree+0x307/0x580
 ntfs_rl_realloc+0x6f/0x110
 ntfs_runlists_merge+0x7b1/0x3010
 ntfs_attr_map_cluster+0x4e5/0xf80
 __ntfs_write_iomap_begin+0x8cd/0x2280
 iomap_iter+0x6de/0x11e0
 iomap_page_mkwrite+0x391/0x650
 ntfs_filemap_page_mkwrite+0x1ac/0x400
 do_page_mkwrite+0x15c/0x280
 __handle_mm_fault+0xd6d/0x1ca0
 handle_mm_fault+0x19c/0x470
 do_user_addr_fault+0x23b/0x9c0
 exc_page_fault+0x5c/0xc0
 asm_exc_page_fault+0x26/0x30

Fix this by copying the needed runlist fields while the read lock is still
held and using only those scalar snapshots after unlocking.

After the snapshot, ntfs_attr_map_cluster() can also find that the range
is already mapped and return balloc=false. Only call ntfs_dio_zero_range()
when new clusters were allocated, matching the write iomap path and
preserving the zero-newly-allocated-holes behavior.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index e425c8d074c58a..e8dc4b07bd9759 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5435,6 +5435,7 @@ int ntfs_attr_fallocate(struct ntfs_inode *ni, loff_t start, loff_t byte_len, bo
 	s64 old_data_size;
 	s64 vcn_start, vcn_end, vcn_uninit, vcn, try_alloc_cnt;
 	s64 lcn, alloc_cnt;
+	s64 rl_lcn, rl_length, rl_vcn;
 	int err = 0;
 	struct runlist_element *rl;
 	bool balloc;
@@ -5514,19 +5515,23 @@ int ntfs_attr_fallocate(struct ntfs_inode *ni, loff_t start, loff_t byte_len, bo
 	while (vcn < vcn_uninit) {
 		down_read(&ni->runlist.lock);
 		rl = ntfs_attr_find_vcn_nolock(ni, vcn, NULL);
-		up_read(&ni->runlist.lock);
 		if (IS_ERR(rl)) {
+			up_read(&ni->runlist.lock);
 			err = PTR_ERR(rl);
 			goto out;
 		}
+		rl_lcn = rl->lcn;
+		rl_length = rl->length;
+		rl_vcn = rl->vcn;
+		up_read(&ni->runlist.lock);
 
-		if (rl->lcn > 0) {
-			vcn += rl->length - (vcn - rl->vcn);
-		} else if (rl->lcn == LCN_DELALLOC || rl->lcn == LCN_HOLE) {
-			try_alloc_cnt = min(rl->length - (vcn - rl->vcn),
+		if (rl_lcn > 0) {
+			vcn += rl_length - (vcn - rl_vcn);
+		} else if (rl_lcn == LCN_DELALLOC || rl_lcn == LCN_HOLE) {
+			try_alloc_cnt = min(rl_length - (vcn - rl_vcn),
 					    vcn_uninit - vcn);
 
-			if (rl->lcn == LCN_DELALLOC) {
+			if (rl_lcn == LCN_DELALLOC) {
 				vcn += try_alloc_cnt;
 				continue;
 			}
@@ -5541,11 +5546,14 @@ int ntfs_attr_fallocate(struct ntfs_inode *ni, loff_t start, loff_t byte_len, bo
 				if (err)
 					goto out;
 
-				err = ntfs_dio_zero_range(VFS_I(ni),
-							  lcn << vol->cluster_size_bits,
-							  alloc_cnt << vol->cluster_size_bits);
-				if (err > 0)
-					goto out;
+				if (balloc) {
+					err = ntfs_dio_zero_range(VFS_I(ni),
+								  lcn << vol->cluster_size_bits,
+								  alloc_cnt <<
+								  vol->cluster_size_bits);
+					if (err > 0)
+						goto out;
+				}
 
 				if (signal_pending(current))
 					goto out;
-- 
2.53.0



