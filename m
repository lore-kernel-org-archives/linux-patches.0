Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063884D3BFA;
	Mon, 19 Oct 2026 14:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418531; cv=none; b=iHCPOxXKfBKCQAK/fJKqHBBCI2MVzWe98tuYnWPHhvlG6HMb6ay9i7PO8AlyuU7OJZLt4R/p4dWO8m6YlQEBZTr7njqOjIaAJhOogIy5fgRQneMZYhA0IGvlztVZ1K5h4iC0KJs7ake88Z9iC638iBJGPvuAFpYoY/R4aY56ZbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418531; c=relaxed/simple;
	bh=NO7TGgVGK+8WDxM5XhR+w5dgYZ9JOQpwkb5nfHhQsj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ad+Ky4xUrn0IQDhzp8gzqnb5DeMTpT9r9CITAnmbXcsTDmlXoN1D8li2OowFBzdr4LKY07t32OcJppVQGSbv/pDr6QnZZG5wJ6NE4MeJIcNhhGhB8wZdE66WPN6N4jSYE5t471lRFCW+lNvT7J1qDfN7wyr9H6vsHLdXlm4SPME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9ra/ums; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9ra/ums"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14281F000C6;
	Mon, 19 Oct 2026 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418528;
	bh=CMetwy4v9ql40qjUNT3o1j9UoheoA3hKCOVNzBdDtuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9ra/umseBq3MedA89OeRnKzeJzaU87gEFHqPxhwyc/pNdEHgj8SMG08skKWAScM7
	 BpPTsc9906WfUExxALMxVxV2YOd0iiVkRv4tg61b7QXQFmTNbA8u7qTh+LRTwGqTPI
	 MLMYxVBjhuWXcWh8XIlWYYhskR9+lKyu6CmILeB+IaVOYyodv52DG4xGCZuU6yUPRI
	 OSkxSMJ9KOXxBq1jNSzS0gKSLA/xKGRGjKhLqUrKJBQWMepAEZiMDmxBT+DlbgsDx/
	 X6FLx7rYHxKMbO/Di8kxrqwTmB+0zJzZUkblS9/UKbhNYyYAk3V9lSAT/LIhFEyCGB
	 1MlBBmPx3P27w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	mchehab@kernel.org,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-media@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: cec: stm32: return an error when log-address wait times out
Date: Mon, 19 Oct 2026 09:50:03 -0400
Message-ID: <20261019135441.1420968-312-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3bc2e4a26465386332ee1a40219d8dafba335b0b ]

stm32_cec_adap_log_addr() waits for TXSOM to clear before disabling CEC
and updating the logical address registers. The wait result is ignored,
so a timeout can still be reported as a successful logical address
update.

Return the polling error before touching the address registers. Compute
the address mask only for valid logical addresses so the invalid-address
path does not evaluate a shift based on CEC_LOG_ADDR_INVALID.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb`, branch
`autosel`). The verdict is only for this checkout: the STM32 CEC
timeout/shift bugs are present at `v6.18.53`, and the patch applies
cleanly.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[media/cec/stm32] [return] return an error when log-address
wait times out`

Subsystem prefix `media: cec: stm32`. Verb `return` is error-propagation
language (equivalent to “handle/fix”). Intent: stop treating a timed-out
TXSOM wait as a successful logical-address update.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>` (CEC
  framework maintainer; also the committer of upstream `3bc2e4a26465`)
- Ignored pipeline tags: `[Upstream commit
  3bc2e4a26465386332ee1a40219d8dafba335b0b]`, `Signed-off-by: Sasha
  Levin`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable` (absence expected for this review)

Notable: maintainer SOB, no syzbot/user report.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `stm32_cec_adap_log_addr()` polls for TXSOM to clear, then
  ignores the poll result and still disables CEC, writes OAR, re-enables
  CEC, and returns 0.
- **Symptom:** userspace/CEC core can be told a logical address was
  programmed when the wait timed out and the registers may not have been
  updated safely.
- **Second issue:** address mask `(1 << logical_addr) << 16` is computed
  before the `CEC_LOG_ADDR_INVALID` check, so the invalid-address path
  still evaluates a shift of `0xff`.
- **Root cause:** missing return-value check; mask computed too early.
- **Version info:** none in the message. Poll wait was added in 2019
  (`1a726df6078c2f`, v5.2-rc1).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not disguised. It is an explicit error-path and UB fix (“return
the polling error”, “does not evaluate a shift”).

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/media/cec/platform/stm32/stm32-cec.c` — **+11 / −5**
  (16 lines in one function)
- Function: `stm32_cec_adap_log_addr()` only
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (verified against `v6.18.53` and the candidate diff):

**Before** (at `v6.18.53`):
```c
u32 oar = (1 << logical_addr) << 16;
regmap_read_poll_timeout(...);  /* return value discarded */
regmap_update_bits(..., CECEN, 0);
if (logical_addr == CEC_LOG_ADDR_INVALID)
    clear OAR;
else
    set oar bits;
re-enable CECEN;
return 0;
```

**After:**
- Capture poll result; if nonzero, return it immediately (no CFGR
  write).
- Compute `BIT(logical_addr) << 16` only in the valid-address branch.

Affected path: CEC logical-address claim and unconfigure
(`adap_log_addr`), not probe/IRQ hot path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **(a) Error path:** ignored `regmap_read_poll_timeout()` result.
  Typical returns: `-ETIMEDOUT` or `-EFAULT`.
- **(g) Logic/correctness:** false success (`return 0`) after a failed
  wait.
- **(f/UBSAN):** `(1 << logical_addr)` with `logical_addr ==
  CEC_LOG_ADDR_INVALID` (`0xff` in `include/uapi/linux/cec.h`) is an
  oversized shift (UB). Result is unused on that branch, but the
  expression is always evaluated first.

Hardware context (from `1a726df6078c2f`): CFGR/OAR must be written only
with CECEN=0, after TXSOM clears. On timeout the old code still toggled
CECEN and wrote CFGR.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: check the value the wait already returned; don’t
  shift `0xff`.
- Minimal; `1 <<` → `BIT()` is local to the valid-LA branch (`BIT` comes
  from `linux/kernel.h` → `bitops.h` → `vdso/bits.h`, already included).
- Regression risk: low. On timeout, `cec_config_log_addr()` already does
  `if (err) return err`. On unconfigure, `cec_adap_unconfigure()` does
  `WARN_ON(call_op(..., CEC_LOG_ADDR_INVALID))`, so a stuck TXSOM can
  now warn instead of silently returning 0. That is the existing core
  contract for a failed clear, not a new API. Timeout budget is
  `CEC_XFER_TIMEOUT_MS` = 2100 ms, so this is a stuck-TX path, not a
  normal claim.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Function and `return 0` / CECEN/OAR writes: `d69ae57453c80a` (“[media]
  cec: add STM32 cec driver”, 2017) — first in **v4.13-rc1**.
- Poll without checking the result: `1a726df6078c2f` (“media: platform:
  stm32: wait end of transmission”, 2019) — first in **v5.2-rc1**.
- Buggy pattern has been in this line of kernels for years, including
  6.18.y.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Buggy poll commit `1a726df6078c2f` **is** an
ancestor of HEAD and of `v6.18.53`. Intermediate related work on this
file: `0c260d3f97e52` (RX overflow OOB) is a separate bug, not a
prerequisite.

**Step 3.3: CHECK FILE HISTORY**

Record: Recent file commits are cleanup/moves plus the RX OOB fix. This
is standalone, not “patch X/Y”. No later follow-up on this function
after the candidate.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Pengpeng Hou is not the CEC maintainer. In this tree, the other
hit under `drivers/media/cec/` is unrelated (`tegra`
MODULE_DEVICE_TABLE). Weight comes from **Hans Verkuil** (CEC FRAMEWORK
maintainer in `MAINTAINERS`) signing off and committing upstream.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**

Record: None. Uses existing `regmap_read_poll_timeout`, `BIT()`,
`CEC_LOG_ADDR_INVALID`. Can apply standalone. Confirmed `1a726df6078c2f`
and `d69ae57453c80a` are in `v6.18.53`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 3bc2e4a26465` →
  https://patch.msgid.link/20260624144015.63929-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only**, 2026-06-24, no later revisions
- lore.kernel.org fetches returned 403; discussion recovered from
  LKML/Openwall/Patchew mirrors. Patch body matches the commit. No
  replies on those archives.
- No reviewer NAK found. Hans Verkuil applied it (CommitDate Mon Jun 29
  2026).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc included Hans Verkuil, Mauro Chehab, Maxime
Coquelin, Alexandre Torgue, `linux-media`, `linux-stm32`, `linux-arm-
kernel`, `lkml`. Right maintainers were on the submission. No extra
Reviewed-by in the committed message.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No `Reported-by` / bugzilla / syzbot. Static/code-correctness
fix, not a user crash report.

**Step 4.4: RELATED PATCHES AND SERIES**

Record: Standalone `[PATCH]`, not a series. Sibling STM32 change
`0c260d3f97e52` is a different RX OOB bug and already has `Cc: stable`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No usable stable-list hit for this subject (lore/stable blocked
by anti-bot). UNVERIFIED that nobody previously rejected it for stable.
No evidence of a known NAK.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `stm32_cec_adap_log_addr` only. Registered as `.adap_log_addr`
in `stm32_cec_adap_ops`.

**Step 5.2: TRACE CALLERS**

Record (`call_op` in `drivers/media/cec/core/cec-priv.h`):
- `cec_config_log_addr()` in `cec-adap.c` — claim path; error is
  returned to the config thread.
- `cec_adap_unconfigure()` — `WARN_ON(call_op(...,
  CEC_LOG_ADDR_INVALID))`; then core still marks the adapter
  unconfigured.

Called with `adap->lock` held from the CEC kthread / ioctl configuration
path, not IRQ context.

**Step 5.3: TRACE CALLEES**

Record: `regmap_read_poll_timeout`, `regmap_update_bits`. Sleeps up to
~2.1 s. No alloc/new locks.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace CEC ioctls (`CEC_ADAP_S_LOG_ADDRS` / adapter enable-
disable) → CEC core → `adap_log_addr`. Reachable on STM32 HDMI CEC
(`CONFIG_CEC_STM32`, `st,stm32-cec`) without extra privilege beyond
access to the CEC device node. Not a generic syscall bug on x86.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Other platform CEC drivers (tegra, meson) check
`CEC_LOG_ADDR_INVALID` before building a shift mask. Tegra still uses `1
<< logical_addr` only in the else branch. This STM32 driver was the one
evaluating the shift first.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes**, at `v6.18.53` in `stm32_cec_adap_log_addr()`.
Introduced 2017 (shift) / 2019 (ignored poll). Upstream fix
`3bc2e4a26465` is **not** an ancestor of HEAD (expected: it is a later
mainline commit being evaluated). The autosel cherry-pick
`a1157fd7d1e0f` is already on this branch; that is ignored as selection
evidence.

**Step 6.2: BACKPORT COMPLICATIONS**

Record: **Clean apply.** Surrounding function at `v6.18.53` matches the
pre-image exactly. No refactor of this callback on 6.18.y.

**Step 6.3: RELATED FIXES ALREADY HERE**

Record: No earlier timeout-return or shift-guard on this function. RX
OOB fix is independent.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: `drivers/media/cec/platform/stm32/` — STM32 HDMI CEC.
**PERIPHERAL** (SoC HDMI-CEC), but a supported in-tree driver (`CEC
FRAMEWORK` is Supported; Kconfig `CEC_STM32` depends on `ARCH_STM32 ||
COMPILE_TEST`).

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: File is mature (2017), low churn aside from tree-wide media
cleanups and the recent RX OOB fix. This is an old bug, not a regression
in brand-new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: Driver-specific / config-specific: STM32 boards with HDMI CEC
(`st,stm32-cec`). Not universal.

**Step 8.2: TRIGGER CONDITIONS**

Record:
- **Timeout bug:** TXSOM stuck for >2.1 s while claiming or clearing a
  LA. Uncommon, but that is exactly the failure the 2019 wait was meant
  to cover. Unprivileged users with CEC device access can hit the claim
  path.
- **Shift UB:** every unconfigure (`CEC_LOG_ADDR_INVALID` = 0xff), a
  normal path when disabling/reconfiguring CEC.

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- False-success LA update + CFGR write while TXSOM still set: CEC
  misconfiguration / possible controller or bus glitch. **MEDIUM**
  (functional/hardware-constraint), not a kernel oops.
- Shift UB on unconfigure: UBSAN-class undefined behavior; result unused
  on that branch, so not a typical oops. **MEDIUM**.

Not panic/UAF/corruption in the usual sense. Still a real correctness
bug on a user-reachable path.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** medium for STM32 CEC users — honest errors, no forbidden
  CFGR write after timeout, no `1 << 0xff`.
- **Risk:** very low — ~16 lines, one function, no API/locking/data-
  structure change.
- Ratio: favorable. The new `WARN_ON` on unconfigure-timeout is the main
  behavioral change and only fires if the wait already failed.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**FOR:**
- Real bugs: ignored poll error → false success and a CFGR write the
  driver itself documented as illegal during TX; UB shift of `0xff` on
  unconfigure.
- Small, obviously correct, maintainer-acked (Hans Verkuil).
- Buggy code exists in this 6.18.y tree; applies cleanly; no
  prerequisites.
- Matches stable error-handling / UBSAN-shift patterns.

**AGAINST:**
- Peripheral STM32 HDMI CEC, not a core path.
- No user/syzbot report; timeout is rare.
- Failure is not a documented oops/CVE/deadlock.
- Unconfigure timeout can now `WARN_ON` (honest, but user-visible in
  dmesg).

**UNRESOLVED:**
- Full lore thread (403); no public review comments beyond maintainer
  application.
- Stable-list history not searchable here.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — check existing return;
   maintainer merged it.
2. Fixes a real bug that affects users? **PASS** — false success and
   hardware-forbidden write; UB on unconfigure.
3. Important issue? **PASS** (medium) — not a panic, but incomplete
   timeout handling plus UBSAN-class shift on a normal unconfigure path.
   Driver fixes of this size are in-scope.
4. Small and contained? **PASS** — one function, +11/−5.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — pre-image matches `v6.18.53`.

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk, DT, build, or docs-only change).
Qualifies as a normal small bugfix.

**Step 9.4: DECISION**

Backport. The bugs exist in this 6.18 tree, the patch is surgical, and
the risk is far smaller than leaving a wait whose result is discarded
and a `1 << 0xff` on every unconfigure.

---

### What the commit solves for this tree

On 6.18.53, `stm32_cec_adap_log_addr()` waits for TXSOM then always
programs OAR and returns success. After a 2.1 s timeout that still
writes CFGR, which the 2019 change said must not happen during transmit,
and reports a successful LA update. Separately, unconfigure always
evaluates `(1 << 0xff) << 16` before the invalid-address check. The
patch returns the poll error first and only builds the mask for valid
LAs.

### Risk vs benefit

Benefit is correct CEC address programming and avoidance of a hardware-
illegal register update and a shift UB. Risk is a few lines in one STM32
CEC callback; the only extra symptom is `WARN_ON` if unconfigure hits a
stuck TXSOM.

---

### Verification

- **[Phase 1]** Parsed subject/tags from `git log -1` / `git show` of
  `a1157fd7d1e0f` and upstream `3bc2e4a26465`. No Fixes/Reported-by.
  Hans Verkuil SOB + committer.
- **[Phase 2]** Diff: +11/−5 in `stm32_cec_adap_log_addr`. Pre-image
  confirmed via `git show
  v6.18.53:drivers/media/cec/platform/stm32/stm32-cec.c`.
  `CEC_LOG_ADDR_INVALID` is `0xff`.
- **[Phase 3]** `git blame` on the function: `d69ae57453c80a` (v4.13),
  poll `1a726df6078c2f` (v5.2). `git merge-base --is-ancestor` of both
  vs `v6.18.53` and HEAD: present. No `Fixes:` tag. No follow-ups after
  the candidate on this file.
- **[Phase 3]** `git merge-base --is-ancestor 3bc2e4a26465 HEAD` → not
  in this branch (mainline-only). Local cherry-pick is on autosel;
  ignored as selection evidence.
- **[Phase 4]** `b4 dig -c/-a/-w`: v1-only, msgid
  `20260624144015.63929-1-pengpeng@iscas.ac.cn`, correct maintainers
  CCed. lore.kernel.org 403; LKML/Openwall/Patchew matched the committed
  diff; no NAK found.
- **[Phase 4]** Stable-list search unusable (anti-bot). UNVERIFIED:
  prior stable discussion.
- **[Phase 5]** Callers: `cec_config_log_addr`, `cec_adap_unconfigure`
  in `cec-adap.c`. `call_op` in `cec-priv.h`. Kconfig `CEC_STM32`.
- **[Phase 6]** `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
  `make kernelversion` → 6.18.53. Buggy code at v6.18.53. Clean pre-
  image.
- **[Phase 7]** Peripheral STM32 CEC; maintainer Hans Verkuil.
- **[Phase 8]** Failure: false success + illegal CFGR write (MEDIUM);
  shift UB on unconfigure (MEDIUM). Risk very low.
- **UNVERIFIED:** live review comments on lore (403); whether UBSAN has
  actually fired on this shift in the field.

**YES**

 drivers/media/cec/platform/stm32/stm32-cec.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/cec/platform/stm32/stm32-cec.c b/drivers/media/cec/platform/stm32/stm32-cec.c
index 8c2fc232202de..29418966a98ef 100644
--- a/drivers/media/cec/platform/stm32/stm32-cec.c
+++ b/drivers/media/cec/platform/stm32/stm32-cec.c
@@ -194,18 +194,24 @@ static int stm32_cec_adap_enable(struct cec_adapter *adap, bool enable)
 static int stm32_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
 {
 	struct stm32_cec *cec = adap->priv;
-	u32 oar = (1 << logical_addr) << 16;
 	u32 val;
+	int ret;
 
 	/* Poll every 100µs the register CEC_CR to wait end of transmission */
-	regmap_read_poll_timeout(cec->regmap, CEC_CR, val, !(val & TXSOM),
-				 100, CEC_XFER_TIMEOUT_MS * 1000);
+	ret = regmap_read_poll_timeout(cec->regmap, CEC_CR, val, !(val & TXSOM),
+				       100, CEC_XFER_TIMEOUT_MS * 1000);
+	if (ret)
+		return ret;
+
 	regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
 
-	if (logical_addr == CEC_LOG_ADDR_INVALID)
+	if (logical_addr == CEC_LOG_ADDR_INVALID) {
 		regmap_update_bits(cec->regmap, CEC_CFGR, OAR, 0);
-	else
+	} else {
+		u32 oar = BIT(logical_addr) << 16;
+
 		regmap_update_bits(cec->regmap, CEC_CFGR, oar, oar);
+	}
 
 	regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
 
-- 
2.53.0

