Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D6E5BE69A;
	Mon, 19 Oct 2026 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418469; cv=none; b=g7Yo4G1CoeawGCx7dX9OJlINl0fC9Uz0cCaifq2MHzJwnYHl7hZXgDfdKphYHI06KT4ziSVPQJjk6I9JcvOFPX7MlkkV+ROtCeBN28FZceQ9wg9T/gjoVwKfnHXCIcXL6Yl6RcT/aEniQFRZk8tacPi8+Y3sOqU4mypjMTHCrQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418469; c=relaxed/simple;
	bh=pWdHP9LHEKz+sABbungOTDUeh0Z4zqzoeeY4zbHYH+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DS4YwJP8qfGRGpOQmXI4218IZfTPEk5DE5A96tvZNPYa6k/HAIm5Tr2PbXuVRJQvfKctOT/odpgZMih8UAtVP92eEWDgchJ/wxJOpTd23hlDqfrMm/Xl4C2WCZqFFrVoLe2w6hhDmT5GciR6Jb8hJ1VnA0a+9VSOdNHcn+QOloY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZb2M6IK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZb2M6IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F95A1F000CA;
	Mon, 19 Oct 2026 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418467;
	bh=lJlw6GhXp1L1rVQ4RJd14E3+3JJvpD0/PFLiCS+TtDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZb2M6IKha4110qa8pjwQOWKVKtq4azzbl/EltGrYAFX6d/rjwfb4L9d71RGIno6k
	 eqwTHI2+IkPL7eWwLRrGUiLOTqtmqK68l9rd47jHpSMP31nYAuOo3LCAIAs3pBep9m
	 aBFGw9NnOAe2qdFF3RoHiw1JtMbJSCdyvAuR+u/YKkrm5uw35FKG9GLCW1oQS8giEQ
	 OlzoTozmmd9S0ue7MuS4DC5PhPh0IytA6XdS29m8nXiP4UaL+y/jrWjj7oDH4/O9Kv
	 ioxmUmH+NMSU5BiMRmkg3jI7Sk793HQCZoovdyAjj7KA8EbH42pZF8G+xXA35EG5P9
	 dr9nVMCB+IVdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Grech <bgrech@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] selftests/net: fin_ack_lat: fix latency threshold typo
Date: Mon, 19 Oct 2026 09:49:20 -0400
Message-ID: <20261019135441.1420968-269-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Grech <bgrech@redhat.com>

[ Upstream commit 2373107782a98ba15931a37bbd9dd46d7213e5aa ]

The commit message for af8c8a450bf4 ("selftests: net: Add FIN_ACK
processing order related latency spike test") states: "if the latency
is larger than 1 second (spike), print a message". However the code
uses a threshold of 100000 us (100 ms), not 1000000 us (1 s).

The lower threshold causes false positives on slower hardware where
normal connection latency occasionally exceeds 100 ms but never
approaches the 1 s spike that indicates the actual FIN/ACK race bug.

Fix the threshold to match the documented intent.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Brian Grech <bgrech@redhat.com>
Link: https://patch.msgid.link/20260806151645.4172900-1-bgrech@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local 6.12 tree, the one-line typo, mailing-list review, and
a clean apply. Compiling the nine-phase analysis next.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[selftests/net] [fix] latency threshold typo in fin_ack_lat`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS** (from the presented message
and from `git show 2373107782a9`)
- `Reviewed-by: Simon Horman <horms@kernel.org>`
- `Signed-off-by: Brian Grech <bgrech@redhat.com>` (author)
- `Link:
  https://patch.msgid.link/20260806151645.4172900-1-bgrech@redhat.com`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer,
  applied it)
- No `Reported-by`, `Tested-by`, `Acked-by` in the committed message
- Committed message has no `Fixes:` / `Cc: stable` (those tags were on
  mailing-list v3; they are not treated as “already selected”)
- Record: Reviewed by a netdev reviewer; applied by the net maintainer.
  Author is Red Hat.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record: [Bug] `fin_ack_lat` treats latency ≥ 100000 µs (100 ms) as a
  spike, while the original test commit says the spike is **1 second**.
  [Symptom] false FAIL printouts on slower/loaded hardware when normal
  localhost connect latency is 100 ms–1 s. [Version] original test is
  `af8c8a450bf4` (2020). [Root cause] missing zero: 100000 vs 1000000.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not hidden. Explicit typo/threshold bug in a kselftest. “fix”
  is accurate.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: `tools/testing/selftests/net/fin_ack_lat.c` — 1 line changed
  (`100000` → `1000000`). Function: `client()`. Scope: single-file, one-
  line surgical fix. `git show --stat`: `1 file changed, 1 insertion(+),
  1 deletion(-)`.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record: After `connect`/`send`/`read`, `timediff()` returns
  microseconds (`tv_sec * 1000000 + tv_usec`). If `lat < threshold`,
  skip the printf and close. Before: print (and the wrapper script
  counts a FAIL) at ≥ 100 ms. After: only at ≥ 1 s.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: [Category] logic/correctness (wrong constant). [Mechanism]
  threshold was 10× too low vs documented 1 s spike that matches
  `TCP_TIMEOUT_INIT` (1×HZ). Wrapper `fin_ack_lat.sh` fails if any spike
  line is printed.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: Obviously correct vs the original commit text and vs
  `timediff()` units. Minimal. Regression risk is that 100 ms–1 s events
  would no longer FAIL; that is intended, because those are not the
  FIN/ACK race (which waits a full initial RTO of 1 s). No
  API/locking/kernel-runtime change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: Line 72 (`if (lat < 100000)`) blamed to `af8c8a450bf469`
  (SeongJae Park, 2020-02-02). Introduced with the test; never changed
  since.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Committed message has no `Fixes:` tag. Mailing-list v3 cited `Fixes:
  af8c8a450bf4`.
- `git merge-base --is-ancestor af8c8a450bf4 HEAD` → yes (exit 0).
- Original test message: “if the latency is larger than 1 second
  (spike), print a message.”
- Related kernel fix `9603d47bad464` (“tcp: Reduce SYN resend delay if a
  suspicous ACK is received”) is also an ancestor; it describes the 1 s
  `TIMEOUT_INIT` reconnection spike this test is for.

**Step 3.3: CHECK FILE HISTORY**
- Record: Only one commit on this file in this tree: `af8c8a450bf46`. No
  later refactor. Standalone, not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: `git log --author="Brian Grech" --
  tools/testing/selftests/net/` is empty in this tree (author is not a
  6.12 net-selftest regular). Reviewer Horman and committer Kicinski are
  netdev maintainers/reviewers.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: None. Only changes a numeric constant. `git apply --check` of
  `2373107782a9` succeeds on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: `b4 dig -c 2373107782a9` →
  https://patch.msgid.link/20260806151645.4172900-1-bgrech@redhat.com
- Revisions (`b4 dig -a`):
  - v1: 2026-07-31,
    https://patch.msgid.link/20260731145914.4014912-1-bgrech@redhat.com
  - v2: 2026-08-04 (added maintainer CCs)
  - v3: 2026-08-06 (applied)
- Horman (2026-08-06): looks good; “might be nice” to explain why 1 s;
  “if this is a fix to be backported (I am unsure)” then add `Fixes:`
  and target `net`. **Reviewed-by** given; no NAK.
- Author replied and sent v3 with original-commit wording, `Fixes:`, and
  `Cc: stable`.
- Applied to netdev/net-next by Jakub Kicinski (`2373107782a9`). No NAKs
  in the saved thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record (`b4 dig -w`): netdev, linux-kselftest, Shuah Khan, Eric
  Dumazet, Paolo Abeni, Simon Horman, Jakub Kicinski. Right lists and
  maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No syzbot/bugzilla. Evidence is the commit text plus a Red Hat
  author describing loaded/slower-hardware false positives. Severity:
  incorrect kselftest FAIL, not a kernel oops.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Standalone 1-patch series. No sibling patches required.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable search via WebFetch returned 403. Web
  search did not find a stable-list rejection or discussion of this fix.
  UNVERIFIED: no confirmed stable@ thread beyond v3 CCing stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
- Record: `client()` only.

**Step 5.2: TRACE CALLERS**
- Record: `main()` forks and the child calls `client(port)`. Userspace-
  only. `fin_ack_lat.sh` runs `./fin_ack_lat` for 30s and FAILs if any
  stdout spike line appears. Makefile: `TEST_PROGS += fin_ack_lat.sh`,
  `TEST_GEN_FILES += fin_ack_lat` — part of default net selftests.

**Step 5.3: TRACE CALLEES**
- Record: socket/connect/send/read, `timediff()`, `printf` on spike. No
  kernel helpers.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Reachable by running the net kselftest (localhost TCP). Not a
  syscall bug; it is the test harness for the 2020 FIN/ACK race.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Only this one comparison. `timediff()` already uses `*
  1000000` (µs), which confirms 1000000 = 1 s.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: Yes. This checkout is **6.12.111** (`pending-6.12`,
  `p-6.12-3-gc504cf0baa3d8`). `fin_ack_lat.c:72` is still `if (lat <
  100000)`. Introduced 2020-02 (`af8c8a450bf4`); present throughout
  6.12. Candidate `2373107782a9` is **not** an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: `git diff af8c8a450bf4 HEAD --
  tools/testing/selftests/net/fin_ack_lat.c` is empty. `git apply
  --check` of the candidate succeeds. Expected: **clean apply**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: `git log --grep="fin_ack_lat: fix latency"` and
  `--grep="latency threshold typo"` on that path: empty. No alternate
  fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
- Record: `tools/testing/selftests/net/` — kselftest, not kernel
  runtime. Criticality: **PERIPHERAL** for production machines;
  **IMPORTANT** for people who run net selftests on 6.12 (distro CI, LTS
  validation).

**Step 7.2: SUBSYSTEM ACTIVITY**
- Record: Net selftests are active in 6.12; this **file** is untouched
  since 2020 (mature, long-standing typo).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
- Record: Anyone running `tools/testing/selftests/net`
  (`fin_ack_lat.sh`). Not production TCP. Config: standard net
  kselftests.

**Step 8.2: TRIGGER CONDITIONS**
- Record: 30 s of localhost connect/send/read. False FAIL when a loop
  exceeds 100 ms (loaded CI, slow VM, embedded). Unprivileged users can
  run the test; this is not a security trigger.

**Step 8.3: FAILURE MODE SEVERITY**
- Record: Incorrect kselftest FAIL (script: `FAIL: N spikes detected`).
  No oops, hang, or corruption. Severity: **MEDIUM** for testers/CI,
  **LOW** for production runtime. The kernel bug the test is meant to
  catch is a ~1 s SYN retry (`TCP_TIMEOUT_INIT` = `1*HZ` in
  `include/net/tcp.h`).

**Step 8.4: RISK-BENEFIT RATIO**
- Record: Benefit: stops false FAILs on 6.12 net selftests; restores the
  1 s meaning the test was written for. Risk: one constant in userspace;
  no kernel change. Ratio: **high benefit for testers / very low risk**.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

FOR:
- Real, documented mismatch: commit `af8c8a450bf4` says 1 s; code uses
  100 ms.
- `timediff()` is in microseconds; 1000000 µs is 1 s.
- Kernel symptom being tested is a 1 s initial RTO (`TCP_TIMEOUT_INIT`),
  not 100 ms.
- Wrapper treats any printed spike as FAIL, so the typo causes false
  failures.
- File and bug exist in this 6.12 tree unchanged since 2020.
- One-line, applies cleanly, userspace-only.
- Reviewed-by Horman; applied by Kicinski.
- Author (Red Hat) describes slower/loaded-system false positives — a
  real “bothers people” case for LTS testing.

AGAINST:
- Not a kernel crash, UAF, deadlock, or CVE.
- Horman was unsure about backport before v3.
- Applied via net-next; committed message dropped `Fixes:`/`Cc: stable`.
- Only testers are affected.

UNRESOLVED:
- Could not read lore.kernel.org/stable (403). No evidence of a stable
  rejection.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — units, original docs, and
   TCP_TIMEOUT_INIT all agree; reviewed.
2. Fixes a real bug that affects users? **PASS** — false kselftest FAILs
   on slower/loaded hardware; Red Hat author.
3. Important issue? **PASS** (as “oh, that's not good” / broken default
   net selftest), not as a production crash. Official `stable-kernel-
   rules.rst` allows a real bug that bothers people, not only
   oops/hang/CVE.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS**.
6. Can apply to this tree? **PASS** — clean apply; buggy code present.

**Step 9.3: EXCEPTION CATEGORIES**
- Record: Not a device-ID/quirk/DT/build/docs exception. Closest
  analogue: **test/tooling correctness** (same spirit as a build fix:
  helps people who build and test this kernel).

**Step 9.4: DECISION**

This tree is **6.12.111**. The typo is in-tree, the 1 s threshold is
what the test and the TCP bug both mean, and the patch is a one-line
userspace correction with no kernel regression surface. That is
appropriate for 6.12 stable: it stops false net-selftest failures
without changing runtime behavior.

---

## What the commit solves for stable users

On 6.12, `fin_ack_lat` is a default net selftest. It is supposed to flag
the ~1 s reconnect spike from FIN/ACK processing order
(`TCP_TIMEOUT_INIT`). A missing zero makes it flag ≥100 ms instead, so
loaded or slow machines can FAIL without the actual TCP bug. Distros and
anyone running kselftests on 6.12 get noisy, wrong results.

## Stable rules / risk vs benefit

It is obviously correct, tiny, already reviewed, and applies cleanly.
Benefit is reliable tests; risk is negligible. It does not fix a
production crash, but it does fix a real, user-visible test bug in this
tree.

## Concerns

None that block a backport: no missing prerequisites, no file drift, no
kernel ABI change. Raising the threshold will ignore 100 ms–1 s events;
that matches the original design.

---

## Verification
- [Phase 1] Parsed committed tags on `2373107782a9`; Horman Reviewed-by;
  Kicinski SOB; no Fixes in committed text
- [Phase 1] Original test commit `af8c8a450bf4` text: “larger than 1
  second (spike)”
- [Phase 2] Diff: one comparison in `client()`, 100000 → 1000000
- [Phase 2] `timediff()` uses `tv_sec * 1000000` (microseconds) —
  verified in `fin_ack_lat.c`
- [Phase 2] `fin_ack_lat.sh` FAILs if any spike line is printed —
  verified
- [Phase 3] `git blame` line 72 → `af8c8a450bf469` (2020-02-02)
- [Phase 3] `git merge-base --is-ancestor af8c8a450bf4 HEAD` → yes;
  `2373107782a9` → no
- [Phase 3] `9603d47bad464` (TCP SYN resend / 1 s spike) is an ancestor
- [Phase 3] File unmodified after introduction (`git diff af8c8a450bf4
  HEAD -- fin_ack_lat.c` empty)
- [Phase 3] `git apply --check` of candidate → success
- [Phase 4] `b4 dig -c 2373107782a9` → lore msgid
  `20260806151645.4172900-1-bgrech@redhat.com`
- [Phase 4] `b4 dig -a`: v1 (2026-07-31), v3 (2026-08-06, applied)
- [Phase 4] `b4 dig -m`: Horman Reviewed-by; unsure about backport; no
  NAK; v3 added Fixes + Cc: stable on the list
- [Phase 4] Patchwork: applied to net-next as `2373107782a9`
- [Phase 4] UNVERIFIED: stable@ archive (lore 403)
- [Phase 5] `client()` called only from forked `main()`; Makefile lists
  the test in `TEST_PROGS`
- [Phase 5] `TCP_TIMEOUT_INIT` is `1*HZ` in `include/net/tcp.h`
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111; line 72 still `100000`
- [Phase 8] Failure mode: kselftest false FAIL, not kernel oops;
  severity MEDIUM for testers

**YES**

 tools/testing/selftests/net/fin_ack_lat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fin_ack_lat.c b/tools/testing/selftests/net/fin_ack_lat.c
index 70187494b57af..4117332eb1a9c 100644
--- a/tools/testing/selftests/net/fin_ack_lat.c
+++ b/tools/testing/selftests/net/fin_ack_lat.c
@@ -69,7 +69,7 @@ static void client(int port)
 		lat = timediff(start, end);
 		sum_lat += lat;
 		nr_lat++;
-		if (lat < 100000)
+		if (lat < 1000000)
 			goto close;
 
 		if (getsockname(sock, (struct sockaddr *)&laddr, &len) == -1)
-- 
2.53.0

