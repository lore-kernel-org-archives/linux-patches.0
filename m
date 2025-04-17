Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B433225743F;
	Thu, 17 Apr 2025 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914034; cv=none; b=GbFmIKRhG7d53LxehEFi8tdlYgHco1b0Ts8JFyO3j1BkBsMktvweSfqBZcwMXMzIetJzClPnOvb8U7GoJAAlmjVwhVoFggTtx7cQ4QJyku3q8uuic6q+F4Vbr/xOYbH/GeSnTuRleb7T3zBeU9dXcmcnrUXAHpEQhg9CVhYjO8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914034; c=relaxed/simple;
	bh=KGcgsY9Rm/zrRi3q9zF5YgJQVdZjGibLWJNW4Y8NoSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKi/kpXFeV29K0ggQp6GSlnxnF3O8YtYePJHMkpX4fTX+0ofPih1rcdDnUyKdkX2soPzasb5ay2h/p55T4I9phIVPbA0vdprsCb9w79wH3cG9FsHadvjaKDCHnzEJnngxomoTuno1B3WLaKfp4T50VTMznm1vy18A8hopppqhtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQZqAeYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQZqAeYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BB6C4CEE7;
	Thu, 17 Apr 2025 18:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914034;
	bh=KGcgsY9Rm/zrRi3q9zF5YgJQVdZjGibLWJNW4Y8NoSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQZqAeYF6EfZCY0avFs7U1XG5jCM7aGmjbZcmSMyxDgphnvAswswimupFhWbu2p1h
	 lqX2ccNv49MSYwUTKOpoAkI7EXoqKfd8lCbRqnZC7z7xzMv1RAIcoXcmFmrh8XzhPf
	 UWJIEUcv5RIqUdLbFh+A5mF5IlQQwlmv1pbV5rJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 054/414] Flush console log from kernel_power_off()
Date: Thu, 17 Apr 2025 19:46:52 +0200
Message-ID: <20250417175113.584547534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 6ea9a1781c70a8be1fcdc49134fc1bf4baba8bca ]

Kernels built with CONFIG_PREEMPT_RT=y can lose significant console output
and shutdown time, which hides shutdown-time RCU issues from rcutorture.
Therefore, make pr_flush() public and invoke it after then last print
in kernel_power_off().

[ paulmck: Apply John Ogness feedback. ]
[ paulmck: Appy Sebastian Andrzej Siewior feedback. ]
[ paulmck: Apply kernel test robot feedback. ]

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://lore.kernel.org/r/5f743488-dc2a-4f19-bdda-cf50b9314832@paulmck-laptop
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/printk.h | 6 ++++++
 kernel/printk/printk.c | 4 +---
 kernel/reboot.c        | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 4217a9f412b26..5b462029d03c1 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -207,6 +207,7 @@ void printk_legacy_allow_panic_sync(void);
 extern bool nbcon_device_try_acquire(struct console *con);
 extern void nbcon_device_release(struct console *con);
 void nbcon_atomic_flush_unsafe(void);
+bool pr_flush(int timeout_ms, bool reset_on_progress);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -315,6 +316,11 @@ static inline void nbcon_atomic_flush_unsafe(void)
 {
 }
 
+static inline bool pr_flush(int timeout_ms, bool reset_on_progress)
+{
+	return true;
+}
+
 #endif
 
 bool this_cpu_in_panic(void);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 07668433644b8..057db78876cd9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2461,7 +2461,6 @@ asmlinkage __visible int _printk(const char *fmt, ...)
 }
 EXPORT_SYMBOL(_printk);
 
-static bool pr_flush(int timeout_ms, bool reset_on_progress);
 static bool __pr_flush(struct console *con, int timeout_ms, bool reset_on_progress);
 
 #else /* CONFIG_PRINTK */
@@ -2474,7 +2473,6 @@ static bool __pr_flush(struct console *con, int timeout_ms, bool reset_on_progre
 
 static u64 syslog_seq;
 
-static bool pr_flush(int timeout_ms, bool reset_on_progress) { return true; }
 static bool __pr_flush(struct console *con, int timeout_ms, bool reset_on_progress) { return true; }
 
 #endif /* CONFIG_PRINTK */
@@ -4466,7 +4464,7 @@ static bool __pr_flush(struct console *con, int timeout_ms, bool reset_on_progre
  * Context: Process context. May sleep while acquiring console lock.
  * Return: true if all usable printers are caught up.
  */
-static bool pr_flush(int timeout_ms, bool reset_on_progress)
+bool pr_flush(int timeout_ms, bool reset_on_progress)
 {
 	return __pr_flush(NULL, timeout_ms, reset_on_progress);
 }
diff --git a/kernel/reboot.c b/kernel/reboot.c
index a701000bab347..3ba15b2c40662 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -704,6 +704,7 @@ void kernel_power_off(void)
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	pr_emerg("Power down\n");
+	pr_flush(1000, true);
 	kmsg_dump(KMSG_DUMP_SHUTDOWN);
 	machine_power_off();
 }
-- 
2.39.5



