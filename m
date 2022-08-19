Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCE94A0B
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EBDC433D6
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1660933458;
	bh=4J+Fwfcn3l5TP7dPSLFq+oTih00QSAfPID6kXaebtv0=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=HemL63lsMtSaMyzy4XlgHkF6l/FgD4FDY6H1qoqPu0xaxMAUZM7O59hVPgp2PbvVR
	 o2SfJUnGru+g3NiJAJMwD5kKqOodMwrxdanDuMQmTDb1NUcPrHHlWLvnDbZ+brCPDZ
	 V/Z/hp8bQnwf5NuMZ6hxDn5i1nI2WOTXaq7K5P3Y=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 19 Aug 2022 14:24:15 -0400
Subject: [PATCH RESEND v1 6/9] mm/memcontrol: Replace the PREEMPT_RT conditionals
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-6-dfdb252f35f4@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-dfdb252f35f4@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-dfdb252f35f4@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2145;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=4+IJkFdHR6iLrUiIGHVYw1suR0hmToWLjQqqtGRpD70=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X/U7XJHTYGE1Q759s89Xk30Hvt6L55qQH7Xp/uH+mGcr
 1neWdJSyMIhxMciKKbKU7YvdFFT40EMuvccUZg4rE8gQBi5OAZiIUgIjw4qZx1UiZ983WndFfFG/sm
 L8iilTj4uo/Iu/c9Beex5HsQrDP4v0KXeuHZdjfCN7dpVZsInePkuXmnTWuRclJzplRe26zQAA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

From: Thomas Gleixner <tglx@linutronix.de>

Use VM_WARN_ON_IRQS_ENABLED() and preempt_disable/enable_nested() to
replace the CONFIG_PREEMPT_RT #ifdeffery.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5..d35b6fa560f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -597,25 +597,18 @@ static u64 flush_next_time;
  */
 static void memcg_stats_lock(void)
 {
-#ifdef CONFIG_PREEMPT_RT
-      preempt_disable();
-#else
-      VM_BUG_ON(!irqs_disabled());
-#endif
+	preempt_disable_nested();
+	VM_WARN_ON_IRQS_ENABLED();
 }
 
 static void __memcg_stats_lock(void)
 {
-#ifdef CONFIG_PREEMPT_RT
-      preempt_disable();
-#endif
+	preempt_disable_nested();
 }
 
 static void memcg_stats_unlock(void)
 {
-#ifdef CONFIG_PREEMPT_RT
-      preempt_enable();
-#endif
+	preempt_enable_nested();
 }
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
@@ -715,7 +708,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 	 * interrupt context while other caller need to have disabled interrupt.
 	 */
 	__memcg_stats_lock();
-	if (IS_ENABLED(CONFIG_DEBUG_VM) && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
+	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
 		switch (idx) {
 		case NR_ANON_MAPPED:
 		case NR_FILE_MAPPED:
@@ -725,7 +718,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			WARN_ON_ONCE(!in_task());
 			break;
 		default:
-			WARN_ON_ONCE(!irqs_disabled());
+			VM_WARN_ON_IRQS_ENABLED();
 		}
 	}
 

-- 
b4 0.10.0-dev-c53d8

