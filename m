Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5832576;
	Mon,  2 Jun 2025 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874777; cv=none; b=b1Jp0hO5Y7oEHHYkIi0znpfdYcDJ9KNEy0hFQoL8CeElESEsjDwreyVYMwj+4lBRzxV8d+VxIVBAmYi2kQI52fOLs8O58WjMRbYLPjn4tstaaU30Q+qw8vomM29RxZU+YQ/IKjQB4/ZFjOoER01PHI2pcrsZCVxId99SbTQEbis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874777; c=relaxed/simple;
	bh=zl+IX5nsaPAaYxsCohKPD6ddFX5ZCqDOnIyuVfhBej8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUyfBDAcrUEaCeQWvbYzt5hd7JLCCJMn1++bWa4fAdToWNmB77q71fQZBLuW777Uj490UFEzINFZJ7pWg0lZhCsc7Vl7LMbaGokrnoZYsjQY4AMFvntqqUibCYQiCf6/TgouSA8Uy7U21rm0GFnW4SsHOfFn3bWvlZud0wkZMKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuWa4Si4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuWa4Si4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D00BC4CEEB;
	Mon,  2 Jun 2025 14:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874776;
	bh=zl+IX5nsaPAaYxsCohKPD6ddFX5ZCqDOnIyuVfhBej8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuWa4Si4hVODM4Fa1vvH/Qrp8dz9dUmG7RKj0psRz+tYicZzQ/fxeJeN2S2qJwRlX
	 nke/2h/sCtKr3eWnox8HByqgUXzvh+qzxnNxG5olafGItl1pRgNSRmEr2ylOxODbuh
	 CVkqy8V8wL5wZVvHjvK3XcnYnbSq3iNq5pF9zE24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/204] x86/nmi: Add an emergency handler in nmi_desc & use it in nmi_shootdown_cpus()
Date: Mon,  2 Jun 2025 15:47:45 +0200
Message-ID: <20250602134300.839405842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit fe37c699ae3eed6e02ee55fbf5cb9ceb7fcfd76c ]

Depending on the type of panics, it was found that the
__register_nmi_handler() function can be called in NMI context from
nmi_shootdown_cpus() leading to a lockdep splat:

  WARNING: inconsistent lock state
  inconsistent {INITIAL USE} -> {IN-NMI} usage.

   lock(&nmi_desc[0].lock);
   <Interrupt>
     lock(&nmi_desc[0].lock);

  Call Trace:
    _raw_spin_lock_irqsave
    __register_nmi_handler
    nmi_shootdown_cpus
    kdump_nmi_shootdown_cpus
    native_machine_crash_shutdown
    __crash_kexec

In this particular case, the following panic message was printed before:

  Kernel panic - not syncing: Fatal hardware error!

This message seemed to be given out from __ghes_panic() running in
NMI context.

The __register_nmi_handler() function which takes the nmi_desc lock
with irq disabled shouldn't be called from NMI context as this can
lead to deadlock.

The nmi_shootdown_cpus() function can only be invoked once. After the
first invocation, all other CPUs should be stuck in the newly added
crash_nmi_callback() and cannot respond to a second NMI.

Fix it by adding a new emergency NMI handler to the nmi_desc
structure and provide a new set_emergency_nmi_handler() helper to set
crash_nmi_callback() in any context. The new emergency handler will
preempt other handlers in the linked list. That will eliminate the need
to take any lock and serve the panic in NMI use case.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250206191844.131700-1-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/nmi.h |  2 ++
 arch/x86/kernel/nmi.c      | 42 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/reboot.c   | 10 +++------
 3 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 9d5d949e662e1..dfb483c8c98b6 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -59,6 +59,8 @@ int __register_nmi_handler(unsigned int, struct nmiaction *);
 
 void unregister_nmi_handler(unsigned int, const char *);
 
+void set_emergency_nmi_handler(unsigned int type, nmi_handler_t handler);
+
 void stop_nmi(void);
 void restart_nmi(void);
 void local_touch_nmi(void);
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 5bb001c0c771a..d5c572bca8b1b 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -41,8 +41,12 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
 
+/*
+ * An emergency handler can be set in any context including NMI
+ */
 struct nmi_desc {
 	raw_spinlock_t lock;
+	nmi_handler_t emerg_handler;
 	struct list_head head;
 };
 
@@ -124,9 +128,22 @@ static void nmi_check_duration(struct nmiaction *action, u64 duration)
 static int nmi_handle(unsigned int type, struct pt_regs *regs)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
+	nmi_handler_t ehandler;
 	struct nmiaction *a;
 	int handled=0;
 
+	/*
+	 * Call the emergency handler, if set
+	 *
+	 * In the case of crash_nmi_callback() emergency handler, it will
+	 * return in the case of the crashing CPU to enable it to complete
+	 * other necessary crashing actions ASAP. Other handlers in the
+	 * linked list won't need to be run.
+	 */
+	ehandler = desc->emerg_handler;
+	if (ehandler)
+		return ehandler(type, regs);
+
 	rcu_read_lock();
 
 	/*
@@ -212,6 +229,31 @@ void unregister_nmi_handler(unsigned int type, const char *name)
 }
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
+/**
+ * set_emergency_nmi_handler - Set emergency handler
+ * @type:    NMI type
+ * @handler: the emergency handler to be stored
+ *
+ * Set an emergency NMI handler which, if set, will preempt all the other
+ * handlers in the linked list. If a NULL handler is passed in, it will clear
+ * it. It is expected that concurrent calls to this function will not happen
+ * or the system is screwed beyond repair.
+ */
+void set_emergency_nmi_handler(unsigned int type, nmi_handler_t handler)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+
+	if (WARN_ON_ONCE(desc->emerg_handler == handler))
+		return;
+	desc->emerg_handler = handler;
+
+	/*
+	 * Ensure the emergency handler is visible to other CPUs before
+	 * function return
+	 */
+	smp_wmb();
+}
+
 static void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 6fede2f001042..17e378db513d2 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -875,15 +875,11 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	shootdown_callback = callback;
 
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
-	/* Would it be better to replace the trap vector here? */
-	if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
-				 NMI_FLAG_FIRST, "crash"))
-		return;		/* Return what? */
+
 	/*
-	 * Ensure the new callback function is set before sending
-	 * out the NMI
+	 * Set emergency handler to preempt other handlers.
 	 */
-	wmb();
+	set_emergency_nmi_handler(NMI_LOCAL, crash_nmi_callback);
 
 	apic_send_IPI_allbutself(NMI_VECTOR);
 
-- 
2.39.5



