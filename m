Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DBA4F052F;
	Mon, 31 Aug 2026 13:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183650; cv=none; b=lck6GkooyGtJwJB3Jg7OpQCEbVk70boPaOk4ZTKZBH9BD+EZiz4td6AmAleO2wuaqv9knI61DNczUvdJ1ImE2PFMs3plA+TPFEFZ9cCotUzPM6LUHHplq2Ni2nbUWEsn/Xxazf1YK4mda3cZHYZNbfrABLM/2vqyE2uo1c7C/Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183650; c=relaxed/simple;
	bh=0dIPjFV0mbiqoPj9LlF+ftQlzgiUW1UrLiaZuHD06xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWPUKEi9k1tMdfTaxQ0He8YxCNUnja4dFJOyHmRwhvIwrQekdUiGLOJ53FoFsqjmMP9Q26umIU70+Xdw9f2lladtLaxkAARwzNUUqG0l6EXFy+EHdvNciKj+AKxgXxoPlJgiIb24n6kTZ9dBoGTUwIGLhRvPLBVcp1a7016l4kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7eeazSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7eeazSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1841F00A3D;
	Mon, 31 Aug 2026 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183647;
	bh=+/y1sOX8N5p80BcczvmryeMXn0Jk9heDEynMivmStSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7eeazSlsPSPIigaq1PL8hVd/NlgapzmEwKn0B/wN7sDukIl/Cz3+Dav8QQNKbgNR
	 9Nyk6kVgr0w+k4x7H8E7C+QikxAZksQN0mr6r9a6MnZavVYEqxr1uHmJdog5L1TeJY
	 NVGijFzrnrEkf12OmUGnQqyJxdmz+O/SytEtuHeCjxOmFxYmHoR6HSfQYmt7kmlmWA
	 9ZSYPL7G5I1hcDx+jXzR+E9j/2jxAsRNUZZ7vkM8nqmFgwyj6RjCgnMQox6SsXtKTJ
	 jkP5Z4TcEf+hntVD80TGxzw3A1Pr+CDMSgBIVAPoay3sWJG6ATCbAtB3lSXNtYvdAr
	 JARmvENwgMCxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/gma500: return errors from Oaktrail HDMI I2C reads
Date: Mon, 31 Aug 2026 09:24:07 -0400
Message-ID: <20260831133314.4125787-219-sashal@kernel.org>
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

[ Upstream commit 9b5ce5c496efd20c1c662cedba88465d39ec1f93 ]

xfer_read() waits for the HDMI I2C transaction to reach
I2C_TRANSACTION_DONE, but it ignores both timeout and signal returns from
wait_for_completion_interruptible_timeout().  If the interrupt never
advances the transaction state, the loop can wait forever.

Return -ETIMEDOUT when the completion wait expires, propagate interrupted
waits, and make the I2C master_xfer callback return the first transfer
error instead of reporting a successful message count.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260625003240.6923-1-pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/gma500: return errors from Oaktrail
HDMI I2C reads`

**Local tree:** `v6.18.44` (`VERSION = 6`, `PATCHLEVEL = 18`, `SUBLEVEL
= 44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[drm/gma500]` `[return]` — propagate errors from Oaktrail
HDMI I2C read transfers instead of ignoring them.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Cc: stable@vger.kernel.org** — none (expected for manual review)
- **Link:**
  `https://patch.msgid.link/20260625003240.6923-1-pengpeng@iscas.ac.cn`
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>`, Patrik
  Jakobsson `<patrik.r.jakobsson@gmail.com>` (subsystem maintainer)
- **Notable:** No syzbot/fuzzer report; maintainer sign-off is a
  positive quality signal.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `xfer_read()` calls
  `wait_for_completion_interruptible_timeout()` in a loop but ignores
  its return value.
- **Symptom:** On timeout (`ret == 0`) or signal (`ret < 0`), the loop
  continues while `i2c_dev->status != I2C_TRANSACTION_DONE`, so the
  thread never exits if the interrupt never advances state.
- **Failure mode:** Unbounded wait (10-second timeout iterations
  forever); caller also gets a successful message count instead of an
  error.
- **Root cause:** Missing error handling on completion wait;
  `oaktrail_hdmi_i2c_access()` ignores `xfer_read()` return value.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit hang/error-propagation
fix. The `master_xfer` callback change (return first error instead of
message count) is standard I2C error semantics.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c` (+11 net lines,
  ~20 lines touched)
- **Functions:** `xfer_read()`, `oaktrail_hdmi_i2c_access()`
- **Scope:** Single-file surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Hunk 1 — `xfer_read()` (lines 109–113 today):**

```109:113:drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
        while (i2c_dev->status != I2C_TRANSACTION_DONE)
wait_for_completion_interruptible_timeout(&i2c_dev->complete,
                                                                10 *
HZ);

        return 0;
```

- **Before:** Loop ignores wait return; always returns 0.
- **After:** On `ret < 0` propagate signal (`-ERESTARTSYS`); on `ret ==
  0` return `-ETIMEDOUT`; only return 0 when transaction completes.

**Hunk 2 — `oaktrail_hdmi_i2c_access()` (lines 139–154 today):**

- **Before:** Ignores `xfer_read()`/`xfer_write()` return; always
  returns `i` (message count).
- **After:** Captures `ret`, breaks on error, returns error to I2C core;
  only returns `i` on success.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Logic/correctness — infinite wait loop + incorrect
  success reporting.
- **Mechanism:** `wait_for_completion_interruptible_timeout()` returns 0
  on timeout and negative on signal (documented in
  `kernel/sched/completion.c` lines 237–238). The old loop treated both
  as "keep waiting." The `i2c_lock` mutex remains held for the duration,
  blocking all other transfers on adapter 3.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is minimal and matches standard kernel completion-wait patterns.
- Correct I2C `master_xfer` semantics (negative errno on failure).
- **Regression risk:** Very low. Only changes error/timeout paths;
  success path unchanged.
- Mutex is still released on error via the existing unlock at the end of
  `oaktrail_hdmi_i2c_access()`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** All changed lines blame to `5d324e5159d9e` (Nov 28, 2025
merge) in this shallow checkout. File copyright header shows original
authorship by Li Peng / Intel, 2010 — the buggy wait loop has been
present since initial implementation. Shallow clone limits deeper
history verification.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Recent related stable backports in this tree:
- `6d835a99474cd` — `drm/gma500/oaktrail_hdmi: fix i2c adapter leak on
  setup`
- `ab9256936b58e` — `drm/gma500/oaktrail_lvds: fix hang on init failure`
- `4e003e2fb6d3f` — `drm/gma500/oaktrail_lvds: fix i2c adapter leaks on
  init`

Same driver, same maintainer (Patrik Jakobsson), same class of I2C/hang
fixes already accepted into 6.18.y.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Pengpeng Hou not found in shallow history for this file.
Patrik Jakobsson is the gma500 maintainer (signed off on related
oaktrail stable fixes above).

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** Standalone fix. No series markers, no structural
dependencies. Diff matches current file content in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c <commit>` not possible — commit not in this tree.
Lore.kernel.org and patch.msgid.link blocked by Anubis bot protection.
**UNVERIFIED:** Full review thread content, stable nominations in
review.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** **UNVERIFIED** (lore inaccessible). Patrik Jakobsson
(maintainer) Signed-off-by in commit message.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No Reported-by, no syzbot link. Proactive code-quality/hang
fix from author.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Part of ongoing gma500 oaktrail I2C robustness work (same
timeframe as Johan Hovold's oaktrail I2C leak/hang fixes). Standalone;
no multi-patch dependency.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** **UNVERIFIED** (lore inaccessible). Related oaktrail fixes
were explicitly `Cc: stable@vger.kernel.org` and landed in this 6.18.y
tree.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `xfer_read()`, `oaktrail_hdmi_i2c_access()`, indirectly
`oaktrail_hdmi_i2c_handler()` (IRQ completes the wait).

### Step 5.2: TRACE CALLERS
**Record:**
- `oaktrail_hdmi_i2c_access` is the `master_xfer` callback for I2C
  adapter `.nr = 3` (`oaktrail_hdmi_i2c_adapter`).
- Registered in `oaktrail_hdmi_i2c_init()` called from `oaktrail_hdmi.c`
  during HDMI setup.
- Kernel caller of adapter 3: only `oaktrail_hdmi_get_modes()` via
  `i2c_get_adapter(3)`, but **`drm_get_edid()` is commented out** — it
  uses hardcoded `raw_edid` instead.
- Userspace can access the registered adapter via i2c-dev
  (`/dev/i2c-3`).
- LVDS uses `dev_priv->ops->i2c_bus = 1` (from `oaktrail_device.c`), not
  adapter 3.

### Step 5.3: TRACE CALLEES
**Record:** `wait_for_completion_interruptible_timeout()`,
`reinit_completion()`, HDMI register MMIO, `mutex_lock/unlock`,
`hdmi_i2c_irq_enable/disable`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
- Init path: `oaktrail_hdmi setup` → `oaktrail_hdmi_i2c_init()` →
  registers adapter 3 (always on Oaktrail HDMI hardware).
- Read path: `i2c_transfer()` on adapter 3 →
  `oaktrail_hdmi_i2c_access()` → `xfer_read()` → wait loop.
- **Reachability today:** Kernel EDID-over-HDMI-I2C path is disabled
  (FIXME). Reachable from userspace i2c tools or if `drm_get_edid()` is
  enabled later.
- Mutex held during hang blocks all I2C on adapter 3.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Same driver family recently fixed analogous hang/leak issues
(`ab9256936b58e` — "deregistration hangs indefinitely"). This patch
addresses the same class of problem in the HDMI I2C path.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Buggy code confirmed at lines 109–113 and 139–154
of `drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c`. Fix commit is **not**
present in this tree.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply** — provided diff matches current
file content line-for-line. No conflicting recent changes to this file
in 6.18.y history.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Related oaktrail I2C leak/hang fixes are present; this
specific HDMI I2C error-propagation fix is **not**.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/gpu/drm/gma500` — DRM driver for Intel
GMA500/600/3600/3650 (Poulsbo, Moorestown/Oak Trail, Cedar Trail).
**Criticality: PERIPHERAL** — config-gated (`CONFIG_DRM_GMA500`),
x86-only, legacy embedded hardware.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Active in 6.18.y — multiple oaktrail I2C fixes landed May
2026. Maintainers are actively hardening this code path.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users with `CONFIG_DRM_GMA500` on Oak Trail / GMA600
hardware with HDMI I2C controller. Small but real population (legacy
netbooks/tablets).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- **Trigger:** I2C read on adapter 3 when HDMI I2C interrupt never sets
  `I2C_TRANSACTION_DONE` (hardware fault, missing monitor, IRQ failure).
- **Likelihood:** Low in default kernel config (EDID read via this
  adapter disabled), higher if userspace uses i2c-3 or if
  `drm_get_edid()` is enabled.
- **Unprivileged trigger:** Userspace i2c access could trigger; not a
  typical attack surface.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- **Failure mode:** Infinite wait loop (10s timeout iterations) with
  `i2c_lock` held; thread hang; I2C adapter permanently blocked.
- **Severity: HIGH** when triggered (system hang for that context), but
  **LOW probability** in current default code path.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Prevents unbounded hang; correct error propagation to I2C
  core. Essential if HDMI EDID reading is ever enabled.
- **Risk:** Very low — ~20 lines, error-path only, no API changes.
- **Ratio:** Favorable. Same driver already receives similar stable
  fixes.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real bug: infinite wait on I2C timeout/signal, mutex held
- Small, obviously correct, maintainer-signed
- Buggy code present in 6.18.44 tree; fix not yet applied
- Same gma500/oaktrail I2C hang/leak fixes already in this stable tree
- Registered I2C adapter that can hang on read is a driver correctness
  issue
- No new APIs or features

**AGAINST backport:**
- Very niche hardware (`CONFIG_DRM_GMA500`, legacy Oaktrail)
- Kernel EDID read via this adapter currently disabled (`drm_get_edid`
  commented out in `oaktrail_hdmi_get_modes`)
- No user/fuzzer reports
- Default boot path may not exercise `xfer_read()` today

**UNRESOLVED:**
- Full lore review thread (bot-blocked)
- Exact upstream commit hash (not in shallow tree)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — standard completion-wait
   pattern; maintainer SOB; no Tested-by.
2. Fixes a real bug affecting users? **PASS** — real hang in I2C driver
   code; limited but real hardware population.
3. Important issue? **PASS** — hang with mutex held (HIGH severity when
   triggered).
4. Small and contained? **PASS** — one file, ~20 lines.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — code matches; clean apply
   expected.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** N/A — not a device ID, quirk, DT, build, or docs fix.
Standard driver bug fix.

### Step 9.4: DECISION RATIONALE

This is a legitimate hang fix in production driver infrastructure. The
HDMI I2C adapter is registered on every affected system; even though the
kernel EDID path is currently stubbed out, the I2C read implementation
is live code that hangs indefinitely on hardware/IRQ failure. The fix is
minimal, low-risk, and consistent with other oaktrail I2C fixes already
backported to this 6.18.y tree. The niche hardware and currently-
disabled EDID path reduce urgency but do not negate the technical merit.

---

## Verification

- **[Phase 1]** `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`;
  Makefile → 6.18.44
- **[Phase 1]** Parsed commit message tags from user-provided content
- **[Phase 2]** Read `drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c` —
  confirmed buggy wait loop at lines 109–113
- **[Phase 2]** Read `kernel/sched/completion.c` lines 237–238 —
  confirmed return semantics (0=timeout, <0=signal, >0=completed)
- **[Phase 3]** `git blame -L 93,155` — buggy code present in current
  tree
- **[Phase 3]** `git log --oneline -20 -- drivers/gpu/drm/gma500/` —
  found related stable backports (`6d835a99474cd`, `ab9256936b58e`,
  `4e003e2fb6d3f`)
- **[Phase 3]** `git log --grep="return errors from Oaktrail"` → empty;
  fix not in tree
- **[Phase 3]** `git rev-parse --is-shallow-repository` → `true` (limits
  history depth)
- **[Phase 4]** `b4 dig` — commit not in tree; cannot run `-c`
- **[Phase 4]** Lore/patch.msgid.link fetch — blocked by Anubis
  (**UNVERIFIED** review thread)
- **[Phase 5]** `grep` oaktrail_hdmi.c — `drm_get_edid()` commented out
  at line 581; adapter 3 registered at init
- **[Phase 5]** `grep i2c_bus` in gma500 — LVDS uses bus 1, not 3
- **[Phase 6]** Confirmed buggy code exists; fix absent
- **[Phase 6]** Diff matches current file content (manual comparison)
- **[Phase 7]** Read `drivers/gpu/drm/gma500/Kconfig` —
  `CONFIG_DRM_GMA500` details
- **[Phase 8]** Assessed hang severity and niche hardware scope

**YES**

 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
index 6daa6669ed237..4f1d095fc5a81 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
@@ -95,6 +95,7 @@ static int xfer_read(struct i2c_adapter *adap, struct i2c_msg *pmsg)
 	struct oaktrail_hdmi_dev *hdmi_dev = i2c_get_adapdata(adap);
 	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
 	u32 temp;
+	int ret;
 
 	i2c_dev->status = I2C_STAT_INIT;
 	i2c_dev->msg = pmsg;
@@ -106,9 +107,14 @@ static int xfer_read(struct i2c_adapter *adap, struct i2c_msg *pmsg)
 	HDMI_WRITE(HDMI_HI2CHCR, temp);
 	HDMI_READ(HDMI_HI2CHCR);
 
-	while (i2c_dev->status != I2C_TRANSACTION_DONE)
-		wait_for_completion_interruptible_timeout(&i2c_dev->complete,
+	while (i2c_dev->status != I2C_TRANSACTION_DONE) {
+		ret = wait_for_completion_interruptible_timeout(&i2c_dev->complete,
 								10 * HZ);
+		if (ret < 0)
+			return ret;
+		if (!ret)
+			return -ETIMEDOUT;
+	}
 
 	return 0;
 }
@@ -127,7 +133,7 @@ static int oaktrail_hdmi_i2c_access(struct i2c_adapter *adap,
 {
 	struct oaktrail_hdmi_dev *hdmi_dev = i2c_get_adapdata(adap);
 	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
-	int i;
+	int i, ret = 0;
 
 	mutex_lock(&i2c_dev->i2c_lock);
 
@@ -139,9 +145,11 @@ static int oaktrail_hdmi_i2c_access(struct i2c_adapter *adap,
 	for (i = 0; i < num; i++) {
 		if (pmsg->len && pmsg->buf) {
 			if (pmsg->flags & I2C_M_RD)
-				xfer_read(adap, pmsg);
+				ret = xfer_read(adap, pmsg);
 			else
-				xfer_write(adap, pmsg);
+				ret = xfer_write(adap, pmsg);
+			if (ret)
+				break;
 		}
 		pmsg++;         /* next message */
 	}
@@ -151,6 +159,9 @@ static int oaktrail_hdmi_i2c_access(struct i2c_adapter *adap,
 
 	mutex_unlock(&i2c_dev->i2c_lock);
 
+	if (ret)
+		return ret;
+
 	return i;
 }
 
-- 
2.53.0

