Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529B655C1BF;
	Mon, 31 Aug 2026 13:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184049; cv=none; b=HySVUu6OAVr6a65eJPr+HsGQfOhmEtmavhIVh9LfmwpeWx7VlNv/hlfcdxIH3UZFQToRw71onoMfQSPCh72aUQefT/2f7/n6UlbZ6faH2B8h9bEFzTLq70dc86bXE1oPK3GheJ6cBNRodmeDkzoM4KjVWObVN7P7LBYckPAynYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184049; c=relaxed/simple;
	bh=wXxp1Vp4fsV0oOwxzxkL3E/3MtKzNektS92oXNsxUV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qpBB48iWTHkT0uk4cj21TAr+Lbspl2OPz24a5bh5i7RD+nOLOOqKuitnE4qvCRCv6BgfWaBYaoi0i/NPUFB43Kxi+FL/wLx/LH+K84Vbjt9lyZiSk16INZ8GHTne8hQ+fbjiVCbD2zSLPQG9qgTH8iOAvxZ3MhHFDk5ARJDw09Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4PvxIms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4PvxIms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9EF1F000E9;
	Mon, 31 Aug 2026 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184045;
	bh=F9kJvXxPO++JKYWfYDCl2V4JYbBTnQZLVivtY9gyCnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4PvxImsaBkrlgN3hDHuzRz3ucD3nvfetg8WEzgUUBId17o06o4U2Z8TBRNpj2IJZ
	 FHzpWnX2hGnWrg8XlrFTpHq83vyvfqw0s/LUDT9vZpdfITU/rDwx0j8r/+empwq7pq
	 DEix1VIQc/ZuhPH+dhGwt0QjalORvzWaD+yjGjDASY0nudDBifVxNDM3p8xjmdSsGT
	 lXPjTlBo77ncg+kHdiDPYokvWUUeRJPynceMs/GVR4ZkpGtzA2Fr5FJ96TYxCd1goe
	 n1SLAJQEFZS369oUQOp65g471AUg/oWKfmEUQqeX+XeAJT/48vhF4qbM6NuRsnTRJq
	 WSCF9FwUeqLVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Wowk <dev@adrianwowk.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	valentina.manea.m@gmail.com,
	shuah@kernel.org,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usbip: vhci_hcd: fix NULL deref in status_show_vhci
Date: Mon, 31 Aug 2026 09:28:07 -0400
Message-ID: <20260831133314.4125787-459-sashal@kernel.org>
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

From: Adrian Wowk <dev@adrianwowk.com>

[ Upstream commit bc150783542ba2e7c1257d1299c6f3269bdba270 ]

platform_get_drvdata() can return NULL if a VHCI host controller's
probe failed (e.g. due to USB bus number exhaustion). status_show_vhci()
checked for a NULL pdev but not for a NULL hcd returned by
platform_get_drvdata(). Passing NULL to hcd_to_vhci_hcd() does not
return NULL - it returns a pointer offset of 0x260, causing a NULL
pointer dereference when that value is subsequently dereferenced.

Add a NULL check on hcd before calling hcd_to_vhci_hcd(). Move
status_show_not_ready() above status_show_vhci() to make it callable
from the new error path without a forward declaration.

Signed-off-by: Adrian Wowk <dev@adrianwowk.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://patch.msgid.link/20260414010050.158064-2-dev@adrianwowk.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `usbip: vhci_hcd: fix NULL deref in
status_show_vhci`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `make kernelversion`
→ 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[usbip: vhci_hcd]` `[fix]` — NULL pointer dereference in
`status_show_vhci()` when reading VHCI sysfs status.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Adrian Wowk, Greg Kroah-Hartman (ignore pipeline
  SOB)
- **Reviewed-by:** Shuah Khan (USB/usbip maintainer)
- **Link:**
  https://patch.msgid.link/20260414010050.158064-2-dev@adrianwowk.com
- No `Fixes:`, `Reported-by:`, `Cc: stable`, or `Tested-by:` tags
- Notable: maintainer review present; no syzbot report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `status_show_vhci()` checks `pdev` for NULL but not `hcd`
  from `platform_get_drvdata()`.
- **Trigger:** VHCI host controller probe failure (e.g. USB bus number
  exhaustion); `pdev` exists but `hcd` is NULL.
- **Mechanism:** `hcd_to_vhci_hcd(NULL)` does not return NULL; it yields
  a pointer at offset `0x260` into `struct usb_hcd`, then
  `vhci_hcd->vhci` dereferences that address → kernel oops.
- **Symptom:** NULL pointer dereference / kernel crash on sysfs read.
- **Fix:** NULL-check `hcd`; fall back to existing
  `status_show_not_ready()`; move that helper above `status_show_vhci()`
  to avoid forward declaration.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly labeled and clearly a NULL-deref bug fix,
not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/usb/usbip/vhci_sysfs.c` only
- **Scope:** ~12 lines added (NULL check + debug message), function
  reorder (no logic change to `status_show_not_ready`)
- **Functions:** `status_show_not_ready()` (moved up),
  `status_show_vhci()` (NULL guard added)
- **Classification:** Single-file surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (reorder):** `status_show_not_ready()` moved above
  `status_show_vhci()` — behavior unchanged.
- **Hunk 2 (`status_show_vhci`):**
  - **Before:** `hcd = platform_get_drvdata(pdev);` → immediate
    `hcd_to_vhci_hcd(hcd)` → `vhci_hcd->vhci` (crash if `hcd == NULL`).
  - **After:** If `!hcd`, log debug message and return
    `status_show_not_ready(pdev_nr, out)` (safe placeholder output).
  - **Path affected:** Sysfs `status` / `status.N` read when controller
    probe failed.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** NULL pointer dereference (memory safety)
- **Mechanism:** `hcd_to_vhci_hcd()` is:

```149:152:drivers/usb/usbip/vhci.h
static inline struct vhci_hcd *hcd_to_vhci_hcd(struct usb_hcd *hcd)
{
        return (struct vhci_hcd *) (hcd->hcd_priv);
}
```

  With `hcd == NULL`, `hcd->hcd_priv` is invalid; the resulting pointer
is then dereferenced at line 80 (`vhci_hcd->vhci`).

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — matches the existing pattern in `attach_store()`
  and `detach_store()` in the same file (lines 250–254, 344–348).
- **Regression risk:** Very low — only adds an error path using existing
  helper already used from `status_show()`.
- **No red flags:** No API changes, no locking changes, no cross-
  subsystem impact.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Buggy `platform_get_drvdata()` → `hcd_to_vhci_hcd()` path introduced
  in **03cd00d538a6f** (2017-06-08, "usbip: vhci-hcd: Set the vhci
  structure up to work").
- `pdev` NULL check added in **0775a9cbc694e** (2016-06-13, multi-
  controller extension).
- `attach_store()` / `detach_store()` gained `hcd == NULL` checks in the
  same **0775a9cbc694e** commit; `status_show_vhci()` was never updated
  — a long-standing oversight.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:**
- Recent fixes in this file: race/GPF fix (718ad9693e365, 2021),
  sysfs_lock (4e9c93af7279b), stream socket check (f55a0571690c4).
- This fix is standalone; not part of a multi-patch series.
- **Prerequisites:** None identified.

### Step 3.4: Author context
**Record:** Adrian Wowk has no prior usbip commits in this tree (commit
is mainline candidate not yet merged here). Reviewed by Shuah Khan
(active usbip maintainer).

### Step 3.5: Dependencies
**Record:** No dependencies. `status_show_not_ready()` already exists in
this tree and is callable from `status_show()`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <commit>` not possible — commit not in local
tree. Link fetch to patch.msgid.link and lore.kernel.org blocked (Anubis
bot protection). **UNVERIFIED:** full mailing-list thread content.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via `b4 dig -w`. Commit message documents
**Reviewed-by: Shuah Khan** and **Signed-off-by: Greg Kroah-Hartman**.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug identified by
code-path analysis (inconsistency with attach/detach NULL checks).

### Step 4.4: Related patches
**Record:** Standalone 1-file fix; no series dependency.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — lore stable search blocked. Prior usbip
stable fixes (e.g. 718ad9693e365) included `Cc: stable@vger.kernel.org`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `status_show_vhci()`, `status_show_not_ready()`,
`status_show()` (caller), `hcd_to_vhci_hcd()` (inline macro).

### Step 5.2: Callers
**Record:**
- `status_show_vhci()` called only from `status_show()` (line 160).
- `status_show()` registered as sysfs `.show` for `status` / `status.N`
  attributes (line 471).
- User-triggered via reading `/sys/devices/platform/vhci_hdc/status` (or
  `status.N`).

### Step 5.3: Callees
**Record:** `platform_get_drvdata()`, `hcd_to_vhci_hcd()`,
`spin_lock_irqsave()`, port iteration — all skipped on NULL `hcd` after
fix.

### Step 5.4: Reachability
**Record:**
- **Reachable:** Yes — any process that can read the sysfs file.
- `vhcis[pdev_nr].pdev` is set during `vhci_hcd_init()` before probe; if
  `vhci_hcd_probe()` fails before `usb_create_hcd()` sets drvdata (via
  `dev_set_drvdata` in `__usb_create_hcd()`), `platform_get_drvdata()`
  returns NULL while `pdev` is non-NULL.
- `vhci_hcd_suspend()` already guards `if (!hcd) return 0;` (line
  1452–1454), confirming NULL `hcd` is an expected state.

### Step 5.5: Similar patterns
**Record:** Same-file NULL checks already present:

```250:254:drivers/usb/usbip/vhci_sysfs.c
        hcd = platform_get_drvdata(vhcis[pdev_nr].pdev);
        if (hcd == NULL) {
                dev_err(dev, "port is not ready %u\n", port);
                return -EAGAIN;
        }
```

`status_show_vhci()` was the missing case.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at `v6.18.44` has no `hcd` NULL check
in `status_show_vhci()` (lines 78–80). Bug present since at least 2017.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — only reorders one static function
and adds a small guard block. No conflicting recent changes to this
function.

### Step 6.3: Fix already present?
**Record:** **NO** — grep shows no `hcd is NULL` check in
`status_show_vhci()`. Fix not in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/usb/usbip/` — USB/IP virtual host controller
(VHCI). **Criticality: PERIPHERAL** (optional `CONFIG_USBIP_VHCI_HCD`
module), but crash severity is high when enabled.

### Step 7.2: Activity
**Record:** Moderately active; recent fixes for races, locking, and
sysfs safety in 2021–2025.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_USBIP_VHCI_HCD` built/loaded who read
VHCI status sysfs after a controller probe failure.

### Step 8.2: Trigger conditions
**Record:**
- VHCI probe fails (ENOMEM, USB bus number exhaustion, `usb_add_hcd`
  failure paths).
- User or tool reads `status` sysfs entry.
- Uncommon but realistic on systems with many USB controllers or
  resource exhaustion.
- Sysfs permissions typically restrict to root; still a kernel bug worth
  fixing.

### Step 8.3: Failure mode
**Record:** NULL pointer dereference → kernel oops / possible panic.
**Severity: HIGH** (crash), **breadth: LOW** (usbip VHCI users only).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents kernel crash on sysfs read; completes parity
  with attach/detach error handling.
- **Risk:** Minimal — uses existing fallback helper, reviewed by
  maintainer.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real NULL-deref bug with clear crash mechanism
- Bug present in 6.18.y since 2017; attach/detach already handle this
  case
- Small, surgical, obviously correct fix
- Reviewed by Shuah Khan; signed off by Greg K-H
- Same class of fix as prior stable usbip commits (e.g. 718ad9693e365)

**AGAINST backport:**
- Affects optional `CONFIG_USBIP_VHCI_HCD` module only (narrow user
  base)
- No syzbot/user report in commit message
- Trigger requires probe failure (uncommon)

**Unresolved:**
- Exact `hcd_priv` offset 0x260 not independently measured (mechanism
  verified from source)
- Mailing-list thread not readable (bot protection)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors existing in-file
   pattern; maintainer reviewed.
2. Fixes a real bug? **PASS** — NULL deref on sysfs read.
3. Important issue? **PASS** — kernel oops (HIGH severity, narrow
   scope).
4. Small and contained? **PASS** — single file, ~20 lines touched.
5. No new features/APIs? **PASS** — defensive error path only.
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected.

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not a quirk/ID/DT/build/doc
exception.

### Step 9.4: Decision rationale
For **linux-6.18.y** at `v6.18.44`, the buggy code is present and
unfixed. The patch is a minimal NULL guard consistent with decade-old
attach/detach handling in the same file. It prevents a kernel oops when
users read VHCI status after probe failure. Scope is narrow (usbip VHCI
module) but the fix is low-risk and meets all stable criteria.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 2] Read current `vhci_sysfs.c` and `vhci.h`; confirmed missing
  NULL check and `hcd_to_vhci_hcd` macro behavior
- [Phase 3] `git describe HEAD` → v6.18.44; `git blame` on lines 63–95 →
  bug since 03cd00d538a6f (2017)
- [Phase 3] `git show 0775a9cbc694e` → attach/detach had `hcd == NULL`
  checks since 2016; status_show_vhci did not
- [Phase 3] `git log --oneline -20 -- drivers/usb/usbip/vhci_sysfs.c` →
  no duplicate fix
- [Phase 4] `b4 dig` failed (commit not in tree); lore/patch.msgid.link
  blocked by Anubis — **UNVERIFIED** thread content
- [Phase 4] Reviewed-by Shuah Khan and Greg K-H SOB taken from commit
  message only
- [Phase 5] Grep callers: `status_show_vhci` called only from
  `status_show()`; sysfs `.show` at line 471
- [Phase 5] Verified attach/detach NULL checks at lines 250–254, 344–348
- [Phase 5] Read `vhci_hcd_probe()` and `vhci_hcd_suspend()` NULL-hcd
  handling
- [Phase 5] Read `__usb_create_hcd()` — `dev_set_drvdata(dev, hcd)` at
  hcd.c:2589 for primary HCD
- [Phase 6] `make kernelversion` → 6.18.44; buggy code confirmed at
  lines 78–80
- [Phase 6] No existing fix in tree
- [Phase 8] CONFIG dependency: `USBIP_VHCI_HCD` in
  `drivers/usb/usbip/Kconfig`
- **UNVERIFIED:** Exact 0x260 byte offset of `hcd_priv` (stated in
  commit message; macro mechanism confirmed)

**YES**The background git searches finished and match what the earlier
analysis already found:

- **Fix in history:** No commit for `usbip: vhci_hcd: fix NULL deref in
  status_show_vhci` in this tree — the bug is still present in
  `v6.18.44`.
- **Author search:** Adrian Wowk has no usbip commits here (this is a
  mainline candidate). The only `hcd is NULL` hit was an unrelated `usb:
  chipidea` merge from 2013.

**Verdict unchanged: YES** — small, low-risk NULL-deref fix for sysfs
status reads when VHCI probe fails; worth backporting to `linux-6.18.y`.

 drivers/usb/usbip/vhci_sysfs.c | 52 +++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
index d5865460e82d5..336fb4d92c6f5 100644
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -59,6 +59,29 @@ static void port_show_vhci(char **out, int hub, int port, struct vhci_device *vd
 	*out += sprintf(*out, "\n");
 }
 
+static ssize_t status_show_not_ready(int pdev_nr, char *out)
+{
+	char *s = out;
+	int i = 0;
+
+	for (i = 0; i < VHCI_HC_PORTS; i++) {
+		out += sprintf(out, "hs  %04u %03u ",
+				    (pdev_nr * VHCI_PORTS) + i,
+				    VDEV_ST_NOTASSIGNED);
+		out += sprintf(out, "000 00000000 0000000000000000 0-0");
+		out += sprintf(out, "\n");
+	}
+
+	for (i = 0; i < VHCI_HC_PORTS; i++) {
+		out += sprintf(out, "ss  %04u %03u ",
+				    (pdev_nr * VHCI_PORTS) + VHCI_HC_PORTS + i,
+				    VDEV_ST_NOTASSIGNED);
+		out += sprintf(out, "000 00000000 0000000000000000 0-0");
+		out += sprintf(out, "\n");
+	}
+	return out - s;
+}
+
 /* Sysfs entry to show port status */
 static ssize_t status_show_vhci(int pdev_nr, char *out)
 {
@@ -76,6 +99,12 @@ static ssize_t status_show_vhci(int pdev_nr, char *out)
 	}
 
 	hcd = platform_get_drvdata(pdev);
+
+	if (!hcd) {
+		usbip_dbg_vhci_sysfs("show status error (hcd is NULL)\n");
+		return status_show_not_ready(pdev_nr, out);
+	}
+
 	vhci_hcd = hcd_to_vhci_hcd(hcd);
 	vhci = vhci_hcd->vhci;
 
@@ -104,29 +133,6 @@ static ssize_t status_show_vhci(int pdev_nr, char *out)
 	return out - s;
 }
 
-static ssize_t status_show_not_ready(int pdev_nr, char *out)
-{
-	char *s = out;
-	int i = 0;
-
-	for (i = 0; i < VHCI_HC_PORTS; i++) {
-		out += sprintf(out, "hs  %04u %03u ",
-				    (pdev_nr * VHCI_PORTS) + i,
-				    VDEV_ST_NOTASSIGNED);
-		out += sprintf(out, "000 00000000 0000000000000000 0-0");
-		out += sprintf(out, "\n");
-	}
-
-	for (i = 0; i < VHCI_HC_PORTS; i++) {
-		out += sprintf(out, "ss  %04u %03u ",
-				    (pdev_nr * VHCI_PORTS) + VHCI_HC_PORTS + i,
-				    VDEV_ST_NOTASSIGNED);
-		out += sprintf(out, "000 00000000 0000000000000000 0-0");
-		out += sprintf(out, "\n");
-	}
-	return out - s;
-}
-
 static int status_name_to_id(const char *name)
 {
 	char *c;
-- 
2.53.0

