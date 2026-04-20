Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FD33BAD98;
	Mon, 20 Apr 2026 13:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691486; cv=none; b=BUMy1NnvGo4X86VlyohfktCUdlWKJNrlycQOU703GG/tOOlPwJkxwOKbntZe57z9AG9zJeBm8oZ0EwWq2pwLgr3J1vlk48jLOq1qP09H2XwYEfvIoXobrkvFy0MViWTU7GHxajs0tRkFJ4Z1TBJfhd4Fa4Jz0bZHE1KBnSRPWkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691486; c=relaxed/simple;
	bh=3v6n7MmXkBR3OU97DEK37P+G6pgUa7wJFCvw8MF306A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnaVm3fPAsAc1kWNZUqKuvBeHjqvm5rePzUNTzveN2NSCNsiqC16O89nCoqBBL2gy4HdJXZB6CiwJeWOaZt55T/N37+HOU6VE7pNlB7cf+1ydNAZSG8xN0xi7UN3oTo5JvxGZgVkMph4+rgWurrGHbUs345gDwJ9bjVAAjdsnlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FT7Xk2tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FT7Xk2tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEEEC2BCB4;
	Mon, 20 Apr 2026 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691485;
	bh=3v6n7MmXkBR3OU97DEK37P+G6pgUa7wJFCvw8MF306A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FT7Xk2tmpw2DUJeMBsWOU6Ivg8qifodr3ITye2djwnqPtnKXcPlyGQrFzgwcSmFAf
	 eIqw1BwMHU/Ghmi0rFM+TkYA7I3/OOPY5vKJHvkDvSTvYa6zcZIXwiN70J0JOAbbyL
	 1SWnYt2rhfSOrq4mE1HlGZDLADL9bO/d3N0RJ+6IIycV6NZnCvTekg39U2TSQ1kw6v
	 Xkjaexiidnaf3BrcR3S1usB3Sm/FEd8cFA9/SuaRM8I8JdnwB8E8fAf4vEmKI9KXql
	 J9geCgov0KhjCtk/r66bopjNaHTlHYA415pJm7sB8m0h4xYf3cwopA6fjLQlmunwn8
	 Cl7Z/ElOQcfGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jingkai Tan <contact@jingk.ai>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ACPI: processor: idle: Add missing bounds check in flatten_lpi_states()
Date: Mon, 20 Apr 2026 09:17:31 -0400
Message-ID: <20260420132314.1023554-57-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jingkai Tan <contact@jingk.ai>

[ Upstream commit 638a95168fd53a911201681cd5e55c7965b20733 ]

The inner loop in flatten_lpi_states() that combines composite LPI
states can increment flat_state_cnt multiple times within the loop.

The condition that guards this (checks bounds against ACPI_PROCESSOR
_MAX_POWER) occurs at the top of the outer loop. flat_state_cnt might
exceed ACPI_PROCESSOR_MAX_POWER if it is incremented multiple times
within the inner loop between outer loop iterations.

Add a bounds check after the increment inside the inner loop so that
it breaks out when flat_state_cnt reaches ACPI_PROCESSOR_MAX_POWER.
The existing check in the outer loop will then handle the warning.

Signed-off-by: Jingkai Tan <contact@jingk.ai>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/20260305213831.53985-1-contact@jingk.ai
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: ACPI: processor: idle
- **Action verb**: "Add missing" — clearly indicates a bug fix (missing
  safety check)
- **Summary**: Adds a bounds check in `flatten_lpi_states()` to prevent
  array overflow

### Step 1.2: Tags
- **Signed-off-by**: Jingkai Tan (author), Rafael J. Wysocki (ACPI
  maintainer)
- **Reviewed-by**: Sudeep Holla — the **original author of the LPI
  code** (a36a7fecfe6071)
- **Link**: patch.msgid.link/20260305213831.53985-1-contact@jingk.ai
- No Fixes: tag (expected for commits under review)
- No Cc: stable (expected)

### Step 1.3: Commit Body
The commit describes a clear out-of-bounds bug: the inner loop
increments `flat_state_cnt` multiple times, but the bounds check only
exists at the top of the outer loop. Between outer loop iterations, the
counter can exceed `ACPI_PROCESSOR_MAX_POWER` (8), causing writes past
the end of the `lpi_states[]` array.

### Step 1.4: Hidden Bug Fix Detection
Not hidden — this is explicitly labeled as a missing bounds check, which
is a classic array overflow fix.

**Record**: Clear bug fix adding missing bounds check to prevent out-of-
bounds array write.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`drivers/acpi/processor_idle.c`)
- **Lines added**: 2, removed: 0
- **Function modified**: `flatten_lpi_states()`
- **Scope**: Single-file, surgical 2-line fix

### Step 2.2: Code Flow Change
The fix adds inside the inner `for` loop, immediately after
`flat_state_cnt++` and `flpi++`:

```c
if (flat_state_cnt >= ACPI_PROCESSOR_MAX_POWER)
    break;
```

**Before**: Inner loop could increment `flat_state_cnt` past
`ACPI_PROCESSOR_MAX_POWER`, causing `flpi` to point past
`pr->power.lpi_states[8]`, and subsequent calls to
`combine_lpi_states()` and `stash_composite_state()` would write out-of-
bounds.

**After**: Inner loop breaks immediately when the limit is reached. The
outer loop's existing check then handles the warning message.

### Step 2.3: Bug Mechanism
**Category**: Buffer overflow / out-of-bounds write

The `lpi_states` array is declared as:

```94:96:include/acpi/processor.h
                struct acpi_processor_cx
states[ACPI_PROCESSOR_MAX_POWER];
                struct acpi_lpi_state
lpi_states[ACPI_PROCESSOR_MAX_POWER];
```

Where `ACPI_PROCESSOR_MAX_POWER = 8`. The `composite_states` array in
`acpi_lpi_states_array` is also bounded at 8 entries. Both arrays can be
overflowed when the inner loop runs more times than expected.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes. Mirrors the existing outer-loop bounds
  check. Reviewed by the original code author.
- **Minimal**: 2 lines, no unrelated changes.
- **Regression risk**: Effectively zero. This only adds an early exit
  when the array is full.

**Record**: 2-line bounds check fix preventing out-of-bounds write into
`lpi_states[]` and `composite_states[]` arrays. Severity: HIGH (memory
corruption).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
From blame output, the buggy inner loop code was introduced by commit
`a36a7fecfe6071` (Sudeep Holla, 2016-07-21), "ACPI / processor_idle: Add
support for Low Power Idle(LPI) states". This is in the v4.8-rc1 era.
The bug has existed since the code was first written — **present in all
stable trees**.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected).

### Step 3.3: File History
Recent refactoring by `e4c628e91c6ab` (Rafael, Aug 2025) changed
`flat_state_cnt` from a static variable to a function parameter. The
inner loop code itself is unchanged since 2016. The fix applies to the
identical inner loop code in both old and new versions.

### Step 3.4: Author
Jingkai Tan is a new contributor. However, the fix was reviewed by
Sudeep Holla (original code author, ARM maintainer) and applied by
Rafael J. Wysocki (ACPI subsystem maintainer).

### Step 3.5: Dependencies
The fix references only `ACPI_PROCESSOR_MAX_POWER` and the existing loop
variable `flat_state_cnt`, both of which exist in all kernel versions
since v4.8. The only difference is:
- **Mainline**: `flat_state_cnt` is a function parameter (after
  e4c628e91c6ab)
- **Stable trees**: `flat_state_cnt` is a static variable (same name,
  same inner loop code)

The patch will need a trivial context adjustment for the function
signature in the hunk header, but the actual changed lines apply
identically.

**Record**: Bug exists since v4.8 (2016). Fix is standalone, no
prerequisites. Minor context adaptation needed for stable backport.

---

## PHASE 4: MAILING LIST INVESTIGATION

### Step 4.1: Patch Discussion
From the full mbox thread (7 messages):

1. **v1** (Feb 15, 2026): Added 6 lines — bounds check BEFORE the
   increment at the top of the inner loop, with duplicate warning
   messages.
2. **Rafael's review** (Mar 5): Confirmed "the issue addressed by this
   patch appears to be genuine" but suggested checking after increment
   and letting the outer loop handle warnings.
3. **v2** (Mar 5): Simplified to 2 lines per Rafael's guidance.
4. **Sudeep Holla** (Mar 6): Gave `Reviewed-by` — the original code
   author endorsed the fix.
5. **lihuisong** (Mar 9): Asked if the `!prev_level` (leaf) path also
   needs the check.
6. **Rafael** (Mar 9): Clarified the leaf path is covered by the
   existing outer loop check (only one increment per iteration via
   `continue`).
7. **Rafael** (Mar 9): "Applied as 7.1 material, thanks!"

### Step 4.2: Reviewers
- Rafael J. Wysocki (ACPI maintainer) — reviewed both versions, applied
  the patch
- Sudeep Holla (original LPI code author) — gave Reviewed-by

### Step 4.3: No syzbot or bug report — found by code inspection.

### Step 4.4: Standalone single patch, not part of a series.

### Step 4.5: No stable-specific discussion found.

**Record**: Both the subsystem maintainer and original code author
confirmed the bug is genuine and reviewed the fix. Patch went through
v1->v2 with review refinements.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `flatten_lpi_states()`.

### Step 5.2: Callers
`flatten_lpi_states()` is called from `acpi_processor_get_lpi_info()`
which processes ACPI LPI states during processor initialization. This
runs during boot on ARM systems with ACPI LPI support.

### Step 5.3: Impact
The bug triggers when ACPI firmware defines composite LPI states whose
combinations exceed 8 total. The `combine_lpi_states()` function is
called for each combination of parent/child states. On systems with
hierarchical power domains (common on ARM servers), the combinatorial
explosion can exceed the array bounds.

### Step 5.4: Reachability
The code path is: boot → ACPI processor driver init →
`acpi_processor_get_lpi_info()` → `flatten_lpi_states()`. This is
reached on every ARM server with ACPI LPI support.

**Record**: Called during boot on ARM ACPI systems. Trigger depends on
firmware-defined LPI state counts.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy code from `a36a7fecfe6071` exists in ALL stable trees (v4.8+).
Verified that stable trees 6.1.y and 6.6.y have changes to this file but
the inner loop code is unchanged.

### Step 6.2: Backport Complications
Minor context conflict expected: the function signature in the hunk
header differs between mainline (`unsigned int` return + parameter) and
stable (`int` return + static variable). The actual lines changed
(inside the inner loop) are identical. Trivial adaptation.

### Step 6.3: No related fixes already in stable for this bug.

**Record**: Bug present in all stable trees since v4.8. Trivial backport
adaptation needed.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
ACPI processor idle — **IMPORTANT** criticality. Affects all ARM-based
systems using ACPI LPI idle states (servers, embedded platforms).

### Step 7.2: Activity
Active subsystem with recent refactoring by Rafael.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
ARM ACPI systems with hierarchical LPI states (ARM servers, some
embedded platforms). The bug is firmware-dependent — systems need enough
LPI states to overflow the array.

### Step 8.2: Trigger Conditions
Triggered during boot when ACPI firmware defines composite LPI states
exceeding `ACPI_PROCESSOR_MAX_POWER` (8) in combination. Cannot be
triggered by unprivileged users, but affects boot stability.

### Step 8.3: Failure Mode Severity
When triggered: **out-of-bounds write** to kernel memory beyond
`lpi_states[8]` and `composite_states[8]`. This corrupts adjacent memory
in `struct acpi_processor_power` and `struct acpi_lpi_states_array`.
Consequences:
- Memory corruption → undefined behavior
- Potential kernel crash/oops
- Silent data corruption of adjacent data structures
- **Severity: HIGH**

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Prevents memory corruption on ARM ACPI systems. Long-
  standing bug since v4.8.
- **Risk**: 2-line addition of a bounds check — effectively zero
  regression risk.
- **Ratio**: Very favorable for backporting.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting**:
- Fixes a real out-of-bounds array write (memory corruption)
- Bug exists since v4.8 (2016) — affects all stable trees
- 2-line fix — minimal scope, zero regression risk
- Reviewed by original code author (Sudeep Holla) and subsystem
  maintainer (Rafael)
- Both confirmed the bug is genuine
- Obviously correct — mirrors the existing outer loop check

**AGAINST backporting**:
- No known user report of actually triggering this (found by code
  inspection)
- Needs trivial context adaptation for the function signature in stable
  trees

**Unresolved**:
- No way to know exact firmware configurations that trigger it, but the
  code path is clearly reachable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — reviewed by original author
   and maintainer
2. Fixes a real bug? **YES** — array out-of-bounds write
3. Important issue? **YES** — memory corruption
4. Small and contained? **YES** — 2 lines in one file
5. No new features? **YES** — pure bounds check
6. Can apply to stable? **YES** — with trivial context adaptation

### Step 9.3: Exception Categories
Not an exception category — this is a straightforward bug fix.

### Step 9.4: Decision
This is a textbook stable backport candidate: a small, obviously correct
bounds check that prevents memory corruption, reviewed by the original
code author.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Sudeep Holla, Signed-off-by Rafael
  J. Wysocki, Link to lore
- [Phase 2] Diff analysis: 2 lines added inside inner loop of
  `flatten_lpi_states()`, adds bounds check after `flat_state_cnt++`
- [Phase 2] Verified `ACPI_PROCESSOR_MAX_POWER = 8` at
  `include/acpi/processor.h:24`, `lpi_states[ACPI_PROCESSOR_MAX_POWER]`
  at line 96, `composite_states[ACPI_PROCESSOR_MAX_POWER]` at
  `processor_idle.c:866`
- [Phase 3] git blame: all inner loop lines from `a36a7fecfe6071`
  (Sudeep Holla, 2016-07-21, v4.8-rc1 era)
- [Phase 3] git describe --contains: confirmed commit is pre-v4.8-rc1
- [Phase 3] e4c628e91c6ab refactored function signature (Aug 2025) but
  inner loop code is unchanged
- [Phase 3] Verified stable trees 6.1.y and 6.6.y have changes to file
  but not to the inner loop
- [Phase 4] b4 am retrieved full thread (7 messages), confirmed v1->v2
  evolution
- [Phase 4] Rafael's review of v1: "The issue addressed by this patch
  appears to be genuine"
- [Phase 4] Sudeep Holla (original code author): gave Reviewed-by on v2
- [Phase 4] Rafael's response to lihuisong: confirmed leaf path is
  already covered
- [Phase 4] Rafael: "Applied as 7.1 material"
- [Phase 5] `flatten_lpi_states()` called from
  `acpi_processor_get_lpi_info()` during boot
- [Phase 6] Bug present since v4.8 — all active stable trees affected
- [Phase 6] Backport needs trivial context adaptation for function
  signature
- [Phase 8] Failure mode: out-of-bounds write past `lpi_states[8]` array
  — memory corruption, severity HIGH
- UNVERIFIED: Cannot confirm whether any specific ARM server firmware
  actually produces enough composite states to trigger this; however,
  the code path is clearly reachable and the bug mechanism is confirmed
  by the original code author

**YES**

 drivers/acpi/processor_idle.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f6c72e3a2be1b..d4753420ae0b7 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1068,6 +1068,8 @@ static unsigned int flatten_lpi_states(struct acpi_processor *pr,
 				stash_composite_state(curr_level, flpi);
 				flat_state_cnt++;
 				flpi++;
+				if (flat_state_cnt >= ACPI_PROCESSOR_MAX_POWER)
+					break;
 			}
 		}
 	}
-- 
2.53.0

