Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EB51E1A3B;
	Wed, 19 Feb 2025 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954633; cv=none; b=ELzQFFiXf2OV8xHIgBQ6mbD5GLlvgGJJfWshBN24Go52g4/y1O568oBsYJHFJpY2UfsEQO6vfDgCV5PaPWWvU0Ds+DWz8UtUDdJJCgkD5PVNRshIGiywXpz4FOP0qjvg0625kDhNh7aQKSD9MNPu88YZqohMfqcEOkbIwgw1xRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954633; c=relaxed/simple;
	bh=ZlvBYxZu65cRF9O+xLk543K37Ie6geiIRqqJRjuRZiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXTXHntgQGmev9ANJlEmxbMQTlp+DN/4E9YyhyWG9XjgRhSECK7dCzBCgwNqqzOnaK+6adWktgF9uHbvPO2BYnEkLLN5jGDp8n8FwhkZsRP1Q4/MWRz5K24THFTXcUGQSx8TyJLoZ+floDQ6kB3ipMDJR10S+026FLwLFBKdLMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3kn2grg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3kn2grg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB8DC4CEE6;
	Wed, 19 Feb 2025 08:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954632;
	bh=ZlvBYxZu65cRF9O+xLk543K37Ie6geiIRqqJRjuRZiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3kn2grgeQVB1byiwP+XU1/lD3JEKTqHdKVMtx4rpCEWnvnH60VjSPUH1v83SkUUR
	 iWP9R2wrVmBq1CF5VjxhqrYXz6LH2wavBqcfVxZR9/ADUke8RbKzIkaojkZ9tQCLNI
	 ftWZSmIOe9iGCBiNUQJSEnK6mXI6hd9p5i6Ug7u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.13 264/274] sched/deadline: Correctly account for allocated bandwidth during hotplug
Date: Wed, 19 Feb 2025 09:28:38 +0100
Message-ID: <20250219082619.919350133@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

commit d4742f6ed7ea6df56e381f82ba4532245fa1e561 upstream.

For hotplug operations, DEADLINE needs to check that there is still enough
bandwidth left after removing the CPU that is going offline. We however
fail to do so currently.

Restore the correct behavior by restructuring dl_bw_manage() a bit, so
that overflow conditions (not enough bandwidth left) are properly
checked. Also account for dl_server bandwidth, i.e. discount such
bandwidth in the calculation since NORMAL tasks will be anyway moved
away from the CPU as a result of the hotplug operation.

Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Tested-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20241114142810.794657-3-juri.lelli@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c     |    2 +-
 kernel/sched/deadline.c |   48 +++++++++++++++++++++++++++++++++++++++---------
 kernel/sched/sched.h    |    2 +-
 3 files changed, 41 insertions(+), 11 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8185,7 +8185,7 @@ static void cpuset_cpu_active(void)
 static int cpuset_cpu_inactive(unsigned int cpu)
 {
 	if (!cpuhp_tasks_frozen) {
-		int ret = dl_bw_check_overflow(cpu);
+		int ret = dl_bw_deactivate(cpu);
 
 		if (ret)
 			return ret;
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3464,29 +3464,31 @@ int dl_cpuset_cpumask_can_shrink(const s
 }
 
 enum dl_bw_request {
-	dl_bw_req_check_overflow = 0,
+	dl_bw_req_deactivate = 0,
 	dl_bw_req_alloc,
 	dl_bw_req_free
 };
 
 static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 {
-	unsigned long flags;
+	unsigned long flags, cap;
 	struct dl_bw *dl_b;
 	bool overflow = 0;
+	u64 fair_server_bw = 0;
 
 	rcu_read_lock_sched();
 	dl_b = dl_bw_of(cpu);
 	raw_spin_lock_irqsave(&dl_b->lock, flags);
 
-	if (req == dl_bw_req_free) {
+	cap = dl_bw_capacity(cpu);
+	switch (req) {
+	case dl_bw_req_free:
 		__dl_sub(dl_b, dl_bw, dl_bw_cpus(cpu));
-	} else {
-		unsigned long cap = dl_bw_capacity(cpu);
-
+		break;
+	case dl_bw_req_alloc:
 		overflow = __dl_overflow(dl_b, cap, 0, dl_bw);
 
-		if (req == dl_bw_req_alloc && !overflow) {
+		if (!overflow) {
 			/*
 			 * We reserve space in the destination
 			 * root_domain, as we can't fail after this point.
@@ -3495,6 +3497,34 @@ static int dl_bw_manage(enum dl_bw_reque
 			 */
 			__dl_add(dl_b, dl_bw, dl_bw_cpus(cpu));
 		}
+		break;
+	case dl_bw_req_deactivate:
+		/*
+		 * cpu is going offline and NORMAL tasks will be moved away
+		 * from it. We can thus discount dl_server bandwidth
+		 * contribution as it won't need to be servicing tasks after
+		 * the cpu is off.
+		 */
+		if (cpu_rq(cpu)->fair_server.dl_server)
+			fair_server_bw = cpu_rq(cpu)->fair_server.dl_bw;
+
+		/*
+		 * Not much to check if no DEADLINE bandwidth is present.
+		 * dl_servers we can discount, as tasks will be moved out the
+		 * offlined CPUs anyway.
+		 */
+		if (dl_b->total_bw - fair_server_bw > 0) {
+			/*
+			 * Leaving at least one CPU for DEADLINE tasks seems a
+			 * wise thing to do.
+			 */
+			if (dl_bw_cpus(cpu))
+				overflow = __dl_overflow(dl_b, cap, fair_server_bw, 0);
+			else
+				overflow = 1;
+		}
+
+		break;
 	}
 
 	raw_spin_unlock_irqrestore(&dl_b->lock, flags);
@@ -3503,9 +3533,9 @@ static int dl_bw_manage(enum dl_bw_reque
 	return overflow ? -EBUSY : 0;
 }
 
-int dl_bw_check_overflow(int cpu)
+int dl_bw_deactivate(int cpu)
 {
-	return dl_bw_manage(dl_bw_req_check_overflow, cpu, 0);
+	return dl_bw_manage(dl_bw_req_deactivate, cpu, 0);
 }
 
 int dl_bw_alloc(int cpu, u64 dl_bw)
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -362,7 +362,7 @@ extern void __getparam_dl(struct task_st
 extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
-extern int  dl_bw_check_overflow(int cpu);
+extern int  dl_bw_deactivate(int cpu);
 extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec);
 /*
  * SCHED_DEADLINE supports servers (nested scheduling) with the following


