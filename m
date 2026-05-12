Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567D26FC5;
	Tue, 12 May 2026 18:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609525; cv=none; b=XYUINLJL2ePMbnqXp9dk1eWNdc9t3ESiirifuzlJ9afCDFnQpCB0n+xkyhdQiI60S+oAep2vaP6TZgVra+CQr1koIoM+g2SrjoCXlh8G+jxX3Patntv7i4CrRQk2ffX1nom0+wgKCXTCltaD4XiCPxKgPJ1UXSgr4qYuhb/jWps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609525; c=relaxed/simple;
	bh=EmY+14nQhoJiqO1ehTsVQLD4kVWXylwXawa1x04lzZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPNHPs+ZflrlivPckjK6buOjS14+Tm78EPwFSotqRg9oqpiKBbzqLFGZTbW6LbewSgid61CEKVdiDgG81iTUVtAQRehATpE/yFF1zJdkHy6Osy7K1QZ+RzjzfGNOm0jjLyjaUdtcteBFF7WdQ6Fx5yzoJEXoAybS8WtYjsurx20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA/WK1Uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA/WK1Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BC1C2BCC7;
	Tue, 12 May 2026 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609525;
	bh=EmY+14nQhoJiqO1ehTsVQLD4kVWXylwXawa1x04lzZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA/WK1UjgdQndUfOpWmbxcsiUNnj8FjTpd5RfDWqjXXAtjsu8B0CbrGLZg+XasVIY
	 v7heYsUFbCrUUGBqzTOjaP5pM4kDYbO7AUNjYeF+2q5KULc36iHFXdcXl3IUYjftOh
	 bwYAId2JWiTHWaWtkBFUtqawKs/yqK9/7SDEwblU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.0 229/307] perf/x86/intel: Disable PMI for self-reloaded ACR events
Date: Tue, 12 May 2026 19:40:24 +0200
Message-ID: <20260512173944.950884578@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit 1271aeccc307066315b2d3b0d5af2510e27018b5 upstream.

On platforms with Auto Counter Reload (ACR) support, such as NVL, a
"NMI received for unknown reason 30" warning is observed when running
multiple events in a group with ACR enabled:

  $ perf record -e '{instructions/period=20000,acr_mask=0x2/u,\
    cycles/period=40000,acr_mask=0x3/u}' ./test

The warning occurs because the Performance Monitoring Interrupt (PMI)
is enabled for the self-reloaded event (the cycles event in this case).
According to the Intel SDM, the overflow bit
(IA32_PERF_GLOBAL_STATUS.PMCn_OVF) is never set for self-reloaded events.
Since the bit is not set, the perf NMI handler cannot identify the source
of the interrupt, leading to the "unknown reason" message.

Furthermore, enabling PMI for self-reloaded events is unnecessary and
can lead to extraneous records that pollute the user's requested data.

Disable the interrupt bit for all events configured with ACR self-reload.

Fixes: ec980e4facef ("perf/x86/intel: Support auto counter reload")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260430002558.712334-4-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   17 +++++++++++++----
 arch/x86/events/perf_event.h |   10 ++++++++++
 2 files changed, 23 insertions(+), 4 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3118,11 +3118,11 @@ static void intel_pmu_enable_fixed(struc
 	intel_set_masks(event, idx);
 
 	/*
-	 * Enable IRQ generation (0x8), if not PEBS,
-	 * and enable ring-3 counting (0x2) and ring-0 counting (0x1)
-	 * if requested:
+	 * Enable IRQ generation (0x8), if not PEBS or self-reloaded
+	 * ACR event, and enable ring-3 counting (0x2) and ring-0
+	 * counting (0x1) if requested:
 	 */
-	if (!event->attr.precise_ip)
+	if (!event->attr.precise_ip && !is_acr_self_reload_event(event))
 		bits |= INTEL_FIXED_0_ENABLE_PMI;
 	if (hwc->config & ARCH_PERFMON_EVENTSEL_USR)
 		bits |= INTEL_FIXED_0_USER;
@@ -3306,6 +3306,15 @@ static void intel_pmu_enable_event(struc
 		intel_set_masks(event, idx);
 		static_call_cond(intel_pmu_enable_acr_event)(event);
 		static_call_cond(intel_pmu_enable_event_ext)(event);
+		/*
+		 * For self-reloaded ACR event, don't enable PMI since
+		 * HW won't set overflow bit in GLOBAL_STATUS. Otherwise,
+		 * the PMI would be recognized as a suspicious NMI.
+		 */
+		if (is_acr_self_reload_event(event))
+			hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
+		else if (!event->attr.precise_ip)
+			hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
 		__x86_pmu_enable_event(hwc, enable_mask);
 		break;
 	case INTEL_PMC_IDX_FIXED ... INTEL_PMC_IDX_FIXED_BTS - 1:
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -137,6 +137,16 @@ static inline bool is_acr_event_group(st
 	return check_leader_group(event->group_leader, PERF_X86_EVENT_ACR);
 }
 
+static inline bool is_acr_self_reload_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->idx < 0)
+		return false;
+
+	return test_bit(hwc->idx, (unsigned long *)&hwc->config1);
+}
+
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
 	int refcnt; /* reference count */


