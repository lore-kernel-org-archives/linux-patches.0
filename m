Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206093ABD99;
	Mon, 17 Aug 2026 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977872; cv=none; b=eIlQoZltfgPnmWSlzIGCV6XMI3Dxs4KRfXOLDmR/3HWee1yQeL34rIWRnesoDAwtFEnUGTjXC687DzQCl2vbwGNHAI3nHH90q9wK8SUTSfUigkg+J5HOleelpzpQUvgulYcvV73lfMZhdvywgUgQGbjJw7vvlfvDNc0jXZ7hJ20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977872; c=relaxed/simple;
	bh=6ANojbVvJ1XsMcQdfNkCNgfYawGWgOnmwOTQ4kJzvyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCa0nnGTaHebABxXm7vmPMHVvi4TY2msyrmCiYEdFqejx+ikWs5Ys4QOb7ByCfrM2Vkzm1f+KFRrbtOpFBKCiNaRtjj773ozO1hyszNc8Sb73NuOptqvRts4pjWJ5Ms8thefV/b3HwSle56pvlZ0VxQAqAhzwSBBTiCfxTFykgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhDcCJGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhDcCJGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601E61F000E9;
	Mon, 17 Aug 2026 14:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977870;
	bh=JPwPftm3GTSUsZQRVmLwHbnP8HKWSjMAowNAHamKhXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhDcCJGZqD7BAGkw+dIV0zwWN6ZC1nQdSrJL9huVC/CeN2+NBrS6WR9EJM/BTUv/E
	 zi30UTHag4rPha8SBR3cZ95xODPNBxtElxqKlw/Vonek8PJK9p7ALWBhtqcKifsT6b
	 5C3aPcGmwDUWKgDsBw5iyBH6qU+CD9q1pz7Lg7zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/181] btrfs: fix memory leak in btrfs_do_encoded_write()
Date: Mon, 17 Aug 2026 15:31:56 +0200
Message-ID: <20260817132536.261230892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d2a4e4e626b2f4670b69b430c357f03f53eb6632 ]

Local fuzzing of 6.12.94 has found the following memory leak:

Unreferenced object 0xffff888018050a80 (size 64):
  comm "syz.0.17", pid 10297, jiffies 4294953601
  hex dump (first 32 bytes):
    00 10 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
    10 0a 05 18 80 88 ff ff 10 0a 05 18 80 88 ff ff  ................
  backtrace (crc a8a6fc29):
    kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    slab_post_alloc_hook mm/slub.c:4152 [inline]
    slab_alloc_node mm/slub.c:4197 [inline]
    __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
    kmalloc_noprof include/linux/slab.h:878 [inline]
    extent_changeset_alloc fs/btrfs/extent_io.h:207 [inline]
    qgroup_reserve_data+0x1c5/0x7d0 fs/btrfs/qgroup.c:4305
    btrfs_qgroup_reserve_data+0x2e/0xb0 fs/btrfs/qgroup.c:4355
    btrfs_do_encoded_write+0x92e/0x1040 fs/btrfs/inode.c:9746
    btrfs_encoded_write fs/btrfs/file.c:1482 [inline]
    btrfs_do_write_iter+0x280/0x610 fs/btrfs/file.c:1507
    btrfs_ioctl_encoded_write+0x3d6/0x490 fs/btrfs/ioctl.c:4738
    btrfs_ioctl+0x6f9/0xc90 fs/btrfs/ioctl.c:-1
    vfs_ioctl fs/ioctl.c:51 [inline]
    __do_sys_ioctl fs/ioctl.c:906 [inline]
    __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:892
    do_syscall_x64 arch/x86/entry/common.c:47 [inline]
    do_syscall_64+0xbe/0x1a0 arch/x86/entry/common.c:78
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Unreferenced object 0xffff888018050a00 (size 64):
  comm "syz.0.17", pid 10297, jiffies 4294953601
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 ff 0f 00 00 00 00 00 00  ................
    90 0a 05 18 80 88 ff ff 90 0a 05 18 80 88 ff ff  ................
  backtrace (crc cb5c9580):
    kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    slab_post_alloc_hook mm/slub.c:4152 [inline]
    slab_alloc_node mm/slub.c:4197 [inline]
    __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
    kmalloc_noprof include/linux/slab.h:878 [inline]
    kzalloc_noprof include/linux/slab.h:1014 [inline]
    ulist_prealloc+0x9c/0x110 fs/btrfs/ulist.c:114
    extent_changeset_prealloc fs/btrfs/extent_io.h:217 [inline]
    __set_extent_bit+0x16b/0x1a70 fs/btrfs/extent-io-tree.c:1086
    set_record_extent_bits+0x50/0x90 fs/btrfs/extent-io-tree.c:1821
    qgroup_reserve_data+0x274/0x7d0 fs/btrfs/qgroup.c:4312
    btrfs_qgroup_reserve_data+0x2e/0xb0 fs/btrfs/qgroup.c:4355
    btrfs_do_encoded_write+0x92e/0x1040 fs/btrfs/inode.c:9746
    btrfs_encoded_write fs/btrfs/file.c:1482 [inline]
    btrfs_do_write_iter+0x280/0x610 fs/btrfs/file.c:1507
    btrfs_ioctl_encoded_write+0x3d6/0x490 fs/btrfs/ioctl.c:4738
    btrfs_ioctl+0x6f9/0xc90 fs/btrfs/ioctl.c:-1
    vfs_ioctl fs/ioctl.c:51 [inline]
    __do_sys_ioctl fs/ioctl.c:906 [inline]
    __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:892
    do_syscall_x64 arch/x86/entry/common.c:47 [inline]
    do_syscall_64+0xbe/0x1a0 arch/x86/entry/common.c:78
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix this by freeing an extent changeset before returning from
btrfs_do_encoded_write().

Fixes: 7c0c7269f7b5 ("btrfs: add BTRFS_IOC_ENCODED_WRITE")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f60f8bf38dc50..ab7f19ca21457 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9684,6 +9684,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	}
 	kvfree(folios);
 out:
+	extent_changeset_free(data_reserved);
 	if (ret >= 0)
 		iocb->ki_pos += encoded->len;
 	return ret;
-- 
2.53.0



