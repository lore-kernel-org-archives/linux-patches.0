Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FD16FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F6CC433C7;
	Sun, 17 Sep 2023 20:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980947;
	bh=g5exPWYRD7INzpOL3dozARgSY8fBdIf6fnA8V81nSzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORlAgnfD0yzR122sP8m7kvP+UspnuNPgVRiGB+h4nuG8qsdERYEn/Woi7aQHZlfPQ
	 DbrphIF9WGx3eN4OpKB0tJZBaNxpab/1Me5/1mZSbMXuO11ZHKKSVMFpWlSaMm9JyI
	 5XQl/koyKxWr9o1ZR30Vh1j/F16AC2QNEW6Ujwtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 025/219] null_blk: fix poll request timeout handling
Date: Sun, 17 Sep 2023 21:12:32 +0200
Message-ID: <20230917191041.907917456@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

commit 5a26e45edb4690d58406178b5a9ea4c6dcf2c105 upstream.

When doing io_uring benchmark on /dev/nullb0, it's easy to crash the
kernel if poll requests timeout triggered, as reported by David. [1]

BUG: kernel NULL pointer dereference, address: 0000000000000008
Workqueue: kblockd blk_mq_timeout_work
RIP: 0010:null_timeout_rq+0x4e/0x91
Call Trace:
 ? null_timeout_rq+0x4e/0x91
 blk_mq_handle_expired+0x31/0x4b
 bt_iter+0x68/0x84
 ? bt_tags_iter+0x81/0x81
 __sbitmap_for_each_set.constprop.0+0xb0/0xf2
 ? __blk_mq_complete_request_remote+0xf/0xf
 bt_for_each+0x46/0x64
 ? __blk_mq_complete_request_remote+0xf/0xf
 ? percpu_ref_get_many+0xc/0x2a
 blk_mq_queue_tag_busy_iter+0x14d/0x18e
 blk_mq_timeout_work+0x95/0x127
 process_one_work+0x185/0x263
 worker_thread+0x1b5/0x227

This is indeed a race problem between null_timeout_rq() and null_poll().

null_poll()				null_timeout_rq()
  spin_lock(&nq->poll_lock)
  list_splice_init(&nq->poll_list, &list)
  spin_unlock(&nq->poll_lock)

  while (!list_empty(&list))
    req = list_first_entry()
    list_del_init()
    ...
    blk_mq_add_to_batch()
    // req->rq_next = NULL
					spin_lock(&nq->poll_lock)

					// rq->queuelist->next == NULL
					list_del_init(&rq->queuelist)

					spin_unlock(&nq->poll_lock)

Fix these problems by setting requests state to MQ_RQ_COMPLETE under
nq->poll_lock protection, in which null_timeout_rq() can safely detect
this race and early return.

Note this patch just fix the kernel panic when request timeout happen.

[1] https://lore.kernel.org/all/3893581.1691785261@warthog.procyon.org.uk/

Fixes: 0a593fbbc245 ("null_blk: poll queue support")
Reported-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Link: https://lore.kernel.org/r/20230901120306.170520-2-chengming.zhou@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/main.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1585,9 +1585,12 @@ static int null_poll(struct blk_mq_hw_ct
 	struct nullb_queue *nq = hctx->driver_data;
 	LIST_HEAD(list);
 	int nr = 0;
+	struct request *rq;
 
 	spin_lock(&nq->poll_lock);
 	list_splice_init(&nq->poll_list, &list);
+	list_for_each_entry(rq, &list, queuelist)
+		blk_mq_set_request_complete(rq);
 	spin_unlock(&nq->poll_lock);
 
 	while (!list_empty(&list)) {
@@ -1613,16 +1616,21 @@ static enum blk_eh_timer_return null_tim
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
-	pr_info("rq %p timed out\n", rq);
-
 	if (hctx->type == HCTX_TYPE_POLL) {
 		struct nullb_queue *nq = hctx->driver_data;
 
 		spin_lock(&nq->poll_lock);
+		/* The request may have completed meanwhile. */
+		if (blk_mq_request_completed(rq)) {
+			spin_unlock(&nq->poll_lock);
+			return BLK_EH_DONE;
+		}
 		list_del_init(&rq->queuelist);
 		spin_unlock(&nq->poll_lock);
 	}
 
+	pr_info("rq %p timed out\n", rq);
+
 	/*
 	 * If the device is marked as blocking (i.e. memory backed or zoned
 	 * device), the submission path may be blocked waiting for resources


