Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755103D5C07;
	Mon, 17 Aug 2026 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980212; cv=none; b=EV7472LMt/g+hk8kTLgW7fUwqFiie7f/+ybugyt1ZXUZjQlVDnVwbmZF5PeXB90e997INRKRriRNq2KOdIIIWgyuz59PjHdQSBtik5YZ9gt4fIc6QrDjrlDMT0vs44scMmKdK5jC5UApXV3m7DA61Jos+aTFBain5kQNxGqrhro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980212; c=relaxed/simple;
	bh=RvKy39pXXgYK6nUlCLB1Oq7y4Pkykt2aGSVHWgctunc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdVVI3XsMYgIV5LnJNdWpSBDDhUZPQa6xJFwogaFhNWmMK5ZUXqW+6nS8N5sZcChIH8VmfRESM1XXw/e5JnGnbMxZs0DE1TH5SiAboL1i3LavYvPXt1NiBHdP8VnW29Vp1DfMY1ctSj8E4SFeMWf/EdHV2+/KYTVptUOrGovwok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=go53T+TK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="go53T+TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7491F000E9;
	Mon, 17 Aug 2026 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980211;
	bh=KjV8ub+Gg91YUclY47eDAcveeP1aiFOtEQxma2XFI8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=go53T+TKMM05AWfXXhSyBx7plxAHFVUtjPjUnXXwJAVCLdM0MitmwbRNPgquHqmhm
	 jaPc4FPA2CzWGsqo58T3QJFoEkJ16579bjUt5VLw6p7SmsfHoLNDyv/DhSCMr3NFae
	 r1izgc9Dt6OCKWWEQVrKZBs8Ml+FPSSoVVh4ogJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 495/609] btrfs: fix memory leak in btrfs_do_encoded_write()
Date: Mon, 17 Aug 2026 15:33:11 +0200
Message-ID: <20260817132600.465645342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 77b436bf1db76..b2a1d96a806a9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -11181,6 +11181,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	}
 	kvfree(pages);
 out:
+	extent_changeset_free(data_reserved);
 	if (ret >= 0)
 		iocb->ki_pos += encoded->len;
 	return ret;
-- 
2.53.0



