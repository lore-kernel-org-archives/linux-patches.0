Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12DA19F467;
	Tue, 30 Jul 2024 15:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355198; cv=none; b=FZ9gn77OxzN1tlNZqub91CFP/sh7ErW6951WQZBEKXnzov6uSpNes3AbpvDy4Ee5kAea0QHIVBfPVXDDM2gXKjH1Vzaex15tr2n4iVJYhmUas/cyv7vSVUZpbnEl9BGaPjxkGWx9mFsa4ORek2cmyrxVUosCDRlbzud5PS7vMGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355198; c=relaxed/simple;
	bh=8wd0vQZZLRftox+AoKj5ACFE8CXrRVRI61iiPoBZ8ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlVgH31+2SvBHn1Up0R2MPARppJCVUtmIJ1jQFmeM8zbik+lvk0d31zbnu90mdu/LXjWH4nXWfr5GRhv4T+9n9zp2CiHopNBVSVWG96vJY1TGx2PfNZ2ywgNXvzBAaXYtTUzI9LNp4ew43Da0ENXmz/Ree5KGIGo2xJuxYm//o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyEIzDWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyEIzDWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE1EC32782;
	Tue, 30 Jul 2024 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355198;
	bh=8wd0vQZZLRftox+AoKj5ACFE8CXrRVRI61iiPoBZ8ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyEIzDWg+MDlkNIPsjvNGK3r1en1/kJ2sOExIvWvwuTqh78cRwFnmKZ6qe024CXVp
	 EFyWDWj8Qm0f791laZidjfNm8uC3Nz9FJWfaZnQVYselFoJzszCvnSqQJLhV/Z55+5
	 xLEB9ctGwdHoU0oZHcuC4f+Ns6YzlLb2rCGKmoC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 028/809] perf: arm_pmuv3: Avoid assigning fixed cycle counter with threshold
Date: Tue, 30 Jul 2024 17:38:24 +0200
Message-ID: <20240730151725.768524448@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 81e15ca3e523a508d62806fe681c1d289361ca16 ]

If the user has requested a counting threshold for the CPU cycles event,
then the fixed cycle counter can't be assigned as it lacks threshold
support. Currently, the thresholds will work or not randomly depending
on which counter the event is assigned.

While using thresholds for CPU cycles doesn't make much sense, it can be
useful for testing purposes.

Fixes: 816c26754447 ("arm64: perf: Add support for event counting threshold")
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20240626-arm-pmu-3-9-icntr-v2-1-c9784b4f4065@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmuv3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 23fa6c5da82c4..8ed5c3358920a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -338,6 +338,11 @@ static bool armv8pmu_event_want_user_access(struct perf_event *event)
 	return ATTR_CFG_GET_FLD(&event->attr, rdpmc);
 }
 
+static u32 armv8pmu_event_get_threshold(struct perf_event_attr *attr)
+{
+	return ATTR_CFG_GET_FLD(attr, threshold);
+}
+
 static u8 armv8pmu_event_threshold_control(struct perf_event_attr *attr)
 {
 	u8 th_compare = ATTR_CFG_GET_FLD(attr, threshold_compare);
@@ -941,7 +946,8 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	unsigned long evtype = hwc->config_base & ARMV8_PMU_EVTYPE_EVENT;
 
 	/* Always prefer to place a cycle counter into the cycle counter. */
-	if (evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) {
+	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
+	    !armv8pmu_event_get_threshold(&event->attr)) {
 		if (!test_and_set_bit(ARMV8_IDX_CYCLE_COUNTER, cpuc->used_mask))
 			return ARMV8_IDX_CYCLE_COUNTER;
 		else if (armv8pmu_event_is_64bit(event) &&
@@ -1033,7 +1039,7 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 	 * If FEAT_PMUv3_TH isn't implemented, then THWIDTH (threshold_max) will
 	 * be 0 and will also trigger this check, preventing it from being used.
 	 */
-	th = ATTR_CFG_GET_FLD(attr, threshold);
+	th = armv8pmu_event_get_threshold(attr);
 	if (th > threshold_max(cpu_pmu)) {
 		pr_debug("PMU event threshold exceeds max value\n");
 		return -EINVAL;
-- 
2.43.0



