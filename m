Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C19D12C49E;
	Tue, 30 Apr 2024 10:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474453; cv=none; b=nhF3m7zkphkDoM3X+0dqrGQ1EPKlmOgz6ksiNIepWdICr5KmgugwW9dmfF3FoVcOltPpObINghqLZ2JwCjQuWF3/V8A2APSe4xZGQUqGbPR//zsHBGQrx0ge6CcV3B9Wyuo6byYgRXJyj+l345HlNqFoN9tsNbyBLPxHj+wHNRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474453; c=relaxed/simple;
	bh=ersPDGGhimLU/VHOWWVGRIHdbNg1bZmmHXozzQCCwqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDGFj8h7ERsvsKQ/Vn+gC79ijmDJIcEw+tb2fCmrd0QgxK/EYvvaGNvxdKCP9tKdPXm0e9XikrIbkHq+uzbsYMMsxv4w+dhuK00gtkxV/0wantA+F/fy6bEG4ocH+ObVvaYvh+JKAtXSDWkRM7nzjljIGcyzNmwJFi5Nc/E4ZQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOvIgddo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOvIgddo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B2EC2BBFC;
	Tue, 30 Apr 2024 10:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474453;
	bh=ersPDGGhimLU/VHOWWVGRIHdbNg1bZmmHXozzQCCwqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOvIgddoekzeK3keYC7aP5V6FdiVWG13ArJbn/J2hoE/vFnVku1BUiUGg62lOWQej
	 huBe7Y2Za9CPPqBK37KYg1X8Cj55xqwsRRKWVrahn+POpPvbgu4kTbzS/DEQ+ZEQHK
	 afZ841n5iNE6Hl2mMSc4AKfU8evOy6lYsKP4ivz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+510a1abbb8116eeb341d@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <Johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 161/228] btrfs: fix information leak in btrfs_ioctl_logical_to_ino()
Date: Tue, 30 Apr 2024 12:38:59 +0200
Message-ID: <20240430103108.453311333@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 2f7ef5bb4a2f3e481ef05fab946edb97c84f67cf upstream.

Syzbot reported the following information leak for in
btrfs_ioctl_logical_to_ino():

  BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:114 [inline]
  BUG: KMSAN: kernel-infoleak in _copy_to_user+0xbc/0x110 lib/usercopy.c:40
   instrument_copy_to_user include/linux/instrumented.h:114 [inline]
   _copy_to_user+0xbc/0x110 lib/usercopy.c:40
   copy_to_user include/linux/uaccess.h:191 [inline]
   btrfs_ioctl_logical_to_ino+0x440/0x750 fs/btrfs/ioctl.c:3499
   btrfs_ioctl+0x714/0x1260
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:904 [inline]
   __se_sys_ioctl+0x261/0x450 fs/ioctl.c:890
   __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:890
   x64_sys_call+0x1883/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:17
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Uninit was created at:
   __kmalloc_large_node+0x231/0x370 mm/slub.c:3921
   __do_kmalloc_node mm/slub.c:3954 [inline]
   __kmalloc_node+0xb07/0x1060 mm/slub.c:3973
   kmalloc_node include/linux/slab.h:648 [inline]
   kvmalloc_node+0xc0/0x2d0 mm/util.c:634
   kvmalloc include/linux/slab.h:766 [inline]
   init_data_container+0x49/0x1e0 fs/btrfs/backref.c:2779
   btrfs_ioctl_logical_to_ino+0x17c/0x750 fs/btrfs/ioctl.c:3480
   btrfs_ioctl+0x714/0x1260
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:904 [inline]
   __se_sys_ioctl+0x261/0x450 fs/ioctl.c:890
   __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:890
   x64_sys_call+0x1883/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:17
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Bytes 40-65535 of 65536 are uninitialized
  Memory access of size 65536 starts at ffff888045a40000

This happens, because we're copying a 'struct btrfs_data_container' back
to user-space. This btrfs_data_container is allocated in
'init_data_container()' via kvmalloc(), which does not zero-fill the
memory.

Fix this by using kvzalloc() which zeroes out the memory on allocation.

CC: stable@vger.kernel.org # 4.14+
Reported-by:  <syzbot+510a1abbb8116eeb341d@syzkaller.appspotmail.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <Johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/backref.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2773,20 +2773,14 @@ struct btrfs_data_container *init_data_c
 	size_t alloc_bytes;
 
 	alloc_bytes = max_t(size_t, total_bytes, sizeof(*data));
-	data = kvmalloc(alloc_bytes, GFP_KERNEL);
+	data = kvzalloc(alloc_bytes, GFP_KERNEL);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-	if (total_bytes >= sizeof(*data)) {
+	if (total_bytes >= sizeof(*data))
 		data->bytes_left = total_bytes - sizeof(*data);
-		data->bytes_missing = 0;
-	} else {
+	else
 		data->bytes_missing = sizeof(*data) - total_bytes;
-		data->bytes_left = 0;
-	}
-
-	data->elem_cnt = 0;
-	data->elem_missed = 0;
 
 	return data;
 }


