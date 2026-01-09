Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A6215ADB4;
	Fri,  9 Jan 2026 12:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961412; cv=none; b=OfiY0UkZS6reOzkopBX+wmJwiluIaZrGHQgGWaPN7tsAxi8dOnprFl1/Kyv8hg0HgwNJ/JDdgOhzJL+iTiMXNDtzdGIUj7adEr2SvM6wK6P7Peb45XnIE85L7IJ4O0Mks47k1HGQQLA1+QLMK4J5ESUCx0gqpBnZ1cMkQKhz7RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961412; c=relaxed/simple;
	bh=vIFinzTFR+L9kNezMIT90amYDnGDtoUtx2AalIUjp7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRGXfSi4j9FqY9cpIuVFTyFFaYYXaaNCpwPtnJB5nuPuqpdAlH0HebGxcej9LdsI/g3/xk1yi6VvZAMP/qcX8NSBt+FoO2p14gmjz4O+4BE4c66sCrbcfgJSPWbbUyBuA/UkquBW7PP8aaSdl1QYkN/cqUMPUtqD1PXTAOnWyYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+uLsera; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+uLsera"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8712C4CEF1;
	Fri,  9 Jan 2026 12:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961412;
	bh=vIFinzTFR+L9kNezMIT90amYDnGDtoUtx2AalIUjp7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+uLseraH8BcTuVjWIu8wKSuLeRVz9Fq3W0GqXcNuThCZLb4733VPO1sbbz0DyKau
	 U23aS7gqxkxfKFLXAT58ttVjlxymMFq+nwm3NaO7CJ1pyCP++qe9vbUITfTN9Mzpiu
	 XvCunNq2CQf91kkUIpIqXwbVrq057QxqiyjGFvI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.6 713/737] net: Allow to use SMP threads for backlog NAPI.
Date: Fri,  9 Jan 2026 12:44:12 +0100
Message-ID: <20260109112200.898415351@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit dad6b97702639fba27a2bd3e986982ad6f0db3a7 upstream.

Backlog NAPI is a per-CPU NAPI struct only (with no device behind it)
used by drivers which don't do NAPI them self, RPS and parts of the
stack which need to avoid recursive deadlocks while processing a packet.

The non-NAPI driver use the CPU local backlog NAPI. If RPS is enabled
then a flow for the skb is computed and based on the flow the skb can be
enqueued on a remote CPU. Scheduling/ raising the softirq (for backlog's
NAPI) on the remote CPU isn't trivial because the softirq is only
scheduled on the local CPU and performed after the hardirq is done.
In order to schedule a softirq on the remote CPU, an IPI is sent to the
remote CPU which schedules the backlog-NAPI on the then local CPU.

On PREEMPT_RT interrupts are force-threaded. The soft interrupts are
raised within the interrupt thread and processed after the interrupt
handler completed still within the context of the interrupt thread. The
softirq is handled in the context where it originated.

With force-threaded interrupts enabled, ksoftirqd is woken up if a
softirq is raised from hardirq context. This is the case if it is raised
from an IPI. Additionally there is a warning on PREEMPT_RT if the
softirq is raised from the idle thread.
This was done for two reasons:
- With threaded interrupts the processing should happen in thread
  context (where it originated) and ksoftirqd is the only thread for
  this context if raised from hardirq. Using the currently running task
  instead would "punish" a random task.
- Once ksoftirqd is active it consumes all further softirqs until it
  stops running. This changed recently and is no longer the case.

Instead of keeping the backlog NAPI in ksoftirqd (in force-threaded/
PREEMPT_RT setups) I am proposing NAPI-threads for backlog.
The "proper" setup with threaded-NAPI is not doable because the threads
are not pinned to an individual CPU and can be modified by the user.
Additionally a dummy network device would have to be assigned. Also
CPU-hotplug has to be considered if additional CPUs show up.
All this can be probably done/ solved but the smpboot-threads already
provide this infrastructure.

Sending UDP packets over loopback expects that the packet is processed
within the call. Delaying it by handing it over to the thread hurts
performance. It is not beneficial to the outcome if the context switch
happens immediately after enqueue or after a while to process a few
packets in a batch.
There is no need to always use the thread if the backlog NAPI is
requested on the local CPU. This restores the loopback throuput. The
performance drops mostly to the same value after enabling RPS on the
loopback comparing the IPI and the tread result.

Create NAPI-threads for backlog if request during boot. The thread runs
the inner loop from napi_threaded_poll(), the wait part is different. It
checks for NAPI_STATE_SCHED (the backlog NAPI can not be disabled).

The NAPI threads for backlog are optional, it has to be enabled via the boot
argument "thread_backlog_napi". It is mandatory for PREEMPT_RT to avoid the
wakeup of ksoftirqd from the IPI.

Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |  152 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 115 insertions(+), 37 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -78,6 +78,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/smpboot.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/string.h>
@@ -217,6 +218,31 @@ static inline struct hlist_head *dev_ind
 	return &net->dev_index_head[ifindex & (NETDEV_HASHENTRIES - 1)];
 }
 
+#ifndef CONFIG_PREEMPT_RT
+
+static DEFINE_STATIC_KEY_FALSE(use_backlog_threads_key);
+
+static int __init setup_backlog_napi_threads(char *arg)
+{
+	static_branch_enable(&use_backlog_threads_key);
+	return 0;
+}
+early_param("thread_backlog_napi", setup_backlog_napi_threads);
+
+static bool use_backlog_threads(void)
+{
+	return static_branch_unlikely(&use_backlog_threads_key);
+}
+
+#else
+
+static bool use_backlog_threads(void)
+{
+	return true;
+}
+
+#endif
+
 static inline void rps_lock_irqsave(struct softnet_data *sd,
 				    unsigned long *flags)
 {
@@ -4494,6 +4520,7 @@ EXPORT_SYMBOL(__dev_direct_xmit);
 /*************************************************************************
  *			Receiver routines
  *************************************************************************/
+static DEFINE_PER_CPU(struct task_struct *, backlog_napi);
 
 int netdev_max_backlog __read_mostly = 1000;
 EXPORT_SYMBOL(netdev_max_backlog);
@@ -4526,12 +4553,16 @@ static inline void ____napi_schedule(str
 		 */
 		thread = READ_ONCE(napi->thread);
 		if (thread) {
+			if (use_backlog_threads() && thread == raw_cpu_read(backlog_napi))
+				goto use_local_napi;
+
 			set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
 			wake_up_process(thread);
 			return;
 		}
 	}
 
+use_local_napi:
 	list_add_tail(&napi->poll_list, &sd->poll_list);
 	WRITE_ONCE(napi->list_owner, smp_processor_id());
 	/* If not called from net_rx_action()
@@ -4777,6 +4808,11 @@ static void napi_schedule_rps(struct sof
 
 #ifdef CONFIG_RPS
 	if (sd != mysd) {
+		if (use_backlog_threads()) {
+			__napi_schedule_irqoff(&sd->backlog);
+			return;
+		}
+
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
 
@@ -6000,7 +6036,7 @@ static void net_rps_action_and_irq_enabl
 #ifdef CONFIG_RPS
 	struct softnet_data *remsd = sd->rps_ipi_list;
 
-	if (remsd) {
+	if (!use_backlog_threads() && remsd) {
 		sd->rps_ipi_list = NULL;
 
 		local_irq_enable();
@@ -6015,7 +6051,7 @@ static void net_rps_action_and_irq_enabl
 static bool sd_has_rps_ipi_waiting(struct softnet_data *sd)
 {
 #ifdef CONFIG_RPS
-	return sd->rps_ipi_list != NULL;
+	return !use_backlog_threads() && sd->rps_ipi_list;
 #else
 	return false;
 #endif
@@ -6059,7 +6095,7 @@ static int process_backlog(struct napi_s
 			 * We can use a plain write instead of clear_bit(),
 			 * and we dont need an smp_mb() memory barrier.
 			 */
-			napi->state = 0;
+			napi->state &= NAPIF_STATE_THREADED;
 			again = false;
 		} else {
 			skb_queue_splice_tail_init(&sd->input_pkt_queue,
@@ -6725,43 +6761,48 @@ static void skb_defer_free_flush(struct
 	}
 }
 
-static int napi_threaded_poll(void *data)
+static void napi_threaded_poll_loop(struct napi_struct *napi)
 {
-	struct napi_struct *napi = data;
 	struct softnet_data *sd;
-	void *have;
+	unsigned long last_qs = jiffies;
 
-	while (!napi_thread_wait(napi)) {
-		unsigned long last_qs = jiffies;
+	for (;;) {
+		bool repoll = false;
+		void *have;
 
-		for (;;) {
-			bool repoll = false;
+		local_bh_disable();
+		sd = this_cpu_ptr(&softnet_data);
+		sd->in_napi_threaded_poll = true;
 
-			local_bh_disable();
-			sd = this_cpu_ptr(&softnet_data);
-			sd->in_napi_threaded_poll = true;
-
-			have = netpoll_poll_lock(napi);
-			__napi_poll(napi, &repoll);
-			netpoll_poll_unlock(have);
-
-			sd->in_napi_threaded_poll = false;
-			barrier();
-
-			if (sd_has_rps_ipi_waiting(sd)) {
-				local_irq_disable();
-				net_rps_action_and_irq_enable(sd);
-			}
-			skb_defer_free_flush(sd);
-			local_bh_enable();
+		have = netpoll_poll_lock(napi);
+		__napi_poll(napi, &repoll);
+		netpoll_poll_unlock(have);
+
+		sd->in_napi_threaded_poll = false;
+		barrier();
+
+		if (sd_has_rps_ipi_waiting(sd)) {
+			local_irq_disable();
+			net_rps_action_and_irq_enable(sd);
+		}
+		skb_defer_free_flush(sd);
+		local_bh_enable();
 
-			if (!repoll)
-				break;
+		if (!repoll)
+			break;
 
-			rcu_softirq_qs_periodic(last_qs);
-			cond_resched();
-		}
+		rcu_softirq_qs_periodic(last_qs);
+		cond_resched();
 	}
+}
+
+static int napi_threaded_poll(void *data)
+{
+	struct napi_struct *napi = data;
+
+	while (!napi_thread_wait(napi))
+		napi_threaded_poll_loop(napi);
+
 	return 0;
 }
 
@@ -11346,7 +11387,7 @@ static int dev_cpu_dead(unsigned int old
 
 		list_del_init(&napi->poll_list);
 		if (napi->poll == process_backlog)
-			napi->state = 0;
+			napi->state &= NAPIF_STATE_THREADED;
 		else
 			____napi_schedule(sd, napi);
 	}
@@ -11354,12 +11395,14 @@ static int dev_cpu_dead(unsigned int old
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_enable();
 
+	if (!use_backlog_threads()) {
 #ifdef CONFIG_RPS
-	remsd = oldsd->rps_ipi_list;
-	oldsd->rps_ipi_list = NULL;
+		remsd = oldsd->rps_ipi_list;
+		oldsd->rps_ipi_list = NULL;
 #endif
-	/* send out pending IPI's on offline CPU */
-	net_rps_send_ipi(remsd);
+		/* send out pending IPI's on offline CPU */
+		net_rps_send_ipi(remsd);
+	}
 
 	/* Process offline CPU's input_pkt_queue */
 	while ((skb = __skb_dequeue(&oldsd->process_queue))) {
@@ -11622,6 +11665,38 @@ static struct pernet_operations __net_in
  *
  */
 
+static int backlog_napi_should_run(unsigned int cpu)
+{
+	struct softnet_data *sd = per_cpu_ptr(&softnet_data, cpu);
+	struct napi_struct *napi = &sd->backlog;
+
+	return test_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
+}
+
+static void run_backlog_napi(unsigned int cpu)
+{
+	struct softnet_data *sd = per_cpu_ptr(&softnet_data, cpu);
+
+	napi_threaded_poll_loop(&sd->backlog);
+}
+
+static void backlog_napi_setup(unsigned int cpu)
+{
+	struct softnet_data *sd = per_cpu_ptr(&softnet_data, cpu);
+	struct napi_struct *napi = &sd->backlog;
+
+	napi->thread = this_cpu_read(backlog_napi);
+	set_bit(NAPI_STATE_THREADED, &napi->state);
+}
+
+static struct smp_hotplug_thread backlog_threads = {
+	.store			= &backlog_napi,
+	.thread_should_run	= backlog_napi_should_run,
+	.thread_fn		= run_backlog_napi,
+	.thread_comm		= "backlog_napi/%u",
+	.setup			= backlog_napi_setup,
+};
+
 /*
  *       This is called single threaded during boot, so no need
  *       to take the rtnl semaphore.
@@ -11672,7 +11747,10 @@ static int __init net_dev_init(void)
 		init_gro_hash(&sd->backlog);
 		sd->backlog.poll = process_backlog;
 		sd->backlog.weight = weight_p;
+		INIT_LIST_HEAD(&sd->backlog.poll_list);
 	}
+	if (use_backlog_threads())
+		smpboot_register_percpu_thread(&backlog_threads);
 
 	dev_boot_phase = 0;
 


