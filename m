Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89961386DF;
	Thu, 13 Jun 2024 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279292; cv=none; b=YEpBRkKllU1vdwBiNBm7r8xQ+7w1XFonyMPtVrkMSxV30K5stvKD7AiJvbaygZ/GZ73ozkwxuQfVs7B5SxR+TFNqznG6F3ID9QxQHLp7AcBbLS6PbiWAUCQ9/WtLi9EfsXw6FnuEoBfDudqJHFda9g3FFygFwTOhNt5jRZZDVxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279292; c=relaxed/simple;
	bh=2hbxo/p5S9I0zRNp68W2hfqO3S8pBUsvzCdlkY8KQ3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhF2oyAJEYUGoZ6S5/Fm8qlXTNAAzXw8Wdw9kEHAHuZqT/CuSUdulWMwNjpgxaJcXe++x+Qu6EdMUr10K/aFmTIJbo66a1wE78N6yCz1wX81+3ks8aNYCytoKxFXoQo0228Wo28+X54zzJ7ZCx6qIRJNZboNr6kJwM+l44TMKSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vyr6msPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vyr6msPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF92C2BBFC;
	Thu, 13 Jun 2024 11:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279292;
	bh=2hbxo/p5S9I0zRNp68W2hfqO3S8pBUsvzCdlkY8KQ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vyr6msPqaAIgd/iBSiMKcasN17K85VUUEci6tsba3KlPUQJdxkuRpTDT2TRkfB4KF
	 If8ANeIstasD1/U2Rw8SkSwCx4K7IcJLBp7HnofybkIHfW8DmO2aWyGpAsO8dQAL7V
	 WGCCtIt24t4FQtCMtWFmVOG8jipHMS2JAVnNXWd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	syzbot+3694e283cf5c40df6d14@syzkaller.appspotmail.com
Subject: [PATCH 6.9 007/157] f2fs: fix to do sanity check on i_xattr_nid in sanity_check_inode()
Date: Thu, 13 Jun 2024 13:32:12 +0200
Message-ID: <20240613113227.686200683@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 20faaf30e55522bba2b56d9c46689233205d7717 upstream.

syzbot reports a kernel bug as below:

F2FS-fs (loop0): Mounted with checkpoint version = 48b305e4
==================================================================
BUG: KASAN: slab-out-of-bounds in f2fs_test_bit fs/f2fs/f2fs.h:2933 [inline]
BUG: KASAN: slab-out-of-bounds in current_nat_addr fs/f2fs/node.h:213 [inline]
BUG: KASAN: slab-out-of-bounds in f2fs_get_node_info+0xece/0x1200 fs/f2fs/node.c:600
Read of size 1 at addr ffff88807a58c76c by task syz-executor280/5076

CPU: 1 PID: 5076 Comm: syz-executor280 Not tainted 6.9.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 f2fs_test_bit fs/f2fs/f2fs.h:2933 [inline]
 current_nat_addr fs/f2fs/node.h:213 [inline]
 f2fs_get_node_info+0xece/0x1200 fs/f2fs/node.c:600
 f2fs_xattr_fiemap fs/f2fs/data.c:1848 [inline]
 f2fs_fiemap+0x55d/0x1ee0 fs/f2fs/data.c:1925
 ioctl_fiemap fs/ioctl.c:220 [inline]
 do_vfs_ioctl+0x1c07/0x2e50 fs/ioctl.c:838
 __do_sys_ioctl fs/ioctl.c:902 [inline]
 __se_sys_ioctl+0x81/0x170 fs/ioctl.c:890
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The root cause is we missed to do sanity check on i_xattr_nid during
f2fs_iget(), so that in fiemap() path, current_nat_addr() will access
nat_bitmap w/ offset from invalid i_xattr_nid, result in triggering
kasan bug report, fix it.

Reported-and-tested-by: syzbot+3694e283cf5c40df6d14@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/00000000000094036c0616e72a1d@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -361,6 +361,12 @@ static bool sanity_check_inode(struct in
 		return false;
 	}
 
+	if (fi->i_xattr_nid && f2fs_check_nid_range(sbi, fi->i_xattr_nid)) {
+		f2fs_warn(sbi, "%s: inode (ino=%lx) has corrupted i_xattr_nid: %u, run fsck to fix.",
+			  __func__, inode->i_ino, fi->i_xattr_nid);
+		return false;
+	}
+
 	return true;
 }
 


