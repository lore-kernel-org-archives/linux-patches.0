Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87E633A6F1;
	Wed, 30 Sep 2026 19:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795492; cv=none; b=mNastKg2rkKzdHbK9u6EXGGEGV0tGgz8E5DqcoM/OGaf6CwtouscjBR/Vb724kDEQfLxV6n9HZ+wh/Ge2jGwcUYK9aaOHS34wfb3YXf+kZIAJvn/77O2VX9umd1AeE5KmmWtq6StXWRm6Yyr+QXAmCQ0IFpqmZBT1ZvrxMHb8kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795492; c=relaxed/simple;
	bh=yRaup8iyrGdPwg6e64MEBE56oxtlu55h/j28ngel4vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UN6knEtla644fIBqDGcQvEaGTykYrT0xz0hPMF+VaIn2bmW4nGrrlPHhbDGHbUIdvYvrRd8A/KzIpIjbipGKiYaFLXCMO0dPUW8UKhCjJF5hYX3fe2A49zDQ3k55cvBO25z7UegHoB1EGHzOD/bbxtsmS0ZkwHFH3vkMCpuzrDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsNLN2ts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsNLN2ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9471F000FF;
	Wed, 30 Sep 2026 19:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795490;
	bh=CHuWcSsfVYKyILQj7QA3uifh5KsyZ92/H4l3VY45XPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsNLN2tsj64lJa/a+QRI062GkIne7BPL9cc2wNYATIFjDPdwTGYszZwOInsVfsXMX
	 eLMLwE8057Rn2HG0lZ2ZMxPd14LomXbyhElcUxMLY29GNHD2KVgGTMY/lmfmxH8mAv
	 oyDoZ4aHcaTMq+g/dT4xD3/sav5b2KBALaIDIeQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0581/1193] perf/x86/intel/ds: Factor out PEBS group processing code to functions
Date: Wed, 30 Sep 2026 17:21:05 +0200
Message-ID: <20260930152447.152025534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 167cde7dc9b36b7a88f3c29d836fabce13023327 ]

Adaptive PEBS and arch-PEBS share lots of same code to process these
PEBS groups, like basic, GPR and meminfo groups. Extract these shared
code to generic functions to avoid duplicated code.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251029102136.61364-8-dapeng1.mi@linux.intel.com
Stable-dep-of: 88aa1223bfff ("perf/x86/intel: Correct pt_regs->flags update for PEBS path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 170 +++++++++++++++++++++++--------------
 1 file changed, 104 insertions(+), 66 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 0dbe7470f3fad..461475dd2b045 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1782,6 +1782,90 @@ static void adaptive_pebs_save_regs(struct pt_regs *regs,
 
 #define PEBS_LATENCY_MASK			0xffff
 
+static inline void __setup_perf_sample_data(struct perf_event *event,
+					    struct pt_regs *iregs,
+					    struct perf_sample_data *data)
+{
+	perf_sample_data_init(data, 0, event->hw.last_period);
+
+	/*
+	 * We must however always use iregs for the unwinder to stay sane; the
+	 * record BP,SP,IP can point into thin air when the record is from a
+	 * previous PMI context or an (I)RET happened between the record and
+	 * PMI.
+	 */
+	perf_sample_save_callchain(data, event, iregs);
+}
+
+static inline void __setup_pebs_basic_group(struct perf_event *event,
+					    struct pt_regs *regs,
+					    struct perf_sample_data *data,
+					    u64 sample_type, u64 ip,
+					    u64 tsc, u16 retire)
+{
+	/* The ip in basic is EventingIP */
+	set_linear_ip(regs, ip);
+	regs->flags = PERF_EFLAGS_EXACT;
+	setup_pebs_time(event, data, tsc);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT_STRUCT)
+		data->weight.var3_w = retire;
+}
+
+static inline void __setup_pebs_gpr_group(struct perf_event *event,
+					  struct pt_regs *regs,
+					  struct pebs_gprs *gprs,
+					  u64 sample_type)
+{
+	if (event->attr.precise_ip < 2) {
+		set_linear_ip(regs, gprs->ip);
+		regs->flags &= ~PERF_EFLAGS_EXACT;
+	}
+
+	if (sample_type & (PERF_SAMPLE_REGS_INTR | PERF_SAMPLE_REGS_USER))
+		adaptive_pebs_save_regs(regs, gprs);
+}
+
+static inline void __setup_pebs_meminfo_group(struct perf_event *event,
+					      struct perf_sample_data *data,
+					      u64 sample_type, u64 latency,
+					      u16 instr_latency, u64 address,
+					      u64 aux, u64 tsx_tuning, u64 ax)
+{
+	if (sample_type & PERF_SAMPLE_WEIGHT_TYPE) {
+		u64 tsx_latency = intel_get_tsx_weight(tsx_tuning);
+
+		data->weight.var2_w = instr_latency;
+
+		/*
+		 * Although meminfo::latency is defined as a u64,
+		 * only the lower 32 bits include the valid data
+		 * in practice on Ice Lake and earlier platforms.
+		 */
+		if (sample_type & PERF_SAMPLE_WEIGHT)
+			data->weight.full = latency ?: tsx_latency;
+		else
+			data->weight.var1_dw = (u32)latency ?: tsx_latency;
+
+		data->sample_flags |= PERF_SAMPLE_WEIGHT_TYPE;
+	}
+
+	if (sample_type & PERF_SAMPLE_DATA_SRC) {
+		data->data_src.val = get_data_src(event, aux);
+		data->sample_flags |= PERF_SAMPLE_DATA_SRC;
+	}
+
+	if (sample_type & PERF_SAMPLE_ADDR_TYPE) {
+		data->addr = address;
+		data->sample_flags |= PERF_SAMPLE_ADDR;
+	}
+
+	if (sample_type & PERF_SAMPLE_TRANSACTION) {
+		data->txn = intel_get_tsx_transaction(tsx_tuning, ax);
+		data->sample_flags |= PERF_SAMPLE_TRANSACTION;
+	}
+}
+
 /*
  * With adaptive PEBS the layout depends on what fields are configured.
  */
@@ -1792,12 +1876,14 @@ static void setup_pebs_adaptive_sample_data(struct perf_event *event,
 					    struct pt_regs *regs)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	u64 sample_type = event->attr.sample_type;
 	struct pebs_basic *basic = __pebs;
 	void *next_record = basic + 1;
-	u64 sample_type, format_group;
 	struct pebs_meminfo *meminfo = NULL;
 	struct pebs_gprs *gprs = NULL;
 	struct x86_perf_regs *perf_regs;
+	u64 format_group;
+	u16 retire;
 
 	if (basic == NULL)
 		return;
@@ -1805,31 +1891,17 @@ static void setup_pebs_adaptive_sample_data(struct perf_event *event,
 	perf_regs = container_of(regs, struct x86_perf_regs, regs);
 	perf_regs->xmm_regs = NULL;
 
-	sample_type = event->attr.sample_type;
 	format_group = basic->format_group;
-	perf_sample_data_init(data, 0, event->hw.last_period);
 
-	setup_pebs_time(event, data, basic->tsc);
-
-	/*
-	 * We must however always use iregs for the unwinder to stay sane; the
-	 * record BP,SP,IP can point into thin air when the record is from a
-	 * previous PMI context or an (I)RET happened between the record and
-	 * PMI.
-	 */
-	perf_sample_save_callchain(data, event, iregs);
+	__setup_perf_sample_data(event, iregs, data);
 
 	*regs = *iregs;
-	/* The ip in basic is EventingIP */
-	set_linear_ip(regs, basic->ip);
-	regs->flags = PERF_EFLAGS_EXACT;
 
-	if (sample_type & PERF_SAMPLE_WEIGHT_STRUCT) {
-		if (x86_pmu.flags & PMU_FL_RETIRE_LATENCY)
-			data->weight.var3_w = basic->retire_latency;
-		else
-			data->weight.var3_w = 0;
-	}
+	/* basic group */
+	retire = x86_pmu.flags & PMU_FL_RETIRE_LATENCY ?
+			basic->retire_latency : 0;
+	__setup_pebs_basic_group(event, regs, data, sample_type,
+				 basic->ip, basic->tsc, retire);
 
 	/*
 	 * The record for MEMINFO is in front of GP
@@ -1845,54 +1917,20 @@ static void setup_pebs_adaptive_sample_data(struct perf_event *event,
 		gprs = next_record;
 		next_record = gprs + 1;
 
-		if (event->attr.precise_ip < 2) {
-			set_linear_ip(regs, gprs->ip);
-			regs->flags &= ~PERF_EFLAGS_EXACT;
-		}
-
-		if (sample_type & (PERF_SAMPLE_REGS_INTR | PERF_SAMPLE_REGS_USER))
-			adaptive_pebs_save_regs(regs, gprs);
+		__setup_pebs_gpr_group(event, regs, gprs, sample_type);
 	}
 
 	if (format_group & PEBS_DATACFG_MEMINFO) {
-		if (sample_type & PERF_SAMPLE_WEIGHT_TYPE) {
-			u64 latency = x86_pmu.flags & PMU_FL_INSTR_LATENCY ?
-					meminfo->cache_latency : meminfo->mem_latency;
-
-			if (x86_pmu.flags & PMU_FL_INSTR_LATENCY)
-				data->weight.var2_w = meminfo->instr_latency;
-
-			/*
-			 * Although meminfo::latency is defined as a u64,
-			 * only the lower 32 bits include the valid data
-			 * in practice on Ice Lake and earlier platforms.
-			 */
-			if (sample_type & PERF_SAMPLE_WEIGHT) {
-				data->weight.full = latency ?:
-					intel_get_tsx_weight(meminfo->tsx_tuning);
-			} else {
-				data->weight.var1_dw = (u32)latency ?:
-					intel_get_tsx_weight(meminfo->tsx_tuning);
-			}
-
-			data->sample_flags |= PERF_SAMPLE_WEIGHT_TYPE;
-		}
-
-		if (sample_type & PERF_SAMPLE_DATA_SRC) {
-			data->data_src.val = get_data_src(event, meminfo->aux);
-			data->sample_flags |= PERF_SAMPLE_DATA_SRC;
-		}
-
-		if (sample_type & PERF_SAMPLE_ADDR_TYPE) {
-			data->addr = meminfo->address;
-			data->sample_flags |= PERF_SAMPLE_ADDR;
-		}
-
-		if (sample_type & PERF_SAMPLE_TRANSACTION) {
-			data->txn = intel_get_tsx_transaction(meminfo->tsx_tuning,
-							  gprs ? gprs->ax : 0);
-			data->sample_flags |= PERF_SAMPLE_TRANSACTION;
-		}
+		u64 latency = x86_pmu.flags & PMU_FL_INSTR_LATENCY ?
+				meminfo->cache_latency : meminfo->mem_latency;
+		u64 instr_latency = x86_pmu.flags & PMU_FL_INSTR_LATENCY ?
+				meminfo->instr_latency : 0;
+		u64 ax = gprs ? gprs->ax : 0;
+
+		__setup_pebs_meminfo_group(event, data, sample_type, latency,
+					   instr_latency, meminfo->address,
+					   meminfo->aux, meminfo->tsx_tuning,
+					   ax);
 	}
 
 	if (format_group & PEBS_DATACFG_XMMS) {
-- 
2.53.0



