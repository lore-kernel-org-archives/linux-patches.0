Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632BF3D3012;
	Mon, 20 Apr 2026 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691411; cv=none; b=J4MbOLveOksQpa+WDyDJuOvnPGkMvHaw9Ps26nOPDOJrAjxLWCxhyUweH+B4VvR3or/Wq7YAs9Iho65TbWmuqj2ZDJBZ/wWsRNR5BLJN6mHIDmwVQuHTFcgpCz6fxB/ZiL35zYbVM58uUIC/DhDdegrwsIH9sd1RkMZa9BNMG9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691411; c=relaxed/simple;
	bh=MZEuU3Y93HSS0LylEUPvD8xXO8PAZIqVKPE46K33WHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWJcoM2YOQDNhBuO6/DpCvdhF++cD2FxCj05kXu4SMfDnLZ4wy4qkCSpqLTWdY7/ig9tWDwPdClTs8cSogdPrOdxGI1Few1RM9fK3vywvxhvLihuJcY0sIrKbDdxv4TboIs/fJoIwXvDxlf4Zklah+BwiQfoq/cLme3xTKmelM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddEGI0rd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddEGI0rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B71CC19425;
	Mon, 20 Apr 2026 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691411;
	bh=MZEuU3Y93HSS0LylEUPvD8xXO8PAZIqVKPE46K33WHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddEGI0rdfZFYlnpeJNT9VrdiRlyo8HKHXkc5Q5V+qkpSoPHOxbOHFpfHnYYY9I1E6
	 WVHPoR25oFfhea7yxBGlK9q3KmIPaPiWWvn16f+Il1GFGxd2XglCLFTE7uvf7wnCd5
	 ET8651mMZ9asZ5xQ9msaKGOl/84qdO7VyMMG9FI6OYz9FHNdSMY8ZuTVe+GTo9yQji
	 HUkdQazgP3jT5fqPctVbSuhRyPNKvXrjYF2esJ4M4lACl6FJNi+DJxXG222jtdzQ3B
	 F+8hgNSLXHiKmgPkQ6BPIye6/Iyeo7lpF9eLFaBjXKJqYY8fJniNLYTOYmDnQt5fE+
	 Gb7wXNa5SsmKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jiangshanlai@gmail.com,
	josh@joshtriplett.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] srcu: Use irq_work to start GP in tiny SRCU
Date: Mon, 20 Apr 2026 09:16:44 -0400
Message-ID: <20260420132314.1023554-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit a6fc88b22bc8d12ad52e8412c667ec0f5bf055af ]

Tiny SRCU's srcu_gp_start_if_needed() directly calls schedule_work(),
which acquires the workqueue pool->lock.

This causes a lockdep splat when call_srcu() is called with a scheduler
lock held, due to:

  call_srcu() [holding pi_lock]
    srcu_gp_start_if_needed()
      schedule_work() -> pool->lock

  workqueue_init() / create_worker() [holding pool->lock]
    wake_up_process() -> try_to_wake_up() -> pi_lock

Also add irq_work_sync() to cleanup_srcu_struct() to prevent a
use-after-free if a queued irq_work fires after cleanup begins.

Tested with rcutorture SRCU-T and no lockdep warnings.

[ Thanks to Boqun for similar fix in patch "rcu: Use an intermediate irq_work
to start process_srcu()" ]

Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 include/linux/srcutiny.h |  4 ++++
 kernel/rcu/srcutiny.c    | 19 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index 51ce25f07930e..1f9a226e6fd81 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_SRCU_TINY_H
 #define _LINUX_SRCU_TINY_H
 
+#include <linux/irq_work_types.h>
 #include <linux/swait.h>
 
 struct srcu_struct {
@@ -24,18 +25,21 @@ struct srcu_struct {
 	struct rcu_head *srcu_cb_head;	/* Pending callbacks: Head. */
 	struct rcu_head **srcu_cb_tail;	/* Pending callbacks: Tail. */
 	struct work_struct srcu_work;	/* For driving grace periods. */
+	struct irq_work srcu_irq_work;	/* Defer schedule_work() to irq work. */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 };
 
 void srcu_drive_gp(struct work_struct *wp);
+void srcu_tiny_irq_work(struct irq_work *irq_work);
 
 #define __SRCU_STRUCT_INIT(name, __ignored, ___ignored)			\
 {									\
 	.srcu_wq = __SWAIT_QUEUE_HEAD_INITIALIZER(name.srcu_wq),	\
 	.srcu_cb_tail = &name.srcu_cb_head,				\
 	.srcu_work = __WORK_INITIALIZER(name.srcu_work, srcu_drive_gp),	\
+	.srcu_irq_work = { .func = srcu_tiny_irq_work },		\
 	__SRCU_DEP_MAP_INIT(name)					\
 }
 
diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index e3b64a5e0ec7e..d9c11d5f0ea45 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/irq_work.h>
 #include <linux/mutex.h>
 #include <linux/preempt.h>
 #include <linux/rcupdate_wait.h>
@@ -41,6 +42,7 @@ static int init_srcu_struct_fields(struct srcu_struct *ssp)
 	ssp->srcu_idx_max = 0;
 	INIT_WORK(&ssp->srcu_work, srcu_drive_gp);
 	INIT_LIST_HEAD(&ssp->srcu_work.entry);
+	init_irq_work(&ssp->srcu_irq_work, srcu_tiny_irq_work);
 	return 0;
 }
 
@@ -84,6 +86,7 @@ EXPORT_SYMBOL_GPL(init_srcu_struct);
 void cleanup_srcu_struct(struct srcu_struct *ssp)
 {
 	WARN_ON(ssp->srcu_lock_nesting[0] || ssp->srcu_lock_nesting[1]);
+	irq_work_sync(&ssp->srcu_irq_work);
 	flush_work(&ssp->srcu_work);
 	WARN_ON(ssp->srcu_gp_running);
 	WARN_ON(ssp->srcu_gp_waiting);
@@ -172,6 +175,20 @@ void srcu_drive_gp(struct work_struct *wp)
 }
 EXPORT_SYMBOL_GPL(srcu_drive_gp);
 
+/*
+ * Use an irq_work to defer schedule_work() to avoid acquiring the workqueue
+ * pool->lock while the caller might hold scheduler locks, causing lockdep
+ * splats due to workqueue_init() doing a wakeup.
+ */
+void srcu_tiny_irq_work(struct irq_work *irq_work)
+{
+	struct srcu_struct *ssp;
+
+	ssp = container_of(irq_work, struct srcu_struct, srcu_irq_work);
+	schedule_work(&ssp->srcu_work);
+}
+EXPORT_SYMBOL_GPL(srcu_tiny_irq_work);
+
 static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 {
 	unsigned long cookie;
@@ -184,7 +201,7 @@ static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 	WRITE_ONCE(ssp->srcu_idx_max, cookie);
 	if (!READ_ONCE(ssp->srcu_gp_running)) {
 		if (likely(srcu_init_done))
-			schedule_work(&ssp->srcu_work);
+			irq_work_queue(&ssp->srcu_irq_work);
 		else if (list_empty(&ssp->srcu_work.entry))
 			list_add(&ssp->srcu_work.entry, &srcu_boot_list);
 	}
-- 
2.53.0

