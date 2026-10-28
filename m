Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216780;
	b=1+5EiTJeMoyOmqiZazE3YBZFZfZ5BOdizqsERvZZwCwoTzUUZbz6rwdfFtH+kPnILWGS
	 UyCxh+quomUgfBGms4sOpBkmXRsF2sLS+8ElXMiCtoL5Ry9s9vOy1/Y/az03YP69AKYrC
	 TFMlap15pYXeuYVzxtDOp6qYrhsucN5dIi6uW3/H9uvLNjY7pfNlALLHqZGCin72M6lZL
	 PPr9a2+hBZ0o/BxQHQViNdMjWBp/Hn1TGzdI7htMLBiBeAIakNJXUgReK5kOo9QIlgTmB
	 cpAeKNvnUdfPuj8ZP2iHiSKCp2uC0ln3Ch4K4H4A6FxGsSTsCkA55TSjMIw9I59VVPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cRSJZCpYlxb2uuzn8A/kLn/G/G40yXEKmBEdmp+yDZI=;
	b=VGS8mOWMwf9ceTQWIl+1VbLFMqnJ4/VwQyC38KSgyT6rL88VoX7JkDfhcSH0oDtsS2i2
	 n1hDY0oC18IFa81hUPJM/75kvQIsop1vLC4gqssQsv8RBPowCaU7C3+vC+jxsiBmDGDL2
	 qgqsG0atAIlyU/eni+pF4F6PbWWd/buuFmRSXczUWMCzSd9lep34nOLJGoifQ9TsU4Ipo
	 Ssh4N/8z5JuwA3f5TJvAOP8vU1+jqylsFQE55EKfHVil7fNmN5HGi4W5AwAJhGRNj9RjI
	 OH5ilT/p+2Hi0rC6yTgtHnu6tzFgblCSSSPhls60kswTdPbmKcNRDWQgmo30uB5cdOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LChpWGZh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9A0606A31A;
	Wed, 28 Oct 2026 19:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LChpWGZh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CED1F01825;
	Wed, 28 Oct 2026 19:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216779;
	bh=cRSJZCpYlxb2uuzn8A/kLn/G/G40yXEKmBEdmp+yDZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LChpWGZhCpQ6uVjO9BUbSwjFOsXK8q3mwxUzQxUZTYYP97MDU4TNCsuuzX3KrVV19
	 E2CF0PBe7xTJ+mIVglY5pQ9KSnkyVVL2z0QgGElkKHSe8at4c5nlEtqbPB25YLtc/g
	 ZrI+Efp0WTlTUHt1TdUBR12UAsY88Wok02sY5ZR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Huang <congei42@163.com>,
	Fei Li <fei1.li@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1675/1887] virt: acrn: Fix irqfd use-after-free during eventfd shutdown
Date: Wed, 28 Oct 2026 18:02:51 +0100
Message-ID: <20261028170537.574873354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/virt/acrn/irqfd.c | 71 ++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/virt/acrn/irqfd.c b/drivers/virt/acrn/irqfd.c
index d4ad211dce7a3..e6280a1005724 100644
--- a/drivers/virt/acrn/irqfd.c
+++ b/drivers/virt/acrn/irqfd.c
@@ -18,6 +18,9 @@
 
 static LIST_HEAD(acrn_irqfd_clients);
 
+/* Cleanup work has been queued; set via test_and_set_bit(). */
+#define HSM_IRQFD_FLAG_SHUTDOWN	0
+
 /**
  * struct hsm_irqfd - Properties of HSM irqfd
  * @vm:		Associated VM pointer
@@ -27,6 +30,7 @@ static LIST_HEAD(acrn_irqfd_clients);
  * @list:	Entry within &acrn_vm.irqfds of irqfds of a VM
  * @pt:		Structure for select/poll on the associated eventfd
  * @msi:	MSI data
+ * @flags:	Internal lifecycle flags (HSM_IRQFD_FLAG_*)
  */
 struct hsm_irqfd {
 	struct acrn_vm		*vm;
@@ -36,6 +40,7 @@ struct hsm_irqfd {
 	struct list_head	list;
 	poll_table		pt;
 	struct acrn_msi_entry	msi;
+	unsigned long		flags;
 };
 
 static void acrn_irqfd_inject(struct hsm_irqfd *irqfd)
@@ -46,30 +51,29 @@ static void acrn_irqfd_inject(struct hsm_irqfd *irqfd)
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
@@ -78,17 +82,16 @@ static int hsm_irqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
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
@@ -145,6 +148,12 @@ static int acrn_irqfd_assign(struct acrn_vm *vm, struct acrn_irqfd *args)
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
@@ -153,14 +162,12 @@ static int acrn_irqfd_assign(struct acrn_vm *vm, struct acrn_irqfd *args)
 		mutex_unlock(&vm->irqfds_lock);
 		goto fail;
 	}
-	list_add_tail(&irqfd->list, &vm->irqfds);
-	mutex_unlock(&vm->irqfds_lock);
 
-	/* Check the pending event in this stage */
 	events = vfs_poll(f.file, &irqfd->pt);
-
+	list_add_tail(&irqfd->list, &vm->irqfds);
 	if (events & EPOLLIN)
 		acrn_irqfd_inject(irqfd);
+	mutex_unlock(&vm->irqfds_lock);
 
 	fdput(f);
 	return 0;
@@ -187,13 +194,17 @@ static int acrn_irqfd_deassign(struct acrn_vm *vm,
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
 
@@ -226,9 +237,15 @@ void acrn_irqfd_deinit(struct acrn_vm *vm)
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



