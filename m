Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7124F755A;
	Mon, 31 Aug 2026 13:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183677; cv=none; b=tbFOW2c99xhVlgvEUQchYnisGaqeMtqouBzh3X7B+0m13ZDjsu8D7FAdCZqZRi7GKcoLA+q60zusuRZox6lipY8ikrmTrKeTRLUCqV/llaq3cg8pgj3pCkrVk19Xqoy44npFEKOBenuNCSVkh0R4wEAQTNmd7KBSKytm9CFtoLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183677; c=relaxed/simple;
	bh=NiOOIRe+RazP0jkQ8XhFlBUaPxVGUpjBuJ+/Z/UDFIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dHhoVtiMLk9WUxksGJrSEwfCIgrSeAm/qru6pvqYUMRRvt0mvCOg1XHay266Sael+/M/RMMqby/xw2erHG50S2DP8q37JmZLqXgQFTIxsMLtlsjX+Di4bk5y150O9JkM3StHt8hxfNykIZR9mI9DO7Nj6hoPWyPfE8OL/2rKKTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2iMtuTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2iMtuTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426461F00ACA;
	Mon, 31 Aug 2026 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183675;
	bh=/SouyGdEaHqB03m2lFAd2TnOK5ycVJFukmm9BxVy3sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2iMtuTzcee6cRfou3VWuJAxGKT++aVNnT9uf2PpFEH57zsnV4h7IXkF8bvjRO9Y9
	 kMcX04jN4ttcVa3K7AkQxHVoAxinoZ1xyOEFBZ/v5Jk3VDsEfslNaIYlfmZnZEc6t8
	 5onRHvmB+KISXoV8E1LIGTNvhsPhTgSw7hvv36ZFPPEJ/amNCol9m86iObtaaeXRtL
	 TfsMxb10hpzHw/FIsJaP5+uVUsLrpiAgZdB/pFOwKqZErVGDlEsY2ukelMlvMQ+OlO
	 tsWhCsCpeXOc0hR63OdfBNcPXp8dgS8XXhbS8qmIsXZz5FvjwYx9NiUYLtGB6UzkMC
	 4ZkFyX4hea3Vg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] powercap: intel_rapl: Fix memory leak in rapl_add_package_cpuslocked()
Date: Mon, 31 Aug 2026 09:24:25 -0400
Message-ID: <20260831133314.4125787-237-sashal@kernel.org>
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

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit bfc7d93bc5e12288e5dc6bb54260f68cdf5a5c47 ]

When topology_physical_package_id()/topology_logical_die_id() returns
a negative value, rapl_add_package_cpuslocked() returns ERR_PTR(-EINVAL)
directly without freeing the rapl_package structure that was just
allocated by kzalloc_obj(), leaking memory on every failed package
addition.

Use the existing err_free_package label so that the allocation is
released on the error path.

Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
Link: https://patch.msgid.link/20260515182616.227707-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[powercap: intel_rapl]` `[Fix]` — memory leak in
`rapl_add_package_cpuslocked()` on topology error path.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Sumeet Pawnikar `<sumeet4linux@gmail.com>` (author)
- **Link:** https://patch.msgid.link/20260515182616.227707-1-
  sumeet4linux@gmail.com
- **Signed-off-by:** Rafael J. Wysocki `<rafael.j.wysocki@intel.com>`
  (powercap/ACPI maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

Notable: maintainer sign-off; no syzbot/fuzzer report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** After `kzalloc`/`kzalloc_obj` allocates `struct
  rapl_package`, if `topology_physical_package_id()` or
  `topology_logical_die_id()` yields a negative value, the function
  returns `ERR_PTR(-EINVAL)` without freeing `rp`.
- **Symptom:** Kernel memory leak on each failed package addition.
- **Root cause:** Missing jump to existing `err_free_package` cleanup
  label on this error path.
- **Fix:** Set `ret = -EINVAL` and `goto err_free_package`.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly labeled and described as a memory leak fix.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/powercap/intel_rapl_common.c` (+2 / -1 lines in
  hunk)
- **Function:** `rapl_add_package_cpuslocked()`
- **Scope:** Single-file, surgical error-path fix

Note: upstream diff uses `kzalloc_obj()`; this tree uses
`kzalloc(sizeof(struct rapl_package), GFP_KERNEL)` at line 2210 —
allocation line unchanged by the fix.

### Step 2.2: Code flow change
**Record:**
- **Before:** On negative topology ID → immediate `return
  ERR_PTR(-EINVAL)` with `rp` leaked.
- **After:** On negative topology ID → `ret = -EINVAL; goto
  err_free_package;` → `kfree(rp->domains); kfree(rp); return
  ERR_PTR(ret);`
- **Path:** Error path in CPU-hotplug-driven package registration,
  before `rapl_config()`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Error-path resource leak (missing `kfree`).
- `rp->domains` is not yet allocated at this point; `kfree(NULL)` in
  `err_free_package` is safe.
- Other error paths (`rapl_config`, `rapl_detect_domains`,
  `rapl_package_register_powercap`) already use `err_free_package`.

### Step 2.4: Fix quality
**Record:** Obviously correct; reuses existing cleanup. Minimal
regression risk — no new APIs, locks, or behavior changes on success
paths.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Lines 2210–2219 blame to `7e22de67e545d` in this checkout
(shallow/stable history). Buggy early-return pattern is present in
current tree at lines 2217–2219.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** `git log --oneline -- drivers/powercap/intel_rapl_common.c`
shows only one commit in this checkout’s history. Negative-topology
guard and `err_free_package` label are both present; only the EINVAL
path omits cleanup.

### Step 3.4: Author context
**Record:** Sumeet Pawnikar; Rafael Wysocki (subsystem maintainer)
committed/acked. No other author commits visible in this shallow tree.

### Step 3.5: Dependencies
**Record:** Standalone; no series or prerequisite commits.
`err_free_package` already exists in this tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** `b4 dig -c HEAD` found no match. `b4 dig` with message-id
argument failed (wrong syntax). Lore and patch.msgid.link fetches
returned no usable review content (bot protection / thread not indexed).
**Series revisions, reviewer feedback, stable nominations: UNVERIFIED.**

### Step 4.2: Reviewers
**Record:** UNVERIFIED from lore. Maintainer SOB from Rafael Wysocki is
present in commit message.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Issue identified by
code inspection per commit message.

### Step 4.4: Related patches
**Record:** None found in local `.mbx` files.

### Step 4.5: Stable list
**Record:** UNVERIFIED — no stable-list discussion found.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `rapl_add_package_cpuslocked()`,
`rapl_find_package_domain_cpuslocked()`, `rapl_cpu_online()`.

### Step 5.2: Callers
**Record:**
- `drivers/powercap/intel_rapl_msr.c:79` — `rapl_cpu_online()` CPU
  hotplug callback (`id_is_cpu=true`)
- `rapl_add_package()` wrapper at `intel_rapl_common.c:2258–2261`
- `drivers/powercap/intel_rapl_tpmi.c:309` — `rapl_add_package(...,
  false)` (non-CPU ID path; bug path only when `id_is_cpu=true`)
- `drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c:84` —
  `rapl_add_package(0, ..., false)` (not affected)

### Step 5.3: Callees
**Record:** `kzalloc`, `topology_physical_package_id`,
`topology_logical_die_id`, `rapl_config`, `err_free_package` cleanup
(`kfree`).

### Step 5.4: Reachability
**Record:** Reachable from CPU hotplug on Intel/AMD/HYGON systems with
`CONFIG_INTEL_RAPL` MSR driver.

Trigger chain verified in code:
1. `rapl_cpu_online()` calls `rapl_find_package_domain_cpuslocked()` —
   if topology ID is negative, returns `NULL` (no leak).
2. Because `!rp`, calls `rapl_add_package_cpuslocked()` — allocates
   `rp`, hits same negative check, leaks on current code.

On x86, `topology_get_logical_id()` can return `-ENODEV` or `-ERANGE`;
stored in `u32 logical_die_id`, then `(int)rp->id < 0` detects the
wrapped negative value.

### Step 5.5: Similar patterns
**Record:** `rapl_find_package_domain_cpuslocked()` at lines 2177–2181
handles the same negative-topology case without allocation —
`rapl_add_package_cpuslocked()` is inconsistent.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Tree is `v6.18.44` (`VERSION=6 PATCHLEVEL=18
SUBLEVEL=44`). Bug at:

```2217:2219:drivers/powercap/intel_rapl_common.c
                if ((int)(rp->id) < 0) {
                        pr_err("topology_logical_(package/die)_id()
returned a negative value");
                        return ERR_PTR(-EINVAL);
```

`err_free_package` exists at lines 2251–2254.

### Step 6.2: Backport complications
**Record:** Clean apply expected — only change `return ERR_PTR(-EINVAL)`
to `ret = -EINVAL; goto err_free_package`. No conflict with `kzalloc` vs
upstream `kzalloc_obj`.

### Step 6.3: Related fixes already present?
**Record:** No — `git log --grep` found no matching fix; leaky path
still present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/powercap/intel_rapl` — **IMPORTANT** (Intel/AMD
power monitoring; widely enabled on x86 servers/laptops with
`CONFIG_INTEL_RAPL`).

### Step 7.2: Activity
**Record:** Shallow history in this checkout; driver and CPU hotplug
integration are mature and active in mainline.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** x86 systems with Intel RAPL MSR driver
(`CONFIG_INTEL_RAPL=m/y`), during CPU online/hotplug when topology IDs
are invalid.

### Step 8.2: Trigger conditions
**Record:** `topology_physical_package_id()` or
`topology_logical_die_id()` returns a value that is negative when cast
to `int` (e.g. `topology_get_logical_id()` error stored in `u32`).
Uncommon but realistic during hotplug races or topology registration
failures. Not userspace-triggerable directly; kernel-initiated on CPU
online.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM** — kmem leak (~one `struct rapl_package` per
failed attempt). No crash, corruption, or deadlock. Repeated hotplug
retries could accumulate leaked memory.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates leak on an error path that is explicitly
  exercised when `rapl_find_package_domain_cpuslocked()` already
  returned `NULL` for the same reason.
- **Risk:** Very low — 2-line logic change using existing cleanup.
- **Ratio:** Favorable for stable.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verified memory leak on error path
- Buggy code confirmed present in Linux 6.18.44 tree
- Fix is minimal, obviously correct, uses existing `err_free_package`
- Reachable from CPU hotplug (common on servers)
- Maintainer sign-off
- Matches stable pattern for error-path resource leaks

**AGAINST backport:**
- Failure mode is leak, not crash/corruption/security
- Trigger is relatively rare (invalid topology during hotplug)
- No fuzzer report or user bug report

**UNVERIFIED:**
- Lore review discussion and stable nominations
- Exact mainline commit SHA in this autosel checkout
- When the negative-topology guard was first introduced (shallow git
  history)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard `goto` cleanup;
   maintainer SOB; no Tested-by.
2. Fixes a real bug? **PASS** — kmem leak on EINVAL path.
3. Important issue? **PASS (moderate)** — resource leak on hotplug path,
   not critical crash.
4. Small and contained? **PASS** — 2-line functional change.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — code exists; clean apply
   expected.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale

For **this** tree (Linux 6.18.44), the bug exists, the fix is trivial
and correct, and the leak is on a reachable CPU-hotplug error path.
While not as severe as a crash or UAF, error-path kmem leaks in core
infrastructure drivers are routinely backported when the fix is this
small and low-risk. The inconsistency with
`rapl_find_package_domain_cpuslocked()` (which handles the same
condition without leaking) further supports inclusion.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 1]** Confirmed no syzbot/Fixes:/Cc: stable tags
- **[Phase 2]** Read `drivers/powercap/intel_rapl_common.c:2205–2254` —
  confirmed leak and `err_free_package` cleanup
- **[Phase 2]** Verified `kfree(rp->domains)` safe before
  `rapl_config()` on early error path
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; Makefile → 6.18.44
- **[Phase 3]** `git blame -L 2210,2220` — buggy return at line 2219
- **[Phase 3]** `git log --grep` — no fix commit already in tree
- **[Phase 4]** `b4 dig -c HEAD` — no match
- **[Phase 4]** Lore/patch.msgid.link fetch — no usable review content
  (UNVERIFIED review discussion)
- **[Phase 5]** `grep rapl_add_package` — callers in `intel_rapl_msr.c`,
  `intel_rapl_tpmi.c`, `processor_thermal_rapl.c`
- **[Phase 5]** Read `intel_rapl_msr.c:73–84` — hotplug call chain
  confirmed
- **[Phase 5]** Read `topology.c:311–321` — `topology_get_logical_id()`
  returns negative errors
- **[Phase 5]** Read `processor.h:95` — `logical_die_id` is `u32`;
  negative errors wrap and are caught by `(int)rp->id < 0`
- **[Phase 5]** Read `rapl_find_package_domain_cpuslocked:2176–2181` —
  same check without allocation
- **[Phase 6]** Confirmed buggy code at lines 2217–2219 in local tree
- **[Phase 6]** Confirmed fix not yet applied
- **[Phase 7]** `drivers/powercap/Kconfig` — `CONFIG_INTEL_RAPL` exists
- **[Phase 8]** Assessed severity as MEDIUM kmem leak on hotplug error
  path

**YES**

 drivers/powercap/intel_rapl_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 57bebd07c7d0d..f08ac99f5e55e 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -2216,7 +2216,8 @@ struct rapl_package *rapl_add_package_cpuslocked(int id, struct rapl_if_priv *pr
 			 topology_physical_package_id(id) : topology_logical_die_id(id);
 		if ((int)(rp->id) < 0) {
 			pr_err("topology_logical_(package/die)_id() returned a negative value");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_free_package;
 		}
 		rp->lead_cpu = id;
 		if (!rapl_msrs_are_pkg_scope() && topology_max_dies_per_package() > 1)
-- 
2.53.0

