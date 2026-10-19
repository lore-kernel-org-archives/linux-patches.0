Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A829A63AC78;
	Mon, 19 Oct 2026 14:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418760; cv=none; b=t3hXBQ6ZwwWWs2aPG8ZRzdaRDyXpC/QKJr+LsuSNY+cdYnVyNEJ74qyaJFXCKeMCcBaV3OexH3EoStWLbcxQX6AMPupWMnCk3OpbLHmWvLlc+dL2YM6C4nnnLLtcuvyHhFOghfzX4J205aJ57QPs92aj/y3Z2E07GGIo6+eTkGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418760; c=relaxed/simple;
	bh=/OllyKuaK9rr8TMjxRThyInFMBFVvyyr5k1dK+s7/fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bezlDsHBdnyTLcfNTI3TWXtBGEfo4YMjeccgfhXWCZvFJGX39jOameQMy3oZC1DkEcqHPPWSJT6pZWYVywaevoru/0bwv2Tpm+OGY6eu2lEeFTZlpU9W6B4WN5JI/39Am72mpIt3pjVEsU7bGvdGTKGYg6wSltw2MyFWljdUpSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pov3Fl5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pov3Fl5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4928E1F000C8;
	Mon, 19 Oct 2026 14:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418757;
	bh=+hnr5cnCaJtPv+XMTDF1DDp93i8WLqg/i31uZJe89tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pov3Fl5un3Fm24nIIzd7YM1J8Vew9JzLYpivCm7jsNewQkKeb5iaVYt2fi4YBO3RC
	 g56jhEvz5wiCJ+C6KprHUrEDm45qssACkP+3/2PoohF+zVxMmHbuLe/R+OkADOfBTO
	 Sev5spqvPn78cMjujmap2bovoqcR7GomjqYYzBCbGl4Tvm8rT5X1DL0kMeKQz0dHkp
	 NpA5iCowEyDXZ5X0/2d2LGh9HZabEBS28WOpvZP8koIUNHP4bUsEdXEJjqJIfvxnfd
	 4AFJKZ2MLEelRitlWZ1bFqEgmOUktLkvNKx4fREvFjO1QYJho80a7I0mLNlusBFvsJ
	 VolHlCRBPiO6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] wifi: mt76: mt7603: restore hardware PS buffering after a service period
Date: Mon, 19 Oct 2026 09:52:45 -0400
Message-ID: <20261019135441.1420968-474-sashal@kernel.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 636a883e2feef5e4ff95695d3c372ceff03960f5 ]

Releasing buffered frames has to turn off the PSE redirect for the
station, otherwise the released frames are looped straight back into the
driver PS queue. Nothing ever turns it back on: mt7603_sta_ps() only runs
on an observed PM bit transition, and MT_WCID_FLAG_PS keeps mt76 from
reporting the same state twice. After the first service period the
hardware therefore treats a dozing station as awake and transmits at it
directly, which is where the retry storms and the packet loss reported
against U-APSD clients come from.

Re-arm hardware buffering from mt7603_mac_work() for every station that
is still known to be asleep, once the PSD queue has drained and the
released frames have passed the redirect stage. Frames that are still
queued belong to the service period that was just served, so unlike on a
sleep transition they must not be pulled back with mt7603_filter_tx().

Track the sleep state separately from the WTBL state, so a station that
wakes up while the re-arm is pending is not put back to sleep.

Link: https://patch.msgid.link/20260801145334.1166751-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this against 5.15.221: the bug is in this tree,
the fix is real, and it needs a small mechanical backport rather than
missing code.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[wifi: mt76: mt7603:] [restore] [re-arm hardware PS buffering
after a U-APSD/PS-Poll service period]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Link: https://patch.msgid.link/20260801145334.1166751-7-nbd@nbd.name`
  — this is **patch 07/10** of Felix Fietkau’s series
- `Signed-off-by: Felix Fietkau <nbd@nbd.name>` — mt76 maintainer
  (ignore any Sasha Levin SOB)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Releasing buffered frames disables PSE redirect
  (`mt7603_wtbl_set_ps(..., false)`). Nothing turns it back on:
  `mt7603_sta_ps()` only runs on a PM-bit edge, and `MT_WCID_FLAG_PS`
  suppresses duplicate notifications.
- **Symptom:** After the first service period the HW treats a dozing STA
  as awake, TX goes to a sleeping radio → **retry storms and packet
  loss** on U-APSD clients.
- **Root cause:** Missing re-arm of hardware PS buffering after an SP;
  sleep state was conflated with WTBL PS state.
- **Fix:** Re-arm from `mt7603_mac_work()` once the PSD queue has
  drained; do not `mt7603_filter_tx()` on that re-arm; track
  `ps_sleeping` separately.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. This is an explicit functional bug fix.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `mac.c`: +~70 / −~7 — split `mt7603_wtbl_set_ps`, add
  `__mt7603_wtbl_set_ps`, `mt7603_wtbl_sta_ps`,
  `mt7603_wtbl_restore_ps`, `mt7603_mac_ps_check`; call it from
  `mt7603_mac_work`
- `main.c`: 1 line — `mt7603_sta_ps()` uses `mt7603_wtbl_sta_ps`
- `mt7603.h`: `u8 ps_sleeping` plus two prototypes
- Scope: **single-driver surgical fix** (~72/7, 3 files)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: `mt7603_wtbl_set_ps(true)` enables PSE redirect + `filter_tx`;
  `false` disables both. `release_buffered_frames` / PS-response TX
  force `false` and never restore.
- After: `sta_ps` also sets `ps_sleeping`. Temporary WTBL-off (SP)
  leaves `ps_sleeping` true. `mac_work` (100 ms) walks stations; if `!ps
  && ps_sleeping` and PSD is empty, re-enables redirect **without**
  pulling in-flight SP frames back via `filter_tx`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / hardware-state correctness.** HW PS filter left off
after an SP. Not UAF/leak/race in the sanitizer sense; it is a driver
state-machine bug with airtime/retry fallout.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Quality is high. `ps_sleeping` is updated under `ps_lock`;
`restore_ps` re-checks it under the same lock so a wakeup cannot put the
STA back to sleep. `filter=false` on restore is required so SP frames
are not recycled. Risk: extra WTBL/PSE MMIO from mac_work (low; only
stations that need re-arm). No public API change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `mt7603_wtbl_set_ps` from `c8846e1015022d` (2019-02-26) — initial
  MT7603 driver, **in this tree**
- The off-without-restore came from `f25e813bf48dce` (2019-03-07) “clear
  ps filtering mode before releasing buffered frames” — **in this tree**
  (`git merge-base --is-ancestor` exit 0). That commit is what made SPs
  work at all; it never re-armed.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Bug-introducing commit is `f25e813bf48dce`,
present here.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Candidate is `636a883e2feef` (not in HEAD). Series around it:
1. `a547b414bf7ea` — **new feature** `MT_DRV_HW_PS_BUFFERING` (other
   chips)
2–3. mt7915/mt7996 MCU PS sync
4. EOSP bit in `mt76_release_buffered_frames`
5. `fix U-APSD service period termination` (mt7603 `main.c`)
6. tell mac80211 when PS queue is empty
7. **this commit**
8. file buffered frames under the reported TID
9–10. mt76 link-id / mt7996 OOB

This commit does **not** call anything those others add. Sibling 4–6 fix
other U-APSD bugs; they are complementary, not compile/runtime
prerequisites.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Felix Fietkau is the mt76 maintainer and original mt7603 author.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Mainline uses `mt76_wcid_ptr` (`dc66a129adf1f`, 2025, **not
here**) and 4-arg `mt7603_filter_tx(dev, sta->vif->idx, idx, ...)`
(`fe0ea395f0a35`, 2023, **not here**). In 5.15, `msta->vif` is **never
assigned**. A correct backport is: 3-arg `mt7603_filter_tx(dev, idx,
false)` and `rcu_dereference(dev->mt76.wcid[i])`. Logic does not need
those later commits.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 636a883e2feef` →
  https://patch.msgid.link/20260801145334.1166751-7-nbd@nbd.name
- Series v1 only (`b4 dig -a`): `[PATCH 01/10] wifi: mt76: add PS
  buffering support for HW-managed TIM drivers`
- Thread: no NAK on patch 07; only kbuild noise on patch 10
  (`ieee80211_txq_aql_pending`), unrelated to mt7603
- lore.kernel.org HTTP 403 for WebFetch/curl; discussion recovered via
  `b4 dig -m`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w`: Felix Fietkau, `linux-wireless@vger.kernel.org`. No
extra Reviewed-by. Author is the subsystem maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: OpenWrt **mt76#1080** (closed 2026-08-01, same day as this
series): MT7628AN AP, iPhone/U-APSD, Wi-Fi “hangs”, thousands of TX
retries, packet loss; workaround was forcing legacy b/g. Related reports
#865, #576, #390, #841, #375, #26. PR #1084: EOSP helped iPhone freezes;
**retries/loss remained as a separate bug**. Commit text matches that
remaining failure (“retry storms and the packet loss reported against
U-APSD clients”).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 10-patch series. 01 is a new mt76 feature; 07 is a standalone
mt7603 HW-PS re-arm. Full iPhone/U-APSD recovery also wants 04–06/08; 07
still fixes a distinct, real bug.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org/stable returned 403.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `mt7603_wtbl_set_ps` → `__mt7603_wtbl_set_ps`; added
`mt7603_wtbl_sta_ps`, `mt7603_wtbl_restore_ps`, `mt7603_mac_ps_check`;
`mt7603_sta_ps`; `mt7603_mac_work`.

**Step 5.2: TRACE CALLERS**
Record (this tree):
- `mt7603_sta_ps` ← `mt76_check_sta()` via `drv->sta_ps` on RX PM-bit
  change
- `mt7603_wtbl_set_ps(false)` still used by
  `mt7603_release_buffered_frames` and `mt7603_tx_prepare_skb` (PS
  response) — those are the paths that drop HW buffering
- `mt7603_mac_work` — delayed work every `MT7603_WATCHDOG_TIME` (100 ms)

**Step 5.3: TRACE CALLEES**
Record: PSE_RTA write + poll, optional `mt7603_filter_tx`, WTBL1
POWER_SAVE bit, `ps_lock`. Restore skips `filter_tx`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace-reachable: STA in PS/U-APSD associated to an
mt7603/MT7628 AP → mac80211 `.release_buffered_frames` / PS-Poll. **Yes,
unprivileged clients trigger this.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same “turn off PS to release frames” exists in `tx_prepare_skb`;
`ps_sleeping` covers that too because it is only cleared on a real wake.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Tree is **5.15.221** (`pending-5.15`,
`p-5.15-2-g6703e5d2f3a29`).
- `mt7603_release_buffered_frames` still does `mt7603_wtbl_set_ps(dev,
  msta, false)` (`main.c:434`)
- `mt76_check_sta` still uses `MT_WCID_FLAG_PS` to skip duplicate
  `sta_ps`
- `636a883e2feef` is **not** an ancestor of HEAD

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: `git show 636a883e2feef | git apply --check` **fails**. Needed
adaptations:
1. `mt7603_filter_tx(dev, sta->vif->idx, idx, false)` →
   `mt7603_filter_tx(dev, idx, false)` (3-arg; `msta->vif` unused here)
2. `mt76_wcid_ptr(dev, i)` → `rcu_dereference(dev->mt76.wcid[i])`
3. `mac_work` context differs (`mt76_tx_status_check` arity,
   `aggr_stats` location) — insertion after `mt7603_edcca_check` is
   still valid

`main.c` hunk and `ps_sleeping` field apply. **Backport difficulty:
minor rework, not a redesign.**

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No `ps_sleeping` / `mac_ps_check` / `wtbl_restore_ps` in this
tree. Older PS commits here (`e004b70066002`, `9dc27bcbe78c5`,
`d55aa5e17461b`) do not re-arm after an SP.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drivers/net/wireless/mediatek/mt76/mt7603** —
**PERIPHERAL/IMPORTANT for that hardware.** MT7603E/MT7628 is common on
low-end APs/routers (`CONFIG_MT7603E`). Not core mm/fs, but AP mode with
phones is a primary use.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (landed 2019). Little 5.15-era churn; the bug is
long-lived.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific:** mt7603/MT7628 in AP mode with power-
save/U-APSD clients (iPhones and similar).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: First PS-Poll or U-APSD SP after the client dozes. Common on
phones (Instagram/video in #1080). Unprivileged associated STAs trigger
it.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **HIGH** (not kernel oops). Retry storms, packet loss, AP
“hangs” vs PS clients; wasted airtime can hurt the whole BSS. Users had
to force legacy b/g.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit: high** for that hardware. **Risk: low–medium**
(contained MMIO + lock; `ps_sleeping` handles races). Blind 4-arg/`vif`
apply would be wrong here; a 3-arg + `rcu_dereference` backport is safe.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real, old bug in this tree (`f25e813bf48dce`, 2019)
- User-visible: retry storms, loss, Wi-Fi hangs with U-APSD/iPhone
  (OpenWrt #1080 and several older issues)
- Small, mt7603-only, maintainer-authored, logic is clear
- Standalone vs series patches 01–06
- Trigger is normal AP + phone PS

**AGAINST:**
- 07/10 in a series that also adds a new mt76 feature
- Does not apply cleanly (filter_tx arity, `mt76_wcid_ptr`, mac_work
  context)
- Full U-APSD repair also wants 04–06; 07 is not the entire story
- Not a kernel crash/security/corruption bug

**UNRESOLVED:** stable@ lore (HTTP 403). No Tested-by on the commit
itself; OpenWrt #1080 was closed the day the series landed.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintainer fix; matches a
   long-standing user report
2. Fixes a real bug that affects users? **PASS**
3. Important issue? **PASS** — AP unusable with PS phones / BSS retry
   storms (HIGH, not oops)
4. Small and contained? **PASS** — ~70 lines, one driver
5. No new features or APIs? **PASS** — internal state + helpers
6. Can apply to the local tree? **PASS** with a small backport (not a
   clean cherry-pick)

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal driver bug fix.

**Step 9.4: MAKE YOUR DECISION**
The buggy “disable PSE redirect on SP, never re-arm” path is in
5.15.221. That is a real AP-mode failure for mt7603/MT7628, not a new-
stack issue. The patch is the right fix and is adaptable without pulling
the HW_PS_BUFFERING feature series.

---

### What the commit solves and why it matters here
After a service period, mt7603 leaves hardware PS buffering off. The AP
then TX’s at a dozing client → retries and loss. That code has been in
this tree since 2019. MT7628 APs with phones hit it in the real world.

### Stable rules
Meets the bar: real bug, contained, no new API. Needs a mechanical
backport (`filter_tx` 3-arg, `rcu_dereference` instead of
`mt76_wcid_ptr`), which is allowed.

### Risk vs benefit
Benefit is high for mt7603 AP users; risk is low if the backport does
**not** use `sta->vif` (unset in 5.15). Sibling EOSP/TIM patches would
help more U-APSD cases but are not required for this re-arm.

### Concerns
Cherry-pick will not apply as-is. Do not copy the 4-argument
`mt7603_filter_tx(..., sta->vif->idx, ...)` call into this tree.

---

Verification:
- [Phase 1] Subject/body/tags: restore HW PS after SP; Link is 07/10;
  maintainer SOB only
- [Phase 2] Diff: ~72/7 in mt7603 mac.c/main.c/mt7603.h; `ps_sleeping` +
  mac_work re-arm
- [Phase 3] `git describe HEAD` / Makefile: 5.15.221, branch
  `pending-5.15`
- [Phase 3] `git merge-base --is-ancestor 636a883e2feef HEAD` → not in
  tree
- [Phase 3] blame: `c8846e1015022d` (driver), `f25e813bf48dce` (clear PS
  before release) — both ancestors of HEAD
- [Phase 3] Related series commits listed; 01 is new feature; 07 does
  not call those APIs
- [Phase 4] `b4 dig -c 636a883e2feef` / `-a` / `-w` / `-m`: lore thread,
  v1-only series, wireless list, no NAK on 07
- [Phase 4] OpenWrt mt76#1080 / #1084: retry storms + iPhone U-APSD;
  issue closed 2026-08-01
- [Phase 5] Callers verified in 5.15: `sta_ps`,
  `release_buffered_frames`, `tx_prepare_skb`, `mac_work` 100 ms
- [Phase 6] Local `mt7603_wtbl_set_ps` / `release_buffered_frames` still
  match the bug; `mt76_wcid_ptr` absent; `filter_tx` is 3-arg;
  `msta->vif` never set
- [Phase 6] `git apply --check` of 636a883e2feef fails on filter_tx/wcid
  helper; main.c hunk would apply
- [Phase 8] Failure mode: retry storms / packet loss / AP hang vs PS
  clients, severity HIGH
- UNVERIFIED: stable@ mailing-list discussion (lore 403)

**YES**

 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 73 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt7603/main.c  |  2 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  4 +
 3 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 6387f9e61060a..85c727fc44e6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -235,16 +235,17 @@ void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	sta->smps = enabled;
 }
 
-void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
-			bool enabled)
+static void
+__mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+		     bool enabled, bool filter)
 {
 	int idx = sta->wcid.idx;
 	u32 addr;
 
-	spin_lock_bh(&dev->ps_lock);
+	lockdep_assert_held(&dev->ps_lock);
 
 	if (sta->ps == enabled)
-		goto out;
+		return;
 
 	mt76_wr(dev, MT_PSE_RTA,
 		FIELD_PREP(MT_PSE_RTA_TAG_ID, idx) |
@@ -255,7 +256,7 @@ void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 
 	mt76_poll(dev, MT_PSE_RTA, MT_PSE_RTA_BUSY, 0, 5000);
 
-	if (enabled)
+	if (enabled && filter)
 		mt7603_filter_tx(dev, sta->vif->idx, idx, false);
 
 	addr = mt7603_wtbl1_addr(idx);
@@ -264,8 +265,34 @@ void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 		 enabled * MT_WTBL1_W3_POWER_SAVE);
 	mt76_clear(dev, MT_WTBL1_OR, MT_WTBL1_OR_PSM_WRITE);
 	sta->ps = enabled;
+}
 
-out:
+void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			bool enabled)
+{
+	spin_lock_bh(&dev->ps_lock);
+	__mt7603_wtbl_set_ps(dev, sta, enabled, enabled);
+	spin_unlock_bh(&dev->ps_lock);
+}
+
+void mt7603_wtbl_sta_ps(struct mt7603_dev *dev, struct mt7603_sta *sta, bool ps)
+{
+	spin_lock_bh(&dev->ps_lock);
+	sta->ps_sleeping = ps;
+	__mt7603_wtbl_set_ps(dev, sta, ps, ps);
+	spin_unlock_bh(&dev->ps_lock);
+}
+
+void mt7603_wtbl_restore_ps(struct mt7603_dev *dev, struct mt7603_sta *sta)
+{
+	spin_lock_bh(&dev->ps_lock);
+	/*
+	 * Frames that are already queued for the station belong to the service
+	 * period that has just been served, so unlike on a sleep transition
+	 * they must not be pulled back into the PS queue.
+	 */
+	if (sta->ps_sleeping)
+		__mt7603_wtbl_set_ps(dev, sta, true, false);
 	spin_unlock_bh(&dev->ps_lock);
 }
 
@@ -1816,6 +1843,39 @@ mt7603_false_cca_check(struct mt7603_dev *dev)
 	mt7603_adjust_sensitivity(dev);
 }
 
+/*
+ * Releasing buffered frames turns off the PSE redirect for a station, since
+ * the released frames would otherwise be looped back into the driver PS queue
+ * again. mac80211 never tells us when the service period is over, so hardware
+ * buffering has to be re-armed here for every station that is still known to
+ * be asleep. Waiting for the PSD queue to drain makes sure that the released
+ * frames have already passed the redirect stage.
+ */
+static void
+mt7603_mac_ps_check(struct mt7603_dev *dev)
+{
+	int i;
+
+	if (dev->mphy.q_tx[MT_TXQ_PSD]->queued)
+		return;
+
+	rcu_read_lock();
+	for (i = 0; i < MT7603_WTBL_STA; i++) {
+		struct mt76_wcid *wcid = mt76_wcid_ptr(dev, i);
+		struct mt7603_sta *msta;
+
+		if (!wcid || !wcid->sta)
+			continue;
+
+		msta = container_of(wcid, struct mt7603_sta, wcid);
+		if (msta->ps || !msta->ps_sleeping)
+			continue;
+
+		mt7603_wtbl_restore_ps(dev, msta);
+	}
+	rcu_read_unlock();
+}
+
 void mt7603_mac_work(struct work_struct *work)
 {
 	struct mt7603_dev *dev = container_of(work, struct mt7603_dev,
@@ -1830,6 +1890,7 @@ void mt7603_mac_work(struct work_struct *work)
 	dev->mphy.mac_work_count++;
 	mt76_update_survey(&dev->mphy);
 	mt7603_edcca_check(dev);
+	mt7603_mac_ps_check(dev);
 
 	for (i = 0, idx = 0; i < 2; i++) {
 		u32 val = mt76_rr(dev, MT_TX_AGG_CNT(i));
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index f8a43d9f72f95..04e3966ab047f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -410,7 +410,7 @@ mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	struct sk_buff_head list;
 
 	mt76_stop_tx_queues(&dev->mphy, sta, true);
-	mt7603_wtbl_set_ps(dev, msta, ps);
+	mt7603_wtbl_sta_ps(dev, msta, ps);
 	if (ps)
 		return;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 55a034ccbacd9..c43ddd3e693c0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -80,6 +80,7 @@ struct mt7603_sta {
 	u8 smps;
 
 	u8 ps;
+	u8 ps_sleeping;
 };
 
 struct mt7603_vif {
@@ -229,6 +230,9 @@ int mt7603_wtbl_set_key(struct mt7603_dev *dev, int wcid,
 			struct ieee80211_key_conf *key);
 void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 			bool enabled);
+void mt7603_wtbl_sta_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			bool ps);
+void mt7603_wtbl_restore_ps(struct mt7603_dev *dev, struct mt7603_sta *sta);
 void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 			  bool enabled);
 void mt7603_filter_tx(struct mt7603_dev *dev, int mac_idx, int idx, bool abort);
-- 
2.53.0

