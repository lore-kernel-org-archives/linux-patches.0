Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A37A21CFEA;
	Thu, 12 Dec 2024 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023489; cv=none; b=b+AG9hszYLCC3hIhgJ8ulTAE2raU+DF7pZO0cn6FzgWTe9qxl8x1XGZUvsDpwe1fjvqiT697Pe7G+/bDs2Z35TMeFr0gEjPC7YDNXC8y3UPi+i013EPckt4vdkICdJpjARMH3XYhLwkAtdrYENQDxnU8anyb+g+bGwyeQr9ni28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023489; c=relaxed/simple;
	bh=efDLj2jR4bkY7cuXR/p+wAhif3fVb4EST81ZlUOwvMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLfDIiILtGepXWZWAa3pKfIINk70ZcegRozDn2w+pa+gakJTCKwY1ll0wCVbyUY6YiFasE/01wwr3+Dv6+ePCB8rrwwglEZ9P9r89MhuwO8QwPWx58RtInFN0UKqEf4SjwvNyr81/hgo2/y4b9ru0lAojr1R0DkEpKqAb1qN03M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCnhU57D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCnhU57D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93D4C4CED0;
	Thu, 12 Dec 2024 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023489;
	bh=efDLj2jR4bkY7cuXR/p+wAhif3fVb4EST81ZlUOwvMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCnhU57DyJxgemWp+vQSOQKzg1IH4riHSs/Bq5OvsYKd58gqSiFDXJwMJ2bMBxXK7
	 imoaQpplR36yENDdOOf4pFTTeO0gCPHjW8jZGfCGxnYkiQAmPMD6fsVHEnWHFpjKsq
	 r6Ow1s+7kpu5teX9Tz/dxEOBs+CHOtITxeDcj0jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Han <hanqi@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 520/565] f2fs: fix f2fs_bug_on when uninstalling filesystem call f2fs_evict_inode.
Date: Thu, 12 Dec 2024 16:01:55 +0100
Message-ID: <20241212144332.348612009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Han <hanqi@vivo.com>

[ Upstream commit d5c367ef8287fb4d235c46a2f8c8d68715f3a0ca ]

creating a large files during checkpoint disable until it runs out of
space and then delete it, then remount to enable checkpoint again, and
then unmount the filesystem triggers the f2fs_bug_on as below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/inode.c:896!
CPU: 2 UID: 0 PID: 1286 Comm: umount Not tainted 6.11.0-rc7-dirty #360
Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:f2fs_evict_inode+0x58c/0x610
Call Trace:
 __die_body+0x15/0x60
 die+0x33/0x50
 do_trap+0x10a/0x120
 f2fs_evict_inode+0x58c/0x610
 do_error_trap+0x60/0x80
 f2fs_evict_inode+0x58c/0x610
 exc_invalid_op+0x53/0x60
 f2fs_evict_inode+0x58c/0x610
 asm_exc_invalid_op+0x16/0x20
 f2fs_evict_inode+0x58c/0x610
 evict+0x101/0x260
 dispose_list+0x30/0x50
 evict_inodes+0x140/0x190
 generic_shutdown_super+0x2f/0x150
 kill_block_super+0x11/0x40
 kill_f2fs_super+0x7d/0x140
 deactivate_locked_super+0x2a/0x70
 cleanup_mnt+0xb3/0x140
 task_work_run+0x61/0x90

The root cause is: creating large files during disable checkpoint
period results in not enough free segments, so when writing back root
inode will failed in f2fs_enable_checkpoint. When umount the file
system after enabling checkpoint, the root inode is dirty in
f2fs_evict_inode function, which triggers BUG_ON. The steps to
reproduce are as follows:

dd if=/dev/zero of=f2fs.img bs=1M count=55
mount f2fs.img f2fs_dir -o checkpoint=disable:10%
dd if=/dev/zero of=big bs=1M count=50
sync
rm big
mount -o remount,checkpoint=enable f2fs_dir
umount f2fs_dir

Let's redirty inode when there is not free segments during checkpoint
is disable.

Signed-off-by: Qi Han <hanqi@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 27bd8d1bae4d3..558f478d037d0 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -724,8 +724,10 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		!is_inode_flag_set(inode, FI_DIRTY_INODE))
 		return 0;
 
-	if (!f2fs_is_checkpoint_ready(sbi))
+	if (!f2fs_is_checkpoint_ready(sbi)) {
+		f2fs_mark_inode_dirty_sync(inode, true);
 		return -ENOSPC;
+	}
 
 	/*
 	 * We need to balance fs here to prevent from producing dirty node pages
-- 
2.43.0



