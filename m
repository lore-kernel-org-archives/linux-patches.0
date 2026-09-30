Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EA35678C7;
	Wed, 30 Sep 2026 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790493; cv=none; b=F1M2fEc+7wO9DPfQyaBNIfsAWoYcaULKm5lus1sl6Mjf40WKOjFUHvT3BbqfSO1FgQRHOUSZzc7eTYdjA+9cLMc7bsEFEZ/mCUxYlY01NhkfeG2msmZNZuzjZIVoGrkGz0zDTCuoKbB8HriXqF01f1a/GE6pSbkhCQoY5ekclpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790493; c=relaxed/simple;
	bh=jn0/b7InQt+DNq17EjduzM+AH+z3FxG9uLTiKEa3cQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWVp61Wo8aVnG1tMfCgOYNhI2Z3RuIc1Oy8vFQN3A245xe0y+P3ebDIngT/h8EiYFuDG4O1RpUXvWTwIIokPCNv/TH9KTrZ4W4+TPSXNI+4lDoU21ErZDxXxBYFkxAbdAkhbu/zXI+gW9xIbdFPeludKM3TrRi7eC1WbkINyWyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqly+A5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqly+A5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EC31F000FF;
	Wed, 30 Sep 2026 17:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790492;
	bh=pHag8vQTPRtd5eILREViyGHLIrHRedz2z89Vj6do/jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yqly+A5o1W6L55Q8UtWe52IFRfrcJaYyKTGlMuXxhcD5AUeaofEwsKbhDCkpEx8qx
	 BJQCCjP+s6VC6FHpt+7dU08dLI71P/llUJ7IDdnFxqDITe/tlcl/9eQgxlNeh4o1kn
	 Lyrv9kmc1x6+HaffrwXzr7liYkhvSlQMNUQTNJac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 848/877] perf/x86/intel: Update event constraints and cache_extra_regsfor LNL
Date: Wed, 30 Sep 2026 17:29:19 +0200
Message-ID: <20260930152433.041025965@linuxfoundation.org>
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

[ Upstream commit 331c3e4fa39a87560c09bdd878652090ae040b69 ]

Update perf hard-coded event constraints and cache_extra_regs[] for
Lunarlake according to the latest LNL perfmon events (V1.22).

LNL introduces new extra register values for the OCR L3 cache events,
so introduce lnc_hw_cache_extra_regs[] and skt_hw_cache_extra_regs[] to
reflect the changes.

LNL perfmon events:
https://github.com/intel/perfmon/blob/main/LNL/events/lunarlake_lioncove_core.json
https://github.com/intel/perfmon/blob/main/LNL/events/lunarlake_skymont_core.json

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260515061143.338553-7-dapeng1.mi@linux.intel.com

[Backport to 6.18: retain the Lion Cove PEBS constraint additions needed
by 7c944595cc43 ("perf/x86/intel: Remove incorrect LionCove PEBS data-source
constraints"). Keep the matching regular counter masks for
TOPDOWN.MEMORY_BOUND_SLOTS (0x10a4, 0x8) and MEM_INST_RETIRED.ANY
(0x87d0, 0x3ff), since that fix removes their PEBS-specific entries and
falls back to the regular constraint table.

Omit the unrelated cache extra-register tables and PMU initialization
changes, which depend on cache-event refactoring and intel_pmu_init_cmt()
absent from 6.18. Also omit the unrelated fixed-counter, non-PEBS OCR,
0x00e0, and Skymont constraint updates. No functions are added.]

Stable-dep-of: 7c944595cc43 ("perf/x86/intel: Remove incorrect LionCove PEBS data-source constraints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    3 ++-
 arch/x86/events/intel/ds.c   |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -411,11 +411,12 @@ static struct event_constraint intel_lnc
 	INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4),
 	INTEL_UEVENT_CONSTRAINT(0x04a4, 0x1),
 	INTEL_UEVENT_CONSTRAINT(0x08a4, 0x1),
-	INTEL_UEVENT_CONSTRAINT(0x10a4, 0x1),
+	INTEL_UEVENT_CONSTRAINT(0x10a4, 0x8),
 	INTEL_UEVENT_CONSTRAINT(0x01b1, 0x8),
 	INTEL_UEVENT_CONSTRAINT(0x01cd, 0x3fc),
 	INTEL_UEVENT_CONSTRAINT(0x02cd, 0x3),
 
+	INTEL_UEVENT_CONSTRAINT(0x87d0, 0x3ff),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xd0, 0xdf, 0xf),
 
 	INTEL_UEVENT_CONSTRAINT(0x00e0, 0xf),
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1179,6 +1179,13 @@ struct event_constraint intel_lnc_pebs_e
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x100, 0x100000000ULL),	/* INST_RETIRED.PREC_DIST */
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x0400, 0x800000000ULL),
 
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x012a, 0x1),		/* OCR.* events */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x012b, 0x1),		/* OCR.* events */
+
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x04a4, 0x1),		/* TOPDOWN.BAD_SPEC_SLOTS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x08a4, 0x1),		/* TOPDOWN.BR_MISPREDICT_SLOTS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x10a4, 0x8),		/* TOPDOWN.MEMORY_BOUND_SLOTS */
+
 	INTEL_HYBRID_LDLAT_CONSTRAINT(0x1cd, 0x3fc),
 	INTEL_HYBRID_STLAT_CONSTRAINT(0x2cd, 0x3),
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_LOADS */
@@ -1188,6 +1195,7 @@ struct event_constraint intel_lnc_pebs_e
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_STORES */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf),	/* MEM_INST_RETIRED.ALL_LOADS */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf),	/* MEM_INST_RETIRED.ALL_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x87d0, 0x3ff),		/* MEM_INST_RETIRED.ANY */
 
 	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD_RANGE(0xd1, 0xd4, 0xf),
 


