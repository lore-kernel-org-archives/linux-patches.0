Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA5C146A63;
	Wed,  5 Feb 2025 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763552; cv=none; b=XUjL2m7nlKxlrtmixEDIUAHc4g8VUZKI4fIUKuSl17VpbXhb9KJHzTlvv63uyP86Vu5EqcKevTS3hv+4S+n4I1Au+FjtR1qlyse6ddG/jsEMon3XPuy4+bmG+5DzU5LJ+iUObpizUSJa+s+7Bqt6pSFlhyoTqvg99+3hKwTBhOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763552; c=relaxed/simple;
	bh=6nNfQlrF/CT650Rmr1SR8Otel4XPiCzHSATzmY8AC8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3xxNG21RfCopZ0PLEta22djthrwgrMwBOn8X236Xd4EXD8HewTcoX8SwUvoMyLj0S8awBYcy6MhZ9WtEjfU/A9F9fMwK41vHxAa4PA3mk8XkdVLQwv160nw9LluAacSPsHbuNi0WNazfNnQwZBjqzM5Beb+RcIfbYj6M6VylqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkcLUDZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkcLUDZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B05C4CED1;
	Wed,  5 Feb 2025 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763552;
	bh=6nNfQlrF/CT650Rmr1SR8Otel4XPiCzHSATzmY8AC8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkcLUDZSTGob5rR0vrjCRdZZLPsDtBkcjiUhKshAGybZVHLanOF9qcrdty8XFv5FK
	 SeMncI4f/NVd4w+PbfbSzOEg68wSNv/OguDePdlOcQjYAV+7KaZplWn6btIsU6LASl
	 mO7jGjiqcKu8RtkGEImUGAGwD5vujlRhvrN7HX+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Swapnil Sapkal <swapnil.sapkal@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/590] sched/fair: Fix value reported by hot tasks pulled in /proc/schedstat
Date: Wed,  5 Feb 2025 14:36:24 +0100
Message-ID: <20250205134456.360609947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit a430d99e349026d53e2557b7b22bd2ebd61fe12a ]

In /proc/schedstat, lb_hot_gained reports the number hot tasks pulled
during load balance. This value is incremented in can_migrate_task()
if the task is migratable and hot. After incrementing the value,
load balancer can still decide not to migrate this task leading to wrong
accounting. Fix this by incrementing stats when hot tasks are detached.
This issue only exists in detach_tasks() where we can decide to not
migrate hot task even if it is migratable. However, in detach_one_task(),
we migrate it unconditionally.

[Swapnil: Handled the case where nr_failed_migrations_hot was not accounted properly and wrote commit log]

Fixes: d31980846f96 ("sched: Move up affinity check to mitigate useless redoing overhead")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: "Gautham R. Shenoy" <gautham.shenoy@amd.com>
Not-yet-signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Swapnil Sapkal <swapnil.sapkal@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241220063224.17767-2-swapnil.sapkal@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 17 +++++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 02eaf84c8626f..8982820dae213 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -944,6 +944,7 @@ struct task_struct {
 	unsigned			sched_reset_on_fork:1;
 	unsigned			sched_contributes_to_load:1;
 	unsigned			sched_migrated:1;
+	unsigned			sched_task_hot:1;
 
 	/* Force alignment to the next boundary: */
 	unsigned			:0;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a21110b220b7b..65e7be6448720 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9418,6 +9418,8 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	int tsk_cache_hot;
 
 	lockdep_assert_rq_held(env->src_rq);
+	if (p->sched_task_hot)
+		p->sched_task_hot = 0;
 
 	/*
 	 * We do not migrate tasks that are:
@@ -9490,10 +9492,8 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 
 	if (tsk_cache_hot <= 0 ||
 	    env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
-		if (tsk_cache_hot == 1) {
-			schedstat_inc(env->sd->lb_hot_gained[env->idle]);
-			schedstat_inc(p->stats.nr_forced_migrations);
-		}
+		if (tsk_cache_hot == 1)
+			p->sched_task_hot = 1;
 		return 1;
 	}
 
@@ -9508,6 +9508,12 @@ static void detach_task(struct task_struct *p, struct lb_env *env)
 {
 	lockdep_assert_rq_held(env->src_rq);
 
+	if (p->sched_task_hot) {
+		p->sched_task_hot = 0;
+		schedstat_inc(env->sd->lb_hot_gained[env->idle]);
+		schedstat_inc(p->stats.nr_forced_migrations);
+	}
+
 	deactivate_task(env->src_rq, p, DEQUEUE_NOCLOCK);
 	set_task_cpu(p, env->dst_cpu);
 }
@@ -9668,6 +9674,9 @@ static int detach_tasks(struct lb_env *env)
 
 		continue;
 next:
+		if (p->sched_task_hot)
+			schedstat_inc(p->stats.nr_failed_migrations_hot);
+
 		list_move(&p->se.group_node, tasks);
 	}
 
-- 
2.39.5



