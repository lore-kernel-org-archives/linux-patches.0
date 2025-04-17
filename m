Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47EF1A3178;
	Thu, 17 Apr 2025 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913955; cv=none; b=mZM7FYtQdzIYOF9p/1FjFi6O3hzmezVDalXE4XjzqRkaUfYrf1oacV18ssMyglJe9mfg+HSOmU2lba+v1IE+QVmro+YgCQgBoYlKEeDLpSbzaRR+Sp4hqRDDYqLghdfxWur/knqEDha3rFCw4/6CQvjsl1fmNuFS/olQY8z0EbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913955; c=relaxed/simple;
	bh=RUKXBA1wz8VGL6haMfROPBFESdf5DILy1fBuJ5mrdp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCrojcQFU/5Kaew9DN4uzUBj3SJ0guDfr4HnwZSn5pbUiTx22JZ8wViGBm6XUwgO36urL5TNk1S1QlQXsE6FVthSOu2Z2k+rjg+SGwqabHy4HOWZByZ4Fi6jRJm1/GHF8kmaCHEuYHQFuVYwroGfrUmoWtpVe6Q+p58XNkU+X6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1thBZNLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1thBZNLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B361C4CEE4;
	Thu, 17 Apr 2025 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913955;
	bh=RUKXBA1wz8VGL6haMfROPBFESdf5DILy1fBuJ5mrdp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1thBZNLs6ao6c5s1lgUUSUg+aQlo+VzRDuy+EkpYOhuDJ7SxXxNdIaK5LnVPbahlz
	 5INi3FsSRNfzXCWKTnobAy8mZ9iqbpfI3jEXCWPx/KSUq0ixG+sM4qIQBHFXfmb5Yp
	 63EI8GiUrjjgR11deqcMUsCnTNvjZHh4LirZUHzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 058/414] tracing: Disable branch profiling in noinstr code
Date: Thu, 17 Apr 2025 19:46:56 +0200
Message-ID: <20250417175113.749097076@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 2cbb20b008dba39893f0e296dc8ca312f40a9a0e ]

CONFIG_TRACE_BRANCH_PROFILING inserts a call to ftrace_likely_update()
for each use of likely() or unlikely().  That breaks noinstr rules if
the affected function is annotated as noinstr.

Disable branch profiling for files with noinstr functions.  In addition
to some individual files, this also includes the entire arch/x86
subtree, as well as the kernel/entry, drivers/cpuidle, and drivers/idle
directories, all of which are noinstr-heavy.

Due to the nature of how sched binaries are built by combining multiple
.c files into one, branch profiling is disabled more broadly across the
sched code than would otherwise be needed.

This fixes many warnings like the following:

  vmlinux.o: warning: objtool: do_syscall_64+0x40: call to ftrace_likely_update() leaves .noinstr.text section
  vmlinux.o: warning: objtool: __rdgsbase_inactive+0x33: call to ftrace_likely_update() leaves .noinstr.text section
  vmlinux.o: warning: objtool: handle_bug.isra.0+0x198: call to ftrace_likely_update() leaves .noinstr.text section
  ...

Reported-by: Ingo Molnar <mingo@kernel.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/fb94fc9303d48a5ed370498f54500cc4c338eb6d.1742586676.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kbuild                    | 4 ++++
 arch/x86/kernel/head64.c           | 2 --
 arch/x86/mm/kasan_init_64.c        | 1 -
 arch/x86/mm/mem_encrypt_amd.c      | 2 --
 arch/x86/mm/mem_encrypt_identity.c | 2 --
 drivers/acpi/Makefile              | 4 ++++
 drivers/cpuidle/Makefile           | 3 +++
 drivers/idle/Makefile              | 5 ++++-
 kernel/Makefile                    | 5 +++++
 kernel/entry/Makefile              | 3 +++
 kernel/sched/Makefile              | 5 +++++
 kernel/time/Makefile               | 6 ++++++
 lib/Makefile                       | 5 +++++
 13 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index cf0ad89f5639d..f7fb3d88c57bd 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -1,4 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
+
+# Branch profiling isn't noinstr-safe.  Disable it for arch/x86/*
+subdir-ccflags-$(CONFIG_TRACE_BRANCH_PROFILING) += -DDISABLE_BRANCH_PROFILING
+
 obj-$(CONFIG_ARCH_HAS_CC_PLATFORM) += coco/
 
 obj-y += entry/
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 4b9d4557fc94a..bab68feef0e8f 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -5,8 +5,6 @@
  *  Copyright (C) 2000 Andrea Arcangeli <andrea@suse.de> SuSE
  */
 
-#define DISABLE_BRANCH_PROFILING
-
 /* cpu_feature_enabled() cannot be used this early */
 #define USE_EARLY_PGTABLE_L5
 
diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 9dddf19a55716..0539efd0d216b 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#define DISABLE_BRANCH_PROFILING
 #define pr_fmt(fmt) "kasan: " fmt
 
 /* cpu_feature_enabled() cannot be used this early */
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 774f9677458f2..8dfc584be40c3 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -7,8 +7,6 @@
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  */
 
-#define DISABLE_BRANCH_PROFILING
-
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <linux/mm.h>
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 9fce5b87b8c50..5eecdd92da105 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -7,8 +7,6 @@
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  */
 
-#define DISABLE_BRANCH_PROFILING
-
 /*
  * Since we're dealing with identity mappings, physical and virtual
  * addresses are the same, so override these defines which are ultimately
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 40208a0f5dfb5..797070fc9a3f4 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -5,6 +5,10 @@
 
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 
+ifdef CONFIG_TRACE_BRANCH_PROFILING
+CFLAGS_processor_idle.o += -DDISABLE_BRANCH_PROFILING
+endif
+
 #
 # ACPI Boot-Time Table Parsing
 #
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index d103342b7cfc2..1de9e92c5b0fc 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -3,6 +3,9 @@
 # Makefile for cpuidle.
 #
 
+# Branch profiling isn't noinstr-safe
+ccflags-$(CONFIG_TRACE_BRANCH_PROFILING) += -DDISABLE_BRANCH_PROFILING
+
 obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
diff --git a/drivers/idle/Makefile b/drivers/idle/Makefile
index 0a3c375100797..a34af1ba09bdb 100644
--- a/drivers/idle/Makefile
+++ b/drivers/idle/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_INTEL_IDLE)			+= intel_idle.o
 
+# Branch profiling isn't noinstr-safe
+ccflags-$(CONFIG_TRACE_BRANCH_PROFILING) += -DDISABLE_BRANCH_PROFILING
+
+obj-$(CONFIG_INTEL_IDLE)			+= intel_idle.o
diff --git a/kernel/Makefile b/kernel/Makefile
index 87866b037fbed..434929de17ef2 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -21,6 +21,11 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_irq_work.o = $(CC_FLAGS_FTRACE)
 endif
 
+# Branch profiling isn't noinstr-safe
+ifdef CONFIG_TRACE_BRANCH_PROFILING
+CFLAGS_context_tracking.o += -DDISABLE_BRANCH_PROFILING
+endif
+
 # Prevents flicker of uninteresting __do_softirq()/__local_bh_disable_ip()
 # in coverage traces.
 KCOV_INSTRUMENT_softirq.o := n
diff --git a/kernel/entry/Makefile b/kernel/entry/Makefile
index 095c775e001e2..d4b8bd0af79b0 100644
--- a/kernel/entry/Makefile
+++ b/kernel/entry/Makefile
@@ -6,6 +6,9 @@ KASAN_SANITIZE := n
 UBSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 
+# Branch profiling isn't noinstr-safe
+ccflags-$(CONFIG_TRACE_BRANCH_PROFILING) += -DDISABLE_BRANCH_PROFILING
+
 CFLAGS_REMOVE_common.o	 = -fstack-protector -fstack-protector-strong
 CFLAGS_common.o		+= -fno-stack-protector
 
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 976092b7bd452..8ae86371ddcdd 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -22,6 +22,11 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
+# Branch profiling isn't noinstr-safe
+ifdef CONFIG_TRACE_BRANCH_PROFILING
+CFLAGS_build_policy.o += -DDISABLE_BRANCH_PROFILING
+CFLAGS_build_utility.o += -DDISABLE_BRANCH_PROFILING
+endif
 #
 # Build efficiency:
 #
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index fe0ae82124fe7..e6e9b85d4db5f 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -1,4 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
+
+# Branch profiling isn't noinstr-safe
+ifdef CONFIG_TRACE_BRANCH_PROFILING
+CFLAGS_sched_clock.o += -DDISABLE_BRANCH_PROFILING
+endif
+
 obj-y += time.o timer.o hrtimer.o sleep_timeout.o
 obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o
 obj-y += timeconv.o timecounter.o alarmtimer.o
diff --git a/lib/Makefile b/lib/Makefile
index a8155c972f028..6041cb0ef1588 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,6 +5,11 @@
 
 ccflags-remove-$(CONFIG_FUNCTION_TRACER) += $(CC_FLAGS_FTRACE)
 
+# Branch profiling isn't noinstr-safe
+ifdef CONFIG_TRACE_BRANCH_PROFILING
+CFLAGS_smp_processor_id.o += -DDISABLE_BRANCH_PROFILING
+endif
+
 # These files are disabled because they produce lots of non-interesting and/or
 # flaky coverage that is not a function of syscall inputs. For example,
 # rbtree can be global and individual rotations don't correlate with inputs.
-- 
2.39.5



