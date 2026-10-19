Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6555810E7;
	Mon, 19 Oct 2026 13:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418325; cv=none; b=e/F9aWPOMSKTEXr1CMEQ9HbN/CuHz+TBxmGPHnKP65zNfkmfViR0SZoio4LdX8bFqik/JlrqfnPpL6UfwmXyeV7pdEyV1ihjBsneFeTHONsI+VkdnYLcdTlW+ftm5QfOKmYDj/uf2F4TkSayhF0/xMwS2qSJviFF5s62sE4wWUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418325; c=relaxed/simple;
	bh=0/+oTq/iPFd4Dx56ED+kSetpVtEOv78MVIXbnFkc8HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s07MncBYvcUrdXu6GJySyT+pTOuNwtHHjhHYpi+1S7LTL5pyWB9bjRxVjDOx/+d+Sh9aZ/x8NtWEiGYMlhfeWoKlilGJ96F8mgCJawSSPJVjTd6FKuRo/iZzbEVGDzCQCQBeXcDnsyFM2jZ+slnsHThsQvFtVjcEFu5DjshWMss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gA39CcNJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gA39CcNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA3D1F000C7;
	Mon, 19 Oct 2026 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418322;
	bh=dENmD698szZzBSZbOBfmILBFw0Baf/1rZwQeB805f4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gA39CcNJKhHgq7B59R2mfa5+NRFWq4whIH8Gtzo8fJwksfYAP3/FKwXQgBkstbElS
	 mtEE9PDQ2LNE15+n7/iESZU6Ccq/FGTsZZzIJdDu19NzmGQlXkMQNOuGn61lM1tRkp
	 L7X1Vjb5VYcobQv5Uur3hJH36oyyc+HO+kcrmaUdRhEbJQacQ+wZUNXn3lCtH6ZtJt
	 cQuFxVr/uBCDSTEKUjLsFh47QnsT3qwQvY0w1uh93gSTrJi5ybo6pDv/bkNCbF/zZd
	 d9icni/n6S0l68gOi5ctalm/2tq2BT9wCeEyHdbJOtmjTaBFKDyNmxs1OI2Bu4PMkl
	 83zrrI8Aeoz0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bryam Vargas <hexlabsecurity@proton.me>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] iio: accel: fxls8962af: clamp the device-reported FIFO sample count
Date: Mon, 19 Oct 2026 09:47:36 -0400
Message-ID: <20261019135441.1420968-165-sashal@kernel.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 2f8225b91eb478ca2e9aec8aaef4d229765bcebe ]

fxls8962af_fifo_flush() transfers the sample count the device reports in
BUF_STATUS into an on-stack buffer sized for FXLS8962AF_FIFO_LENGTH (32)
samples, but the count is a 6-bit field (0..63) that is only checked for
zero. A device, or an attacker on the I2C/SPI bus, reporting 33..63
overflows the buffer by up to 186 bytes: a stack out-of-bounds write.

Clamp the count to FXLS8962AF_FIFO_LENGTH before the transfer, mirroring
the clamp already applied in fxls8962af_set_watermark(). Conforming
hardware reports at most that many samples and is unaffected.

Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. The FIFO clamp is not in `v6.18.53`; the
32-sample stack buffer and 6-bit `BUF_CNT` path have been here since
v5.14. That is a real stack out-of-bounds write, so this is a YES on
technical merit.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[iio/accel/fxls8962af] [clamp] [bound device-reported FIFO
sample count before stack transfer]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Reviewed-by:** Andy Shevchenko `<andriy.shevchenko@intel.com>`
- **Signed-off-by:** Bryam Vargas `<hexlabsecurity@proton.me>` (author)
- **Signed-off-by:** Jonathan Cameron `<jic23@kernel.org>` (IIO
  maintainer)
- No **Fixes:**, **Cc: stable**, **Reported-by**, **Tested-by**, or
  **Link:** on the committed message (v1 had Fixes/Cc: stable; they were
  dropped after review)
- Ignore pipeline markers: `[ Upstream commit
  2f8225b91eb478ca2e9aec8aaef4d229765bcebe ]`, Sasha Levin SOB

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `fxls8962af_fifo_flush()` copies `BUF_STATUS` `BUF_CNT`
  (GENMASK(5,0), 0..63) into `u16 buffer[FXLS8962AF_FIFO_LENGTH * 3]`
  (32 samples). Count is only checked for zero.
- **Symptom:** stack out-of-bounds write of up to 186 bytes (63×6=378
  into 192-byte buffer), canary/return-address smash.
- **Root cause:** driver trusts a 6-bit device field against a 32-deep
  FIFO buffer. Watermark path already clamps; flush path does not.
- **Version:** unbounded since `79e3a5bdd9ef` (“add hw buffered
  sampling”), 2021.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is a bounds-check / memory-safety fix. Review
treated it as hardening against malformed device reports rather than a
conforming-hardware bug.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/iio/accel/fxls8962af-core.c` (+2 / −0)
- Function: `fxls8962af_fifo_flush()`
- Scope: single-file, two-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: After `count = reg & FXLS8962AF_BUF_STATUS_BUF_CNT` and the `if
(!count) return 0` check, add `count = min(count,
FXLS8962AF_FIFO_LENGTH)` before timestamp math and
`fxls8962af_fifo_transfer(data, buffer, count)`. Normal path with count
≤ 32 is unchanged. Path with count 33..63 is capped at 32 instead of
overflowing the stack buffer.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Buffer overflow / out-of-bounds write.** Device-reported
length used as transfer size without clamping to the on-stack array. Fix
is a bounds clamp (memory-safety / hardware-value validation).

Verified math:
- `u16 buffer[32 * 3]` → 192 bytes
- `fxls8962af_fifo_transfer()` reads `count * 3 * sizeof(u16)` = `count
  * 6` bytes
- count=32 → 192 (fits); count=33 → 198 (6 past); count=63 → 378 (**186
  past**), matching the message

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. `min()` is valid here: `count` is
`u8`, `FXLS8962AF_FIFO_LENGTH` is 32; this tree’s `minmax.h` promotes
unsigned char to signed int. Regression risk is very low: conforming
devices report ≤32. Clamping a wild count to 32 can leave unread FIFO
data rather than crashing; that is safer than a stack smash. Maintainer
later preferred `dev_err` + abort over a silent clamp, but the clamp
still prevents the overflow.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: FIFO flush, stack buffer, and unclamped `BUF_CNT` came from
**`79e3a5bdd9ef`** (Sean Nyekjaer, 2021-05-17), “iio: accel: fxls8962af:
add hw buffered sampling”. First appeared around **v5.14**. Long-lived
in this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes tag on the committed version. v1 tagged `79e3a5bdd9ef`.
That commit **is** an ancestor of HEAD and of `v6.18.53`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related: `1fe16dc1a2f50` (“Fix use after free in
fxls8962af_fifo_flush”, CVE-2025-38485) — `synchronize_irq()` on
predisable, **already in v6.18.53**. Different bug; does not bound FIFO
count. Sibling **`3e766526827ac`** (bmc150 FIFO clamp) **is already in
v6.18.53** with `Cc: stable`. This patch is standalone, not patch N/M.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Bryam Vargas is not the IIO maintainer. Same author submitted
the bmc150 clamp (already in this tree). Driver author/regular is Sean
Nyekjaer (CC’d). Applied by Jonathan Cameron.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `min()`, `FXLS8962AF_FIFO_LENGTH`, and
`fxls8962af_fifo_flush()`. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **v1:** https://lore.kernel.org/all/20260613-b4-disp-22362900-v1-1-
  c5e49f6af027@proton.me/ (had Fixes + Cc: stable, used `min_t(u8,
  ...)`)
- **v2:** https://lore.kernel.org/all/20260615-b4-disp-1a8c7886-v2-1-
  0f0a2c48d840@proton.me/
- **v3 (applied):** https://lore.kernel.org/all/20260616-b4-disp-
  2e8d94cf-v3-1-c4e092eef3a2@proton.me/
- Jonathan on v1: *“This is hardening against broken devices. Nice to
  have, but not a fix and not back port material.”* Also asked for
  `min()` instead of `min_t`.
- Andy: shrink the AI-heavy commit message.
- Author dropped Fixes/Cc: stable for v2/v3. Andy **Reviewed-by** on v3.
  Jonathan applied to iio.git testing.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc included Jonathan Cameron (maintainer), Andy Shevchenko,
David Lechner, Nuno Sá, Sean Nyekjaer, linux-iio, linux-kernel.
Maintainer applied it; Andy reviewed it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/user crash. Author reproduced with a
KASAN_STACK litmus (count=36 → write of size 216 past the 192-byte
buffer) and a userspace ASan model (count=63). Not a field report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Parallel bmc150 clamp (`ce0e1cae2609` / `3e766526827ac` in this
tree) with Fixes + Cc: stable. Same author, same week. Jonathan agreed
with that analysis and only nitted `min()` vs `min_t`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Duplicate sent to stable@ in Aug 2026 (Shengzhuo Wei). Jonathan:
not a fix, don’t hide it by clamping. After learning Bryam’s patch was
already in mainline: *“Oops… didn’t think of it in the same way… not
worth more churn for something we don’t really expect to see in
practice.”* He did not NAK backporting Bryam’s already-merged clamp; he
rejected the duplicate and a follow-up rework.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `fxls8962af_fifo_flush()`; helper `fxls8962af_fifo_transfer()`.

**Step 5.2: TRACE CALLERS**
Record: Only caller is `fxls8962af_interrupt()` when
`FXLS8962AF_INT_STATUS_SRC_BUF` is set. IRQ is a threaded oneshot
handler (`devm_request_threaded_irq(..., NULL, fxls8962af_interrupt,
...)`). Runs when the IIO buffer is enabled and the device signals
FIFO/watermark.

**Step 5.3: TRACE CALLEES**
Record: `regmap_read` (`BUF_STATUS`), `iio_get_time_ns`,
`fxls8962af_fifo_transfer` → `regmap_raw_read` (or I2C errata-3 per-
sample reads), then `iio_push_to_buffers_with_ts`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace enables the IIO buffer → hardware FIFO IRQ → flush.
Not a syscall that feeds the count; the count comes from the device over
I2C/SPI. Unprivileged userspace cannot set `BUF_CNT` without controlling
the bus or the part.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same bug/fix in bmc150 (`__bmc150_accel_fifo_flush`). Watermark
path already clamps to `FXLS8962AF_FIFO_LENGTH`. `BUF_CNT` is only
consumed here.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
`make kernelversion` → **6.18.53**.
`v6.18.53:drivers/iio/accel/fxls8962af-core.c` has the 32-sample stack
buffer and unclamped `BUF_CNT`. `git merge-base --is-ancestor
e25456b3011d9 v6.18.53` is false (candidate only on autosel). Introduced
**v5.14** (`79e3a5bdd9ef`). Driver configs: `FXLS8962AF_I2C` /
`FXLS8962AF_SPI`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** `git diff v6.18.53 e25456b3011d9^ --
drivers/iio/accel/fxls8962af-core.c` is empty. Dry-run of the two-line
hunk against the v6.18.53 file succeeded.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: UAF/CVE-2025-38485 fix is in v6.18.53; it does not clamp count.
No earlier FIFO-count clamp. bmc150 analog **is** in v6.18.53.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **IIO accelerometer driver** (`drivers/iio/accel/`).
**PERIPHERAL / IMPORTANT for users of this NXP automotive accel**
(FXLS8962AF/64/67/8974). Not core mm/net/fs.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Mature driver (2021) with ongoing IIO-wide and device-specific
fixes. FIFO flush logic is stable, not newly introduced in 6.18.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific / config-specific** (`CONFIG_FXLS8962AF_I2C`
or `_SPI`), when the IIO buffer is on.

**Step 8.2: TRIGGER CONDITIONS**
Record: FIFO IRQ with `BUF_CNT` in 33..63 and `BUF_OVF` clear.
Conforming silicon: FIFO depth 32; overflow sets `BUF_OVF` and the
driver returns `-EOVERFLOW` without transferring. Trigger needs a
bad/malicious/counterfeit part, bus tampering, or a corrupted
`BUF_STATUS` read (e.g. I2C bit error on bit 5, which adds 32 to a 1..31
count without setting OVF). Not reachable from syscalls alone. No field
reports.

**Step 8.3: FAILURE MODE SEVERITY**
Record: **Stack out-of-bounds write** (up to 186 bytes) in IRQ-thread
context → canary smash, oops, or worse. **Severity: HIGH** (CRITICAL if
the bus is treated as adversarial). Conforming hardware: not hit.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** stops a kernel stack smash on a wild FIFO count. Same
  class already shipped in this 6.18.53 tree for bmc150.
- **Risk:** very low (2 lines, `min()`, no API/locking/structure change;
  good devices unchanged).
- **Ratio:** high benefit/risk for a memory-safety clamp. Maintainer
  preference for “error out instead of clamp” is a design nit, not a
  regression.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real stack OOB: 6-bit count vs 32-sample stack buffer, overflow math
  verified (186 bytes).
- Bug exists in **this** 6.18.53 tree; driver since v5.14.
- Two-line, obviously correct clamp; `min()` is type-safe here.
- Applies cleanly; no prerequisites.
- KASAN_STACK reproduction of the overflow.
- Reviewed by Andy Shevchenko; applied by IIO maintainer.
- Identical bmc150 clamp already in v6.18.53.
- IRQ-time path, not dead init code.

AGAINST:
- Jonathan: hardening, *“not a fix and not back port material.”* Author
  dropped Cc: stable for that reason.
- No user/syzbot reports; needs non-conforming `BUF_CNT` (OVF already
  bails out on overflow).
- Later stable@ thread: prefer logging/error over silent clamp; “don’t
  expect this in practice.”

UNRESOLVED:
- No datasheet fetch here beyond driver comments
  (`FXLS8962AF_FIFO_LENGTH` 32, `BUF_CNT` GENMASK(5,0)). Driver and
  review agree on those numbers.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 2-line `min()`; KASAN
   litmus; W=1 clean; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — driver uses an
   unvalidated 6-bit length as a 32-slot stack transfer size. That is a
   real memory-safety defect; analog already backported for bmc150 on
   this tree.
3. Important issue? **PASS** — stack smash / OOB write (HIGH). Not a
   userspace-only theoretical race; it is a missing bounds check on a
   device-supplied length.
4. Small and contained? **PASS** — +2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — v6.18.53 file matches pre-
   image; dry-run succeeded.

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary memory-
safety bounds check.

**Step 9.4: DECISION**
The IIO maintainer did not want this treated as a stable bug because
conforming parts should never report >32 without `BUF_OVF`. That is why
Cc: stable was dropped; that absence is not a reason to reject it. In
this 6.18.53 tree the buggy flush is present, the fix is two lines, and
the same pattern was already taken for bmc150. A wild `BUF_CNT` still
produces a kernel stack overflow. That is enough technical merit to
backport.

Verification:
- [Phase 1] Parsed subject/tags/body from `git log -1 e25456b3011d9` and
  the user-supplied message; Fixes/Cc: stable dropped after v1 review
- [Phase 2] Read `fxls8962af_fifo_flush` / `fxls8962af_fifo_transfer`;
  confirmed 192-byte buffer, `count * 6` transfer, 186-byte max overflow
- [Phase 2] Confirmed `min(u8, 32)` is valid in this tree’s
  `include/linux/minmax.h`
- [Phase 3] `git blame`: buggy FIFO flush from `79e3a5bdd9ef` (2021);
  `git merge-base --is-ancestor 79e3a5bdd9ef HEAD` true
- [Phase 3] UAF fix `1fe16dc1a2f50` is in v6.18.53; does not clamp count
- [Phase 3] bmc150 clamp `3e766526827ac` is in v6.18.53 with Cc: stable
- [Phase 4] `b4 dig -c 2f8225b91eb478ca2e9aec8aaef4d229765bcebe` → v2/v3
  lore; `-a` showed v3 applied; `-w` listed IIO maintainers
- [Phase 4] Fetched Jonathan v1 review: “not a fix and not back port
  material”
- [Phase 4] Fetched v3 apply mail and Andy Reviewed-by
- [Phase 4] lore.kernel.org/stable search: Aug 2026 duplicate; Jonathan
  restated hardening stance, then dropped rework of Bryam’s already-
  merged clamp
- [Phase 5] Only caller: `fxls8962af_interrupt` on BUF status, threaded
  IRQ
- [Phase 6] `make kernelversion` / Makefile: 6.18.53; clamp **not** in
  `v6.18.53`; `git diff v6.18.53 e25456b3011d9^ -- fxls8962af-core.c`
  empty; patch dry-run against v6.18.53 file succeeded
- [Phase 7] Kconfig: FXLS8962AF I2C/SPI, automotive accelerometer
- [Phase 8] Failure mode: stack OOB write in IRQ thread, HIGH
- UNVERIFIED: live NXP datasheet fetch (FIFO=32 / BUF_CNT width taken
  from in-tree defines and review, which agree)

The patch is a two-line bounds clamp on a stack FIFO flush that exists
in this 6.18.53 tree. It prevents a kernel stack out-of-bounds write if
`BUF_CNT` is 33..63, applies cleanly, and matches a clamp already
present here for bmc150.

**YES**

 drivers/iio/accel/fxls8962af-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/fxls8962af-core.c b/drivers/iio/accel/fxls8962af-core.c
index 8763e91c63d2b..1ecffbf41f64f 100644
--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -970,6 +970,8 @@ static int fxls8962af_fifo_flush(struct iio_dev *indio_dev)
 	if (!count)
 		return 0;
 
+	count = min(count, FXLS8962AF_FIFO_LENGTH);
+
 	data->old_timestamp = data->timestamp;
 	data->timestamp = iio_get_time_ns(indio_dev);
 
-- 
2.53.0

