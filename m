Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626356;
	b=egvQHUM8zR/LrhXeZK5nUVwIKAF4BZAdQtRk9k00zrrU/Dh4vgLepnjf/1ujsPaq7h0y
	 tVwdwNFYxE/QcHBJYN2OsbdFH7e3AfTgicMvnCPWoN8TLNIVeNx5z5nTp7X2nUxAk0J5a
	 DSnE3LXzEXAQl2jeFx7KXUt1wzxuM74CSi37oSPRJnwCYCPSlu+bu0GP06mMB2q/qIlUV
	 iZ2i4x51Ajspg0t5SbrKyekZ5baIMbg8/gky/jRKsfhEqKXjtcB5JnmyfufC1SUxiGI7T
	 UMwtSSNTN8Ga8/AR6zeBBMacl7zRSBKOLO23ULEcYlDaUs2VsCNo0xf9w4feTkvLV3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JP+8OVIc33F31ozzMZ+SeO4vXt6TVRO64Z4CzIa2iOc=;
	b=aqINUOKjQMhPZXl4nWEBQ6TkV8pL/H8/iRPHD715s6K105owBwET7NRNAJKCqoQXuzQu
	 0+ZOk6ZqaeA6hI8EgPBegjTANJaUSO6bQu3Dg3XbZdWiJk2yb/LbjdAZZ/xHr0/E2WVQt
	 PXDQYwMFVNJ1XTaY0Trs+UaCytgSxRqDol98gp+ecoB2d6AFTezZ8tjLDoXUnsvPgbTzK
	 vss2cg0qMIzRQ8lYbQJ5h2W2YDnSovII9PayaGVWjiEAJDAfq8J0AENyU7J/8YrNEPQo0
	 iwGxQzMhGFjnSjopPBrJFv/vSxihVtj8j1WpT1hxtT1FcF35o5YZ6yxKCvDKhGqXEew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dw/XeZAf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D82B606A323;
	Wed, 25 Nov 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dw/XeZAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC6A1F000C6;
	Wed, 25 Nov 2026 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626355;
	bh=JP+8OVIc33F31ozzMZ+SeO4vXt6TVRO64Z4CzIa2iOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dw/XeZAfuWecmbagYrx6KzsRfyHfuL9d8uYLNCufgQXArfqpay+rHfMb/bUmqZnRb
	 erEQDa5T5zqIEBH0epXGrG8zK3k7oCOMwJ8gtuxbeC3VBP+SDdu+uJILQWxTh5eWvR
	 xWyTsvO4b4xe0XoK00r3kOSBqwkN2R/9xXrcLeh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Mani Tofigh <mt4022@columbia.edu>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 801/816] blk-mq: take quiesce_lock when removing a queue from the tag set
Date: Wed, 25 Nov 2026 15:39:09 +0100
Message-ID: <20261125143907.712444210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mani Tofigh <mt4022@columbia.edu>

commit 495f22c5a99ac38e527294cdc4f3972718b9bee0 upstream.

Unquiescing a tag set can run the hw queues of a queue whose hctxs were
already freed.  blk_mq_unquiesce_tagset() walks the tag set's queues
under quiesce_lock and rcu_read_lock().  Commit 71ec3c7d6db8 ("blk-mq:
quiesce a queue that joins a quiesced tag set") added quiesce_lock to
the walks and to adding a queue, but blk_mq_del_queue_tag_set() still
removes a queue without it.  The hctxs are then freed right away since
RCU only keeps the request_queue itself alive:

  Task A (controller reset)            Task B (namespace removal)
  blk_mq_unquiesce_tagset()
    /* finds q */
                                       blk_mq_del_queue_tag_set(q)
                                       blk_mq_release(q)
                                         /* frees the hctxs */
    blk_mq_run_hw_queues(q)
      /* reads freed hctxs */

The window is short.  On PREEMPT_RT quiesce_lock is a sleeping lock and
the walk can be preempted inside it, which is how it's hit here:

  [  399.851277] BUG: KASAN: slab-use-after-free in blk_mq_run_hw_queues+0x4bd/0x550
  [  399.851328] Read of size 8 at addr ff11000003014148 by task kworker/u9:2/116
  [  399.851352] CPU: 1 UID: 0 PID: 116 Comm: kworker/u9:2 Not tainted 7.3.0-16299-g81cb9aa43246 #1 PREEMPT_RT
  [  399.851425] Workqueue: nvme-reset-wq nvme_loop_reset_ctrl_work
  [  399.851441] Call Trace:
  [  399.851457]  <TASK>
  [  399.851551]  blk_mq_run_hw_queues+0x4bd/0x550
  [  399.851564]  blk_mq_unquiesce_tagset+0x128/0x210
  [  399.851576]  nvme_loop_reset_ctrl_work+0x78/0x4c0
  [  399.851600]  process_one_work+0x92b/0x16d0
  [  399.851660]  worker_thread+0x4e6/0xd60
  [  399.851707]  kthread+0x300/0x3e0
  [  399.851727]  ret_from_fork+0x4f0/0x6f0
  [  399.851776]  ret_from_fork_asm+0x1a/0x30
  [  399.851793]  </TASK>
  ...
  [  399.851988] Freed by task 111:
  [  399.852040]  kfree+0x1b3/0x4b0
  [  399.852050]  blk_mq_release+0x400/0x550
  [  399.852060]  blk_put_queue+0x94/0x120
  [  399.852068]  disk_release+0x1bd/0x3f0
  [  399.852102]  nvme_free_ns+0x39/0x270
  [  399.852113]  nvme_remove_nsid_range+0x2d1/0x4a0
  [  399.852123]  nvme_scan_ns_list+0x2cc/0x390
  [  399.852134]  nvme_scan_work+0x421/0x9f0
  ...

With BLK_CGROUP the disk's root blkg holds the queue until a grace
period later, which hides this for NVMe namespaces.  It's still open
without BLK_CGROUP, and from reading the code also for queues freed
without a disk (e.g., SCSI device queues on a UFS host).

Take quiesce_lock around the list_del_rcu() as well so that the walk
either finishes with a queue before it leaves the list or never sees
it, and say so in the comment of quiesce_lock.  With the fix, KASAN
doesn't report the use-after-free anymore.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it about once every 20 minutes on a PREEMPT_RT kernel.

Fixes: 59e25ef2b413 ("block: Use RCU in blk_mq_[un]quiesce_tagset() instead of set->tag_list_lock")
Cc: stable@vger.kernel.org
Reviewed-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20261106-blk-mq-del-quiesce-lock-v2-1-cd4f72a6eb03@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c         |    3 +++
 include/linux/blk-mq.h |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4269,7 +4269,10 @@ static void blk_mq_del_queue_tag_set(str
 
 	lockdep_assert_held(&set->tag_list_lock);
 
+	/* blk_mq_unquiesce_tagset() runs the hctxs, which are not RCU freed */
+	spin_lock(&set->quiesce_lock);
 	list_del_rcu(&q->tag_set_list);
+	spin_unlock(&set->quiesce_lock);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -512,7 +512,8 @@ enum hctx_type {
  * @tag_list:	   List of the request queues that use this tag set. See also
  *		   request_queue.tag_set_list.
  * @quiesce_lock:  Serializes blk_mq_[un]quiesce_tagset() against each other
- *		   and against a request queue being added to @tag_list.
+ *		   and against a request queue being added to or removed from
+ *		   @tag_list.
  * @quiesce_depth: How often blk_mq_quiesce_tagset() has been called without
  *		   blk_mq_unquiesce_tagset().
  * @srcu:	   Use as lock when type of the request queue is blocking


