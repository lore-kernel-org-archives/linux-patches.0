Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608823191B9;
	Wed,  3 Dec 2025 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779932; cv=none; b=mRLT3+H5VQvc1Fb7ed65r8ANr7rzvYKORTDFysSU6LXfuuZr8PAawCWsJpTVbRsSvdybClGoIpWPYE80y7u380OA/DB1aVCaDSEvHmfXqGqSnxYqfclOzZta1a2mkG0x3SHWp7X8X3fyRi9wO18Yflp6lRJUvku09Fe4kJO2/Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779932; c=relaxed/simple;
	bh=s43Sxmhc/g8fMBiYmtuA+KjCJ3L0XdkRuodBG8b7TwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fue6Z98Ujk8Y8CqyJ3K9z884szjgImPSl64pVJNQD6EvPOHZ9W9Qz/S45mvBkdkR+hyZSY4rAG06IzvYKO6Dm9aagYgKyJyYwIaSxZdsiaF8BXcwMIVAsEHSykMSkzdChjzbDeZ3Kv6U38S6jJNngNi6+nYmMDI/+s3Yvm1s30I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5zUYgV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5zUYgV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081D3C4CEF5;
	Wed,  3 Dec 2025 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779931;
	bh=s43Sxmhc/g8fMBiYmtuA+KjCJ3L0XdkRuodBG8b7TwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5zUYgV1k1ch04jNS+V2v8irS9vBtf7vKu9RvwOTFpyX02+JeWWv2scR7VJEwBrgC
	 rBE3NkFnE+maicJmXbr77Zmjoso6sukkgdBCcwaF0axGj8M8iUWtD0+MwXb+YTOojy
	 wajNVTiXjzrOjnRXfWJNBMIcpyKPeQNzsEgq86oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lingutla Chandrasekhar <clingutla@codeaurora.org>,
	"J. Avila" <elavila@google.com>,
	John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sumanth Gavini <sumanth.gavini@yahoo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 388/568] softirq: Add trace points for tasklet entry/exit
Date: Wed,  3 Dec 2025 16:26:30 +0100
Message-ID: <20251203152454.902912380@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Gavini <sumanth.gavini@yahoo.com>

commit f4bf3ca2e5cba655824b6e0893a98dfb33ed24e5 upstream.

Tasklets are supposed to finish their work quickly and should not block the
current running process, but it is not guaranteed that they do so.

Currently softirq_entry/exit can be used to analyse the total tasklets
execution time, but that's not helpful to track individual tasklets
execution time. That makes it hard to identify tasklet functions, which
take more time than expected.

Add tasklet_entry/exit trace point support to track individual tasklet
execution.

Trivial usage example:
   # echo 1 > /sys/kernel/debug/tracing/events/irq/tasklet_entry/enable
   # echo 1 > /sys/kernel/debug/tracing/events/irq/tasklet_exit/enable
   # cat /sys/kernel/debug/tracing/trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 4/4   #P:4
 #
 #                                _-----=> irqs-off/BH-disabled
 #                               / _----=> need-resched
 #                              | / _---=> hardirq/softirq
 #                              || / _--=> preempt-depth
 #                              ||| / _-=> migrate-disable
 #                              |||| /     delay
 #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
 #              | |         |   |||||     |         |
           <idle>-0       [003] ..s1.   314.011428: tasklet_entry: tasklet=0xffffa01ef8db2740 function=tcp_tasklet_func
           <idle>-0       [003] ..s1.   314.011432: tasklet_exit: tasklet=0xffffa01ef8db2740 function=tcp_tasklet_func
           <idle>-0       [003] ..s1.   314.017369: tasklet_entry: tasklet=0xffffa01ef8db2740 function=tcp_tasklet_func
           <idle>-0       [003] ..s1.   314.017371: tasklet_exit: tasklet=0xffffa01ef8db2740 function=tcp_tasklet_func

Signed-off-by: Lingutla Chandrasekhar <clingutla@codeaurora.org>
Signed-off-by: J. Avila <elavila@google.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20230407230526.1685443-1-jstultz@google.com

[elavila: Port to android-mainline]
[jstultz: Rebased to upstream, cut unused trace points, added
 comments for the tracepoints, reworded commit]

The intention is to keep the stable branch in sync with upstream fixes
and improve observability without introducing new functionality.

Signed-off-by: Sumanth Gavini <sumanth.gavini@yahoo.com>

Changes in V2:
- No code changes
- Link to V1: https://lore.kernel.org/all/20250812161755.609600-1-sumanth.gavini@yahoo.com/
- Updated the comment msg before the signed-off-by

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/irq.h | 47 ++++++++++++++++++++++++++++++++++++++
 kernel/softirq.c           |  9 ++++++--
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index eeceafaaea4c1..a07b4607b6635 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -160,6 +160,53 @@ DEFINE_EVENT(softirq, softirq_raise,
 	TP_ARGS(vec_nr)
 );
 
+DECLARE_EVENT_CLASS(tasklet,
+
+	TP_PROTO(struct tasklet_struct *t, void *func),
+
+	TP_ARGS(t, func),
+
+	TP_STRUCT__entry(
+		__field(	void *,	tasklet)
+		__field(	void *,	func)
+	),
+
+	TP_fast_assign(
+		__entry->tasklet = t;
+		__entry->func = func;
+	),
+
+	TP_printk("tasklet=%ps function=%ps", __entry->tasklet, __entry->func)
+);
+
+/**
+ * tasklet_entry - called immediately before the tasklet is run
+ * @t: tasklet pointer
+ * @func: tasklet callback or function being run
+ *
+ * Used to find individual tasklet execution time
+ */
+DEFINE_EVENT(tasklet, tasklet_entry,
+
+	TP_PROTO(struct tasklet_struct *t, void *func),
+
+	TP_ARGS(t, func)
+);
+
+/**
+ * tasklet_exit - called immediately after the tasklet is run
+ * @t: tasklet pointer
+ * @func: tasklet callback or function being run
+ *
+ * Used to find individual tasklet execution time
+ */
+DEFINE_EVENT(tasklet, tasklet_exit,
+
+	TP_PROTO(struct tasklet_struct *t, void *func),
+
+	TP_ARGS(t, func)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 9ab5ca399a990..fadc6bbda27b1 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -822,10 +822,15 @@ static void tasklet_action_common(struct softirq_action *a,
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
 				if (tasklet_clear_sched(t)) {
-					if (t->use_callback)
+					if (t->use_callback) {
+						trace_tasklet_entry(t, t->callback);
 						t->callback(t);
-					else
+						trace_tasklet_exit(t, t->callback);
+					} else {
+						trace_tasklet_entry(t, t->func);
 						t->func(t->data);
+						trace_tasklet_exit(t, t->func);
+					}
 				}
 				tasklet_unlock(t);
 				continue;
-- 
2.51.0



