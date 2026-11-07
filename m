Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061560;
	b=V448y1M7OmFLTJqWqJvRA8vKQyoyNc0+cgl0pxdW+HTWQDhmC0CVsXR2aLZSCojIAbdq
	 bGaue6YC/quyXH0HhvIs1Wbu2ALPnDrIZhLuluGuNoin9l3XxydmUp+PoN9YwXWWVX0mO
	 9D0WFIRwAkp+fpIzfiNB+p7onK2IFB6oXon1y7t9ngtbF6XN/+RaTmj9V0Lmtt8RJ2PfY
	 kGzB14wxkH/mq36DnAHJZjMboJGfaXNNwZ1c2CIyDEmo9HV/bsc681NeTx7bVZ9Kmpe4b
	 bm5zXZAMXd8I7MxQXVNXAqd5NLuGwqPpiOmCaCF8cAhx0zQFb0IL9/KuyjmJdIeODHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4jmrHgiHdAjL/FEa4dRFc3lEhSguUCdRw8p1JIjYF4c=;
	b=hmBWiLjzF4N7+KjaPoEr/QUqNu+ddSzaWRmIQKA6snaLNr0JOpK7o8ndgrYHFpVhzNYO
	 6HjR9G91/tYII4MrlEJ05xm3K+Uln14rExm7zdpGzs5iinH5wWpd/zOAPczJbSs0oLKTk
	 mFQIJybT0lpxphZIF6GGKZK+tX60dmilDXML49qHym53o+LkLZEuwduK8ZhYW4wQR/9oV
	 S5kazCAHPI7gPuwIjXjRQO5OYXA8ayD6bdVNri3+9lkNywzkBCfmb71m326bonPmRYEdg
	 dwFtMdi/37Ff16dljI4b1fFe+MWfZbLNvZAltw6NZpoxHywqwahxOWJqNXl/0dn4gvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g25qNWVQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE44606A326;
	Sat,  7 Nov 2026 14:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g25qNWVQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B34E1F0089F;
	Sat,  7 Nov 2026 14:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061555;
	bh=4jmrHgiHdAjL/FEa4dRFc3lEhSguUCdRw8p1JIjYF4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g25qNWVQv6EcBidYcfPGcs1txIQIn9G6Y9dZRS4/zdbK/TTbfoV2sRIjJ1gUmTE6p
	 Kt0k84fOz8/YUxUYMHPbNi9gUU8bHxaXEs527LxTzD0mCd+740+bkAvIR5oQA1221Y
	 OD9991la+SywlIkC7cpU+YmRomvx1UwNfSLYRvuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Patel <ripatel@wii.dev>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 0638/1536] genirq: Defer kfree(irqaction) until irq_thread_dtor() finishes
Date: Sat,  7 Nov 2026 08:44:14 -0500
Message-ID: <20261107135015.452170404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Richard Patel <ripatel@wii.dev>

commit d04adff6860587e843948b0c31174f8ae11b8dfe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/internals.h |    2 ++
 kernel/irq/manage.c    |   26 ++++++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

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
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -21,6 +21,7 @@
 #include <linux/sched/isolation.h>
 #include <uapi/linux/sched/types.h>
 #include <linux/task_work.h>
+#include <linux/wait_bit.h>
 
 #include "internals.h"
 
@@ -1230,17 +1231,14 @@ void wake_threads_waitq(struct irq_desc
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
 
@@ -1257,6 +1255,14 @@ static void irq_thread_dtor(struct callb
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
@@ -1315,6 +1321,7 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
+	set_bit(IRQTF_EXIT_WORK, &action->thread_flags);
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, TWA_NONE);
 
@@ -1335,6 +1342,7 @@ static int irq_thread(void *data)
 	 * oneshot mask bit can be set.
 	 */
 	task_work_cancel_func(current, irq_thread_dtor);
+	clear_and_wake_up_bit(IRQTF_EXIT_WORK, &action->thread_flags);
 	return 0;
 }
 
@@ -1872,6 +1880,12 @@ out_mput:
 	return ret;
 }
 
+static void irq_stop_thread(struct irqaction *action)
+{
+	kthread_stop_put(action->thread);
+	wait_on_bit(&action->thread_flags, IRQTF_EXIT_WORK, TASK_UNINTERRUPTIBLE);
+}
+
 /*
  * Internal function to unregister an irqaction - used to free
  * regular and special interrupts that are part of the architecture.
@@ -1976,9 +1990,9 @@ static struct irqaction *__free_irq(stru
 	 * the same bit to a newly requested action.
 	 */
 	if (action->thread) {
-		kthread_stop_put(action->thread);
+		irq_stop_thread(action);
 		if (action->secondary && action->secondary->thread)
-			kthread_stop_put(action->secondary->thread);
+			irq_stop_thread(action->secondary);
 	}
 
 	/* Last action releases resources */


