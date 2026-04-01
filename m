Received: from mail115-79.sinamail.sina.com.cn (mail115-79.sinamail.sina.com.cn [218.30.115.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0988A1E230E
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 06:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775023991; cv=none; b=rrbRPNGiEPM/sqkypT6SwYwLDad8MQAnA31nVkCu+s5Zzms42uaWTrBTbKdocqySwytU7ciop2bvItvsR8uPLth7hvFkQCAwtFNSYPXtior2b75VxuzeSzHN1LV9S6U40Fzuj+gmrJwiTE84KcGrM5qbdGYFG17cgsBxcJ7/nfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775023991; c=relaxed/simple;
	bh=/HyS1RYTyVOcHNSoQszutPIt+ayra7uA20TwMUMDYCU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lcr5k/5FO0SpbA0o/fiam8icg8bZlek38ZNACKM4WEc04mu1AOiJ5giKhM3pwR73C0oAekuqRrDDPBJJX0VCyW7ysd0kiTe3X54tFhoY0tWL3Cuv695n5z2Ih4BpKh6/+iAEB5ca9B7BFLbVwJGuVPtdrSJqkxx6lupuO9YwhH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=rDMq9JAa; arc=none smtp.client-ip=218.30.115.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="rDMq9JAa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1775023988;
	bh=+aEDzyDbOTl4WToRqKBS93o7mOqX6kQhrjREC999MfU=;
	h=From:Subject:Date:Message-Id;
	b=rDMq9JAaOpZY5W3cPxgbPMqFJLMsuYYr749U6oMVHQjRmmmWS/QYI99wBJgFKbIHB
	 /bS1aBQiPROcoCdvB//95y8mu0nLus/G1WkuXGz5/VlWn7sfV9HvqihKiU6iazolL2
	 L4ZPuMck0zwiOsdG8gbHGzfIvXQs2OdHRX0mqtB8=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.22) with ESMTP
	id 69CCB763000067E9; Wed, 1 Apr 2026 14:12:59 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 6042587602323
X-SMAIL-UIID: EB597CE8F08B4BDB8B64E81E1B7E65C9-20260401-141259-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	axboe@kernel.dk
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mchehab@kernel.org,
	hverkuil@xs4all.nl,
	sashal@kernel.org,
	obi@linuxtv.org,
	linux-media@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: [PATCH 5.15.y] media: dvb-core: fix wrong reinitialization of ringbuffer on reopen
Date: Wed,  1 Apr 2026 14:12:51 +0800
Message-Id: <20260401061251.4165263-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit bfbc0b5b32a8f28ce284add619bf226716a59bc0 ]

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
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 drivers/media/dvb-core/dmxdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 4989ffe2477e..a5dd2470ecbe 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -178,7 +178,9 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
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
2.34.1

