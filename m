Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E8E517BAE;
	Mon, 31 Aug 2026 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183808; cv=none; b=LN/Y8QXCvggiBfBfhnRdEgUzu1gTIJmolGghKWBY7iYlIIlBqua6cvSD38pTrHSO2VGxkKrfvcZx+RYD7pIss/QWnaiYQ5+1tqEG5QnuCESoYWBNoQfcSsveY3cey18wY9/6Rm3vrA4WSYYubeVu8exXiIx61lqbHLE5P7EAWNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183808; c=relaxed/simple;
	bh=qjGSPZiTjqy9OQnmsUkp20rKbTKFzXPF1DNGqWt1abY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RXJicoJxXmelDvdwZo+Fcu+3VCB5thGihybGqlnEqDAH5q5C0UJF+PrwcrdsilZCq1wJ1hlhgMkHmeP4OsW3OLBqz3e8F9rsB7DoIELlmjxivYICkSqALAkjmftrGIyztXe/xtRuNwZsfTv+8xcd/4FMRxddGteBEsL78JobXRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnYqIjW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnYqIjW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2F71F000E9;
	Mon, 31 Aug 2026 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183805;
	bh=7hw2TwlKijxo5j5n8Tb6oV2dh7rhrzUz50SntWCwRZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnYqIjW1SA+0aMQqMKv5Yw28Cc9TSbN4N8HbJRGdqzR/IHD6l11h3+jcRD6RcqBNL
	 3sIR5TvBoCZiG08GVcTCUloO5DRFIR0lT+mIoHY9KIeAsIxAtx7L9pM3ZeS4rJ8IJN
	 uPixerUIgV2DblthucNSbZ2ialtXEnsH8vmpRJCEk8ryvjC7SXoX9bLzeNztk1hTYu
	 +Q3mVwvjswlgTfAGoGGCtsJgaMZYVhKYGKgZLXFeQzwxXf/XykGdXG723dl69zCo+8
	 yYRct1zY8wV0B68iuhEUgFHgtbthetry6J+jibGDO3y3/xXq6vK1xg0taKEtdmIVXj
	 lZb5FG5QePgcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
	Anushree Mathur <anushree.mathur@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] powerpc/pseries: Ensure vpa,slb_shadow & dtl are unregistered during crash
Date: Mon, 31 Aug 2026 09:25:43 -0400
Message-ID: <20260831133314.4125787-315-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 810d07fb4cf7577847f85a6fd6273b69cad8d580 ]

Currently pseries_kexec_cpu_down() skips unregistering vpa, slb_shadow and
dtl areas during a crash and kexec shutdown path. It was done to avoid
doing an HCALL while crashing. However recently Anushree reported that
during kernel crash while the kdump kernel was coming up, Hypervisor
reported invalid values for 'vpa.yield_count' while it dispatching L2-KVM
Guest vcpus. The error manifested as debug build Hypervisor assert
triggering to indicate possible VPA corruption.

Looking at the kexec cpu offline path it was discovered that during crash
kernel doesn't unregister the VPA/SLB-Shadow/DTL area with
Hypervisor. Instead it re-allocates and re-registers these areas
for cpus during boot. During kexec boot the previously allocated areas
can get overwritten with new content without hypervisor knowledge. This
creates a small window where while kexec kernel boots and the L2-VCPUs are
being dispatched, Hypervisor may try to read/write to a wrong memory area
which previously belonged to older VPA.

Fix this possible race and memory corruption by updating
pseries_kexec_cpu_down() to also unregister vpa,slb_shadow & dtl areas
during a kernel crash.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Tested-by: Anushree Mathur <anushree.mathur@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260708015802.274271-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `powerpc/pseries: Ensure vpa,slb_shadow &
dtl are unregistered during crash`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`, `make kernelversion` → `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[powerpc/pseries]` `[ensure]` — During kernel crash/kdump
shutdown, unregister VPA, SLB shadow, and DTL areas with the hypervisor
instead of skipping that cleanup.

### Step 1.2: Parse all commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Vaibhav Jain \<vaibhav@linux.ibm.com\> (author) |
| Tested-by | Anushree Mathur \<anushree.mathur@linux.ibm.com\>
(reporter/tester) |
| Signed-off-by | Madhavan Srinivasan \<maddy@linux.ibm.com\> (powerpc
maintainer) |
| Link |
https://patch.msgid.link/20260708015802.274271-1-vaibhav@linux.ibm.com |

**Notable patterns:** `Tested-by` from the reporter; maintainer sign-
off; no `Fixes:` tag (expected for manual review); no `Cc: stable` tag
(expected).

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `pseries_kexec_cpu_down()` skips VPA/SLB-shadow/DTL
  unregistration when `crash_shutdown` is set (crash/kdump path).
- **Symptom:** During kernel crash while kdump boots, hypervisor reads
  invalid `vpa.yield_count` values; debug hypervisor asserts on possible
  VPA corruption while dispatching L2-KVM guest vCPUs.
- **Root cause:** Crash kernel does not unregister these areas; kdump
  kernel later reallocates and re-registers them. Hypervisor still
  references old memory for a window, so it may read/write memory that
  no longer belongs to the registered VPA.
- **Version info:** None explicit; bug is long-standing (see Phase 3).

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit race/memory-corruption
fix in the kdump crash-shutdown path, not cleanup-only.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory changes
**Record:**
- **Files:** `arch/powerpc/platforms/pseries/kexec.c` only
- **Scope:** ~10 lines changed (comment rewrite + one condition change)
- **Function modified:** `pseries_kexec_cpu_down()`
- **Classification:** Single-file surgical fix

### Step 2.2: Code flow change per hunk
**Record:**
- **Hunk 1 (comment):** Before: documents intentional skip of hypervisor
  calls during crash. After: explains why unregister must still be
  attempted during crash to prevent hypervisor use of stale memory.
- **Hunk 2 (condition):** Before: `if
  (firmware_has_feature(FW_FEATURE_SPLPAR) && !crash_shutdown)` —
  unregister only on normal kexec. After: `if
  (firmware_has_feature(FW_FEATURE_SPLPAR))` — unregister on both normal
  kexec and crash/kdump paths.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Race condition / memory corruption (hypervisor–kernel
  shared state)
- **Mechanism:** Hypervisor retains pointers to VPA/SLB-shadow/DTL
  memory after crash. kdump kernel reuses that physical memory before
  re-registering new areas. Hypervisor accesses wrong content → VPA
  corruption, hypervisor asserts.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct; reuses existing, tested unregister
  path already used for normal kexec and CPU hotplug.
- **Regression risk:** Low. Failed HCALLs only emit `pr_err` warnings
  (same as today). Worst case equals current crash behavior; best case
  closes the race.
- **Red flags:** None. No API changes, no new logic beyond removing the
  crash exemption.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- `!crash_shutdown` guard present since **dce623e0827e8** (Michael
  Ellerman, 2007-02-08, “[POWERPC] Cleanup pseries kexec code”).
- Comment expanded in **499dcd41378eba** (Nicholas Piggin, 2018-02-14)
  with explicit “XXX: Why?” noting hypervisor may step on memory.
- VPA/SLB/DTL unregister on kexec added in **b1301797f30370** (Anton
  Blanchard, 2011-07-25, “Fix kexec on recent firmware versions”, `Cc:
  stable@kernel.org`).
- Buggy code verified present at tags **v5.4, v5.10, v5.15, v6.1, v6.6,
  v6.12, v6.18** in this tree.

### Step 3.2: Follow Fixes: tag
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: Related file history
**Record:** `arch/powerpc/platforms/pseries/kexec.c` history at v5.4
shows long-stable kexec/VPA handling; no related prerequisite series
identified. Standalone one-commit fix.

### Step 3.4: Author context
**Record:** Vaibhav Jain is an IBM powerpc contributor. Madhavan
Srinivasan (maintainer) signed off. Fix commit not yet present in this
6.18.44 checkout.

### Step 3.5: Dependencies
**Record:** No dependencies. `unregister_vpa()`,
`unregister_slb_shadow()`, `unregister_dtl()` exist in
`arch/powerpc/include/asm/plpar_wrappers.h`. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c HEAD` matched unrelated commit. `b4 shazam` could
not find this patch on lore (likely not yet indexed/merged). `WebFetch`
of lore URL blocked by bot protection. **Link tag present but thread
content unverified.**

### Step 4.2: Reviewers
**Record:** `b4 dig -w` not usable without matching commit. Maintainer
SOB (Madhavan Srinivasan) verified in commit message.

### Step 4.3: Bug report
**Record:** Reported by Anushree Mathur (IBM) per commit message;
hypervisor assert on invalid `vpa.yield_count` during kdump with L2-KVM
guests. `Tested-by` from same person. Real-world IBM Power LPAR/kdump
scenario.

### Step 4.4: Related patches/series
**Record:** Standalone fix; not part of a multi-patch series.

### Step 4.5: Stable mailing list history
**Record:** Not searched successfully (lore inaccessible). Prior related
fix (b1301797f30370, 2011) was explicitly `Cc: stable@kernel.org` for
kexec/VPA unregister issues on pseries.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pseries_kexec_cpu_down()` — only function modified.

### Step 5.2: Callers
**Record:**
| Caller | `crash_shutdown` | Context |
|--------|------------------|---------|
| `arch/powerpc/kexec/crash.c:105` | `1` | Secondary CPU in crash/kdump
path |
| `arch/powerpc/kexec/crash.c:400` | `1` | Panic CPU after crash
shutdown handlers |
| `arch/powerpc/kexec/core_64.c:159,269,287` | `0` | Normal kexec CPU
shutdown |

Registered via `ppc_md.kexec_cpu_down = pseries_kexec_cpu_down` in
`setup.c:1162` under `CONFIG_KEXEC_CORE`.

### Step 5.3: Callees
**Record:** `unregister_dtl()`, `unregister_slb_shadow()`,
`unregister_vpa()` → `plpar_hcall_norets(H_REGISTER_VPA, ...)`. Also
`xive_teardown_cpu()` / `xics_kexec_teardown_cpu()` (unchanged, run
regardless of `crash_shutdown`).

### Step 5.4: Call chain / reachability
**Record:** Triggered on kernel panic with kdump configured
(`CONFIG_CRASH_DUMP`). Requires `FW_FEATURE_SPLPAR` (IBM LPAR). Not
userspace-triggerable directly, but panic/kdump is a critical enterprise
path on Power systems.

### Step 5.5: Similar patterns
**Record:** `pseries_cpu_offline_self()` in `hotplug-cpu.c:73-74` always
calls `unregister_slb_shadow()` and `unregister_vpa()` — confirming
unregister is normal/expected. Only crash path was exempted.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Current `kexec.c:28`:

```28:28:arch/powerpc/platforms/pseries/kexec.c
        if (firmware_has_feature(FW_FEATURE_SPLPAR) && !crash_shutdown)
{
```

Bug present since at least v5.4 in this repository; long-standing.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Single condition change and
comment update; no structural differences between v6.18 and current HEAD
in this file.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found. `git log --grep="Ensure vpa"`
returns nothing. Fix not yet applied to 6.18.44.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `arch/powerpc/platforms/pseries/` — **IMPORTANT** (IBM Power
LPAR platform code). kdump/crash recovery is critical for enterprise
deployments.

### Step 7.2: Subsystem activity
**Record:** Active maintenance in 6.18.y (recent pseries fixes for papr-
hvpipe, MSI, cmm). Platform is actively supported.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Platform-specific, config-specific:** IBM Power LPAR
(`FW_FEATURE_SPLPAR`) systems with kdump (`CONFIG_CRASH_DUMP` /
`CONFIG_KEXEC_CORE`). Especially visible with nested KVM (L2 guests),
but underlying stale-VPA race exists whenever kdump runs after panic.

### Step 8.2: Trigger conditions
**Record:** Kernel panic → kdump kernel boot sequence. Not every boot;
but any panic on affected systems. Requires SPLPAR + kdump. Unprivileged
users can trigger panic indirectly, but this is primarily a reliability
fix for crash recovery, not a direct syscall security issue.

### Step 8.3: Failure mode severity
**Record:** Hypervisor reads/writes stale VPA/SLB/DTL memory → VPA
corruption, hypervisor asserts, potential kdump boot interference.
**Severity: HIGH** (crash-recovery corruption; can affect guest VMs on
same LPAR).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for Power LPAR + kdump users; closes a real
  hypervisor/kernel race during crash recovery.
- **Risk:** LOW — minimal diff, reuses existing unregister path;
  failures are non-fatal warnings.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug with IBM reporter and `Tested-by`
- Race causes hypervisor VPA corruption during kdump
- Long-standing bug (since 2007); present in 6.18.44
- Tiny, surgical, obviously correct fix
- Maintainer signed off
- Prior analogous kexec/VPA fix (2011) was stable material
- kdump reliability is critical for enterprise Power

**AGAINST backport:**
- Platform-limited (powerpc/pseries SPLPAR only)
- Making hypervisor calls during crash was originally avoided
  intentionally
- Lore review thread not accessible for independent verification

**Unresolved:** Full mailing-list review thread not retrieved (lore bot
protection).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is sound; `Tested-by`
   from reporter.
2. Fixes a real bug affecting users? **PASS** — IBM-reported
   kdump/hypervisor VPA corruption.
3. Important issue? **PASS** — memory corruption in crash-recovery path;
   hypervisor asserts; guest impact.
4. Small and contained? **PASS** — one file, one condition, comment
   update.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code identical; clean apply
   expected.

### Step 9.3: Exception categories
**Record:** None (standard bug fix, not device ID/quirk/DT/build/doc).

### Step 9.4: Problem summary for stable users
On IBM Power LPAR systems with kdump enabled, a kernel panic leaves
VPA/SLB-shadow/DTL areas registered with the hypervisor. While the kdump
kernel boots and reallocates that memory, the hypervisor can still
access the old addresses, causing VPA corruption. This was observed as
hypervisor asserts during L2-KVM vCPU dispatch. The fix runs the same
unregister calls during crash shutdown that already run on normal kexec,
closing the race window.

---

## Verification

- **[Phase 1]** Parsed subject, tags (`Tested-by`, `Link`, maintainer
  SOB); no `Fixes:` tag.
- **[Phase 2]** Read diff: removes `&& !crash_shutdown`, updates comment
  in `pseries_kexec_cpu_down()`.
- **[Phase 2]** Read current `arch/powerpc/platforms/pseries/kexec.c` —
  buggy `!crash_shutdown` guard at line 28.
- **[Phase 3]** `git blame v5.4`: `!crash_shutdown` since dce623e0827e8
  (2007); comment from 499dcd41378eba (2018).
- **[Phase 3]** `git show 499dcd41378eba`: Piggin expanded “XXX” comment
  questioning crash skip.
- **[Phase 3]** `git show b1301797f30370`: 2011 kexec VPA unregister fix
  had `Cc: stable@kernel.org`.
- **[Phase 3]** Verified buggy code at tags v5.4, v5.10, v5.15, v6.1,
  v6.6, v6.12, v6.18.
- **[Phase 4]** `b4 dig -c HEAD`: unrelated match only.
- **[Phase 4]** `b4 shazam`: patch not found on lore.
- **[Phase 4]** `WebFetch` lore URL: blocked (bot protection).
  **UNVERIFIED:** full review thread.
- **[Phase 5]** `grep kexec_cpu_down`: callers in `crash.c`
  (crash_shutdown=1) and `core_64.c` (crash_shutdown=0).
- **[Phase 5]** Read `plpar_wrappers.h`: unregister_* are inline
  hypervisor calls.
- **[Phase 5]** Read `hotplug-cpu.c:73-74`: always unregisters on CPU
  offline.
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: tree is
  6.18.44.
- **[Phase 6]** Buggy code confirmed present; fix not yet applied.
- **[Phase 6]** `git show` across tags: identical `!crash_shutdown`
  guard — clean backport expected.
- **[Phase 8]** Failure mode: hypervisor VPA corruption during kdump —
  severity HIGH for affected systems.

**YES**

 arch/powerpc/platforms/pseries/kexec.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/kexec.c b/arch/powerpc/platforms/pseries/kexec.c
index 431be156ca9bb..29f7c97ff1932 100644
--- a/arch/powerpc/platforms/pseries/kexec.c
+++ b/arch/powerpc/platforms/pseries/kexec.c
@@ -20,12 +20,15 @@
 void pseries_kexec_cpu_down(int crash_shutdown, int secondary)
 {
 	/*
-	 * Don't risk a hypervisor call if we're crashing
-	 * XXX: Why? The hypervisor is not crashing. It might be better
-	 * to at least attempt unregister to avoid the hypervisor stepping
-	 * on our memory.
+	 * Ensure vpa/slb_shadow/dtl cleanup even while we are crashing.
+	 * Why? The hypervisor is not crashing so at least attempt unregister to
+	 * avoid the hypervisor stepping on our memory. If hypervisor or kexec
+	 * kernel steps on the old memory allocated to these areas before the
+	 * new kexec-kernel happens to allocate and register new areas,
+	 * the hypervisor will see invalid content which may cause
+	 * unexpected behavior.
 	 */
-	if (firmware_has_feature(FW_FEATURE_SPLPAR) && !crash_shutdown) {
+	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
 		int ret;
 		int cpu = smp_processor_id();
 		int hwcpu = hard_smp_processor_id();
-- 
2.53.0

