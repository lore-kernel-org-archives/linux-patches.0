Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD00645085;
	Mon, 19 Oct 2026 14:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418786; cv=none; b=hg7G/Tggf/jGPQra/b7OcSNplTo5yxM/wPlQW99GL0CyxaqYDU5zmmBmCsRZvib2/wKo7NGgQNUN56a3yhydrpv5M9uGnCyoPYM2eQGEdhkbaHMr+nVK1JeqjYi/mwkgQWc4oen5q24NRxWRThOMtkPHDbdOBR6xQazMWRC6WYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418786; c=relaxed/simple;
	bh=fpbUBSic+Y0uy5UHJ532+VtLkF+liEMy0afhOOEyUj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHH0sSX/MU8PVgO7kAb1yxvBIStWZXZRMtzRhmleNhfMSSjs2OHVwQNI/MaPIMpfAkwUtxSXRDr2ESxVWum55G5l87g2Cy7o9KDwcB+mEhFUqMm/4q5KVQcSwuNjiGDgaa9Ri9vzeaBaDjEu3rklNz83VTw1jLD5axzla9Mf8uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9/nQD7S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9/nQD7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D641E1F000C5;
	Mon, 19 Oct 2026 14:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418784;
	bh=2Cqt/StO5wJRmyuqhqdQe+vFzWCcT9Y1VHmZC4EWq60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9/nQD7StqWbgAGRjAOY28lNWp7VlJALTWwOSu9hVt2wguy76/Db8F85SL70PoRbf
	 Wm8bIVD5JHKkI6I8+qENXxIedNbBnNQr6/OxMxkyALuTWJyiIUOfYcJ+2WbNa8vP6Z
	 Bm3QKYJGW/B/HIQnikepUrX90/wfL6iXuxcODTR3ri0lNAReehMIf7Tvm/btlD4kj7
	 04JwFw01TrCjj4Aro2qgQIYKtuFnxoSFojzGoJyx2IMkszhQAjZVmTu4tMMOKqmhGP
	 LTK9VyC4cg/x7Tg+zLnhZ1wA8XfUUO8OiVydRuIqq0auJNWkciqLcoq45lPesHQuGx
	 nPb9VXWTX23bA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Haufler <andreas@haufler.info>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] tools/lib/thermal: Fix misplaced extern "C" closing brace
Date: Mon, 19 Oct 2026 09:53:05 -0400
Message-ID: <20261019135441.1420968-494-sashal@kernel.org>
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

From: Andreas Haufler <andreas@haufler.info>

[ Upstream commit cb0ec27efac2aaf92393ad563a35fb6f00d0a6cd ]

The public libthermal header opens the C++ 'extern "C" {' block inside
the __LIBTHERMAL_H include guard, but places the closing brace after
the guard has already ended:

	#endif /* __LIBTHERMAL_H */

	#ifdef __cplusplus
	}
	#endif

On a single inclusion the braces still balance, so the problem is
invisible. On the second inclusion of the header in the same C++
translation unit the include guard skips the opening 'extern "C" {',
while the closing '}' lives outside the guard and is emitted anyway.
This leaves a stray '}' and breaks compilation for any C++ consumer
that includes the header more than once.

Move the closing block inside the include guard so both halves of the
'extern "C"' declaration are guarded consistently.

Signed-off-by: Andreas Haufler <andreas@haufler.info>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260721083230.91246-1-andreas@haufler.info
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **pending-6.18**, kernel **6.18.53**
(`p-6.18-1-g03b85e06ca9bf`). The verdict is only about this tree.

Mainline commit: `cb0ec27efac2aaf92393ad563a35fb6f00d0a6cd` (landed
after v6.18; `git describe` reports `v7.2-rc2-24-gcb0ec27efac2a`). It is
**not** an ancestor of HEAD.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE

- **Subsystem:** `tools/lib/thermal` (userspace libthermal, not
  `drivers/thermal`)
- **Action verb:** Fix
- **Claimed intent:** Put the C++ `extern "C"` closing brace inside the
  include guard

**Record:** `[tools/lib/thermal] [fix] [move misplaced extern "C" }
inside include guard]`

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS

From `git show cb0ec27efac2a` and the lore thread:

| Tag | Value |
|-----|--------|
| Signed-off-by | Andreas Haufler \<andreas@haufler.info\> (author) |
| Signed-off-by | Daniel Lezcano \<daniel.lezcano@kernel.org\> (thermal
maintainer) |
| Link |
https://patch.msgid.link/20260721083230.91246-1-andreas@haufler.info |

**Absent (expected):** Fixes, Reported-by, Tested-by, Reviewed-by,
Acked-by, Cc: stable.

**Record:** Author + maintainer SOB; one lore Link. No syzbot, no Fixes,
no stable tag.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT

The header opens `extern "C" {` **inside** `#ifndef __LIBTHERMAL_H`, but
closes `}` **after** `#endif`.

- First include: braces balance, so C++ compiles.
- Second include in the same C++ TU: the guard skips the opening brace,
  but the closing `}` is still emitted → stray `}` → **compile error**.

**Record:**
- **Bug:** include-guard / `extern "C"` mismatch
- **Symptom:** C++ compile failure on the second include of `thermal.h`
- **Versions:** none stated; intro commit is in this tree since v5.19
- **Root cause:** closing `}` lives outside the guard

### Step 1.4: DETECT HIDDEN BUG FIXES

Not disguised. Subject and body describe a real compile break.

**Record:** Not a hidden fix. Explicit userspace header compile bug.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES

```
tools/lib/thermal/include/thermal.h | 4 ++--
```

One file. Two lines moved: `#endif /* __LIBTHERMAL_H */` is placed after
the `extern "C"` close. No functions changed (header-only).

**Record:** `[thermal.h +2/-2] [no functions] [single-file surgical]`

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Before** (this tree, lines 178–182):

```178:182:tools/lib/thermal/include/thermal.h
#endif /* __LIBTHERMAL_H */

#ifdef __cplusplus
}
#endif
```

**After:** `#ifdef __cplusplus` / `}` / `#endif` stay inside
`__LIBTHERMAL_H`, then the guard ends.

**Record:** `[header guard close moved after extern "C" close; second
C++ include no longer emits a stray }]`

### Step 2.3: IDENTIFY THE BUG MECHANISM

**Category:** (g) logic/correctness + (h) not hardware; this is a
**build / include-file** defect.

**Mechanism:** On re-include, the guard suppresses `extern "C" {` but
not `}`.

**Record:** `[build/include-guard] [closing brace outside guard]`

### Step 2.4: ASSESS THE FIX QUALITY

Matches the correct pattern in `tools/lib/bpf/libbpf.h` (close `extern
"C"` **then** `#endif /* __LIBBPF_LIBBPF_H */`). Minimal, no API change,
no runtime code. Regression risk is effectively none.

**Record:** `[obviously correct] [no meaningful regression risk]`

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES

```
47c4b0de080adc (Daniel Lezcano 2022-04-20)  #endif /* __LIBTHERMAL_H */
47c4b0de080adc (Daniel Lezcano 2022-04-20)  #ifdef __cplusplus
47c4b0de080adc (Daniel Lezcano 2022-04-20)  }
```

Introduced with the library itself. Present since v5.19 (`git merge-base
--is-ancestor 47c4b0de080ad v5.19`; not in v5.18).

**Record:** `[47c4b0de080ad "tools/lib/thermal: Add a thermal library"]
[v5.19]`

### Step 3.2: FOLLOW THE FIXES: TAG

No Fixes tag. The buggy code is the original header layout from
47c4b0de080ad, which **is** in this tree.

**Record:** `[no Fixes tag; intro commit is in this tree]`

### Step 3.3: CHECK FILE HISTORY

Only two commits on this file in this tree:

- `47c4b0de080ad` — add library
- `a262672486287` — threshold netlink ABI (does not touch the
  guard/`extern "C"`)

No later local fix. `git log v6.18..HEAD --
tools/lib/thermal/include/thermal.h` is empty. File at v6.18 and HEAD
still has the misplaced `}`.

**Record:** `[no related local fixes] [standalone] [not a series]`

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS

`git log --author="Andreas Haufler" -- tools/` is empty in this tree.
Author is an external contributor. Maintainer Daniel Lezcano committed
it (`CommitDate: Fri Aug 7 17:18:51 2026`) after “Applied, thanks for
the fix”.

**Record:** `[external author; thermal maintainer applied]`

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS

Diff assumes only `#endif` / `#ifdef __cplusplus` / `}`. Those lines
exist unchanged. Standalone.

**Record:** `[no dependencies] [applies standalone]`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION

`b4 dig -c cb0ec27efac2a` matched by patch-id:

- **Lore:**
  https://patch.msgid.link/20260721083230.91246-1-andreas@haufler.info
- **v1 only** (`b4 dig -a`): no v2/v3
- Thread: patch + Daniel Lezcano reply: **“Applied, thanks for the
  fix”**
- No NAK, no stable nomination, no requested rework

WebFetch to lore returned 403; thread was recovered via `b4 mbox`.

**Record:** `[v1 accepted as-is] [maintainer Applied] [no stable
mention] [no NAKs]`

### Step 4.2: CHECK WHO REVIEWED THE PATCH

`b4 dig -w` recipients: Rafael Wysocki, Daniel Lezcano, Zhang Rui,
Lukasz Luba, linux-pm, linux-kernel. Those are the THERMAL
maintainers/reviewers in MAINTAINERS.

**Record:** `[thermal maintainers on To/Cc; Lezcano applied]`

### Step 4.3: SEARCH FOR THE BUG REPORT

No Reported-by, bugzilla, or syzbot. Author found it by inspecting the
public header.

**Record:** `[no external bug report] [author-discovered compile
defect]`

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES

Standalone `[PATCH]`, msgid `...91246-1`, no `-2`. `git log
origin/master cb0ec27efac2a^.. -- tools/lib/thermal/include/thermal.h`
shows only this commit.

**Record:** `[standalone; no follow-up on the header]`

### Step 4.5: CHECK STABLE MAILING LIST HISTORY

lore.kernel.org/stable WebFetch returned 403. No Cc: stable on the
patch. No local `git log --grep=extern -- tools/lib/thermal/` hits.

**Record:** `[no stable-list discussion verified; lore/stable fetch
failed with 403]`

---

## PHASE 5: CODE SEMANTIC ANALYSIS

semcode MCP is not available. Grep/read used instead.

### Step 5.1: IDENTIFY KEY FUNCTIONS

No functions modified. Change is preprocessor layout at the bottom of
`thermal.h`.

**Record:** `[none; include guard / extern "C" only]`

### Step 5.2: TRACE CALLERS

In-tree includes of this header:

- `tools/lib/thermal/{thermal,events,commands,thermal_nl,sampling}.c`
- `tools/thermal/thermal-engine/thermal-engine.c` (`thermal_init`,
  `thermal_events_handle`)

All **C**. `find tools/thermal tools/lib/thermal -name '*.cpp'` is
empty. The header is still a **public installed API** (`install_headers`
installs `include/thermal.h`; `libthermal.pc`).

**Record:** `[in-tree users are C; public header is C++-aware and
installed]`

### Step 5.3: TRACE CALLEES

N/A for a brace move.

**Record:** `[N/A]`

### Step 5.4: FOLLOW THE CALL CHAIN

Trigger is **userspace C++** including `thermal.h` twice (direct or via
two headers). Not a syscall/kernel path. Reachable for anyone who
installs libthermal and uses it from C++.

**Record:** `[userspace C++ re-include] [not kernel runtime]`

### Step 5.5: SEARCH FOR SIMILAR PATTERNS

`tools/lib/bpf/libbpf.h` and `libbpf_legacy.h` close `extern "C"`
**inside** the guard. This patch matches that.

**Record:** `[libbpf already uses the correct pattern; libthermal was
the outlier]`

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?

Yes. `tools/lib/thermal/include/thermal.h` lines 178–182 still have
`#endif` before the closing `}`. Introduced in v5.19; present at v6.18
and HEAD.

`git merge-base --is-ancestor cb0ec27efac2a HEAD` → **not in this
tree**.

**Record:** `[bug present at thermal.h:178-182] [since v5.19] [fix not
applied]`

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS

Context around the hunk is identical to the mainline diff. No churn on
this file after v6.18. Clean apply.

**Record:** `[clean apply]`

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE

No. File history has no other extern-C/guard fix.

**Record:** `[no existing equivalent fix]`

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY

`tools/lib/thermal/` — userspace thermal netlink library (THERMAL in
MAINTAINERS: Rafael Wysocki, Daniel Lezcano).

**Criticality:** PERIPHERAL for kernel runtime; IMPORTANT as a **public
installed userspace API** for thermal tools. Not mm/fs/net core.

**Record:** `[tools/lib/thermal] [PERIPHERAL kernel / public userspace
header]`

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY

Low churn: library add (2022), threshold ABI (2024), a few
build/leak/symbol fixes. Mature header layout, not a moving target.

**Record:** `[low activity; header layout stable since 2022]`

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED

C++ programs that include the installed `thermal.h` more than once. In-
tree C tools (`thermal-engine`) are unaffected. Kernel image/build is
unaffected.

**Record:** `[config/userspace-specific: C++ libthermal consumers]`

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS

Second `#include <thermal.h>` in one C++ translation unit (common with
umbrella headers). Unprivileged userspace compile-time only. Not a race.

**Record:** `[double include from C++] [uncommon but valid] [compile-
time only]`

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY

Compile failure (`stray '}'`), not oops/corruption/UAF. Stable rules
still list **build errors** and **include-file fixes** as in-scope.

**Record:** `[C++ compile break] [MEDIUM as a build bug; HIGH as
include-file correctness; not a kernel crash]`

### Step 8.4: CALCULATE RISK-BENEFIT RATIO

- **Benefit:** C++ consumers of the public header compile; long-standing
  defect (v5.19+).
- **Risk:** 4-line preprocessor move, no runtime, no ABI change.

**Record:** `[moderate benefit for C++ libthermal users] [near-zero
risk] [favorable]`

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Real, well-explained compile break for a public C++-aware header
- Obviously correct; matches libbpf
- 4 lines; zero runtime/API risk
- Buggy code is in this 6.18.53 tree; fix is not
- Applies cleanly; no prerequisites
- Maintainer applied v1 with “thanks for the fix”
- Fits the **build / include-file** exception in stable-kernel-rules

**AGAINST:**
- Not a kernel oops, UAF, deadlock, or security hole
- In-tree tools are C and already build
- No multi-user Reported-by
- libthermal is a small audience

**UNRESOLVED:**
- Could not search lore.kernel.org/stable (HTTP 403). Unverified whether
  anyone asked for this on the stable list.

### Step 9.2: APPLY THE STABLE RULES CHECKLIST

1. Obviously correct and tested? **PASS** — mechanical brace move;
   maintainer applied
2. Fixes a real bug that affects users? **PASS** — C++ double-include of
   the installed header fails
3. Important issue? **PASS** — build/include-file error (explicitly
   allowed); not a crash, but in-scope
4. Small and contained? **PASS** — 4 lines, one header
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — context matches HEAD

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES

**Build / include-file fix.** Not a device ID, quirk, DT, or docs-only
change.

### Step 9.4: DECISION

This tree ships the buggy public header. The fix is a 4-line, zero-risk
compile repair that mainline already took. That meets stable rules for
this 6.18 tree.

---

## What the commit solves for this tree

`thermal.h` advertises C++ support (`extern "C"`) and is installed
(`make install` → `include/thermal.h`). The closing `}` sits outside
`__LIBTHERMAL_H`, so a second include in one C++ file emits a stray
brace and fails the build. Moving `#endif` below the close matches every
other well-formed kernel userspace header. Kernel runtime is untouched.

Risk vs benefit: benefit is restoring a header that this tree already
ships; risk is none.

---

## Verification

- **[Phase 1]** `git show cb0ec27efac2a`: tags are author SOB, Lezcano
  SOB, Link; no Fixes/Reported-by/Cc: stable
- **[Phase 1]** Body describes second-include stray `}` — matches the
  current header
- **[Phase 2]** Diff is `#endif` moved after `#ifdef __cplusplus` / `}`
  / `#endif`
- **[Phase 2]** `tools/lib/bpf/libbpf.h` uses the same close-then-guard-
  end order
- **[Phase 3]** `git blame tools/lib/thermal/include/thermal.h` lines
  178–182 → `47c4b0de080ad`
- **[Phase 3]** `git merge-base --is-ancestor 47c4b0de080ad v5.19` yes;
  `v5.18` no
- **[Phase 3]** `git log --oneline --
  tools/lib/thermal/include/thermal.h`: only add + threshold ABI
- **[Phase 3]** `git merge-base --is-ancestor cb0ec27efac2a HEAD` → not
  in this tree
- **[Phase 4]** `b4 dig -c cb0ec27efac2a`: lore URL + v1 only
- **[Phase 4]** `b4 dig -a`: single revision 2026-07-21
- **[Phase 4]** `b4 dig -w`: Rafael, Lezcano, Zhang Rui, Lukasz Luba,
  linux-pm, linux-kernel
- **[Phase 4]** `b4 mbox`: Lezcano “Applied, thanks for the fix”
  (2026-08-07)
- **[Phase 4]** WebFetch lore/all, patch.msgid.link, lore/linux-pm,
  lore/stable → 403
- **[Phase 5]** No `*.cpp` under `tools/thermal` or `tools/lib/thermal`
- **[Phase 5]** In-tree include sites are C; `thermal-engine.c` calls
  `thermal_init`
- **[Phase 5]** Makefile `install_headers` installs `include/thermal.h`
- **[Phase 6]** `make kernelversion` / Makefile → 6.18.53; `git describe
  HEAD` → `p-6.18-1-g03b85e06ca9bf`
- **[Phase 6]** HEAD `thermal.h` still has `#endif` before `}`
- **[Phase 6]** `git log v6.18..HEAD --
  tools/lib/thermal/include/thermal.h` empty
- **[Phase 7]** MAINTAINERS THERMAL covers `tools/lib/thermal/`
- **[Phase 8]** Failure mode verified as C++ compile-time only, not
  kernel oops
- **UNVERIFIED:** stable@ mailing-list archive (HTTP 403); does not
  change the verdict

The local 6.18.53 tree has the bug, the fix is small and correct, and it
applies cleanly.

**YES**

 tools/lib/thermal/include/thermal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/thermal/include/thermal.h b/tools/lib/thermal/include/thermal.h
index 818ecdfb46e50..d9097271d9fad 100644
--- a/tools/lib/thermal/include/thermal.h
+++ b/tools/lib/thermal/include/thermal.h
@@ -175,8 +175,8 @@ LIBTHERMAL_API thermal_error_t thermal_sampling_handle(struct thermal_handler *t
 
 LIBTHERMAL_API int thermal_sampling_fd(struct thermal_handler *th);
 
-#endif /* __LIBTHERMAL_H */
-
 #ifdef __cplusplus
 }
 #endif
+
+#endif /* __LIBTHERMAL_H */
-- 
2.53.0

