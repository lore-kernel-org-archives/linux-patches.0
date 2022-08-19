Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C09F46AE
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB44C433D7
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933040;
	bh=EjHaD121DKySdxcmCvjx6oTLrw50KJIHoRrIG+/3hpY=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=tu+TZ4AU/sRuHu2bRnbFolcUfkBkULAD5p5QEzLZKyCC/pu2XB8Cv3ev4+oTaq5GN
	 AUMj5NY3N0IkPCAigmFb8QHvtTsI2mhNrubzI04M7RrqlRLRCZ2cFbP4c6zLKjKJw/
	 i4z50UgaS6p0vcqT4QouT5x9YAM8qLAYP7r9/A/0BkMZJztjQyy/SMUFJ63R32ahrG
	 lYp8EASLn6VIl2Xgi9zMOufIdO7HUYCrTqwsEvL6QL2SU5qwl7a+6ynNLRxiXmix8k
	 CkAzNNbHVBMkdKDaCh5DuktpVwF/XAUQBAEQn9jk/9avFM7fm+71cpx5kFzLnE8FMn
	 PPcJ/A1vmZNZg==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:16 -0400
Subject: [PATCH v1 2/9] preempt: Provide preempt_[dis|en]able_nested()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-2-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3259;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=DYafn2h/R79+6oOzFnUcl2OcKxlyAw86Mf7sGc0BiAA=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X15rES1i+YNpvdDT+4XVsvOSmfScRKflTf86fR2nB4uJ
 eMysjlIWBjEuBlkxRZayfbGbggofesil95jCzGFlAhnCwMUpABPxMGJkuHW/uHx1gNc8FoYwlTk6cx
 xfrX0SaaTY0NIpvWbzl1IZY0aGVWzaWzdYJ7GXeUZf49zaerjZ+VFrf+ulR8JvbuY8czrDBQA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

On PREEMPT_RT enabled kernels, spinlocks and rwlocks are neither disabling
preemption nor interrupts. Though there are a few places which depend on
the implicit preemption/interrupt disable of those locks, e.g. seqcount
write sections, per CPU statistics updates etc.

To avoid sprinkling CONFIG_PREEMPT_RT conditionals all over the place, add
preempt_disable_nested() and preempt_enable_nested() which should be
descriptive enough.

Add a lockdep assertion for the !PREEMPT_RT case to catch callers which
do not have preemption disabled.

Cc: Ben Segall <bsegall@google.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index b4381f255a5c..0df425bf9bd7 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -421,4 +421,46 @@ static inline void migrate_enable(void) { }
 
 #endif /* CONFIG_SMP */
 
+/**
+ * preempt_disable_nested - Disable preemption inside a normally preempt disabled section
+ *
+ * Use for code which requires preemption protection inside a critical
+ * section which has preemption disabled implicitly on non-PREEMPT_RT
+ * enabled kernels, by e.g.:
+ *  - holding a spinlock/rwlock
+ *  - soft interrupt context
+ *  - regular interrupt handlers
+ *
+ * On PREEMPT_RT enabled kernels spinlock/rwlock held sections, soft
+ * interrupt context and regular interrupt handlers are preemptible and
+ * only prevent migration. preempt_disable_nested() ensures that preemption
+ * is disabled for cases which require CPU local serialization even on
+ * PREEMPT_RT. For non-PREEMPT_RT kernels this is a NOP.
+ *
+ * The use cases are code sequences which are not serialized by a
+ * particular lock instance, e.g.:
+ *  - seqcount write side critical sections where the seqcount is not
+ *    associated to a particular lock and therefore the automatic
+ *    protection mechanism does not work. This prevents a live lock
+ *    against a preempting high priority reader.
+ *  - RMW per CPU variable updates like vmstat.
+ */
+/* Macro to avoid header recursion hell vs. lockdep */
+#define preempt_disable_nested()				\
+do {								\
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))			\
+		preempt_disable();				\
+	else							\
+		lockdep_assert_preemption_disabled();		\
+} while (0)
+
+/**
+ * preempt_enable_nested - Undo the effect of preempt_disable_nested()
+ */
+static __always_inline void preempt_enable_nested(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
+}
+
 #endif /* __LINUX_PREEMPT_H */

-- 
b4 0.10.0-dev-c53d8

