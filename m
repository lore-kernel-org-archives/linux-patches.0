Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753B8353360;
	Tue, 26 Aug 2025 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219414; cv=none; b=jwUl0U/dWEFkmAtQJ/kQoMIGffiZRWYB7SZDnFifjmVF8eyKbQj5FmVOJ+LqEQ8iHJfSSghV3WElkAKHbphoe83YOB2KsysvWZ1+oWN3fFuRCGCdwMlXAc4yhOXXnD1kbhQy2aRlewnqYcA6CQ33vZbRSvYXGK0Egf3nOT3eTq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219414; c=relaxed/simple;
	bh=3La+myHi3hFPsRzGMXBXNzGxT2KjyGywOEulOo9Zzek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efnFfeFHjYCvR4aX0+9S5c8MJat4tz8txMrbBBAAyoWLalGoSqKpi6QAqA5iZGDGPsTboxtbLfSYpKKxOw9Uub+MkXI6uG99XRdjEq+t/1QB4fdUQYLlDbmGGSFEtiO3d95Wq92cGah7MT7TAojdExw1KMw/5yaUvrs6nV4ATzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0I01q4OD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0I01q4OD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05601C4CEF1;
	Tue, 26 Aug 2025 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219414;
	bh=3La+myHi3hFPsRzGMXBXNzGxT2KjyGywOEulOo9Zzek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0I01q4ODWRP2L1M9XXVv4+AxASgdefYKCJdunvJTg6cNTd5Pm6JRlOJR4l4nF06AL
	 rzfeZfV0LrKot4W6521iyF3AeNDV7WNYtj5W3+XTWTvTvKCGaKpGQgNJk8s7DATgEd
	 5q2juGNTWjzTKKvjST5eq1sv4BkjtXueLpxR0Xog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiaming Zhang <r772577952@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 372/403] f2fs: fix to avoid out-of-boundary access in dnode page
Date: Tue, 26 Aug 2025 13:11:38 +0200
Message-ID: <20250826110917.290329271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 77de19b6867f2740cdcb6c9c7e50d522b47847a4 ]

As Jiaming Zhang reported:

 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x1c1/0x2a0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x17e/0x800 mm/kasan/report.c:480
 kasan_report+0x147/0x180 mm/kasan/report.c:593
 data_blkaddr fs/f2fs/f2fs.h:3053 [inline]
 f2fs_data_blkaddr fs/f2fs/f2fs.h:3058 [inline]
 f2fs_get_dnode_of_data+0x1a09/0x1c40 fs/f2fs/node.c:855
 f2fs_reserve_block+0x53/0x310 fs/f2fs/data.c:1195
 prepare_write_begin fs/f2fs/data.c:3395 [inline]
 f2fs_write_begin+0xf39/0x2190 fs/f2fs/data.c:3594
 generic_perform_write+0x2c7/0x910 mm/filemap.c:4112
 f2fs_buffered_write_iter fs/f2fs/file.c:4988 [inline]
 f2fs_file_write_iter+0x1ec8/0x2410 fs/f2fs/file.c:5216
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x546/0xa90 fs/read_write.c:686
 ksys_write+0x149/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x3d0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The root cause is in the corrupted image, there is a dnode has the same
node id w/ its inode, so during f2fs_get_dnode_of_data(), it tries to
access block address in dnode at offset 934, however it parses the dnode
as inode node, so that get_dnode_addr() returns 360, then it tries to
access page address from 360 + 934 * 4 = 4096 w/ 4 bytes.

To fix this issue, let's add sanity check for node id of all direct nodes
during f2fs_get_dnode_of_data().

Cc: stable@kernel.org
Reported-by: Jiaming Zhang <r772577952@gmail.com>
Closes: https://groups.google.com/g/syzkaller/c/-ZnaaOOfO3M
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ replaced f2fs_err_ratelimited() with f2fs_err() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -764,6 +764,16 @@ int f2fs_get_dnode_of_data(struct dnode_
 	for (i = 1; i <= level; i++) {
 		bool done = false;
 
+		if (nids[i] && nids[i] == dn->inode->i_ino) {
+			err = -EFSCORRUPTED;
+			f2fs_err(sbi,
+				"inode mapping table is corrupted, run fsck to fix it, "
+				"ino:%lu, nid:%u, level:%d, offset:%d",
+				dn->inode->i_ino, nids[i], level, offset[level]);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			goto release_pages;
+		}
+
 		if (!nids[i] && mode == ALLOC_NODE) {
 			/* alloc new node */
 			if (!f2fs_alloc_nid(sbi, &(nids[i]))) {


