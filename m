Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0FE2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FFDC433D2;
	Sun, 22 Jan 2023 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401216;
	bh=11CZXW0Y8V6fCu4Lsv8FaoLlw3NHkqlgRT1xk2vmROk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiVNOgoQsrOyTiT4gnp2zhJiVuZ5WdsWgAE3+Rre36yJXsJQGeXonn398pq00etx5
	 XFU1dIX9X83hlF/XIH/xGUi6TnB1ITRwMDeReWq3+bkPE5Ebr9LPTP7N/uBsKinDmp
	 3RWcarIkWwr4qzAjuqRihalOzaankItsrRTZUFLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Gow <davidgow@google.com>,
	tangmeng <tangmeng@uniontech.com>,
	Jann Horn <jannh@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Petr Mladek <pmladek@suse.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 154/193] panic: Consolidate open-coded panic_on_warn checks
Date: Sun, 22 Jan 2023 16:04:43 +0100
Message-Id: <20230122150253.432742379@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

commit 79cc1ba7badf9e7a12af99695a557e9ce27ee967 upstream.

Several run-time checkers (KASAN, UBSAN, KFENCE, KCSAN, sched) roll
their own warnings, and each check "panic_on_warn". Consolidate this
into a single function so that future instrumentation can be added in
a single location.

Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Gow <davidgow@google.com>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20221117234328.594699-4-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/panic.h |    1 +
 kernel/kcsan/report.c |    3 +--
 kernel/panic.c        |    9 +++++++--
 kernel/sched/core.c   |    3 +--
 lib/ubsan.c           |    3 +--
 mm/kasan/report.c     |    4 ++--
 mm/kfence/report.c    |    3 +--
 7 files changed, 14 insertions(+), 12 deletions(-)

--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -11,6 +11,7 @@ extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...) __noreturn __cold;
 void nmi_panic(struct pt_regs *regs, const char *msg);
+void check_panic_on_warn(const char *origin);
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern bool oops_may_print(void);
--- a/kernel/kcsan/report.c
+++ b/kernel/kcsan/report.c
@@ -492,8 +492,7 @@ static void print_report(enum kcsan_valu
 	dump_stack_print_info(KERN_DEFAULT);
 	pr_err("==================================================================\n");
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("KCSAN");
 }
 
 static void release_report(unsigned long *flags, struct other_info *other_info)
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -201,6 +201,12 @@ static void panic_print_sys_info(bool co
 		ftrace_dump(DUMP_ALL);
 }
 
+void check_panic_on_warn(const char *origin)
+{
+	if (panic_on_warn)
+		panic("%s: panic_on_warn set ...\n", origin);
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -619,8 +625,7 @@ void __warn(const char *file, int line,
 	if (regs)
 		show_regs(regs);
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("kernel");
 
 	if (!regs)
 		dump_stack();
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5778,8 +5778,7 @@ static noinline void __schedule_bug(stru
 		pr_err("Preemption disabled at:");
 		print_ip_sym(KERN_ERR, preempt_disable_ip);
 	}
-	if (panic_on_warn)
-		panic("scheduling while atomic\n");
+	check_panic_on_warn("scheduling while atomic");
 
 	dump_stack();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -154,8 +154,7 @@ static void ubsan_epilogue(void)
 
 	current->in_ubsan--;
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("UBSAN");
 }
 
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -164,8 +164,8 @@ static void end_report(unsigned long *fl
 				       (unsigned long)addr);
 	pr_err("==================================================================\n");
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
-		panic("panic_on_warn set ...\n");
+	if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
+		check_panic_on_warn("KASAN");
 	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
 		panic("kasan.fault=panic set ...\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -273,8 +273,7 @@ void kfence_report_error(unsigned long a
 
 	lockdep_on();
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("KFENCE");
 
 	/* We encountered a memory safety error, taint the kernel! */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_STILL_OK);


