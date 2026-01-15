Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1BC3C00A6;
	Thu, 15 Jan 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497241; cv=none; b=teOHulvqWNfJDmeVpr104GfM+xc8nISDny1/mn71eHfbbxJw0tt0G9a9kwJ4Q19uIYe390ip+5sRUHGvvG6Cxl9+D4e3TNXDfpkG6ZvF31+e3x/uCSg/vsDSW13A4UQjmXsB2CSMoVfu5xWdKyuvSamV1H/n9kb8BzGD5kklEro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497241; c=relaxed/simple;
	bh=6IP1Sxf6HqnJj4tbGFhmcLkjYWv5WYyHSG4DPonjhW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QihRpV1j/0ZBQIs3nxhnPcNyeh03ZPFFeIkhnS5U6KzGVf9OK5BbMz5RquthTtEZGV8US8OSc9iDX29m6jQHu2p1nkuPMWjyofyu6zqLb1KHChT9BrEfYk6Y/KyA9wRGiCEaOpBoCRKUYawo2DxgOzfeqfdS/hX2iU8MXY3aS3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8v4jBEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8v4jBEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0A9C116D0;
	Thu, 15 Jan 2026 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497241;
	bh=6IP1Sxf6HqnJj4tbGFhmcLkjYWv5WYyHSG4DPonjhW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8v4jBEv8hmxJsC+GJmBL9/r+cCCsHIedc/8uNw9d5j4CtUuyNhee8IYmKuLR93N9
	 qOpNfrggn6yxFPszZ1xE8opbD2KbszqlcbfIeaLOjntE7/BjxhHTNDLrG1sm9Bh/l1
	 LNylkkRauTw9XIYFaZD633lNJxyTZGrJAcuCMJ74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 013/554] ext4: add i_data_sem protection in ext4_destroy_inline_data_nolock()
Date: Thu, 15 Jan 2026 17:41:19 +0100
Message-ID: <20260115164246.720348670@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Nepomnyashih <sdl@nppct.ru>

commit 0cd8feea8777f8d9b9a862b89c688b049a5c8475 upstream.

Fix a race between inline data destruction and block mapping.

The function ext4_destroy_inline_data_nolock() changes the inode data
layout by clearing EXT4_INODE_INLINE_DATA and setting EXT4_INODE_EXTENTS.
At the same time, another thread may execute ext4_map_blocks(), which
tests EXT4_INODE_EXTENTS to decide whether to call ext4_ext_map_blocks()
or ext4_ind_map_blocks().

Without i_data_sem protection, ext4_ind_map_blocks() may receive inode
with EXT4_INODE_EXTENTS flag and triggering assert.

kernel BUG at fs/ext4/indirect.c:546!
EXT4-fs (loop2): unmounting filesystem.
invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:ext4_ind_map_blocks.cold+0x2b/0x5a fs/ext4/indirect.c:546

Call Trace:
 <TASK>
 ext4_map_blocks+0xb9b/0x16f0 fs/ext4/inode.c:681
 _ext4_get_block+0x242/0x590 fs/ext4/inode.c:822
 ext4_block_write_begin+0x48b/0x12c0 fs/ext4/inode.c:1124
 ext4_write_begin+0x598/0xef0 fs/ext4/inode.c:1255
 ext4_da_write_begin+0x21e/0x9c0 fs/ext4/inode.c:3000
 generic_perform_write+0x259/0x5d0 mm/filemap.c:3846
 ext4_buffered_write_iter+0x15b/0x470 fs/ext4/file.c:285
 ext4_file_write_iter+0x8e0/0x17f0 fs/ext4/file.c:679
 call_write_iter include/linux/fs.h:2271 [inline]
 do_iter_readv_writev+0x212/0x3c0 fs/read_write.c:735
 do_iter_write+0x186/0x710 fs/read_write.c:861
 vfs_iter_write+0x70/0xa0 fs/read_write.c:902
 iter_file_splice_write+0x73b/0xc90 fs/splice.c:685
 do_splice_from fs/splice.c:763 [inline]
 direct_splice_actor+0x10f/0x170 fs/splice.c:950
 splice_direct_to_actor+0x33a/0xa10 fs/splice.c:896
 do_splice_direct+0x1a9/0x280 fs/splice.c:1002
 do_sendfile+0xb13/0x12c0 fs/read_write.c:1255
 __do_sys_sendfile64 fs/read_write.c:1323 [inline]
 __se_sys_sendfile64 fs/read_write.c:1309 [inline]
 __x64_sys_sendfile64+0x1cf/0x210 fs/read_write.c:1309
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Fixes: c755e251357a ("ext4: fix deadlock between inline_data and ext4_expand_extra_isize_ea()")
Cc: stable@vger.kernel.org # v4.11+
Signed-off-by: Alexey Nepomnyashih <sdl@nppct.ru>
Message-ID: <20251104093326.697381-1-sdl@nppct.ru>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -446,9 +446,13 @@ static int ext4_destroy_inline_data_nolo
 	if (!ei->i_inline_off)
 		return 0;
 
+	down_write(&ei->i_data_sem);
+
 	error = ext4_get_inode_loc(inode, &is.iloc);
-	if (error)
+	if (error) {
+		up_write(&ei->i_data_sem);
 		return error;
+	}
 
 	error = ext4_xattr_ibody_find(inode, &i, &is);
 	if (error)
@@ -487,6 +491,7 @@ out:
 	brelse(is.iloc.bh);
 	if (error == -ENODATA)
 		error = 0;
+	up_write(&ei->i_data_sem);
 	return error;
 }
 


