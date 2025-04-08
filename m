Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A888268684;
	Tue,  8 Apr 2025 11:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110498; cv=none; b=qz5cxqT2SpbuchJaQ7Npaakht3ZNF50Nq3N+WUKim7ZBN7UE6a3Qmuu94JDbO92yckafjBhsGfFNW1ibeF2I8K191M6nSelNNI2YZ6jr4PFWwCXe89Az0ztqvjy0GDYAqT9c/dPjzuMPZCWti3wQVvxRaYlTtCLSDnhfMrRiQO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110498; c=relaxed/simple;
	bh=LVrtjZag+AxtkOhnfr+h/uQJy/jZbJAInZAXI8NETfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVdJFLHFD5f9zGFMqVMxdEHke7VZfkl3qhOgKQ1l735pRhuKIR9ANNgo7dvLmdMmoVY8fTWtbREqK+z6BBUm3fN7o3+1Q144emB4i2W+V0ooj9/iUlp1tSkL4EwPJDaJxtFTy0zkrTlXID1Bl/eVe+xAl7OFYIA2hOMxxEblAJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haMS1KyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haMS1KyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1159C4CEEA;
	Tue,  8 Apr 2025 11:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110498;
	bh=LVrtjZag+AxtkOhnfr+h/uQJy/jZbJAInZAXI8NETfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haMS1KySuIMWc8LkwEG8YN992k79Sq9rvlBcDY9GnvyF0TQUeMUGeG+7Vwxxieu8D
	 l/rVhwziA1QVRsPSm2U0jv9Qc+EYYsc2ww8dzDH0AiCccTmup9GyVFYkj8w0WQmk6X
	 gnKk7PITwNMe479trvQTCarCum7EppjaXdssfo7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 046/731] perf: Save PMU specific data in task_struct
Date: Tue,  8 Apr 2025 12:39:03 +0200
Message-ID: <20250408104915.346439271@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit cb4369129339060218baca718a578bb0b826e734 ]

Some PMU specific data has to be saved/restored during context switch,
e.g. LBR call stack data. Currently, the data is saved in event context
structure, but only for per-process event. For system-wide event,
because of missing the LBR call stack data after context switch, LBR
callstacks are always shorter in comparison to per-process mode.

For example,
  Per-process mode:
  $perf record --call-graph lbr -- taskset -c 0 ./tchain_edit

  -   99.90%    99.86%  tchain_edit  tchain_edit       [.] f3
       99.86% _start
          __libc_start_main
          generic_start_main
          main
          f1
        - f2
             f3

  System-wide mode:
  $perf record --call-graph lbr -a -- taskset -c 0 ./tchain_edit

  -   99.88%    99.82%  tchain_edit  tchain_edit        [.] f3
   - 62.02% main
        f1
        f2
        f3
   - 28.83% f1
      - f2
        f3
   - 28.83% f1
      - f2
           f3
   - 8.88% generic_start_main
        main
        f1
        f2
        f3

It isn't practical to simply allocate the data for system-wide event in
CPU context structure for all tasks. We have no idea which CPU a task
will be scheduled to. The duplicated LBR data has to be maintained on
every CPU context structure. That's a huge waste. Otherwise, the LBR
data still lost if the task is scheduled to another CPU.

Save the pmu specific data in task_struct. The size of pmu specific data
is 788 bytes for LBR call stack. Usually, the overall amount of threads
doesn't exceed a few thousands. For 10K threads, keeping LBR data would
consume additional ~8MB. The additional space will only be allocated
during LBR call stack monitoring. It will be released when the
monitoring is finished.

Furthermore, moving task_ctx_data from perf_event_context to task_struct
can reduce complexity and make things clearer. E.g. perf doesn't need to
swap task_ctx_data on optimized context switch path.
This patch set is just the first step. There could be other
optimization/extension on top of this patch set. E.g. for cgroup
profiling, perf just needs to save/store the LBR call stack information
for tasks in specific cgroup. That could reduce the additional space.
Also, the LBR call stack can be available for software events, or allow
even debugging use cases, like LBRs on crash later.

Because of the alignment requirement of Intel Arch LBR, the Kmem cache
is used to allocate the PMU specific data. It's required when child task
allocates the space. Save it in struct perf_ctx_data.
The refcount in struct perf_ctx_data is used to track the users of pmu
specific data.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Alexey Budankov <alexey.budankov@linux.intel.com>
Link: https://lore.kernel.org/r/20250314172700.438923-1-kan.liang@linux.intel.com
Stable-dep-of: 3cec9fd03543 ("perf/x86/lbr: Fix shorter LBRs call stacks for the system-wide mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h | 35 +++++++++++++++++++++++++++++++++++
 include/linux/sched.h      |  2 ++
 kernel/events/core.c       |  1 +
 3 files changed, 38 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8333f132f4a96..852ea843bca27 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1020,6 +1020,41 @@ struct perf_event_context {
 	local_t				nr_no_switch_fast;
 };
 
+/**
+ * struct perf_ctx_data - PMU specific data for a task
+ * @rcu_head:  To avoid the race on free PMU specific data
+ * @refcount:  To track users
+ * @global:    To track system-wide users
+ * @ctx_cache: Kmem cache of PMU specific data
+ * @data:      PMU specific data
+ *
+ * Currently, the struct is only used in Intel LBR call stack mode to
+ * save/restore the call stack of a task on context switches.
+ *
+ * The rcu_head is used to prevent the race on free the data.
+ * The data only be allocated when Intel LBR call stack mode is enabled.
+ * The data will be freed when the mode is disabled.
+ * The content of the data will only be accessed in context switch, which
+ * should be protected by rcu_read_lock().
+ *
+ * Because of the alignment requirement of Intel Arch LBR, the Kmem cache
+ * is used to allocate the PMU specific data. The ctx_cache is to track
+ * the Kmem cache.
+ *
+ * Careful: Struct perf_ctx_data is added as a pointer in struct task_struct.
+ * When system-wide Intel LBR call stack mode is enabled, a buffer with
+ * constant size will be allocated for each task.
+ * Also, system memory consumption can further grow when the size of
+ * struct perf_ctx_data enlarges.
+ */
+struct perf_ctx_data {
+	struct rcu_head			rcu_head;
+	refcount_t			refcount;
+	int				global;
+	struct kmem_cache		*ctx_cache;
+	void				*data;
+};
+
 struct perf_cpu_pmu_context {
 	struct perf_event_pmu_context	epc;
 	struct perf_event_pmu_context	*task_epc;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9c15365a30c08..b13c9545d5d67 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -65,6 +65,7 @@ struct mempolicy;
 struct nameidata;
 struct nsproxy;
 struct perf_event_context;
+struct perf_ctx_data;
 struct pid_namespace;
 struct pipe_inode_info;
 struct rcu_node;
@@ -1311,6 +1312,7 @@ struct task_struct {
 	struct perf_event_context	*perf_event_ctxp;
 	struct mutex			perf_event_mutex;
 	struct list_head		perf_event_list;
+	struct perf_ctx_data __rcu	*perf_ctx_data;
 #endif
 #ifdef CONFIG_DEBUG_PREEMPT
 	unsigned long			preempt_disable_ip;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 823aa08249161..eb359be7ec793 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -14002,6 +14002,7 @@ int perf_event_init_task(struct task_struct *child, u64 clone_flags)
 	child->perf_event_ctxp = NULL;
 	mutex_init(&child->perf_event_mutex);
 	INIT_LIST_HEAD(&child->perf_event_list);
+	child->perf_ctx_data = NULL;
 
 	ret = perf_event_init_context(child, clone_flags);
 	if (ret) {
-- 
2.39.5



