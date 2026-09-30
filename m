Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5633F52F262;
	Wed, 30 Sep 2026 18:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793771; cv=none; b=feA9m/gQUT+dv67YAO7uFeizivuSQXk0myYt2g0VV6hJqKP/691e8X0JKWlBhSQce12zcCrnGhoqg3W4SVGfCZPauS5/yDT9iFwOiAfc8Qsv4pt5PWfFLgGVuEAKfyoreEJ8DnjA5wbfCOIUZWI71KTdAdDJlvSroHCYRXhFf+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793771; c=relaxed/simple;
	bh=yMfG6LDdtBl0zbiTBlezfyZQlnTSDrph7OtS++RczXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yn7fT+5a5lVx2jzGKEsEMPKE6CR9Sv3adsIXqgIxR23t+7bbYu2CgQO+arpK9qu54jd+zIYSqnV1Hn8SLC+wH1UlVXZZHpsbOR5F/co+zO0Vad+QYa+K/7Ose6EEHLoRPHbnTh2yJZCNX60HTTW1ZvtSDvdzbQ9jjsFUCqh2BLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e19nkB6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e19nkB6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56581F000FF;
	Wed, 30 Sep 2026 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793770;
	bh=Yq+mxYJ8iFPdi/FBbIIOZ4QV5bQYVrydhFmQGAsjRKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e19nkB6S3bYGS0eqOl6yubWnJJO/fMJrC5Jzc5vW6rU6dUA+Q/qpgHsj0L0gSMenU
	 kVFKTowuP0ZF9wLJxo30HIg2hyhWibr3kj/4ZRK9rX9PByHh1CJA13Rz5LuUNSLMKF
	 zW2nuR/zE/wSLgQBrgKdwU/2nWXT175ePB+J5co4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 373/395] perf/x86/intel: Update event constraints and cache_extra_regsfor ADL
Date: Wed, 30 Sep 2026 17:30:35 +0200
Message-ID: <20260930152348.786736143@linuxfoundation.org>
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

[ Upstream commit 4ef863352bcde482d65722ed721c3fd3967a67d6 ]

Update perf hard-coded event constraints and cache_extra_regs[] for
Alderlake according to the latest ADL perfmon events (V1.39).

One important note is that ADL has differences on the L3/node related
OCR events although it shares same uarch with SPR server, e.g.,
ADL has different extra MSR values and no node events. So some variants
of structures and functions are introduced to reflect these
differences, like adl_glc_hw_cache_event_ids[],
adl_glc_hw_cache_extra_regs[] and intel_pmu_init_glc_hybrid(), etc.

Please note these changes would temporarily impact other platforms like
MTL/ARL-U which shares hard-coded event structures, but it would be
fixed soon in subsequent patches.

ADL perfmon events:
https://github.com/intel/perfmon/blob/main/ADL/events/alderlake_goldencove_core.json
https://github.com/intel/perfmon/blob/main/ADL/events/alderlake_gracemont_core.json

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260515061143.338553-5-dapeng1.mi@linux.intel.com

[Stable dependency adaptation]
Retain only the Gracemont STORE_LATENCY (event 0x6d0) PEBS counter-mask
update from 0xf to 0x3f in intel_grt_pebs_event_constraints[]. This is the
preimage required by target 89dc568e8c0be60e05e5fcd0b528c79077d7b84b.
The existing latency decoder and LOAD/STORE constraint macros are already
available in this stable tree, so no new functions are needed.

Drop all core.c changes: the cache-event tables, offcore MSR masks,
fixed-event aliases and hybrid initialization changes are unrelated to the
target. Their upstream context includes cache tables absent from 6.18,
and retaining them would bring in an unnecessary helper function and
broader platform changes.

[ sashal: Reduced backport -- upstream 4ef863352bcde touches 2 file(s), this
  backport carries 1. Not backported here:
  arch/x86/events/intel/core.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 89dc568e8c0b ("perf/x86/intel: Fix GRT PEBS load/store direction for latency events, to fix sample classification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1011,7 +1011,7 @@ struct event_constraint intel_glm_pebs_e
 struct event_constraint intel_grt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
 	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
-	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0xf),
+	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0x3f),
 	EVENT_CONSTRAINT_END
 };
 


