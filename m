Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79D852F12D;
	Mon, 31 Aug 2026 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183894; cv=none; b=bBPLTff898i1/Sgeed5B1FHxi9YXbRxtqMt0xcEPAla9dOL+o2mzLmTxXU3UdsxzyUUM/ENF+pLbOVxHYJPz2EdGJDqy+xmTbKW4hr/GC2ft2Vf6hXYZS2xyfIZuYld596bbE7JzkqxPFYlOV28nQeNqFc+UtfW3nofAh/vPEzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183894; c=relaxed/simple;
	bh=1gQ0fNHi0dr34p5DUc/kt39jh94iHQ1aQJ4epP2Bvvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XtOW1CGHXnro30tVfGQ1fl4m4rVbozE8RCYx1q+bE25E0kWtwBcx3yZLkYnKCeOknZq8fhpTOfMZw13CNKDuS4W0k95WOx7PFm6spfmsz4ASHZrzu7JUBJDHqmEFXDMfBE7hy+ptlZMTNCaVaFbtd6dNGLMhPk0noqTWzuPjRvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1r27pYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1r27pYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C44B1F00A3F;
	Mon, 31 Aug 2026 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183890;
	bh=lVESvZtxLPN53N+V3hPGCVqY68pmm6oEw0Is776h6Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1r27pYoYv5RNmTPmn482JXQwAIig2CeL5vhqE2J9tB8BVwTe55R/OloqutkjS+BP
	 X83zlMu6+E+wELlOUILPOLWCYW8UXxeRtQfLEGEhiCPOtjHf2XzBKt0wSnb0+apdEL
	 pNJ+nxOMFKwEL5Xju1iDKSKep0jRdjTzMERljOrjkAeRRi6A8QYgNJY/axK61Vq/Ax
	 eeGvd2k9dDYEcg8aXkM5kcQCnnpAxFDqHrTsFcJF/QYQq8vQYv86m7Gf/G8sybA2ya
	 3Q1MzgjO8sXx39HCHdoslfr3BBa+hE4lVV7OOJ4wS5E6ZcPaL4c+lZQ6I7TayNqH86
	 3Bh+DUrrOyn4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	saravanak@kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drivers/of: validate live-tree string properties before string use
Date: Mon, 31 Aug 2026 09:26:32 -0400
Message-ID: <20260831133314.4125787-364-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 1e54c31b9cbbb42162e2e4317c18c8a8b350a79d ]

`populate_properties()` stores live-tree property values as raw byte
sequences plus a separate `length`. They are not globally guaranteed to
be NUL-terminated.

`of_prop_next_string()` iterates string-list properties by walking raw
bytes, `__of_node_is_type()` checks `device_type`,
`__of_device_is_status()` checks `status`, and
`of_alias_from_compatible()` reads the first `compatible` entry. These
paths must validate that the relevant string fits within the property
bounds before they hand it to C string helpers.

Validate these live-tree string properties within their declared bounds.
In particular, make `of_prop_next_string()` reject malformed entries
before returning them, keep the `device_type` check inside the existing
no-lock helper path, and add unit coverage for malformed first and
trailing string-list entries.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260507081812.91838-1-pengpeng@iscas.ac.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drivers/of: validate live-tree string
properties before string use`

## Local Tree Context

This checkout is **linux-6.18.y** at **v6.18.43** (`HEAD detached from
stable/linux-6.18.y`). The buggy code is present; this fix is not yet
applied.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[drivers/of]` `[validate]` — Validate live-tree string
properties before passing them to C string helpers (`strlen`, `strcmp`,
etc.).

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author)
- **Link:**
  https://patch.msgid.link/20260507081812.91838-1-pengpeng@iscas.ac.cn
- **Signed-off-by:** Rob Herring (Arm) `<robh@kernel.org>` (OF
  maintainer merge)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags

Notable: maintainer merge sign-off from Rob Herring; no syzbot or user
bug report.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `populate_properties()` and live-tree property storage keep
  raw byte sequences with a `length` field; they are not guaranteed NUL-
  terminated.
- **Affected paths:** `of_prop_next_string()`, `__of_node_is_type()`,
  `__of_device_is_status()`, `of_alias_from_compatible()` use
  `strlen`/`strcmp` without verifying the string fits within `length`.
- **Symptom:** Out-of-bounds reads when scanning for a NUL terminator on
  malformed properties.
- **Fix:** Validate with `strnlen()` within declared bounds; switch
  `of_alias_from_compatible()` to `of_property_read_string_index()`
  (already validated).
- **Root cause:** Inconsistent validation — some OF helpers already use
  `strnlen`, these paths do not.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite “validate” wording rather than “fix”, this is a
real memory-safety bug fix (out-of-bounds read), not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `drivers/of/base.c` | ~30 lines modified |
| `drivers/of/property.c` | ~25 lines modified |
| `drivers/of/unittest.c` | ~35 lines added (tests) |

**Functions modified:** `__of_node_is_type()`,
`__of_device_is_status()`, `of_alias_from_compatible()`,
`of_prop_next_string()`

**Scope:** Single-subsystem, surgical fix + unit tests.

### Step 2.2: Code Flow Changes

**Hunk 1 — `__of_node_is_type()`:**
- Before: `strcmp(match, type)` with no bounds check on `device_type`.
- After: `strnlen(match, len) >= len` rejects unterminated values before
  `strcmp`.

**Hunk 2 — `__of_device_is_status()`:**
- Before: `strlen(status)` / `strcmp` / `strncmp` without verifying
  `status` is NUL-terminated within `statlen`.
- After: Rejects if `strnlen(status, statlen) >= statlen`.

**Hunk 3 — `of_alias_from_compatible()`:**
- Before: `strlen(compatible) > cplen` — `strlen` itself can read past
  `cplen` if no NUL exists within bounds.
- After: Uses `of_property_read_string_index()` which already validates
  via `strnlen`.

**Hunk 4 — `of_prop_next_string()`:**
- Before: On first entry (`cur == NULL`), returns `prop->value`
  unconditionally; on advance uses `strlen(cur)` without bounds.
- After: Validates cursor within `[value, value+length)`; uses `strnlen`
  for both current and next strings; rejects unterminated entries.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Memory safety — out-of-bounds read (buffer
over-read).

**Mechanism:** Property values are stored as `(value, length)` byte
sequences. `strlen()`/`strcmp()` scan until NUL. If no NUL exists within
`length`, they read past the property boundary. The tree already has
test data for this:

```65:66:drivers/of/unittest-data/tests-phandle.dtsi
                                unterminated-string = [40 41 42 43];
                                unterminated-string-list = "first",
"second", [40 41 42 43];
```

`of_property_read_string_index()` already rejects these (`-EILSEQ`), but
`of_prop_next_string()` does not.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Matches the existing pattern in
  `of_property_read_string()` and `of_property_read_string_helper()`.
- **Minimal:** No API changes, no refactoring.
- **Regression risk:** Low — well-formed DT strings behave the same;
  only malformed properties change from OOB-read to safe rejection.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Shallow clone (`git rev-parse --is-shallow-repository` →
`true`); blame points all lines to merge base `6bda50f4333fa`. Cannot
determine original introduction commit from this checkout. Buggy code is
present in 6.18.43.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:** Shallow history limits `git log` on these files. In-tree,
`of_property_read_string()` (line 505) and
`of_property_read_string_helper()` (line 581) already use `strnlen`.
`overlay.c` line 228 also validates before `strlen`. This fix closes the
remaining gaps in the same subsystem.

### Step 3.4: Author History
**Record:** No prior commits from Pengpeng Hou in this shallow tree. Rob
Herring (OF maintainer) merged it.

### Step 3.5: Dependencies
**Record:** Standalone. Uses existing `of_property_read_string_index()`
(inline in `include/linux/of.h`, calls
`of_property_read_string_helper`). No series dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1–4.5
**Record:**
- `b4 dig -c HEAD` matched wrong commit (local HEAD, not this patch).
- `b4 dig` with message-ID failed (requires `-c COMMITISH`).
- lore.kernel.org and patch.msgid.link blocked by bot protection
  (Anubis).
- **UNVERIFIED:** Full mailing-list review thread, stable nominations,
  reviewer NAKs.

From commit message and Rob Herring merge sign-off: patch went through
normal OF maintainer tree.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `of_prop_next_string`, `__of_node_is_type`,
`__of_device_is_status`, `of_alias_from_compatible`

### Step 5.2: Callers
**Record:**
- `of_prop_next_string`: `__of_device_is_compatible()` (core device
  matching), `drivers/memory/of_memory.c`,
  `drivers/net/wireless/mediatek/mt76/eeprom.c`, `drivers/leds/leds-
  powernv.c`, `arch/powerpc/platforms/pseries/of_helpers.c`, macro in
  `include/linux/of.h`
- `__of_device_is_status` → `of_device_is_available()` (called on
  essentially every OF device probe), `of_device_is_fail`,
  `of_device_is_reserved`
- `__of_node_is_type` → `of_find_node_by_type()`,
  `of_get_next_cpu_node()`, `__of_device_is_compatible()`
- `of_alias_from_compatible` → SPI, I2C, DRM DSI, HSI, ACPI bus alias
  handling

### Step 5.3: Callees
**Record:** `__of_get_property`, `strnlen`, `strcmp`, `strncmp`,
`of_property_read_string_index` → `of_property_read_string_helper`

### Step 5.4: Reachability
**Record:** Reachable on every boot on DT-based platforms (ARM, RISC-V,
PowerPC, etc.) during device-tree parsing, matching, and probe. Trigger
requires malformed property data (bad DT blob, overlay, or dynamic
property), not normal well-formed vendor DT.

### Step 5.5: Similar Patterns
**Record:** Same `strnlen(prop->value, prop->length) >= prop->length`
check already exists in:
- `of_property_read_string()` at `drivers/of/property.c:505`
- `of_property_read_string_helper()` at `drivers/of/property.c:581`
- `overlay.c:228`

This fix brings the remaining helpers in line.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** All four vulnerable code paths exist in 6.18.43:

```615:629:drivers/of/property.c
const char *of_prop_next_string(const struct property *prop, const char
*cur)
{
        const void *curv = cur;
        // ...
        curv += strlen(cur) + 1;  // no bounds check on cur or first
string
```

```83:87:drivers/of/base.c
static bool __of_node_is_type(const struct device_node *np, const char
*type)
{
        const char *match = __of_get_property(np, "device_type", NULL);
        return np && match && type && !strcmp(match, type);  // no
bounds check
```

### Step 6.2: Backport Difficulty
**Record:** Clean apply expected — line context matches the provided
diff. No conflicting changes in recent 6.18.y history on these
functions.

### Step 6.3: Related Fixes Already Present?
**Record:** Partial. `of_property_read_string*` paths already validate.
`of_prop_next_string` and the three `base.c` helpers do not. No
duplicate fix found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/of` — Open Firmware / Device Tree core.
**Criticality: CORE** for all DT-based platforms.

### Step 7.2: Activity
**Record:** Actively maintained; recent commits include fwnode flag
thread-safety and alias refcount leak fixes in this tree.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** All DT/OF platforms (ARM, RISC-V, PowerPC, some MIPS, etc.).
Not x86 ACPI-only systems.

### Step 8.2: Trigger Conditions
**Record:**
- Malformed DT property without NUL within declared `length`
- Examples: raw byte properties (`[40 41 42 43]`), truncated overlay
  properties, dynamic properties via `__of_prop_dup()` (copies exact
  length, no added NUL)
- Unprivileged trigger: only if attacker can supply/modify DT (some
  embedded boot chains, overlay loading)
- Well-formed vendor DT: not affected

### Step 8.3: Failure Mode
**Record:** Out-of-bounds read past property boundary → KASAN report,
potential oops, information leak from adjacent memory. **Severity:
HIGH** (memory safety); not data corruption but real kernel robustness
issue.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for DT platforms — closes OOB-read holes in core
  matching/probe paths
- **Risk:** VERY LOW — ~55 lines of production code, mirrors existing
  validated patterns
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real out-of-bounds read bug in core OF code
- Affects device matching, status checks, alias resolution — common boot
  paths
- Small, surgical, maintainer-merged fix
- Consistent with validation already present in same files
- Unit tests included
- Bug demonstrable with existing `unterminated-string` test data

**AGAINST backport:**
- Requires malformed DT to trigger (not typical production DT)
- No user/syzbot report in commit message
- Mailing-list discussion unverified

**Unresolved:**
- Full lore review thread (blocked)
- Exact mainline commit hash (not in shallow 6.18.y history)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors existing `strnlen`
   pattern; adds unit tests
2. Fixes a real bug? **PASS** — OOB read on malformed properties
3. Important issue? **PASS** — memory safety / potential crash on DT
   platforms
4. Small and contained? **PASS** — ~55 lines production code + tests
5. No new features/APIs? **PASS** — behavior change only for malformed
   input
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected

### Step 9.3: Exception Category
**Record:** N/A (not device ID, quirk, DT binding, build fix, or docs
fix — standard bug fix).

### Step 9.4: Decision Rationale

For **linux-6.18.y**, this commit fixes a genuine memory-safety gap in
core device-tree string handling. Several OF helpers already validate
with `strnlen`, but `of_prop_next_string()` and three `base.c` helpers
do not — creating inconsistent, unsafe behavior on malformed properties.
The fix is small, follows established in-tree patterns, is merged by the
OF maintainer, and affects paths used during every device probe on DT
platforms. The trigger (malformed DT) is uncommon in production but is
exactly the class of input the kernel must handle safely.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed no `Fixes:`, `Reported-by:`, or `Cc: stable`
  tags
- **[Phase 2]** Diff analysis: 3 production files, 4 functions modified
- **[Phase 2]** Read current `of_prop_next_string()` at
  `drivers/of/property.c:615-629` — uses unbounded `strlen`
- **[Phase 2]** Read current `__of_node_is_type()` at
  `drivers/of/base.c:83-87` — no bounds check
- **[Phase 2]** Read current `__of_device_is_status()` at
  `drivers/of/base.c:437-460` — no bounds check
- **[Phase 2]** Read current `of_alias_from_compatible()` at
  `drivers/of/base.c:1170-1181` — `strlen` before bounds validation
- **[Phase 2]** Read `of_property_read_string()` at
  `drivers/of/property.c:505` — already uses `strnlen` (fix pattern
  exists)
- **[Phase 2]** Read `of_property_read_string_helper()` at
  `drivers/of/property.c:581` — already uses `strnlen`
- **[Phase 2]** Read `overlay.c:228` — already uses `strnlen`
- **[Phase 3]** `git rev-parse --is-shallow-repository` → `true`
  (limited history)
- **[Phase 3]** `git blame` on changed lines — all point to
  `6bda50f4333fa` (shallow base)
- **[Phase 3]** Verified `of_property_read_string_index` exists at
  `include/linux/of.h:1262-1268`
- **[Phase 4]** `b4 dig -c HEAD` — returned unrelated URL (wrong match)
- **[Phase 4]** `b4 dig` with message-ID — failed (wrong usage)
- **[Phase 4]** UNVERIFIED: lore.kernel.org and patch.msgid.link blocked
  by bot protection
- **[Phase 5]** `grep of_prop_next_string` — 6 call sites in production
  code
- **[Phase 5]** `grep of_alias_from_compatible` — 6 production call
  sites
- **[Phase 5]** `grep of_device_is_available` — widespread driver usage
  confirmed
- **[Phase 6]** `git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`;
  branch `stable/linux-6.18.y`
- **[Phase 6]** Confirmed buggy code present in all four functions
- **[Phase 6]** Read `tests-phandle.dtsi:65-66` — unterminated test
  properties exist
- **[Phase 6]** Read `__of_prop_dup()` at `drivers/of/dynamic.c:424` —
  `kmemdup` without NUL padding
- **[Phase 8]** Failure mode: OOB read via `strlen`/`strcmp` on non-NUL-
  terminated property within declared length

**YES**

 drivers/of/base.c     | 43 ++++++++++++++++++++++++++-----------------
 drivers/of/property.c | 27 +++++++++++++++++++++------
 drivers/of/unittest.c | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 6620bf07b79b8..f6b99bd7a9ceb 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -82,9 +82,17 @@ EXPORT_SYMBOL(of_node_name_prefix);
 
 static bool __of_node_is_type(const struct device_node *np, const char *type)
 {
-	const char *match = __of_get_property(np, "device_type", NULL);
+	const char *match;
+	int len;
+
+	if (!np || !type)
+		return false;
+
+	match = __of_get_property(np, "device_type", &len);
+	if (!match || len <= 0 || strnlen(match, len) >= len)
+		return false;
 
-	return np && match && type && !strcmp(match, type);
+	return !strcmp(match, type);
 }
 
 #define EXCLUDED_DEFAULT_CELLS_PLATFORMS ( \
@@ -444,22 +452,22 @@ static bool __of_device_is_status(const struct device_node *device,
 		return false;
 
 	status = __of_get_property(device, "status", &statlen);
-	if (status == NULL)
+	if (!status || statlen <= 0)
+		return false;
+	if (strnlen(status, statlen) >= statlen)
 		return false;
 
-	if (statlen > 0) {
-		while (*strings) {
-			unsigned int len = strlen(*strings);
+	while (*strings) {
+		unsigned int len = strlen(*strings);
 
-			if ((*strings)[len - 1] == '-') {
-				if (!strncmp(status, *strings, len))
-					return true;
-			} else {
-				if (!strcmp(status, *strings))
-					return true;
-			}
-			strings++;
+		if ((*strings)[len - 1] == '-') {
+			if (!strncmp(status, *strings, len))
+				return true;
+		} else {
+			if (!strcmp(status, *strings))
+				return true;
 		}
+		strings++;
 	}
 
 	return false;
@@ -1170,10 +1178,11 @@ EXPORT_SYMBOL(of_find_matching_node_and_match);
 int of_alias_from_compatible(const struct device_node *node, char *alias, int len)
 {
 	const char *compatible, *p;
-	int cplen;
+	int ret;
 
-	compatible = of_get_property(node, "compatible", &cplen);
-	if (!compatible || strlen(compatible) > cplen)
+	ret = of_property_read_string_index(node, "compatible", 0,
+					    &compatible);
+	if (ret)
 		return -ENODEV;
 	p = strchr(compatible, ',');
 	strscpy(alias, p ? p + 1 : compatible, len);
diff --git a/drivers/of/property.c b/drivers/of/property.c
index c1feb631e3831..71322b5bda267 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -614,16 +614,31 @@ EXPORT_SYMBOL_GPL(of_prop_next_u32);
 
 const char *of_prop_next_string(const struct property *prop, const char *cur)
 {
-	const void *curv = cur;
+	const char *curv;
+	const char *end;
+	size_t len;
 
-	if (!prop)
+	if (!prop || !prop->value || !prop->length)
 		return NULL;
 
-	if (!cur)
-		return prop->value;
+	curv = cur ? cur : prop->value;
+	end = prop->value + prop->length;
 
-	curv += strlen(cur) + 1;
-	if (curv >= prop->value + prop->length)
+	if (curv < (const char *)prop->value || curv >= end)
+		return NULL;
+
+	if (cur) {
+		len = strnlen(curv, end - curv);
+		if (len >= end - curv)
+			return NULL;
+
+		curv += len + 1;
+		if (curv >= end)
+			return NULL;
+	}
+
+	len = strnlen(curv, end - curv);
+	if (len >= end - curv)
 		return NULL;
 
 	return curv;
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 02b780b6e8e25..729813d54c22d 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -713,6 +713,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 static void __init of_unittest_property_string(void)
 {
 	const char *strings[4];
+	const struct property *prop;
 	struct device_node *np;
 	int rc;
 
@@ -789,6 +790,37 @@ static void __init of_unittest_property_string(void)
 	strings[1] = NULL;
 	rc = of_property_read_string_array(np, "phandle-list-names", strings, 1);
 	unittest(rc == 1 && strings[1] == NULL, "Overwrote end of string array; rc=%i, str='%s'\n", rc, strings[1]);
+
+	/* of_prop_next_string() tests */
+	prop = of_find_property(np, "phandle-list-names", NULL);
+	strings[0] = of_prop_next_string(prop, NULL);
+	unittest(strings[0] && !strcmp(strings[0], "first"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(strings[0] && !strcmp(strings[0], "second"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(strings[0] && !strcmp(strings[0], "third"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(!strings[0],
+		 "of_prop_next_string() should return NULL at end of list\n");
+
+	prop = of_find_property(np, "unterminated-string", NULL);
+	strings[0] = of_prop_next_string(prop, NULL);
+	unittest(!strings[0],
+		 "of_prop_next_string() should reject unterminated first string\n");
+
+	prop = of_find_property(np, "unterminated-string-list", NULL);
+	strings[0] = of_prop_next_string(prop, NULL);
+	unittest(strings[0] && !strcmp(strings[0], "first"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(strings[0] && !strcmp(strings[0], "second"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(!strings[0],
+		 "of_prop_next_string() should reject unterminated trailing string\n");
 }
 
 #define propcmp(p1, p2) (((p1)->length == (p2)->length) && \
-- 
2.53.0

