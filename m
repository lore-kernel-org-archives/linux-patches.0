Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155EB3EDE6F;
	Tue, 12 May 2026 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608474; cv=none; b=DsBuSCL2YqMB2t4rS/1v0K8iCdNchMFkR9I89T7IKsOdrL6kNyr7lPMAemBHYLhT/4Fm8bcce0yXBxZVbJUcu8YbnSIGGNDRA47QMPmb/MIzAsfBJ9K6U375rjBCtn+gem6QbprmO36GzlVd8sapGrVIlKvSkY0daSMuBl7MuqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608474; c=relaxed/simple;
	bh=j64D9aJHw6VqGgg1rl7Yr4iOK2lG04SYuCB01bzhh8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p11zZerB+jZ4v6jGUkUaaYMYR2hCkaw+7c1P6dxlku/BsTn7lBVTzjXMuOPbjkG7Tzj4yWZi0Fow8/oeCrL/9uwXPoNXZj1vrTG0adPAbZtazupY26GTNDedbqTntYEabKVkXUcoM2/7Lac37gBeAG2kK0b+xvLp5p33mHI8rW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cI0md0BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cI0md0BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A160DC2BCB0;
	Tue, 12 May 2026 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608474;
	bh=j64D9aJHw6VqGgg1rl7Yr4iOK2lG04SYuCB01bzhh8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cI0md0BOUto2lnpzpEsQqzwxQ1O27kn9kNMln1g8A499cEQ3uDerjYhpc1BC26FHY
	 FyZDmucE0/D96h4csO8v6sjgLAXwB/3XVyPBIqh1hsxVgKYDEQD6ATukOBLZa2uHQ2
	 p2aklbA/ZhegPawzQD7pGbsPH+0fH2qFF1he9as4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 094/270] perf/x86/intel: Improve validation and configuration of ACR masks
Date: Tue, 12 May 2026 19:38:15 +0200
Message-ID: <20260512173940.440136256@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

commit 5ad732a56be46aabf158c16aa0c095291727aaef upstream.

Currently there are several issues on the user space ACR mask validation
and configuration.
- The validation for user space ACR mask (attr.config2) is incomplete,
  e.g., the ACR mask could include the index which belongs to another
  ACR events group, but it's not validated.
- An early return on an invalid ACR mask caused all subsequent ACR groups
  to be skipped.
- The stale hardware ACR mask (hw.config1) is not cleared before setting
  new hardware ACR mask.

The following changes address all of the above issues.
- Figure out the event index group of an ACR group. Any bits in the
  user-space mask not present in the index group are now dropped.
- Instead of an early return on invalid bits, drop only the invalid
  portions and continue iterating through all ACR events to ensure full
  configuration.
- Explicitly clear the stale hardware ACR mask for each event prior to
  writing the new configuration.

Besides, a non-leader event member of ACR group could be disabled in
theory. This could cause bit-shifting errors in the acr_mask of remaining
group members. But since ACR sampling requires all events to be active,
this should not be a big concern in real use case. Add a "FIXME" comment
to notice this risk.

Fixes: ec980e4facef ("perf/x86/intel: Support auto counter reload")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260430002558.712334-2-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2980,23 +2980,41 @@ static void intel_pmu_enable_event(struc
 static void intel_pmu_acr_late_setup(struct cpu_hw_events *cpuc)
 {
 	struct perf_event *event, *leader;
-	int i, j, idx;
+	int i, j, k, bit, idx;
 
+	/*
+	 * FIXME: ACR mask parsing relies on cpuc->event_list[] (active events only).
+	 * Disabling an ACR event causes bit-shifting errors in the acr_mask of
+	 * remaining group members. As ACR sampling requires all events to be active,
+	 * this limitation is acceptable for now. Revisit if independent event toggling
+	 * is required.
+	 */
 	for (i = 0; i < cpuc->n_events; i++) {
 		leader = cpuc->event_list[i];
 		if (!is_acr_event_group(leader))
 			continue;
 
-		/* The ACR events must be contiguous. */
+		/* Find the last event of the ACR group. */
 		for (j = i; j < cpuc->n_events; j++) {
 			event = cpuc->event_list[j];
 			if (event->group_leader != leader->group_leader)
 				break;
-			for_each_set_bit(idx, (unsigned long *)&event->attr.config2, X86_PMC_IDX_MAX) {
-				if (i + idx >= cpuc->n_events ||
-				    !is_acr_event_group(cpuc->event_list[i + idx]))
-					return;
-				__set_bit(cpuc->assign[i + idx], (unsigned long *)&event->hw.config1);
+		}
+
+		/*
+		 * Translate the user-space ACR mask (attr.config2) into the physical
+		 * counter bitmask (hw.config1) for each ACR event in the group.
+		 * NOTE: ACR event contiguity is guaranteed by intel_pmu_hw_config().
+		 */
+		for (k = i; k < j; k++) {
+			event = cpuc->event_list[k];
+			event->hw.config1 = 0;
+			for_each_set_bit(bit, (unsigned long *)&event->attr.config2, X86_PMC_IDX_MAX) {
+				idx = i + bit;
+				/* Event index of ACR group must locate in [i, j). */
+				if (idx >= j || !is_acr_event_group(cpuc->event_list[idx]))
+					continue;
+				__set_bit(cpuc->assign[idx], (unsigned long *)&event->hw.config1);
 			}
 		}
 		i = j - 1;


