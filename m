Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8602F4DDB23;
	Wed, 30 Sep 2026 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787453; cv=none; b=PD9dhRedk+Wl0IFC061SDpB4KFkMlPfNbHkrMFa5DaLADtwrqXTEUlgF+p/aQyAPyXfsikBRZDZFsf1Gr5w9XHsjofOrfHMK7l0yoJnREaho6rj8E3oIbEr4E2pLdHJvZb6tL2OFZKmbrWi9SS0YhR8Zkk3LPyViCIeJB1yXnAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787453; c=relaxed/simple;
	bh=lISk/diz6wXUUfiZgBqkDKIBiDXwL7UTIe+2Vkb8CL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ0HmHu5LWq74nseos6rAPBhhYnYdFdyP+dSNfhU+Zzwc/aq3AkeMKzih8Lb0mjy87fsPKkWbahD57sH7WqCGVtWmAv7cRL4sJB1+3Kax2wimPbZxprc+WlDUz6fgt+PgsZ+iyEHTihTiIyYBOrGL9CjAWftK3FzPwBp77lEoWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vToefvoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vToefvoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72461F000FF;
	Wed, 30 Sep 2026 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787451;
	bh=Lsh50C4lQEFR+hPb6+gwzD33Agc8QS237Md8f6uZe5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vToefvoLE7bYju4fHfo+HYzu3jzGVZXD9lyBGVOvX9AgUnpMXhq/v2XofLs4bXqV6
	 WTD+TBwxMgJPYdVV6oKrGZBTHAt9Ml1E+zGBVcPhmA21Cg2lvg6jTGU9PZ+/DybnX+
	 xE8Xyih8qocRKxVsd9QCVLZW4vt8cFk3PQ+QBR7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Yifan Wu <wuyifan50@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 234/457] perf/core: Fill branch entries with a single assignment
Date: Wed, 30 Sep 2026 17:25:39 +0200
Message-ID: <20260930152351.094099826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 24b620729e53d978b3e425f55bc66efd3bab1f59 ]

perf_clear_branch_entry_bitfields() clears the bitfields of struct
perf_branch_entry one by one and leaves from/to alone, since callers
overwrite those straight away. The list has to be kept in sync with the
struct by hand and has already fallen behind: new_type and priv were
added to perf_branch_entry and never added here.

Only BRBE writes those two, and neither for every record.
brbe_set_perf_entry_type() leaves new_type alone for a branch type it
does not recognise, and priv is not set for source-only records.
arm_pmuv3.c allocates the per-CPU branch stack with kmalloc(), so such a
record reaches userspace with whatever the slot held: uninitialised
kmalloc() data on the first pass over the buffer, the previous record's
values after that. Nothing under arch/x86/events/ writes either field,
so only arm64 is affected.

Assign the whole entry at each site instead. Everything not named is
then zero, and there is no list to keep in sync. The bitfields add up to
exactly 64 bits, so the struct has no padding to leave undefined.

perf_clear_branch_entry_bitfields() has no callers left, so remove it.
perf_entry_from_brbe_regset() assigns an empty literal instead, since it
fills from/to conditionally. PERF_BR_SPEC_NA is 0, so dropping the
explicit spec assignment changes nothing.

Fixes: b190bc4ac9e6 ("perf: Extend branch type classification")
Fixes: 5402d25aa571 ("perf: Capture branch privilege information")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Yifan Wu <wuyifan50@huawei.com>
Link: https://patch.msgid.link/20260810133540.1947118-4-puranjay@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/brs.c   |  9 +++--
 arch/x86/events/amd/lbr.c   | 16 ++++-----
 arch/x86/events/intel/lbr.c | 65 ++++++++++++++++++++-----------------
 drivers/perf/arm_brbe.c     |  2 +-
 include/linux/perf_event.h  | 17 ----------
 5 files changed, 48 insertions(+), 61 deletions(-)

diff --git a/arch/x86/events/amd/brs.c b/arch/x86/events/amd/brs.c
index dc564688f3d73..54b13faba116c 100644
--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -343,11 +343,10 @@ void amd_brs_drain(void)
 		if (!amd_brs_match_plm(event, from, to))
 			continue;
 
-		perf_clear_branch_entry_bitfields(br+nr);
-
-		br[nr].from = from;
-		br[nr].to   = to;
-
+		br[nr] = (struct perf_branch_entry){
+			.from	= from,
+			.to	= to,
+		};
 		nr++;
 	}
 empty:
diff --git a/arch/x86/events/amd/lbr.c b/arch/x86/events/amd/lbr.c
index 9d9c961989d51..a55646fcb8465 100644
--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -184,13 +184,6 @@ void amd_pmu_lbr_read(void)
 		    entry.to.split.reserved)
 			continue;
 
-		perf_clear_branch_entry_bitfields(br + out);
-
-		br[out].from	= sign_ext_branch_ip(entry.from.split.ip);
-		br[out].to	= sign_ext_branch_ip(entry.to.split.ip);
-		br[out].mispred	= entry.from.split.mispredict;
-		br[out].predicted = !br[out].mispred;
-
 		/*
 		 * Set branch speculation information using the status of
 		 * the valid and spec bits.
@@ -208,7 +201,14 @@ void amd_pmu_lbr_read(void)
 		 * speculative and took the correct path
 		 */
 		idx = (entry.to.split.valid << 1) | entry.to.split.spec;
-		br[out].spec = lbr_spec_map[idx];
+
+		br[out] = (struct perf_branch_entry){
+			.from		= sign_ext_branch_ip(entry.from.split.ip),
+			.to		= sign_ext_branch_ip(entry.to.split.ip),
+			.mispred	= entry.from.split.mispredict,
+			.predicted	= !entry.from.split.mispredict,
+			.spec		= lbr_spec_map[idx],
+		};
 		out++;
 	}
 
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 52d14927a1917..1ed29d58f119f 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -756,10 +756,10 @@ void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
 
 		rdmsrq(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
 
-		perf_clear_branch_entry_bitfields(br);
-
-		br->from	= msr_lastbranch.from;
-		br->to		= msr_lastbranch.to;
+		*br = (struct perf_branch_entry){
+			.from	= msr_lastbranch.from,
+			.to	= msr_lastbranch.to,
+		};
 		br++;
 	}
 	cpuc->lbr_stack.nr = i;
@@ -847,14 +847,15 @@ void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 		if (abort && x86_pmu.lbr_double_abort && out > 0)
 			out--;
 
-		perf_clear_branch_entry_bitfields(br+out);
-		br[out].from	 = from;
-		br[out].to	 = to;
-		br[out].mispred	 = mis;
-		br[out].predicted = pred;
-		br[out].in_tx	 = in_tx;
-		br[out].abort	 = abort;
-		br[out].cycles	 = cycles;
+		br[out] = (struct perf_branch_entry){
+			.from		= from,
+			.to		= to,
+			.mispred	= mis,
+			.predicted	= pred,
+			.in_tx		= in_tx,
+			.abort		= abort,
+			.cycles		= cycles,
+		};
 		out++;
 	}
 	cpuc->lbr_stack.nr = out;
@@ -905,6 +906,7 @@ static void intel_pmu_store_lbr(struct cpu_hw_events *cpuc,
 	struct perf_branch_entry *e;
 	struct lbr_entry *lbr;
 	u64 from, to, info;
+	bool mispred;
 	int i;
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++) {
@@ -921,24 +923,27 @@ static void intel_pmu_store_lbr(struct cpu_hw_events *cpuc,
 		to = rdlbr_to(i, lbr);
 		info = rdlbr_info(i, lbr);
 
-		perf_clear_branch_entry_bitfields(e);
-
-		e->from		= from;
-		e->to		= to;
-		e->mispred	= get_lbr_mispred(info);
-		e->predicted	= !e->mispred;
-		e->in_tx	= !!(info & LBR_INFO_IN_TX);
-		e->abort	= !!(info & LBR_INFO_ABORT);
-		e->cycles	= get_lbr_cycles(info);
-		e->type		= get_lbr_br_type(info);
-
-		/*
-		 * Leverage the reserved field of cpuc->lbr_entries[i] to
-		 * temporarily store the branch counters information.
-		 * The later code will decide what content can be disclosed
-		 * to the perf tool. Pleae see intel_pmu_lbr_counters_reorder().
-		 */
-		e->reserved	= (info >> LBR_INFO_BR_CNTR_OFFSET) & LBR_INFO_BR_CNTR_FULL_MASK;
+		mispred = get_lbr_mispred(info);
+
+		*e = (struct perf_branch_entry){
+			.from		= from,
+			.to		= to,
+			.mispred	= mispred,
+			.predicted	= !mispred,
+			.in_tx		= !!(info & LBR_INFO_IN_TX),
+			.abort		= !!(info & LBR_INFO_ABORT),
+			.cycles		= get_lbr_cycles(info),
+			.type		= get_lbr_br_type(info),
+			/*
+			 * Leverage the reserved field of
+			 * cpuc->lbr_entries[i] to temporarily store the
+			 * branch counters information. The later code will
+			 * decide what content can be disclosed to the perf
+			 * tool. Pleae see intel_pmu_lbr_counters_reorder().
+			 */
+			.reserved	= (info >> LBR_INFO_BR_CNTR_OFFSET) &
+					  LBR_INFO_BR_CNTR_FULL_MASK,
+		};
 	}
 
 	cpuc->lbr_stack.nr = i;
diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
index ba554e0c846c4..254be4da8ae29 100644
--- a/drivers/perf/arm_brbe.c
+++ b/drivers/perf/arm_brbe.c
@@ -604,7 +604,7 @@ static bool perf_entry_from_brbe_regset(int index, struct perf_branch_entry *ent
 		return false;
 
 	brbinf = bregs.brbinf;
-	perf_clear_branch_entry_bitfields(entry);
+	*entry = (struct perf_branch_entry){ };
 	if (brbe_record_is_complete(brbinf)) {
 		entry->from = bregs.brbsrc;
 		entry->to = bregs.brbtgt;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 48d851fbd8ea5..310681cccb50a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1467,23 +1467,6 @@ static inline u32 perf_sample_data_size(struct perf_sample_data *data,
 	return size;
 }
 
-/*
- * Clear all bitfields in the perf_branch_entry.
- * The to and from fields are not cleared because they are
- * systematically modified by caller.
- */
-static inline void perf_clear_branch_entry_bitfields(struct perf_branch_entry *br)
-{
-	br->mispred	= 0;
-	br->predicted	= 0;
-	br->in_tx	= 0;
-	br->abort	= 0;
-	br->cycles	= 0;
-	br->type	= 0;
-	br->spec	= PERF_BR_SPEC_NA;
-	br->reserved	= 0;
-}
-
 extern void perf_output_sample(struct perf_output_handle *handle,
 			       struct perf_event_header *header,
 			       struct perf_sample_data *data,
-- 
2.53.0



