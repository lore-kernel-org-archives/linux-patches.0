Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88F74A09
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E90CC43140
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933041;
	bh=4J+Fwfcn3l5TP7dPSLFq+oTih00QSAfPID6kXaebtv0=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=oh1VILUEqEvfKsKUlXs0AQ0DpvaXlrTSxwpNKjqewjAVfNS2LVHlegqPq4tMclljx
	 5RYswRP3SU2r/Sce5tbfEbGspaUf9rqRMJNmAq++C5fyKR4VxfukafHB8Ldm0aoQqp
	 u/Dcb/ZMpnyWatr2btnosLF2q7/AEpcrsgHgaQ4nvnKfdzZQSjdx+6hoctGAzq8Yla
	 ggodmRzzcoBWywmpctQsC06Gen5/mEkhzoKNkwJKJVax7YQq2BFa24r8oXKBu/mGYG
	 pcCavMP1/F8gtIMgBF3iz1bV7ASU+UKbur/QDrn/jFDJeDQnXiilEVqUh+PpUD9F5I
	 rIG6bAK5yX6yQ==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:20 -0400
Subject: [PATCH v1 6/9] mm/memcontrol: Replace the PREEMPT_RT conditionals
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-6-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2145;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=4+IJkFdHR6iLrUiIGHVYw1suR0hmToWLjQqqtGRpD70=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X173a0+/wYyHWT++udoriR5YJuK+dXPNT6a6OP413B8m
 Fcu+7ihlYRDjYpAVU2Qp2xe7KajwoYdceo8pzBxWJpAhDFycAjCRLZsYGd7eu6O9oGT6KTbDTccmST
 v8MUvRbZMxWP7/hRK/o1TF9K2MDBsXT/gQ7r3VsmD+Gvlnn7zd7v4xSlJdZLC65KJ+pOsFDRYA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

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

