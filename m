Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B1747045A;
	Tue, 21 Jul 2026 19:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662419; cv=none; b=CgX4DGd01+HzVBW+/EPHz40WTQpsH6JfcjTHYSEXKrE2dECPrt1sNCXYwUrGCT/xXFMVhUxzVyCb8cEZJJ4uGZloHZzhe5X9adBPt5qgwaiJDkHveVFbOvV8xhHJTzcrt+KSX+wh8Wc1on02YeoYxGp88G13whOtkbGUtYUQw5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662419; c=relaxed/simple;
	bh=8VUDYsnwYQMsrcDOxjdzAPsbK+CXzAxTts9dzfeZ1oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYNLywf1KsLfyaDJQe+pI1LjbQNtg9Hyrn+0Dkw0HcU4NRfJ7rUbmSIDtFpLHnHC0puoPWSxk7BPp19Jyc1k8GsceVkyhi7lEXS7cDQC/+0yekApUiWP5BJwa5qX4Gf+TP2oZLto7DugTGV0m5Az4sjVnIY4DIsBLsusmwaeN18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHcmG/X0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHcmG/X0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0285E1F000E9;
	Tue, 21 Jul 2026 19:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662417;
	bh=8yXtihT/KqajvVvAhOlD/8zbWTyzP4KtoZY1g1U0L0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHcmG/X00TQZXe46e4/3eWSWVgqvQm/uXPxFPGq06eUog3BbGiWqOjDWE95ZPASOm
	 invv9c5FItsYFoVklbzWK8Q/TMoKET0eb3LL3wHgw1duDSPActCfy2ryZIkVn+LbfF
	 DE+T3ohk9bShz/rmIGkG8NaHmYsQWGaMcNx6XWOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0437/1276] perf event: Fix size of synthesized sample with branch stacks
Date: Tue, 21 Jul 2026 17:14:40 +0200
Message-ID: <20260721152455.881575358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 059e9100d82aae2254f1b06835a55755936b1417 ]

Synthesizing branch stacks for Intel-PT highlighted an issue where
PERF_SAMPLE_BRANCH_HW_INDEX was assumed to always be set in the
perf_event_attr branch_sample_type. This caused an incorrect size
calculation.

Fix the writing of the nr and hw_idx values during sample event
synthesis by passing the branch_sample_type into the sample size
and synthesis functions. Also update hardware tracers (Intel PT,
ARM SPE, CS-ETM) to retrieve and pass their branch_sample_type
dynamically to prevent payload misalignment.

Fixes: d3f85437ad6a5511 ("perf evsel: Support PERF_SAMPLE_BRANCH_HW_INDEX")
Assisted-by: Gemini:gemini-3.1-pro-preview
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/inject-buildid.c  |  9 ++++++---
 tools/perf/builtin-inject.c        | 12 +++++++++---
 tools/perf/tests/dlfilter-test.c   |  8 ++++++--
 tools/perf/tests/sample-parsing.c  |  5 +++--
 tools/perf/util/arm-spe.c          | 28 ++++++++++++++++++++++++----
 tools/perf/util/cs-etm.c           | 28 +++++++++++++++++++++++-----
 tools/perf/util/intel-bts.c        |  3 ++-
 tools/perf/util/intel-pt.c         | 27 +++++++++++++++++++++++----
 tools/perf/util/synthetic-events.c | 25 ++++++++++++++++++-------
 tools/perf/util/synthetic-events.h |  6 ++++--
 10 files changed, 118 insertions(+), 33 deletions(-)

diff --git a/tools/perf/bench/inject-buildid.c b/tools/perf/bench/inject-buildid.c
index a759eb2328bead..a77957b4697a9e 100644
--- a/tools/perf/bench/inject-buildid.c
+++ b/tools/perf/bench/inject-buildid.c
@@ -228,9 +228,12 @@ static ssize_t synthesize_sample(struct bench_data *data, struct bench_dso *dso,
 
 	event.header.type = PERF_RECORD_SAMPLE;
 	event.header.misc = PERF_RECORD_MISC_USER;
-	event.header.size = perf_event__sample_event_size(&sample, bench_sample_type, 0);
-
-	perf_event__synthesize_sample(&event, bench_sample_type, 0, &sample);
+	event.header.size = perf_event__sample_event_size(&sample, bench_sample_type,
+							   /*read_format=*/0,
+							   /*branch_sample_type=*/0);
+	perf_event__synthesize_sample(&event, bench_sample_type,
+				      /*read_format=*/0,
+				      /*branch_sample_type=*/0, &sample);
 
 	return writen(data->input_pipe[1], &event, event.header.size);
 }
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 241d7e36914872..82683a57ad6c13 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -477,8 +477,13 @@ static int perf_event__convert_sample_callchain(const struct perf_tool *tool,
 	/* remove sample_type {STACK,REGS}_USER for synthesize */
 	sample_type &= ~(PERF_SAMPLE_STACK_USER | PERF_SAMPLE_REGS_USER);
 
-	perf_event__synthesize_sample(event_copy, sample_type,
-				      evsel->core.attr.read_format, sample);
+	ret = perf_event__synthesize_sample(event_copy, sample_type,
+					    evsel->core.attr.read_format,
+					    evsel->core.attr.branch_sample_type, sample);
+	if (ret) {
+		pr_err("Failed to synthesize sample\n");
+		return ret;
+	}
 	return perf_event__repipe_synth(tool, event_copy);
 }
 
@@ -1107,7 +1112,8 @@ static int perf_inject__sched_stat(const struct perf_tool *tool,
 	sample_sw.period = sample->period;
 	sample_sw.time	 = sample->time;
 	perf_event__synthesize_sample(event_sw, evsel->core.attr.sample_type,
-				      evsel->core.attr.read_format, &sample_sw);
+				      evsel->core.attr.read_format,
+				      evsel->core.attr.branch_sample_type, &sample_sw);
 	build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
 	return perf_event__repipe(tool, event_sw, &sample_sw, machine);
 }
diff --git a/tools/perf/tests/dlfilter-test.c b/tools/perf/tests/dlfilter-test.c
index 54f59d1246bc53..1e75c5441f48fc 100644
--- a/tools/perf/tests/dlfilter-test.c
+++ b/tools/perf/tests/dlfilter-test.c
@@ -189,8 +189,12 @@ static int write_sample(struct test_data *td, u64 sample_type, u64 id, pid_t pid
 
 	event->header.type = PERF_RECORD_SAMPLE;
 	event->header.misc = PERF_RECORD_MISC_USER;
-	event->header.size = perf_event__sample_event_size(&sample, sample_type, 0);
-	err = perf_event__synthesize_sample(event, sample_type, 0, &sample);
+	event->header.size = perf_event__sample_event_size(&sample, sample_type,
+							   /*read_format=*/0,
+							   /*branch_sample_type=*/0);
+	err = perf_event__synthesize_sample(event, sample_type,
+					    /*read_format=*/0,
+					    /*branch_sample_type=*/0, &sample);
 	if (err)
 		return test_result("perf_event__synthesize_sample() failed", TEST_FAIL);
 
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 25a3f6cece5054..64744f678705d7 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -294,7 +294,8 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
 		sample.read.one.lost  = 1;
 	}
 
-	sz = perf_event__sample_event_size(&sample, sample_type, read_format);
+	sz = perf_event__sample_event_size(&sample, sample_type, read_format,
+					   evsel.core.attr.branch_sample_type);
 	bufsz = sz + 4096; /* Add a bit for overrun checking */
 	event = malloc(bufsz);
 	if (!event) {
@@ -308,7 +309,7 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
 	event->header.size = sz;
 
 	err = perf_event__synthesize_sample(event, sample_type, read_format,
-					    &sample);
+					    evsel.core.attr.branch_sample_type, &sample);
 	if (err) {
 		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
 			 "perf_event__synthesize_sample", sample_type, err);
diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 80fcb8b10f52e4..a63ff5ff364502 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -411,10 +411,30 @@ static void arm_spe__prep_branch_stack(struct arm_spe_queue *speq)
 	bstack->hw_idx = -1ULL;
 }
 
-static int arm_spe__inject_event(union perf_event *event, struct perf_sample *sample, u64 type)
+static int arm_spe__inject_event(struct arm_spe *spe, union perf_event *event,
+				 struct perf_sample *sample, u64 type)
 {
-	event->header.size = perf_event__sample_event_size(sample, type, 0);
-	return perf_event__synthesize_sample(event, type, 0, sample);
+	struct evsel *evsel = sample->evsel;
+	u64 branch_sample_type = 0;
+	size_t sz;
+
+	if (!evsel && spe->session && spe->session->evlist)
+		evsel = evlist__id2evsel(spe->session->evlist, sample->id);
+
+	if (evsel)
+		branch_sample_type = evsel->core.attr.branch_sample_type;
+
+	event->header.type = PERF_RECORD_SAMPLE;
+	sz = perf_event__sample_event_size(sample, type, /*read_format=*/0,
+					   branch_sample_type);
+	if (sz >= PERF_SAMPLE_MAX_SIZE) {
+		pr_err("Sample size %zu exceeds max size %d\n", sz, PERF_SAMPLE_MAX_SIZE);
+		return -EFAULT;
+	}
+	event->header.size = sz;
+
+	return perf_event__synthesize_sample(event, type, /*read_format=*/0,
+					     branch_sample_type, sample);
 }
 
 static inline int
@@ -426,7 +446,7 @@ arm_spe_deliver_synth_event(struct arm_spe *spe,
 	int ret;
 
 	if (spe->synth_opts.inject) {
-		ret = arm_spe__inject_event(event, sample, spe->sample_type);
+		ret = arm_spe__inject_event(spe, event, sample, spe->sample_type);
 		if (ret)
 			return ret;
 	}
diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 0bf9e5c27b599b..51994ccbfbcb52 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1416,11 +1416,29 @@ static void cs_etm__update_last_branch_rb(struct cs_etm_queue *etmq,
 		bs->nr += 1;
 }
 
-static int cs_etm__inject_event(union perf_event *event,
+static int cs_etm__inject_event(struct cs_etm_auxtrace *etm, union perf_event *event,
 			       struct perf_sample *sample, u64 type)
 {
-	event->header.size = perf_event__sample_event_size(sample, type, 0);
-	return perf_event__synthesize_sample(event, type, 0, sample);
+	struct evsel *evsel = sample->evsel;
+	u64 branch_sample_type = 0;
+	size_t sz;
+
+	if (!evsel && etm->session && etm->session->evlist)
+		evsel = evlist__id2evsel(etm->session->evlist, sample->id);
+
+	if (evsel)
+		branch_sample_type = evsel->core.attr.branch_sample_type;
+
+	sz = perf_event__sample_event_size(sample, type, /*read_format=*/0,
+					   branch_sample_type);
+	if (sz >= PERF_SAMPLE_MAX_SIZE) {
+		pr_err("Sample size %zu exceeds max size %d\n", sz, PERF_SAMPLE_MAX_SIZE);
+		return -EFAULT;
+	}
+	event->header.size = sz;
+
+	return perf_event__synthesize_sample(event, type, /*read_format=*/0,
+					     branch_sample_type, sample);
 }
 
 
@@ -1585,7 +1603,7 @@ static int cs_etm__synth_instruction_sample(struct cs_etm_queue *etmq,
 		sample.branch_stack = tidq->last_branch;
 
 	if (etm->synth_opts.inject) {
-		ret = cs_etm__inject_event(event, &sample,
+		ret = cs_etm__inject_event(etm, event, &sample,
 					   etm->instructions_sample_type);
 		if (ret)
 			return ret;
@@ -1659,7 +1677,7 @@ static int cs_etm__synth_branch_sample(struct cs_etm_queue *etmq,
 	}
 
 	if (etm->synth_opts.inject) {
-		ret = cs_etm__inject_event(event, &sample,
+		ret = cs_etm__inject_event(etm, event, &sample,
 					   etm->branches_sample_type);
 		if (ret)
 			return ret;
diff --git a/tools/perf/util/intel-bts.c b/tools/perf/util/intel-bts.c
index 27d9b5c9fec8be..7f50351fada2ef 100644
--- a/tools/perf/util/intel-bts.c
+++ b/tools/perf/util/intel-bts.c
@@ -302,7 +302,8 @@ static int intel_bts_synth_branch_sample(struct intel_bts_queue *btsq,
 		event.sample.header.size = bts->branches_event_size;
 		ret = perf_event__synthesize_sample(&event,
 						    bts->branches_sample_type,
-						    0, &sample);
+						    /*read_format=*/0, /*branch_sample_type=*/0,
+						    &sample);
 		if (ret)
 			return ret;
 	}
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 61f10578e12121..627ff17e9b6615 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -1728,11 +1728,30 @@ static void intel_pt_prep_b_sample(struct intel_pt *pt,
 	event->sample.header.misc = sample->cpumode;
 }
 
-static int intel_pt_inject_event(union perf_event *event,
+static int intel_pt_inject_event(struct intel_pt *pt, union perf_event *event,
 				 struct perf_sample *sample, u64 type)
 {
-	event->header.size = perf_event__sample_event_size(sample, type, 0);
-	return perf_event__synthesize_sample(event, type, 0, sample);
+	struct evsel *evsel = sample->evsel;
+	u64 branch_sample_type = 0;
+	size_t sz;
+
+	if (!evsel && pt->session && pt->session->evlist)
+		evsel = evlist__id2evsel(pt->session->evlist, sample->id);
+
+	if (evsel)
+		branch_sample_type = evsel->core.attr.branch_sample_type;
+
+	event->header.type = PERF_RECORD_SAMPLE;
+	sz = perf_event__sample_event_size(sample, type, /*read_format=*/0,
+					   branch_sample_type);
+	if (sz >= PERF_SAMPLE_MAX_SIZE) {
+		pr_err("Sample size %zu exceeds max size %d\n", sz, PERF_SAMPLE_MAX_SIZE);
+		return -EFAULT;
+	}
+	event->header.size = sz;
+
+	return perf_event__synthesize_sample(event, type, /*read_format=*/0,
+					     branch_sample_type, sample);
 }
 
 static inline int intel_pt_opt_inject(struct intel_pt *pt,
@@ -1742,7 +1761,7 @@ static inline int intel_pt_opt_inject(struct intel_pt *pt,
 	if (!pt->synth_opts.inject)
 		return 0;
 
-	return intel_pt_inject_event(event, sample, type);
+	return intel_pt_inject_event(pt, event, sample, type);
 }
 
 static int intel_pt_deliver_synth_event(struct intel_pt *pt,
diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index a58444c4aed1f1..ef9ad891ef09b5 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1442,7 +1442,8 @@ int perf_event__synthesize_stat_round(const struct perf_tool *tool,
 	return process(tool, (union perf_event *) &event, NULL, machine);
 }
 
-size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type, u64 read_format)
+size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type, u64 read_format,
+				     u64 branch_sample_type)
 {
 	size_t sz, result = sizeof(struct perf_record_sample);
 
@@ -1502,8 +1503,10 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
 		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
-		/* nr, hw_idx */
-		sz += 2 * sizeof(u64);
+		/* nr */
+		sz += sizeof(u64);
+		if (branch_sample_type & PERF_SAMPLE_BRANCH_HW_INDEX)
+			sz += sizeof(u64);
 		result += sz;
 	}
 
@@ -1586,7 +1589,7 @@ static __u64 *copy_read_group_values(__u64 *array, __u64 read_format,
 }
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type, u64 read_format,
-				  const struct perf_sample *sample)
+				  u64 branch_sample_type, const struct perf_sample *sample)
 {
 	__u64 *array;
 	size_t sz;
@@ -1696,9 +1699,17 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type, u64 read_fo
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
 		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
-		/* nr, hw_idx */
-		sz += 2 * sizeof(u64);
-		memcpy(array, sample->branch_stack, sz);
+
+		*array++ = sample->branch_stack->nr;
+
+		if (branch_sample_type & PERF_SAMPLE_BRANCH_HW_INDEX) {
+			if (sample->no_hw_idx)
+				*array++ = 0;
+			else
+				*array++ = sample->branch_stack->hw_idx;
+		}
+
+		memcpy(array, perf_sample__branch_entries((struct perf_sample *)sample), sz);
 		array = (void *)array + sz;
 	}
 
diff --git a/tools/perf/util/synthetic-events.h b/tools/perf/util/synthetic-events.h
index b9c936b5cfeb9c..ae989b76cb8e4c 100644
--- a/tools/perf/util/synthetic-events.h
+++ b/tools/perf/util/synthetic-events.h
@@ -81,7 +81,8 @@ int perf_event__synthesize_mmap_events(const struct perf_tool *tool, union perf_
 int perf_event__synthesize_modules(const struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
 int perf_event__synthesize_namespaces(const struct perf_tool *tool, union perf_event *event, pid_t pid, pid_t tgid, perf_event__handler_t process, struct machine *machine);
 int perf_event__synthesize_cgroups(const struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
-int perf_event__synthesize_sample(union perf_event *event, u64 type, u64 read_format, const struct perf_sample *sample);
+int perf_event__synthesize_sample(union perf_event *event, u64 type, u64 read_format,
+				  u64 branch_sample_type, const struct perf_sample *sample);
 int perf_event__synthesize_stat_config(const struct perf_tool *tool, struct perf_stat_config *config, perf_event__handler_t process, struct machine *machine);
 int perf_event__synthesize_stat_events(struct perf_stat_config *config, const struct perf_tool *tool, struct evlist *evlist, perf_event__handler_t process, bool attrs);
 int perf_event__synthesize_stat_round(const struct perf_tool *tool, u64 time, u64 type, perf_event__handler_t process, struct machine *machine);
@@ -95,7 +96,8 @@ pid_t perf_event__synthesize_comm(const struct perf_tool *tool, union perf_event
 
 int perf_tool__process_synth_event(const struct perf_tool *tool, union perf_event *event, struct machine *machine, perf_event__handler_t process);
 
-size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type, u64 read_format);
+size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
+				     u64 read_format, u64 branch_sample_type);
 
 int __machine__synthesize_threads(struct machine *machine, const struct perf_tool *tool,
 				  struct target *target, struct perf_thread_map *threads,
-- 
2.53.0



