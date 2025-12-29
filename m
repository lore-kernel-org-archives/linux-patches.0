Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3958F3321B4;
	Mon, 29 Dec 2025 16:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025820; cv=none; b=ggpQL+0ju5imupUuAaxnl2i9BsFj+u8yiAplbHK6moTn50KxLDoyk6EAiyPLMtYbInUFzh8pVOMD3aXlnppqdVv2D3+5M5uiQwTsImfxQO+J5o4txjrCqX5shmDZkI4Yslb7FRhs85XYA7ImwfFqvnYp77i9dPR32MYdBdWPYbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025820; c=relaxed/simple;
	bh=UJQoB92tRqiWQdbmr4Jw6W4FRa0PPOz4Bvt4bVdLwYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChsyjrZibBSzImG58MyPW7EFDfuobke3XsYwz7xSs2npXMUoiMh3tR7iIUf9STvgYdYseWPGqOLGy2feBmEyYKeB9zMjC2qvszEGvMDGjPLu8FOALDrlV5UPEOHQsAfA0ryUnvR1um1MK6DVuPS3DIIvxF5HMRAOTxZrFr/4Jlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlOx6j/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlOx6j/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AB7C4CEF7;
	Mon, 29 Dec 2025 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025820;
	bh=UJQoB92tRqiWQdbmr4Jw6W4FRa0PPOz4Bvt4bVdLwYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlOx6j/uDVCddiOPnNdthiqFPER5Eed+6ImC4+gJlnbcPfJiEXSX7TYdg2Z32eDE4
	 bVnvTZ5odnokqpgg9lVZtKM6zS+QNu24+J+MFL8NoKNaAyPcpAp/67tl6wS3CKdLfo
	 FrlD9m+U1+DxxlbgzhZfan0/2VTXThQ7R+CMD2BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+24124df3170c3638b35f@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 316/430] f2fs: fix to avoid updating zero-sized extent in extent cache
Date: Mon, 29 Dec 2025 17:11:58 +0100
Message-ID: <20251229160735.957200290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 7c37c79510329cd951a4dedf3f7bf7e2b18dccec upstream.

As syzbot reported:

F2FS-fs (loop0): __update_extent_tree_range: extent len is zero, type: 0, extent [0, 0, 0], age [0, 0]
------------[ cut here ]------------
kernel BUG at fs/f2fs/extent_cache.c:678!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5336 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__update_extent_tree_range+0x13bc/0x1500 fs/f2fs/extent_cache.c:678
Call Trace:
 <TASK>
 f2fs_update_read_extent_cache_range+0x192/0x3e0 fs/f2fs/extent_cache.c:1085
 f2fs_do_zero_range fs/f2fs/file.c:1657 [inline]
 f2fs_zero_range+0x10c1/0x1580 fs/f2fs/file.c:1737
 f2fs_fallocate+0x583/0x990 fs/f2fs/file.c:2030
 vfs_fallocate+0x669/0x7e0 fs/open.c:342
 ioctl_preallocate fs/ioctl.c:289 [inline]
 file_ioctl+0x611/0x780 fs/ioctl.c:-1
 do_vfs_ioctl+0xb33/0x1430 fs/ioctl.c:576
 __do_sys_ioctl fs/ioctl.c:595 [inline]
 __se_sys_ioctl+0x82/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f07bc58eec9

In error path of f2fs_zero_range(), it may add a zero-sized extent
into extent cache, it should be avoided.

Fixes: 6e9619499f53 ("f2fs: support in batch fzero in dnode page")
Cc: stable@kernel.org
Reported-by: syzbot+24124df3170c3638b35f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/68e5d698.050a0220.256323.0032.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1654,8 +1654,11 @@ static int f2fs_do_zero_range(struct dno
 		f2fs_set_data_blkaddr(dn, NEW_ADDR);
 	}
 
-	f2fs_update_read_extent_cache_range(dn, start, 0, index - start);
-	f2fs_update_age_extent_cache_range(dn, start, index - start);
+	if (index > start) {
+		f2fs_update_read_extent_cache_range(dn, start, 0,
+							index - start);
+		f2fs_update_age_extent_cache_range(dn, start, index - start);
+	}
 
 	return ret;
 }


