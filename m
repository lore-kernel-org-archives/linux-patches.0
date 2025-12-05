Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DE9286881;
	Fri,  5 Dec 2025 03:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764906767; cv=none; b=eh9J4efnIAqey7H3iqnQyivP9+Dbq52+ZISdFU88ppqhue623us8lATNbLwhUG87lV0rSC+Y1miKLV11Yfb239b9ulbOBCbb5AUf9Pj0Vh5jytY8nBVRVRQ3buYySSpfu73ng/2riTPz27TtcJo6vATZdOzfHwQM3f3G4tH2lmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764906767; c=relaxed/simple;
	bh=0OdxpCJvDb7qvb5LaiqErXaRFGaYIq0y/J6U8xLo63A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpKXf4yhpuwq0G6jc8WXEuL0porAGI3ZR4ZwfJQWcUVf58EwizAH2QG6x73QOWxLlzaYSC8LVoSZAtS5x4r2oYFAg+9eKWNp+hC9wYn9jG+bMEsAzA7gzF0r9VOXXD3bF+Mt9oJsBDoMNp7a2NQwisuWa3sLX2BHgfWe14XJ4r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iadIAdtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iadIAdtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6B7C4CEF1;
	Fri,  5 Dec 2025 03:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764906766;
	bh=0OdxpCJvDb7qvb5LaiqErXaRFGaYIq0y/J6U8xLo63A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iadIAdtSmjMtXqHYv5Dutyr5etH/P/BeW+bG70lEIK4hgVmkdLKKYHj7dJy8XvfiK
	 BKFWPprf26/ROLw1Fh97MkdKA3cXgx+dWWUzl6KR9j8xGfI73IiwS8pP/zfXtHxaMv
	 H9re1RUBqxDeh/CoL0dhcK491A1nITMZY1+Q7ZDyT71k2N/AL1OVf739hEHlWkAtZf
	 tX4eonyu2oVTtccPm359md+GCHz5T1O5R5vcqQxN51VHR/16rjef28kzNJw+9ddsqM
	 TmZ9LAjDshUvdeo9/gKAH0MO4HtRfjbYO88+TRns0S9jQ8ocRfAIsYpeZ+cXzL5VuZ
	 KhKveo1DsfEOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	quic_zhonhan@quicinc.com
Subject: [PATCH AUTOSEL 6.18-6.6] cpuidle: menu: Use residency threshold in polling state override decisions
Date: Thu,  4 Dec 2025 22:52:31 -0500
Message-ID: <20251205035239.341989-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205035239.341989-1-sashal@kernel.org>
References: <20251205035239.341989-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit 07d815701274d156ad8c7c088a52e01642156fb8 ]

On virtualized PowerPC (pseries) systems, where only one polling state
(Snooze) and one deep state (CEDE) are available, selecting CEDE when
the predicted idle duration is less than the target residency of CEDE
state can hurt performance. In such cases, the entry/exit overhead of
CEDE outweighs the power savings, leading to unnecessary state
transitions and higher latency.

Menu governor currently contains a special-case rule that prioritizes
the first non-polling state over polling, even when its target residency
is much longer than the predicted idle duration. On PowerPC/pseries,
where the gap between the polling state (Snooze) and the first non-polling
state (CEDE) is large, this behavior causes performance regressions.

Refine that special case by adding an extra requirement: the first
non-polling state can only be chosen if its target residency is below
the defined RESIDENCY_THRESHOLD_NS. If this condition is not satisfied,
polling is allowed instead, avoiding suboptimal non-polling state
entries.

This change is limited to the single special-case rule for the first
non-polling state. The general non-polling state selection logic in the
menu governor remains unchanged.

Performance improvement observed with pgbench on PowerPC (pseries)
system:
+---------------------------+------------+------------+------------+
| Metric                    | Baseline   | Patched    | Change (%) |
+---------------------------+------------+------------+------------+
| Transactions/sec (TPS)    | 495,210    | 536,982    | +8.45%     |
| Avg latency (ms)          | 0.163      | 0.150      | -7.98%     |
+---------------------------+------------+------------+------------+

CPUIdle state usage:
+--------------+--------------+-------------+
| Metric       | Baseline     | Patched     |
+--------------+--------------+-------------+
| Total usage  | 12,735,820   | 13,918,442  |
| Above usage  | 11,401,520   | 1,598,210   |
| Below usage  | 20,145       | 702,395     |
+--------------+--------------+-------------+

Above/Total and Below/Total usage percentages:
+------------------------+-----------+---------+
| Metric                 | Baseline  | Patched |
+------------------------+-----------+---------+
| Above % (Above/Total)  | 89.56%    | 11.49%  |
| Below % (Below/Total)  | 0.16%     | 5.05%   |
| Total cpuidle miss (%) | 89.72%    | 16.54%  |
+------------------------+-----------+---------+

The results indicate that restricting CEDE selection to cases where
its residency matches the predicted idle time reduces mispredictions,
lowers unnecessary state transitions, and improves overall throughput.

Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
[ rjw: Changelog edits, rebase ]
Link: https://patch.msgid.link/20251006013954.17972-1-aboorvad@linux.ibm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## COMPREHENSIVE ANALYSIS

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: "cpuidle: menu: Use residency threshold in polling state
override decisions"

**Key points**:
- Fixes a performance regression on PowerPC/pseries systems
- Problem: Menu governor selects deep state (CEDE) when predicted idle
  duration is less than target residency, causing unnecessary
  transitions and higher latency
- Solution: Adds a `RESIDENCY_THRESHOLD_NS` check to the special-case
  rule
- Impact: 8.45% TPS improvement, 7.98% latency reduction, significant
  reduction in cpuidle mispredictions (89.72% → 16.54%)

**Missing indicators**:
- No `Cc: stable@vger.kernel.org` tag
- No `Fixes:` tag
- No `Reported-by:` tag (no explicit bug report reference)

**Positive indicators**:
- `Reviewed-by:` present
- Performance metrics provided
- Clear problem description

### 2. CODE CHANGE ANALYSIS

**Exact change**:
```c
// BEFORE:
if ((drv->states[idx].flags & CPUIDLE_FLAG_POLLING) &&
    s->target_residency_ns <= data->next_timer_ns &&
    s->exit_latency_ns <= predicted_ns) {

// AFTER:
if ((drv->states[idx].flags & CPUIDLE_FLAG_POLLING) &&
    s->target_residency_ns < RESIDENCY_THRESHOLD_NS &&  // <-- NEW
CONDITION
    s->target_residency_ns <= data->next_timer_ns &&
    s->exit_latency_ns <= predicted_ns) {
```

**Technical analysis**:
- Adds one condition: `s->target_residency_ns < RESIDENCY_THRESHOLD_NS`
- `RESIDENCY_THRESHOLD_NS` is `(15 * NSEC_PER_USEC)` = 15 microseconds
  (defined in `drivers/cpuidle/governors/gov.h` since Aug 2023)
- Makes the override more selective: only override polling if the non-
  polling state's target residency is below 15μs
- Prevents selecting deep states (like CEDE) with high target residency
  when predicted idle time is short

**Root cause**: The special-case rule prioritized the first non-polling
state over polling even when its target residency was much longer than
predicted idle duration, causing suboptimal decisions on PowerPC/pseries
where the gap between polling (Snooze) and deep (CEDE) is large.

**Why this fixes it**: By requiring target residency < 15μs, it avoids
deep state entry when the overhead exceeds benefit, reducing unnecessary
transitions and improving throughput.

### 3. CLASSIFICATION

**Bug fix or feature?**: Bug fix addressing a performance regression.

**Exception categories**:
- Not a device ID addition
- Not a quirk/workaround
- Not a DT update
- Not a build fix
- Not documentation-only

**Security**: No security implications.

### 4. SCOPE AND RISK ASSESSMENT

**Lines changed**: 1 line added, comment updated (5 insertions, 4
deletions total)

**Files touched**: 1 file (`drivers/cpuidle/governors/menu.c`)

**Complexity**: Low — single condition added to existing logic

**Subsystem**: `drivers/cpuidle/governors/` — mature, core power
management

**Risk assessment**:
- Low risk: Conservative change that makes the governor more selective
- No new code paths
- No API changes
- Limited to one special-case rule
- Well-tested (performance metrics provided)

**Potential concerns**:
- The code being modified was introduced in commit `17224c1d2574d2` (Aug
  13, 2025) — very recent
- Older stable trees (e.g., 6.1.y, 5.15.y) may not have this exact code
  structure
- The polling override logic has existed since at least 2018, but the
  exact form with `exit_latency_ns` check is recent

### 5. USER IMPACT

**Who is affected**: PowerPC/pseries systems (virtualized PowerPC),
specifically those with:
- One polling state (Snooze)
- One deep state (CEDE)
- Large gap between polling and deep state target residencies

**Severity**: Performance regression (not crash/corruption)
- Measurable impact: 8.45% TPS improvement, 7.98% latency reduction
- Significant reduction in cpuidle mispredictions
- Affects commonly-used code path (idle state selection)

**Stable rules reference**: Documentation/process/stable-kernel-
rules.rst states:
> "Serious issues as reported by a user of a distribution kernel may
also be considered if they fix a notable performance or interactivity
issue."

This qualifies as a notable performance issue.

### 6. STABILITY INDICATORS

- `Reviewed-by: Christian Loehle <christian.loehle@arm.com>`
- Performance testing results included
- Signed-off by maintainer (Rafael J. Wysocki)
- Commit date: Oct 6, 2025 (recent, but has been in mainline)

### 7. DEPENDENCY CHECK

**Dependencies**:
1. `RESIDENCY_THRESHOLD_NS` constant — introduced Aug 10, 2023 (commit
   `5484e31bbbff2`) in `drivers/cpuidle/governors/gov.h`
   - Should be available in stable trees 6.1.y and newer (6.1 was
     released in Dec 2022, but stable trees receive updates)
   - May not exist in very old stable trees (5.15.y, 5.10.y)

2. The specific code structure being modified — introduced Aug 13, 2025
   (commit `17224c1d2574d2`)
   - Very recent; may not exist in older stable trees
   - The polling override logic exists in older forms, but the exact
     structure differs

**Backport considerations**:
- For stable trees with the Aug 2025 code: applies cleanly
- For older stable trees: may require adaptation or may not apply if the
  code structure differs significantly

### 8. HISTORICAL CONTEXT

**Evolution of the polling override logic**:
- 2018 (commit `96c3d11df1532`): Basic polling override logic existed
  with different conditions
- Aug 2023: `RESIDENCY_THRESHOLD_NS` introduced
- Aug 2025: Current form of the special-case rule introduced (with
  `exit_latency_ns` check)
- Oct 2025: This commit refines the rule by adding
  `RESIDENCY_THRESHOLD_NS` check

**Related commits**: Multiple recent commits address polling state
selection:
- `a60be7339353f`, `ef14be6774d3f`, `acbbd683b3ea6`: "Select polling
  state in some more cases"
- Suggests ongoing refinement of this logic

### 9. STABLE KERNEL RULES COMPLIANCE

**Meets criteria**:
- ✅ Obviously correct and tested (small change, reviewed, performance
  tested)
- ✅ Fixes a real bug (performance regression on PowerPC/pseries)
- ✅ Small and contained (1 line added)
- ✅ No new features (refines existing logic)
- ✅ Important issue (notable performance regression per stable rules)

**Concerns**:
- ⚠️ No `Cc: stable@vger.kernel.org` tag (maintainer did not explicitly
  request backport)
- ⚠️ Code being modified is very recent (Aug 2025) — may not exist in
  older stable trees
- ⚠️ Performance fix, not crash/corruption (acceptable per stable rules,
  but less critical)

**Risk vs benefit**:
- Benefit: Fixes measurable performance regression (8.45% improvement)
  affecting PowerPC/pseries users
- Risk: Low — conservative change, well-tested, limited scope
- Trade-off: Favorable — low risk, clear benefit for affected users

### 10. FINAL ASSESSMENT

**Strengths**:
1. Fixes a real, measurable performance regression
2. Small, conservative change
3. Well-tested with performance metrics
4. Reviewed and signed-off by maintainer
5. Low risk of regression
6. Addresses a notable performance issue (acceptable per stable rules)

**Weaknesses**:
1. No `Cc: stable` tag from maintainer
2. Code being modified is very recent (may not exist in older stable
   trees)
3. Performance fix, not crash/corruption
4. Platform-specific (PowerPC/pseries), though the logic is general

**Recommendation**: YES, with caveats

This commit should be backported to stable trees because:
- It fixes a real performance regression with measurable impact
- The change is small, conservative, and low-risk
- Performance regressions are acceptable per stable rules
- The fix is obviously correct and well-tested

**Caveats**:
- Only applies to stable trees that have the Aug 2025 code structure
  (likely 6.6.y and newer)
- For older stable trees, verify the code structure exists before
  backporting
- If the exact code doesn't exist, may require adaptation or may not be
  applicable

**YES**

 drivers/cpuidle/governors/menu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 23239b0c04f95..64d6f7a1c7766 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -317,12 +317,13 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		}
 
 		/*
-		 * Use a physical idle state, not busy polling, unless a timer
-		 * is going to trigger soon enough or the exit latency of the
-		 * idle state in question is greater than the predicted idle
-		 * duration.
+		 * Use a physical idle state instead of busy polling so long as
+		 * its target residency is below the residency threshold, its
+		 * exit latency is not greater than the predicted idle duration,
+		 * and the next timer doesn't expire soon.
 		 */
 		if ((drv->states[idx].flags & CPUIDLE_FLAG_POLLING) &&
+		    s->target_residency_ns < RESIDENCY_THRESHOLD_NS &&
 		    s->target_residency_ns <= data->next_timer_ns &&
 		    s->exit_latency_ns <= predicted_ns) {
 			predicted_ns = s->target_residency_ns;
-- 
2.51.0

