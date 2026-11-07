Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065129;
	b=FgOpSFw+lfliEy3OEHX7bC3BxO0CNAwNb0bm1xCbrEnxdLKdYh9kiCeOCU48+tIQTfqk
	 p4RdXreZgBxzmJs11nHMRgK2A2X+tAIxPfUqLxXFl1SYQt/txxHdsretpYdN1rf1HZisT
	 o9k7jfAKjHw/7caq50IMMc9CJRsFHO6MO7o/O/oUUn9hOHZ5uEIlCP/YyVk8RdXlQCvbp
	 YhoSRgacJJukhgD7DLaQAeTdKJZDgyIr5AoqJ2YHTIM3PKu5WdCTLUdDEvAtfQQ0ahGon
	 En7El3j32nVsAySVZUElZ6Uj3wyXJ4Bvpscs6/gSkEv+Roe5fetZhAomuDv1FQD+Mrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OasLNe7+9tYZkhlY8ChDG7Uh2DezXYJNAct0EJAa2VY=;
	b=lj+dJbGOiq60O7r6extzMLGuFVMnSglR7CYbG4ekqhHgfmuEXWnnlfn4sHxnpAlOEjse
	 1ewOym6UHHGfQFNVgA/n+Q4aRVxz2umaLQubSchRf8NE4v1zlBRpNCPIWjL40jADXm1+A
	 h48FjaDII7qHL6AK/WYO1sFFaYmgjN3aqcwVyO9FoUc9Y/9VVJttNdeOgyD4wv1z4e4Pe
	 S5vtq9Ww3JxV9oddSWwETMsf4qb4IH9/SkwNriC2vI7SM78Ljs6H5bWD3aqWpeEffWtnl
	 hurPwPS0CKzsQClX8VJSfTcikYww90WLUSH8EgJQqwz640HChjAe9K2QOjE7UoCO7ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHhRT19p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B644606A32E;
	Sat,  7 Nov 2026 15:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHhRT19p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F581F0089F;
	Sat,  7 Nov 2026 15:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065128;
	bh=OasLNe7+9tYZkhlY8ChDG7Uh2DezXYJNAct0EJAa2VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHhRT19pJhZv5BH3bsMfDTiDev4QJZFasmeW7I7dAFPgLs8i1bhGw+RRHsJ9+hKDQ
	 jw/e62EeG1+NJvHUF8n8j3hDbxNs24nLiNXFaKM49Aj/jR6wfa143t5ZY9Evn8Pg/r
	 S3eZGO8mgrtGR0NB4YfpX7SruMB3gqci9a6+SuCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0950/1257] blk-mq: clear stale inactive flag on hctx reuse
Date: Sat,  7 Nov 2026 08:54:06 -0500
Message-ID: <20261107135005.584888510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e929f94b25c7f..5a5dc66fc3b15 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4003,6 +4003,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 		goto fail;
 
 	hctx->queue_num = hctx_idx;
+	clear_bit(BLK_MQ_S_INACTIVE, &hctx->state);
 
 	hctx->tags = set->tags[hctx_idx];
 
-- 
2.53.0



