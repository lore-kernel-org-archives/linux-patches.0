Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D118D25335A;
	Thu, 17 Apr 2025 18:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915336; cv=none; b=NTdFgceN1t/po8aPs+ZMtchB0ex1jx+fFE+e1j5qWM2EEAVnyVJ9AyUEoyI3LYu+gn4O/i8ne6ytPDxkHx/BV4cj6MjM/iBLwBDeuw3T3HhDddZgtYXqc/t+PUbeto95xmtQCBYjC4BvACxdXBDlou1GlyFtlO5R6UN8TAfmigI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915336; c=relaxed/simple;
	bh=wVs5Tug8IwHp5IA5G4x0/MTv5d9ujipzCjehYYYhTVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH4w/YqSYCt+EeNZBAGYIODx17rBOzGz/ECwzaOPXJJPhp5hcyIkOP+ENQko4va0+Rzx2BGdt7oiD+i4WO+ub7tkDbg4Fgsm8b6mZhhNgJuaGQ/pVjJ5gmp4iISQo5lbFhHI3m62yzsN+sWmJZPxeyGOioS7WOZASsKNFG1BMkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7wHeuKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7wHeuKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E96C4CEE4;
	Thu, 17 Apr 2025 18:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915336;
	bh=wVs5Tug8IwHp5IA5G4x0/MTv5d9ujipzCjehYYYhTVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7wHeuKwTDtqK/Fbb/TZ7rFnb56JTiW+H9yC4C6/GrkYKHSH2DqPPqR2ry5G6zwat
	 Os0g75aROtJLWoVIXuBbGcrTfIJfP2MR6pqTFtJOiEHEOtVVKLW1crFk4XzFp4cB4y
	 O/vTsRZLIL1cPWfOj7A1w+nXRTRrKjRh9nNMvFGg=
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
Subject: [PATCH 6.12 055/393] Flush console log from kernel_power_off()
Date: Thu, 17 Apr 2025 19:47:44 +0200
Message-ID: <20250417175109.800339695@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eca9bb2ee637b..0cb647ecd77f5 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -204,6 +204,7 @@ void printk_legacy_allow_panic_sync(void);
 extern bool nbcon_device_try_acquire(struct console *con);
 extern void nbcon_device_release(struct console *con);
 void nbcon_atomic_flush_unsafe(void);
+bool pr_flush(int timeout_ms, bool reset_on_progress);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -304,6 +305,11 @@ static inline void nbcon_atomic_flush_unsafe(void)
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
index 3b75f6e8410b9..881a26e18c658 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2436,7 +2436,6 @@ asmlinkage __visible int _printk(const char *fmt, ...)
 }
 EXPORT_SYMBOL(_printk);
 
-static bool pr_flush(int timeout_ms, bool reset_on_progress);
 static bool __pr_flush(struct console *con, int timeout_ms, bool reset_on_progress);
 
 #else /* CONFIG_PRINTK */
@@ -2449,7 +2448,6 @@ static bool __pr_flush(struct console *con, int timeout_ms, bool reset_on_progre
 
 static u64 syslog_seq;
 
-static bool pr_flush(int timeout_ms, bool reset_on_progress) { return true; }
 static bool __pr_flush(struct console *con, int timeout_ms, bool reset_on_progress) { return true; }
 
 #endif /* CONFIG_PRINTK */
@@ -4436,7 +4434,7 @@ static bool __pr_flush(struct console *con, int timeout_ms, bool reset_on_progre
  * Context: Process context. May sleep while acquiring console lock.
  * Return: true if all usable printers are caught up.
  */
-static bool pr_flush(int timeout_ms, bool reset_on_progress)
+bool pr_flush(int timeout_ms, bool reset_on_progress)
 {
 	return __pr_flush(NULL, timeout_ms, reset_on_progress);
 }
diff --git a/kernel/reboot.c b/kernel/reboot.c
index f05dbde2c93fe..d6ee090eda943 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -697,6 +697,7 @@ void kernel_power_off(void)
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	pr_emerg("Power down\n");
+	pr_flush(1000, true);
 	kmsg_dump(KMSG_DUMP_SHUTDOWN);
 	machine_power_off();
 }
-- 
2.39.5



