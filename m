Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA37208BB
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747EAC433CA;
	Wed, 20 Sep 2023 11:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210654;
	bh=qHO0HX9tfEgjznSU8AiSAdEcVJyet80SRSypOr0Q/HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdXUAfASItVGgZYsENdrQOd+UZR/xVzUlyLH88YVlLDDIuxNX7jBYDwwpF7Ys0xnf
	 PohlvFkW7eoDfQYhtTpM9bQZru7tizuL21tCxxJAKI8kHva22eFcHgSaxGKlFnuAK9
	 pdMJZ+cH31JebqsyZQMlMsTv0KRdPuTb+MEheZQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 129/211] printk: Keep non-panic-CPUs out of console lock
Date: Wed, 20 Sep 2023 13:29:33 +0200
Message-ID: <20230920112849.813436213@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 51a1d258e50e03a0216bf42b6af9ff34ec402ac1 ]

When in a panic situation, non-panic CPUs should avoid holding the
console lock so as not to contend with the panic CPU. This is already
implemented with abandon_console_lock_in_panic(), which is checked
after each printed line. However, non-panic CPUs should also avoid
trying to acquire the console lock during a panic.

Modify console_trylock() to fail and console_lock() to block() when
called from a non-panic CPU during a panic.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20230717194607.145135-4-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 45 ++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7d3f30eb35862..591c11888200d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2585,6 +2585,25 @@ static int console_cpu_notify(unsigned int cpu)
 	return 0;
 }
 
+/*
+ * Return true when this CPU should unlock console_sem without pushing all
+ * messages to the console. This reduces the chance that the console is
+ * locked when the panic CPU tries to use it.
+ */
+static bool abandon_console_lock_in_panic(void)
+{
+	if (!panic_in_progress())
+		return false;
+
+	/*
+	 * We can use raw_smp_processor_id() here because it is impossible for
+	 * the task to be migrated to the panic_cpu, or away from it. If
+	 * panic_cpu has already been set, and we're not currently executing on
+	 * that CPU, then we never will be.
+	 */
+	return atomic_read(&panic_cpu) != raw_smp_processor_id();
+}
+
 /**
  * console_lock - block the console subsystem from printing
  *
@@ -2597,6 +2616,10 @@ void console_lock(void)
 {
 	might_sleep();
 
+	/* On panic, the console_lock must be left to the panic cpu. */
+	while (abandon_console_lock_in_panic())
+		msleep(1000);
+
 	down_console_sem();
 	if (console_suspended)
 		return;
@@ -2615,6 +2638,9 @@ EXPORT_SYMBOL(console_lock);
  */
 int console_trylock(void)
 {
+	/* On panic, the console_lock must be left to the panic cpu. */
+	if (abandon_console_lock_in_panic())
+		return 0;
 	if (down_trylock_console_sem())
 		return 0;
 	if (console_suspended) {
@@ -2633,25 +2659,6 @@ int is_console_locked(void)
 }
 EXPORT_SYMBOL(is_console_locked);
 
-/*
- * Return true when this CPU should unlock console_sem without pushing all
- * messages to the console. This reduces the chance that the console is
- * locked when the panic CPU tries to use it.
- */
-static bool abandon_console_lock_in_panic(void)
-{
-	if (!panic_in_progress())
-		return false;
-
-	/*
-	 * We can use raw_smp_processor_id() here because it is impossible for
-	 * the task to be migrated to the panic_cpu, or away from it. If
-	 * panic_cpu has already been set, and we're not currently executing on
-	 * that CPU, then we never will be.
-	 */
-	return atomic_read(&panic_cpu) != raw_smp_processor_id();
-}
-
 /*
  * Check if the given console is currently capable and allowed to print
  * records.
-- 
2.40.1



