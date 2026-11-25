Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624540;
	b=DGUDnCiutfvouzv8ARbDmOj+NAnbsrC6QTwn9IikiGYsXTTR7glvdKLnhjsK3o09OZi7
	 3+bx2oC4IirDmi6VZ2PVXSF6aadJflscANosbCXM3r3jRP0KKH+7pz9+4QLqsi56WjCMC
	 B8vhm7NhobvpdHNE6R4BEsNVCIr019kp1rdXVFTeM9HOLIOIQ6bgA6Tm61BYRtpdVvxzm
	 0e4Pc5n0lEN3KMq+Z28a9zGDgn0gUho32BKRowU2yit5fCnl1Q3x/UWI0BJ0ICWsszUS1
	 3TnGSevkXJbBv3PS4f3xp1QrwWLtJTVSIcYQUn3bhrxRNz0YHA0s7v336NcfoIeJSaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQ92GUtVAu27MvehhAkPcdTGk2tsbEdRtj0NsAu+Tdc=;
	b=CP9aMJShelA99PLjiuMU+6jAH2fk08sJYlk5tJ0ZOTNW7uupqi3rV3dPim5dGCsGe2GK
	 I99CqTutDh7DHFc+1HP+0fopOMnIk69ooCMVgAk+CE/w5DuxXZPKD2Z5bTAJIJxQaE8sb
	 hzqVtu1QlrCbdRCvCsyT2Sl7+jQk7InsNeqyLjQDf+EJYki1Gsr5CamTqoBn6CVYfuGu0
	 uTToxHADqeJAOOJ43kaon9+HTHF0+R/6KRDVVxj9ZY2aXxUzk3tPkT126eKtTt3qi5nDS
	 bRWvB4s4frzE9e9RxKefTpWQkTIcR6W6sPf5dXTPegmgiEvke7ZeztLi8dHFVxAe5TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrXU0Usl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7FE606A332;
	Wed, 25 Nov 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrXU0Usl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BE61F000C6;
	Wed, 25 Nov 2026 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624540;
	bh=hQ92GUtVAu27MvehhAkPcdTGk2tsbEdRtj0NsAu+Tdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrXU0UslmNIQ6CfPpN+tPZsbCaOWQOBfKEY1UZYYS8ZOm1THQwS8YJlN9YIsZJ2+D
	 AHIVchXR4vNYE9ol1xW5fApPlMsb5Se6dTcfy/163GFq1fJvZCnJ3MS/E0ADUl7fz2
	 ZaXqJouhNiUwgXUY/+J4yMbbXfTp+hO1JMeslpDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Cobb <mcobb@thegoodpenguin.co.uk>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/816] printk: Allow to use the printk kthread immediately even for 1st nbcon
Date: Wed, 25 Nov 2026 15:28:49 +0100
Message-ID: <20261125143853.382706159@linuxfoundation.org>
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

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit cf5543870186d6f99b631faaeca27beaa996d52f ]

The kthreads for nbcon consoles are created by nbcon_alloc() at
the beginning of the console registration. But it currently works
only for the 2nd or later nbcon console because the code checks
@printk_kthreads_running.

The kthread for the 1st registered nbcon console is created at the very
end of register_console() by printk_kthreads_check_locked(). As a result,
the entire log is replayed synchronously when the "enabled" message
gets printed. It might block the boot for a long time with a slow serial
console.

Prevent the synchronous flush by creating the kthread even for the 1st
nbcon console when it is safe (kthreads ready and no boot consoles).

Also inform printk() to use the kthread by setting
@printk_kthreads_running. Note that the kthreads already must be
running when it is safe and this is not the 1st nbcon console.

Symmetrically, clear @printk_kthreads_running when the last nbcon
console was unregistered by nbcon_free(). This requires updating
@have_nbcon_console before nbcon_free() gets called.

Note that there is _no_ problem when the 1st nbcon console replaces boot
consoles. In this case, the kthread will be started at the end
of registration after the boot consoles are removed. But the console
does not reply the entire log buffer in this case. Note that
the flag CON_PRINTBUFFER is always cleared when the boot consoles are
removed and vice versa.

Closes: https://lore.kernel.org/r/20250514173514.2117832-1-mcobb@thegoodpenguin.co.uk
Tested-by: Michael Cobb <mcobb@thegoodpenguin.co.uk>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20250604142045.253301-1-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Stable-dep-of: 8a7f26aa072a ("printk: Avoid multiple unregistration in unregister_console_locked()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/internal.h |  2 ++
 kernel/printk/nbcon.c    | 26 ++++++++++++++++++++++++--
 kernel/printk/printk.c   | 20 +++++++++++---------
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index 53c4b3438a1c6..5dffc4f53e665 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -62,6 +62,7 @@ struct dev_printk_info;
 
 extern struct printk_ringbuffer *prb;
 extern bool printk_kthreads_running;
+extern bool printk_kthreads_ready;
 extern bool debug_non_panic_cpus;
 
 __printf(4, 0)
@@ -177,6 +178,7 @@ static inline void nbcon_kthread_wake(struct console *con)
 #define PRINTKRB_RECORD_MAX	0
 
 #define printk_kthreads_running (false)
+#define printk_kthreads_ready (false)
 
 /*
  * In !PRINTK builds we still export console_sem
diff --git a/kernel/printk/nbcon.c b/kernel/printk/nbcon.c
index a947b1a75cce3..8cee780155c2e 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1690,6 +1690,9 @@ bool nbcon_alloc(struct console *con)
 {
 	struct nbcon_state state = { };
 
+	/* Synchronize the kthread start. */
+	lockdep_assert_console_list_lock_held();
+
 	/* The write_thread() callback is mandatory. */
 	if (WARN_ON(!con->write_thread))
 		return false;
@@ -1720,12 +1723,15 @@ bool nbcon_alloc(struct console *con)
 			return false;
 		}
 
-		if (printk_kthreads_running) {
+		if (printk_kthreads_ready && !have_boot_console) {
 			if (!nbcon_kthread_create(con)) {
 				kfree(con->pbufs);
 				con->pbufs = NULL;
 				return false;
 			}
+
+			/* Might be the first kthread. */
+			printk_kthreads_running = true;
 		}
 	}
 
@@ -1735,14 +1741,30 @@ bool nbcon_alloc(struct console *con)
 /**
  * nbcon_free - Free and cleanup the nbcon console specific data
  * @con:	Console to free/cleanup nbcon data
+ *
+ * Important: @have_nbcon_console must be updated before calling
+ *	this function. In particular, it can be set only when there
+ *	is still another nbcon console registered.
  */
 void nbcon_free(struct console *con)
 {
 	struct nbcon_state state = { };
 
-	if (printk_kthreads_running)
+	/* Synchronize the kthread stop. */
+	lockdep_assert_console_list_lock_held();
+
+	if (printk_kthreads_running) {
 		nbcon_kthread_stop(con);
 
+		/* Might be the last nbcon console.
+		 *
+		 * Do not rely on printk_kthreads_check_locked(). It is not
+		 * called in some code paths, see nbcon_free() callers.
+		 */
+		if (!have_nbcon_console)
+			printk_kthreads_running = false;
+	}
+
 	nbcon_state_set(con, &state);
 
 	/* Boot consoles share global printk buffers. */
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 72845f87089b6..def877601a867 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3564,7 +3564,7 @@ EXPORT_SYMBOL(console_start);
 static int unregister_console_locked(struct console *console);
 
 /* True when system boot is far enough to create printer threads. */
-static bool printk_kthreads_ready __ro_after_init;
+bool printk_kthreads_ready __ro_after_init;
 
 static struct task_struct *printk_legacy_kthread;
 
@@ -3708,6 +3708,7 @@ static void printk_kthreads_check_locked(void)
 	if (!printk_kthreads_ready)
 		return;
 
+	/* Start or stop the legacy kthread when needed. */
 	if (have_legacy_console || have_boot_console) {
 		if (!printk_legacy_kthread &&
 		    force_legacy_kthread() &&
@@ -4199,14 +4200,6 @@ static int unregister_console_locked(struct console *console)
 	 */
 	synchronize_srcu(&console_srcu);
 
-	if (console->flags & CON_NBCON)
-		nbcon_free(console);
-
-	console_sysfs_notify();
-
-	if (console->exit)
-		res = console->exit(console);
-
 	/*
 	 * With this console gone, the global flags tracking registered
 	 * console types may have changed. Update them.
@@ -4227,6 +4220,15 @@ static int unregister_console_locked(struct console *console)
 	if (!found_nbcon_con)
 		have_nbcon_console = found_nbcon_con;
 
+	/* @have_nbcon_console must be updated before calling nbcon_free(). */
+	if (console->flags & CON_NBCON)
+		nbcon_free(console);
+
+	console_sysfs_notify();
+
+	if (console->exit)
+		res = console->exit(console);
+
 	/* Changed console list, may require printer threads to start/stop. */
 	printk_kthreads_check_locked();
 
-- 
2.53.0



