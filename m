Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C0855549E;
	Mon, 19 Oct 2026 13:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418226; cv=none; b=RlFneO9vSQ/Y/WNtZ71WeJDiKUJELq+q3UHxel9cEJco7AjQfD15o8m9qeNn28p8S5zElKjhzCf4xoc/qlbCptMxAUg4u5TbKmRZa3cjjtjxkYozWs+AKvlqkG+0JTQ2U3IDaugl9CpIjq7HX2EGnG/g+AV0od2QCuvpk3wk4V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418226; c=relaxed/simple;
	bh=O2QtGfa2GeyAFBg0995Q8tsqoiLqdE9ObXYSpyt8mvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m1DYmtTqVPrtkJn5Df8bNYhQBuJfvrPIUREjpYd0bEwANrWJz0FCOW894p2zJ33dYVOaoEV9MWV0pCHTL0fc79KDCQQRyRMD367q99VpG4vYJy2+WIkU7dRuk3TUWyOw38oeBqgMls4EWM5aIH9EODBG7D9X3Syjo+L6oe103NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFcUA9YB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFcUA9YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8CD1F000C6;
	Mon, 19 Oct 2026 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418224;
	bh=bs6aoZXnd5UwjNLgDzr9Pe3S4ulbOQWFZpgOL2xcaMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFcUA9YBU/F4AFQSJuygeGZ2enrNHPBNUXgJ5tNDpMwiUyMjTkgmONQi0rek2+PdL
	 F5xRMTNIdOLSUjpa/+OEnqoyvXU8AyJlOzDDLJPV66iJ/dSBK8lwmSUE6zAdHviRJW
	 Mpszar0wP/TmODBd7sKXoaXv/lz94zESOWqbWFPnU6b5oxAIQkET6rQwcjf2n9pshw
	 V2DcEgnTUsCROMFBYO9DjgSDjXnlBlGF9kZDTQumuzrO47HgTRqjN8oLxShjC1PLrV
	 VvBYqN0frRFKttfxi+i1E0H/NOe2T3uzqE4mn39PHxzSBuIEvGfzsHjxk87Tea/bl/
	 X1BIoHoNU8H5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	jjohnson@kernel.org,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: ath10k: trigger hardware recovery upon rx failures
Date: Mon, 19 Oct 2026 09:46:31 -0400
Message-ID: <20261019135441.1420968-100-sashal@kernel.org>
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

From: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>

[ Upstream commit f78210dd4bea09090b828adc2733cad4b9916306 ]

When an error occurs during RX packet processing (e.g., MSDU done
failure), the driver sets rx_confused and drops all subsequent RX
packets until a Wi-Fi ON/OFF cycle clears the flag. This can leave
the device in a bad state where it cannot process RX data traffic.

Instead of leaving the device in such a state, trigger hardware
recovery so that such an error state can be reset and the device
can function again normally.

Tested-on: WCN3990 hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260710060406.3323260-1-manikanta.pubbisetty@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **Linux 7.3-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
surrounding ath10k RX and recovery code is present, and this is a small,
real device-hang fix.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[wifi/ath10k] [trigger] [start hardware recovery when RX
processing fails instead of leaving the device stuck]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-on:** WCN3990 hw1.0; QCA6174 hw3.2 PCI; QCA6174 hw3.2 SDIO
  (three hardware/firmware combinations)
- **Reviewed-by:** Rameshkumar Sundaram, Baochen Qiang (Qualcomm ath
  reviewers)
- **Acked-by:** none
- **Link:** https://patch.msgid.link/20260710060406.3323260-1-
  manikanta.pubbisetty@oss.qualcomm.com
- **Cc: stable:** none (expected)
- **Signed-off-by:** Manikanta Pubbisetty (author); Jeff Johnson (ath
  maintainer). Ignoring Sasha Levin SOB if present in pipeline copies;
  the tree copy has none.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** On RX processing errors (e.g. MSDU_DONE not set), the driver
  sets `htt->rx_confused` and then drops all further RX until a Wi-Fi
  ON/OFF cycle.
- **Symptom:** Device stays in a bad state and cannot process RX data
  traffic; connectivity is dead until the user toggles the interface.
- **Version info:** none in the message. The FIXME this removes dates to
  2014 (`e0bd7513bbc85`, v3.19-rc1).
- **Root cause:** Error paths mark the ring confused but never reset
  hardware, so the device stays inoperable.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit functional fix:
replace “leave device inoperable” with the existing recovery path. The
removed FIXME said the same thing since 2014.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/ath/ath10k/htt_rx.c` — **3 insertions, 3
  deletions** (`git show --stat`: 6 lines changed).
- Functions: `ath10k_htt_rx_handle_amsdu()`,
  `ath10k_htt_rx_in_ord_ind()` (two sites).
- Scope: single-file surgical error-path change.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
1. `ath10k_htt_rx_handle_amsdu()` when `ath10k_htt_rx_amsdu_pop()`
   returns `< 0`: previously purged skbs, set `rx_confused`, returned.
   Now also calls `ath10k_core_start_recovery(ar)`. FIXME removed.
2. `ath10k_htt_rx_in_ord_ind()` when pop-paddr-list fails: same recovery
   call after `rx_confused = true`.
3. Same function when `ath10k_htt_rx_extract_amsdu()` fails: same
   recovery call after purge + `rx_confused`.

All three are **error paths only**. Normal RX is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / hardware-stuck recovery.** After RX ring corruption
the driver permanently refuses RX (`if (htt->rx_confused) return -EIO`).
Recovery queues `restart_work` → `ath10k_halt()` →
`ieee80211_restart_hw()` → `ath10k_start()` → `ath10k_core_start()` →
`ath10k_htt_rx_alloc()`, which sets `htt->rx_confused = false`. That is
the same recovery used on firmware crash and WMI timeout.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. `ath10k_core_start_recovery()`
only queues work (`queue_work(ar->workqueue_aux,
&ar->recovery_check_work)` in this tree), so it is safe from NAPI.
Existing consecutive-failure logic can WEDGE the device, so this does
not create an infinite restart loop. Risk is a brief firmware restart on
a path that was already dead. No API or data-structure changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Confused-without-reboot behavior introduced in **`e0bd7513bbc85`**
  (“ath10k: refactor htt->rx_confused”, 2014-11-20), first in
  **v3.19-rc1**.
- `handle_amsdu` error path from **`18235664e7f9a`** (Rajkumar
  Manoharan, 2016).
- In-order pop/extract error paths from **`c545070e404bf`** (“ath10k:
  implement rx reorder support”, 2015), v4.1 era.
- Recovery calls added by this commit **`f78210dd4bea0`**.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Historical introducer is `e0bd7513bbc85`
(ancestor of HEAD). `git merge-base --is-ancestor e0bd7513bbc85 HEAD` is
true.

**Step 3.3: CHECK FILE HISTORY**
Record: Related but independent: `7393878255e49` (skb leak on incomplete
MSDU pop) is a different patch/date/msgid. This commit is standalone
`1/1`. No prerequisite refactor in htt_rx.c.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Manikanta Pubbisetty is a Qualcomm ath10k contributor (leak fix
on the same file shortly before). Not the listed maintainer; maintainer
Jeff Johnson applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- `ath10k_core_start_recovery()` exists since **`5dadbe4e3718`**
  (v5.11-rc1) — ancestor of HEAD.
- Current implementation from **`f35a07a4842a8`** (Oct 2025) — ancestor
  of HEAD; queues work, does not block in the caller.
- Can apply standalone on this tree: the function, `rx_confused`, and
  both RX handlers exist.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore/msgid: https://patch.msgid.link/20260710060406.3323260-1-
  manikanta.pubbisetty@oss.qualcomm.com
- `b4 dig -a`: **v1 only**, single patch, no v2/v3.
- Reviews: Baochen Qiang Reviewed-by; Rameshkumar Sundaram “Actual
  change looks fine” + Reviewed-by. No NAKs, no stable nomination, no
  risk flags.
- Jeff Johnson: “Applied, thanks!” (`da5d73e12af2` in ath.git; mainline
  sha `f78210dd4bea0`).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w` original To/Cc: author,
`ath10k@lists.infradead.org`, `linux-wireless@vger.kernel.org`. Applied
by **Jeff Johnson**, listed ATH10K maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Qualcomm Tested-on on three chipsets implies
they hit RX-stuck in product testing, not a theoretical FIXME-only
cleanup.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[ath-next] 1/1`. The earlier skb-leak patch is not
required for this change.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org HTTP fetch returned 403. `b4 dig` thread has no
stable discussion. **UNVERIFIED** whether linux-stable ever discussed
this specific patch; no evidence it was rejected.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `ath10k_htt_rx_handle_amsdu`, `ath10k_htt_rx_in_ord_ind`; callee
`ath10k_core_start_recovery`.

**Step 5.2: TRACE CALLERS**
Record: Both called from `ath10k_htt_txrx_compl_task()` (NAPI poll): in-
order queue then `num_mpdus_ready` loop. On `-EIO` it stops processing.
That is the normal data RX completion path, not init-only.

**Step 5.3: TRACE CALLEES**
Record: `ath10k_core_start_recovery()` → `queue_work(workqueue_aux,
recovery_check_work)` → may `queue_work(workqueue, restart_work)` → halt
+ `ieee80211_restart_hw()`. No lock taken in `start_recovery`.
`in_ord_ind` holds `rx_ring.lock` while queuing work; that is safe.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace/network RX → mac80211 → NAPI → htt_rx. Reachable on
any associated ath10k interface when firmware/DMA delivers a bad MSDU or
corrupted ring. Unprivileged traffic can contribute; the actual trigger
is firmware/hardware RX error, not a crafted syscall.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `ath10k_core_start_recovery()` already used in `pci.c`
(firmware crash), `wmi.c` (command timeout), `sdio.c`/`snoc.c`,
`debug.c`. This patch extends that pattern to RX ring failure. All
`rx_confused = true` sites in htt_rx.c are covered.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` / `make kernelversion`: **7.3.0-rc4**.
- File and functions exist. `rx_confused` still used. Recovery API
  present.
- Bug introduced v3.19; long present in this lineage.
- Working tree already contains `f78210dd4bea0` (`git merge-base --is-
  ancestor` exit 0). That is the mainline commit under review, not a
  reason to treat the bug as absent from this series’ code.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Hunks match this tree’s htt_rx.c. Recovery is the non-blocking
workqueue form. Expected apply: **clean** on a 7.3-era tree that still
has the pre-image; current HEAD is already post-image.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier alternative fix for “reboot on rx_confused”.
`51fc7d74ce4a1` only clears the flag on load. This is the fix that
actually starts recovery.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **drivers/net/wireless/ath/ath10k** — **IMPORTANT** (not core
mm/fs, but QCA6174/WCN3990 are common laptop/phone Wi-Fi). Status in
MAINTAINERS: Supported; maintainer Jeff Johnson.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively maintained (Qualcomm patches through 2026). The stuck-
RX behavior itself is old; the recovery helper is mature.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific**, `CONFIG_ATH10K*`. QCA6174 is widely used in
PCs; WCN3990 on Qualcomm platforms.

**Step 8.2: TRIGGER CONDITIONS**
Record: RX ring pop/extract failure (incomplete MSDU, corrupted ring).
Not every packet; when it hits, RX stays dead until iface toggle. Not a
userspace exploit path.

**Step 8.3: FAILURE MODE SEVERITY**
Record: **Wi-Fi RX permanently stopped** until ON/OFF. Not a panic/UAF,
but the device is inoperable — the 2014 FIXME called it that. Severity
**HIGH** (driver hang / loss of connectivity). Consecutive recovery
failures can WEDGE, which is existing policy, not new.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** Restores Wi-Fi after RX ring confusion without a manual
  toggle; uses the same recovery as firmware crash.
- **Risk:** Very low (3 calls to an existing queue_work helper; error
  paths only). Worst case is a restart of an already-dead radio.
- **Ratio:** Strongly favors taking the fix.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real user-visible bug: all RX dropped until Wi-Fi toggle.
- Acknowledged since 2014 in-tree FIXME.
- Small (3 calls, one file), obviously correct.
- Uses existing, NAPI-safe recovery.
- Tested on three chip/bus combinations.
- Reviewed and applied by ath maintainers; no NAKs.
- All `rx_confused = true` sites updated.
- Code and `ath10k_core_start_recovery()` exist in this 7.3-rc4 tree.

AGAINST:
- Not a crash, UAF, or security bug; workaround exists (iface bounce).
- Trigger is firmware/hardware RX error, not every boot.
- No `Fixes:`/`Cc: stable` (not a negative per the rules).

UNRESOLVED:
- lore.kernel.org WebFetch 403; thread recovered via `b4 dig -m`.
- No independent end-user bugzilla; product Tested-on only.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — three Tested-on lines, two
   Reviewed-by, maintainer applied.
2. Fixes a real bug that affects users? **PASS** — RX stays dead until
   ON/OFF.
3. Important issue? **PASS** — device inoperable / connectivity hang,
   HIGH.
4. Small and contained? **PASS** — 3/3 lines, one file.
5. No new features or APIs? **PASS** — only calls existing recovery.
6. Can apply to the local tree? **PASS** — htt_rx.c and
   `ath10k_core_start_recovery()` match; this tree is 7.3-rc4.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/doc). Qualifies as a normal
bugfix.

**Step 9.4: DECISION**
This tree has the ath10k RX confused paths and the recovery helper.
Leaving `rx_confused` set without restart makes the radio unusable;
kicking `ath10k_core_start_recovery()` is the same response already used
for firmware crash and is safe from NAPI. That is a contained, tested
hang fix appropriate for this tree.

---

## What the commit solves for this tree

When htt RX pop/extract fails, ath10k previously set `rx_confused` and
discarded all later RX until a full Wi-Fi cycle. Users see a dead
receive path. The patch queues the existing hardware restart so
`ath10k_htt_rx_alloc()` clears the flag and the device can RX again.

It meets stable rules: obviously correct, real hang, ~3 lines, no new
API. Benefit is restoring Wi-Fi after ring confusion; risk is a restart
of an already-stuck device.

---

## Verification

- **[Phase 1]** Tags: Tested-on ×3, Reviewed-by ×2, Link msgid; no
  Fixes/Reported-by/Cc:stable.
- **[Phase 2]** `git show --stat f78210dd4bea0`: htt_rx.c +3/-3; three
  `ath10k_core_start_recovery()` calls on error paths; FIXME removed.
- **[Phase 2]** Read `ath10k_core_start_recovery()` at core.c:2534 —
  `queue_work` only.
- **[Phase 2]** Read restart path: `ath10k_core_restart` →
  `ieee80211_restart_hw` → `ath10k_start` → `ath10k_core_start` →
  `ath10k_htt_rx_alloc()` sets `rx_confused = false` (htt_rx.c:796).
- **[Phase 3]** `git log -S` / `git describe --contains e0bd7513bbc85`:
  FIXME from v3.19-rc1.
- **[Phase 3]** `ath10k_core_start_recovery` added in `5dadbe4e3718`
  (v5.11-rc1); ancestor of HEAD.
- **[Phase 3]** `git merge-base --is-ancestor` for f35a07a4842a8,
  5dadbe4e3718, c545070e404bf, e0bd7513bbc85: all 0.
- **[Phase 3]** Related leak commit `7393878255e49` is a separate patch,
  not a prerequisite.
- **[Phase 4]** `b4 dig -c f78210dd4bea0`: msgid
  20260710060406.3323260-1.
- **[Phase 4]** `b4 dig -a`: v1 only.
- **[Phase 4]** `b4 dig -w`: linux-wireless + ath10k lists.
- **[Phase 4]** `b4 dig -m`: Baochen/Rameshkumar Reviewed-by; Jeff
  Johnson applied; no NAK; no Cc:stable in thread.
- **[Phase 4]** WebFetch lore.kernel.org: 403. UNVERIFIED via HTTP;
  thread obtained via b4.
- **[Phase 5]** Callers: `ath10k_htt_txrx_compl_task`
  (htt_rx.c:4382–4395).
- **[Phase 5]** Grep: all three `rx_confused = true` sites got recovery;
  other start_recovery users are pci/wmi/sdio/snoc/debug.
- **[Phase 6]** `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4.
- **[Phase 6]** `git merge-base --is-ancestor f78210dd4bea0 HEAD`: 0
  (commit is in this tree’s history).
- **[Phase 7]** MAINTAINERS: ATH10K Supported, Jeff Johnson.
- **[Phase 8]** Failure mode: RX hung until iface toggle; recovery
  already rate-limited to WEDGED.
- **UNVERIFIED:** linux-stable mailing list (HTTP 403); no public non-
  Qualcomm reproducer.

The fix is small, surgical, and meets the stable criteria for this
7.3-rc4 tree.

**YES**

 drivers/net/wireless/ath/ath10k/htt_rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d7e429041065a..e4162d2faae66 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2345,10 +2345,8 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 	if (ret < 0) {
 		ath10k_warn(ar, "rx ring became corrupted: %d\n", ret);
 		__skb_queue_purge(&amsdu);
-		/* FIXME: It's probably a good idea to reboot the
-		 * device instead of leaving it inoperable.
-		 */
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return ret;
 	}
 
@@ -3313,6 +3311,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 	if (ret < 0) {
 		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return -EIO;
 	}
 
@@ -3346,6 +3345,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
 			htt->rx_confused = true;
 			__skb_queue_purge(&list);
+			ath10k_core_start_recovery(ar);
 			return -EIO;
 		}
 	}
-- 
2.53.0

