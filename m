Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E8B27FD42;
	Wed, 23 Apr 2025 15:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421288; cv=none; b=cYO6lsthkwijJ7YjRD0KstltdBi2LQEUssqUz05zirGkzkX/YLSxB374YN37v/7LB5owqJPeNOPny8lrrG3dnIbf1/nTP3dvdRJKStR8afjWgKrhnbqOxOUJu4ioe4SckrpfpY6wbkxOIHa+d1qLLHMbzqVnDrCfi2Bc8AAc9JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421288; c=relaxed/simple;
	bh=NXqQux3KbU2z1cFrHM20mCu9trQGSCPnivbUFF3mruQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZRuMACNfQqGRY2R6a+gpzInPKHFZ0DQDXnBBQ4prSmwrMIuB6mstfc5teANxyf2+YMO1LNnNLu/xBDVykXW0+apeYI9KH6WlL0Lto7TD5YpiSnTWziO5EhYklK9OVLNr4fi4tu9CMsjkXCFDY9HUtwU5hXRH25+YNZG+ojFqk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+/o+9CL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+/o+9CL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9719C4CEE2;
	Wed, 23 Apr 2025 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421288;
	bh=NXqQux3KbU2z1cFrHM20mCu9trQGSCPnivbUFF3mruQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+/o+9CLOeEMnHxY05y2CShV+sBjD9E1FX0TXTl+VNGMze4YDwgI698juluQGia42
	 W8twWQHAA2JHMTA5lIhlR43Uj+Qwi2Wc7X5uTLl5pCc03T0pT0PCSCYCzMXdtdAIXP
	 PboUmI2uZ+WuOAdSxZjEhwRHup+znH/ODLxHpn6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6.12 208/223] block: dont reorder requests in blk_add_rq_to_plug
Date: Wed, 23 Apr 2025 16:44:40 +0200
Message-ID: <20250423142625.637975185@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christoph Hellwig <hch@lst.de>

commit e70c301faece15b618e54b613b1fd6ece3dd05b4 upstream.

Add requests to the tail of the list instead of the front so that they
are queued up in submission order.

Remove the re-reordering in blk_mq_dispatch_plug_list, virtio_queue_rqs
and nvme_queue_rqs now that the list is ordered as expected.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241113152050.157179-6-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c             |    4 ++--
 drivers/block/virtio_blk.c |    2 +-
 drivers/nvme/host/pci.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1386,7 +1386,7 @@ static void blk_add_rq_to_plug(struct bl
 	 */
 	if (!plug->has_elevator && (rq->rq_flags & RQF_SCHED_TAGS))
 		plug->has_elevator = true;
-	rq_list_add_head(&plug->mq_list, rq);
+	rq_list_add_tail(&plug->mq_list, rq);
 	plug->rq_count++;
 }
 
@@ -2840,7 +2840,7 @@ static void blk_mq_dispatch_plug_list(st
 			rq_list_add_tail(&requeue_list, rq);
 			continue;
 		}
-		list_add(&rq->queuelist, &list);
+		list_add_tail(&rq->queuelist, &list);
 		depth++;
 	} while (!rq_list_empty(&plug->mq_list));
 
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -514,7 +514,7 @@ static void virtio_queue_rqs(struct rq_l
 		vq = this_vq;
 
 		if (virtblk_prep_rq_batch(req))
-			rq_list_add_head(&submit_list, req); /* reverse order */
+			rq_list_add_tail(&submit_list, req);
 		else
 			rq_list_add_tail(&requeue_list, req);
 	}
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1026,7 +1026,7 @@ static void nvme_queue_rqs(struct rq_lis
 		nvmeq = req->mq_hctx->driver_data;
 
 		if (nvme_prep_rq_batch(nvmeq, req))
-			rq_list_add_head(&submit_list, req); /* reverse order */
+			rq_list_add_tail(&submit_list, req);
 		else
 			rq_list_add_tail(&requeue_list, req);
 	}


