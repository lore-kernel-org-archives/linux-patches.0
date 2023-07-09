Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409E546B8
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C58C433C7;
	Sun,  9 Jul 2023 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901653;
	bh=JnALJdvnNtOITk52U/OLd3WMoXQUp16JLToEtXJAj0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQbgtTs6vJr4kHqTR0e+6H1/lYQfAQx4eW4JZ3NjYdgDL6MyUOhU1vaVZRk3DFy0K
	 286LZeZ8bQEU/CGESzVF6X4WnH8mIm4LOMApA//GoOG2VEo90QFaGofSpV55PyWQ23
	 HPNDieb+WtKWaJJPhaNbB1YwU83IjDq9CHgJ6b1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Eranian <eranian@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 069/431] perf/ibs: Fix interface via core pmu events
Date: Sun,  9 Jul 2023 13:10:17 +0200
Message-ID: <20230709111452.767483598@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 2fad201fe38ff9a692acedb1990ece2c52a29f95 ]

Although, IBS pmus can be invoked via their own interface, indirect
IBS invocation via core pmu events is also supported with fixed set
of events: cpu-cycles:p, r076:p (same as cpu-cycles:p) and r0C1:p
(micro-ops) for user convenience.

This indirect IBS invocation is broken since commit 66d258c5b048
("perf/core: Optimize perf_init_event()"), which added RAW pmu under
'pmu_idr' list and thus if event_init() fails with RAW pmu, it started
returning error instead of trying other pmus.

Forward precise events from core pmu to IBS by overwriting 'type' and
'config' in the kernel copy of perf_event_attr. Overwriting will cause
perf_init_event() to retry with updated 'type' and 'config', which will
automatically forward event to IBS pmu.

Without patch:
  $ sudo ./perf record -C 0 -e r076:p -- sleep 1
  Error:
  The r076:p event is not supported.

With patch:
  $ sudo ./perf record -C 0 -e r076:p -- sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.341 MB perf.data (37 samples) ]

Fixes: 66d258c5b048 ("perf/core: Optimize perf_init_event()")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20230504110003.2548-3-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c        |  2 +-
 arch/x86/events/amd/ibs.c         | 53 +++++++++++++++----------------
 arch/x86/include/asm/perf_event.h |  2 ++
 3 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index bccea57dee81e..abadd5f234254 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -374,7 +374,7 @@ static int amd_pmu_hw_config(struct perf_event *event)
 
 	/* pass precise event sampling to ibs: */
 	if (event->attr.precise_ip && get_ibs_caps())
-		return -ENOENT;
+		return forward_event_to_ibs(event);
 
 	if (has_branch_stack(event) && !x86_pmu.lbr_nr)
 		return -EOPNOTSUPP;
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 64582954b5f67..3710148021916 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -190,7 +190,7 @@ static struct perf_ibs *get_ibs_pmu(int type)
 }
 
 /*
- * Use IBS for precise event sampling:
+ * core pmu config -> IBS config
  *
  *  perf record -a -e cpu-cycles:p ...    # use ibs op counting cycle count
  *  perf record -a -e r076:p ...          # same as -e cpu-cycles:p
@@ -199,25 +199,9 @@ static struct perf_ibs *get_ibs_pmu(int type)
  * IbsOpCntCtl (bit 19) of IBS Execution Control Register (IbsOpCtl,
  * MSRC001_1033) is used to select either cycle or micro-ops counting
  * mode.
- *
- * The rip of IBS samples has skid 0. Thus, IBS supports precise
- * levels 1 and 2 and the PERF_EFLAGS_EXACT is set. In rare cases the
- * rip is invalid when IBS was not able to record the rip correctly.
- * We clear PERF_EFLAGS_EXACT and take the rip from pt_regs then.
- *
  */
-static int perf_ibs_precise_event(struct perf_event *event, u64 *config)
+static int core_pmu_ibs_config(struct perf_event *event, u64 *config)
 {
-	switch (event->attr.precise_ip) {
-	case 0:
-		return -ENOENT;
-	case 1:
-	case 2:
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 		switch (event->attr.config) {
@@ -243,22 +227,37 @@ static int perf_ibs_precise_event(struct perf_event *event, u64 *config)
 	return -EOPNOTSUPP;
 }
 
+/*
+ * The rip of IBS samples has skid 0. Thus, IBS supports precise
+ * levels 1 and 2 and the PERF_EFLAGS_EXACT is set. In rare cases the
+ * rip is invalid when IBS was not able to record the rip correctly.
+ * We clear PERF_EFLAGS_EXACT and take the rip from pt_regs then.
+ */
+int forward_event_to_ibs(struct perf_event *event)
+{
+	u64 config = 0;
+
+	if (!event->attr.precise_ip || event->attr.precise_ip > 2)
+		return -EOPNOTSUPP;
+
+	if (!core_pmu_ibs_config(event, &config)) {
+		event->attr.type = perf_ibs_op.pmu.type;
+		event->attr.config = config;
+	}
+	return -ENOENT;
+}
+
 static int perf_ibs_init(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_ibs *perf_ibs;
 	u64 max_cnt, config;
-	int ret;
 
 	perf_ibs = get_ibs_pmu(event->attr.type);
-	if (perf_ibs) {
-		config = event->attr.config;
-	} else {
-		perf_ibs = &perf_ibs_op;
-		ret = perf_ibs_precise_event(event, &config);
-		if (ret)
-			return ret;
-	}
+	if (!perf_ibs)
+		return -ENOENT;
+
+	config = event->attr.config;
 
 	if (event->pmu != &perf_ibs->pmu)
 		return -ENOENT;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index abf09882f58b6..f1a46500a2753 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -478,8 +478,10 @@ struct pebs_xmm {
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern u32 get_ibs_caps(void);
+extern int forward_event_to_ibs(struct perf_event *event);
 #else
 static inline u32 get_ibs_caps(void) { return 0; }
+static inline int forward_event_to_ibs(struct perf_event *event) { return -ENOENT; }
 #endif
 
 #ifdef CONFIG_PERF_EVENTS
-- 
2.39.2



