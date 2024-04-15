Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104F91E52C;
	Mon, 15 Apr 2024 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192254; cv=none; b=OIUYlspTL4R+qR0WelGBRhgDdeNToQI3G7iFnWE3gpF3ryfBrCYpNyrESrVi32robPGK3+OfJ2QJplPzgX9fOUoX3sfhdc0Zo+QUcVtBDAr/K0q5wfgbUf9Pg2+2z00qdq8WKI7OLN/wJHoSCUhIuUPscpeBsSQ1qpMeOYJ0SeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192254; c=relaxed/simple;
	bh=Hf21ByN4TohVCqOVPVPCmH47GQgTvRkjvjSWCR9PTT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX1LRPJOHQKrGkX1fVdDe81oYkXc0qrOWxLS8P4zK/+ZnqPDkS3AdvMj5ZslWbiOTvuKQRtXwLShaNpAGXa9vJBaX59D/k9KYQ2AqZ+zhn3G7jZdfiv3wYDQkfxAiAzIKPezNnONTfxpjUME9WXRygmgPyhviMDI7JmbJXlWfCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V661z0kY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V661z0kY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6047EC113CC;
	Mon, 15 Apr 2024 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192253;
	bh=Hf21ByN4TohVCqOVPVPCmH47GQgTvRkjvjSWCR9PTT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V661z0kYIAUk5Ttvhnt9LzkxDhmVCPTyGXwaP0njsBSwKN6QegzARRjuQDHue5wnk
	 +7BrhRHEyn6bckUY6ZyZcy+ZbQdmgE2XrMLlof2Be4G9lKQtS4Sxt6njD7ECwlbXU+
	 Mqtbt3qQ8Bay60cUwgN9QK76iNPtsRp9LKQwuweI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/45] u64_stats: Disable preemption on 32bit UP+SMP PREEMPT_RT during updates.
Date: Mon, 15 Apr 2024 16:21:17 +0200
Message-ID: <20240415141942.551569823@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 3c118547f87e930d45a5787e386734015dd93b32 ]

On PREEMPT_RT the seqcount_t for synchronisation is required on 32bit
architectures even on UP because the softirq (and the threaded IRQ handler) can
be preempted.

With the seqcount_t for synchronisation, a reader with higher priority can
preempt the writer and then spin endlessly in read_seqcount_begin() while the
writer can't make progress.

To avoid such a lock up on PREEMPT_RT the writer must disable preemption during
the update. There is no need to disable interrupts because no writer is using
this API in hard-IRQ context on PREEMPT_RT.

Disable preemption on 32bit-RT within the u64_stats write section.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 38a15d0a50e0 ("u64_stats: fix u64_stats_init() for lockdep when used repeatedly in one file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/u64_stats_sync.h | 42 ++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index e81856c0ba134..6a0f2097d3709 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -66,7 +66,7 @@
 #include <linux/seqlock.h>
 
 struct u64_stats_sync {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	seqcount_t	seq;
 #endif
 };
@@ -115,7 +115,7 @@ static inline void u64_stats_inc(u64_stats_t *p)
 }
 #endif
 
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 #define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
 #else
 static inline void u64_stats_init(struct u64_stats_sync *syncp)
@@ -125,15 +125,19 @@ static inline void u64_stats_init(struct u64_stats_sync *syncp)
 
 static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
 	write_seqcount_begin(&syncp->seq);
 #endif
 }
 
 static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	write_seqcount_end(&syncp->seq);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 #endif
 }
 
@@ -142,8 +146,11 @@ u64_stats_update_begin_irqsave(struct u64_stats_sync *syncp)
 {
 	unsigned long flags = 0;
 
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
-	local_irq_save(flags);
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+	else
+		local_irq_save(flags);
 	write_seqcount_begin(&syncp->seq);
 #endif
 	return flags;
@@ -153,15 +160,18 @@ static inline void
 u64_stats_update_end_irqrestore(struct u64_stats_sync *syncp,
 				unsigned long flags)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	write_seqcount_end(&syncp->seq);
-	local_irq_restore(flags);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
+	else
+		local_irq_restore(flags);
 #endif
 }
 
 static inline unsigned int __u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	return read_seqcount_begin(&syncp->seq);
 #else
 	return 0;
@@ -170,7 +180,7 @@ static inline unsigned int __u64_stats_fetch_begin(const struct u64_stats_sync *
 
 static inline unsigned int u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (!defined(CONFIG_SMP) && !defined(CONFIG_PREEMPT_RT))
 	preempt_disable();
 #endif
 	return __u64_stats_fetch_begin(syncp);
@@ -179,7 +189,7 @@ static inline unsigned int u64_stats_fetch_begin(const struct u64_stats_sync *sy
 static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 					 unsigned int start)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	return read_seqcount_retry(&syncp->seq, start);
 #else
 	return false;
@@ -189,7 +199,7 @@ static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 static inline bool u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 					 unsigned int start)
 {
-#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (!defined(CONFIG_SMP) && !defined(CONFIG_PREEMPT_RT))
 	preempt_enable();
 #endif
 	return __u64_stats_fetch_retry(syncp, start);
@@ -203,7 +213,9 @@ static inline bool u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
  */
 static inline unsigned int u64_stats_fetch_begin_irq(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT_RT)
+	preempt_disable();
+#elif BITS_PER_LONG == 32 && !defined(CONFIG_SMP)
 	local_irq_disable();
 #endif
 	return __u64_stats_fetch_begin(syncp);
@@ -212,7 +224,9 @@ static inline unsigned int u64_stats_fetch_begin_irq(const struct u64_stats_sync
 static inline bool u64_stats_fetch_retry_irq(const struct u64_stats_sync *syncp,
 					     unsigned int start)
 {
-#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT_RT)
+	preempt_enable();
+#elif BITS_PER_LONG == 32 && !defined(CONFIG_SMP)
 	local_irq_enable();
 #endif
 	return __u64_stats_fetch_retry(syncp, start);
-- 
2.43.0



