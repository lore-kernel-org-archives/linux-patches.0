Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797358B6CE;
	Mon, 19 Oct 2026 13:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418386; cv=none; b=NGUl353MognCx2mGUiwszckl3OqY7/V/rYynJhQbD0/ktWsHHzCIVgp7w4R4rwLb1W4ONwYAFz1oqqnAdYP+TL7jLUsZtwEVkm/euIn9k+7XRDAic/0QZohXmRxSCTSfQfWFL924LFHWeoDIG6yS9uvOWSmmC0KaakJFxorrbIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418386; c=relaxed/simple;
	bh=XZPghCTjb1jX+Q7cqp8MHf8/5S+roAFYzazEhZS/viw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZLn3BBUTvKEoVPSHe2/2zWk29uI5Jv8rSen/nPPB8nr0vyOqoegDkalIe0UXtL8D8YgIMRVqtQxFa+X0s1cVSp0qbikbjBUH1x2X9blBq5QhVxDivPXjXgCYheCHLSIUdENh75NyyajMDHZ0tF+wQ+14Zhk5LAxRsmHevTskm3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBDC7KCX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBDC7KCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF6C1F000CA;
	Mon, 19 Oct 2026 13:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418383;
	bh=D1aPOgBERGuCo14oNo+vtfsa1n/bJR50FBv53Np1Kr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBDC7KCX6j3nXvNmoW/nF3EUWlcoopMnzFDY9eDQU4e31bvGb4nWvPwQrali/yyaS
	 VTfQcGekeFvvXEf8b+XYacwm5yEjpy/xGk0dSqivLjVxfB3xpWGc0y5WMv8r9k+Pwj
	 jYyY14a2rbeCRQIpEg61fwR2hwxyVn//wSiKfgix/0wBcZX7E+A2EMBKpCy+EGLFQ+
	 sG7j1H27cMRxrUglCcp8S8mhQNzackUMmLFNdv0xZTVvNZ3ERpQd2ahZCB+GiSEFEg
	 aWzKdgrJyarbGSeTBrFQsy6ziikn6P/yKYatjWo9K0ttl4nwBnN7LezJOFZ+FV5uf4
	 IEzx0Kb4MXPaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mike Tipton <mike.tipton@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] pmdomain: qcom: rpmhpd: Skip retention by default
Date: Mon, 19 Oct 2026 09:48:21 -0400
Message-ID: <20261019135441.1420968-210-sashal@kernel.org>
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

From: Mike Tipton <mike.tipton@oss.qualcomm.com>

[ Upstream commit 7178817f190496f2bfdec181fb4aa72832448468 ]

Retention is very rarely an operational corner. In the majority of
cases, HW cannot operate properly at Retention levels and so the minimum
operational level when enabling a rail is the first corner above
Retention. A small subset of always-on use cases can operate at
Retention, but those aren't controlled from HLOS.

Currently, we allow Retention by default and only disallow it special
cases. But this leaves us open to various failures when the PD is
enabled without first being voted to an OPP above Retention. Such as
when a child GDSC PD requests to enable its parent RPMh PD. In this
case, the GDSC would get stuck powering on.

Newer chips have started supporting Retention on rails that didn't
previously (such as for MMCX). Instead of adding more special cases to
skip Retention on MMCX, start skipping Retention by default since it's
almost never desired from an HLOS perspective.

Signed-off-by: Mike Tipton <mike.tipton@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[pmdomain/qcom/rpmhpd] [Skip] Skip Retention voltage as the
  default enable corner`

**Step 1.2: Tags**
- Record:
  - `Signed-off-by: Mike Tipton <mike.tipton@oss.qualcomm.com>` (author,
    Qualcomm)
  - `Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>`
    (Qualcomm SoC reviewer)
  - `Signed-off-by: Ulf Hansson <ulfh@kernel.org>` (GENERIC PM DOMAINS
    maintainer)
  - No `Fixes:` tag (expected)
  - No `Cc: stable` (expected)
  - No `Reported-by`, `Tested-by`, `Link`, or syzbot tags
- Notable: Qualcomm author + Qualcomm reviewer + subsystem maintainer
  SOB. No user/syzbot report.

**Step 1.3: Body**
- Record:
  - **Bug:** HLOS enable of an RPMh PD without an OPP above Retention
    can vote Retention. Most hardware cannot run at Retention.
  - **Symptom:** Child GDSC enable of a parent RPMh PD leaves the GDSC
    stuck powering on (hardware hang, not a kernel oops).
  - **Root cause:** Retention is allowed by default; only MXC opted out
    via `skip_retention_level`. Newer chips now expose Retention on
    rails that previously did not (e.g. MMCX).
  - **Fix approach:** Skip Retention for every rail when building the
    cmd-db mapping, instead of adding more per-rail flags.
  - **Version info:** None in the message. “Newer chips” / MMCX is the
    motivation.

**Step 1.4: Hidden bug fix?**
- Record: Not hidden. It is a real hardware-failure fix described as a
  default-policy change. Skipping Retention is the workaround, not a
  cleanup.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record:
  - File: `drivers/pmdomain/qcom/rpmhpd.c` (+9 / −5)
  - Functions/data: `struct rpmhpd` (drop `skip_retention_level`), `mxc`
    / `mxc_ao` initializers, `rpmhpd_update_level_mapping()`
  - Scope: single-file surgical change

**Step 2.2: Code flow**
- Record:
  - **Before:** `rpmhpd_update_level_mapping()` copied cmd-db aux levels
    into `rpmhpd->level[]`. Retention (vlvl 16) was skipped only if
    `skip_retention_level` was set. That flag was true only on `mxc` /
    `mxc_ao`. `enable_corner` became the first non-zero mapped corner,
    which could be Retention.
  - **`rpmhpd_power_on()`:** `corner = max(pd->corner,
    pd->enable_corner)` then aggregate. Enable without an OPP uses
    `enable_corner`.
  - **After:** Retention is always skipped. `enable_corner` is the first
    corner above Retention. MXC’s flag is redundant and removed.
  - Path affected: probe-time mapping, then every power-on that does not
    already have a higher OPP (including parent enable from a child
    GDSC).

**Step 2.3: Bug mechanism**
- Record: **Hardware workaround / logic fix.** Retention as min enable
  corner is not a valid operational vote for HLOS. Child GDSC parent-on
  uses that corner and the GDSC never completes power-on.
- Verified path: `gdsc_register()` attaches GDSCs as genpd subdomains of
  the clock-controller’s `dev->pm_domain` (`drivers/clk/qcom/gdsc.c`).
  `genpd_power_on()` walks parents and calls `rpmhpd_power_on()` with no
  performance state. DT has many `power-domains = <&rpmhpd RPMHPD_MMCX>`
  nodes (sm8450/sm8550/sm8650/sm8750 and others).

**Step 2.4: Fix quality**
- Record: Obviously correct given the existing skip logic. Minimal. If
  cmd-db has no Retention entry, the new `if` never matches (no-op on
  older rails). Regression risk is a slightly higher min vote (Retention
  16 → typically MIN_SVS 48) on rails that advertised Retention; the
  author states HLOS must not use Retention. No API/ABI change.

## Phase 3: Git history

**Step 3.1: Blame**
- Record:
  - Mapping loop: `279b7e8a62cc` (“soc: qcom: rpmhpd: Add RPMh power
    domain driver”, 2019)
  - `enable_corner`: `e3e56c050ab6` (“soc: qcom: rpmhpd: Make power_on
    actually enable the domain”, 2021) — this is what makes Retention
    reachable as the enable vote
  - Opt-in skip: `ddab91f4b2de5` (“Skip retention level for Power
    Domains”, 2024), MXC only, `Cc: stable@vger.kernel.org # v5.17`
  - This change: `7178817f19049` (2026-07-13)

**Step 3.2: Fixes tag**
- Record: None. Closest predecessor is `ddab91f4b2de5` (MXC-only skip).
  Both `ddab91f4b2de5` and `e3e56c050ab6` are ancestors of this HEAD.

**Step 3.3: File history**
- Record: Recent work is mostly new SoC tables. No later revert of
  default-skip. Eliza MXC/MMCX add was reverted for unrelated reasons
  (`9fca7779ad185`). Standalone v1 patch, not part of a numbered series.

**Step 3.4: Author**
- Record: Mike Tipton (Qualcomm); this is his only recent commit on
  `drivers/pmdomain/qcom/`. Konrad reviews rpmhpd regularly. Ulf is the
  pmdomain maintainer.

**Step 3.5: Dependencies**
- Record: Needs `enable_corner` + Retention skip `continue` in
  `rpmhpd_update_level_mapping()`. Both exist here. Applies standalone
  on a tree that still has `skip_retention_level`. No other patches
  required.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `b4 dig -c 7178817f19049` →
  https://patch.msgid.link/20260629-rpmhpd-skip-
  ret-v1-1-d94180ad9a29@oss.qualcomm.com
- Series: **v1 only** (no v2/v3).
- Thread (mbox): Ulf Hansson: “Applied for next, thanks!” No NAKs, no
  stable nomination, no reviewer risk flags.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Ulf Hansson, linux-arm-msm, linux-pm, linux-kernel, Bjorn
  Andersson, Konrad Dybcio, Taniya Das (author of the MXC skip), Fenglin
  Wu. Right lists and people.

**Step 4.3: Bug report**
- Record: No public user/syzbot/bugzilla report. Failure mode is
  described by the Qualcomm author from platform bring-up.

**Step 4.4: Related series**
- Record: Standalone. Extends `ddab91f4b2de5` rather than depending on a
  multi-patch series.

**Step 4.5: Stable list**
- Record: lore.kernel.org/stable fetch returned 403. UNVERIFIED whether
  stable@ discussed this subject. The 2024 MXC skip *was* Cc:stable.

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
- Record: `rpmhpd_update_level_mapping()` (changed), `rpmhpd_power_on()`
  / `rpmhpd_set_performance_state()` (consumers of `enable_corner`,
  unchanged).

**Step 5.2: Callers**
- Record: `rpmhpd_update_level_mapping()` ← `rpmhpd_probe()` only.
  `rpmhpd_power_on()` is `generic_pm_domain.power_on`, called from genpd
  (including parent-on for child GDSCs). Probe + device/runtime PM, not
  a syscall-only path.

**Step 5.3: Callees**
- Record: `cmd_db_read_aux_data()`, then later
  `rpmhpd_aggregate_corner()` → `rpmhpd_send_corner()` (RPMh votes).

**Step 5.4: Reachability**
- Record: Yes, from normal Qualcomm device probe. Clock-controller GDSCs
  are subdomains of rpmhpd (often MMCX). Userspace does not need a
  special trigger; enabling display/video/camera clocks is enough.

**Step 5.5: Similar patterns**
- Record: Only MXC used `skip_retention_level`. MMCX/`mmcx_w_cx_parent`
  did not. That matches “instead of adding more special cases for MMCX.”

## Phase 6: This tree only

**Step 6.1: Does the buggy code exist here?**
- Record:
  - Local tree: **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`,
    Makefile `VERSION=7 PATCHLEVEL=3`).
  - `drivers/pmdomain/qcom/rpmhpd.c` is present. Pre-commit code had
    `skip_retention_level` only on MXC.
  - `7178817f19049` is already an ancestor of HEAD (in v7.3-rc1; **not**
    in v7.2). Current file already skips Retention unconditionally.
  - Bug class (Retention as `enable_corner`) dates to `e3e56c050ab6`
    (2021) whenever cmd-db lists Retention; MMCX Retention on newer
    chips is why this default change was made. That hardware **is**
    represented in this 7.3 tree.

**Step 6.2: Backport difficulty**
- Record: Against current HEAD the patch is already applied (forward
  apply would fail). Against 7.3 immediately before this commit it is a
  clean apply (same file layout, `skip_retention_level` present). No
  extra backport rework for this tree’s rpmhpd.c.

**Step 6.3: Related fixes already here**
- Record: MXC-only skip (`ddab91f4b2de5`) is here; it does **not** cover
  MMCX/CX/etc. `2a93c6cbd5a70` (enabled_corner aggregation) is a
  different bug (peer off during sync_state). No substitute for this
  commit.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `drivers/pmdomain/qcom/` — Qualcomm RPMh power domains.
  **IMPORTANT** (not core mm/fs, but used on a large set of Snapdragon
  phones, laptops, and embedded boards). Maintainer: Ulf Hansson
  (`GENERIC PM DOMAINS`).

**Step 7.2**
- Record: Active (new SoC tables: Nord, Hawi, Eliza, Kaanapali, Glymur,
  etc.). The Retention default is independent of those tables.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Qualcomm rpmhpd platforms (`CONFIG_QCOM_RPMHPD`), especially
  SoCs whose cmd-db advertises Retention on MMCX or other non-MXC rails.
  Not universal; not staging.

**Step 8.2: Trigger**
- Record: Common: child GDSC on, parent rpmhpd has no OPP. Happens at
  probe/runtime PM. Unprivileged userspace can cause it indirectly by
  using multimedia devices; it also happens at boot when those
  controllers probe.

**Step 8.3: Failure mode**
- Record: GDSC stuck powering on → device/controller hang, probe
  failure, missing display/video/camera (or boot issues if that path is
  on the critical path). Severity: **HIGH** (hardware hang), not a
  KASAN/UAF class crash.

**Step 8.4: Risk-benefit**
- Record:
  - **Benefit:** Prevents GDSC/parent-rail hangs on Qualcomm platforms
    in this tree, including MMCX without extending a per-rail flag list.
  - **Risk:** Low. 14-line change; no-op if Retention is absent from
    cmd-db; MXC behavior unchanged; Qualcomm + maintainer reviewed.
  - **Ratio:** Benefit > risk.

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Concrete hang: parent RPMh PD at Retention → child GDSC stuck on.
- Call path and DT consumers verified in this tree.
- Small, obviously correct extension of an existing skip that was
  already Cc:stable for MXC.
- Safe no-op when Retention is not in cmd-db.
- Reviewed by Konrad, applied by Ulf; Taniya Das (original skip author)
  was on Cc.
- This 7.3 tree has rpmhpd, `enable_corner`, `skip_retention_level`, and
  MMCX users.

Against:
- No `Fixes:` / public reproducer / syzbot (not a negative per rules).
- Default change for all rails, not only MMCX (mitigated: Retention skip
  is a no-op where unused).
- lore.kernel.org/stable search could not be fetched (403).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — v1 accepted, maintainer
   applied, Qualcomm review.
2. Real user-visible bug? **PASS** — GDSC stuck on parent enable.
3. Important (hang/corruption/security)? **PASS** — hardware hang on a
   widely used SoC family; HIGH, not a panic.
4. Small and contained? **PASS** — +9/−5, one file.
5. No new features/APIs? **PASS** — same skip, defaulted; no userspace
   API.
6. Can apply to this tree? **PASS** — 7.3 has the pre-image; the commit
   is in 7.3-rc1.

**Step 9.3: Exception category**
- Record: Hardware workaround (skip a non-operational corner), same
  class as the 2024 MXC Retention skip.

**Step 9.4: Decision**
This tree is 7.3.0-rc4. The rpmhpd driver, the Retention-
as-`enable_corner` bug, and MMCX parent-GDSC consumers are all here. The
change is a small, correct hang fix, not a feature. It should be in this
tree.

---

### What it solves for users of this tree

Without it, enabling a Qualcomm GDSC whose parent RPMh rail (often MMCX)
has no OPP votes Retention. That rail cannot actually run there, so the
GDSC never finishes power-on. Display, video, camera, and similar
controllers that list `power-domains = <&rpmhpd RPMHPD_MMCX>` hit this
on probe or runtime PM. Skipping Retention when building the cmd-db map
makes the min enable corner the first real operational level.

### Risk vs benefit

Benefit is avoiding a platform hang on common Qualcomm PM paths. Risk is
low: SoCs without Retention in cmd-db are unchanged; MXC already skipped
Retention; HLOS is not supposed to use Retention.

### Concerns

No public reproducer. Stable-list discussion unverified (HTTP 403).
Slightly higher min vote on rails that listed Retention is intended, not
a silent functional change for rails that never had it.

### Verification
- [Phase 1] Parsed tags: author/reviewer/maintainer SOBs only; no
  Fixes/stable/syzbot
- [Phase 2] Diff: +9/−5 in `rpmhpd.c`; drop `skip_retention_level`;
  always skip `RPMH_REGULATOR_LEVEL_RETENTION` (16)
- [Phase 2] `rpmhpd_power_on()` uses `max(pd->corner,
  pd->enable_corner)` — verified in file
- [Phase 2] GDSC subdomain attach in `gdsc_register()` — verified
- [Phase 2] DT MMCX consumers in sm8450/sm8550/sm8650/sm8750 dtsi —
  verified
- [Phase 3] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor 7178817f19049 HEAD`: yes; not
  in v7.2; in v7.3-rc1
- [Phase 3] Blame: mapping 279b7e8a62cc (2019); enable_corner
  e3e56c050ab6 (2021); MXC skip ddab91f4b2de5 (2024)
- [Phase 3] Pre-image: `skip_retention_level` only on mxc/mxc_ao; mmcx
  had no flag
- [Phase 4] `b4 dig -c 7178817f19049`: lore/msgid `20260629-rpmhpd-skip-
  ret-v1-1-d94180ad9a29@oss.qualcomm.com`
- [Phase 4] `b4 dig -a`: v1 only; Ulf “Applied for next”; no NAK
- [Phase 4] `b4 dig -w`: Ulf, Bjorn, Konrad, Taniya Das, linux-arm-msm,
  linux-pm
- [Phase 4] UNVERIFIED: lore.kernel.org/stable (403)
- [Phase 5] `rpmhpd_update_level_mapping()` called only from
  `rpmhpd_probe`
- [Phase 6] Post-fix code already in this checkout; related MXC skip
  present and insufficient
- [Phase 8] Failure mode: GDSC stuck on — HIGH hang, Qualcomm-specific

**YES**

 drivers/pmdomain/qcom/rpmhpd.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/pmdomain/qcom/rpmhpd.c b/drivers/pmdomain/qcom/rpmhpd.c
index 4c3cbf3abc750..fc61ec45755c3 100644
--- a/drivers/pmdomain/qcom/rpmhpd.c
+++ b/drivers/pmdomain/qcom/rpmhpd.c
@@ -41,7 +41,6 @@
  * @addr:		Resource address as looped up using resource name from
  *			cmd-db
  * @state_synced:	Indicator that sync_state has been invoked for the rpmhpd resource
- * @skip_retention_level: Indicate that retention level should not be used for the power domain
  */
 struct rpmhpd {
 	struct device	*dev;
@@ -58,7 +57,6 @@ struct rpmhpd {
 	const char	*res_name;
 	u32		addr;
 	bool		state_synced;
-	bool            skip_retention_level;
 };
 
 struct rpmhpd_desc {
@@ -176,7 +174,6 @@ static struct rpmhpd mxc = {
 	.pd = { .name = "mxc", },
 	.peer = &mxc_ao,
 	.res_name = "mxc.lvl",
-	.skip_retention_level = true,
 };
 
 static struct rpmhpd mxc_ao = {
@@ -184,7 +181,6 @@ static struct rpmhpd mxc_ao = {
 	.active_only = true,
 	.peer = &mxc,
 	.res_name = "mxc.lvl",
-	.skip_retention_level = true,
 };
 
 static struct rpmhpd nsp = {
@@ -974,7 +970,15 @@ static int rpmhpd_update_level_mapping(struct rpmhpd *rpmhpd)
 		return -EINVAL;
 
 	for (i = 0; i < rpmhpd->level_count; i++) {
-		if (rpmhpd->skip_retention_level && buf[i] == RPMH_REGULATOR_LEVEL_RETENTION)
+		/*
+		 * Most HW won't function properly at Retention. The minimum
+		 * operational level is the first level above Retention. The
+		 * small subset of HW that can operate at Retention isn't
+		 * controlled by HLOS. Skip the Retention level to avoid HW
+		 * failures when the PD is enabled without first having an
+		 * explicit OPP level set.
+		 */
+		if (buf[i] == RPMH_REGULATOR_LEVEL_RETENTION)
 			continue;
 
 		rpmhpd->level[i] = buf[i];
-- 
2.53.0

