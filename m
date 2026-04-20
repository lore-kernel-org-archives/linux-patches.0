Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E822341C307;
	Mon, 20 Apr 2026 13:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691654; cv=none; b=TVwk/wTKvbT2zDGPz8cT/oz8xVM/6O198TmPoM6BACX2BCsFHSJdzzjJSF3K/kpvO7izmcQZfKd7AZOPkc73MrUMi26Y7ueaedFQ4WJbOLjanX04U9nNdfyNAD0VdmtCi7FRqB/aesJW2r0vq3le0lyAdZUoACJbBCrD6wezIWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691654; c=relaxed/simple;
	bh=buwyR++9CurJdz+jiz3qwQE0qZO4hCUjznEc2NetFsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9PXfHex6ziQtTcdk/0+vVSdumVIEGWBaEv1TeicxbI20isGfTm2aQxaucasTHer8/0ndqXRC41gFei0+181Q/cmQawAx0mLr45L7CSR+ZXlBAiE9l3Kpn3p0wKUHoccLSM72pXRwnruYEGsw9qVwvKHAweckJXQcCqX9dmMa+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEwo+Lh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEwo+Lh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E81C2BCB7;
	Mon, 20 Apr 2026 13:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691653;
	bh=buwyR++9CurJdz+jiz3qwQE0qZO4hCUjznEc2NetFsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEwo+Lh6PIdZgfdg4i15+C9sdnfJRpfHr6wmtdqk1M3kIQCEO2D12tsxi8U0Lk+fW
	 stMtU8PwdzJGH/ZQobU+vyLE5mTbipwJHQthZKWrzjzaFBE6+B8wp3NrEF96tpo/4k
	 WjdhYiYis3l3xkc+DDOVJC7TBV7BE2eI4C6J3XFdFfeQ05s/otaYKXF7XmyoxVMrHA
	 b0g6UZvzvg9SQnp3YTTng9npGexNv8fAt28sw3HaU7wO6n7zAfBxwRjjBHoZqenFbO
	 6xlLNKfcNhskWakr9p5DBiny/ys1Ej966FvHhEDmRzhEI/to66nJuODTLsqzKMMnLb
	 Rq+Udbcgob2bA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	rostedt@goodmis.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] rtla: Handle pthread_create() failure properly
Date: Mon, 20 Apr 2026 09:19:08 -0400
Message-ID: <20260420132314.1023554-154-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit d847188bb92b14518a04d7542e44928a22060847 ]

Add proper error handling when pthread_create() fails to create the
timerlat user-space dispatcher thread. Previously, the code only logged
an error message but continued execution, which could lead to undefined
behavior when the tool later expects the thread to be running.

When pthread_create() returns an error, the function now jumps to the
out_trace error path to properly clean up resources and exit. This
ensures consistent error handling and prevents the tool from running
in an invalid state without the required user-space thread.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260309195040.1019085-10-wander@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me compile the full analysis.

---

## Phase 1: Commit Message Forensics

**Step 1.1: Subject Line**
- Subsystem: `rtla` (Real-Time Linux Analysis tool, under
  `tools/tracing/rtla`)
- Action verb: "Handle" (strongly suggests fixing incorrect handling - a
  bug fix pattern)
- Summary: Add proper error handling when pthread_create() fails for the
  timerlat user-space dispatcher thread.

Record: [rtla] [Handle] [Add missing error path when pthread_create
fails]

**Step 1.2: Tags**
- `Signed-off-by: Wander Lairson Costa <wander@redhat.com>` - author,
  Red Hat engineer
- `Link:
  https://lore.kernel.org/r/20260309195040.1019085-10-wander@redhat.com`
  - part of a larger series (patch 10 of a series)
- `Signed-off-by: Tomas Glozar <tglozar@redhat.com>` - maintainer sign-
  off
- No Fixes: tag (expected for autosel candidates)
- No Reported-by: (found by code review, not user report)
- No Cc: stable (expected)

Record: Author is Wander (Red Hat, active rtla contributor). Part of a
larger series (patch 10). Accepted by Tomas Glozar (rtla maintainer).

**Step 1.3: Body Text**
The commit message clearly describes: when `pthread_create()` fails, the
code only logged an error but continued execution. This leads to the
tool running in an invalid state where it expects user-space threads
that don't exist.

Record: Bug = missing error exit on pthread_create failure. Symptom =
tool runs without required user-space thread. Root cause = missing `goto
out_trace` on error path.

**Step 1.4: Hidden Bug Fix Detection**
"Handle ... properly" is a classic bug-fix pattern. This IS a bug fix -
it adds a missing error exit path.

Record: Yes, this is a clear bug fix despite not using the word "fix" in
the subject.

## Phase 2: Diff Analysis

**Step 2.1: Changes Inventory**
- 1 file modified: `tools/tracing/rtla/src/common.c`
- Net change: +3 lines / -1 line (added braces + `goto out_trace;`)
- Function modified: `run_tool()`
- Scope: Single-file, surgical fix

**Step 2.2: Code Flow Change**
Before: `pthread_create()` failure logged an error message but execution
continued to `ops->enable(tool)`, `ops->main(tool)`, etc.
After: `pthread_create()` failure logs error and jumps to `out_trace`
for proper cleanup and exit.

**Step 2.3: Bug Mechanism**
Category: (a) Error path fix. The code was missing a `goto` to the error
cleanup path when `pthread_create()` failed. Without it, the tool runs
without the user-space timerlat threads, producing incorrect/misleading
measurements.

**Step 2.4: Fix Quality**
- Obviously correct: follows the identical pattern used by all other
  error checks in the same function (lines 247, 253, 280, 287)
- Minimal/surgical: only adds braces and a `goto`
- Regression risk: extremely low - only changes behavior when
  `pthread_create()` fails (which is already an error condition)

Record: Fix is obviously correct, minimal, and consistent with
surrounding code patterns. No regression risk.

## Phase 3: Git History Investigation

**Step 3.1: Blame**
The buggy code (lines 257-276) was introduced by commit `2f3172f9dd58cc`
("tools/rtla: Consolidate code between osnoise/timerlat and hist/top")
by Crystal Wood, September 2025. However, tracing further back, the
original missing error handling existed since commit `cdca4f4e5e8ea`
("rtla/timerlat_top: Add timerlat user-space support") by Daniel Bristot
de Oliveira, June 2023 (v6.5-rc1).

Record: Bug introduced in v6.5-rc1, present in all stable trees from
6.6.y onward. The consolidation commit just carried the bug forward into
`common.c`.

**Step 3.2: Fixes Tag**
No Fixes: tag present (expected for autosel candidates). The bug
logically traces to `cdca4f4e5e8ea` (v6.5-rc1).

**Step 3.3: File History**
The file has been actively developed. Recent commits include
consolidations of option parsing, volatile fix for stop_tracing, and
other improvements. The author (Wander Lairson Costa) is a prolific
contributor to rtla.

**Step 3.4: Author**
Wander has at least 17 commits in rtla (including multiple fixes like
NULL pointer dereference fix, parse return value doc fix, volatile fix).
He is a regular contributor and maintainer-level contributor for rtla.

Record: Author is a regular, trusted contributor to this subsystem.

**Step 3.5: Dependencies**
The `run_tool()` function and the `out_trace` label already exist in the
7.0 tree. No dependencies needed. However, the `run_tool()` function
only exists since the consolidation commit `2f3172f9dd58cc` (~v6.18
cycle). In older stable trees (6.6.y, 6.12.y), the same fix would need
to target `timerlat_top.c` and `timerlat_hist.c` instead.

Record: For 7.0.y, applies standalone with no dependencies. For older
trees, would need different patches.

## Phase 4: Mailing List and External Research

**Step 4.1-4.2: Patch Discussion**
The commit's Link tag shows it's patch 10 of a series (Message-ID
`20260309195040.1019085-10-wander@redhat.com`). Lore.kernel.org was
blocked by anti-bot protection, but b4 dig confirmed the author's other
patches in the same series (e.g., `20260106133655.249887-16` for the
volatile fix). The patch was accepted and signed off by maintainer Tomas
Glozar.

Record: Part of a larger cleanup/fix series. Accepted by rtla
maintainer.

**Step 4.3-4.5: Bug Report / Stable Discussion**
No explicit bug report found. This appears to be found by code
review/audit, not by a user hitting it in practice.

Record: No user reports. Found by code inspection.

## Phase 5: Code Semantic Analysis

**Step 5.1: Functions Modified**
Only `run_tool()` in `common.c`.

**Step 5.2: Callers**
`run_tool()` is the unified entry point for all rtla tool modes (osnoise
top/hist, timerlat top/hist). It's called from each tool's main
function.

**Step 5.3-5.4: Call Chain**
When `pthread_create()` fails and execution continues:
1. `ops->enable(tool)` - enables tracing infrastructure
2. `ops->main(tool)` - runs main measurement loop (top_main_loop or
   hist_main_loop)
3. Both main loops check `params->user.stopped_running` to detect if
   user threads died
4. Since threads were never created, `stopped_running` stays at 0, so
   the tool thinks threads are still running
5. The tool produces measurements and statistics without user-space
   thread contributions

**Step 5.5: Similar Patterns**
The original code in `timerlat_top.c` and `timerlat_hist.c` (pre-
consolidation) had the identical missing error handling pattern,
confirming this is a systematic bug.

## Phase 6: Cross-Referencing and Stable Tree Analysis

**Step 6.1: Buggy Code in Stable**
The `run_tool()` function in `common.c` only exists since ~v6.18 cycle.
In 7.0.y, the code exists as-is and the patch applies cleanly. For older
stable trees, different patches targeting `timerlat_top.c` and
`timerlat_hist.c` would be needed.

**Step 6.2: Backport Complications**
For 7.0.y: clean apply expected - no conflicts.

**Step 6.3: Related Fixes**
No other fix for this specific issue found in stable.

## Phase 7: Subsystem and Maintainer Context

**Step 7.1: Subsystem**
`tools/tracing/rtla` - userspace real-time latency analysis tool.
Criticality: PERIPHERAL (userspace tool, not kernel code), but important
for real-time system validation.

**Step 7.2: Activity**
Very actively developed - 14+ commits since the consolidation.

## Phase 8: Impact and Risk Assessment

**Step 8.1: Who Is Affected**
Users of the rtla timerlat tool with `--user-threads` option,
specifically when `pthread_create()` fails.

**Step 8.2: Trigger Conditions**
Rare - requires `--user-threads` mode AND `pthread_create()` failure
(typically due to resource exhaustion or system limits).

**Step 8.3: Failure Mode Severity**
When triggered: tool continues running in invalid state, producing
measurements without user-space thread contributions. For a real-time
analysis tool, this means **silently incorrect results** (the error
message is printed but could be missed). Severity: MEDIUM (incorrect
tool output, not kernel crash/corruption).

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Moderate - prevents misleading latency measurements
- RISK: Very low - 2-line change to an error path only triggered on
  failure
- Ratio: Favorable

## Phase 9: Final Synthesis

**Step 9.1: Evidence**
FOR backporting:
- Fixes a real bug (missing error exit leads to invalid tool state)
- Small and surgical (3 lines changed)
- Obviously correct (follows identical pattern in same function)
- Very low regression risk
- Author is trusted contributor; accepted by maintainer
- Bug existed since v6.5

AGAINST backporting:
- Userspace tool, not kernel code
- Trigger condition is rare (pthread_create failure)
- No user reports of actually hitting this bug
- MEDIUM severity (incorrect tool output, not crash/corruption)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** - trivially correct
2. Fixes a real bug? **YES** - tool runs without required threads
3. Important issue? **MEDIUM** - incorrect measurements, not crash
4. Small and contained? **YES** - 3 lines in 1 file
5. No new features? **YES** - pure error handling fix
6. Can apply to stable? **YES** for 7.0.y

**Step 9.3: Exception Categories**
Not an exception category - standard bug fix.

**Step 9.4: Decision**
The fix is small, obviously correct, and prevents the rtla tool from
operating in an invalid state. While it's a userspace tool and the
trigger is rare, the fix has essentially zero regression risk and
improves correctness. The pattern of missing error handling on
`pthread_create()` failure is a clear bug.

## Verification

- [Phase 1] Parsed tags: Link to patch 10 of a series, SOBs from author
  and maintainer
- [Phase 2] Diff analysis: +3/-1 lines, adds `goto out_trace` to error
  path in `run_tool()`
- [Phase 3] git blame: buggy code carried from `cdca4f4e5e8ea`
  (v6.5-rc1) through consolidation `2f3172f9dd58cc`
- [Phase 3] git show 2f3172f9dd58cc: confirmed consolidation commit
  created `run_tool()` carrying the bug
- [Phase 3] Checked pre-consolidation files: both `timerlat_top.c` and
  `timerlat_hist.c` had identical missing error handling
- [Phase 4] b4 dig: confirmed author's series via `af2962d68b970` match
- [Phase 4] Lore blocked by anti-bot; could not read full thread
  discussion
- [Phase 5] Traced `run_tool()` flow: after failed pthread_create, tool
  continues to enable/main/stats without user threads
- [Phase 5] Verified `out_trace` cleanup path exists and is used by
  other error checks in same function
- [Phase 6] Code exists in 7.0.y (run_tool in common.c); older trees
  have equivalent code in different files
- [Phase 8] Failure mode: tool produces results without user-space
  threads, severity MEDIUM
- UNVERIFIED: Could not read full mailing list thread due to lore anti-
  bot protection

**YES**

 tools/tracing/rtla/src/common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/common.c b/tools/tracing/rtla/src/common.c
index ceff76a62a30b..68426ce6f9971 100644
--- a/tools/tracing/rtla/src/common.c
+++ b/tools/tracing/rtla/src/common.c
@@ -271,8 +271,10 @@ int run_tool(struct tool_ops *ops, int argc, char *argv[])
 		params->user.cgroup_name = params->cgroup_name;
 
 		retval = pthread_create(&user_thread, NULL, timerlat_u_dispatcher, &params->user);
-		if (retval)
+		if (retval) {
 			err_msg("Error creating timerlat user-space threads\n");
+			goto out_trace;
+		}
 	}
 
 	retval = ops->enable(tool);
-- 
2.53.0

