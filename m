Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4D14A12
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC72C433D6
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933042;
	bh=JdYontgimBsq9jzwBRrczqNx6GAG5f+hdJ8KbE3Afqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=Rej+uUI9SrJxpq7tX+inbGKNxGPh+tuz9r7HHHYsL60AsYTLx2UHNwRnvz9rQZGFw
	 CQ0vcGP821606guIQhRuaduNKUFewmKZ0jE4WvgoYtuwbpvXMoBWoPPF6P0KGr8fIe
	 mI056fE92SI9kMZXSLJX+RJRKuxu6GzcggnXuQRWRbbKs385149joHPR9u+Tz7jQ9i
	 qjv0tGcZbK0VE+44wRMrS8ndtGoBFgTYkPkNbfETcrjxm9h3lA3kQeUuDRWvorntyZ
	 5CDMXnj4a+v8TBpCZsrrAIvAdnZatsk+zq1fJwveND2rZG3n9RnCbzIVVUwKNKktbk
	 19M5Bammov6NA==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:22 -0400
Subject: [PATCH v1 8/9] u64_stats: Streamline the implementation
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-8-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=8184;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=5fcBgo65Qtoiq765g0unoMReJg5IVpLx4yQbAhpc9oM=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X17Xpr2vJf3Av29ssSoG7UXLH1VGn/l+PvpB7oydCxfd
 fLroXUcpC4MYF4OsmCJL2b7YTUGFDz3k0ntMYeawMoEMYeDiFICJ+JxnZGg0ejBD6QmzzJTJCcfE1+
 TvmRj3p3OCdMW/UsvjYZefNL9g+Ge9udg9UjLHVt2r9P8cbvvU2Ndcqdm6feYNLgFrKzOiOAE=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

The u64 stats code handles 3 different cases:

  - 32bit UP
  - 32bit SMP
  - 64bit

with an unreadable #ifdef maze, which was recently expanded with PREEMPT_RT
conditionals.

Reduce it to two cases (32bit and 64bit) and drop the optimization for
32bit UP as suggested by Linus.

Use the new preempt_disable/enable_nested() helpers to get rid of the
CONFIG_PREEMPT_RT conditionals.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 6ad4e9032d53..46040d66334a 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -8,7 +8,7 @@
  *
  * Key points :
  *
- * -  Use a seqcount on 32-bit SMP, only disable preemption for 32-bit UP.
+ * -  Use a seqcount on 32-bit
  * -  The whole thing is a no-op on 64-bit architectures.
  *
  * Usage constraints:
@@ -20,7 +20,8 @@
  *    writer and also spin forever.
  *
  * 3) Write side must use the _irqsave() variant if other writers, or a reader,
- *    can be invoked from an IRQ context.
+ *    can be invoked from an IRQ context. On 64bit systems this variant does not
+ *    disable interrupts.
  *
  * 4) If reader fetches several counters, there is no guarantee the whole values
  *    are consistent w.r.t. each other (remember point #2: seqcounts are not
@@ -29,11 +30,6 @@
  * 5) Readers are allowed to sleep or be preempted/interrupted: they perform
  *    pure reads.
  *
- * 6) Readers must use both u64_stats_fetch_{begin,retry}_irq() if the stats
- *    might be updated from a hardirq or softirq context (remember point #1:
- *    seqcounts are not used for UP kernels). 32-bit UP stat readers could read
- *    corrupted 64-bit values otherwise.
- *
  * Usage :
  *
  * Stats producer (writer) should use following template granted it already got
@@ -66,7 +62,7 @@
 #include <linux/seqlock.h>
 
 struct u64_stats_sync {
-#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
+#if BITS_PER_LONG == 32
 	seqcount_t	seq;
 #endif
 };
@@ -98,7 +94,22 @@ static inline void u64_stats_inc(u64_stats_t *p)
 	local64_inc(&p->v);
 }
 
-#else
+static inline void u64_stats_init(struct u64_stats_sync *syncp) { }
+static inline void __u64_stats_update_begin(struct u64_stats_sync *syncp) { }
+static inline void __u64_stats_update_end(struct u64_stats_sync *syncp) { }
+static inline unsigned long __u64_stats_irqsave(void) { return 0; }
+static inline void __u64_stats_irqrestore(unsigned long flags) { }
+static inline unsigned int __u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
+{
+	return 0;
+}
+static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
+					   unsigned int start)
+{
+	return false;
+}
+
+#else /* 64 bit */
 
 typedef struct {
 	u64		v;
@@ -123,123 +134,95 @@ static inline void u64_stats_inc(u64_stats_t *p)
 {
 	p->v++;
 }
-#endif
 
-#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
-#define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
-#else
 static inline void u64_stats_init(struct u64_stats_sync *syncp)
 {
+	seqcount_init(&syncp->seq);
 }
-#endif
 
-static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
+static inline void __u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 	write_seqcount_begin(&syncp->seq);
-#endif
 }
 
-static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
+static inline void __u64_stats_update_end(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	write_seqcount_end(&syncp->seq);
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
-#endif
+	preempt_enable_nested();
 }
 
-static inline unsigned long
-u64_stats_update_begin_irqsave(struct u64_stats_sync *syncp)
+static inline unsigned long __u64_stats_irqsave(void)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 
-#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
-	else
-		local_irq_save(flags);
-	write_seqcount_begin(&syncp->seq);
-#endif
+	local_irq_save(flags);
 	return flags;
 }
 
-static inline void
-u64_stats_update_end_irqrestore(struct u64_stats_sync *syncp,
-				unsigned long flags)
+static inline void __u64_stats_irqrestore(unsigned long flags)
 {
-#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
-	write_seqcount_end(&syncp->seq);
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
-	else
-		local_irq_restore(flags);
-#endif
+	local_irq_restore(flags);
 }
 
 static inline unsigned int __u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	return read_seqcount_begin(&syncp->seq);
-#else
-	return 0;
-#endif
 }
 
-static inline unsigned int u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
+static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
+					   unsigned int start)
 {
-#if BITS_PER_LONG == 32 && (!defined(CONFIG_SMP) && !defined(CONFIG_PREEMPT_RT))
-	preempt_disable();
-#endif
-	return __u64_stats_fetch_begin(syncp);
+	return read_seqcount_retry(&syncp->seq, start);
 }
+#endif /* !64 bit */
 
-static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
-					 unsigned int start)
+static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
-	return read_seqcount_retry(&syncp->seq, start);
-#else
-	return false;
-#endif
+	__u64_stats_update_begin(syncp);
+}
+
+static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
+{
+	__u64_stats_update_end(syncp);
+}
+
+static inline unsigned long u64_stats_update_begin_irqsave(struct u64_stats_sync *syncp)
+{
+	unsigned long flags = __u64_stats_irqsave();
+
+	__u64_stats_update_begin(syncp);
+	return flags;
+}
+
+static inline void u64_stats_update_end_irqrestore(struct u64_stats_sync *syncp,
+						   unsigned long flags)
+{
+	__u64_stats_update_end(syncp);
+	__u64_stats_irqrestore(flags);
+}
+
+static inline unsigned int u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
+{
+	return __u64_stats_fetch_begin(syncp);
 }
 
 static inline bool u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 					 unsigned int start)
 {
-#if BITS_PER_LONG == 32 && (!defined(CONFIG_SMP) && !defined(CONFIG_PREEMPT_RT))
-	preempt_enable();
-#endif
 	return __u64_stats_fetch_retry(syncp, start);
 }
 
-/*
- * In case irq handlers can update u64 counters, readers can use following helpers
- * - SMP 32bit arches use seqcount protection, irq safe.
- * - UP 32bit must disable irqs.
- * - 64bit have no problem atomically reading u64 values, irq safe.
- */
+/* Obsolete interfaces */
 static inline unsigned int u64_stats_fetch_begin_irq(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT_RT)
-	preempt_disable();
-#elif BITS_PER_LONG == 32 && !defined(CONFIG_SMP)
-	local_irq_disable();
-#endif
-	return __u64_stats_fetch_begin(syncp);
+	return u64_stats_fetch_begin(syncp);
 }
 
 static inline bool u64_stats_fetch_retry_irq(const struct u64_stats_sync *syncp,
 					     unsigned int start)
 {
-#if BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT_RT)
-	preempt_enable();
-#elif BITS_PER_LONG == 32 && !defined(CONFIG_SMP)
-	local_irq_enable();
-#endif
-	return __u64_stats_fetch_retry(syncp, start);
+	return u64_stats_fetch_retry(syncp, start);
 }
 
 #endif /* _LINUX_U64_STATS_SYNC_H */

-- 
b4 0.10.0-dev-c53d8

