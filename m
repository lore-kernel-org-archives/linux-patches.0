Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA741714DD;
	Thu, 15 Aug 2024 14:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731353; cv=none; b=Zi5idwbw33zye8hfPflghSU8GLeqdZaJQc3IYGvWUDf4FTw1gj6/nBOQw1t1J4ya9pm8rZ14VwjYDgAIrndKduYcGPcRdvU4RXwAum8qWtnx9VtMvI9G4dSWHXrZcxEzt9uAVcy/I9joLs29F8PC2Xvzik+mSBI8Yn/vorxYWW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731353; c=relaxed/simple;
	bh=T+/+Af+L9TNq2aeNIsLDTT6BXgJEUDLm18bJP3c+pqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c53NAM258LJFZoIfxoqQcWnGPStafRlaeI0fEHrpqmRVIRVuUrgriFssTaALIcpM4CGeoXM5GkfD/+u5XPotasSylTL0+Db/fpQ5CLE35DYYWrxyd8p+j9Ad7b+mhrzJCtlaDO1CEOO6+Wq3YJEs4cQOO8ntjgurJUG4l9HZ8Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehj/8IFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehj/8IFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AC0C32786;
	Thu, 15 Aug 2024 14:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731353;
	bh=T+/+Af+L9TNq2aeNIsLDTT6BXgJEUDLm18bJP3c+pqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehj/8IFzCZiEa/9uj6xMCbyd9UpsjWe1Ivy3TyyH80rOMimscUQ8Nm/wJJPL/wQi0
	 jgUF8pEGi021LM61JkdGo/w8H++fkTjVgaEhuHWsHdfiPoVx6+fP01Kcd7f4sLCJbc
	 EhZhp7DNqA/9TxOY6BeVzEduMCwNw24qRrwloCak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ae6be33a50b5aae4dab@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 095/259] hfs: fix to initialize fields of hfs_inode_info after hfs_alloc_inode()
Date: Thu, 15 Aug 2024 15:23:48 +0200
Message-ID: <20240815131906.472200616@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 26a2ed107929a855155429b11e1293b83e6b2a8b upstream.

Syzbot reports uninitialized value access issue as below:

loop0: detected capacity change from 0 to 64
=====================================================
BUG: KMSAN: uninit-value in hfs_revalidate_dentry+0x307/0x3f0 fs/hfs/sysdep.c:30
 hfs_revalidate_dentry+0x307/0x3f0 fs/hfs/sysdep.c:30
 d_revalidate fs/namei.c:862 [inline]
 lookup_fast+0x89e/0x8e0 fs/namei.c:1649
 walk_component fs/namei.c:2001 [inline]
 link_path_walk+0x817/0x1480 fs/namei.c:2332
 path_lookupat+0xd9/0x6f0 fs/namei.c:2485
 filename_lookup+0x22e/0x740 fs/namei.c:2515
 user_path_at_empty+0x8b/0x390 fs/namei.c:2924
 user_path_at include/linux/namei.h:57 [inline]
 do_mount fs/namespace.c:3689 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x66b/0x810 fs/namespace.c:3875
 __x64_sys_mount+0xe4/0x140 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

BUG: KMSAN: uninit-value in hfs_ext_read_extent fs/hfs/extent.c:196 [inline]
BUG: KMSAN: uninit-value in hfs_get_block+0x92d/0x1620 fs/hfs/extent.c:366
 hfs_ext_read_extent fs/hfs/extent.c:196 [inline]
 hfs_get_block+0x92d/0x1620 fs/hfs/extent.c:366
 block_read_full_folio+0x4ff/0x11b0 fs/buffer.c:2271
 hfs_read_folio+0x55/0x60 fs/hfs/inode.c:39
 filemap_read_folio+0x148/0x4f0 mm/filemap.c:2426
 do_read_cache_folio+0x7c8/0xd90 mm/filemap.c:3553
 do_read_cache_page mm/filemap.c:3595 [inline]
 read_cache_page+0xfb/0x2f0 mm/filemap.c:3604
 read_mapping_page include/linux/pagemap.h:755 [inline]
 hfs_btree_open+0x928/0x1ae0 fs/hfs/btree.c:78
 hfs_mdb_get+0x260c/0x3000 fs/hfs/mdb.c:204
 hfs_fill_super+0x1fb1/0x2790 fs/hfs/super.c:406
 mount_bdev+0x628/0x920 fs/super.c:1359
 hfs_mount+0xcd/0xe0 fs/hfs/super.c:456
 legacy_get_tree+0x167/0x2e0 fs/fs_context.c:610
 vfs_get_tree+0xdc/0x5d0 fs/super.c:1489
 do_new_mount+0x7a9/0x16f0 fs/namespace.c:3145
 path_mount+0xf98/0x26a0 fs/namespace.c:3475
 do_mount fs/namespace.c:3488 [inline]
 __do_sys_mount fs/namespace.c:3697 [inline]
 __se_sys_mount+0x919/0x9e0 fs/namespace.c:3674
 __ia32_sys_mount+0x15b/0x1b0 fs/namespace.c:3674
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0xa2/0x100 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x37/0x80 arch/x86/entry/common.c:203
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:246
 entry_SYSENTER_compat_after_hwframe+0x70/0x82

Uninit was created at:
 __alloc_pages+0x9a6/0xe00 mm/page_alloc.c:4590
 __alloc_pages_node include/linux/gfp.h:238 [inline]
 alloc_pages_node include/linux/gfp.h:261 [inline]
 alloc_slab_page mm/slub.c:2190 [inline]
 allocate_slab mm/slub.c:2354 [inline]
 new_slab+0x2d7/0x1400 mm/slub.c:2407
 ___slab_alloc+0x16b5/0x3970 mm/slub.c:3540
 __slab_alloc mm/slub.c:3625 [inline]
 __slab_alloc_node mm/slub.c:3678 [inline]
 slab_alloc_node mm/slub.c:3850 [inline]
 kmem_cache_alloc_lru+0x64d/0xb30 mm/slub.c:3879
 alloc_inode_sb include/linux/fs.h:3018 [inline]
 hfs_alloc_inode+0x5a/0xc0 fs/hfs/super.c:165
 alloc_inode+0x83/0x440 fs/inode.c:260
 new_inode_pseudo fs/inode.c:1005 [inline]
 new_inode+0x38/0x4f0 fs/inode.c:1031
 hfs_new_inode+0x61/0x1010 fs/hfs/inode.c:186
 hfs_mkdir+0x54/0x250 fs/hfs/dir.c:228
 vfs_mkdir+0x49a/0x700 fs/namei.c:4126
 do_mkdirat+0x529/0x810 fs/namei.c:4149
 __do_sys_mkdirat fs/namei.c:4164 [inline]
 __se_sys_mkdirat fs/namei.c:4162 [inline]
 __x64_sys_mkdirat+0xc8/0x120 fs/namei.c:4162
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

It missed to initialize .tz_secondswest, .cached_start and .cached_blocks
fields in struct hfs_inode_info after hfs_alloc_inode(), fix it.

Cc: stable@vger.kernel.org
Reported-by: syzbot+3ae6be33a50b5aae4dab@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-fsdevel/0000000000005ad04005ee48897f@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20240616013841.2217-1-chao@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -199,6 +199,7 @@ struct inode *hfs_new_inode(struct inode
 	HFS_I(inode)->flags = 0;
 	HFS_I(inode)->rsrc_inode = NULL;
 	HFS_I(inode)->fs_blocks = 0;
+	HFS_I(inode)->tz_secondswest = sys_tz.tz_minuteswest * 60;
 	if (S_ISDIR(mode)) {
 		inode->i_size = 2;
 		HFS_SB(sb)->folder_count++;
@@ -274,6 +275,8 @@ void hfs_inode_read_fork(struct inode *i
 	for (count = 0, i = 0; i < 3; i++)
 		count += be16_to_cpu(ext[i].count);
 	HFS_I(inode)->first_blocks = count;
+	HFS_I(inode)->cached_start = 0;
+	HFS_I(inode)->cached_blocks = 0;
 
 	inode->i_size = HFS_I(inode)->phys_size = log_size;
 	HFS_I(inode)->fs_blocks = (log_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;


