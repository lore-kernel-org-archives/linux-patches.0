Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3794F218;
	Thu, 12 Dec 2024 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018679; cv=none; b=NEdvO3BVnkzaAPQAmsT1fuJFMOudGdOqyKhkzFJ9xhQuTnS/Z8JC/s1bDwC6b0oGSQF/vsJ9yg0cM4VOQvLoforvPr1Rb3g6msdb31YjP5UYf+lTgHytmBUb/5gWR44QPP0Vk/ADJ71xdDJ8+WNHJfbmUyPUca46UdFkdJFBFks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018679; c=relaxed/simple;
	bh=KhCbtCr13CoTvuxCpeByjjl/2/FXh2wZEo/JXFnK7xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ2a9OlBBKO4TFVRk/cJi9nOtVaUUIoE+9vkXAT+NkhuYlKsPv6bpU3zNk+jnaGywSlmo4bDV+SbQXtYLDAkeDtjWaSYMnLmuOVvfzMkk4gPowrsIJqP5ek/AM8aWSZd/+Qpie12hHBqXbWNadbflrOXE0VKlSRJ4UhRIofp3f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ms/0ZiKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ms/0ZiKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2963C4CECE;
	Thu, 12 Dec 2024 15:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018679;
	bh=KhCbtCr13CoTvuxCpeByjjl/2/FXh2wZEo/JXFnK7xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ms/0ZiKDAwRaXjzNCRNyJRaHGMclza0iQ24NvoszQ+cEmFFWkbK4WUY2QpiIRVyjX
	 RGindMVvz1V/HiAxrqnUBQ04u3cFILJNGBVxSF8xW3pysyeBPZP8HZ1FC/CNqMm10z
	 tHIdM3VsbIbZWR3/ZhJgfIkEox8uBH6+s1RAXoQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Phil Auld <pauld@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 329/356] sched/deadline: Collect sched_dl_entity initialization
Date: Thu, 12 Dec 2024 16:00:48 +0100
Message-ID: <20241212144257.563264515@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 9e07d45c5210f5dd6701c00d55791983db7320fa ]

Create a single function that initializes a sched_dl_entity.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://lkml.kernel.org/r/51acc695eecf0a1a2f78f9a044e11ffd9b316bcf.1699095159.git.bristot@kernel.org
Stable-dep-of: 0664e2c311b9 ("sched/deadline: Fix warning in migrate_enable for boosted tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c     |  5 +----
 kernel/sched/deadline.c | 22 +++++++++++++++-------
 kernel/sched/sched.h    |  5 +----
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7181e6aae16b4..228f7c07da728 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4513,10 +4513,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	memset(&p->stats, 0, sizeof(p->stats));
 #endif
 
-	RB_CLEAR_NODE(&p->dl.rb_node);
-	init_dl_task_timer(&p->dl);
-	init_dl_inactive_task_timer(&p->dl);
-	__dl_clear_params(p);
+	init_dl_entity(&p->dl);
 
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->rt.timeout		= 0;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6421d28553576..97b548c343ddd 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -335,6 +335,8 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 	__add_rq_bw(new_bw, &rq->dl);
 }
 
+static void __dl_clear_params(struct sched_dl_entity *dl_se);
+
 /*
  * The utilization of a task cannot be immediately removed from
  * the rq active utilization (running_bw) when the task blocks.
@@ -434,7 +436,7 @@ static void task_non_contending(struct task_struct *p)
 			raw_spin_lock(&dl_b->lock);
 			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
 			raw_spin_unlock(&dl_b->lock);
-			__dl_clear_params(p);
+			__dl_clear_params(dl_se);
 		}
 
 		return;
@@ -1207,7 +1209,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-void init_dl_task_timer(struct sched_dl_entity *dl_se)
+static void init_dl_task_timer(struct sched_dl_entity *dl_se)
 {
 	struct hrtimer *timer = &dl_se->dl_timer;
 
@@ -1413,7 +1415,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		raw_spin_lock(&dl_b->lock);
 		__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
 		raw_spin_unlock(&dl_b->lock);
-		__dl_clear_params(p);
+		__dl_clear_params(dl_se);
 
 		goto unlock;
 	}
@@ -1429,7 +1431,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-void init_dl_inactive_task_timer(struct sched_dl_entity *dl_se)
+static void init_dl_inactive_task_timer(struct sched_dl_entity *dl_se)
 {
 	struct hrtimer *timer = &dl_se->inactive_timer;
 
@@ -2986,10 +2988,8 @@ bool __checkparam_dl(const struct sched_attr *attr)
 /*
  * This function clears the sched_dl_entity static params.
  */
-void __dl_clear_params(struct task_struct *p)
+static void __dl_clear_params(struct sched_dl_entity *dl_se)
 {
-	struct sched_dl_entity *dl_se = &p->dl;
-
 	dl_se->dl_runtime		= 0;
 	dl_se->dl_deadline		= 0;
 	dl_se->dl_period		= 0;
@@ -3007,6 +3007,14 @@ void __dl_clear_params(struct task_struct *p)
 #endif
 }
 
+void init_dl_entity(struct sched_dl_entity *dl_se)
+{
+	RB_CLEAR_NODE(&dl_se->rb_node);
+	init_dl_task_timer(dl_se);
+	init_dl_inactive_task_timer(dl_se);
+	__dl_clear_params(dl_se);
+}
+
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1d586e7576bc2..992ac92d021d2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -286,8 +286,6 @@ struct rt_bandwidth {
 	unsigned int		rt_period_active;
 };
 
-void __dl_clear_params(struct task_struct *p);
-
 static inline int dl_bandwidth_enabled(void)
 {
 	return sysctl_sched_rt_runtime >= 0;
@@ -2446,8 +2444,7 @@ extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
 
-extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
-extern void init_dl_inactive_task_timer(struct sched_dl_entity *dl_se);
+extern void init_dl_entity(struct sched_dl_entity *dl_se);
 
 #define BW_SHIFT		20
 #define BW_UNIT			(1 << BW_SHIFT)
-- 
2.43.0



