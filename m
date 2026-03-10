Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2461537B413;
	Tue, 10 Mar 2026 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142006; cv=none; b=aXTA+jzles86SQZeeEfZXoUyZjI3rJw6zbY0yk707csRN024HorHJWynwLhVuqcc2sRI10vtzVRw1nptaBJK8LHdE1aVzgBQmUV42gdTju/nh8wpy2FClzcUo+Istzjb+NoMbiI5Au6xRvYSRKv5QQkYXiOTxk5FebpdosGJc3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142006; c=relaxed/simple;
	bh=NS+VPQCbtYZiCM08dSoLbRbFxwh98OUv8FEU+cCGN3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glueDw3EpNj+yAkY7jb/emvsrny4KDL/ZgzHGvQ//qxZUG5uu2cwGdxLWXO6b2SVshqseJgC+LOQ+U3mYSKBaMPWBnzUOgX79kKw1jdKNZN3Z4bYvmUVlasTTQ6/KcVZPTQ7p3jLXFcikzYxXf6RY/ht5Vmfr8ckpWrAW4YMND8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luLDEm10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luLDEm10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598B2C2BC86;
	Tue, 10 Mar 2026 11:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142006;
	bh=NS+VPQCbtYZiCM08dSoLbRbFxwh98OUv8FEU+cCGN3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luLDEm10htjh4I1wPrzi9M8W8WintyaSuOL1AudnPKvNwtARzy4hSs2JJmeFZL889
	 9h0yYcPhNLfC4h7IWikUQLzmqBV67LoG4C9j8wyDfaXIz+BEBEPyi9nVMfFTHaAjK8
	 oaO3vpVe/iGcmlM2wIzv3nq36TTlyB9zy3GtnKiyjD482CeI6qTk3SJa0kmwsSyVrk
	 zVarZ8cVV0jk1En+j5BHW0zIW1WBLJ6ojsCtJ3pbvcZEcB3jzcMKTzXUf3wXeKPXSO
	 KGCSeiIt8SNDsE6VHxl+DIUj/nGZU/ivDuza/O9CkAQGlCL3skk9oHP2acObFqWbnT
	 2MWm75r1q1mlw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 132/314] media: dvb-core: fix wrong reinitialization of ringbuffer on reopen
Date: Tue, 10 Mar 2026 07:16:31 -0400
Message-ID: <249ef6fa6129de9be07ce47cffeaead949394568.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 drivers/media/dvb-core/dmxdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 8a9cca6da3e0e..ab34be22cd1aa 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -168,7 +168,9 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
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
-- 
2.51.0

