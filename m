Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512325E0E41;
	Mon, 19 Oct 2026 14:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418546; cv=none; b=mTIyZUmHlGP6g42rAcVtNzn32Cieq/BEHLT8wNjMOeQ3zSqL6esaqBbyNo2xuvchIUYfxNmWdH7oKCaU9fDHZdJOcNrCsF6OP7s73GlnkpJL4K0FNLbtLDcs8MlV/IpflQBwtK1j2JyCxY+Kep8UEV8wM5D54CPSUjBRpQG4rys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418546; c=relaxed/simple;
	bh=uVUBf5y86ozP98jwAO+Z6HEpVjq0Nyj+KC1UFavyYBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVKJys3HK/M6QCdR12aMxn8NOEG7rw2jhuLrd4rU98CSmLHekSDKp35TsogAm5CKFPHixNE6V8a1qrQK9Ov/xzWJVpNcsMJuayr5G9vCxRiAhG8JxMGiXVvn4/RKiprY4JT2zFBYiNNqm+lBFwHz2Zje2moSRRw3FaH/Q/I20Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eOnMEagv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eOnMEagv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C0E1F000C6;
	Mon, 19 Oct 2026 14:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418543;
	bh=0M7zuchmywfdUImy6+SRCax1nzOIJYIdgMIg780jPMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOnMEagviYDDhz5364wQ17abpwlgPx4BlqY++42N0gxLSBmPWqngRS4o4XU74+m7k
	 7ErmMALKeCqpj/ST1wNXLdQ+afF5V8f6LRGq21XGoTxFOyKsoWKl8VgNWRGg6+vCwj
	 ns2jadL87hx5vjRCUvR7JVcYqTkt/25N4fg2pZPuqAs+lfE4skeX2PWlfXLaPFAnkk
	 gYz6QemySRg1vKBKjAu6NM4sry1NA5BlZkRZxe4B2ZcQB/RaVRkvKtX3TPnkdcjxWb
	 /HPkBlc/nhhwCkw0qTVQdIEJ5QQy7Ti60FnUX+yzq7icBdnCHC+oXhVk4Dzv8hK/g0
	 XI7aB8lew/fUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li Jun <lijun01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zhuyinbo@loongson.cn,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] spi: loongson: pm: add .freeze .poweroff .thaw .restore
Date: Mon, 19 Oct 2026 09:50:14 -0400
Message-ID: <20261019135441.1420968-323-sashal@kernel.org>
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

From: Li Jun <lijun01@kylinos.cn>

[ Upstream commit a9c2f0d401fd1e11ce59e4243946a59bd818e8c5 ]

after execute s4, the spi error,
[ 1104.754246][ 4] [    T1] tpm_tis_spi spi-SMO0768:00: SPI transfer failed: -110
[ 1104.761503][ 4] [    T1] spi_master spi1: failed to transfer one message from queue
[ 1104.769201][ 4] [    T1] spi_master spi1: noqueue transfer failed
[ 1104.776344][ 4] [    T1] tpm_tis_spi spi-SMO0768:00: SPI transfer failed: -110
[ 1104.783609][ 4] [    T1] spi_master spi1: failed to transfer one message from queue
[ 1104.791308][ 4] [    T1] spi_master spi1: noqueue transfer failed
[ 1104.797446][ 4] [    T1] gttadd tpm_chip_start1 ret = -110
and in s4 the loongson_spi_resume&suspend are not
called at all. use DEFINE_SIMPLE_DEV_PM_OPS() add .freeze .poweroff
.thaw .restore, after s4 the spi communication is normal.

Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://patch.msgid.link/20260820092351.101605-1-lijun01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy PM ops are
present here; the candidate is not. The rest of the write-up is the full
nine-phase review for this tree only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[spi: loongson: pm] [add] [hibernation callbacks
.freeze/.poweroff/.thaw/.restore]**

The verb is “add”, but the body is a hibernation bug report (S4 SPI
timeout), not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none (author states it was tested after S4)
- **Reviewed-by:** none on the committed message
- **Acked-by:** none
- **Link:**
  https://patch.msgid.link/20260820092351.101605-1-lijun01@kylinos.cn
- **Cc: stable:** none (expected)
- **Signed-off-by:** Li Jun \<lijun01@kylinos.cn\> (author); Mark Brown
  \<broonie@kernel.org\> (SPI maintainer)
- **Ignored pipeline tags:** none present in the provided message beyond
  the usual evaluation context

Notable: SPI maintainer SOB; mailing-list Link; no syzbot.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** After S4 (hibernate), Loongson SPI transfers fail with **-110
  (`ETIMEDOUT`)**. `tpm_tis_spi` device `spi-SMO0768:00` cannot talk to
  the controller; `tpm_chip_start` returns -110.
- **Symptom:** SPI master `spi1` “failed to transfer one message from
  queue” / “noqueue transfer failed”.
- **Root cause (author):** `loongson_spi_suspend`/`loongson_spi_resume`
  are **not called at all during S4**, because only `.suspend`/`.resume`
  were registered.
- **Fix:** `DEFINE_SIMPLE_DEV_PM_OPS()` so the same save/restore path is
  also used for `.freeze`, `.poweroff`, `.thaw`, `.restore`.
- **Version info:** none in the message; dmesg is a real hibernate-
  resume failure.
- **Author test:** “after s4 the spi communication is normal.”

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** It is a real hibernation PM bug. “add …
callbacks” is the usual wording for filling missing `dev_pm_ops` slots;
it is not a new API or new driver.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/spi/spi-loongson-core.c`
- **Scope:** ~2 insertions, ~4 deletions (single struct rewrite)
- **Functions:** `loongson_spi_suspend` / `loongson_spi_resume`
  unchanged; only `loongson_spi_dev_pm_ops` definition changes
- **Classification:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `dev_pm_ops` has only `.suspend` and `.resume`. Kernel
  hibernation uses `.freeze`/`.thaw`/`.poweroff`/`.restore`
  (`include/linux/pm.h`). Those were NULL, so S4 never saved/restored
  SPI registers or called
  `spi_controller_suspend`/`spi_controller_resume`.
- **After:** `DEFINE_SIMPLE_DEV_PM_OPS` → `SYSTEM_SLEEP_PM_OPS`, which
  sets all six sleep callbacks to the existing suspend/resume pair via
  `pm_sleep_ptr()`.
- **Path affected:** system hibernation (S4) and poweroff-after-image.
  S3 still uses the same functions.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** logic/correctness in PM ops (missing hibernation
  callbacks); hardware state not restored after S4
- **Mechanism:** After hibernate, SPI controller registers are not
  rewritten (`SPCR`/`SPER`/`SPSR`/`PARA`/`SFCS`/`TIMI`). Transfers time
  out. TPM on that bus (`SMO0768`) fails.
- **Not** UAF/leak/race/overflow.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** Obviously correct. Same pattern as `SYSTEM_SLEEP_PM_OPS`
  / `SET_SYSTEM_SLEEP_PM_OPS` used across `drivers/spi/` (e.g. `spi-
  sifive.c`, `spi-bcm63xx.c`, many `SET_SYSTEM_SLEEP_PM_OPS` users).
- **Minimal:** no unrelated edits.
- **Regression risk:** Low. S3 still uses the same two functions.
  Hibernation now runs the save/restore that S3 already used.
  `RUNTIME_PM_OPS(NULL,NULL,NULL)` matches the old struct (no runtime
  PM).
- **Style note (not a blocker):** `include/linux/pm.h` prefers
  `EXPORT_NS_GPL_SIMPLE_DEV_PM_OPS` when the symbol is exported.
  Mainline kept `DEFINE_SIMPLE_DEV_PM_OPS` + existing
  `EXPORT_SYMBOL_NS_GPL`. Functionally equivalent on this tree: the
  macro is non-static `const struct dev_pm_ops`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy ops introduced in **`6c7a864007b66`** (“spi: loongson: add bus
  driver for the loongson spi controller”, Yinbo Zhu, 2023-06-13;
  committed 2023-07-31).
- **`git merge-base --is-ancestor 6c7a864007b66 HEAD`** succeeded.
- Present since **v6.6** (`v6.5` does not contain it; `v6.6` does).
  Unchanged since then (`git blame` on lines 232–276 is entirely that
  commit).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The introducing commit is the original driver,
and it **is** in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- `git log --oneline -- drivers/spi/spi-loongson-core.c` shows **only**
  `6c7a864007b66`.
- No later refactor of these PM ops in this tree.
- Standalone; subject is `[PATCH v3]`, not `X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record:
- Author Li Jun (Kylinos) has **no** other commits under `drivers/spi/`
  in this checkout.
- Original driver author is Yinbo Zhu (Loongson). Maintainer who applied
  the fix is Mark Brown.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs `DEFINE_SIMPLE_DEV_PM_OPS` — present at `include/linux/pm.h:418`
  in this tree.
- Needs existing `loongson_spi_suspend`/`loongson_spi_resume` — present.
- **Standalone.** No new helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **v1:** https://lore.kernel.org/linux-
  spi/20260818104241.850042-1-lijun01@kylinos.cn/ — manually added four
  callback pointers.
- **v2:** https://lore.kernel.org/linux-
  spi/20260819014552.1986077-1-lijun01@kylinos.cn/ —
  `SIMPLE_DEV_PM_OPS()` after review.
- **v3 (committed):** https://lore.kernel.org/linux-
  spi/20260820092351.101605-1-lijun01@kylinos.cn/ —
  `DEFINE_SIMPLE_DEV_PM_OPS()` (non-deprecated helper).
- **`b4 mbox -c`** on v3: no newer revision.
- **Reviewer:** Mark Brown on v1: “This could be done using
  SIMPLE_DEV_PM_OPS().” No NAK. He applied v3 to `broonie/spi.git
  for-7.3` (`a9c2f0d401fd`).
- No `Cc: stable` in review (not a negative signal).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record:
- **To/Cc:** Li Jun, Yinbo Zhu (original driver author), Mark Brown,
  linux-spi.
- SPI maintainer reviewed and applied. Original driver author was CCed;
  no objection in the threads retrieved.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:
- No bugzilla/syzbot. Evidence is the author’s dmesg plus “after s4 …
  normal.”
- ACPI id **SMO0768** is in this tree:
  `drivers/char/tpm/tpm_tis_spi_main.c` (`acpi_tis_spi_match`). `-110`
  is `ETIMEDOUT` (`include/uapi/asm-generic/errno.h`).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Three revisions of **one** patch. v3 is the applied form. No
other patches in the series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search for “loongson spi freeze” returned
only unrelated “freeze” hits in stable review series. **No dedicated
stable discussion** of this bug (search via lore `?q=` HTML, HTTP 200).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: Symbol `loongson_spi_dev_pm_ops` only. Call targets
`loongson_spi_suspend` and `loongson_spi_resume` are unchanged.

**Step 5.2: TRACE CALLERS**

Record:
- `drivers/spi/spi-loongson-plat.c`: platform `.driver.pm =
  &loongson_spi_dev_pm_ops`
- `drivers/spi/spi-loongson-pci.c`: PCI `.driver.pm =
  &loongson_spi_dev_pm_ops`
- Invoked by the PM core on system sleep/hibernation, not from a syscall
  directly.

**Step 5.3: TRACE CALLEES**

Record (`loongson_spi_suspend`/`resume` in this tree):
- Suspend: `spi_controller_suspend()`, then read 6 controller registers
  into `struct loongson_spi`.
- Resume: write those 6 registers back, then `spi_controller_resume()`.
- `spi_controller_suspend` (`drivers/spi/spi.c`) stops a queued
  controller and sets `SPI_CONTROLLER_SUSPENDED`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
- Userspace (typically root): `echo disk > /sys/power/state` or distro
  hibernate.
- PM core → driver `.freeze`/`.poweroff`/`.restore` → save/restore SPI
  HW → later `tpm_tis_spi` transfers.
- **Reachable** on Loongson machines that hibernate with this controller
  and an SPI TPM (or any SPI child).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: In this tree, almost every other SPI driver uses
`SET_SYSTEM_SLEEP_PM_OPS` or `DEFINE_SIMPLE_DEV_PM_OPS`. Loongson was an
outlier with only `.suspend`/`.resume`. That matches the S4-only
failure.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `drivers/spi/spi-loongson-core.c` lines 272–275:

```c
const struct dev_pm_ops loongson_spi_dev_pm_ops = {
        .suspend = loongson_spi_suspend,
        .resume = loongson_spi_resume,
};
```

Bug since driver addition (**v6.6**). This tree is **6.12.111**.
Candidate not in HEAD (`git log --grep='add .freeze' -- drivers/spi/spi-
loongson-core.c` empty).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Minor context, clean functional apply.**
- This tree still has `__maybe_unused` on suspend/resume; the upstream
  hunk context dropped it.
- This tree exports `SPI_LOONGSON_CORE` unquoted; upstream uses
  `"SPI_LOONGSON_CORE"`.
- **`git apply --check` of the verbatim upstream hunk failed.**
- An adapted hunk using local context **applied cleanly** (`git apply
  --check` exit 0).
- `DEFINE_SIMPLE_DEV_PM_OPS` exists here.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other loongson SPI PM/hibernation fix in this file’s history.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record:
- **Subsystem:** SPI controller driver (`drivers/spi/`),
  Loongson/LoongArch.
- **Criticality:** **PERIPHERAL** for the kernel as a whole,
  **IMPORTANT** for Loongson users (SPI TPM after hibernate).
- Kconfig: `SPI_LOONGSON_CORE` / `_PCI` / `_PLATFORM`, `depends on
  LOONGARCH || COMPILE_TEST`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: This driver is **mature/quiet** in 6.12 (single commit). The bug
is long-standing, not a new-subsystem race.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Platform-specific / driver-specific:** LoongArch systems with
Loongson SPI (`loongson,ls2k1000-spi` or PCI 0x7a0b/0x7a1b) that
hibernate. Reporter path includes Infineon SPI TPM ACPI `SMO0768`. Not
universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: **hibernate (S4)**, then resume. Not every boot; every
  successful S4 on this hardware.
- Unprivileged users cannot normally hibernate (needs CAP_SYS_BOOT /
  root). Not a local-DoS from unprivileged userspace.
- Not a timing race; deterministic missing callbacks.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Failure:** SPI I/O timeouts; TPM start fails (`tpm_chip_start`
  -110). Controller left unrestored after image restore.
- **Severity: HIGH** (not a panic, but broken SPI/TPM after hibernate is
  a serious PM regression). TPM unusable can break measured boot / TPM-
  backed secrets after S4.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit: high** for affected Loongson/S4 users (restores SPI after
  hibernate).
- **Risk: very low** (~2-line helper swap, standard PM pattern, S3 path
  unchanged).
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real S4 failure with dmesg; author confirmed fix.
- Buggy incomplete `dev_pm_ops` present in this 6.12 tree since v6.6.
- Tiny, standard `DEFINE_SIMPLE_DEV_PM_OPS` change; SPI maintainer
  requested the helper and applied v3.
- TPM (`SMO0768`) is a real child device in-tree.
- `DEFINE_SIMPLE_DEV_PM_OPS` exists here; adapted patch applies.

**AGAINST:**
- LoongArch/Loongson-only; hibernate-only (not every boot).
- Subject says “add”; no `Fixes:`/`Cc: stable` (not used as a no).
- Verbatim upstream hunk needs a one-line context tweak (namespace
  quotes / `__maybe_unused`).
- Could have used `EXPORT_NS_GPL_SIMPLE_DEV_PM_OPS` (style only).

**UNRESOLVED:** Could not open lore via WebFetch (403); threads were
retrieved with `b4 mbox` and lore HTML search instead. Exact mainline
SHA of the evaluation candidate was not in this checkout (`a9c2f0d401fd`
is Mark’s spi.git apply of v3).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — standard helper; author
   tested S4; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — SPI/TPM broken after
   hibernate.
3. Important issue? **PASS** — HIGH: I/O failure and TPM unusable after
   S4 (not a panic, still production-breaking PM).
4. Small and contained? **PASS** — one struct, one file.
5. No new features or APIs? **PASS** — missing hibernation ops, not a
   new API.
6. Can apply to the local tree? **PASS** — with trivial context
   adjustment; macros and driver exist.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
small PM bugfix.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this 6.12 tree**. The driver has only
`.suspend`/`.resume`, so hibernation never restores the controller; that
matches the S4 TPM timeouts. The fix is the usual
`DEFINE_SIMPLE_DEV_PM_OPS` mapping, already used by other SPI drivers
here, with very low regression risk.

The problem for 6.12 users is that Loongson SPI (and the SPI TPM on that
bus) stays dead after hibernate because hibernation callbacks were never
wired. That is a real, tested, important PM bug. It meets the stable
rules: small, obviously correct, no new API, and it applies here with a
trivial context tweak.

Verification:
- [Phase 1] Parsed subject/tags/body from the provided commit and v1–v3
  mboxes; no Fixes/Reported-by/Cc:stable; Link msgid
  `20260820092351.101605-1-lijun01@kylinos.cn`
- [Phase 2] Diff: replace 4-line `dev_pm_ops` with
  `DEFINE_SIMPLE_DEV_PM_OPS`; functions unchanged
- [Phase 2] Confirmed `SYSTEM_SLEEP_PM_OPS` sets
  suspend/resume/freeze/thaw/poweroff/restore
  (`include/linux/pm.h:312-318`); `-110` is `ETIMEDOUT`
- [Phase 3] `git blame` lines 232–276 → `6c7a864007b66`; `git merge-base
  --is-ancestor 6c7a864007b66 HEAD` true; `v6.5` no, `v6.6` yes
- [Phase 3] `git log --oneline -- drivers/spi/spi-loongson*.c` only the
  original driver commit
- [Phase 4] `b4 mbox` v1/v2/v3; Mark Brown asked for
  `SIMPLE_DEV_PM_OPS()` on v1; v3 uses `DEFINE_SIMPLE_DEV_PM_OPS`; `b4
  mbox -c` no newer rev
- [Phase 4] lore.kernel.org/stable `?q=loongson+spi+freeze` HTTP 200, no
  dedicated thread
- [Phase 5] Callers: `spi-loongson-plat.c:39`, `spi-loongson-pci.c:48`;
  ACPI `SMO0768` in `tpm_tis_spi_main.c:342`
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → `6.12.111`; buggy ops at `spi-loongson-
  core.c:272-275`
- [Phase 6] Original hunk `git apply --check` failed; adapted hunk
  (unquoted ns + `__maybe_unused` context) succeeded
- [Phase 7] Kconfig `SPI_LOONGSON_*` depends on `LOONGARCH ||
  COMPILE_TEST`
- [Phase 8] Failure: SPI timeout / TPM start -110 after S4; severity
  HIGH; risk very low
- UNVERIFIED: WebFetch to lore/git.kernel.org returned 403; used `b4`
  and curl HTML instead
- UNVERIFIED: Did not boot-test hibernate on Loongson hardware; relied
  on author’s dmesg and code

**YES**

 drivers/spi/spi-loongson-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-loongson-core.c b/drivers/spi/spi-loongson-core.c
index b46f072a0387b..f07ee432f96b5 100644
--- a/drivers/spi/spi-loongson-core.c
+++ b/drivers/spi/spi-loongson-core.c
@@ -270,10 +270,8 @@ static int __maybe_unused loongson_spi_resume(struct device *dev)
 	return 0;
 }
 
-const struct dev_pm_ops loongson_spi_dev_pm_ops = {
-	.suspend = loongson_spi_suspend,
-	.resume = loongson_spi_resume,
-};
+DEFINE_SIMPLE_DEV_PM_OPS(loongson_spi_dev_pm_ops, loongson_spi_suspend, loongson_spi_resume);
+
 EXPORT_SYMBOL_NS_GPL(loongson_spi_dev_pm_ops, "SPI_LOONGSON_CORE");
 
 MODULE_DESCRIPTION("Loongson SPI core driver");
-- 
2.53.0

