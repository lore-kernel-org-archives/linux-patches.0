Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2196C52F262;
	Wed, 30 Sep 2026 18:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793774; cv=none; b=sO8nEr6ZUm/rHTw9NpT+R2oPYEOYP/HorY97lfNSqSsUTwv6nOxkavNLfjNyyrX/w9WeYaMhvY65AyOKod6Kv7zXYJnsS3GfkcpkEYN1UlcW56R9aCAsloUr8g/DUwgY7wXffcEAKTHk6zxM4aX+XBi8NM+lTOrwA7ksLKnKlYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793774; c=relaxed/simple;
	bh=VLB3MhiNAmXFTw/DY00vTP08WUO8DKPIao7zjs//ciM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0vs73h1Y5khTYxCwwgJ+R3cffvgnY4KYgNPJKjpBMiHgcfWzd3Xbo44+ymOZRIWHd3yVLhKSTLi9iRUrNj1x/Rz4nJmNWzX4I3Mp2LLvTI0goEQEBCCEXcbi6/8xZo5/W4xkFRC3uqggUMNCeLbwzz+HAk4DH0T7cYWPEAsPjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoAEJdDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoAEJdDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7651F000FF;
	Wed, 30 Sep 2026 18:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793773;
	bh=zN522imgQhz/Gi4Yk6eubeZXoNgxW+T5XO3ev6DtBrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoAEJdDMII9QhykNSa5EE7oNR0HmZDmWc+0eRIcrdyuibTeaHnnhgPBIdRizmQbyD
	 O/Fq6OA8Yrey47Fm2x9xOsB48WoUVEmO0Klo6N+FtfbgXyUHBMBCzbDhLmGpn5kRJ+
	 8lc+26lz+6i+wRb4PVQvZVxotPjeKSu26Qz3CDmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 374/395] perf/x86/intel: Fix GRT PEBS load/store direction for latency events, to fix sample classification
Date: Wed, 30 Sep 2026 17:30:36 +0200
Message-ID: <20260930152348.810000552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -315,6 +315,7 @@ static inline void pebs_set_tlb_lock(u64
 static u64 __grt_latency_data(struct perf_event *event, u64 status,
 			       u8 dse, bool tlb, bool lock, bool blk)
 {
+	union perf_mem_data_src src;
 	u64 val;
 
 	WARN_ON_ONCE(is_hybrid() &&
@@ -330,7 +331,16 @@ static u64 __grt_latency_data(struct per
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
@@ -1010,8 +1020,8 @@ struct event_constraint intel_glm_pebs_e
 
 struct event_constraint intel_grt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
-	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
-	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0x3f),
+	INTEL_HYBRID_LDLAT_CONSTRAINT(0x5d0, 0x3),
+	INTEL_HYBRID_STLAT_CONSTRAINT(0x6d0, 0x3f),
 	EVENT_CONSTRAINT_END
 };
 


