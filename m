Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048175678C8;
	Wed, 30 Sep 2026 17:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790499; cv=none; b=NFC0Cz7zohI2fTd4qF3FWpmmRkNNEaXQhtGioTb/Et0KmLwkrS+/Y/UsQTn8sAx+ixtdqxBGSGbbiIZHY3UssNJbiwuZuxRPL/zLHYhviOm5De/GJqY8a1zd2hNt4x+i7x4HQuIoKKHqvbedkQD3F+xOuWnvIYgAoSkD4UT2giU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790499; c=relaxed/simple;
	bh=5SnQo8JesdO9Nx70DiUc7B/IIqi0USlQzS/v75Q6mbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmLLSIArEmVUoghs7nlbU49N/p4d2BWylpky42NpNrujkvLnhqGJSVHBZYpCJ34cr2R+Ozv9yjD4E+gIvh2X+qleyATuX+vADXZVxHHB+HOyY6ZG++ZAzKoDD3FHE/epLE7u+g5/JpNww1h6zPtBySXuHSE7y4XCa58BsdN2b6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04+Fz9Hr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04+Fz9Hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9B51F00898;
	Wed, 30 Sep 2026 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790497;
	bh=o4ABuK8I2q2tJ2gjCCiGvL6SowPTV8eFqaO7w2bC2RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04+Fz9Hrkf28Wy5RGmK8+hDOVYicZjBuW+O9C0ddVE1cplrbwgMZP5AAi3rZjnRak
	 0scLQdsa/wA/SYdPZbTowNuJE9SsRetf8P39rf4R7/7JGP0YLJQcFUCj3mTtsy6AFJ
	 zCZ8zsIPdkeTOUo9qJHm/1ozS2IEi7VxHtkVWr/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 850/877] perf/x86/intel: Update event constraints and cache_extra_regsfor ADL
Date: Wed, 30 Sep 2026 17:29:21 +0200
Message-ID: <20260930152433.083216935@linuxfoundation.org>
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
@@ -986,7 +986,7 @@ struct event_constraint intel_glm_pebs_e
 struct event_constraint intel_grt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
 	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
-	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0xf),
+	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0x3f),
 	EVENT_CONSTRAINT_END
 };
 


