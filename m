Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3963152E12;
	Wed,  5 Feb 2025 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763941; cv=none; b=M58R3eBqkpqsHpV2IKDDUwxQUi+1KGWbqpzxxFv1AFcBMPdTXp/CLpEakJ/gbL9kkrJWEgF4R5//PyXnlvskijHg8XOAx/TFqrU0vbEcn0egWKaJax0uf0VuqOLPkvmf1MR5Y08al1+jpMqizxLdI0EfRXsF4/qV7wV7l0hhXcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763941; c=relaxed/simple;
	bh=Iv6/Z+wddhhStGYQaZoBKC1U29+EiOpYMln+u6Zoqbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4bZCtNxrShnP1NJqyGSvfNcfzX7rDqAxAkKJ8uJzgoqzjeD/anmxfvWGo+wF5BNtnM/bY22EcQ+q5aVUDBDNNx2GbvkjooQQCIlXgyk27DMVB04Yfm6MCp0PB9tgG2nE4DSIgbwigCPHrN1lf5OFx5NjMfHkmI8ccGRxelHqQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xVqL1+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xVqL1+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42683C4CED6;
	Wed,  5 Feb 2025 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763941;
	bh=Iv6/Z+wddhhStGYQaZoBKC1U29+EiOpYMln+u6Zoqbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xVqL1+yrWiAyq7GAnSNkFN6aeeSwZ42J7kf1opieSU7UtZx/uUOzMEKMBjyB6itz
	 EVsU2yDhx/5L3bjBJ+mbTCMwwAevKgzckxAMMrGbUduGApnQ5VqFDx8M2wXP8+rH+6
	 erNDGg0i5OeCrz2Cs1FW0/u/rGj7DYLoPqGGXOkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 032/623] perf/core: Save raw sample data conditionally based on sample type
Date: Wed,  5 Feb 2025 14:36:14 +0100
Message-ID: <20250205134457.456423481@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Yabin Cui <yabinc@google.com>

[ Upstream commit b9c44b91476b67327a521568a854babecc4070ab ]

Currently, space for raw sample data is always allocated within sample
records for both BPF output and tracepoint events. This leads to unused
space in sample records when raw sample data is not requested.

This patch enforces checking sample type of an event in
perf_sample_save_raw_data(). So raw sample data will only be saved if
explicitly requested, reducing overhead when it is not needed.

Fixes: 0a9081cf0a11 ("perf/core: Add perf_sample_save_raw_data() helper")
Signed-off-by: Yabin Cui <yabinc@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240515193610.2350456-2-yabinc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c    |  2 +-
 arch/s390/kernel/perf_pai_crypto.c |  2 +-
 arch/s390/kernel/perf_pai_ext.c    |  2 +-
 arch/x86/events/amd/ibs.c          |  2 +-
 include/linux/perf_event.h         |  6 +++++
 kernel/events/core.c               | 35 +++++++++++++++---------------
 kernel/trace/bpf_trace.c           | 11 +++++-----
 7 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index b0bc68da6a116..33205dd410e47 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -981,7 +981,7 @@ static int cfdiag_push_sample(struct perf_event *event,
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		raw.frag.size = cpuhw->usedss;
 		raw.frag.data = cpuhw->stop;
-		perf_sample_save_raw_data(&data, &raw);
+		perf_sample_save_raw_data(&data, event, &raw);
 	}
 
 	overflow = perf_event_overflow(event, &data, &regs);
diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index fa73254542661..10725f5a6f0fd 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -478,7 +478,7 @@ static int paicrypt_push_sample(size_t rawsize, struct paicrypt_map *cpump,
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		raw.frag.size = rawsize;
 		raw.frag.data = cpump->save;
-		perf_sample_save_raw_data(&data, &raw);
+		perf_sample_save_raw_data(&data, event, &raw);
 	}
 
 	overflow = perf_event_overflow(event, &data, &regs);
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index 7f462bef1fc07..a8f0bad99cf04 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -503,7 +503,7 @@ static int paiext_push_sample(size_t rawsize, struct paiext_map *cpump,
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		raw.frag.size = rawsize;
 		raw.frag.data = cpump->save;
-		perf_sample_save_raw_data(&data, &raw);
+		perf_sample_save_raw_data(&data, event, &raw);
 	}
 
 	overflow = perf_event_overflow(event, &data, &regs);
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index e91970b01d624..c3a2f6f57770a 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1118,7 +1118,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 				.data = ibs_data.data,
 			},
 		};
-		perf_sample_save_raw_data(&data, &raw);
+		perf_sample_save_raw_data(&data, event, &raw);
 	}
 
 	if (perf_ibs == &perf_ibs_op)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cb99ec8c9e96f..f7c0a3f2f502d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1287,12 +1287,18 @@ static inline void perf_sample_save_callchain(struct perf_sample_data *data,
 }
 
 static inline void perf_sample_save_raw_data(struct perf_sample_data *data,
+					     struct perf_event *event,
 					     struct perf_raw_record *raw)
 {
 	struct perf_raw_frag *frag = &raw->frag;
 	u32 sum = 0;
 	int size;
 
+	if (!(event->attr.sample_type & PERF_SAMPLE_RAW))
+		return;
+	if (WARN_ON_ONCE(data->sample_flags & PERF_SAMPLE_RAW))
+		return;
+
 	do {
 		sum += frag->size;
 		if (perf_raw_frag_last(frag))
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 065f9188b44a0..e9f698c08dc17 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10425,9 +10425,9 @@ static struct pmu perf_tracepoint = {
 };
 
 static int perf_tp_filter_match(struct perf_event *event,
-				struct perf_sample_data *data)
+				struct perf_raw_record *raw)
 {
-	void *record = data->raw->frag.data;
+	void *record = raw->frag.data;
 
 	/* only top level events have filters set */
 	if (event->parent)
@@ -10439,7 +10439,7 @@ static int perf_tp_filter_match(struct perf_event *event,
 }
 
 static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data,
+				struct perf_raw_record *raw,
 				struct pt_regs *regs)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
@@ -10450,7 +10450,7 @@ static int perf_tp_event_match(struct perf_event *event,
 	if (event->attr.exclude_kernel && !user_mode(regs))
 		return 0;
 
-	if (!perf_tp_filter_match(event, data))
+	if (!perf_tp_filter_match(event, raw))
 		return 0;
 
 	return 1;
@@ -10476,6 +10476,7 @@ EXPORT_SYMBOL_GPL(perf_trace_run_bpf_submit);
 static void __perf_tp_event_target_task(u64 count, void *record,
 					struct pt_regs *regs,
 					struct perf_sample_data *data,
+					struct perf_raw_record *raw,
 					struct perf_event *event)
 {
 	struct trace_entry *entry = record;
@@ -10485,13 +10486,17 @@ static void __perf_tp_event_target_task(u64 count, void *record,
 	/* Cannot deliver synchronous signal to other task. */
 	if (event->attr.sigtrap)
 		return;
-	if (perf_tp_event_match(event, data, regs))
+	if (perf_tp_event_match(event, raw, regs)) {
+		perf_sample_data_init(data, 0, 0);
+		perf_sample_save_raw_data(data, event, raw);
 		perf_swevent_event(event, count, data, regs);
+	}
 }
 
 static void perf_tp_event_target_task(u64 count, void *record,
 				      struct pt_regs *regs,
 				      struct perf_sample_data *data,
+				      struct perf_raw_record *raw,
 				      struct perf_event_context *ctx)
 {
 	unsigned int cpu = smp_processor_id();
@@ -10499,15 +10504,15 @@ static void perf_tp_event_target_task(u64 count, void *record,
 	struct perf_event *event, *sibling;
 
 	perf_event_groups_for_cpu_pmu(event, &ctx->pinned_groups, cpu, pmu) {
-		__perf_tp_event_target_task(count, record, regs, data, event);
+		__perf_tp_event_target_task(count, record, regs, data, raw, event);
 		for_each_sibling_event(sibling, event)
-			__perf_tp_event_target_task(count, record, regs, data, sibling);
+			__perf_tp_event_target_task(count, record, regs, data, raw, sibling);
 	}
 
 	perf_event_groups_for_cpu_pmu(event, &ctx->flexible_groups, cpu, pmu) {
-		__perf_tp_event_target_task(count, record, regs, data, event);
+		__perf_tp_event_target_task(count, record, regs, data, raw, event);
 		for_each_sibling_event(sibling, event)
-			__perf_tp_event_target_task(count, record, regs, data, sibling);
+			__perf_tp_event_target_task(count, record, regs, data, raw, sibling);
 	}
 }
 
@@ -10525,15 +10530,10 @@ void perf_tp_event(u16 event_type, u64 count, void *record, int entry_size,
 		},
 	};
 
-	perf_sample_data_init(&data, 0, 0);
-	perf_sample_save_raw_data(&data, &raw);
-
 	perf_trace_buf_update(record, event_type);
 
 	hlist_for_each_entry_rcu(event, head, hlist_entry) {
-		if (perf_tp_event_match(event, &data, regs)) {
-			perf_swevent_event(event, count, &data, regs);
-
+		if (perf_tp_event_match(event, &raw, regs)) {
 			/*
 			 * Here use the same on-stack perf_sample_data,
 			 * some members in data are event-specific and
@@ -10543,7 +10543,8 @@ void perf_tp_event(u16 event_type, u64 count, void *record, int entry_size,
 			 * because data->sample_flags is set.
 			 */
 			perf_sample_data_init(&data, 0, 0);
-			perf_sample_save_raw_data(&data, &raw);
+			perf_sample_save_raw_data(&data, event, &raw);
+			perf_swevent_event(event, count, &data, regs);
 		}
 	}
 
@@ -10560,7 +10561,7 @@ void perf_tp_event(u16 event_type, u64 count, void *record, int entry_size,
 			goto unlock;
 
 		raw_spin_lock(&ctx->lock);
-		perf_tp_event_target_task(count, record, regs, &data, ctx);
+		perf_tp_event_target_task(count, record, regs, &data, &raw, ctx);
 		raw_spin_unlock(&ctx->lock);
 unlock:
 		rcu_read_unlock();
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1b8db5aee9d38..9f2f65767639d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -619,7 +619,8 @@ static const struct bpf_func_proto bpf_perf_event_read_value_proto = {
 
 static __always_inline u64
 __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
-			u64 flags, struct perf_sample_data *sd)
+			u64 flags, struct perf_raw_record *raw,
+			struct perf_sample_data *sd)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	unsigned int cpu = smp_processor_id();
@@ -644,6 +645,8 @@ __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
 	if (unlikely(event->oncpu != cpu))
 		return -EOPNOTSUPP;
 
+	perf_sample_save_raw_data(sd, event, raw);
+
 	return perf_event_output(event, sd, regs);
 }
 
@@ -687,9 +690,8 @@ BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, regs, struct bpf_map *, map,
 	}
 
 	perf_sample_data_init(sd, 0, 0);
-	perf_sample_save_raw_data(sd, &raw);
 
-	err = __bpf_perf_event_output(regs, map, flags, sd);
+	err = __bpf_perf_event_output(regs, map, flags, &raw, sd);
 out:
 	this_cpu_dec(bpf_trace_nest_level);
 	preempt_enable();
@@ -748,9 +750,8 @@ u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 
 	perf_fetch_caller_regs(regs);
 	perf_sample_data_init(sd, 0, 0);
-	perf_sample_save_raw_data(sd, &raw);
 
-	ret = __bpf_perf_event_output(regs, map, flags, sd);
+	ret = __bpf_perf_event_output(regs, map, flags, &raw, sd);
 out:
 	this_cpu_dec(bpf_event_output_nest_level);
 	preempt_enable();
-- 
2.39.5



