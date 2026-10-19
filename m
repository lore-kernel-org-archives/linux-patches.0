Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6814C502575;
	Mon, 19 Oct 2026 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418168; cv=none; b=Qcs6D7rp1O/iaCNYvAglv6p1I8YyhDWXDGlgvQkVSYIJ1GcKAMU6QjvAyglxge7JtHpsQHBlTGF4cs6Tl5+MYFegTj4o7hVYIZJe/t/fthZsxkmStWssg9NpVNs4nsGHm2imCTkpexUIqbe129tHcMrrOiWq9OjU2mhWbO5w1wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418168; c=relaxed/simple;
	bh=PagkDkatg2vkUjw8ywuAPeJUtrrOOuTOFVOG3JBuNZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sy8BcNSb/iD91DLSGl180JzDkAK+NJ9UXHxpHS86S/YObAHHavHTJU7B+ery9C8LOtfS7fxL7+JNG+jYh0ppvHSp+J2ByWH5GOzFqwUZPy+mjba1ozfJMdMn0hjHbYYjd3HnWLcby0hPBteR5Adl3MCbdamHBFlU1pXOQ45bkEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLtJle2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLtJle2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BED1F000C6;
	Mon, 19 Oct 2026 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418165;
	bh=mtmFXFrqn44bCQ1htm2kFYcTt2aWR/brBgEmJVJnVM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLtJle2C90wBCdUacXK5jcjfvUVGafgYgwI789tD+11rr0II80OdOfnmvyJ5uv/50
	 nivl1HUdD4k0WrkCue8n33h5o+YX8hYaNVcspxtIU7xaarTM7Sf9LPKa6mSZuPzPOO
	 F3RXsz8jRNmJuaE/fuDfNr7tXhltDpLukUt9ZTWj9zEwwEbfZAcb9SgB34D9vh40lx
	 rdQ/HmQyMaqXaGEZBcBC7C8Veq7nNgRxp3R7SdX5DwUVJnTTSLgvhSzkOGaMjscAFh
	 vrTi7/7Im5I/3vb8qG+VUjjlmJuj2bMY40MDsd6bURmx/l3LQObrIrueWsrBsz8zEk
	 hdfMiV+2y3Ujw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Changcheng <chenchangcheng@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] Bluetooth: btrsi: Move set_bt_context after successful HCI registration
Date: Mon, 19 Oct 2026 09:45:49 -0400
Message-ID: <20261019135441.1420968-58-sashal@kernel.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 290a3644609526f7ac12529cd1618042fa5a32db ]

In rsi_hci_attach(), ops->set_bt_context() stores the newly allocated
h_adapter into common->bt_adapter before hci_alloc_dev() and
hci_register_dev() are called. If either of these fails, h_adapter
is freed but common->bt_adapter remains a non-NULL dangling pointer.

This causes a deterministically reachable use-after-free when the
device operates in a BT+WiFi coexistence mode and CONFIG_RSI_COEX
is enabled. The following software-only trigger paths exist:

  1. SDIO driver .remove  (rsi_disconnect)
  2. USB  driver .disconnect (rsi_disconnect)
  3. SDIO driver .shutdown (rsi_shutdown)
  4. Hibernation .freeze  (rsi_freeze)

All four paths check:
    if (IS_ENABLED(CONFIG_RSI_COEX) && coex_mode > 1 && bt_adapter)
        rsi_bt_ops.detach(bt_adapter);  // use-after-free

coex_mode is set during rsi_91x_init(), before rsi_hci_attach() is
called, and is not cleared on attach failure. Since set_bt_context()
already wrote bt_adapter before the failure, the deinit paths see a
non-NULL dangling pointer and proceed to detach it.

Fix this by moving set_bt_context() after hci_register_dev() succeeds.
On failure paths bt_adapter stays NULL, and the deinit callers correctly
skip the detach call.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy
`set_bt_context()` placement is present in `drivers/bluetooth/btrsi.c`,
and the 3-line UAF fix applies here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [Bluetooth/btrsi] [Move] [Call `set_bt_context()` only after
`hci_register_dev()` succeeds so a failed HCI attach does not leave a
dangling `bt_adapter`.]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Chen Changcheng \<chenchangcheng@kylinos.cn\> (author)
- Signed-off-by: Luiz Augusto von Dentz \<luiz.von.dentz@intel.com\>
  (Bluetooth maintainer; applied to bluetooth-next)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable (absence is expected for this review pipeline)
- Upstream object (verified in this repo’s object store, not an ancestor
  of HEAD): `17abcfc57c8a0071e60a56256fbc4428957d22bb`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `rsi_hci_attach()` stores `h_adapter` into `common->bt_adapter`
  via `ops->set_bt_context()` *before* `hci_alloc_dev()` /
  `hci_register_dev()`. On failure it `kfree`s `h_adapter` but leaves
  `bt_adapter` non-NULL.
- Symptom: use-after-free in later detach callers that test `bt_adapter`
  and call `rsi_bt_ops.detach()`.
- Named triggers: SDIO `.remove` (`rsi_disconnect`), USB `.disconnect`
  (`rsi_disconnect`), SDIO `.shutdown` (`rsi_shutdown`), hibernation
  `.freeze` (`rsi_freeze`).
- Root cause: `coex_mode` is set in `rsi_91x_init()` and is not cleared
  on attach failure, so deinit still takes the BT detach path.
- Version info: none in the message. The buggy placement dates to the
  original driver (`38aa4da504837`, v4.17-rc1).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. This is an explicit UAF fix described as such. The
verb “Move” is the mechanism, not a cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/bluetooth/btrsi.c` only (+2 / −1 in the actual commit
  `17abcfc57c8a`; the candidate dump showed extra surrounding context
  including `kzalloc_obj`, which is **not** part of the functional
  change).
- Function: `rsi_hci_attach()`.
- Scope: single-file surgical fix.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: after `kzalloc`, immediately `ops->set_bt_context(priv,
  h_adapter)` (writes `common->bt_adapter`). Then `hci_alloc_dev()` /
  `hci_register_dev()`. Either failure does `goto err` →
  `kfree(h_adapter)` while `bt_adapter` still points at it.
- After: `set_bt_context()` runs only after `hci_register_dev()` returns
  success. Failure paths leave `bt_adapter` NULL (it was never written),
  so deinit skips detach.
- Path affected: HCI attach error path; success path still publishes the
  adapter, just later.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: [USE-AFTER-FREE / dangling pointer] Mechanism: publish-then-free
on error. Fix: publish only after successful registration. Category (d)
memory safety + (g) error-path ordering.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: `rsi_set_bt_context()` is a straight store of
  `common->bt_adapter`; delaying that store until the object is fully
  live is the right lifetime rule.
- Minimal: one call moved, no API/data-structure change.
- Regression risk: low. During `hci_register_dev()`, `bt_adapter` stays
  NULL so `recv_pkt` is skipped (`if (common->bt_adapter)`). HCI
  callbacks use `hci_set_drvdata()`, which is set before register.
  Attach is synchronous in the RX path, so by the next BT packet
  `bt_adapter` is either valid or still NULL.
- Red flags: none.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy `ops->set_bt_context(priv, h_adapter)` at line 120 is from
`38aa4da504837` (“Bluetooth: btrsi: add new rsi bluetooth driver”,
Prameela Rani Garnepudi, 2018-02-27). Contained in v4.17-rc1. Present in
this 6.12 tree (`git merge-base --is-ancestor 38aa4da504837 HEAD`
succeeded).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. The introducing commit is the original driver
add, confirmed by blame.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `btrsi.c` history in this tree is unrelated (unaligned.h
move, HCI_AMP removal, header/comment cleanups, tx timeout). No prior
UAF/`set_bt_context` fix. Standalone; not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Chen Changcheng has no other commits in this tree under
`drivers/bluetooth/`. Luiz von Dentz (who applied it) is the Bluetooth
subsystem maintainer and is active here. Author is not the RSI driver
maintainer; the patch was still taken by the Bluetooth maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: No prerequisites. `set_bt_context` / `rsi_hci_attach` /
`rsi_bt_ops.detach` all exist in this tree. `git apply --check` of
`17abcfc57c8a` succeeded (hunks at offset +10). Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 17abcfc57c8a`: https://patch.msgid.link/20260722083136.1756
  50-1-chenchangcheng@kylinos.cn
- `b4 dig -a`: single v1 series (2026-07-22); no v2/v3.
- Thread: original patch, BlueZ CI bot, patchwork-bot “applied by Luiz”.
  No NAKs. No reviewer-requested respin. No explicit “Cc: stable” in the
  thread.
- Applied to bluetooth-next as `17abcfc57c8a` by Luiz Augusto von Dentz
  (2026-07-23).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Marcel Holtmann, Luiz von Dentz; Cc linux-
bluetooth, linux-kernel. Appropriate Bluetooth maintainers. Luiz applied
it (maintainer SOB). No additional human Reviewed-by in the mbox.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, syzbot, or bugzilla. Bug is explained from code
analysis. BlueZ CI: CheckPatch/BuildKernel/CheckSparse/IncrementalBuild
PASS.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone 1-patch series. No sibling patches required.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No useful stable-list discussion of this fix was found
(lore.kernel.org search 403; web search for site:lore.kernel.org/stable
returned unrelated btrfs hits). UNVERIFIED that nobody previously
rejected it for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `rsi_hci_attach()` only. Related callees/callers used to confirm
the UAF: `rsi_set_bt_context()`, `rsi_hci_detach()`, `rsi_attach_bt()`.

**Step 5.2: TRACE CALLERS**
Record:
- `rsi_hci_attach` is `rsi_bt_ops.attach`.
- `rsi_attach_bt()` in `drivers/net/wireless/rsi/rsi_91x_main.c` calls
  `rsi_bt_ops.attach()` and **only logs** on failure.
- Callers of `rsi_attach_bt()`: RX handler on `BT_CARD_READY_IND`
  (`rsi_91x_main.c`), and deferred attach from mgmt FSM
  (`rsi_91x_mgmt.c`).
- Detach UAF sites (all present here):
  - `rsi_91x_sdio.c` remove (~1226), freeze (~1407), shutdown (~1460)
  - `rsi_91x_usb.c` disconnect (~882)
  - `rsi_91x_main.c` `rsi_91x_deinit()` (~411) — same pattern, not
    listed in the commit message
- Context: probe/firmware-ready path and later remove/shutdown/PM. Not
  IRQ-critical; reachable from device lifecycle.

**Step 5.3: TRACE CALLEES**
Record:
`kzalloc`/`hci_alloc_dev`/`hci_register_dev`/`hci_free_dev`/`kfree`;
`ops->set_bt_context` → `rsi_set_bt_context()` which assigns
`common->bt_adapter = bt_context`. `rsi_hci_detach()` does
`hci_unregister_dev`/`hci_free_dev`/`kfree` on that pointer.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Plug RSI SDIO/USB device with BT+WiFi firmware
(`CONFIG_RSI_COEX`, `coex_mode > 1`) → firmware `BT_CARD_READY_IND` →
`rsi_attach_bt()` → `rsi_hci_attach()`. If `hci_alloc_dev()` or
`hci_register_dev()` fails, `h_adapter` is freed but `bt_adapter`
remains set. Subsequent BT RX packets hit `if (common->bt_adapter)
rsi_bt_ops.recv_pkt(...)` (UAF without waiting for unplug).
Unplug/shutdown/hibernate also UAF in detach. Userspace can trigger the
lifecycle (unplug, reboot, hibernate); the attach failure itself is an
error path (OOM or HCI register failure).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: All `rsi_bt_ops.detach(bt_adapter)` sites share the same
`bt_adapter` NULL-check. No other `set_bt_context` call sites. Same bug
class is concentrated in this one publish point.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `drivers/bluetooth/btrsi.c` lines 119–153:

```119:153:drivers/bluetooth/btrsi.c
        h_adapter->priv = priv;
        ops->set_bt_context(priv, h_adapter);
        h_adapter->proto_ops = ops;
        // ...
        err = hci_register_dev(hdev);
        if (err < 0) {
                BT_ERR("HCI registration failed with errcode %d", err);
                hci_free_dev(hdev);
                goto err;
        }
        return 0;
err:
        h_adapter->hdev = NULL;
        kfree(h_adapter);
```

`rsi_set_bt_context()` assigns `common->bt_adapter`. `coex_mode` is set
in `rsi_91x_init()` (lines 347–366) and is not cleared on attach
failure. Introduced in v4.17; present in 6.12.111.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. `git show 17abcfc57c8a -- drivers/bluetooth/btrsi.c
| git apply --check` succeeded (offset 10). This tree still uses
`kzalloc(sizeof(*h_adapter), GFP_KERNEL)` rather than mainline
`kzalloc_obj`; that line is outside the committed hunks. No conflicting
local changes.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `git log --grep="set_bt_context"` on these files is empty.
`17abcfc57c8a` is **not** an ancestor of HEAD. No alternate fix present.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [Bluetooth HCI driver + RSI 91x WiFi coexistence] [IMPORTANT for
RSI users, PERIPHERAL vs core kernel]. `CONFIG_RSI_COEX` is `default y`
when `RSI_91X && BT`. `BT_HCIRSI` is selected by that. Affects
Redpine/Silicon Labs RS9113-class BT+WiFi modules, not all machines.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: RSI wireless still receives real fixes in this tree (heap OOB,
beacon length, kthread lifetime, memory corruption). Bluetooth stack is
actively maintained. The UAF itself is old (2018), not a new-code issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific + config-specific: RSI 91x with
`CONFIG_RSI_COEX` (default y) in BT coexistence `oper_mode` (`coex_mode
> 1`).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Requires HCI attach failure (`hci_alloc_dev` OOM or
`hci_register_dev` error) after `coex_mode` is already > 1, then either
continued BT RX or remove/shutdown/freeze. Not every boot; once attach
fails, UAF is deterministic. Unprivileged users can unplug USB or
trigger shutdown; they cannot typically force `hci_register_dev` failure
except under memory pressure.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: [Use-after-free of `rsi_hci_adapter`, then
`hci_unregister_dev`/`kfree` on freed memory] [HIGH]. Crash/oops; UAF is
also a memory-safety issue. Not a guaranteed panic on every RSI boot.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit HIGH for affected hardware (prevents UAF/crash on a
reachable error path). Risk VERY LOW (3-line reorder, no locking/API
change, applies cleanly). Ratio strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real UAF: `bt_adapter` published, object freed, later detach/recv uses
  it.
- Confirmed in *this* 6.12.111 tree; introducing commit is an ancestor.
- Multiple concrete deinit paths match the message; `rsi_91x_deinit()`
  is another.
- Attach failure is ignored (`rsi_attach_bt` only logs), so the device
  stays up with a dangling pointer.
- 3-line, obviously correct, Bluetooth maintainer applied it, BlueZ CI
  passed.
- Applies cleanly here; no prerequisites.
- UAF is a standard stable-worthy class.

AGAINST:
- Niche driver (Redpine RSI), not core mm/net.
- Primary trigger is an HCI alloc/register *failure*, not the happy
  path.
- No syzbot/user crash report; found by code inspection.
- No Fixes:/Cc: stable (expected; not a negative).
- No extra human Reviewed-by beyond maintainer application.

UNRESOLVED:
- No stable-list history found (lore.kernel.org 403; search noise).
- Could not walk descendants of `17abcfc57c8a` without forbidden
  `--all`; no evidence of a follow-up is needed for this standalone
  reorder.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — lifetime reorder; applied by
   Luiz; CI PASS.
2. Fixes a real bug that affects users? **PASS** — UAF on RSI BT+WiFi
   coexistence after failed HCI attach, then unplug/shutdown/hibernate
   or further BT RX.
3. Important issue? **PASS** — UAF / crash (HIGH). Not a style change.
4. Small and contained? **PASS** — 3 lines, one function, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. It qualifies as a
normal UAF bug fix.

**Step 9.4: MAKE YOUR DECISION**
This is a small, correct UAF fix for code that has been in tree since
v4.17 and is still buggy in 6.12.111. Benefit outweighs risk.

------------------------------------------------
What the commit solves for stable users
------------------------------------------------
On RSI 91x BT+WiFi coexistence, a failed HCI attach currently leaves
`common->bt_adapter` pointing at freed memory. Later disconnect,
shutdown, freeze, deinit, or even the next BT packet will use that
pointer. Moving `set_bt_context()` until after successful
`hci_register_dev()` keeps `bt_adapter` NULL on failure so those paths
skip detach/recv.

It meets stable rules: real UAF, small, no new API, applies cleanly, low
regression risk.

------------------------------------------------
Verification
------------------------------------------------
- [Phase 1] `git describe HEAD` / `make kernelversion`:
  `p-6.12-3-g710455e2077bb`, **6.12.111**, branch `pending-6.12`.
- [Phase 1] Parsed tags: author + Luiz SOBs only; no Fixes/Reported-
  by/Cc: stable.
- [Phase 2] Actual upstream commit `17abcfc57c8a`: +2/−1 in
  `rsi_hci_attach()`; candidate dump’s `kzalloc_obj` is surrounding
  mainline context, not the fix.
- [Phase 3] `git blame drivers/bluetooth/btrsi.c` lines 109–154:
  `38aa4da504837` (v4.17-rc1).
- [Phase 3] `git merge-base --is-ancestor 38aa4da504837 HEAD`: yes. `git
  merge-base --is-ancestor 17abcfc57c8a HEAD`: no (fix not in this
  tree).
- [Phase 3] No related `set_bt_context` history in this tree.
- [Phase 4] `b4 dig -c 17abcfc57c8a`: lore msgid
  `20260722083136.175650-1-chenchangcheng@kylinos.cn`; v1 only; To
  Luiz/Marcel.
- [Phase 4] Saved mbox: CI PASS; patchwork-bot applied by Luiz; no NAK.
- [Phase 4] lore.kernel.org WebFetch 403; spinics 500 — used b4 mbox
  instead.
- [Phase 5] Callers verified in `rsi_91x_main.c`, `rsi_91x_mgmt.c`,
  `rsi_91x_sdio.c`, `rsi_91x_usb.c`; `rsi_set_bt_context()` writes
  `common->bt_adapter`.
- [Phase 6] Buggy `set_bt_context` still at line 120 of this tree’s
  `btrsi.c`.
- [Phase 6] `git apply --check` of `17abcfc57c8a`: succeeded (offset
  10).
- [Phase 7] `CONFIG_RSI_COEX` default y in
  `drivers/net/wireless/rsi/Kconfig`.
- [Phase 8] Failure mode: UAF → oops / memory safety, severity HIGH;
  trigger is attach-failure then deinit/RX.
- UNVERIFIED: later mainline follow-ups after `17abcfc57c8a` (no
  `--all`); no stable-list discussion.

**YES**

 drivers/bluetooth/btrsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
index 6c1f584c8a337..0e2894e93e82e 100644
--- a/drivers/bluetooth/btrsi.c
+++ b/drivers/bluetooth/btrsi.c
@@ -117,7 +117,6 @@ static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
 		return -ENOMEM;
 
 	h_adapter->priv = priv;
-	ops->set_bt_context(priv, h_adapter);
 	h_adapter->proto_ops = ops;
 
 	hdev = hci_alloc_dev();
@@ -146,6 +145,8 @@ static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
 		goto err;
 	}
 
+	ops->set_bt_context(priv, h_adapter);
+
 	return 0;
 err:
 	h_adapter->hdev = NULL;
-- 
2.53.0

