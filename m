Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C423E549FC4;
	Mon, 19 Oct 2026 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418197; cv=none; b=ftVFtClKF0OjBBL+veGugb8rGXrUyT49w+BxpSTBDluTRJLNe1xhbu7giy73icQlerkFMTObrzTeLWskllHE+58LnxHncQKPxIX10K1DrOuQbAuuJxzrQFVxQ3ewbnvlULV8eymHA21xNotjP6NpgKdc2prrpUja7NWZS52BAuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418197; c=relaxed/simple;
	bh=XKYtZG9jZ3ReqcBRdyDFRva8ElWckOc+6/P9d5PO27Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nWpN1DTzw+VX4lqgX7ro6HVW7NfPbFPLI1pb4tBptNcOEgDn6grf1/W/SwJwF7DAg2popm5bR+fU8yjYd/kya8PJh+4G2WxkPx+uQ2KTaAy/7CeR65SW7sSAQRdkfGd7pT96NKg2WxeA48e2DQYO8Nn8GplKn847fpVT99YfWPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lfqn1lKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lfqn1lKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F171F000C4;
	Mon, 19 Oct 2026 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418194;
	bh=2jrlydWD0ybximvu56ADcj1OMkqBIJuYCWQhhTa9mxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lfqn1lKo4Al6ArAUORpxLDkU9AYoZF/ZUsl6/iGEEAwpl2ecHBxm7bGco4bXUKScz
	 waX0ay3zV+rqdcm9pjWm2CZR3LD87alntU2lu7RCOZyOIqd+jsSb9ylKtTbcq5p5ck
	 oY50PlIa+Pm1L92KRkO09OlSDi09i+1NefDPKIEH7OIr4r9d+1hU5yvGn6rPkFS35D
	 hlJP40tWWcwsOuo+9Z6DzGctw9MDHPu/B0PBuptLRrMGKhEWXZheAabN4PARqRI/M3
	 nk9GmDiBy2AVICJb/MjRDJYXyCwH1mttnFQyewwyDCviwIDqTRg2nCAi4vJTfjbP5G
	 6TL7RaVZr6uFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: mac80211_hwsim: clear PMSR request state on abort
Date: Mon, 19 Oct 2026 09:46:10 -0400
Message-ID: <20261019135441.1420968-79-sashal@kernel.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 37a77bd1395e8261d1760ae39c7f5eb637300550 ]

mac80211_hwsim saves the in-flight cfg80211 PMSR request and its wdev
in data->pmsr_request / data->pmsr_request_wdev when a measurement
starts, and clears them only when it reports completion.

mac80211_hwsim_abort_pmsr() never cleared that saved state. cfg80211
owns the request and frees it once the abort callback returns
(cfg80211_pmsr_process_abort() calls rdev_abort_pmsr() then
kfree(req)), so after an abort data->pmsr_request dangles. A later
hwsim PMSR report then dereferences the freed request in
hwsim_pmsr_report_nl() and completes it; a use-after-free.

Clear data->pmsr_request and data->pmsr_request_wdev once the abort
matches the active request. Move the wmediumd/virtio notification check
below the clear so the saved state is dropped even when no notification
is sent.

Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260708195911.84365-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[wifi: mac80211_hwsim]** **[clear]** in-flight PMSR request
pointers when abort matches, so cfg80211’s free cannot leave a dangling
`data->pmsr_request`.

**Step 1.2: Tags**
Committed message (pipeline-stripped):
- Link: `https://patch.msgid.link/20260708195911.84365-2-
  enderaoelyther@gmail.com`
- Assisted-by: Codex:gpt-5, Claude:opus-4.8
- Signed-off-by: Zhao Li; Johannes Berg
- No Fixes:/Cc: stable/Reported-by in the committed text (expected for
  this pipeline)

Original mailing-list submission (from the saved mbox, not used as
circular “already selected” evidence):
- Fixes: `5530c04c87c5` (“mac80211_hwsim: add PMSR request support via
  virtio”)
- Cc: `stable@vger.kernel.org`
- Cover letter: `[PATCH 0/8] wifi: fix PMSR lifetime and frame
  validation issues`

**Step 1.3: Body**
Record:
- **Bug:** `mac80211_hwsim_abort_pmsr()` never NULLs
  `data->pmsr_request` / `data->pmsr_request_wdev`. cfg80211 owns the
  request and `kfree(req)` after `rdev_abort_pmsr()`.
- **Symptom:** later `hwsim_pmsr_report_nl()` uses the freed request →
  use-after-free. Abort also leaves a non-NULL pointer so a new start
  can see `-EBUSY` forever.
- **Root cause:** abort notifies wmediumd/virtio but does not drop saved
  state; an early `return` when wmediumd/virtio is absent skips even the
  mutex.
- **Version:** not stated in the message. Introduction is v6.4-rc1
  (verified in Phase 3).

**Step 1.4: Hidden bug fix?**
Record: **No.** This is an explicit UAF fix, not cleanup disguised as a
fix.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/net/wireless/virtual/mac80211_hwsim_main.c` (+7 / −3)
- Function: `mac80211_hwsim_abort_pmsr()` only
- Scope: single-file surgical fix

**Step 2.2: Flow change**
Record:
- **Before:** read `data->wmediumd`; if no wmediumd and no virtio,
  **return unlocked** with saved pointers intact. If notification is
  sent, still never NULL the pointers.
- **After:** take the mutex, match `data->pmsr_request == request`, then
  set both pointers to NULL **before** the notification check. Missing
  wmediumd/virtio is `goto out` (unlock), not an early return.

**Step 2.3: Bug mechanism**
Record: **Use-after-free / dangling pointer** (also a lifetime/refcount-
style leak of a cfg80211-owned object). cfg80211 frees the request;
hwsim keeps the pointer; `hwsim_pmsr_report_nl()` later calls
`cfg80211_pmsr_report()` / `cfg80211_pmsr_complete()` on it.

**Step 2.4: Fix quality**
Record: Obviously correct: abort that matches the in-flight request must
drop the saved pointers because cfg80211 will free the object. Mutex
already covers start/abort/report. Regression risk is low: a late report
after abort now hits `if (!data->pmsr_request) return -EINVAL`, which is
the intended post-abort behavior. No API/data-structure change.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: Pre-fix abort body is entirely from **`8ba1da95053e0`**
(“mac80211_hwsim: add PMSR abort support via virtio”, Jaewan Kim,
2023-03-22). Pointers are stored in **`5530c04c87c59`** (start/request
support, same day). First appears in **v6.4-rc1**. Present for a long
time in this lineage.

**Step 3.2: Fixes: target**
Record: Original Fixes: `5530c04c87c5` is an ancestor of HEAD (`git
merge-base --is-ancestor` exit 0). Closest actual miss is abort itself
(`8ba1da95053e0`), also an ancestor. Related: `2bef4d1fb8b34` (NULL
deref in `hwsim_pmsr_report_nl`, 2023) — different bug, already here.

**Step 3.3: File history**
Record: Neighbor `aeea930c7a878` (“authenticate PMSR report senders”) is
series patch 2/8, parent of this commit, **independent** (touches
`hwsim_pmsr_report_nl()`, not abort). File split `340f2ab83a5c9` / move
`f79cbc77abde2` already in this tree. No extra prerequisite for the
abort clear.

**Step 3.4: Author**
Record: Zhao Li is not the wireless maintainer. Same-day sibling is the
report-sender auth patch. Maintainer **Johannes Berg** applied this
commit.

**Step 3.5: Dependencies**
Record: Standalone. Uses existing `data->pmsr_request`, `data->mutex`,
`hwsim_virtio_enabled`. Series 1/8; does not need 2/8–8/8. Can apply
without `aeea930c7a878`.

---

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record:
- Lore URL: https://patch.msgid.link/20260708195911.84365-2-
  enderaoelyther@gmail.com
- Cover: https://patch.msgid.link/20260708195911.84365-1-
  enderaoelyther@gmail.com
- Series: **v1 only** as this patch (`b4 dig -a` “v2” is a different
  nl80211 color-change patch; false match)
- Johannes on the cover (2026-07-21): will take the two hwsim patches
  for **wireless-next**; **“I don’t think hwsim is all that relevant in
  deployed systems.”** Not a NAK of the UAF. He did apply this patch the
  same day.
- No reviewer asked for changes to this hunk. Other series patches
  (probe-resp, S1G TWT) were called out as LLM-pattern issues; **this
  patch was not**.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: linux-wireless, Johannes Berg, Jaewan Kim (original PMSR
author), Intel/Qualcomm/Marvell names, **stable@vger.kernel.org**. Right
lists for a hwsim UAF.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla. Found by review. Cover letter: KASAN hwsim
boot; after the fix, a stale `REPORT_PMSR` got `-EINVAL` with no KASAN
splat. Author-tested, not an external user report.

**Step 4.4: Series**
Record: 8 patches, mixed subsystems. This one is self-contained. 2/8
(sender auth) is a separate spoofing fix, not required to stop the abort
UAF (it only narrows who can fire `hwsim_pmsr_report_nl()`).

**Step 4.5: Stable list**
Record: lore.kernel.org returned HTTP 403 via WebFetch. Original
submission **did** Cc stable. Johannes’s “not relevant in deployed
systems” is the only maintainer comment on hwsim priority. **No NAK and
no “do not backport” found in the mbox.**

---

## Phase 5: Semantic / call chain

**Step 5.1: Functions**
Record: `mac80211_hwsim_abort_pmsr()` only. Consumers of the pointers:
`mac80211_hwsim_start_pmsr()`, `hwsim_pmsr_report_nl()`.

**Step 5.2: Callers**
Record:
- `ieee80211_ops.abort_pmsr` → `drv_abort_pmsr()` →
  `ieee80211_abort_pmsr()` → `rdev_abort_pmsr()` →
  `cfg80211_pmsr_process_abort()` which **then `kfree(req)`**.
- Abort work: `cfg80211_pmsr_free_wk` / `cfg80211_pmsr_wdev_down`.
- Socket teardown: `nl80211` URELEASE → `cfg80211_release_pmsr()`.

**Step 5.3: Callees**
Record: mutex, `genlmsg_new`, `mac80211_hwsim_send_pmsr_request`,
virtio/wmediumd unicast. After the fix, notification is best-effort;
**state drop is not**.

**Step 5.4: Reachability**
Record: Yes, from userspace on this tree:
1. `NL80211_CMD_PEER_MEASUREMENT_START` (`GENL_UNS_ADMIN_PERM`) with
   PMSR capa on an hwsim radio (wmediumd or virtio).
2. Close the nl80211 socket or take the wdev down → abort → cfg80211
   frees `req`.
3. `HWSIM_CMD_REPORT_PMSR` has **no** `GENL_UNS_ADMIN_PERM` (verified at
   the genl op). Combined with a leftover pointer, that is the UAF.
4. Extra path: wmediumd URELEASE sets `data->wmediumd = 0`
   (`hwsim_register_wmediumd(net, 0)`). Old abort **returned
   immediately** and never cleared.

**Step 5.5: Similar patterns**
Record: Same lifetime bug described for iwlwifi MLD in series 3/8
(`mld->ftm_initiator.req` left dangling). hwsim abort was the incomplete
half of start-saves/complete-clears.

---

## Phase 6: This checkout

**Step 6.1: Local tree and buggy code**
Record:
- `git describe HEAD`: **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion`: **7.3.0-rc4**
- Buggy abort (save on start, clear only in `hwsim_pmsr_report_nl()`)
  exists here; pre-image at `37a77bd1395e8^` still has the early return
  and no NULL. Introduced v6.4-rc1; **not after this branch point**.

**Step 6.2: Backport difficulty**
Record: **Clean apply** on this tree’s `mac80211_hwsim_main.c`. Function
and fields (`pmsr_request`, `pmsr_request_wdev`, `mutex`) are present.

**Step 6.3: Related fixes already here**
Record: No earlier abort-clear. `2bef4d1fb8b34` is a different NULL
check. `aeea930c7a878` is sender auth, not this UAF.

---

## Phase 7: Subsystem

**Step 7.1**
Record: **drivers/net/wireless/virtual** (mac80211_hwsim). Kconfig:
“Simulated radio testing tool… not needed for normal wireless LAN
usage.” Criticality: **PERIPHERAL** as hardware, but **IMPORTANT** as a
virtual/test driver shipped as a module and used by
CI/syzkaller/wmediumd.

**Step 7.2**
Record: File is actively developed (NAN, virtio, many 2026 hwsim fixes).
PMSR abort itself has been unchanged since 2023 — a long-standing hole,
not churn from last month.

---

## Phase 8: Impact and risk

**Step 8.1: Who**
Record: Users with `CONFIG_MAC80211_HWSIM` who start PMSR
(wmediumd/virtio) and abort. Not general Wi-Fi laptops. Distros often
ship the module; Android Cuttlefish / mac80211 selftests use it.

**Step 8.2: Trigger**
Record: Start PMSR, then abort (socket close / iface down), then a
report **or** wmediumd disconnect so abort’s old early-return fires.
Needs CAP_NET_ADMIN to **start**; report genl op is unrestricted.
Timing-dependent if wmediumd still reports after abort;
**deterministic** dangling pointer after abort regardless.

**Step 8.3: Failure mode**
Record: **Use-after-free** in `cfg80211_pmsr_report` /
`cfg80211_pmsr_complete` (`req->cookie`, `req->nl_portid`, …). Severity:
**HIGH** (oops/KASAN; possible memory corruption). Secondary: stuck
`-EBUSY` on later PMSR.

**Step 8.4: Risk vs benefit**
Record: Benefit **high** for anyone hitting hwsim PMSR abort (crash).
Risk **very low**: ~10-line pointer clear under an existing mutex. Ratio
favors taking it on this tree.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**
For:
- Real UAF with a traced cfg80211 `kfree(req)` after `rdev_abort_pmsr()`
- Small, obviously correct, mutex-protected
- Bug in this tree since v6.4-rc1
- Standalone; no new API
- Author tested abort-then-report under KASAN
- Wireless maintainer applied it
- Original submission had Fixes: + Cc: stable

Against:
- Test/simulator driver; Johannes said hwsim is not very relevant on
  deployed systems
- No syzbot/external user report
- Start path needs admin + wmediumd/virtio
- LLM-assisted series (maintainer criticized *other* patches, not this
  one)

Unresolved: stable@ lore search (HTTP 403). Does not change the local-
tree technical picture.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** (clear-on-abort; KASAN boot
   described)
2. Real user-visible bug? **PASS** (UAF / oops; also stuck PMSR)
3. Important (crash/security/corruption/deadlock)? **PASS** (UAF → HIGH)
4. Small and contained? **PASS** (+7/−3, one function)
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** (code present; clean)

**Step 9.3: Exceptions**
Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal memory-safety fix.

**Step 9.4: Decision**
This checkout is **v7.3-rc4**. The buggy hwsim PMSR abort path is here.
The patch is a small UAF fix with no prerequisites. Maintainer
skepticism about hwsim on production APs does not make a use-after-free
in this tree’s driver “not a bug.” It should be taken.

---

## What the commit solves for this tree

`mac80211_hwsim` stores cfg80211’s PMSR request in `data->pmsr_request`.
cfg80211 frees that object when abort finishes. This tree’s abort
callback never dropped the pointer (and skipped all cleanup if wmediumd
had already exited). A later `HWSIM_CMD_REPORT_PMSR` dereferences freed
memory. Clearing the two pointers under `data->mutex` when abort matches
is the whole fix.

## Risk vs benefit

Benefit: prevent a KASAN/UAF oops on PMSR abort and allow a later start.
Risk: negligible; notification becomes best-effort after the pointer is
already gone, which is what cfg80211 requires.

## Concerns

None that block this tree: no missing helpers, no series dependency,
file is already `mac80211_hwsim_main.c`. Johannes’s “deployed systems”
comment is priority, not a correctness NAK.

---

## Verification

- **[Phase 1]** Parsed committed tags: Link msgid
  `20260708195911.84365-2`; SOBs Zhao Li + Johannes Berg; no Fixes in
  committed text
- **[Phase 1]** mbox of original mail: Fixes `5530c04c87c5`, Cc: stable
- **[Phase 2]** `git show 37a77bd1395e8`: +7/−3 in
  `mac80211_hwsim_abort_pmsr` only
- **[Phase 2]** Read current abort (lines 3848–3911) and
  `hwsim_pmsr_report_nl` (4213–4277): report uses `data->pmsr_request`
  then NULLs it
- **[Phase 2]** Read `cfg80211_pmsr_process_abort()`:
  `rdev_abort_pmsr()` then `kfree(req)`
- **[Phase 3]** `git blame` on pre-image: abort from `8ba1da95053e0`;
  `git describe --contains` → v6.4-rc1
- **[Phase 3]** `git merge-base --is-ancestor 5530c04c87c59 HEAD` → 0;
  same for `8ba1da95053e0`
- **[Phase 3]** `git log --oneline --grep=pmsr --
  drivers/net/wireless/virtual/`: series neighbor `aeea930c7a878`
  independent
- **[Phase 3]** `git log --oneline -S mac80211_hwsim_abort_pmsr --
  drivers/net/wireless/virtual/`: only intro + this fix
- **[Phase 4]** `b4 dig -c 37a77bd1395e8`: patch.msgid.link `…84365-2`
- **[Phase 4]** `b4 dig -a`: v1 of this patch; “v2” is unrelated nl80211
  color-change
- **[Phase 4]** `b4 dig -w`: linux-wireless, Johannes, Jaewan Kim,
  stable@
- **[Phase 4]** mbox msg from Johannes: wireless-next; hwsim “not all
  that relevant in deployed systems”; no NAK of this diff
- **[Phase 4]** WebFetch lore/stable: HTTP 403 — UNVERIFIED whether it
  was discussed on stable@ beyond original Cc
- **[Phase 5]** Grep: abort wired in `ieee80211_ops`; nl80211 URELEASE
  calls `cfg80211_release_pmsr`
- **[Phase 5]** `HWSIM_CMD_REPORT_PMSR` op has no `GENL_UNS_ADMIN_PERM`;
  `NL80211_CMD_PEER_MEASUREMENT_START` has it
- **[Phase 5]** wmediumd URELEASE zeros portid via
  `hwsim_register_wmediumd(net, 0)`
- **[Phase 6]** `git describe HEAD` v7.3-rc4-27-gf0100363d8c37; Makefile
  7.3.0-rc4
- **[Phase 6]** `git merge-base --is-ancestor 37a77bd1395e8 HEAD` → 0
  (present; judged on merit, not as “already selected”)
- **[Phase 6]** Pre-fix abort still has early return without NULL (shown
  at `37a77bd1395e8^`)
- **[Phase 7]** Kconfig: test tool, module `mac80211_hwsim`
- **[Phase 8]** `cfg80211_pmsr_complete()` derefs `req->cookie` /
  `req->nl_portid` — UAF if abort already freed `req`
- **UNVERIFIED:** How many distro .configs enable `MAC80211_HWSIM` — not
  used to drive the verdict; UAF is in-tree regardless

The fix is small, surgical, and matches stable rules for a real use-
after-free in code this tree has had since v6.4.

**YES**

 drivers/net/wireless/virtual/mac80211_hwsim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 484198766efda..89794c724858c 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3654,9 +3654,6 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
 	int err = 0;
 
 	data = hw->priv;
-	_portid = READ_ONCE(data->wmediumd);
-	if (!_portid && !hwsim_virtio_enabled)
-		return;
 
 	mutex_lock(&data->mutex);
 
@@ -3665,6 +3662,13 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	data->pmsr_request = NULL;
+	data->pmsr_request_wdev = NULL;
+
+	_portid = READ_ONCE(data->wmediumd);
+	if (!_portid && !hwsim_virtio_enabled)
+		goto out;
+
 	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb) {
 		err = -ENOMEM;
-- 
2.53.0

