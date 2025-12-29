Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D5C2F0C46;
	Mon, 29 Dec 2025 16:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025495; cv=none; b=fQKLqhQFwVhD2AfLgBWoNrCUkmgjq+LgYjmsL/JPQBKQTD8wfbpr8O5RzLYy6vKI0camtfjkpegojYhzap2QL5nai6MOS9LlJEWm1r41xJN5pLWRsR4U6CZXY5Zc096JZDX6gYI3lWzM8ON78eXy5XJge6cjkBpzrLCdtFnRUjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025495; c=relaxed/simple;
	bh=i7E17/eYkHTsO+QUjkY3lHb2BY+ICVL3eOntYQy3/IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9OFGEVy4PmwdE7PTNhztum7RaQq4UE04/QQuzEmK/tD7ZMJtkoteCYAmmNaet0hCPKKMj3Ui7x8GCQ+HSivNSwlNZaNobQ1IBhOCcI4EuxIittRPzNVps0b8Wcd+whuBGqilnH8h0apfwSj07lHeEohrP5us84/7aVDmmT11aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stgWhZqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stgWhZqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640D9C4CEF7;
	Mon, 29 Dec 2025 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025494;
	bh=i7E17/eYkHTsO+QUjkY3lHb2BY+ICVL3eOntYQy3/IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stgWhZqm8QLWb1ji8IeJbeYlJSrXnNDcui2OEQH+vBFlRkMQWrcDCyal2UBPoMuay
	 BEJ4hrWeNp1Tk8Repf30tFIpyGJz1IbkrazbAa/Ad2/cMhdT5ZH+GRYzqmk4rBqOmi
	 xmruraU75HoQGa+kkbyP6wcEXnhWKkUHlFZBDf9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sherry Sun <sherry.sun@nxp.com>
Subject: [PATCH 6.18 232/430] printk: Avoid scheduling irq_work on suspend
Date: Mon, 29 Dec 2025 17:10:34 +0100
Message-ID: <20251229160732.890747269@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

commit 26873e3e7f0cb26c45e6ad63656f9fe36b2aa31b upstream.

Allowing irq_work to be scheduled while trying to suspend has shown
to cause problems as some architectures interpret the pending
interrupts as a reason to not suspend. This became a problem for
printk() with the introduction of NBCON consoles. With every
printk() call, NBCON console printing kthreads are woken by queueing
irq_work. This means that irq_work continues to be queued due to
printk() calls late in the suspend procedure.

Avoid this problem by preventing printk() from queueing irq_work
once console suspending has begun. This applies to triggering NBCON
and legacy deferred printing as well as klogd waiters.

Since triggering of NBCON threaded printing relies on irq_work, the
pr_flush() within console_suspend_all() is used to perform the final
flushing before suspending consoles and blocking irq_work queueing.
NBCON consoles that are not suspended (due to the usage of the
"no_console_suspend" boot argument) transition to atomic flushing.

Introduce a new global variable @console_irqwork_blocked to flag
when irq_work queueing is to be avoided. The flag is used by
printk_get_console_flush_type() to avoid allowing deferred printing
and switch NBCON consoles to atomic flushing. It is also used by
vprintk_emit() to avoid klogd waking.

Add WARN_ON_ONCE(console_irqwork_blocked) to the irq_work queuing
functions to catch any code that attempts to queue printk irq_work
during the suspending/resuming procedure.

Cc: stable@vger.kernel.org # 6.13.x because no drivers in 6.12.x
Fixes: 6b93bb41f6ea ("printk: Add non-BKL (nbcon) console basic infrastructure")
Closes: https://lore.kernel.org/lkml/DB9PR04MB8429E7DDF2D93C2695DE401D92C4A@DB9PR04MB8429.eurprd04.prod.outlook.com
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://patch.msgid.link/20251113160351.113031-3-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/printk/internal.h |    8 ++++--
 kernel/printk/nbcon.c    |    7 +++++
 kernel/printk/printk.c   |   58 ++++++++++++++++++++++++++++++++++-------------
 3 files changed, 55 insertions(+), 18 deletions(-)

--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -230,6 +230,8 @@ struct console_flush_type {
 	bool	legacy_offload;
 };
 
+extern bool console_irqwork_blocked;
+
 /*
  * Identify which console flushing methods should be used in the context of
  * the caller.
@@ -241,7 +243,7 @@ static inline void printk_get_console_fl
 	switch (nbcon_get_default_prio()) {
 	case NBCON_PRIO_NORMAL:
 		if (have_nbcon_console && !have_boot_console) {
-			if (printk_kthreads_running)
+			if (printk_kthreads_running && !console_irqwork_blocked)
 				ft->nbcon_offload = true;
 			else
 				ft->nbcon_atomic = true;
@@ -251,7 +253,7 @@ static inline void printk_get_console_fl
 		if (have_legacy_console || have_boot_console) {
 			if (!is_printk_legacy_deferred())
 				ft->legacy_direct = true;
-			else
+			else if (!console_irqwork_blocked)
 				ft->legacy_offload = true;
 		}
 		break;
@@ -264,7 +266,7 @@ static inline void printk_get_console_fl
 		if (have_legacy_console || have_boot_console) {
 			if (!is_printk_legacy_deferred())
 				ft->legacy_direct = true;
-			else
+			else if (!console_irqwork_blocked)
 				ft->legacy_offload = true;
 		}
 		break;
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1276,6 +1276,13 @@ void nbcon_kthreads_wake(void)
 	if (!printk_kthreads_running)
 		return;
 
+	/*
+	 * It is not allowed to call this function when console irq_work
+	 * is blocked.
+	 */
+	if (WARN_ON_ONCE(console_irqwork_blocked))
+		return;
+
 	cookie = console_srcu_read_lock();
 	for_each_console_srcu(con) {
 		if (!(console_srcu_read_flags(con) & CON_NBCON))
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -462,6 +462,9 @@ bool have_boot_console;
 /* See printk_legacy_allow_panic_sync() for details. */
 bool legacy_allow_panic_sync;
 
+/* Avoid using irq_work when suspending. */
+bool console_irqwork_blocked;
+
 #ifdef CONFIG_PRINTK
 DECLARE_WAIT_QUEUE_HEAD(log_wait);
 static DECLARE_WAIT_QUEUE_HEAD(legacy_wait);
@@ -2426,7 +2429,7 @@ asmlinkage int vprintk_emit(int facility
 
 	if (ft.legacy_offload)
 		defer_console_output();
-	else
+	else if (!console_irqwork_blocked)
 		wake_up_klogd();
 
 	return printed_len;
@@ -2730,10 +2733,20 @@ void console_suspend_all(void)
 {
 	struct console *con;
 
+	if (console_suspend_enabled)
+		pr_info("Suspending console(s) (use no_console_suspend to debug)\n");
+
+	/*
+	 * Flush any console backlog and then avoid queueing irq_work until
+	 * console_resume_all(). Until then deferred printing is no longer
+	 * triggered, NBCON consoles transition to atomic flushing, and
+	 * any klogd waiters are not triggered.
+	 */
+	pr_flush(1000, true);
+	console_irqwork_blocked = true;
+
 	if (!console_suspend_enabled)
 		return;
-	pr_info("Suspending console(s) (use no_console_suspend to debug)\n");
-	pr_flush(1000, true);
 
 	console_list_lock();
 	for_each_console(con)
@@ -2754,26 +2767,34 @@ void console_resume_all(void)
 	struct console_flush_type ft;
 	struct console *con;
 
-	if (!console_suspend_enabled)
-		return;
-
-	console_list_lock();
-	for_each_console(con)
-		console_srcu_write_flags(con, con->flags & ~CON_SUSPENDED);
-	console_list_unlock();
-
 	/*
-	 * Ensure that all SRCU list walks have completed. All printing
-	 * contexts must be able to see they are no longer suspended so
-	 * that they are guaranteed to wake up and resume printing.
+	 * Allow queueing irq_work. After restoring console state, deferred
+	 * printing and any klogd waiters need to be triggered in case there
+	 * is now a console backlog.
 	 */
-	synchronize_srcu(&console_srcu);
+	console_irqwork_blocked = false;
+
+	if (console_suspend_enabled) {
+		console_list_lock();
+		for_each_console(con)
+			console_srcu_write_flags(con, con->flags & ~CON_SUSPENDED);
+		console_list_unlock();
+
+		/*
+		 * Ensure that all SRCU list walks have completed. All printing
+		 * contexts must be able to see they are no longer suspended so
+		 * that they are guaranteed to wake up and resume printing.
+		 */
+		synchronize_srcu(&console_srcu);
+	}
 
 	printk_get_console_flush_type(&ft);
 	if (ft.nbcon_offload)
 		nbcon_kthreads_wake();
 	if (ft.legacy_offload)
 		defer_console_output();
+	else
+		wake_up_klogd();
 
 	pr_flush(1000, true);
 }
@@ -4511,6 +4532,13 @@ static void __wake_up_klogd(int val)
 	if (!printk_percpu_data_ready())
 		return;
 
+	/*
+	 * It is not allowed to call this function when console irq_work
+	 * is blocked.
+	 */
+	if (WARN_ON_ONCE(console_irqwork_blocked))
+		return;
+
 	preempt_disable();
 	/*
 	 * Guarantee any new records can be seen by tasks preparing to wait


