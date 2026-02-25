Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DBF4369A;
	Wed, 25 Feb 2026 01:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982879; cv=none; b=MdzBATpmSy21MV8n4ClwHixX8xv+nvcCTr7bfjJri9xh+gHzyyijmNP1is6zYhXQk7+0B2B/ZUGs5VPeDL61kWN6qOhHI3vUAkmQGGIyIMqDgiocG0EwwRyyB6loysOaQn91f4Gz5lTiFh7KKzBZrGQPQow7UqIg7BiJPRMkVXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982879; c=relaxed/simple;
	bh=SdQpFmAqjFX12vrreWJFR+IyiFwWFhlQFlVWbzpULrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRrNx7B3kdbr5Z9GOM+NbpzbRg6huwzBE2X7QkARH3T9EOu150SNreZaFHlgLJblC0Nx5/L81YJrg1HN4Kri1ZAo2hFXjUam6odn7wxE3+g4crtwS0TETBQ56iCEuKF24m6OurZsG2+Gx6lNq7PpH0wQMGLkmMcZkmTWy9CqHNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Nmx+GLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Nmx+GLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82719C116D0;
	Wed, 25 Feb 2026 01:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982879;
	bh=SdQpFmAqjFX12vrreWJFR+IyiFwWFhlQFlVWbzpULrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Nmx+GLQRE3XYEhR8pCUCJ+mau0Xa1/zY2+qmNya9VJxE4U5JTAe61jatx+BRfeo9
	 ThxqNt2IPtd1We2wMUjCSAGFuRLWHnNOouKAcvusKf8aPnmJhOc2DyGimK5W6EbsGY
	 Y2SVQHo/nP99OYv5bVrXpK4ow0V09j+JKtrhBdAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 063/781] perf: arm_spe: Properly set hw.state on failures
Date: Tue, 24 Feb 2026 17:12:52 -0800
Message-ID: <20260225012401.251459749@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 4801115f2b540..5410fb7428d0e 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -106,6 +106,8 @@ struct arm_spe_pmu {
 /* Keep track of our dynamic hotplug state */
 static enum cpuhp_state arm_spe_pmu_online;
 
+static void arm_spe_pmu_stop(struct perf_event *event, int flags);
+
 enum arm_spe_pmu_buf_fault_action {
 	SPE_PMU_BUF_FAULT_ACT_SPURIOUS,
 	SPE_PMU_BUF_FAULT_ACT_FATAL,
@@ -607,8 +609,8 @@ static u64 arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	return limit;
 }
 
-static void arm_spe_perf_aux_output_begin(struct perf_output_handle *handle,
-					  struct perf_event *event)
+static int arm_spe_perf_aux_output_begin(struct perf_output_handle *handle,
+					 struct perf_event *event)
 {
 	u64 base, limit;
 	struct arm_spe_pmu_buf *buf;
@@ -622,7 +624,6 @@ static void arm_spe_perf_aux_output_begin(struct perf_output_handle *handle,
 	/* Start a new aux session */
 	buf = perf_aux_output_begin(handle, event);
 	if (!buf) {
-		event->hw.state |= PERF_HES_STOPPED;
 		/*
 		 * We still need to clear the limit pointer, since the
 		 * profiler might only be disabled by virtue of a fault.
@@ -642,6 +643,7 @@ static void arm_spe_perf_aux_output_begin(struct perf_output_handle *handle,
 
 out_write_limit:
 	write_sysreg_s(limit, SYS_PMBLIMITR_EL1);
+	return (limit & PMBLIMITR_EL1_E) ? 0 : -EIO;
 }
 
 static void arm_spe_perf_aux_output_end(struct perf_output_handle *handle)
@@ -781,7 +783,10 @@ static irqreturn_t arm_spe_pmu_irq_handler(int irq, void *dev)
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
@@ -880,9 +885,10 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
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



