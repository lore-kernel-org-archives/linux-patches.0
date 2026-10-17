Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F387215E5BB;
	Sat, 17 Oct 2026 17:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257936; cv=none; b=t7yq2Xsi7smOX2v3tHteQSKiML448FR4pMBdrpK5zrYFJRiCC7+uYOtkJ8hucitVH0vxKk3e7qEQxsYhuXHjx3hpxBvPRBBI4PWhZmOc7po9ZF4PS04tnKvYVkLr1mb0SxqhHIg7dKVkxjoTNrHW+zbBZE5pmLaxNr7Ti5sGowM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257936; c=relaxed/simple;
	bh=KlfZ0lGXqdtK/PXlD69ql8xXxGU56t9zWtl2UIAnzGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYVgqW9sIX6UL6cZiFcqCtDpkNuI2R3jnbr3iCnEPw9kMQCsLveeckIdcd2yf/T5ZybnnYnkcRV0oCjbgOBjOEx/NJWQjQb42qOMSEFWb75y4fdNfT2IaLOiAS00YYuwWStcI+r6rSgJV8TA+Qm/mC6fT6jSKNuymHUjR2g520o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RL3stMkg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RL3stMkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9C61F000C4;
	Sat, 17 Oct 2026 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257934;
	bh=UgmQLWLDUPEaGUMGzslke5zv2PSvn2rxnwCOO8NmJ/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RL3stMkghobM55pUK9derS2dWLeiXSD3usPpe/C//OWVSKQJA/NXUHT94YVKoA1B/
	 evJiHwkSJaffYpk9dh7OJgezLTqKIU4mqhmCf/johB1TjBIcjdCcNsPgpvtXlm5arQ
	 yYv6BJcyn8MMUG8bwvsWChz+UF+vpuacmjQtXLFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0719/1674] ublk: fix handling recovery & reissue in ublk_abort_queue()
Date: Sat, 17 Oct 2026 17:49:51 +0200
Message-ID: <20261017160449.562967753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 6ee6bd5d4fce502a5b5a2ea805e9ff16e6aa890f ]

Commit 8284066946e6 ("ublk: grab request reference when the request is handled
by userspace") doesn't grab request reference in case of recovery reissue.
Then the request can be requeued & re-dispatch & failed when canceling
uring command.

If it is one zc request, the request can be freed before io_uring
returns the zc buffer back, then cause kernel panic:

[  126.773061] BUG: kernel NULL pointer dereference, address: 00000000000000c8
[  126.773657] #PF: supervisor read access in kernel mode
[  126.774052] #PF: error_code(0x0000) - not-present page
[  126.774455] PGD 0 P4D 0
[  126.774698] Oops: Oops: 0000 [#1] SMP NOPTI
[  126.775034] CPU: 13 UID: 0 PID: 1612 Comm: kworker/u64:55 Not tainted 6.14.0_blk+ #182 PREEMPT(full)
[  126.775676] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-1.fc39 04/01/2014
[  126.776275] Workqueue: iou_exit io_ring_exit_work
[  126.776651] RIP: 0010:ublk_io_release+0x14/0x130 [ublk_drv]

Fixes it by always grabbing request reference for aborting the request.

Reported-by: Caleb Sander Mateos <csander@purestorage.com>
Closes: https://lore.kernel.org/linux-block/CADUfDZodKfOGUeWrnAxcZiLT+puaZX8jDHoj_sfHZCOZwhzz6A@mail.gmail.com/
Fixes: 8284066946e6 ("ublk: grab request reference when the request is handled by userspace")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250409011444.2142010-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 356f32b6f1803..c39eab406978e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1134,13 +1134,37 @@ static inline void __ublk_complete_rq(struct request *req)
 	ublk_end_request(req, res);
 }
 
+static void ublk_do_fail_rq(struct request *req)
+{
+	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+
+	if (ublk_queue_can_use_recovery_reissue(ubq))
+		blk_mq_requeue_request(req, false);
+	else
+		__ublk_complete_rq(req);
+}
+
+static void ublk_fail_rq_fn(struct kref *ref)
+{
+	struct ublk_rq_data *data = container_of(ref, struct ublk_rq_data,
+			ref);
+	struct request *req = blk_mq_rq_from_pdu(data);
+
+	ublk_do_fail_rq(req);
+}
+
 static void ublk_complete_rq(struct kref *ref)
 {
 	struct ublk_rq_data *data = container_of(ref, struct ublk_rq_data,
 			ref);
 	struct request *req = blk_mq_rq_from_pdu(data);
+	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 
-	__ublk_complete_rq(req);
+	/* the abort path's reference may be dropped by another holder last */
+	if (ubq->ios[req->tag].flags & UBLK_IO_FLAG_ABORTED)
+		ublk_do_fail_rq(req);
+	else
+		__ublk_complete_rq(req);
 }
 
 /*
@@ -1158,10 +1182,13 @@ static void __ublk_fail_req(struct ublk_queue *ubq, struct ublk_io *io,
 
 	if (!(io->flags & UBLK_IO_FLAG_ABORTED)) {
 		io->flags |= UBLK_IO_FLAG_ABORTED;
-		if (ublk_queue_can_use_recovery_reissue(ubq))
-			blk_mq_requeue_request(req, false);
-		else
-			ublk_put_req_ref(ubq, req);
+		if (ublk_need_req_ref(ubq)) {
+			struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+
+			kref_put(&data->ref, ublk_fail_rq_fn);
+		} else {
+			ublk_do_fail_rq(req);
+		}
 	}
 }
 
-- 
2.53.0



