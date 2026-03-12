Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CE01A0712;
	Thu, 12 Mar 2026 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346802; cv=none; b=MMmzEalihh/9gcWXd1XSCm1JOfm8il57W++IbVaTLr65PPKXJyfEGSYXF0HCo438Y0qMbsqS+hvSHJCf6mj/YPPz2qD9Vkr69ituVQFVIF3J4tGEj2ZZFtWV2jhZRYS5ff2MnNSIQr+kxX9w4eObIdqueCz6H2W9D3W7U2XI63o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346802; c=relaxed/simple;
	bh=3ctIc9IR2M+4kfZLlfwYmAI1V+jRr27nII5zw9ckleM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Blm17JlpQZOAoa+NJthoPEUz1cPd00LsF0WNMAS9qzrP6UUX6QeWY2Bll1OxJUvYsXez+T4HGlY5bsFWmoJy7ZskbkIR233B12G4ciSIx388KdqQ1i40VG/BV5B+QaCh0Wj8Qk+Dud6kvwqKGzKoRnGP36ri9rt8eVhn3kQWQmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvYsSdqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvYsSdqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D609C19425;
	Thu, 12 Mar 2026 20:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346802;
	bh=3ctIc9IR2M+4kfZLlfwYmAI1V+jRr27nII5zw9ckleM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvYsSdqCAer64FJcMRoZGeUB1pm5efTdN+O6E9DhXI7AxQ5bNeneEaxtgByjG9HkT
	 l8U53oFKw0ydByPpFP8uYHcsF+AmTOWrJF5PE44Du4nYI+2wAW70aIJK6uzperJSwS
	 LjQU4l+4Z/vIUfOqJ7GMLfJSG5i9iZhi97imYsGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 128/265] media: dvb-core: fix wrong reinitialization of ringbuffer on reopen
Date: Thu, 12 Mar 2026 21:08:35 +0100
Message-ID: <20260312201022.873578850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit bfbc0b5b32a8f28ce284add619bf226716a59bc0 upstream.

dvb_dvr_open() calls dvb_ringbuffer_init() when a new reader opens the
DVR device.  dvb_ringbuffer_init() calls init_waitqueue_head(), which
reinitializes the waitqueue list head to empty.

Since dmxdev->dvr_buffer.queue is a shared waitqueue (all opens of the
same DVR device share it), this orphans any existing waitqueue entries
from io_uring poll or epoll, leaving them with stale prev/next pointers
while the list head is reset to {self, self}.

The waitqueue and spinlock in dvr_buffer are already properly
initialized once in dvb_dmxdev_init().  The open path only needs to
reset the buffer data pointer, size, and read/write positions.

Replace the dvb_ringbuffer_init() call in dvb_dvr_open() with direct
assignment of data/size and a call to dvb_ringbuffer_reset(), which
properly resets pread, pwrite, and error with correct memory ordering
without touching the waitqueue or spinlock.

Cc: stable@vger.kernel.org
Fixes: 34731df288a5f ("V4L/DVB (3501): Dmxdev: use dvb_ringbuffer")
Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
Tested-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/698a26d3.050a0220.3b3015.007d.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dmxdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -168,7 +168,9 @@ static int dvb_dvr_open(struct inode *in
 			mutex_unlock(&dmxdev->mutex);
 			return -ENOMEM;
 		}
-		dvb_ringbuffer_init(&dmxdev->dvr_buffer, mem, DVR_BUFFER_SIZE);
+		dmxdev->dvr_buffer.data = mem;
+		dmxdev->dvr_buffer.size = DVR_BUFFER_SIZE;
+		dvb_ringbuffer_reset(&dmxdev->dvr_buffer);
 		if (dmxdev->may_do_mmap)
 			dvb_vb2_init(&dmxdev->dvr_vb2_ctx, "dvr",
 				     file->f_flags & O_NONBLOCK);


