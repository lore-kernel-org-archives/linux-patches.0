Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979FB37D11A;
	Wed, 30 Sep 2026 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787543; cv=none; b=S++SaXfGsXxApIvKSPQKVZa0dg8vvGz1aSzGyduQ6OYZcGJAH9SSqUNEiOPaCq7GWsXsxdYVFjDNj4oGXUO2Rg0/p3iZc6J0ovqOarRGdwRvYCzSnJt/gEkelJiWoG5WcYlcVtnLVYbF3nwmdW8bcY2BP6LrFO5pwICcbQeENZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787543; c=relaxed/simple;
	bh=u60HA/n/Qhjlk2rIrjkeqMop1Unh7Rz6fSUk3Aiekes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DunvIgrauubGSNaVDyWPdWSYYaiA9JMlR2EmndaHZMvcJg6HCRkP1J6eeCAWOS09Wy7M8zvHoKFrJWDgEBaYd+O15pCKrzXcaEEQehbk++HEbUorqGeohhwX4CKyEyL+dsmibOIO1zbjTQtq4IQPE1P8Nw8nLwPxcRxzFhpGvn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xd7Y+q1H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xd7Y+q1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBB01F000FF;
	Wed, 30 Sep 2026 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787542;
	bh=Hldvi0gNShqTrcHs0fmJRf+2zLvPxRBevB3pdwU3vPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xd7Y+q1HbD1fxBOE0UbycmysXrxkAUaYQEBg11xQlnw9xfYRwMZh7bU5MkVoe4Ce3
	 strs0x66QpEwws51qp/uitKkxUaYkFa05+3FvRWhUThh6U3QktVW7F0PpK7beZCKsF
	 pXS/bPjYxrQj12h+LAyoVLIYEOtCREzS70pOYVlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.2 268/457] kprobes: Fix permanent hang when flushing the kprobe optimizer
Date: Wed, 30 Sep 2026 17:26:13 +0200
Message-ID: <20260930152351.826445914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

commit 5bfa9f1a9dcb6ecb607adbc1c0226605c972935b upstream.

Writing 0 to /proc/sys/debug/kprobes-optimization while a kprobe is
jump-optimized never returns. The writer sleeps in D state forever with
kprobe_sysctl_mutex held, so any later read or write of that sysctl
hangs as well. For example, with vfs_read+9 as an optimizable address
in this build:

  # cd /sys/kernel/tracing
  # echo 'p:myprobe vfs_read+9' >> kprobe_events
  # echo 1 > events/kprobes/myprobe/enable
  # # wait until /sys/kernel/debug/kprobes/list shows [OPTIMIZED]
  # echo 0 > /proc/sys/debug/kprobes-optimization

  INFO: task sh:246 blocked for more than 10 seconds.
  Call Trace:
   <TASK>
   __schedule+0x1176/0x4f70
   schedule+0xdc/0x2c0
   schedule_timeout+0x17b/0x260
   wait_for_completion+0x173/0x3c0
   wait_for_kprobe_optimizer_locked+0xbc/0x130
   proc_kprobes_optimization_handler+0x156/0x1b0
   proc_sys_call_handler+0x324/0x490
   vfs_write+0x52d/0xfe0
   ksys_write+0xff/0x200
   do_syscall_64+0x106/0x630
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  ...
  INFO: task cat:265 is blocked on a mutex likely owned by task sh:246.

wait_for_kprobe_optimizer_locked() reinitializes optimizer_completion,
asks the optimizer thread to flush and sleeps in wait_for_completion().
The thread drains the (un)optimizing lists, but calls complete() only
if completion_done() is true, i.e. if the completion is already done,
which never happens while someone waits. disarm_all_kprobes() and
kprobe_trace_self_tests_init() wait the same way.

Calling complete() unconditionally would not be enough: the waiter
drops kprobe_mutex while it sleeps, and nothing else serializes the
sysctl handler against the debugfs "enabled" file. A second flusher
that still finds the lists non-empty, e.g. because a disabled probe is
queued for unoptimizing, reinitializes the completion under the first:

  sysctl write                      debugfs "enabled" write
  unoptimize_all_kprobes()
    wait_for_kprobe_optimizer_locked()
      init_completion(c)
      mutex_unlock(&kprobe_mutex)
      wait_for_completion(c)
                                    disarm_all_kprobes()
                                      wait_for_kprobe_optimizer_locked()
                                        init_completion(c)
                                          // c->wait is reset, the first
                                          // waiter is off the queue
                                        mutex_unlock(&kprobe_mutex)
                                        wait_for_completion(c)
  kprobe_optimizer()
    complete(c)
      // wakes the debugfs writer only

where c is &optimizer_completion. Lining up the two writes during an
optimizer pass loses the sysctl writer this way.

Replace the completion with a counter of optimizer passes, bumped at the
end of each pass and signalled with wake_up_var_locked(), both under
kprobe_mutex. A flusher samples the count and waits with
wait_var_event_mutex(), which drops kprobe_mutex only while sleeping, so
a new count means a whole pass ran in the meantime. Nothing is
reinitialized, so several flushers can sleep in the wait at once.

Link: https://lore.kernel.org/all/20260924092142.199198-1-parri.andrea@gmail.com/

Fixes: 73c12f209462 ("kprobes: Use dedicated kthread for kprobe optimizer")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 6337da5cab9e..4edd8ca5c657 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -42,6 +42,7 @@
 #include <linux/execmem.h>
 #include <linux/cleanup.h>
 #include <linux/wait.h>
+#include <linux/wait_bit.h>
 
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
@@ -526,7 +527,8 @@ enum {
 	OPTIMIZER_ST_FLUSHING = 2,
 };
 
-static DECLARE_COMPLETION(optimizer_completion);
+/* Bumped at the end of each kprobe_optimizer() pass, under 'kprobe_mutex' */
+static unsigned long optimizer_passes;
 
 #define OPTIMIZE_DELAY 5
 
@@ -654,9 +656,9 @@ static void kprobe_optimizer(void)
 		do_free_cleaned_kprobes();
 	}
 
-	/* Step 5: Kick optimizer again if needed. But if there is a flush requested, */
-	if (completion_done(&optimizer_completion))
-		complete(&optimizer_completion);
+	/* Step 5: Wake up flushers, and kick optimizer again if needed. */
+	optimizer_passes++;
+	wake_up_var_locked(&optimizer_passes, &kprobe_mutex);
 
 	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))
 		kick_kprobe_optimizer();	/*normal kick*/
@@ -708,7 +710,8 @@ static void wait_for_kprobe_optimizer_locked(void)
 	lockdep_assert_held(&kprobe_mutex);
 
 	while (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list)) {
-		init_completion(&optimizer_completion);
+		unsigned long passes = optimizer_passes;
+
 		/*
 		 * Set state to OPTIMIZER_ST_FLUSHING and wake up the thread if it's
 		 * idle. If it's already kicked, it will see the state change.
@@ -717,9 +720,12 @@ static void wait_for_kprobe_optimizer_locked(void)
 			OPTIMIZER_ST_FLUSHING) != OPTIMIZER_ST_FLUSHING)
 			wake_up(&kprobe_optimizer_wait);
 
-		mutex_unlock(&kprobe_mutex);
-		wait_for_completion(&optimizer_completion);
-		mutex_lock(&kprobe_mutex);
+		/*
+		 * kprobe_optimizer() holds 'kprobe_mutex' for a whole pass, which
+		 * this drops while sleeping, so a new count means a full pass ran.
+		 */
+		wait_var_event_mutex(&optimizer_passes,
+				     optimizer_passes != passes, &kprobe_mutex);
 	}
 }
 
-- 
2.55.0



