Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FAD6BB5B;
	Tue, 12 Aug 2025 18:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023899; cv=none; b=r9zXIy+5F52GYMUhIbqK86EzHCEK6eWQSkBAAKp1qW70qAIjJw9pU4ZypDrXfF0a9MKeTd64IxhRcvaCjp1oo7cStUib3Lvu3J4K3QOgSqWOfqeqN1rHzQwwa/Y1T2NznFAJcbvLi16Jz19ZhModwlHlQLMu7MPU58Z7IjOnN2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023899; c=relaxed/simple;
	bh=LkDlwleA1u8Q1XmqWdoF5bIb/qNjAhpIPg3Dgf8Mq18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn0dHmsP5pcb4BTSbBcTQCW9IPURQFChpkXMzq0XpmMWOhMjEJswQlXowMv8oE1u1YGn9Ejy0jDrNYt/2e4wn0nUCTR6O+mzXdz+8tx4Mo1l9QAxfItYh7qnTjEQQswhuyKPhE2ip8aYGv2LkICfXxYIVnZ9tsBi2p5gZgTpcgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4e4De4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4e4De4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924C5C4CEF0;
	Tue, 12 Aug 2025 18:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023899;
	bh=LkDlwleA1u8Q1XmqWdoF5bIb/qNjAhpIPg3Dgf8Mq18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4e4De4fLUha+ZJp9HcCK/M89FNE3w+uv0h7gM9bY6MIYKOi7sAavTRubCTRvWCO4
	 HQuiYr0A98XRBgxt3vQ4DMHij0h8uHM/ZlLDAVf3uyzxKHtnqsAEP9uwosoWr9kTCM
	 9JqNtne9kQnEDkLBZakuPUuNFt+0JeRRJowxUdNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 215/627] sched/deadline: Initialize dl_servers after SMP
Date: Tue, 12 Aug 2025 19:28:30 +0200
Message-ID: <20250812173427.465015936@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 9f239df55546ee1d28f0976130136ffd1cad0fd7 ]

dl-servers are currently initialized too early at boot when CPUs are not
fully up (only boot CPU is). This results in miscalculation of per
runqueue DEADLINE variables like extra_bw (which needs a stable CPU
count).

Move initialization of dl-servers later on after SMP has been
initialized and CPUs are all online, so that CPU count is stable and
DEADLINE variables can be computed correctly.

Fixes: d741f297bceaf ("sched/fair: Fair server interface")
Reported-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Tested-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk> # nuc & rock5b
Link: https://lore.kernel.org/r/20250627115118.438797-2-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c     |  2 ++
 kernel/sched/deadline.c | 48 +++++++++++++++++++++++++----------------
 kernel/sched/sched.h    |  1 +
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 81c6df746df1..deb6a8cce1ab 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8470,6 +8470,8 @@ void __init sched_init_smp(void)
 	init_sched_rt_class();
 	init_sched_dl_class();
 
+	sched_init_dl_servers();
+
 	sched_smp_initialized = true;
 }
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 094134c9b135..ef5b5c045769 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -824,6 +824,8 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
+	update_rq_clock(rq);
+
 	WARN_ON(is_dl_boosted(dl_se));
 	WARN_ON(dl_time_before(rq_clock(rq), dl_se->deadline));
 
@@ -1652,23 +1654,7 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = dl_se->rq;
 
-	/*
-	 * XXX: the apply do not work fine at the init phase for the
-	 * fair server because things are not yet set. We need to improve
-	 * this before getting generic.
-	 */
-	if (!dl_server(dl_se)) {
-		u64 runtime =  50 * NSEC_PER_MSEC;
-		u64 period = 1000 * NSEC_PER_MSEC;
-
-		dl_server_apply_params(dl_se, runtime, period, 1);
-
-		dl_se->dl_server = 1;
-		dl_se->dl_defer = 1;
-		setup_new_dl_entity(dl_se);
-	}
-
-	if (!dl_se->dl_runtime || dl_se->dl_server_active)
+	if (!dl_server(dl_se) || dl_se->dl_server_active)
 		return;
 
 	dl_se->dl_server_active = 1;
@@ -1679,7 +1665,7 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 
 void dl_server_stop(struct sched_dl_entity *dl_se)
 {
-	if (!dl_se->dl_runtime)
+	if (!dl_server(dl_se) || !dl_server_active(dl_se))
 		return;
 
 	dequeue_dl_entity(dl_se, DEQUEUE_SLEEP);
@@ -1712,6 +1698,32 @@ void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
 	dl_se->server_pick_task = pick_task;
 }
 
+void sched_init_dl_servers(void)
+{
+	int cpu;
+	struct rq *rq;
+	struct sched_dl_entity *dl_se;
+
+	for_each_online_cpu(cpu) {
+		u64 runtime =  50 * NSEC_PER_MSEC;
+		u64 period = 1000 * NSEC_PER_MSEC;
+
+		rq = cpu_rq(cpu);
+
+		guard(rq_lock_irq)(rq);
+
+		dl_se = &rq->fair_server;
+
+		WARN_ON(dl_server(dl_se));
+
+		dl_server_apply_params(dl_se, runtime, period, 1);
+
+		dl_se->dl_server = 1;
+		dl_se->dl_defer = 1;
+		setup_new_dl_entity(dl_se);
+	}
+}
+
 void __dl_server_attach_root(struct sched_dl_entity *dl_se, struct rq *rq)
 {
 	u64 new_bw = dl_se->dl_bw;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 83e3aa917142..e8e6011fe0d8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -384,6 +384,7 @@ extern void dl_server_stop(struct sched_dl_entity *dl_se);
 extern void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
 		    dl_server_has_tasks_f has_tasks,
 		    dl_server_pick_f pick_task);
+extern void sched_init_dl_servers(void);
 
 extern void dl_server_update_idle_time(struct rq *rq,
 		    struct task_struct *p);
-- 
2.39.5



