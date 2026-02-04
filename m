Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378F7421EED;
	Wed,  4 Feb 2026 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218577; cv=none; b=kmU4FlYmGs7bWFUQX6N3eLItYnNvoZ7RLYubp26b4U8dMpOLYKjGV6fHP5gOsmtvHuVJnlVhbrVO/TQDz1SziUhKFsdem9kZyO1woPoRVFSwqWBO3Ng7uD1RBn82m7ULCXV9DNBzTxE7sQtrtMLpE9FoAsHnazc7TEj25ieySc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218577; c=relaxed/simple;
	bh=77Sq4oReETXXpdaDYSU06elgCNE3Mm/InQlRD0i4UPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlYUMJ806O324+nSt9M/Imgrj3r2XY7oesrdNoFrQLPWDYpSDHFfl3Anb9Q71HS/+wuWk94W5jdSdfv6Y9lXyLsRNTXo+ZyjTxuU7+BpjX2krt7feyugEwBN5wqUSwc+iq4YVb6vTqxt5OUn4m+PYLt2vMFp4UosnyISL55StE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1Xbt9Kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1Xbt9Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F180C116C6;
	Wed,  4 Feb 2026 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218577;
	bh=77Sq4oReETXXpdaDYSU06elgCNE3Mm/InQlRD0i4UPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1Xbt9Krfh/hNS1+gr7nEv20IeGx6BofBdyBAxdUDtxH6lNWFj5dt3YWk3F9UZa6Y
	 JQ+AZqivAeyTynJv6GyzZ0eyQQGmdxCfxoWYrCKr0ZXgqa0YlFb/UyKAmLF9Rq070D
	 MsnhZJZ6NCwGwP3WWq892vHbtR48BHNo4rqnA4eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.6 70/72] Revert "net: Allow to use SMP threads for backlog NAPI."
Date: Wed,  4 Feb 2026 15:41:13 +0100
Message-ID: <20260204143848.181101080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f3652768a89cfdaedbe2c9384299eea7ec435fef which is
commit dad6b97702639fba27a2bd3e986982ad6f0db3a7 upstream.

It is only for issues around PREEMPT_RT, which is not in the 6.6.y tree,
so revert this for now.

Link: https://lore.kernel.org/r/20260120103833.4kssDD1Y@linutronix.de
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |  152 +++++++++++++--------------------------------------------
 1 file changed, 37 insertions(+), 115 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -78,7 +78,6 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
-#include <linux/smpboot.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/string.h>
@@ -218,31 +217,6 @@ static inline struct hlist_head *dev_ind
 	return &net->dev_index_head[ifindex & (NETDEV_HASHENTRIES - 1)];
 }
 
-#ifndef CONFIG_PREEMPT_RT
-
-static DEFINE_STATIC_KEY_FALSE(use_backlog_threads_key);
-
-static int __init setup_backlog_napi_threads(char *arg)
-{
-	static_branch_enable(&use_backlog_threads_key);
-	return 0;
-}
-early_param("thread_backlog_napi", setup_backlog_napi_threads);
-
-static bool use_backlog_threads(void)
-{
-	return static_branch_unlikely(&use_backlog_threads_key);
-}
-
-#else
-
-static bool use_backlog_threads(void)
-{
-	return true;
-}
-
-#endif
-
 static inline void rps_lock_irqsave(struct softnet_data *sd,
 				    unsigned long *flags)
 {
@@ -4533,7 +4507,6 @@ EXPORT_SYMBOL(__dev_direct_xmit);
 /*************************************************************************
  *			Receiver routines
  *************************************************************************/
-static DEFINE_PER_CPU(struct task_struct *, backlog_napi);
 
 int netdev_max_backlog __read_mostly = 1000;
 EXPORT_SYMBOL(netdev_max_backlog);
@@ -4566,16 +4539,12 @@ static inline void ____napi_schedule(str
 		 */
 		thread = READ_ONCE(napi->thread);
 		if (thread) {
-			if (use_backlog_threads() && thread == raw_cpu_read(backlog_napi))
-				goto use_local_napi;
-
 			set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
 			wake_up_process(thread);
 			return;
 		}
 	}
 
-use_local_napi:
 	list_add_tail(&napi->poll_list, &sd->poll_list);
 	WRITE_ONCE(napi->list_owner, smp_processor_id());
 	/* If not called from net_rx_action()
@@ -4821,11 +4790,6 @@ static void napi_schedule_rps(struct sof
 
 #ifdef CONFIG_RPS
 	if (sd != mysd) {
-		if (use_backlog_threads()) {
-			__napi_schedule_irqoff(&sd->backlog);
-			return;
-		}
-
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
 
@@ -6049,7 +6013,7 @@ static void net_rps_action_and_irq_enabl
 #ifdef CONFIG_RPS
 	struct softnet_data *remsd = sd->rps_ipi_list;
 
-	if (!use_backlog_threads() && remsd) {
+	if (remsd) {
 		sd->rps_ipi_list = NULL;
 
 		local_irq_enable();
@@ -6064,7 +6028,7 @@ static void net_rps_action_and_irq_enabl
 static bool sd_has_rps_ipi_waiting(struct softnet_data *sd)
 {
 #ifdef CONFIG_RPS
-	return !use_backlog_threads() && sd->rps_ipi_list;
+	return sd->rps_ipi_list != NULL;
 #else
 	return false;
 #endif
@@ -6108,7 +6072,7 @@ static int process_backlog(struct napi_s
 			 * We can use a plain write instead of clear_bit(),
 			 * and we dont need an smp_mb() memory barrier.
 			 */
-			napi->state &= NAPIF_STATE_THREADED;
+			napi->state = 0;
 			again = false;
 		} else {
 			skb_queue_splice_tail_init(&sd->input_pkt_queue,
@@ -6774,48 +6738,43 @@ static void skb_defer_free_flush(struct
 	}
 }
 
-static void napi_threaded_poll_loop(struct napi_struct *napi)
+static int napi_threaded_poll(void *data)
 {
+	struct napi_struct *napi = data;
 	struct softnet_data *sd;
-	unsigned long last_qs = jiffies;
+	void *have;
 
-	for (;;) {
-		bool repoll = false;
-		void *have;
+	while (!napi_thread_wait(napi)) {
+		unsigned long last_qs = jiffies;
 
-		local_bh_disable();
-		sd = this_cpu_ptr(&softnet_data);
-		sd->in_napi_threaded_poll = true;
+		for (;;) {
+			bool repoll = false;
 
-		have = netpoll_poll_lock(napi);
-		__napi_poll(napi, &repoll);
-		netpoll_poll_unlock(have);
-
-		sd->in_napi_threaded_poll = false;
-		barrier();
-
-		if (sd_has_rps_ipi_waiting(sd)) {
-			local_irq_disable();
-			net_rps_action_and_irq_enable(sd);
-		}
-		skb_defer_free_flush(sd);
-		local_bh_enable();
+			local_bh_disable();
+			sd = this_cpu_ptr(&softnet_data);
+			sd->in_napi_threaded_poll = true;
+
+			have = netpoll_poll_lock(napi);
+			__napi_poll(napi, &repoll);
+			netpoll_poll_unlock(have);
+
+			sd->in_napi_threaded_poll = false;
+			barrier();
+
+			if (sd_has_rps_ipi_waiting(sd)) {
+				local_irq_disable();
+				net_rps_action_and_irq_enable(sd);
+			}
+			skb_defer_free_flush(sd);
+			local_bh_enable();
 
-		if (!repoll)
-			break;
+			if (!repoll)
+				break;
 
-		rcu_softirq_qs_periodic(last_qs);
-		cond_resched();
+			rcu_softirq_qs_periodic(last_qs);
+			cond_resched();
+		}
 	}
-}
-
-static int napi_threaded_poll(void *data)
-{
-	struct napi_struct *napi = data;
-
-	while (!napi_thread_wait(napi))
-		napi_threaded_poll_loop(napi);
-
 	return 0;
 }
 
@@ -11400,7 +11359,7 @@ static int dev_cpu_dead(unsigned int old
 
 		list_del_init(&napi->poll_list);
 		if (napi->poll == process_backlog)
-			napi->state &= NAPIF_STATE_THREADED;
+			napi->state = 0;
 		else
 			____napi_schedule(sd, napi);
 	}
@@ -11408,14 +11367,12 @@ static int dev_cpu_dead(unsigned int old
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_enable();
 
-	if (!use_backlog_threads()) {
 #ifdef CONFIG_RPS
-		remsd = oldsd->rps_ipi_list;
-		oldsd->rps_ipi_list = NULL;
+	remsd = oldsd->rps_ipi_list;
+	oldsd->rps_ipi_list = NULL;
 #endif
-		/* send out pending IPI's on offline CPU */
-		net_rps_send_ipi(remsd);
-	}
+	/* send out pending IPI's on offline CPU */
+	net_rps_send_ipi(remsd);
 
 	/* Process offline CPU's input_pkt_queue */
 	while ((skb = __skb_dequeue(&oldsd->process_queue))) {
@@ -11678,38 +11635,6 @@ static struct pernet_operations __net_in
  *
  */
 
-static int backlog_napi_should_run(unsigned int cpu)
-{
-	struct softnet_data *sd = per_cpu_ptr(&softnet_data, cpu);
-	struct napi_struct *napi = &sd->backlog;
-
-	return test_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
-}
-
-static void run_backlog_napi(unsigned int cpu)
-{
-	struct softnet_data *sd = per_cpu_ptr(&softnet_data, cpu);
-
-	napi_threaded_poll_loop(&sd->backlog);
-}
-
-static void backlog_napi_setup(unsigned int cpu)
-{
-	struct softnet_data *sd = per_cpu_ptr(&softnet_data, cpu);
-	struct napi_struct *napi = &sd->backlog;
-
-	napi->thread = this_cpu_read(backlog_napi);
-	set_bit(NAPI_STATE_THREADED, &napi->state);
-}
-
-static struct smp_hotplug_thread backlog_threads = {
-	.store			= &backlog_napi,
-	.thread_should_run	= backlog_napi_should_run,
-	.thread_fn		= run_backlog_napi,
-	.thread_comm		= "backlog_napi/%u",
-	.setup			= backlog_napi_setup,
-};
-
 /*
  *       This is called single threaded during boot, so no need
  *       to take the rtnl semaphore.
@@ -11760,10 +11685,7 @@ static int __init net_dev_init(void)
 		init_gro_hash(&sd->backlog);
 		sd->backlog.poll = process_backlog;
 		sd->backlog.weight = weight_p;
-		INIT_LIST_HEAD(&sd->backlog.poll_list);
 	}
-	if (use_backlog_threads())
-		smpboot_register_percpu_thread(&backlog_threads);
 
 	dev_boot_phase = 0;
 


