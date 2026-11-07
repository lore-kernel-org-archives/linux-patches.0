Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063533;
	b=KQR1p6LXWxI7keOX74tMask3QeUoG+nqEbmZ3jJdyDvAVBgOyLVxvM+K6tJmRfzsqwB6
	 TlpGJNTRldijQqbiHX8gODhv9WzD0G4Qs0oXJhsvBP6kt6hwGJRK+LD6hzpnjTZCHtY8g
	 snWD5AfHn0DecGyuzijBnim48Cck7A3/UPelXw3Hd/bxzeXv4W9JHW8STy1DyUSf8/MkI
	 qYgtvJ/Mnvl4LXfyp35Ilpg1EtVEOcppgZORokUEqnBfGukqP9fgsL3SYHnPkAibh8dYq
	 oZl2JoyR80OPSYoswIN9iMqMk+j/QJisJegAbnTKIL2RMIPST/LZRFGwradTHzogGaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tnnlo5bC/z/mlCLBDJo4wcDpl5fcJ7eXvVU8IMNYnB8=;
	b=vRJebhP93otP0aIpzCWu6GeA9vbzm/9FQSiEIUs+xlSeyvw0vpVwZCxnXQegzhg/VHxY
	 cJfBmNjA8lu86LMNycox0vZBP0YCML7JYYbAmiymfiqVVUogIZvsZ0BRpxV87/tFBxeAf
	 MyIKlj/8oHiowjB2xPXCAXhuhj8wgEF/AzrU/qKC2awFFjO8atTSNCBky4BCRYL+61yMN
	 BiuD1gFgH3ciV83QL6yEbQAsgdJyxRGgHlnIYJI2nZfgnqO4ukkyOvjQThff3RAtKXE/P
	 sHOmNbkERJlXDhfyXIQ3eA6pEHdvHTw0dHMLLbvZSbWHN4xSXbsQt9DgXdKSSMsJV4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZhTvQpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19771606EE8C;
	Sat,  7 Nov 2026 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZhTvQpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0E11F008A2;
	Sat,  7 Nov 2026 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063532;
	bh=tnnlo5bC/z/mlCLBDJo4wcDpl5fcJ7eXvVU8IMNYnB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZhTvQpTjfcURzJjEIqBypEI6wneEDBuIXLMA7LLk0k67waFBaFwVwasuXnDmNZTV
	 7TQsw00QwvAd6GqTgKaTwNJVxWAk/KCLgdbkPna3zSkBFPSGjr2Wqw6wpm+VKTNNBz
	 pubyyqDdWkeoDfSGStuuYi+Ccvpm+IGvYwC/olwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 669/869] blk-mq: clear stale inactive flag on hctx reuse
Date: Sat,  7 Nov 2026 08:55:51 -0500
Message-ID: <20261107134915.804810896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

[ Upstream commit afc1de47a7ab607ae6403c4bfda36b0bf3cd342f ]

When the last CPU mapped to an hctx goes offline,
blk_mq_hctx_notify_offline() sets BLK_MQ_S_INACTIVE. Updating the
number of hardware queues exits every hctx and parks it on
q->unused_hctx_list. A later update can reuse a parked hctx through
blk_mq_alloc_and_init_hctx(), at any queue index, and nothing clears
the flag.

If the reused hctx is mapped to an online CPU, blk_mq_get_tag() keeps
returning BLK_MQ_NO_TAG for it. __blk_mq_alloc_requests() sleeps and
retries, expecting CPU hotplug to move the task to another CPU, so a
task that stays on that CPU never gets a tag. Onlining the original CPU
doesn't recover it either, because blk_mq_hctx_notify_online() only
clears the flag on the hctx that CPU now maps to.

Clear BLK_MQ_S_INACTIVE in blk_mq_init_hctx() so a reused hctx starts
like a freshly allocated one. A reused hctx has no cpuhp instances at
that point, so the offline callback can't set the flag again before
blk_mq_add_hw_queues_cpuhp() registers it. Clearing the flag in
blk_mq_exit_hctx() is not enough, because a parked hctx keeps its cpuhp
instances until blk_mq_remove_hw_queues_cpuhp(). Preserve the other
hctx state flags.

Reproduced with null_blk on v7.3 in a four-vCPU arm64 QEMU/KVM guest:

  modprobe null_blk nr_devices=0
  mkdir /sys/kernel/config/nullb/nullb0
  cd /sys/kernel/config/nullb/nullb0
  echo 4 > submit_queues; echo 1 > memory_backed; echo 16 > size
  echo 1 > power
  echo 0 > /sys/devices/system/cpu/cpu3/online
  echo 2 > submit_queues
  echo 4 > submit_queues

Offlining CPU3 marks hctx3 inactive. After the two updates it comes back
as hctx1 and is mapped to CPU0:

  # cat /sys/block/nullb0/mq/1/cpu_list
  0
  # cat /sys/kernel/debug/block/nullb0/hctx1/state
  INACTIVE

A 4K O_DIRECT read pinned to CPU0 hangs in D state, while the same read
on CPU1 and CPU2 completes. Onlining CPU3 again leaves hctx1 inactive
and the CPU0 read still hangs. With this change hctx1 state is empty and
the reads on CPU0, CPU1 and CPU2 complete, before and after onlining
CPU3.

Fixes: bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are offline")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Link: https://patch.msgid.link/20261020125129.430600-1-nirmoyd@nvidia.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 73ee5a9ea51d6..cced68a0e3c53 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4016,6 +4016,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 		goto fail;
 
 	hctx->queue_num = hctx_idx;
+	clear_bit(BLK_MQ_S_INACTIVE, &hctx->state);
 
 	hctx->tags = set->tags[hctx_idx];
 
-- 
2.53.0



