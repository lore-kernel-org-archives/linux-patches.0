Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C78817BED0;
	Sat, 17 Oct 2026 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256177; cv=none; b=h9W4GFdb4+G0OqE1tOiTajZrljDWX/Pra0Xtzn59QlKTsd6CdulFhQ/0DV230uguKturOYzJBNdPAKCEKXHrkuYzmmghO3/dxDgiCyJAD0M0+5gvO+CtStpGAKI5QHtp+x2suXN4APbPlLQ5RaSTEpT7Sq9MeVO3CJPNBHeZvHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256177; c=relaxed/simple;
	bh=UiWOThr/AAXJC4LfzYSvUTYq53WS5iFbQ5ZoWZqLfiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HK3jRbEehMyQrjHj6i3cFQ48YSaaPH2tY2iNiXMXaU4+3f8Zg1nUpS2q+OWOdapMK5Dv+nLQKEJ6vxN8rVxoxnIbv5ZkWd19aL0ZGUpAZnwubuxNuMUoMS2f3NsFsqvZh+O8xOFwPpTUzfAeUzqTR1jDeWrqCDvDg29o8rrZjxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXflDoi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXflDoi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9FF1F000C4;
	Sat, 17 Oct 2026 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256176;
	bh=WmKuJKPMa+l3L1jyhafljq04p3Da8M+I5yRdfW/YUw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXflDoi73a40dYIf/o+CXJPNgsNdUMLUJN0PX6o4UX+gqJ8yhnglpQGEZLQStkkAC
	 e3FP7iuqTFcs26wQhYbG736+/nKx1n1ymeo8OPD+/uAdspezebyQerse9nj2TVRlVf
	 accN/W9Bjr1MJC/mjo5hLOUPTdXbWktbV3KTRQfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0149/1674] perf/x86/intel: Fix GRT PEBS load/store direction for latency events, to fix sample classification
Date: Sat, 17 Oct 2026 17:40:21 +0200
Message-ID: <20261017160434.985899120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit 89dc568e8c0be60e05e5fcd0b528c79077d7b84b ]

On Gracemont, intel_grt_pebs_event_constraints[] applies LAT_CONSTRAINT
constraints to MEM_UOPS_RETIRED.{LOAD,STORE}_LATENCY, but does not set
explicit LOAD/STORE flags for those events.

The PEBS latency path (pebs_latency_data(), via __grt_latency_data())
uses the event flags to determine memory operation direction. Without an
explicit STORE flag, samples from MEM_UOPS_RETIRED.STORE_LATENCY can be
misclassified as LOADs.

Set explicit LOAD/STORE flags in intel_grt_pebs_event_constraints[] for:

- MEM_UOPS_RETIRED.LOAD_LATENCY
- MEM_UOPS_RETIRED.STORE_LATENCY

Also update __grt_latency_data() to explicitly interpret these flags when
assigning the sampled memory operation direction.

This fixes incorrect STORE sample classification.

Fixes: 39a41278f041 ("perf/x86/intel: Fix PEBS memory access info encoding for ADL")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org> # v7.2+
Link: https://patch.msgid.link/20260917015234.981153-2-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index c452ce0531e46..04f3b0d8f14f2 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -259,6 +259,7 @@ static inline void pebs_set_tlb_lock(u64 *val, bool tlb, bool lock)
 static u64 __grt_latency_data(struct perf_event *event, u64 status,
 			       u8 dse, bool tlb, bool lock, bool blk)
 {
+	union perf_mem_data_src src;
 	u64 val;
 
 	WARN_ON_ONCE(is_hybrid() &&
@@ -274,7 +275,16 @@ static u64 __grt_latency_data(struct perf_event *event, u64 status,
 	else
 		val |= P(BLK, NA);
 
-	return val;
+	src.val = val;
+
+	if (event->hw.flags &
+	    (PERF_X86_EVENT_PEBS_LDLAT | PERF_X86_EVENT_PEBS_LD_HSW))
+		src.mem_op = P(OP, LOAD);
+	if (event->hw.flags &
+	    (PERF_X86_EVENT_PEBS_STLAT | PERF_X86_EVENT_PEBS_ST_HSW))
+		src.mem_op = P(OP, STORE);
+
+	return src.val;
 }
 
 u64 grt_latency_data(struct perf_event *event, u64 status)
@@ -892,8 +902,8 @@ struct event_constraint intel_glm_pebs_event_constraints[] = {
 
 struct event_constraint intel_grt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
-	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
-	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0x3f),
+	INTEL_HYBRID_LDLAT_CONSTRAINT(0x5d0, 0x3),
+	INTEL_HYBRID_STLAT_CONSTRAINT(0x6d0, 0x3f),
 	EVENT_CONSTRAINT_END
 };
 
-- 
2.53.0



