Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058026;
	b=YTHZi5LixZg7ADwRO3ygOZNrp0G/ikQfaFbeN0CTfs5g11Zzgn1v5vKRjgHJ6akbnFRZ
	 C+Kwcl2XKj3Octn3zm9qTr84h0Hd7ftn+iq0B5Afkg2OZfpaJoYjJ8vat6XKsWPn7GTQ2
	 ZGHZH0B6kat9fejEbeQFIrJ/VBLn5hYPkEI9TtKcaFIZ7l3J5w+i+xTOK0QTVb4FzvY4Q
	 BmLter2HXT34wx8gTQzXXek90IpfyPdQjOx870APFjjOK6U9VFI5qCOMDKASmoGcdT/kC
	 hX3rVms/KihRM9t53TIIGQU7HwGG2kT1phvW4btka0+DDqHad4yCXWGMsVqPbbk6q2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gzpNWCedXa6wrZxlLSdL/fbIO3UM+6l1dukBGtYDSEc=;
	b=yNOCS2OhrTC1uCWWfew+z/3Q9J7Jihtlu6eYNqVEiJTgm3IUFMlcfifaq0U3K6OURrqV
	 2gMxDd8OfsUt1LcBpWo3dUz+Z4z226ZEdvT5x04J5QnQE0s2tyB7vY3wG5AC9R3o3kA0N
	 WIGD+uFefRnIOz/YZb6MyEV4N8M8YvA4rimj6wrWPHAFBQnYsSOoVC+r4L5Jbty+3rmfs
	 XgRFUh2NY7wxYqZaXoUPVzxB48rKlD1yFjZV9DZl3+/a7Gn3YvdozsJHSFfrWU9tYnLT3
	 dqeCzK2FplZaA4ipkFvr1bDcAsKcYJg5MHR9EzQZjDaKv6tscXi0IJQZf5YTi312Prg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyhT4ePW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A34606A31C;
	Thu, 19 Nov 2026 03:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyhT4ePW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441C11F000C4;
	Thu, 19 Nov 2026 03:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058025;
	bh=gzpNWCedXa6wrZxlLSdL/fbIO3UM+6l1dukBGtYDSEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyhT4ePWAymnMQEYkKES3dI7GFt44lNs1txz8ujZoYe7d83fz0BKAZ2E686nQsDyh
	 Rlxx9imnB24ce+1y2JQdVbD9M82ylDE0WRrljqJx4cDI++cgfLwZ1RBzxj+dNNd53m
	 ykTDE3bPr7XSgD1vb1yyZFTwGYRMNCT5wPGdiEbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Patel <ripatel@wii.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0338/1848] genirq: Defer kfree(irqaction) until irq_thread_dtor() finishes
Date: Wed, 18 Nov 2026 15:39:36 +0100
Message-ID: <20261118145926.557097509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Patel <ripatel@wii.dev>

[ Upstream commit d04adff6860587e843948b0c31174f8ae11b8dfe ]

When an interrupt thread exits abnormally via do_exit() (e.g. the interrupt
handler oopses) without returning from irq_thread(), a concurrent call to
free_irq() could free the irqaction before the irq_thread_dtor() exit task
work runs.

  irq thread (oopsed)                 free_irq()
  -------------------                 ----------
  do_exit()
    exit_mm()
      complete_vfork_done()  -------> kthread_stop() returns
    exit_files() ...                  kfree(action)
    exit_task_work()
      irq_thread_dtor()
        action->...                   <- use-after-free

Track the pending exit work with the IRQTF_EXIT_WORK thread flag, and have
__free_irq() wait for the bit to clear before kfree().

irq_thread_dtor() only runs on irq_thread abnormal exit. If that dtor also
faults, free_irq() will hang indefinitely, but double IRQ thread faults
require a reboot anyways.

[ tglx: Add missing include ]

Fixes: ed3e694d78cc ("move exit_task_work() past exit_files() et.al.")
Signed-off-by: Richard Patel <ripatel@wii.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009145842.1616117-2-ripatel@wii.dev
[ sashal: replaced kthread_stop_put() with separate kthread_stop() and put_task_struct() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/internals.h |  2 ++
 kernel/irq/manage.c    | 32 ++++++++++++++++++++++----------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index da1f282d5a1d1..e9531706a91ae 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -30,6 +30,7 @@ extern struct irqaction chained_action;
  * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
  * IRQTF_FORCED_THREAD  - irq action is force threaded
  * IRQTF_READY     - signals that irq thread is ready
+ * IRQTF_EXIT_WORK - irq thread exit task_work is pending
  */
 enum {
 	IRQTF_RUNTHREAD,
@@ -37,6 +38,7 @@ enum {
 	IRQTF_AFFINITY,
 	IRQTF_FORCED_THREAD,
 	IRQTF_READY,
+	IRQTF_EXIT_WORK,
 };
 
 /*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4998e8a561564..bcd5780b2f513 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -21,6 +21,7 @@
 #include <linux/sched/isolation.h>
 #include <uapi/linux/sched/types.h>
 #include <linux/task_work.h>
+#include <linux/wait_bit.h>
 
 #include "internals.h"
 
@@ -1225,17 +1226,14 @@ static void wake_threads_waitq(struct irq_desc *desc)
 		wake_up(&desc->wait_for_threads);
 }
 
-static void irq_thread_dtor(struct callback_head *unused)
+static void __irq_thread_dtor(struct irqaction *action)
 {
 	struct task_struct *tsk = current;
 	struct irq_desc *desc;
-	struct irqaction *action;
 
 	if (WARN_ON_ONCE(!(current->flags & PF_EXITING)))
 		return;
 
-	action = kthread_data(tsk);
-
 	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
 	       tsk->comm, tsk->pid, action->irq);
 
@@ -1252,6 +1250,14 @@ static void irq_thread_dtor(struct callback_head *unused)
 	irq_finalize_oneshot(desc, action);
 }
 
+static void irq_thread_dtor(struct callback_head *unused)
+{
+	struct irqaction *action = kthread_data(current);
+
+	__irq_thread_dtor(action);
+	clear_and_wake_up_bit(IRQTF_EXIT_WORK, &action->thread_flags);
+}
+
 static void irq_wake_secondary(struct irq_desc *desc, struct irqaction *action)
 {
 	struct irqaction *secondary = action->secondary;
@@ -1308,6 +1314,7 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
+	set_bit(IRQTF_EXIT_WORK, &action->thread_flags);
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, TWA_NONE);
 
@@ -1332,6 +1339,7 @@ static int irq_thread(void *data)
 	 * oneshot mask bit can be set.
 	 */
 	task_work_cancel_func(current, irq_thread_dtor);
+	clear_and_wake_up_bit(IRQTF_EXIT_WORK, &action->thread_flags);
 	return 0;
 }
 
@@ -1863,6 +1871,13 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	return ret;
 }
 
+static void irq_stop_thread(struct irqaction *action)
+{
+	kthread_stop(action->thread);
+	put_task_struct(action->thread);
+	wait_on_bit(&action->thread_flags, IRQTF_EXIT_WORK, TASK_UNINTERRUPTIBLE);
+}
+
 /*
  * Internal function to unregister an irqaction - used to free
  * regular and special interrupts that are part of the architecture.
@@ -1967,12 +1982,9 @@ static struct irqaction *__free_irq(struct irq_desc *desc, void *dev_id)
 	 * the same bit to a newly requested action.
 	 */
 	if (action->thread) {
-		kthread_stop(action->thread);
-		put_task_struct(action->thread);
-		if (action->secondary && action->secondary->thread) {
-			kthread_stop(action->secondary->thread);
-			put_task_struct(action->secondary->thread);
-		}
+		irq_stop_thread(action);
+		if (action->secondary && action->secondary->thread)
+			irq_stop_thread(action->secondary);
 	}
 
 	/* Last action releases resources */
-- 
2.53.0



