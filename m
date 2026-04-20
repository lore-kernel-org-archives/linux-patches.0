Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8963E5577;
	Mon, 20 Apr 2026 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691493; cv=none; b=hBTQ5zVH9BenZSKYCSM0jGsRgFQlGWK5aUYF/ojMgktfhRnsQ0TiEWSse6xpCQJHBO9TM6bIZ0MOz3oYOJn3VXaSFdIT1cJ1i2Pfl/A1HQM2+LbCuzRxpjCXITt+vtv6ig51okHGLQqgkRjZ/zg/e+oU6y11QmEN/rc6t/y+yc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691493; c=relaxed/simple;
	bh=lk6iIm7LzLgEvSiocn/nJudNBxNOAcXBoMivMYFfH/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VOiKiSSZw6/od4xc1QRBEIkcFkbxbuoM4iAyCjUtm4T7UCaiMKl+dBYu1dZH9L4dzG0zEBg8d+nWvFFJIpwxgVB0KiZsgm2mkNjzRLX5tb3ynTSjbwg3ecnpxpaN9ptV3O/tOz7rFlIa13E0o7HXyBVbGgoNgsYPzOA/1RRzNH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udSRzyKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udSRzyKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25315C19425;
	Mon, 20 Apr 2026 13:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691493;
	bh=lk6iIm7LzLgEvSiocn/nJudNBxNOAcXBoMivMYFfH/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udSRzyKvaZpUpHacO3h3I+I8NDvZ5eQUUQOl9Rcl+PACvuF6XhJ+9SOkqn2+FNs35
	 Wmk95v1kWD5ZqVgIOg9X0Pv5nw6GkKpREKNnT68WFd8SVelwC+Pvi5W+NcdpQlCzah
	 SgD4IwB5Ow4qnMbnb49wRiESSvhSfXjfQxSu50i1IjglijpGuUQkI/G7doikM7YzE8
	 ZnboB6kzFbKVk4zswFSnoRT/xtT42G7NSsWn/Vb5PrEEqezjh5dpkEBNPi9wbvliCs
	 QuwJ24v0wIq64TC6tx6WIqHjjrxBvU0BgXYrBrzqoBz6xTCJZC8T6iMtbRKMwL1KGl
	 158HyljEVEvGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	xen-devel@lists.xenproject.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ARM: xen: validate hypervisor compatible before parsing its version
Date: Mon, 20 Apr 2026 09:17:36 -0400
Message-ID: <20260420132314.1023554-62-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f45ab27774aadeee28f093a9f074892e9bebb586 ]

fdt_find_hyper_node() reads the raw compatible property and then derives
hyper_node.version from a prefix match before later printing it with %s.
Flat DT properties are external boot input, and this path does not prove
that the first compatible entry is NUL-terminated within the returned
property length.

Keep the existing flat-DT lookup path, but verify that the first
compatible entry terminates within the returned property length before
deriving the version suffix from it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260405094005.5-arm-xen-v2-pengpeng@iscas.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Here is my complete analysis:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** ARM: xen
- **Action verb:** "validate" — implies adding missing input validation,
  strongly suggestive of a bug fix
- **Summary:** Validate the hypervisor compatible string before parsing
  the version suffix from it

### Step 1.2: Tags
- **Signed-off-by:** Pengpeng Hou (author), Juergen Gross (XEN
  HYPERVISOR INTERFACE maintainer — committer)
- **Reviewed-by:** Stefano Stabellini (XEN HYPERVISOR ARM maintainer)
- **Message-ID:** 20260405094005.5-arm-xen-v2-pengpeng@iscas.ac.cn
  (indicates v2 of patch)
- No Fixes: tag (expected for review candidates). No Cc: stable. No
  Reported-by.
- **Notable:** Both Xen ARM and Xen Interface maintainers endorsed this
  patch.

### Step 1.3: Commit Body
The commit explains:
- `fdt_find_hyper_node()` reads a raw `compatible` property from the
  flat device tree
- It derives `hyper_node.version` via a prefix match
- The version is later printed with `%s`
- FDT properties are **external boot input** — the code doesn't verify
  that the first compatible entry is NUL-terminated within the returned
  property length
- The fix adds validation of NUL-termination before deriving the version
  suffix

**Bug:** Potential buffer over-read and NULL pointer dereference from
unvalidated external input.
**Symptom:** Out-of-bounds read when printing version string, or crash
if property is absent.

### Step 1.4: Hidden Bug Fix Detection
This is explicitly framed as input validation hardening. "Validate"
clearly indicates fixing a missing safety check. This is a real bug fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **File:** `arch/arm/xen/enlighten.c` — single file
- **Function:** `fdt_find_hyper_node()` — single function
- **Changes:** ~6 lines modified (net: +4/-2 meaningful lines)
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Before:**
```c
const void *s = NULL;
int len;
// ...
s = of_get_flat_dt_prop(node, "compatible", &len);
if (strlen(hyper_node.prefix) + 3  < len &&
    !strncmp(hyper_node.prefix, s, strlen(hyper_node.prefix)))
    hyper_node.version = s + strlen(hyper_node.prefix);
```

**After:**
```c
const char *s = NULL;
int len;
size_t prefix_len = strlen(hyper_node.prefix);
// ...
s = of_get_flat_dt_prop(node, "compatible", &len);
if (s && len > 0 && strnlen(s, len) < len &&
    len > prefix_len + 3 &&
    !strncmp(hyper_node.prefix, s, prefix_len))
    hyper_node.version = s + prefix_len;
```

### Step 2.3: Bug Mechanism
Two bugs fixed:

**Bug 1 — NULL pointer dereference:** If `of_get_flat_dt_prop()` returns
NULL (property absent), `len` is set to a negative error code. The old
comparison `strlen(hyper_node.prefix) + 3 < len` compares `size_t`
(unsigned) with `int`. Due to C implicit conversion, the negative `len`
becomes a huge unsigned value, making the condition TRUE. Then
`strncmp(hyper_node.prefix, NULL, ...)` is called → undefined behavior /
crash.

**Bug 2 — Buffer over-read:** If the compatible property exists but its
first string entry lacks NUL-termination within the property length,
`hyper_node.version` points into unterminated data. Later, `pr_info("Xen
%s support found\n", hyper_node.version)` at line 268 reads beyond
property bounds → information leak or crash.

The fix adds: (1) NULL check `s &&`, (2) positive length check `len >
0`, (3) NUL-termination check `strnlen(s, len) < len`, and (4) proper
size comparison `len > prefix_len + 3` with correct types.

### Step 2.4: Fix Quality
- Obviously correct: adds standard defensive checks
- Minimal/surgical: only touches the parsing condition
- No regression risk: only adds validation; the happy path is identical
- Clean type change from `const void *` to `const char *` is appropriate

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The buggy code was introduced in commit `9b08aaa3199a4d` ("ARM: XEN:
Move xen_early_init() before efi_init()") by Shannon Zhao, first
appearing in **v4.8-rc1** (2016). This code has been present in the
kernel for ~10 years and exists in ALL current stable trees.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected). The correct Fixes target would be
`9b08aaa3199a4d`.

### Step 3.3: File History
The `fdt_find_hyper_node()` function has not been modified since its
introduction in 2016. Only unrelated parts of `enlighten.c` changed
(treewide cleanups, etc.). No prerequisite commits needed.

### Step 3.4: Author
Pengpeng Hou appears to contribute security/validation fixes across
multiple subsystems (nfc, net, tracing, bluetooth). The patch was
reviewed by the subsystem maintainer (Stefano Stabellini) and committed
by the Xen interface maintainer (Juergen Gross).

### Step 3.5: Dependencies
None. The fix is entirely self-contained. The code structure in stable
trees is identical to mainline for this function.

---

## PHASE 4: MAILING LIST

Lore was blocked by anti-bot measures. However, the Message-ID indicates
this is v2 of the patch, suggesting it went through at least one round
of review. The Reviewed-by from the ARM Xen maintainer and SOB from the
Xen interface maintainer confirm it was properly reviewed through the
standard process.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `fdt_find_hyper_node()` is modified.

### Step 5.2: Callers
`fdt_find_hyper_node()` is called from `xen_early_init()` (line 257) via
`of_scan_flat_dt()`. This is an `__init` function called very early
during boot on ARM Xen guests. After the function runs,
`hyper_node.version` is used in `pr_info()` at line 268.

### Step 5.3/5.4: Call Chain
Boot path: `xen_early_init()` → `of_scan_flat_dt(fdt_find_hyper_node,
NULL)` → flat DT scan callback invoked for each node. The data source is
the FDT blob — external boot input provided by the
hypervisor/bootloader.

### Step 5.5: Similar Patterns
`of_get_flat_dt_prop()` is used throughout `drivers/of/fdt.c`. Other
callers typically handle the NULL case (e.g., `if (p != NULL && l > 0)`
at line 1115). The buggy Xen code was an outlier that skipped this
validation.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy code was introduced in v4.8 and has NOT been modified since.
It exists in all active stable trees (5.10.y, 5.15.y, 6.1.y, 6.6.y,
6.12.y). Only tree-wide mechanical changes (kmalloc_obj, sys-off
handler) touched this file, none affecting the `fdt_find_hyper_node()`
function.

### Step 6.2: Backport Complications
The patch should apply cleanly to all stable trees. The function has
been untouched since 2016.

### Step 6.3: Related Fixes
No other fix for this specific issue exists in any stable tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- **Subsystem:** arch/arm/xen — ARM Xen hypervisor support
- **Criticality:** IMPORTANT — affects all ARM systems running as Xen
  guests
- **Maintainer endorsement:** Both the ARM Xen maintainer (Stefano
  Stabellini, Reviewed-by) and Xen Interface maintainer (Juergen Gross,
  committed) approved this fix

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
ARM Xen guest users. While not universal, this is a well-defined and
active user population (cloud VMs, embedded Xen deployments).

### Step 8.2: Trigger Conditions
- Bug 1 (NULL deref): hypervisor DT node exists but lacks "compatible"
  property — unusual but possible with malformed DT
- Bug 2 (over-read): hypervisor DT compatible property not NUL-
  terminated — possible with malicious/corrupt FDT
- Trigger is boot-time only, from external input

### Step 8.3: Failure Severity
- NULL pointer dereference → kernel crash during early boot → CRITICAL
- Buffer over-read → information leak or crash → HIGH (potential
  security issue)

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH — prevents potential crash or info leak from
  external input during boot on ARM Xen guests
- **Risk:** VERY LOW — 4-5 lines of pure input validation added to a
  single condition; happy path unchanged
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Fixes two real bugs: NULL pointer dereference and buffer over-read
  from external input
- Surgical fix: ~5 lines in one function, one file
- Reviewed and committed by both Xen subsystem maintainers
- Buggy code present since v4.8 (2016) — affects all stable trees
- Zero regression risk — only adds validation, happy path unchanged
- Will apply cleanly to all stable trees
- External input validation is security-relevant

**AGAINST backporting:**
- No user report or syzbot trigger (hardening/proactive fix)
- Boot-time only, ARM Xen specific (narrower impact than core kernel)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — standard NULL/bounds/NUL
   checks, reviewed by maintainer
2. Fixes a real bug? **YES** — NULL deref and buffer over-read from
   external input
3. Important issue? **YES** — potential crash (NULL deref) and info leak
   (over-read)
4. Small and contained? **YES** — ~5 lines in one function
5. No new features or APIs? **YES** — pure validation
6. Can apply to stable? **YES** — function unchanged since v4.8

### Step 9.3: Exception Categories
Not applicable (not a device ID, quirk, or DT addition — this is a
standard bug fix).

### Step 9.4: Decision
The fix prevents both a NULL pointer dereference and a buffer over-read
on external boot input in ARM Xen guests. It is minimal, obviously
correct, endorsed by both relevant subsystem maintainers, and applies
cleanly to all stable trees. The benefit clearly outweighs the near-zero
risk.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by from Stefano Stabellini (ARM Xen
  maintainer), SOB from Juergen Gross (Xen Interface maintainer)
- [Phase 2] Diff analysis: ~5 lines changed in single condition in
  `fdt_find_hyper_node()`, adds NULL check, len > 0 check, strnlen NUL-
  termination check
- [Phase 2] Verified `of_get_flat_dt_prop()` returns `const void *` and
  can return NULL (confirmed in `include/linux/of_fdt.h` line 56 and
  `drivers/of/fdt.c` line 622-626)
- [Phase 2] Verified type promotion bug: `strlen()` returns `size_t`
  (unsigned), `len` is `int` — negative len promotes to huge unsigned,
  making condition TRUE with NULL `s`
- [Phase 2] Verified `hyper_node.version` used with `%s` at line 268 in
  `pr_info()` — confirms over-read risk
- [Phase 3] git blame: buggy code introduced in commit `9b08aaa3199a4d`
  (Shannon Zhao, 2016), first in v4.8-rc1
- [Phase 3] git describe: confirmed `9b08aaa3199a4d` is in
  v4.8-rc1~141^2~36
- [Phase 3] git log v5.10.. / v6.1.. / v6.6..: confirmed function
  unchanged in all stable trees (only tree-wide mechanical changes to
  file)
- [Phase 5] Traced caller: `xen_early_init()` →
  `of_scan_flat_dt(fdt_find_hyper_node)` — boot-time path
- [Phase 5] Verified other callers of `of_get_flat_dt_prop` typically
  check for NULL (e.g., fdt.c line 1114-1115)
- [Phase 6] Code exists in all active stable trees (5.10+), function
  unchanged
- [Phase 7] MAINTAINERS confirms Stefano Stabellini maintains
  arch/arm/xen/ and Juergen Gross maintains Xen interface
- [Phase 8] Failure mode: NULL deref → crash at boot; over-read → info
  leak/crash. Severity: CRITICAL/HIGH
- UNVERIFIED: Could not access lore.kernel.org discussion due to anti-
  bot protection. Does not affect decision since maintainer review is
  confirmed via tags.

**YES**

 arch/arm/xen/enlighten.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 4feed2c2498dd..25a0ce3b4584a 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -218,8 +218,9 @@ static __initdata struct {
 static int __init fdt_find_hyper_node(unsigned long node, const char *uname,
 				      int depth, void *data)
 {
-	const void *s = NULL;
+	const char *s = NULL;
 	int len;
+	size_t prefix_len = strlen(hyper_node.prefix);
 
 	if (depth != 1 || strcmp(uname, "hypervisor") != 0)
 		return 0;
@@ -228,9 +229,10 @@ static int __init fdt_find_hyper_node(unsigned long node, const char *uname,
 		hyper_node.found = true;
 
 	s = of_get_flat_dt_prop(node, "compatible", &len);
-	if (strlen(hyper_node.prefix) + 3  < len &&
-	    !strncmp(hyper_node.prefix, s, strlen(hyper_node.prefix)))
-		hyper_node.version = s + strlen(hyper_node.prefix);
+	if (s && len > 0 && strnlen(s, len) < len &&
+	    len > prefix_len + 3 &&
+	    !strncmp(hyper_node.prefix, s, prefix_len))
+		hyper_node.version = s + prefix_len;
 
 	/*
 	 * Check if Xen supports EFI by checking whether there is the
-- 
2.53.0

