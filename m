Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED85382871;
	Wed, 19 Jun 2024 13:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802341; cv=none; b=lNLUz/ICz4Ls9Z5G4J3NdHExGrfvi+mr2/K0rZ/U/UDSplteOJSelKUY7tEim1zv6uHUyLeOCyJi65wXTrEe9dqS3Z5dTAtA2AaisAWxEKZPUp19x8WznGSrOXqfuQU+Qe7nZfIj5a5D/fmK+lVlJcb1mH571xR8kTCAN87+Sn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802341; c=relaxed/simple;
	bh=IscNATaARKlYWUVFOClqWYc05lonMPTvt2n57sxPMAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdk2K2oUa6ayb3Tnqss+SXwN8XC4jRvgLY1v4fG8l34pToMZm2k1xLknzqU/O2fH4zgiKZlnrIzhjUsnFQ/bMHnSkUe13ODsgLetS18pmlRLyMyvcAwbjnvRBcSCZN23mF57eYbhLZTbiRLUFojJMw3qi3wVptekHXcgvK/0mbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3/KrJAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3/KrJAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CF6C2BBFC;
	Wed, 19 Jun 2024 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802340;
	bh=IscNATaARKlYWUVFOClqWYc05lonMPTvt2n57sxPMAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3/KrJAEHahiAAX1kjqYhKaOMq1LiHMl2ZLh/e1usdoWdmIrVt8I5JNzchxDeiTBI
	 3rCcx1m3NfUHC1U6vnm2xm7MzC7Pk+XYpkcnGzm6CIl7QTkV9yzTEHLaO/XmhwVnC3
	 0fDhDRcM5GDkDE8GhYgw5yyFGZ4PjexiJDF8CRYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Weber <f.weber@proxmox.com>,
	Christoph Hellwig <hch@lst.de>,
	ming.lei@redhat.com,
	bvanassche@acm.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/267] block: fix request.queuelist usage in flush
Date: Wed, 19 Jun 2024 14:55:15 +0200
Message-ID: <20240619125612.639568217@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <chengming.zhou@linux.dev>

[ Upstream commit d0321c812d89c5910d8da8e4b10c891c6b96ff70 ]

Friedrich Weber reported a kernel crash problem and bisected to commit
81ada09cc25e ("blk-flush: reuse rq queuelist in flush state machine").

The root cause is that we use "list_move_tail(&rq->queuelist, pending)"
in the PREFLUSH/POSTFLUSH sequences. But rq->queuelist.next == xxx since
it's popped out from plug->cached_rq in __blk_mq_alloc_requests_batch().
We don't initialize its queuelist just for this first request, although
the queuelist of all later popped requests will be initialized.

Fix it by changing to use "list_add_tail(&rq->queuelist, pending)" so
rq->queuelist doesn't need to be initialized. It should be ok since rq
can't be on any list when PREFLUSH or POSTFLUSH, has no move actually.

Please note the commit 81ada09cc25e ("blk-flush: reuse rq queuelist in
flush state machine") also has another requirement that no drivers would
touch rq->queuelist after blk_mq_end_request() since we will reuse it to
add rq to the post-flush pending list in POSTFLUSH. If this is not true,
we will have to revert that commit IMHO.

This updated version adds "list_del_init(&rq->queuelist)" in flush rq
callback since the dm layer may submit request of a weird invalid format
(REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH), which causes double list_add
if without this "list_del_init(&rq->queuelist)". The weird invalid format
problem should be fixed in dm layer.

Reported-by: Friedrich Weber <f.weber@proxmox.com>
Closes: https://lore.kernel.org/lkml/14b89dfb-505c-49f7-aebb-01c54451db40@proxmox.com/
Closes: https://lore.kernel.org/lkml/c9d03ff7-27c5-4ebd-b3f6-5a90d96f35ba@proxmox.com/
Fixes: 81ada09cc25e ("blk-flush: reuse rq queuelist in flush state machine")
Cc: Christoph Hellwig <hch@lst.de>
Cc: ming.lei@redhat.com
Cc: bvanassche@acm.org
Tested-by: Friedrich Weber <f.weber@proxmox.com>
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240608143115.972486-1-chengming.zhou@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-flush.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index e73dc22d05c1d..313f0ffcce42e 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -183,7 +183,7 @@ static void blk_flush_complete_seq(struct request *rq,
 		/* queue for flush */
 		if (list_empty(pending))
 			fq->flush_pending_since = jiffies;
-		list_move_tail(&rq->queuelist, pending);
+		list_add_tail(&rq->queuelist, pending);
 		break;
 
 	case REQ_FSEQ_DATA:
@@ -261,6 +261,7 @@ static enum rq_end_io_ret flush_end_io(struct request *flush_rq,
 		unsigned int seq = blk_flush_cur_seq(rq);
 
 		BUG_ON(seq != REQ_FSEQ_PREFLUSH && seq != REQ_FSEQ_POSTFLUSH);
+		list_del_init(&rq->queuelist);
 		blk_flush_complete_seq(rq, fq, seq, error);
 	}
 
-- 
2.43.0



