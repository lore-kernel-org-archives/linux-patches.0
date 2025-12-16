Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F189315D48;
	Tue, 16 Dec 2025 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884912; cv=none; b=hyst235UfAkHSfNQrjj02ripDxQynvMU+/y0IC1RmGxJKPw2vyHjAqOHOAQFhiNpW+nOPVJj30o35to0FegdLJFw/qBZ5iphtHGy/bCN3TEIF2gx2PvN2j4nMVwjo4UPbaSpuKNXsSvdym1LQ9ZBCoZeW5HQbFcmWe7BJVG8wUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884912; c=relaxed/simple;
	bh=7o8Ktjw1Nnfw2jYFvpCEij/I0nZEsQHvI4Ptjy6rRCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smBQpCrVqMtxYxBy0/2MIW6Qci0ty15zV2Bfa9t9yzkZ9fwMeJo+l6+6g7iRGSE/WhLV2E/fllXHuUrg9IekpQtN7D5U2C8lZHQiTntUjGmUo5XuhX0/4D9JmYNBKn7GmyNkVayo7sMKewMSiUyKLDCI3eQbPWBYY+nhhJw+Fyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAyDuClV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAyDuClV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED64DC4CEF1;
	Tue, 16 Dec 2025 11:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884912;
	bh=7o8Ktjw1Nnfw2jYFvpCEij/I0nZEsQHvI4Ptjy6rRCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAyDuClVJIwsIxneKubgL60/Qh10J9+9p8GLDYn+v7+VPoOcsVmwW8klPkf1zcrax
	 v6qhNmJr6FY9QGra1nYIJbGkqC6BoB53O/maRPnLXrQLvBlB7aAExdWN+Ahb0uV5ox
	 Qe0nH5qcWAW5p/lP9IUxn0dw0F2o4ZNAi/J02rEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/354] block: Use RCU in blk_mq_[un]quiesce_tagset() instead of set->tag_list_lock
Date: Tue, 16 Dec 2025 12:15:03 +0100
Message-ID: <20251216111333.080615795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit 59e25ef2b413c72da6686d431e7759302cfccafa ]

blk_mq_{add,del}_queue_tag_set() functions add and remove queues from
tagset, the functions make sure that tagset and queues are marked as
shared when two or more queues are attached to the same tagset.
Initially a tagset starts as unshared and when the number of added
queues reaches two, blk_mq_add_queue_tag_set() marks it as shared along
with all the queues attached to it. When the number of attached queues
drops to 1 blk_mq_del_queue_tag_set() need to mark both the tagset and
the remaining queues as unshared.

Both functions need to freeze current queues in tagset before setting on
unsetting BLK_MQ_F_TAG_QUEUE_SHARED flag. While doing so, both functions
hold set->tag_list_lock mutex, which makes sense as we do not want
queues to be added or deleted in the process. This used to work fine
until commit 98d81f0df70c ("nvme: use blk_mq_[un]quiesce_tagset")
made the nvme driver quiesce tagset instead of quiscing individual
queues. blk_mq_quiesce_tagset() does the job and quiesce the queues in
set->tag_list while holding set->tag_list_lock also.

This results in deadlock between two threads with these stacktraces:

  __schedule+0x47c/0xbb0
  ? timerqueue_add+0x66/0xb0
  schedule+0x1c/0xa0
  schedule_preempt_disabled+0xa/0x10
  __mutex_lock.constprop.0+0x271/0x600
  blk_mq_quiesce_tagset+0x25/0xc0
  nvme_dev_disable+0x9c/0x250
  nvme_timeout+0x1fc/0x520
  blk_mq_handle_expired+0x5c/0x90
  bt_iter+0x7e/0x90
  blk_mq_queue_tag_busy_iter+0x27e/0x550
  ? __blk_mq_complete_request_remote+0x10/0x10
  ? __blk_mq_complete_request_remote+0x10/0x10
  ? __call_rcu_common.constprop.0+0x1c0/0x210
  blk_mq_timeout_work+0x12d/0x170
  process_one_work+0x12e/0x2d0
  worker_thread+0x288/0x3a0
  ? rescuer_thread+0x480/0x480
  kthread+0xb8/0xe0
  ? kthread_park+0x80/0x80
  ret_from_fork+0x2d/0x50
  ? kthread_park+0x80/0x80
  ret_from_fork_asm+0x11/0x20

  __schedule+0x47c/0xbb0
  ? xas_find+0x161/0x1a0
  schedule+0x1c/0xa0
  blk_mq_freeze_queue_wait+0x3d/0x70
  ? destroy_sched_domains_rcu+0x30/0x30
  blk_mq_update_tag_set_shared+0x44/0x80
  blk_mq_exit_queue+0x141/0x150
  del_gendisk+0x25a/0x2d0
  nvme_ns_remove+0xc9/0x170
  nvme_remove_namespaces+0xc7/0x100
  nvme_remove+0x62/0x150
  pci_device_remove+0x23/0x60
  device_release_driver_internal+0x159/0x200
  unbind_store+0x99/0xa0
  kernfs_fop_write_iter+0x112/0x1e0
  vfs_write+0x2b1/0x3d0
  ksys_write+0x4e/0xb0
  do_syscall_64+0x5b/0x160
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

The top stacktrace is showing nvme_timeout() called to handle nvme
command timeout. timeout handler is trying to disable the controller and
as a first step, it needs to blk_mq_quiesce_tagset() to tell blk-mq not
to call queue callback handlers. The thread is stuck waiting for
set->tag_list_lock as it tries to walk the queues in set->tag_list.

The lock is held by the second thread in the bottom stack which is
waiting for one of queues to be frozen. The queue usage counter will
drop to zero after nvme_timeout() finishes, and this will not happen
because the thread will wait for this mutex forever.

Given that [un]quiescing queue is an operation that does not need to
sleep, update blk_mq_[un]quiesce_tagset() to use RCU instead of taking
set->tag_list_lock, update blk_mq_{add,del}_queue_tag_set() to use RCU
safe list operations. Also, delete INIT_LIST_HEAD(&q->tag_set_list)
in blk_mq_del_queue_tag_set() because we can not re-initialize it while
the list is being traversed under RCU. The deleted queue will not be
added/deleted to/from a tagset and it will be freed in blk_free_queue()
after the end of RCU grace period.

Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Fixes: 98d81f0df70c ("nvme: use blk_mq_[un]quiesce_tagset")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9115419d33ed9..db72779760d5c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -364,12 +364,12 @@ void blk_mq_quiesce_tagset(struct blk_mq_tag_set *set)
 {
 	struct request_queue *q;
 
-	mutex_lock(&set->tag_list_lock);
-	list_for_each_entry(q, &set->tag_list, tag_set_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(q, &set->tag_list, tag_set_list) {
 		if (!blk_queue_skip_tagset_quiesce(q))
 			blk_mq_quiesce_queue_nowait(q);
 	}
-	mutex_unlock(&set->tag_list_lock);
+	rcu_read_unlock();
 
 	blk_mq_wait_quiesce_done(set);
 }
@@ -379,12 +379,12 @@ void blk_mq_unquiesce_tagset(struct blk_mq_tag_set *set)
 {
 	struct request_queue *q;
 
-	mutex_lock(&set->tag_list_lock);
-	list_for_each_entry(q, &set->tag_list, tag_set_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(q, &set->tag_list, tag_set_list) {
 		if (!blk_queue_skip_tagset_quiesce(q))
 			blk_mq_unquiesce_queue(q);
 	}
-	mutex_unlock(&set->tag_list_lock);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(blk_mq_unquiesce_tagset);
 
@@ -4255,7 +4255,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 	struct blk_mq_tag_set *set = q->tag_set;
 
 	mutex_lock(&set->tag_list_lock);
-	list_del(&q->tag_set_list);
+	list_del_rcu(&q->tag_set_list);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
@@ -4263,7 +4263,6 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		blk_mq_update_tag_set_shared(set, false);
 	}
 	mutex_unlock(&set->tag_list_lock);
-	INIT_LIST_HEAD(&q->tag_set_list);
 }
 
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
@@ -4282,7 +4281,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	}
 	if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
 		queue_set_hctx_shared(q, true);
-	list_add_tail(&q->tag_set_list, &set->tag_list);
+	list_add_tail_rcu(&q->tag_set_list, &set->tag_list);
 
 	mutex_unlock(&set->tag_list_lock);
 }
-- 
2.51.0



