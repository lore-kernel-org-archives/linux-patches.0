Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465953446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302058; cv=none; b=X1hnUXclcVBG6vxM3zz5buaI5R2esD8yHs+3iUjWVp4hBdeHS1IcvHjxrKF6U0CsA09LOSH3HCWbjo/04T53gaXm1EVIAQ/sttTWfzNwxVPuRnjnzK5JNENEc109uwFWPiEjX46iISKd2Iqe0XSWDzhFLg551KPslJxEHFb+jXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302058; c=relaxed/simple;
	bh=LTqURpw7yiWuA5EBWwJVqfs2fercf+sG4rC1kWQZAfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDnPr8/i5ymI4Omque8idL4+kAkQlJQPESysR+yiF3ViGXDa19cSMa9FTwWHIhO/fCK37ma4XCAZ9TRHKuTo3MEa6tw7WX/dBRL9/gUOrqQlzULAEpt22/7wDRqKOCyH4T2bHHVg0NsA/PVs95QSlqMRI7we45rVyQEGX4Hef0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIomZxze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIomZxze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31EFC116D0;
	Sat, 28 Feb 2026 18:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302058;
	bh=LTqURpw7yiWuA5EBWwJVqfs2fercf+sG4rC1kWQZAfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIomZxze5FzQ5TIGaw7ZTWBeU9ClI3vcnYVtRHcec361mSOLBvqOweuSSExWrwdDy
	 VCkdkRjsFUn92zqS6Tq9035XUwkHrXQiIbjKsNni/yo8OSB+YUnHz4ak4Nx2Kv69OQ
	 VbnSpA/U1qoO2cKagtSkbMkZw0Gcz/1N+aZsJLCdjYZznarWybRCa4nhjfLzbt+PNW
	 XkcFZ4paJt08Io1FvStR75AD/JiETHWHnkLKauR+CnOhETQBk4h1OznsG0Bizj/G2U
	 5KxYQBMoJyY659dU2UYFadHM+l1drGdqd7Me9VBz6iy7YPzE9/Ces8ICMqRg+dPhjY
	 Kf+9kSU30onOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/283] perf: arm_spe: Properly set hw.state on failures
Date: Sat, 28 Feb 2026 13:02:56 -0500
Message-ID: <20260228180709.1583486-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 283182c1c239f6873d1a50e9e710c1a699f2256b ]

When arm_spe_pmu_next_off() fails to calculate a valid limit, it returns
zero to indicate that tracing should not start.  However, the caller
arm_spe_perf_aux_output_begin() does not propagate this failure by
updating hwc->state, cause the error to be silently ignored by upper
layers.

Because hwc->state remains zero after a failure, arm_spe_pmu_start()
continues to programs filter registers unnecessarily.  The driver
still reports success to the perf core, so the core assumes the SPE
event was enabled and proceeds to enable other events.  This breaks
event group semantics: SPE is already stopped while other events in the
same group are enabled.

Fix this by updating arm_spe_perf_aux_output_begin() to return a status
code indicating success (0) or failure (-EIO).  Both the interrupt
handler and arm_spe_pmu_start() check the return value and call
arm_spe_pmu_stop() to set PERF_HES_STOPPED in hwc->state.

In the interrupt handler, the period (e.g., period_left) needs to be
updated, so PERF_EF_UPDATE is passed to arm_spe_pmu_stop().  When the
error occurs during event start, the trace unit is not yet enabled, so
a flag '0' is used to drain buffer and update state only.

Fixes: d5d9696b0380 ("drivers/perf: Add support for ARMv8.2 Statistical Profiling Extension")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_spe_pmu.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index affa78376b6a8..5164078c06d25 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -102,6 +102,8 @@ struct arm_spe_pmu {
 /* Keep track of our dynamic hotplug state */
 static enum cpuhp_state arm_spe_pmu_online;
 
+static void arm_spe_pmu_stop(struct perf_event *event, int flags);
+
 enum arm_spe_pmu_buf_fault_action {
 	SPE_PMU_BUF_FAULT_ACT_SPURIOUS,
 	SPE_PMU_BUF_FAULT_ACT_FATAL,
@@ -519,8 +521,8 @@ static u64 arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	return limit;
 }
 
-static void arm_spe_perf_aux_output_begin(struct perf_output_handle *handle,
-					  struct perf_event *event)
+static int arm_spe_perf_aux_output_begin(struct perf_output_handle *handle,
+					 struct perf_event *event)
 {
 	u64 base, limit;
 	struct arm_spe_pmu_buf *buf;
@@ -528,7 +530,6 @@ static void arm_spe_perf_aux_output_begin(struct perf_output_handle *handle,
 	/* Start a new aux session */
 	buf = perf_aux_output_begin(handle, event);
 	if (!buf) {
-		event->hw.state |= PERF_HES_STOPPED;
 		/*
 		 * We still need to clear the limit pointer, since the
 		 * profiler might only be disabled by virtue of a fault.
@@ -548,6 +549,7 @@ static void arm_spe_perf_aux_output_begin(struct perf_output_handle *handle,
 
 out_write_limit:
 	write_sysreg_s(limit, SYS_PMBLIMITR_EL1);
+	return (limit & PMBLIMITR_EL1_E) ? 0 : -EIO;
 }
 
 static void arm_spe_perf_aux_output_end(struct perf_output_handle *handle)
@@ -687,7 +689,10 @@ static irqreturn_t arm_spe_pmu_irq_handler(int irq, void *dev)
 		 * when we get to it.
 		 */
 		if (!(handle->aux_flags & PERF_AUX_FLAG_TRUNCATED)) {
-			arm_spe_perf_aux_output_begin(handle, event);
+			if (arm_spe_perf_aux_output_begin(handle, event)) {
+				arm_spe_pmu_stop(event, PERF_EF_UPDATE);
+				break;
+			}
 			isb();
 		}
 		break;
@@ -782,9 +787,10 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
 	struct perf_output_handle *handle = this_cpu_ptr(spe_pmu->handle);
 
 	hwc->state = 0;
-	arm_spe_perf_aux_output_begin(handle, event);
-	if (hwc->state)
+	if (arm_spe_perf_aux_output_begin(handle, event)) {
+		arm_spe_pmu_stop(event, 0);
 		return;
+	}
 
 	reg = arm_spe_event_to_pmsfcr(event);
 	write_sysreg_s(reg, SYS_PMSFCR_EL1);
-- 
2.51.0

