Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E74D35B135;
	Fri,  9 Jan 2026 12:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962969; cv=none; b=hTVFwH2WQ+3o+SLmD4FEZnITuS0+mLdL8OSYqROKFXlHwADEiOJtTChDk6RqruGST159GQLs84yNmfrbLR2yr4MkrBYV595MbXgtqo19W5gCPxNsMsE1NJxkKX8TAdvOVciXm2aZrPxlOaWEMBc78Mr0eYU0An/DJ9pIBKPZ1Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962969; c=relaxed/simple;
	bh=Vq9kN7IfR0bIwTuM+HfIL6IJHUHSo/fqGLqJx8lv8BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLy137EcHsOarJz26dYbhIrMBAdJdWGwGrjEcxznQnTJd7e6DogoUNCCH64yJP0wSgerHOMMw5WJVxHRKOHxhpoPXevtAcIyuzbOtbq/a6o0dBUFA0l3aLRQoeMQ4nMQEfs6KhF+zfS5YgckJMaqr5F2TwYKlqPvNmSjBg4UDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfGIxaeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfGIxaeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF0EC4CEF1;
	Fri,  9 Jan 2026 12:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962969;
	bh=Vq9kN7IfR0bIwTuM+HfIL6IJHUHSo/fqGLqJx8lv8BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfGIxaeAyoVQcY+yRp51IOh6PjGYVqXH2q5/rbZ/VMUxksI+0lM0Kec41NG4jwdr/
	 pYerUL94+V38wCOKkaOz7N2Dda/ktJGDID+tNwMSUrCYzidGRXwCU2+oZGQepTGwET
	 ujAw8FnHDT9mGumzc6QnKpGLObx7xmeGajq4Z5AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+24124df3170c3638b35f@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 551/634] f2fs: fix to avoid updating zero-sized extent in extent cache
Date: Fri,  9 Jan 2026 12:43:49 +0100
Message-ID: <20260109112138.326139761@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7c37c79510329cd951a4dedf3f7bf7e2b18dccec ]

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
[ adapted patch to only guard f2fs_update_read_extent_cache_range() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1552,7 +1552,9 @@ static int f2fs_do_zero_range(struct dno
 		f2fs_set_data_blkaddr(dn, NEW_ADDR);
 	}
 
-	f2fs_update_read_extent_cache_range(dn, start, 0, index - start);
+	if (index > start)
+		f2fs_update_read_extent_cache_range(dn, start, 0,
+							index - start);
 
 	return ret;
 }


