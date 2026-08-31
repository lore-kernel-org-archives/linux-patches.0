Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA2B58F062;
	Mon, 31 Aug 2026 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184247; cv=none; b=KRU1zmC/ozfuQ7XoegtSsjhJumDWXgqe0a+tci85DQFyY9G6Auql3Pr7zPKbkm8G6emAMIlmf35Y9Akqi08RwbpXy25GdTwe9ysUo+QcvM+8pITi1o0Aiyy1zbLAh4JA4tc2CLAU6UjSSvgka0I8DQHDkieZ4Lx0yeZglA1rVKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184247; c=relaxed/simple;
	bh=vuOSVSx0fcngSuqKE1+TmaIIckuadgDGiFCoqeSIUcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdONWLnC5qK9f0oeCW4vtB81eaCbcH9omsX19nfRMQO5tDX7sRZNqbF9BiL2dJpIW61nkWEjx4ReXTmLXaYM56SHuvKIZ7ZaCFKsIo6lX087p4O5mdBWqPXTEy6YaEnDKSEy/MKZvhBc+6dR0lt6/Bv9sT8SYhUX+zdqiMTq/TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Is4aqKY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Is4aqKY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E01F00A3F;
	Mon, 31 Aug 2026 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184245;
	bh=EgQx6EMDMpAmYFSNUpQVpZ8JTwG0WrdXe8NkFgg01Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Is4aqKY9dEN4YCXm/LZfwFu+s2zk65F/kiPQTqvtF5MCrY8PGq1aDKgDdj6DI+pjT
	 06g28oxD6/807/cZCxmQaXrU/t6eBRs389pacmxRIMPR2ArJ/KPJ91kioSq6plWne6
	 aWR+3yF/Bpo5/odErXf7dGRePB9xeNqwCm7QD/M0kAtXDhmjGVhyXZoqpRAnOdOpov
	 IGhiYXY0FQflwa09f2hVfxb/0+tuWrLsZJ4vhldLk9VbQ+NjAAGgt/z6nHOcE9rtGt
	 dKKa16I2OaV9uDPlA2ZONMOvYGa7IktP1f5Av0ZrDYYvBJNsDuE+VlInL7dply6IBi
	 GhkpPb7hzXYMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mac80211: don't call ieee80211_handle_reconfig_failure when not needed
Date: Mon, 31 Aug 2026 09:30:06 -0400
Message-ID: <20260831133314.4125787-578-sashal@kernel.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 7a8a3ff2815501f78f494808355ddf37e08647d0 ]

In case reconfiguration of NAN fails, we call
ieee80211_handle_reconfig_failure, that marks all interfaces as not in
the driver.
Then, at the error path of the reconfig, cfg80211_shutdown_all_interfaces
is called to destroy all the interfaces.

If we have any other interface but the NAN one, for example a BSS
station, then when its state (links, stations) will be removed, we
won't tell the driver about this, because we will think that the
interfaces are not in the driver, and then drivers might remain with
dangling pointers to objects like stations and links (at least for
iwlwifi this is the case).

ieee80211_handle_reconfig_failure is meant to be called after we cleaned
up the state in the driver, there is no reason to call it for NAN
reconfiguration failure.

Fix the code to just warn in such a case, as we do in other error paths
in reconfig where it is too complicated to rewind.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260513182548.6a25f3a0a6ec.I83d1f2a7eed20200a78a62757c6b193e3bab892b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[wifi: mac80211]` `[don't call / fix]` — avoid calling
`ieee80211_handle_reconfig_failure` on NAN reconfiguration failure.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (author)
- `Link: https://patch.msgid.link/20260513182548...` (patch submission)
- `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (mac80211
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

Notable: maintainer sign-off; no syzbot or user bug report.

**Step 1.3 — Body analysis**

Record:
- **Bug:** On NAN reconfig failure,
  `ieee80211_handle_reconfig_failure()` marks all interfaces as not in
  the driver (`IEEE80211_SDATA_IN_DRIVER` cleared). The reconfig error
  path then calls `cfg80211_shutdown_all_interfaces()`, which tears down
  interfaces without notifying the driver because mac80211 thinks they
  are not in the driver.
- **Symptom:** Driver (specifically iwlwifi) can retain dangling
  pointers to stations and links.
- **Root cause:** `ieee80211_handle_reconfig_failure` is meant for use
  after driver state is already cleaned up; calling it mid-NAN-reconfig
  is wrong.
- **Fix approach:** Warn only (`WARN_ON`), matching other reconfig error
  paths that are too hard to unwind.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite the subject not using "fix", this is a real
correctness bug with driver dangling-pointer consequences, not a
cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `net/mac80211/util.c` only (+1 / −5 lines)
- **Function:** `ieee80211_reconfig()`
- **Scope:** Single-file surgical fix in one switch case

**Step 2.2 — Code flow change**

Record:
- **Before:** `ieee80211_reconfig_nan()` failure →
  `ieee80211_handle_reconfig_failure(local)` → `return res` → caller
  invokes `cfg80211_shutdown_all_interfaces()`.
- **After:** `WARN_ON(ieee80211_reconfig_nan(sdata))` → reconfig
  continues; no `handle_reconfig_failure`, no early return.

**Step 2.3 — Bug mechanism**

Record: **Reference-counting / driver-notification bug** (category:
logic/correctness leading to UAF risk).

`ieee80211_handle_reconfig_failure()` at lines 1628–1629 clears
`IEEE80211_SDATA_IN_DRIVER` on all interfaces. `drv_remove_interface()`
and `drv_sta_state()` in `driver-ops.c` gate on
`check_sdata_in_driver()` and return without calling the driver when the
flag is cleared. Shutdown then proceeds without proper driver teardown →
dangling pointers.

**Step 2.4 — Fix quality**

Record:
- Fix is minimal and logically sound.
- Aligns with existing pattern: other reconfig paths use `WARN_ON`
  without calling `handle_reconfig_failure` when unwind is impractical
  (e.g. `drv_add_chanctx`, `drv_join_ibss`).
- Low regression risk; behavior change (no longer aborting full reconfig
  on NAN failure) is intentional and safer than the broken shutdown
  path.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Buggy NAN error path introduced in `167e33f4f68cc` ("mac80211:
Implement add_nan_func and rm_nan_func", 2016-09-20). Present since NAN
support landed; well within 6.18.y scope.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no `Fixes:` tag.

**Step 3.3 — Related file history**

Record: `ieee80211_handle_reconfig_failure` introduced in
`f6837ba8c98af` ("mac80211: handle failed restart/resume better"). NAN
case incorrectly adopted the same pattern in `167e33f4f68cc`. Standalone
one-patch fix (v1 only per b4).

**Step 3.4 — Author context**

Record: Miri Korenblit is an active Intel/mac80211 contributor. Johannes
Berg (subsystem maintainer) committed the fix. No related prerequisite
series.

**Step 3.5 — Dependencies**

Record: **None.** Applies standalone. Mainline diff references
`NL80211_IFTYPE_NAN_DATA` as a fallthrough case, but that iftype does
not exist in this 6.18.y tree — only the `NL80211_IFTYPE_NAN` hunk is
needed for backport.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: b4 dig found thread at https://patch.msgid.link/20260513182548.6
a25f3a0a6ec.I83d1f2a7eed20200a78a62757c6b193e3bab892b@changeid. Single
v1 submission; no replies captured in mbox. No explicit stable
nomination in thread.

**Step 4.2 — Reviewers**

Record: CC'd to `linux-wireless@vger.kernel.org`. Maintainer Johannes
Berg signed off on commit.

**Step 4.3 — Bug report**

Record: No external bug report or syzbot link. Bug identified internally
(Intel iwlwifi).

**Step 4.4 — Series context**

Record: Standalone patch, not part of a multi-patch series.

**Step 4.5 — Stable list**

Record: Not searched on lore stable list; no stable nomination found in
patch thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `ieee80211_reconfig()`, `ieee80211_reconfig_nan()`,
`ieee80211_handle_reconfig_failure()`, `ieee80211_restart_work()`.

**Step 5.2 — Callers**

Record:
- `ieee80211_reconfig()` called from `ieee80211_restart_work()`
  (`main.c:528`) during hardware restart.
- `ieee80211_restart_work` scheduled from `ieee80211_restart_hw()` —
  common iwlwifi recovery path.
- On failure: `cfg80211_shutdown_all_interfaces()` at `main.c:532`.

**Step 5.3 — Callees**

Record: `ieee80211_reconfig_nan()` calls `drv_start_nan()`,
`drv_add_nan_func()`. Failures return `-ENOMEM` or driver error from
`drv_start_nan()`.

**Step 5.4 — Reachability**

Record: Trigger requires hardware restart/resume with a running NAN
interface plus at least one other interface (e.g. STA). Reachable from
driver-initiated `ieee80211_restart_hw()` — not a rare/obscure code path
for WiFi users.

**Step 5.5 — Similar patterns**

Record: Other reconfig steps use `WARN_ON()` without aborting (e.g.
`drv_add_chanctx`, `drv_join_ibss`). The NAN path was an outlier
incorrectly calling `handle_reconfig_failure`.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44` on `stable/linux-6.18.y`.
Buggy code at `net/mac80211/util.c:2057-2062`. Fix commit
`7a8a3ff281550` is **not** an ancestor of HEAD.

**Step 6.2 — Backport complications**

Record: **Clean apply expected.** Only the `NL80211_IFTYPE_NAN` case
changes; no `NAN_DATA` iftype in this tree.

**Step 6.3 — Related fixes already present?**

Record: No equivalent fix in 6.18.y. Related historical commits
(`74430f9489a3b`, `ee06fcb98dcdc`) address different reconfig-failure
aspects.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem criticality**

Record: **net/mac80211** — IMPORTANT (core WiFi stack used by all
mac80211 drivers).

**Step 7.2 — Activity**

Record: Actively maintained in 6.18.y with recent mac80211 stable fixes
(memory safety, MLO, etc.).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users with NAN plus another active interface (STA/AP) on
mac80211 drivers (especially iwlwifi) during hardware restart or resume.

**Step 8.2 — Trigger conditions**

Record: Hardware reconfig (`ieee80211_restart_hw` / resume) while NAN is
running; `ieee80211_reconfig_nan()` returns error (`-ENOMEM` or
`drv_start_nan` failure). Uncommon but realistic on iwlwifi systems
using NAN.

**Step 8.3 — Failure mode severity**

Record: Driver retains dangling pointers to stations/links → subsequent
operations can oops/UAF. **Severity: HIGH** (potential crash; possible
security implications from UAF).

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** HIGH — prevents broken driver teardown during hw restart
- **Risk:** LOW — 6-line change, maintainer-reviewed, matches existing
  WARN_ON patterns
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR:**
- Real bug with verified mechanism in local tree code
- Can cause driver dangling pointers / crash (iwlwifi confirmed by
  author)
- Small, surgical, maintainer-signed fix
- Bug present since 2016; affects 6.18.y
- mac80211 is widely used core infrastructure

**AGAINST:**
- No syzbot or public user report (internal Intel finding)
- Trigger requires NAN + hw restart failure (not everyday)
- Fix changes behavior to continue reconfig on NAN failure rather than
  abort (intentional, safer than broken shutdown)

**UNRESOLVED:** No independent runtime reproduction; relies on code-path
analysis and author/maintainer description.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic verified in code;
   maintainer SOB; no Tested-by
2. Fixes a real bug? **PASS** — incorrect `handle_reconfig_failure` call
   on NAN error path
3. Important issue? **PASS** — driver dangling pointers, potential
   crash/UAF
4. Small and contained? **PASS** — 1 file, ~6 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present; clean
   backport

**Step 9.3 — Exception categories**

Record: Not applicable (standard bug fix).

**Step 9.4 — Decision rationale**

For Linux **6.18.y**, this commit fixes a real mac80211 bug where NAN
reconfiguration failure during hardware restart incorrectly marks all
interfaces as not-in-driver, causing
`cfg80211_shutdown_all_interfaces()` to skip driver notifications and
leave iwlwifi (and potentially other drivers) with dangling station/link
pointers. The fix is minimal, maintainer-approved, and applies cleanly
to this tree.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes/Reported-by/syzbot
- [Phase 2] Diff: `net/mac80211/util.c` NAN case −5/+1; verified
  `handle_reconfig_failure` clears `IEEE80211_SDATA_IN_DRIVER`
  (util.c:1628-1629)
- [Phase 2] Verified `drv_remove_interface`/`drv_sta_state` skip driver
  when flag cleared (driver-ops.c:114-115, 146-147)
- [Phase 2] Verified failure path calls
  `cfg80211_shutdown_all_interfaces` (main.c:531-532)
- [Phase 3] `git blame`: buggy code from `167e33f4f68cc` (2016)
- [Phase 3] `git show f6837ba8c98af`: origin of
  `ieee80211_handle_reconfig_failure`
- [Phase 3] Fix commit `7a8a3ff281550` on master; `git merge-base --is-
  ancestor` → not in 6.18.44
- [Phase 4] `b4 dig -c 7a8a3ff281550`: lore URL found; v1 only
- [Phase 4] `b4 dig -w`: CC linux-wireless; maintainer SOB on commit
- [Phase 4] `b4 dig -m /tmp/nan_fix.mbox`: patch content matches commit
- [Phase 5] `ieee80211_reconfig` called from `ieee80211_restart_work`
  (main.c:528)
- [Phase 5] `ieee80211_reconfig_nan` failure paths: `-ENOMEM`,
  `drv_start_nan` error (util.c:1683-1690)
- [Phase 6] `git describe HEAD` → v6.18.44; buggy code at
  util.c:2057-2062 confirmed
- [Phase 6] `NL80211_IFTYPE_NAN_DATA` absent from
  include/uapi/linux/nl80211.h in this tree
- [Phase 6] Fix not present: `grep WARN_ON(ieee80211_reconfig` → not
  found
- [Phase 8] Failure mode: dangling driver pointers → crash/UAF, severity
  HIGH

**YES**

 net/mac80211/util.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 62e1a37849d04..af99ac02953d9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2055,11 +2055,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			}
 			break;
 		case NL80211_IFTYPE_NAN:
-			res = ieee80211_reconfig_nan(sdata);
-			if (res < 0) {
-				ieee80211_handle_reconfig_failure(local);
-				return res;
-			}
+			WARN_ON(ieee80211_reconfig_nan(sdata));
 			break;
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
-- 
2.53.0

