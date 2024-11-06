Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B061DF98C;
	Wed,  6 Nov 2024 12:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896474; cv=none; b=TbjE9Tr6hTT1bkmn0cldccR9LKypjdpv1r00f4TynWhhxNuT6NETPiFtSKOiMyqits63vYN5hfJlcXIqPi+2amQ4bomz5fKVibTSAmwu8O3EG2BQNx0AlzMW1Em8MOifNLD2eHfWrdwlFmaigkS1TLGlxD6gqKMITd3UbOVGa3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896474; c=relaxed/simple;
	bh=XPjUQJvSa+STs9KiLnpNtCypS+cI3LPcXcro0ipFUJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ujsh8ITszDaLhF+UafqapNTu6bj+dOIMIGpDWFWwK8zNcoF2jSk5oYkR7XrUARuSsAJj0q+0gZM9MPfg/NYMvHORt+SCa7Yn+HhzDmt95asMwfFy78dIBGKck2zgLDO+iexGv+fcLCedCZTzNbCL1OXFMv/E49Z/5q5BvmZrmxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsq7Int4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsq7Int4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3F5C4CECD;
	Wed,  6 Nov 2024 12:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896474;
	bh=XPjUQJvSa+STs9KiLnpNtCypS+cI3LPcXcro0ipFUJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsq7Int4JwFMINgNQ7Vkl6WD9OwWHzUel1hWoAxndVkfB6tOm5yqfVkSed/9UQ39J
	 /u7Z+XCvxkhR9X3YO9fFRsj4fcDbVSG4iZysXDwHWzzvwj2OWR7v/ySt0+2uHrcXC+
	 vuzmeGVMnKFTRxYu1IMDHsSzu0y6KRiLdhtEeCFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Mann <peter.mann@sh.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 197/245] io_uring/rw: fix missing NOWAIT check for O_DIRECT start write
Date: Wed,  6 Nov 2024 13:04:10 +0100
Message-ID: <20241106120324.092379684@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 1d60d74e852647255bd8e76f5a22dc42531e4389 ]

When io_uring starts a write, it'll call kiocb_start_write() to bump the
super block rwsem, preventing any freezes from happening while that
write is in-flight. The freeze side will grab that rwsem for writing,
excluding any new writers from happening and waiting for existing writes
to finish. But io_uring unconditionally uses kiocb_start_write(), which
will block if someone is currently attempting to freeze the mount point.
This causes a deadlock where freeze is waiting for previous writes to
complete, but the previous writes cannot complete, as the task that is
supposed to complete them is blocked waiting on starting a new write.
This results in the following stuck trace showing that dependency with
the write blocked starting a new write:

task:fio             state:D stack:0     pid:886   tgid:886   ppid:876
Call trace:
 __switch_to+0x1d8/0x348
 __schedule+0x8e8/0x2248
 schedule+0x110/0x3f0
 percpu_rwsem_wait+0x1e8/0x3f8
 __percpu_down_read+0xe8/0x500
 io_write+0xbb8/0xff8
 io_issue_sqe+0x10c/0x1020
 io_submit_sqes+0x614/0x2110
 __arm64_sys_io_uring_enter+0x524/0x1038
 invoke_syscall+0x74/0x268
 el0_svc_common.constprop.0+0x160/0x238
 do_el0_svc+0x44/0x60
 el0_svc+0x44/0xb0
 el0t_64_sync_handler+0x118/0x128
 el0t_64_sync+0x168/0x170
INFO: task fsfreeze:7364 blocked for more than 15 seconds.
      Not tainted 6.12.0-rc5-00063-g76aaf945701c #7963

with the attempting freezer stuck trying to grab the rwsem:

task:fsfreeze        state:D stack:0     pid:7364  tgid:7364  ppid:995
Call trace:
 __switch_to+0x1d8/0x348
 __schedule+0x8e8/0x2248
 schedule+0x110/0x3f0
 percpu_down_write+0x2b0/0x680
 freeze_super+0x248/0x8a8
 do_vfs_ioctl+0x149c/0x1b18
 __arm64_sys_ioctl+0xd0/0x1a0
 invoke_syscall+0x74/0x268
 el0_svc_common.constprop.0+0x160/0x238
 do_el0_svc+0x44/0x60
 el0_svc+0x44/0xb0
 el0t_64_sync_handler+0x118/0x128
 el0t_64_sync+0x168/0x170

Fix this by having the io_uring side honor IOCB_NOWAIT, and only attempt a
blocking grab of the super block rwsem if it isn't set. For normal issue
where IOCB_NOWAIT would always be set, this returns -EAGAIN which will
have io_uring core issue a blocking attempt of the write. That will in
turn also get completions run, ensuring forward progress.

Since freezing requires CAP_SYS_ADMIN in the first place, this isn't
something that can be triggered by a regular user.

Cc: stable@vger.kernel.org # 5.10+
Reported-by: Peter Mann <peter.mann@sh.cz>
Link: https://lore.kernel.org/io-uring/38c94aec-81c9-4f62-b44e-1d87f5597644@sh.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 6b3bc0876f7fe..19e2c1f9c4a21 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1016,6 +1016,25 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)
+{
+	struct inode *inode;
+	bool ret;
+
+	if (!(req->flags & REQ_F_ISREG))
+		return true;
+	if (!(kiocb->ki_flags & IOCB_NOWAIT)) {
+		kiocb_start_write(kiocb);
+		return true;
+	}
+
+	inode = file_inode(kiocb->ki_filp);
+	ret = sb_start_write_trylock(inode->i_sb);
+	if (ret)
+		__sb_writers_release(inode->i_sb, SB_FREEZE_WRITE);
+	return ret;
+}
+
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -1053,8 +1072,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	if (req->flags & REQ_F_ISREG)
-		kiocb_start_write(kiocb);
+	if (unlikely(!io_kiocb_start_write(req, kiocb)))
+		return -EAGAIN;
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (likely(req->file->f_op->write_iter))
-- 
2.43.0



