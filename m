Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6127552F26B;
	Mon, 19 Oct 2026 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418119; cv=none; b=oO5Xl0eZhyADvAJIWU6cQk3H4gKtkdBmeXU56SwKWxWBBHx6H2RurqguLvgVIWgU87SSnUmgj1a+oDqB0YjT15AOc49XkiCa7nJfTj2P8/F8XoEDKHNbxyPPVpBVQViUreHmoZjyGp04eZ/prCVhukJsvuIU1O6W1KE8u/9RVoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418119; c=relaxed/simple;
	bh=vvfWDcS2rWGi+nOV2v/fQMUgu8zF8gJl01U+RURLLL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ix0UTUDyMb44IBACzSkAiLWDqMorslmvIC+TgKmtX1jRe5hDQp6vEf5haw3yNFfXvix4d6j+eLPi3JxBb6zuzyK+pMnWT/e1z1r/E8NohlriSEvHUKFnLm7ouEU4n/kS//kffwzZXnqx1uS105NDsTOTcLVvjIUKKo3oxv4zZsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDG5fM/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDG5fM/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569AD1F000C6;
	Mon, 19 Oct 2026 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418117;
	bh=WRcfFK3BdNnjyOg64mtimJlbpdRUsbjFlCy++SmS9iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDG5fM/1+Si7UuCMwKN/H8Ykuz85D6murT+9izZUr2G4wVDBrIbtzuen/fCgAto3t
	 eu96DIbRrcOaw5uYE9p+D4Zk4N8oyRydmJMe6jlA2lKBFMT/mHdqDe6+CWL8xchCnb
	 Z+Aawsuh1Ro/iAgEyOJxfFUUviBOzBrlAVzrSsPuFWiSD1hk9JwsGawQKwVu7w+EzQ
	 5MUHGEqnC9346DJxe+OPvbghdDveojFh6htIm1NO2JOa6nqkWmGrAnlwKp2fksIexj
	 VXHCzkfQnEDkVvStkNKlmdfPdjZr3Yd2AXL+F8snH5J41y3O/bE6NeoN8GsMegm9Ct
	 7uVuxV6XFE/QQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] i2c: qup: Propagate clock enable failures
Date: Mon, 19 Oct 2026 09:45:14 -0400
Message-ID: <20261019135441.1420968-23-sashal@kernel.org>
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

[ Upstream commit a477626332800942f463d76aa48db0c47f1dfd18 ]

The QUP I2C driver treats the core and iface clocks as required
resources, but qup_i2c_enable_clocks() ignores clk_prepare_enable()
failures.  Probe can then continue to register the I2C adapter, and
runtime/system resume can return success, even when a required clock
transition failed.

Make the helper return an error, unwind a partially enabled clock, and
propagate failures from probe and resume paths.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260624055237.29977-1-pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **v7.3-rc4**. The driver and the ignored-clock-
enable bug exist in this lineage (since v3.15); the fix is a small,
self-contained error-path change that belongs in this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[i2c: qup]** **[Propagate]** — make `clk_prepare_enable()`
failures visible instead of swallowing them.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Konrad Dybcio (Qualcomm / linux-arm-msm)
- **Acked-by:** none
- **Link:**
  https://lore.kernel.org/r/20260624055237.29977-1-pengpeng@iscas.ac.cn
- **Cc: stable:** none (expected)
- **Signed-off-by:** Pengpeng Hou (author); Andi Shyti (I2C maintainer)
- No syzbot / kernel test robot tags

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `qup_i2c_enable_clocks()` treats core and iface clocks as
  required, but ignores `clk_prepare_enable()` return values.
- **Symptoms:** probe still registers the I2C adapter; runtime/system
  resume still return success after a required clock failed.
- **Version info:** none in the message. Git shows the ignore-return
  pattern since the driver was added.
- **Root cause:** void helper with unchecked clock enables; callers
  cannot fail.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not disguised. It is an explicit error-path fix: check returns,
unwind a half-enabled clock, propagate from probe and resume.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/i2c/busses/i2c-qup.c` — **+24 / −7** (31 lines)
- **Functions:** `qup_i2c_enable_clocks`, `qup_i2c_probe`,
  `qup_i2c_pm_resume_runtime`, `qup_i2c_resume`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
1. **Helper:** void, two unchecked `clk_prepare_enable()` → `int`, abort
   on first failure, disable core clk if iface enable fails.
2. **Probe (DT path only):** ignore enable → `ret = …; if (ret) goto
   fail_dma`. ACPI path still skips this helper.
3. **Runtime resume:** always `return 0` → return the helper’s error.
4. **System resume:** always `pm_request_autosuspend()` after resume →
   skip autosuspend request if clocks failed.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Error-path / ignored-return + resource leak.**
- Broken: required clocks can fail; driver still MMIO-resets the QUP
  (`writel` to `QUP_SW_RESET` immediately after enable in probe) and
  later runs I2C with clocks off; iface-fail leaves core clk enabled.
- Fix: fail probe/resume, unwind partial enable.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct and matches other I2C host drivers. `goto
fail_dma` is the right label: `fail:` would call
`qup_i2c_disable_clocks()` and MMIO/unprepare clocks that were never (or
no longer) enabled. Regression risk is low: a real clock failure now
fails probe/resume instead of continuing on dead hardware.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Ignored enables introduced in **`10c5a8425968`** (“i2c: qup: New
bus driver…”, Bjorn Andersson, 2014). First contained in **v3.15-rc1**.
`git log -L :qup_i2c_enable_clocks:` shows only that commit and this
fix.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Original driver commit is an ancestor of HEAD.

**Step 3.3: CHECK FILE HISTORY**

Record: Recent related work is unrelated (`pm_runtime_mark_last_busy`,
timeout loop, interconnect vote). Older related fix **`3cf357dfb40b`**
already routed some probe errors to `fail` so clocks get released — this
patch fills the missing enable-check. Standalone, not `X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Pengpeng Hou has only this commit under `drivers/i2c/`. Reviewer
is a Qualcomm platform maintainer; committer is the I2C maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: No new APIs or structs. Applies standalone on this tree. No
follow-ups on `i2c-qup.c` after `a477626332800`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:**
  https://patch.msgid.link/20260624055237.29977-1-pengpeng@iscas.ac.cn
- **Revisions:** v1 only (no v2/v3)
- **Review:** Konrad Dybcio `Reviewed-by` the same day; Andi Shyti
  merged to `i2c/i2c` (~2026-07-28). No NAK, no stable nomination in-
  thread.
- lore.kernel.org fetch returned 403; thread confirmed via gnuweeb,
  patchew, and openwall mirrors.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To Andi Shyti; Cc linux-arm-msm, linux-i2c, linux-
kernel. Konrad was not in the original To/Cc but reviewed from linux-
arm-msm.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No bugzilla/syzbot/user report. Issue is from code review of
ignored returns.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Single standalone patch, not a series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No discussion of this subject on stable@ found
(lore.kernel.org/stable 403; web search did not hit this patch).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `qup_i2c_enable_clocks`, `qup_i2c_probe`,
`qup_i2c_pm_resume_runtime`, `qup_i2c_resume`. (semcode MCP not
available.)

**Step 5.2: TRACE CALLERS**

Record: Only three call sites in this file:
- `qup_i2c_probe` (DT/clk path, boot / module load)
- `qup_i2c_pm_resume_runtime` (runtime PM; also used as `RUNTIME_PM_OPS`
  resume)
- `qup_i2c_resume` → that runtime helper (system sleep)

Not interrupt context. Reachable on every QUP I2C device probe and every
resume.

**Step 5.3: TRACE CALLEES**

Record: `clk_prepare_enable` / `clk_disable_unprepare` only. Probe then
`clk_get_rate` and `writel(QUP_SW_RESET)`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Platform probe / PM resume. Userspace does not call this
directly, but every Qualcomm QUP I2C bus (touch, sensors, PMICs, cameras
on many phones and boards) goes through it. Unclocked MMIO after a
failed enable is a hang path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Most I2C hosts already check `clk_prepare_enable`
(`i2c-designware-common.c`, `i2c-exynos5.c`, `i2c-img-scb.c`, etc.). A
few still ignore it (`i2c-mv64xxx.c`, `i2c-hix5hd2.c`). This brings QUP
in line with the common pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Tree is **v7.3-rc4** (`7.3.0-rc4`, `f0100363d8c37`).
Introducer `10c5a8425968` and fix `a477626332800` are both ancestors of
HEAD. Pre-fix helper in the parent of the fix is still the 2014 void
ignore-return version. Driver: `drivers/i2c/busses/i2c-qup.c`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Clean apply on this tree (same file, same functions). No extra
prerequisites.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No alternate fix for ignored enable. `3cf357dfb40b` only fixes a
later probe unwind, not enable checking. No post-fix regressions on this
file.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **I2C host driver** (`drivers/i2c/busses/i2c-qup.c`),
`CONFIG_I2C_QUP` (`ARCH_QCOM || COMPILE_TEST`). **IMPORTANT** for
Qualcomm platforms (common on phones, boards, IoT); not core mm/VFS.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Mature driver (2014), still getting occasional correctness
fixes. Not a new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: Qualcomm SoC users with QUP I2C (`qcom,i2c-qup-v1.1.1` /
`v2.1.1` / `v2.2.1`). Driver- and config-specific, but a large device
population.

**Step 8.2: TRIGGER CONDITIONS**

Record: `clk_prepare_enable()` failure on core or iface (probe, runtime
resume, or system resume). Unprivileged users cannot poke the helper,
but resume is a normal path. Failures are uncommon on healthy clocks;
they do happen with power-domain / RPM / -ENOMEM issues. No public
reproducer.

**Step 8.3: FAILURE MODE SEVERITY**

Record: Continuing after a failed enable then `writel`/`readl` on the
QUP can hang the interconnect; resume success with clocks off breaks
later transfers; iface-fail leaks a prepared core clk. **HIGH** when it
triggers (hang / stuck I2C), **MEDIUM** overall because triggers are
rare. Not a demonstrated CVE.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** avoid unclocked MMIO and false-success resume on QUP I2C.
- **Risk:** very low (~24 insertions, error paths only, standard clk
  unwind).
- **Ratio:** favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**For:**
- Real ignored-error bug on required clocks.
- Probe immediately MMIO-resets the block; clocks-off access can hang.
- Resume used to report success with clocks still off.
- Partial enable leaked the core clock.
- 24 insertions in one file; obviously correct; no new API.
- Reviewed by Konrad Dybcio, merged by Andi Shyti.
- Bug present since v3.15; no extra dependencies.
- Matches the usual I2C host-driver pattern.

**Against:**
- No user/syzbot report in ~12 years.
- Clock enable rarely fails on working hardware.
- No in-thread `Cc: stable`.

**Unresolved:** Direct lore.kernel.org/stable search 403; no evidence
this was rejected for stable.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — standard clk check/unwind;
   maintainer review/merge. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — ignored required-
   clock failure on probe/resume.
3. Important issue? **PASS** — hang / dead I2C / clock leak on that
   path, not a style cleanup.
4. Small and contained? **PASS** — +24/−7, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — driver and call sites match.

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk, DT, build, or doc fix). Qualifies
as a normal error-path bugfix.

**Step 9.4: DECISION**

This is a small, correct fix for ignored required-clock errors. On this
v7.3-rc4 tree the buggy helper and the QUP probe/resume paths are
present; the change prevents probe/resume from continuing into unclocked
MMIO. That is enough for stable, even without a field report.

---

### What it solves for this tree

`qup_i2c_enable_clocks()` used to ignore `clk_prepare_enable()`. Probe
still registered the adapter and then `writel`’d `QUP_SW_RESET`; resume
returned 0. If enable actually failed, that is unclocked MMIO (possible
SoC hang) plus a clock leak when only the iface clock failed. The patch
fails those paths and unwinds.

### Stable rules / risk

Meets the rules: real bug, small, no features, applies here. Benefit is
avoiding hangs and false-success PM on Qualcomm QUP I2C; risk is low.

### Concerns

No `Fixes:` / user report (not a reason to reject). `fail_dma` on enable
failure is correct. No follow-up fix found.

---

### Verification

- **[Phase 1]** Tags: Reviewed-by Konrad Dybcio; SOB Andi Shyti; Link
  lore msgid `20260624055237.29977-1`; no Fixes/Reported-by/Cc:stable.
- **[Phase 2]** Diff: +24/−7 in `i2c-qup.c`; helper becomes `int`;
  probe/resume propagate; partial unwind on iface fail.
- **[Phase 2]** Pre-fix parent: void helper, probe
  `qup_i2c_enable_clocks(qup)` then `writel(QUP_SW_RESET)`; resume
  always 0.
- **[Phase 2]** Post-fix probe uses `goto fail_dma` (not `fail`), so
  `qup_i2c_disable_clocks()` is not run on a failed enable.
- **[Phase 3]** `git log -L :qup_i2c_enable_clocks:` → `10c5a8425968`
  (v3.15-rc1) then `a477626332800`.
- **[Phase 3]** `git merge-base --is-ancestor` both SHAs vs HEAD: both
  in this tree.
- **[Phase 3]** Author: only this I2C commit; no later commits on this
  file after the fix.
- **[Phase 4]** `b4 dig -c a477626332800`: matched msgid; `-a`: v1 only;
  `-w`: Andi + linux-i2c/arm-msm.
- **[Phase 4]** Review: Konrad Reviewed-by; Andi “merged to i2c/i2c”; no
  NAK.
- **[Phase 4]** lore.kernel.org 403; gnuweeb/patchew/openwall used
  instead. Stable-list search: no hits for this subject.
- **[Phase 5]** Callers: probe, runtime resume, system resume only.
  Other I2C hosts already check `clk_prepare_enable`.
- **[Phase 6]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → `7.3.0-rc4`. Buggy code existed; driver
  present.
- **[Phase 7]** `CONFIG_I2C_QUP` depends on `ARCH_QCOM`; I2C maintainer
  Andi Shyti.
- **[Phase 8]** Failure mode: unclocked MMIO / false resume success;
  severity HIGH if triggered, uncommon trigger.
- **UNVERIFIED:** Could not fetch lore.kernel.org HTML directly (403).
  Thread content verified via b4 + mirrors.

**YES**

 drivers/i2c/busses/i2c-qup.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index a0e076fc5f363..ee7915ee2ba2f 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -1657,10 +1657,21 @@ static const struct i2c_adapter_quirks qup_i2c_quirks_v2 = {
 	.flags = I2C_AQ_NO_ZERO_LEN,
 };
 
-static void qup_i2c_enable_clocks(struct qup_i2c_dev *qup)
+static int qup_i2c_enable_clocks(struct qup_i2c_dev *qup)
 {
-	clk_prepare_enable(qup->clk);
-	clk_prepare_enable(qup->pclk);
+	int ret;
+
+	ret = clk_prepare_enable(qup->clk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(qup->pclk);
+	if (ret) {
+		clk_disable_unprepare(qup->clk);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void qup_i2c_disable_clocks(struct qup_i2c_dev *qup)
@@ -1823,7 +1834,9 @@ static int qup_i2c_probe(struct platform_device *pdev)
 			ret = PTR_ERR(qup->pclk);
 			goto fail_dma;
 		}
-		qup_i2c_enable_clocks(qup);
+		ret = qup_i2c_enable_clocks(qup);
+		if (ret)
+			goto fail_dma;
 		src_clk_freq = clk_get_rate(qup->clk);
 	}
 	qup->src_clk_freq = src_clk_freq;
@@ -1975,8 +1988,7 @@ static int qup_i2c_pm_resume_runtime(struct device *device)
 	struct qup_i2c_dev *qup = dev_get_drvdata(device);
 
 	dev_dbg(device, "pm_runtime: resuming...\n");
-	qup_i2c_enable_clocks(qup);
-	return 0;
+	return qup_i2c_enable_clocks(qup);
 }
 
 static int qup_i2c_suspend(struct device *device)
@@ -1988,7 +2000,12 @@ static int qup_i2c_suspend(struct device *device)
 
 static int qup_i2c_resume(struct device *device)
 {
-	qup_i2c_pm_resume_runtime(device);
+	int ret;
+
+	ret = qup_i2c_pm_resume_runtime(device);
+	if (ret)
+		return ret;
+
 	pm_request_autosuspend(device);
 	return 0;
 }
-- 
2.53.0

