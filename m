Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C9949DB9B;
	Mon, 31 Aug 2026 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183624; cv=none; b=atfJaEhtnpWrx42l7LsHSi/O3Ot/K1yJmv9UDz+CY7fAKV8qC8bw7DPFybSPD1NK8PwM+H933GTAiBe6y1B838Yi44qEILPK2VZt0WlnAWJOkSdvBl3KnJnI4OC/izYXi5l1LbHZjqo69t8HzGPrPZbreT1kIHmoLr2MtXGO8R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183624; c=relaxed/simple;
	bh=ORshEqZAmZj4RJ6P64H8aJ/Jq7ltrE/uwtKDvnOhsy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3ksba8LyfuYH6UCvvdqb1PIwOPav6pQ+xrpKs2ju0NkouvW9J4Xt+C4hlJkSefrQ7FqN8Nw7HApwTvNb5BoqHHiwneEVgDN4SPVxy3D1hw7vO7RxcibnEf7Px9OI12z8oNq8KOsSXU0C7MCvEmcvK4eDmhJ4Q5Dk5FViXegx+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WeS3ydPX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WeS3ydPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B5B1F00ACA;
	Mon, 31 Aug 2026 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183622;
	bh=5vP5s0rhNizpSe05pI4qpUzJp35E9bLBUCPO5+i8kTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WeS3ydPXHvC9Q9sB9NhSSPts1voIb0TCwsMLSGNxBjWzCblFLk1e+JHMavlj9vrDw
	 M2FQI85H7/D0svCksZl+/f48uBCKZviOfOiXbpNXYLi/wgHDPmNwRSHN0CJRdfSktP
	 ezwBynCSw/zO9ESMXra++IYVP7/e4Ob+g9VMAzrtlkXFSponoUrvuMEvGvXOO5Bv3/
	 ZLJYCnH2iIwz7lRgKW9u4T+MBlHE9WMnJIKDU1pd4uu1fnxZjZxfiGKTUIvXyjeK12
	 RfrW1Zhcn+LqOJK6NM/QiP6ZjcjNuXgXDojZbEmvnW/WT9xnA4HmsmwZjmba7IHN30
	 2/7kJkWVwAP0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sicong Huang <congei42@163.com>,
	Fei Li <fei1.li@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] virt: acrn: Fix irqfd use-after-free during eventfd shutdown
Date: Mon, 31 Aug 2026 09:23:52 -0400
Message-ID: <20260831133314.4125787-204-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Sicong Huang <congei42@163.com>

[ Upstream commit 666c7f9e07925aa0863348f960e09bb89f8f05a3 ]

acrn_irqfd_deassign() and the eventfd EPOLLHUP wakeup can race and free
the same struct hsm_irqfd:

  CPU0                                 CPU1
  ----                                 ----
  eventfd_release()
    wake_up_poll(EPOLLHUP)
      hsm_irqfd_wakeup()
        queue_work(&irqfd->shutdown)
                                       acrn_irqfd_deassign()
                                         hsm_irqfd_shutdown()
                                           list_del_init()
                                           eventfd_ctx_remove_wait_queue()
                                           eventfd_ctx_put()
                                         kfree(irqfd)
  hsm_irqfd_shutdown_work()
    container_of(work, ..., shutdown)
    irqfd->vm                  <-- use-after-free

The deassign path freed the irqfd while a shutdown work item was
already queued by EPOLLHUP (or vice versa), so the work item could
resurrect a dangling pointer through container_of().

Switch to the lifetime model used by KVM irqfds:

 - Deassign/deinit only deactivate the irqfd: remove it from vm->irqfds
   under irqfds_lock and queue the cleanup work.
 - hsm_irqfd_shutdown_work() becomes the sole owner that unhooks the
   eventfd waitqueue entry, drops the eventfd reference and frees the
   irqfd.
 - A new HSM_IRQFD_FLAG_SHUTDOWN bit guarded by test_and_set_bit()
   ensures the cleanup work is queued at most once, no matter how many
   of {EPOLLHUP, deassign, deinit} fire concurrently.  This is safe to
   call from the waitqueue callback, which runs with wqh->lock held and
   IRQs disabled and therefore cannot take irqfds_lock.
 - acrn_irqfd_deassign() flushes vm->irqfd_wq before returning so the
   eventfd is fully detached on return.  acrn_irqfd_deinit() deactivates
   every irqfd, flushes the workqueue and only then destroys it, so no
   path can queue_work() onto a torn-down workqueue.
 - acrn_irqfd_assign() now installs the eventfd waitqueue entry and
   publishes the irqfd to vm->irqfds under irqfds_lock, so the irqfd is
   never visible to deassign/deinit before its waitqueue entry is in
   place, and any EPOLLHUP that fires in the assign window queues
   cleanup work that blocks on irqfds_lock until publication is done.

Signed-off-by: Sicong Huang <congei42@163.com>
Reviewed-by: Fei Li <fei1.li@intel.com>
Link: https://patch.msgid.link/20260519112018.2135000-2-congei42@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

That check finished: `git log -S "hsm_irqfd_queue_shutdown"` on HEAD
returned no matches, so the irqfd UAF fix is not in **6.18.44** yet.
That lines up with the earlier **YES** backport recommendation.

 drivers/virt/acrn/irqfd.c | 71 ++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/virt/acrn/irqfd.c b/drivers/virt/acrn/irqfd.c
index 64d32c8fbf79b..b18d1a9021fb4 100644
--- a/drivers/virt/acrn/irqfd.c
+++ b/drivers/virt/acrn/irqfd.c
@@ -16,6 +16,9 @@
 
 #include "acrn_drv.h"
 
+/* Cleanup work has been queued; set via test_and_set_bit(). */
+#define HSM_IRQFD_FLAG_SHUTDOWN	0
+
 /**
  * struct hsm_irqfd - Properties of HSM irqfd
  * @vm:		Associated VM pointer
@@ -25,6 +28,7 @@
  * @list:	Entry within &acrn_vm.irqfds of irqfds of a VM
  * @pt:		Structure for select/poll on the associated eventfd
  * @msi:	MSI data
+ * @flags:	Internal lifecycle flags (HSM_IRQFD_FLAG_*)
  */
 struct hsm_irqfd {
 	struct acrn_vm		*vm;
@@ -34,6 +38,7 @@ struct hsm_irqfd {
 	struct list_head	list;
 	poll_table		pt;
 	struct acrn_msi_entry	msi;
+	unsigned long		flags;
 };
 
 static void acrn_irqfd_inject(struct hsm_irqfd *irqfd)
@@ -44,30 +49,29 @@ static void acrn_irqfd_inject(struct hsm_irqfd *irqfd)
 			irqfd->msi.msi_data);
 }
 
-static void hsm_irqfd_shutdown(struct hsm_irqfd *irqfd)
+/* Queue the cleanup work at most once. Safe from atomic context. */
+static void hsm_irqfd_queue_shutdown(struct hsm_irqfd *irqfd)
 {
-	u64 cnt;
-
-	lockdep_assert_held(&irqfd->vm->irqfds_lock);
-
-	/* remove from wait queue */
-	list_del_init(&irqfd->list);
-	eventfd_ctx_remove_wait_queue(irqfd->eventfd, &irqfd->wait, &cnt);
-	eventfd_ctx_put(irqfd->eventfd);
-	kfree(irqfd);
+	if (!test_and_set_bit(HSM_IRQFD_FLAG_SHUTDOWN, &irqfd->flags))
+		queue_work(irqfd->vm->irqfd_wq, &irqfd->shutdown);
 }
 
+/* Sole owner of @irqfd: unhook waitqueue, drop eventfd ref, free. */
 static void hsm_irqfd_shutdown_work(struct work_struct *work)
 {
-	struct hsm_irqfd *irqfd;
-	struct acrn_vm *vm;
+	struct hsm_irqfd *irqfd = container_of(work, struct hsm_irqfd,
+					       shutdown);
+	struct acrn_vm *vm = irqfd->vm;
+	u64 cnt;
 
-	irqfd = container_of(work, struct hsm_irqfd, shutdown);
-	vm = irqfd->vm;
 	mutex_lock(&vm->irqfds_lock);
 	if (!list_empty(&irqfd->list))
-		hsm_irqfd_shutdown(irqfd);
+		list_del_init(&irqfd->list);
 	mutex_unlock(&vm->irqfds_lock);
+
+	eventfd_ctx_remove_wait_queue(irqfd->eventfd, &irqfd->wait, &cnt);
+	eventfd_ctx_put(irqfd->eventfd);
+	kfree(irqfd);
 }
 
 /* Called with wqh->lock held and interrupts disabled */
@@ -76,17 +80,16 @@ static int hsm_irqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
 {
 	unsigned long poll_bits = (unsigned long)key;
 	struct hsm_irqfd *irqfd;
-	struct acrn_vm *vm;
 
 	irqfd = container_of(wait, struct hsm_irqfd, wait);
-	vm = irqfd->vm;
+
 	if (poll_bits & POLLIN)
 		/* An event has been signaled, inject an interrupt */
 		acrn_irqfd_inject(irqfd);
 
 	if (poll_bits & POLLHUP)
-		/* Do shutdown work in thread to hold wqh->lock */
-		queue_work(vm->irqfd_wq, &irqfd->shutdown);
+		/* Defer teardown to the cleanup work; can't sleep here. */
+		hsm_irqfd_queue_shutdown(irqfd);
 
 	return 0;
 }
@@ -142,6 +145,12 @@ static int acrn_irqfd_assign(struct acrn_vm *vm, struct acrn_irqfd *args)
 	init_waitqueue_func_entry(&irqfd->wait, hsm_irqfd_wakeup);
 	init_poll_funcptr(&irqfd->pt, hsm_irqfd_poll_func);
 
+	/*
+	 * Hold irqfds_lock across waitqueue install and list_add so the
+	 * irqfd is not visible to deassign/deinit before its waitqueue
+	 * entry is in place, and any racing EPOLLHUP cleanup work blocks
+	 * on irqfds_lock until publication completes.
+	 */
 	mutex_lock(&vm->irqfds_lock);
 	list_for_each_entry(tmp, &vm->irqfds, list) {
 		if (irqfd->eventfd != tmp->eventfd)
@@ -150,14 +159,12 @@ static int acrn_irqfd_assign(struct acrn_vm *vm, struct acrn_irqfd *args)
 		mutex_unlock(&vm->irqfds_lock);
 		goto fail;
 	}
-	list_add_tail(&irqfd->list, &vm->irqfds);
-	mutex_unlock(&vm->irqfds_lock);
 
-	/* Check the pending event in this stage */
 	events = vfs_poll(fd_file(f), &irqfd->pt);
-
+	list_add_tail(&irqfd->list, &vm->irqfds);
 	if (events & EPOLLIN)
 		acrn_irqfd_inject(irqfd);
+	mutex_unlock(&vm->irqfds_lock);
 
 	return 0;
 fail:
@@ -180,13 +187,17 @@ static int acrn_irqfd_deassign(struct acrn_vm *vm,
 	mutex_lock(&vm->irqfds_lock);
 	list_for_each_entry_safe(irqfd, tmp, &vm->irqfds, list) {
 		if (irqfd->eventfd == eventfd) {
-			hsm_irqfd_shutdown(irqfd);
+			list_del_init(&irqfd->list);
+			hsm_irqfd_queue_shutdown(irqfd);
 			break;
 		}
 	}
 	mutex_unlock(&vm->irqfds_lock);
 	eventfd_ctx_put(eventfd);
 
+	/* Wait for cleanup work to finish so the eventfd is fully detached. */
+	flush_workqueue(vm->irqfd_wq);
+
 	return 0;
 }
 
@@ -219,9 +230,15 @@ void acrn_irqfd_deinit(struct acrn_vm *vm)
 	struct hsm_irqfd *irqfd, *next;
 
 	dev_dbg(acrn_dev.this_device, "VM %u irqfd deinit.\n", vm->vmid);
-	destroy_workqueue(vm->irqfd_wq);
+
 	mutex_lock(&vm->irqfds_lock);
-	list_for_each_entry_safe(irqfd, next, &vm->irqfds, list)
-		hsm_irqfd_shutdown(irqfd);
+	list_for_each_entry_safe(irqfd, next, &vm->irqfds, list) {
+		list_del_init(&irqfd->list);
+		hsm_irqfd_queue_shutdown(irqfd);
+	}
 	mutex_unlock(&vm->irqfds_lock);
+
+	/* Drain all cleanup work before tearing the workqueue down. */
+	flush_workqueue(vm->irqfd_wq);
+	destroy_workqueue(vm->irqfd_wq);
 }
-- 
2.53.0

