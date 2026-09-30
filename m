Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D7552BE5E;
	Wed, 30 Sep 2026 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789915; cv=none; b=WIMyLIxbDFvShooemUTxgvu5ikZ3+2E4mitRB4i6pJ6RMVDj/x3qq8r9AO+HzWxhZCyqaW3w6KGa7VsBEmMEqFmyu1Gq+YHgdlXJy6ibas3F44jJ+SEYfYV6dxQ3pArVlBD+v7ze4njtzPhBL6yfwgTyx0X/jBWWLsROI8g9E4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789915; c=relaxed/simple;
	bh=39Z5R5xVbCJj52GmR/a9zFNMHWEd9a+I9h11n1ontPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkz7dmC/JG2X2SDs9bFGIh+5fazyD6eL/JdJJu+/8ADjRf/fPZ9tqX5z5ASm+8/ONbx7RQbP8MUFEUkWf6b71VfFWpxO71aJlC1D+ozGb+7h1KC69a0qH418j0ybTtvtK6EWDMnrCRvMrUEhBfxLFTGa31X6aakyotzIPgB6dMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArU+4SNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArU+4SNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E8A1F000FF;
	Wed, 30 Sep 2026 17:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789914;
	bh=m+320P52rFo9hNd0ry7joZMivlqGnE5WgJa5kDxX4ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArU+4SNQOSWoG4YITH3eEKMFwf/aSnrseVBKxo7aTMiWG12iQ5nzQzEm6jOggs20v
	 h4OD0gW6EI1LR4WJqkya75HcYZNtoIUq1LoBkuN+D6jtDMeuOXkoTEPy8mlLzk1niV
	 toLiLmo8k75NGoaq0qHYboIK/oiGyUYQlt1ALI/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zide Chen <zide.chen@intel.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 638/877] perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities
Date: Wed, 30 Sep 2026 17:25:49 +0200
Message-ID: <20260930152428.421877385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 8767b4d73018bd3143f4c55b672064fad292f11b ]

AnyThread mode deprecation is enumerated by CPUID.0AH:EDX[15] instead of
PERF_CAPABILITIES MSR. It's not a good practice to define a bit to
represent "anythread deprecation" in perf_capabilities. It leads to the
anythread_deprecated bit could be overwritten by the real value of
PERF_CAPABILITIES MSR, just like the below code in update_pmu_cap() does.

if (!intel_pmu_broken_perf_cap()) {
	/* Perf Metric (Bit 15) and PEBS via PT (Bit 16) are hybrid enumeration */
	rdmsrq(MSR_IA32_PERF_CAPABILITIES, hybrid(pmu, intel_cap).capabilities);
}

It leads to the anythread_deprecated bit is cleared to 0 and the "any"
attribute is incorrectly shown in the /sys/devices/cpu/format/ folder on
these support Perfmon v6 platforms, like Clearwater Forest.

$ grep . /sys/devices/cpu/format/*
/sys/devices/cpu/format/acr_mask:config2:0-63
/sys/devices/cpu/format/any:config:21
/sys/devices/cpu/format/cmask:config:24-31

So remove the anythread_deprecated bit from perf_capabilities structure
and directly depends on CPUID.0AH:EDX[15] to judge if anythread is
deprecated.

Fixes: cadbaa039b99 ("perf/x86/intel: Make anythread filter support conditional")
Reported-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616044654.3468742-2-dapeng1.mi@linux.intel.com
[ Adjusted patch context to match the older PMU initialization and capability layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   10 +++-------
 arch/x86/events/perf_event.h |    2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6568,12 +6568,6 @@ __init int intel_pmu_init(void)
 
 	x86_add_quirk(intel_arch_events_quirk); /* Install first, so it runs last */
 
-	if (version >= 5) {
-		x86_pmu.intel_cap.anythread_deprecated = edx.split.anythread_deprecated;
-		if (x86_pmu.intel_cap.anythread_deprecated)
-			pr_cont(" AnyThread deprecated, ");
-	}
-
 	/*
 	 * Install the hw-cache-events table:
 	 */
@@ -7301,8 +7295,10 @@ __init int intel_pmu_init(void)
 				      &x86_pmu.intel_ctrl);
 
 	/* AnyThread may be deprecated on arch perfmon v5 or later */
-	if (x86_pmu.intel_cap.anythread_deprecated)
+	if (version >= 5 && edx.split.anythread_deprecated) {
 		x86_pmu.format_attrs = intel_arch_formats_attr;
+		pr_cont("AnyThread deprecated, ");
+	}
 
 	intel_pmu_check_event_constraints(x86_pmu.event_constraints,
 					  x86_pmu.cntr_mask64,
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -630,7 +630,7 @@ union perf_capabilities {
 		u64	perf_metrics:1;
 		u64	pebs_output_pt_available:1;
 		u64	pebs_timing_info:1;
-		u64	anythread_deprecated:1;
+		u64	__reserved:1;
 	};
 	u64	capabilities;
 };


