Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3079BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D09C433EF;
	Tue,  7 Mar 2023 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211395;
	bh=NhHFIaADgd7fgNQEZYy/GBvu5bD+BjYn9akLOa/HyXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKK/AvhqbXIzDBWPGy4JCJJY6RyA2V0TfW3VC1iu62VtpnhovBta9/2WiscOw/A1/
	 ubfZWDTfc2rXwTjqmoGajjLjM8kzm4Ob4ZKnFdRDACF5qc0BfGOPPcPwY1+/lz+pvI
	 s3dqa5FNZLGZR9OtRVpch2yh4AIJbtFjx7GinPHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0848/1001] brd: mark as nowait compatible
Date: Tue,  7 Mar 2023 18:00:20 +0100
Message-Id: <20230307170058.621178860@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 67205f80be9910207481406c47f7d85e703fb2e9 upstream.

By default, non-mq drivers do not support nowait. This causes io_uring
to use a slower path as the driver cannot be trust not to block. brd
can safely set the nowait flag, as worst case all it does is a NOIO
allocation.

For io_uring, this makes a substantial difference. Before:

submitter=0, tid=453, file=/dev/ram0, node=-1
polled=0, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=440.03K, BW=1718MiB/s, IOS/call=32/31
IOPS=428.96K, BW=1675MiB/s, IOS/call=32/32
IOPS=442.59K, BW=1728MiB/s, IOS/call=32/31
IOPS=419.65K, BW=1639MiB/s, IOS/call=32/32
IOPS=426.82K, BW=1667MiB/s, IOS/call=32/31

and after:

submitter=0, tid=354, file=/dev/ram0, node=-1
polled=0, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=3.37M, BW=13.15GiB/s, IOS/call=32/31
IOPS=3.45M, BW=13.46GiB/s, IOS/call=32/31
IOPS=3.43M, BW=13.42GiB/s, IOS/call=32/32
IOPS=3.43M, BW=13.39GiB/s, IOS/call=32/31
IOPS=3.43M, BW=13.38GiB/s, IOS/call=32/31

or about an 8x in difference. Now that brd is prepared to deal with
REQ_NOWAIT reads/writes, mark it as supporting that.

Cc: stable@vger.kernel.org # 5.10+
Link: https://lore.kernel.org/linux-block/20230203103005.31290-1-p.raghav@samsung.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/brd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -412,6 +412,7 @@ static int brd_alloc(int i)
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
+	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
 	err = add_disk(disk);
 	if (err)
 		goto out_cleanup_disk;


