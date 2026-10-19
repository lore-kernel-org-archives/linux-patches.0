Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649705827B6;
	Mon, 19 Oct 2026 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418417; cv=none; b=Eb/c1EQViFVky5D8jp7QJ4R0VZ102II/oDqppaQnPsbR6lVBuZi73Aduw4KJTGUo0F2YnzhWv8uaeurlHhD8xPET+FjXdHXsfjgvD/urflLRsmyMs5saLPxFcfxZp9HSqcFwwooc3h+ZIgDWghRHMKBosffMcbhvAYvjH5iAVdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418417; c=relaxed/simple;
	bh=+xOolqVHTIjUNje/NBlWqngZewdY5WPe7Cv7eyrJaHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4cYwBns3s8ZW5wnDPi7JSiHklQBAUs0gvsSW6FguptNsPcMCKjU2WyB7J67haHKcEdiqe376hq3YSgIZPJ2jYkgv3RKs3fkyjJiHw+cOpSjNxXiR0cFaB46gyBGIKPVfihf95b7GOZZ63v8RDfxSW963af8AavnlIyEaH8zI8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olOeDOjT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olOeDOjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179181F000CB;
	Mon, 19 Oct 2026 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418414;
	bh=ZBGxOJXU7HjBVpyfzOXs9dH+Zt09Hx8bIDlSjJjZIfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olOeDOjTLuRm4sKwbNu0/Rcpa7GSsMFZTmi2jhIKuEuwf8qC9/FtzeCYUK9PxXZNv
	 hly3hf2uXpxmvtLzM1G/Xbq4ZSndpum6fEsRO+vkjd3lb+IjCsyo5BN3sUh/gmIuER
	 QK9bXf+Ohuslhe/bKz3ygChK+lDQzeG3UXdIlOVESsGblOte11MbmSFO613D9L567u
	 8lencfBzirbJYhHd3nK58hBLlIv+lFe3UxdN1RDDcCY8kbsXjr7WjNed/0wlZtP7cq
	 hGb1OALT8gfNvmmyZVWDYWkzk7KU6bC6evEhNSAm8i9wW3ESvtIfIKSgGsdHZeLJSa
	 NhDXAwXgHtZwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mengyuanlou@net-swift.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: libwx: disable TX VLAN offload for packets with >2 VLAN tags
Date: Mon, 19 Oct 2026 09:48:43 -0400
Message-ID: <20261019135441.1420968-232-sashal@kernel.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit f5cfb576ce39ba5647024c6d6eeb5b7a822fab6e ]

The current hardware does not support TX VLAN offload for packets with
three or more VLAN tags. When such packets are transmitted with hardware
VLAN offload enabled, the hardware may malfunction or produce corrupted
frames.

Add a check in wx_features_check() to parse the VLAN depth of the
skb. If more than two VLAN tags are detected (including both the
hardware tag and in-band tags), strip NETIF_F_HW_VLAN_CTAG_TX and
NETIF_F_HW_VLAN_STAG_TX from the feature set. This forces the
kernel networking stack to handle VLAN insertion in software for
these specific packets, ensuring correct transmission.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/069DF89AA8029189+20260713060441.276612-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The candidate is a hardware-limitation workaround in Wangxun `libwx`: TX
VLAN offload is unsafe for more than two tags and can corrupt frames.
This 7.3-rc4 tree already has `wx_features_check` and the VLAN TX path,
so the rest of the write-up is whether that fix belongs here as a stable
backport.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[net/libwx] [disable] disable TX VLAN offload for packets
  with >2 VLAN tags`
- Subsystem: `net: libwx` (Wangxun shared NIC library used by
  txgbe/ngbe)
- Verb `disable` is a hardware-workaround action, not a feature or
  cleanup

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>` (author;
    Wangxun maintainer)
  - `Link: https://patch.msgid.link/069DF89AA8029189+20260713060441.2766
    12-1-jiawenwu@trustnetic.com`
  - `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev
    maintainer, applied)
  - No `Fixes:` tag (expected for this review pipeline)
  - No `Cc: stable@vger.kernel.org`
  - No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`
  - Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    ...]` (none in the real commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** Wangxun TX VLAN offload does not support three or more VLAN
    tags
  - **Symptom / failure mode:** hardware may malfunction or produce
    **corrupted frames**
  - **Root cause (author):** HW offload still used on >2-tag packets
  - **Fix:** in `wx_features_check()`, count hwaccel + in-band VLAN
    tags; if `vlan_num > 2`, drop `NETIF_F_HW_VLAN_CTAG_TX` and
    `NETIF_F_HW_VLAN_STAG_TX` so the stack inserts in software
  - **Version info in message:** none

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not a disguised cleanup. This is an explicit hardware
  workaround for incorrect TX offload. Intel reviewer Jacob Keller
  treated it as a bug fix that should have gone to `net` with a `Fixes:`
  tag (see Phase 4).

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
- Record:
  - File: `drivers/net/ethernet/wangxun/libwx/wx_lib.c` — **+24 / -0**
  - Function: `wx_features_check()`
  - Scope: single-file surgical addition inside an existing
    `ndo_features_check` hook

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **Before:** `wx_features_check()` only restricted checksum/GSO for
    encapsulated packets; VLAN TX offload was left on for every packet
  - **After:** count `skb_vlan_tag_present()` plus in-band
    `eth_type_vlan()` headers via `skb_header_pointer()`. If more than
    two tags, clear HW VLAN TX features and break
  - Path: per-packet TX feature check (`netif_skb_features()` →
    `ndo_features_check`). Normal TX path, not probe/error-only

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record:
  - Category: **hardware workaround / logic correctness** (not
    UAF/leak/race)
  - Mechanism: HW can insert/offload at most two VLAN tags. With a third
    tag and HW VLAN TX still enabled, the NIC may emit corrupted frames
    or malfunction
  - How the fix works: `validate_xmit_vlan()` in `net/core/dev.c` sees
    VLAN TX offload cleared and calls `__vlan_hwaccel_push_inside()`, so
    the extra tag is inserted in software

**Step 2.4: ASSESS THE FIX QUALITY**
- Record:
  - Obviously correct: this is the standard `ndo_features_check`
    pattern; `skb_header_pointer()` is NULL-safe; loop stops at >2 tags
  - v1 skipped the in-band walk when no hwaccel tag; v2 (applied) always
    walks in-band tags — better
  - Minimal, no API/data-structure change
  - Regression risk: **low**. Extra work only while
    `eth_type_vlan(skb->protocol)` is true. Worst case is extra software
    VLAN insertion, not a new crash path
  - Residual gap (not a reason to reject): VF drivers
    (`txgbevf`/`ngbevf`) use `wx_xmit_frame` but do **not** set
    `ndo_features_check`, so VFs are not covered

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record:
  - New lines are entirely from `f5cfb576ce39b` (this commit)
  - Surrounding `wx_features_check()` introduced by `3b05aa997c491`
    (“net: wangxun: restrict feature flags for tunnel packets”,
    2025-04-22)
  - TX VLAN offload itself: `3403960cdf86c` (“net: wangxun: libwx add tx
    offload functions”, 2023-05-31, in v6.5-rc1)

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Author told Jacob Keller they could not
  identify one. The limitation dates to original TX VLAN offload
  (`3403960cdf86c`), not a later regression. That commit **is** an
  ancestor of this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record:
  - Immediate follow-up: `732ed8f75ce58` “net: libwx: fix FDIR ATR queue
    mismatch for software VLAN packets” — sets `WX_TX_FLAGS_SW_VLAN`
    when VLAN is in-band; has its own `Fixes: b501d261a5b3`. Related
    when more packets take the SW VLAN path, but standalone
  - Not labeled patch X/Y. Standalone 24-line addition
  - Prerequisite in this tree: `wx_features_check()` exists
    (`3b05aa997c491` is an ancestor)

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Jiawen Wu is the Wangxun maintainer (`MAINTAINERS`: `M: Jiawen
  Wu <jiawenwu@trustnetic.com>`). Regular libwx/txgbe/ngbe fixes around
  the same time.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: Depends on `wx_features_check()` / `ndo_features_check`
  (`3b05aa997c491`). Both exist here. Helpers used (`eth_type_vlan`,
  `skb_header_pointer`, `skb_vlan_tag_present`) are long-standing core
  APIs. Can apply standalone on this tree.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - `b4 dig -c f5cfb576ce39b`: [PATCH net-next v2] https://patch.msgid.l
    ink/069DF89AA8029189+20260713060441.276612-1-jiawenwu@trustnetic.com
  - `b4 dig -a`: v1 (2026-07-10) → v2 (2026-07-13, applied)
  - v1 review (Przemek Kitszel): style/logic nits — don’t skip the loop
    when no hwaccel tag; don’t use a dummy parse depth of 8; move the
    `vlan_num > 2` test inside the loop. All addressed in v2
  - v2 review (Jacob Keller): **asked why this went to net-next instead
    of net with a Fixes: tag to the commit that introduced VLAN
    tagging**
  - Author reply: “Probably because I couldn't find a Fixes tag for
    it...”
  - Applied to **netdev/net-next.git** by Jakub Kicinski (patchwork bot,
    2026-07-22)
  - No NAKs; no reviewer objection to the fix itself
  - No explicit `Cc: stable` in the thread (Jacob’s question is the
    stable-relevant signal)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record (`b4 dig -w`): netdev maintainers (Kicinski, Abeni, Dumazet,
  Miller, Horman, Lunn), Wangxun (Jiawen Wu, Duanqiang Wen, Mengyuan
  Lou), Intel NIC reviewers (Jacob Keller, Przemek Kitszel). Right
  audience.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No `Reported-by`, syzbot, or bugzilla. Vendor/maintainer
  hardware-limitation report. Severity from message: corrupted frames /
  hardware malfunction.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Standalone v1/v2 of one patch, not a multi-patch series.
  Follow-up ATR SW-VLAN fix is separate and already in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: **UNVERIFIED** — lore.kernel.org HTTP 403; no local stable@
  discussion found. No evidence it was rejected for stable.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
- Record: `wx_features_check()` only (exported)

**Step 5.2: TRACE CALLERS**
- Record:
  - `txgbe_netdev_ops.ndo_features_check = wx_features_check`
    (`txgbe_main.c`)
  - `ngbe_netdev_ops.ndo_features_check = wx_features_check`
    (`ngbe_main.c`)
  - Core: `netif_skb_features()` → `dev->netdev_ops->ndo_features_check`
    (`net/core/dev.c`)
  - Called from the generic TX validation path (`validate_xmit_skb` /
    `xmit_one`) — userspace-reachable on every transmit for those NICs
  - VF ops use `wx_xmit_frame` but **no** `ndo_features_check` (coverage
    gap)

**Step 5.3: TRACE CALLEES**
- Record: `skb_vlan_tag_present`, `eth_type_vlan`, `skb_header_pointer`
  — read-only skb inspection; no alloc/lock/I/O

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: syscall/send path → qdisc → `validate_xmit_skb()` →
  `netif_skb_features()` → `wx_features_check()` → if VLAN TX bits
  dropped, `validate_xmit_vlan()` software-inserts the tag →
  `wx_xmit_frame()`. Reachable from userspace on Wangxun PF devices.
  Triple-tag is uncommon (QinQ + extra tag) but real.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Many NICs call `vlan_features_check()`, which **keeps** HW
  VLAN TX on multi-tag skbs and only tightens csum features. Wangxun’s
  extra restriction is device-specific (max two tags). Same idea as
  other `ndo_features_check` HW-limit hooks, not a copy of
  `vlan_features_check()`.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record:
  - Local tree: **v7.3-rc4-27-gf0100363d8c37**, `make kernelversion` =
    **7.3.0-rc4**
  - `wx_features_check()` exists; pre-patch body had no VLAN-depth check
    (`git show f5cfb576ce39b^:...`)
  - TX VLAN flags (`WX_TXD_VLE`, `skb_vlan_tag_present` in
    `wx_xmit_frame`) exist since `3403960cdf86c`
  - Candidate **is** already an ancestor of HEAD (already merged here).
    Evaluation is still whether the fix has stable merit for this
    codebase; the pre-fix function is the buggy code

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: **Clean apply** on this tree. Context is the existing
  `wx_features_check()`; no conflicting refactor of that function
  besides this commit and later unrelated wangxun work

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: This fix is in the tree. Related ATR SW-VLAN fix
  `732ed8f75ce58` is also here. No alternate fix of the >2-tag HW limit.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: `drivers/net/ethernet/wangxun/libwx` — **IMPORTANT** for
  Wangxun NIC users (txgbe/ngbe PFs), **PERIPHERAL** vs core mm/net. Not
  staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: Actively developed (2026 wangxun commits: Tx timeout, PCIe
  AER, FDIR, PTP). Author is the maintainer.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: **driver-specific** — CONFIG_TXGBE / CONFIG_NGBE Wangxun PF
  users. Not universal. VFs not covered by this hook.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: TX of a frame with **three or more** VLAN tags (hwaccel + in-
  band) while HW VLAN TX is on. Uncommon vs plain Ethernet; used in
  QinQ/provider/NFV setups. Unprivileged users can send tagged frames if
  the interface/bridge allows it. Not a pure timing race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: Corrupted TX frames and possible hardware malfunction.
  **HIGH** (data corruption on the wire; possible device misbehavior).
  Not a kernel oops, but not cosmetic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record:
  - **Benefit:** high for affected Wangxun users (correct frames; avoid
    HW malfunction)
  - **Risk:** very low (24 lines, feature-bit clear, standard stack
    fallback)
  - **Ratio:** favors backporting

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real HW limit: >2 VLAN tags + HW VLAN TX → corrupted frames /
  malfunction
- Jacob Keller explicitly framed it as a `net` bugfix that needed
  `Fixes:`
- Author is the Wangxun maintainer; netdev maintainers applied it
- Small (+24), contained, no new APIs
- Uses the intended `ndo_features_check` mechanism
- Hardware quirk/workaround class (stable exception)
- `wx_features_check` and VLAN TX offload exist in this tree
- v2 addressed review nits; no NAKs

**AGAINST:**
- Sent to net-next, not `net` (author could not pick a `Fixes:` SHA)
- No public reproducer, crash log, or extra `Reported-by`
- Triple-tag TX is a relatively rare path
- VF devices sharing `wx_xmit_frame` still lack this hook

**UNRESOLVED:**
- No stable@ lore search (HTTP 403)
- “Malfunction” not independently characterized beyond the vendor commit
  message

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — v2 after review; applied by
   Kicinski; logic matches core `validate_xmit_vlan()`
2. Fixes a real bug that affects users? **PASS** — HW TX of >2 VLAN tags
   is wrong and user-triggerable
3. Important issue? **PASS** — on-wire corruption / HW malfunction
   (HIGH, not a core oops)
4. Small and contained? **PASS** — +24 lines, one function
5. No new features or APIs? **PASS** — disables an unsafe offload for
   specific packets
6. Can apply to the local tree? **PASS** — `wx_features_check()`
   present; patch is a clean addition

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: **Hardware quirk/workaround** — disable an offload the NIC
  cannot perform. Same class as USB/PCI/codec quirks.

**Step 9.4: DECISION**

This tree is 7.3.0-rc4 and already contains the Wangxun TX offload path
and `wx_features_check()`. The patch is a small, reviewed workaround for
a vendor-confirmed HW limit that otherwise yields corrupted frames.
Missing `Fixes:`/`Cc: stable` is why it needs manual review, not a
reason to drop it. Jacob Keller’s net-vs-net-next question is the right
classification: this is a bugfix, not a feature.

### What the commit solves for stable users
Wangxun PFs will no longer ask the NIC to hardware-insert/offload a
third VLAN tag. Those packets fall back to software VLAN insertion,
which avoids bad frames and possible device malfunction.

### Risk vs benefit
Benefit is correctness on a real (if uncommon) TX path. Risk is a few
extra header walks and software VLAN push only when tags are already
present.

### Concerns
- Needs `wx_features_check()` (present here)
- Optional companion `732ed8f75ce58` for FDIR ATR on SW-VLAN packets is
  already in this tree
- VFs still omit `ndo_features_check`; that is a remaining gap, not a
  regression from this patch

Verification:
- [Phase 1] Parsed subject/tags/body from `git log -1` / `git show
  f5cfb576ce39b`; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +24 in `wx_features_check()` only; confirmed current
  file at wx_lib.c:3265-3313
- [Phase 2] Confirmed stack fallback: `validate_xmit_vlan()` in
  net/core/dev.c:3971-3977
- [Phase 3] `git blame` on wx_features_check: body from 3b05aa997c491;
  new VLAN loop from f5cfb576ce39b
- [Phase 3] TX offload intro `3403960cdf86c` (v6.5-rc1); `git merge-base
  --is-ancestor` both 3b05aa997c491 and 3403960cdf86c vs HEAD: yes
- [Phase 3] Follow-up 732ed8f75ce58 exists; not a required prereq for
  this hunk
- [Phase 3] Author Jiawen Wu listed as Wangxun maintainer in MAINTAINERS
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1→v2, lore msgid
  069DF89AA8029189+...; Przemek nits on v1; Jacob Keller asked why not
  net+Fixes; author said no Fixes SHA; applied to net-next
- [Phase 4] lore WebFetch 403; v1 retrieved via `b4 mbox`
- [Phase 5] Callers: txgbe_main.c:705, ngbe_main.c:681;
  netif_skb_features in net/core/dev.c:3895-3924
- [Phase 5] VF netdev_ops: ndo_start_xmit=wx_xmit_frame, no
  ndo_features_check
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4; pre-patch function confirmed via `git show
  f5cfb576ce39b^`
- [Phase 8] Failure mode from commit text + HW offload path: corrupted
  frames / malfunction, severity HIGH
- UNVERIFIED: stable@ mailing-list history (lore 403); independent
  crash/reproducer beyond vendor description

**YES**

 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 24 +++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 4a6851612368d..9be339965a683 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -3193,6 +3193,30 @@ netdev_features_t wx_features_check(struct sk_buff *skb,
 				    netdev_features_t features)
 {
 	struct wx *wx = netdev_priv(netdev);
+	__be16 type = skb->protocol;
+	u16 vlan_depth = ETH_HLEN;
+	u32 vlan_num = 0;
+
+	if (skb_vlan_tag_present(skb))
+		vlan_num++;
+
+	while (eth_type_vlan(type)) {
+		struct vlan_hdr vhdr, *vh;
+
+		vh = skb_header_pointer(skb, vlan_depth, sizeof(vhdr), &vhdr);
+		if (unlikely(!vh))
+			break;
+
+		type = vh->h_vlan_encapsulated_proto;
+		vlan_depth += VLAN_HLEN;
+		vlan_num++;
+
+		if (vlan_num > 2) {
+			features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
+				      NETIF_F_HW_VLAN_STAG_TX);
+			break;
+		}
+	}
 
 	if (!skb->encapsulation)
 		return features;
-- 
2.53.0

