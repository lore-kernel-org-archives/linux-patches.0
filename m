Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036740;
	b=L0T5ZQ/2RnzRJGF7I5/j4qKfJM/xafFsKj8pGsSNuxrXQ9bH41XyY+7HgO9/5QzGmbbp
	 88/UBrqrwoSzN0yX3yPYGS7kdN/g9zc14ZehNoMRk4pruteDkEJNbIKYaFgAdpX3/qpWA
	 0URf6w9d8rQz8p9tisqrc5F7X4Y7dnATUWbXoi4JZvjSiC6fwOv54qJm0QPO4Z5Plfim2
	 bmspXOd0//21fjYKbw5OX4HX7zZZb0AMSmJ4EY7lNf5qQNxZtSbC0nEVtrIgczCzF4g9x
	 UgQ74Uu0EvmxHkHJdro5NWAHzIbA5swQqNpnQrxe/G5/LZ0PAZAA6BmRfGXFzClNohg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gzE9SuTrb2FB2IQC+sADL0Zy+MhWjDR30x5P7M4nRMA=;
	b=iwpOHtHCWzi1XZ2Cq/34ysSdGqesQmS1lgeGIOEUy68tKGmkoKNGaifKrdxWRID1j0e9
	 IgSjQVDhtpaK5H2JDgPuznIugIlf5O8mcbF2kZNkP9JcBxAsWaZlWOrU/A5nHLx+yHn+x
	 7LogIO0eOM6q9JTqbulz5xwkLwopVo6QGYn6xhrtF+4CxFMVV1Z4MPYoTvfRt1h3kUxq7
	 6VmTqlkgUO/rmVW5FhrO7ElYJ/eYlGbsVncGiQjpNXRf4KdFuPOUX1sBUz0RZpMHz7hAg
	 PkC4I89+DoB4AABhafIk3HQSc8peGNmFkazIRgORg8lVEWaQkAcZa0MkpgMIURp/oTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeXGlRD7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E5A606A31C;
	Wed, 18 Nov 2026 21:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeXGlRD7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A761F000C4;
	Wed, 18 Nov 2026 21:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036740;
	bh=gzE9SuTrb2FB2IQC+sADL0Zy+MhWjDR30x5P7M4nRMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeXGlRD7HrLAVOxDCS+VYsV1vy1qij2gDHAzNRfeM9rh3hBwy3tp/GQ7E7Sez8sDh
	 eYlAUQx2scRtYJiDH7cH7ud1K4QrV6OSo6G82/VJyaepx3WShKnqkmOCgbUlnkFv2H
	 Fw6GwueryNESzU3Ulzmcqpr2S9Vt/pZ/khC/MwAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1168/3318] blk-mq: clear stale inactive flag on hctx reuse
Date: Wed, 18 Nov 2026 15:29:50 +0100
Message-ID: <20261118150355.161253117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e3fb9222c5ee0..aebcc7fb17865 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3841,6 +3841,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 		struct blk_mq_hw_ctx *hctx, unsigned hctx_idx)
 {
 	hctx->queue_num = hctx_idx;
+	clear_bit(BLK_MQ_S_INACTIVE, &hctx->state);
 
 	hctx->tags = set->tags[hctx_idx];
 
-- 
2.53.0



