Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B77575062;
	Mon, 19 Oct 2026 13:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418307; cv=none; b=ezRgSNalzCMSsOIpliRrq+oi2vwsXwSzDYNQraY6Kwig/ZzEbBH9EEP5c74Yn7EHT3ou+Cyk71E9ah9ekQBC01Ue+Q/vU48+6kBxCeyzihXgpDdykrBduWKkFLNsbBeKeiOdWfd9JCs0R8w10HTRkfmN/5X3n58m7QjS3mKWVlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418307; c=relaxed/simple;
	bh=eSLvGqhDCE0E2quyeayv1HRwmYnO0lNL910FuuT3SaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PRAZLrQbgXuBLGEyfvwVf4oF+/41nG7v2+yRJ05z45O+aQ1HDof5BDmnZgaGbZHJkg/kXsWbZV26iz4XdhR+zwzCu2XMIijwZ6Dxx7rc75O/WAOfYS309ata2Awif5h6yvgPkRnV9v0PSTOkSH5hP3OqOLhoFWlu+WZxsY3ZQ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxEEJsVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxEEJsVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46D91F000C8;
	Mon, 19 Oct 2026 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418304;
	bh=jN5v/XQtD8WXvL1j5Ujlm/7aPTt8CSRn8lW8DKW0kMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxEEJsVAHKvf3bi6yEOZ9WXzI/1zsUR3Q69IMIXPv9lgEAflrO6llnRC/cPYr/quZ
	 m2nei1r8UjEHG0avmWE8/yt0/UUE+2qQvE5dWCjhmYxC+dTiMEdaKYpA7EaKK/6OfV
	 0IzZUCBKmPIpjkQDCycf9xAcXGfTMyjeQrtZcc4p43oTU2dojqMx4zOTwOBhYOu6Gu
	 SZpBUFoBWmaF8mcyW5zfOuRKl/nVuc0wNWIJLa2Dv2vnSQXGE828HCrk9zTBS8VrRv
	 h+ELe2QNcz6xhBJs/F2VvDZ6frRY5Xzki4VDeu+BUrjOK1H/aiiP63L6SB4BqHod6Q
	 HBZjEatEP3omA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rongguang Wei <weirongguang@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	willemdebruijn.kernel@gmail.com,
	jasowangio@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] tap: fix incorrect variable used for USO check in set_offload()
Date: Mon, 19 Oct 2026 09:47:23 -0400
Message-ID: <20261019135441.1420968-152-sashal@kernel.org>
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

From: Rongguang Wei <weirongguang@kylinos.cn>

[ Upstream commit fac7973f004de6dd51fb15a33e33ed37718e58bb ]

The USO features in set_offload() incorrectly uses feature_mask and
features argument.

The USO feature was written to the local features variable instead of
feature_mask. All other offload bits (TSO, TSO_ECN) are stored in
feature_mask which becomes tap->tap_features and is used by
tap_handle_frame() for GSO segmentation. Without NETIF_F_GSO_UDP_L4
in tap->tap_features, making USO on tap effectively non-functional.

Keeping the USO handling inside the TUN_F_CSUM block avoids enabling
GRO/LRO when userspace requests USO without CSUM.

This has not worked since the beginning, so
commit 399e0827642f ("driver/net/tun: Added features for USO.")

Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260807070914.112698-1-clementwei90@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the buggy USO assignment is in this 6.12 tree,
the patch applies, and it is a real offload correctness bug rather than
a crash fix.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[tap] [fix] incorrect variable used for USO check in
set_offload()`
- Subsystem: `tap` (macvtap/ipvtap shared driver, `drivers/net/tap.c`)
- Verb: **fix** — explicit bug fix, not cleanup/refactor

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record (from the commit under review /
`fac7973f004de6dd51fb15a33e33ed37718e58bb`):
- No `Fixes:` tag in the applied commit (the mailing-list v2 had `Fixes:
  399e0827642f`; Jakub rewrote it to prose)
- No `Reported-by:`, `Tested-by:`, `Acked-by:`, `Cc:
  stable@vger.kernel.org`
- `Reviewed-by: Willem de Bruijn <willemb@google.com>` (TUN/TAP
  maintainer)
- `Link:
  https://patch.msgid.link/20260807070914.112698-1-clementwei90@163.com`
- `Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>` (author,
  KylinOS)
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer)
- Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  ignored per instructions

Notable: original `[PATCH net v2]` submission **did** carry `Fixes:
399e0827642f`. Absence of that tag in the applied message is editorial,
not evidence the bug is fictional.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `set_offload()` writes `NETIF_F_GSO_UDP_L4` into the local
  `features` copy instead of `feature_mask`. `tap->tap_features =
  feature_mask`, and `tap_handle_frame()` uses `tap_features` for GSO.
  USO therefore never lands in the forward feature mask.
- **Second bug (same hunk):** the GRO/LRO (`RX_OFFLOADS`) test compares
  `feature_mask` (NETIF_F_* bits) against `TUN_F_USO4|TUN_F_USO6` (ioctl
  flags 0x20/0x40). That comparison is always false.
- **Symptom:** TUNSETOFFLOAD with USO is a no-op. UDP GSO superframes
  are software-segmented before userspace; USO on tap/macvtap/ipvtap has
  never worked.
- **Version info:** “has not worked since the beginning” — introduced by
  `399e0827642f` (v6.2-rc1).
- **Root cause:** wrong destination variable plus type-confused bit
  test.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject, body, and diff all describe a real logic
bug. Not style/cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/tap.c` only
- Scope: **single-file surgical fix**, 2 insertions / 3 deletions (net
  +2 / −3)
- Function: `set_offload()`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record, verified against local `set_offload()` at
`drivers/net/tap.c:952`:

Hunk 1 (USO assignment, inside `if (arg & TUN_F_CSUM)`):
- **Before:** `features |= NETIF_F_GSO_UDP_L4` (`features` is a copy of
  `tap->dev->features`)
- **After:** `feature_mask |= NETIF_F_GSO_UDP_L4` (same place
  TSO/TSO6/CSUM are recorded)
- Path: TUNSETOFFLOAD ioctl, not a hot RX path itself; result is
  consumed on every `tap_handle_frame()` RX.

Hunk 2 (RX_OFFLOADS / GRO+LRO decision):
- **Before:** enable `RX_OFFLOADS` if TSO is in `feature_mask` **or** if
  `feature_mask` has both TUN_F_USO* bits (impossible: those are ioctl
  flags, not netdev features)
- **After:** enable `RX_OFFLOADS` if `feature_mask` has TSO, TSO6,
  **or** `NETIF_F_GSO_UDP_L4`
- USO still only set inside the TUN_F_CSUM block, so USO-without-CSUM
  does not turn on GRO/LRO (v1 regression that v2 closed)

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / correctness** (wrong variable + type-confused bit
test).
- Mechanism: USO bit stored where `update_features()` later sees a
  device-feature snapshot, not in `tap_features`. `tap_handle_frame()`
  then calls `netif_needs_gso()` without `NETIF_F_GSO_UDP_L4`, so every
  `SKB_GSO_UDP_L4` frame is split by `__skb_gso_segment()`.
- The TUN_F_* test vs `feature_mask` is always false: `TUN_F_USO4=0x20`
  is bit 5 (`NETIF_F_HIGHDMA`), `TUN_F_USO6=0x40` is bit 6
  (`NETIF_F_FRAGLIST`). `feature_mask` only ever holds
  HW_CSUM/TSO/TSO_ECN/TSO6.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct; mirrors TSO handling and tun.c’s working USO
path. Minimal, no API change. Regression risk is low: typical QEMU
already sets CSUM+TSO+USO together, so GRO/LRO was already on via TSO.
After the fix, userspace that **asked** for USO actually receives UDP
GSO frames — the documented TUNSETOFFLOAD contract. v2 specifically
avoided enabling GRO/LRO for USO without CSUM.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Both buggy lines introduced by `399e0827642f6` (“driver/net/tun:
Added features for USO.”), Andrew Melnychenko, 2022-12-07. Contained in
v6.2-rc1 (`git describe --contains` → `v6.2-rc1~99^2~30^2~3`). Present
and unchanged in this tree since then (`git merge-base --is-ancestor
399e0827642f HEAD` → yes).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: Applied commit has no `Fixes:` tag; mailing-list v2 named
`399e0827642f`. That commit **is** in this tree. It added USO to both
`tun.c` and `tap.c`; tun.c stores USO in the mask that becomes
`tun->set_features` (works). tap.c used the wrong variable (broken). No
later same-issue fix in `399e0827642f..HEAD -- drivers/net/tap.c`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent tap.c history in this tree is unrelated (XDP skb->dev,
page leaks, short-frame check). On origin/master after this fix: only an
unrelated VLAN `transport_header` change. **Standalone**, not patch N/M.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Author is not the TUN/TAP maintainer (those are Willem de Bruijn
and Jason Wang). `git log --author='Rongguang Wei' -- drivers/net/` in
this tree only shows an unrelated stmmac commit. Reviewer **is** the
subsystem maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Diff uses existing `feature_mask`, `NETIF_F_GSO_UDP_L4`,
`TUN_F_USO4/6`, `RX_OFFLOADS`. `git apply --check` of `fac7973f004de`
succeeded (hunks at offset 92, matching local line numbers). Can apply
standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c fac7973f004de` →
  https://patch.msgid.link/20260807070914.112698-1-clementwei90@163.com
- Series: **v1** (2026-08-05) then **v2** (2026-08-07); v2 is what was
  applied.
- v1 only flipped the RX_OFFLOADS test from `feature_mask` to `arg`
  (incomplete; would enable GRO/LRO while still re-segmenting USO).
- Jakub’s review of v1 (https://lore.kernel.org/netdev/20260806163949.28
  07698-1-kuba@kernel.org/) flagged the **second** wrong-variable bug
  (`features |= NETIF_F_GSO_UDP_L4` vs `feature_mask`) and explicitly
  warned: *“a backporter reading the changelog would likely conclude USO
  on tap works afterwards.”* v2 is the complete fix those backporters
  would expect.
- Willem: Reviewed-by on v1 and again on v2 (“this patch LGTM”). No NAK.
- Patchwork applied it to **netdev/net-next** (`fac7973f004d`), not the
  `net` fixes tree, despite `[PATCH net]`. No reviewer `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Willem de Bruijn (TUN/TAP
maintainer), Jakub Kicinski, Jason Wang, Andrew Lunn, netdev@. Right
people. Willem re-acked v2.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot, bugzilla, or stack trace. Author is at kylinos.cn
(distribution). Impact described by code analysis (Jakub): every USO
superframe is segmented before userspace. Lore WebFetch to
lore.kernel.org returned 403; thread recovered via `b4` mbox instead.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: v1→v2 only; v2 supersedes v1. Willem asked about tun.c; author
checked and tun.c is fine (all offload bits go into one `features`
mask). No companion tun patch required. Later origin/master tap.c change
is unrelated VLAN header handling.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable@ discussion found. UNVERIFIED that nobody requested
this on stable@ (lore.kernel.org/stable WebFetch 403). Absence of
discussion is not a NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `set_offload()` only.

**Step 5.2: TRACE CALLERS**
Record:
- `set_offload()` ← `tap_ioctl()` `TUNSETOFFLOAD`
  (`drivers/net/tap.c:1111-1121`), under `rtnl_lock()`. Userspace ioctl
  on the tap/macvtap/ipvtap fd (QEMU/libvirt typical).
- Consumers of `tap->tap_features`: `tap_handle_frame()`
  (`drivers/net/tap.c:320`), registered as RX handler from
  `macvtap_newlink()` and `ipvtap_newlink()`.

**Step 5.3: TRACE CALLEES**
Record: `rtnl_dereference`, `tap->update_features()`
(`macvtap_update_features` / `ipvtap_update_features` →
`netdev_update_features`). No alloc/lock added by this patch.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace TUNSETOFFLOAD → `set_offload` → `tap_features` → host
RX `tap_handle_frame` → `netif_needs_gso` / `__skb_gso_segment`.
Reachable from QEMU virtio-net on macvtap/ipvtap with IFF_VNET_HDR.
**Yes, userspace-reachable.** Not an interrupt-only or obscure-config
path; `CONFIG_MACVTAP`/`CONFIG_IPVTAP` are common on virt hosts.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: tun.c `set_offload()` correctly does `features |=
NETIF_F_GSO_UDP_L4` then `tun->set_features = features`. macvtap/ipvtap
`TUN_OFFLOADS` still omit `NETIF_F_GSO_UDP_L4` at `newlink`; that only
matters until TUNSETOFFLOAD overwrites `tap_features`. The ioctl path is
the complete fix. No sibling leftover once this lands.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Local tree is **pending-6.12** / `make kernelversion`
**6.12.111** (`git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`).
```977:978:drivers/net/tap.c
                if ((arg & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 |
TUN_F_USO6))
                        features |= NETIF_F_GSO_UDP_L4;
```
```989:990:drivers/net/tap.c
        if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6) ||
            (feature_mask & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 |
TUN_F_USO6))
```
`git merge-base --is-ancestor fac7973f004de HEAD` → **not an ancestor**
(fix not present). Bug introduced v6.2-rc1, well before 6.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** (`git apply --check` succeeded; line offset
only). Surrounding `set_offload()` body matches mainline. No conflicting
6.12 refactor.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `git log --grep='incorrect variable used for USO' --
drivers/net/tap.c` empty. No alternate USO tap fix in this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: Networking TAP/MACVTAP/IPVTAP (`drivers/net/tap.c`).
**IMPORTANT** for virtualization (libvirt macvtap, KVM virtio-net), not
core mm/VFS. Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature. USO addition is from 2022; `set_offload()` logic dates
to the old macvtap path (2013). Low churn in the offload function
itself.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific:** users of macvtap or
ipvtap who issue TUNSETOFFLOAD with both USO4 and USO6 (typical QEMU
virtio-net USO). tun/tap (`drivers/net/tun.c`) already works. Not
universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Userspace sets TUN_F_CSUM|TUN_F_USO4|TUN_F_USO6 (usually with
TSO). Then a GSO UDP packet arrives on the macvtap/ipvtap netdev with
IFF_VNET_HDR. Not a race. Unprivileged user needs the tap fd (VM
process). Common on virt hosts that enable guest USO; silent if nobody
requests USO.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Failure mode:** USO advertised via ioctl does not work; kernel
always software-segments UDP GSO before queueing to userspace. Packets
are still delivered (not a drop/crash on the happy path).
`__skb_gso_segment()` failure can drop a frame
(`SKB_DROP_REASON_SKB_GSO_SEG`). No oops, deadlock, or filesystem
corruption.
**Severity: MEDIUM** — functional/performance offload bug, “oh, that’s
not good,” not CRITICAL.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Medium. Restores a userspace-requested virt offload that
  6.12 already advertises (`TUN_F_USO4/6` accepted by TUNSETOFFLOAD).
  Helps macvtap UDP throughput (VXLAN/QUIC-style workloads). Distro
  author.
- **Risk:** Very low. Two-line logic fix, no locking/API/data-structure
  change, applies cleanly. Behavior change only for fds that **opt in**
  to USO.
- **Ratio:** Benefit outweighs risk for this LTS virt-host kernel.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real, verified logic bug; USO on tap has been a no-op since v6.2, and
  that code is in 6.12.111
- Tiny, obviously correct; matches working tun.c and TSO handling
- TUN/TAP maintainer Reviewed-by; netdev maintainer applied it
- v2 is complete (v1 would have been a bad backport)
- Userspace ioctl already accepts USO flags; this makes the existing ABI
  work
- Applies cleanly; no prerequisites
- KylinOS engineer / virt-relevant path (macvtap)

AGAINST:
- Not a crash, security hole, deadlock, or data-corruption bug
- Feature never worked; this is the first time 6.12 would actually pass
  UDP GSO to tap userspace
- Applied to net-next; Fixes: tag stripped in the git message
- No syzbot/user crash report; four years without a flood of reports
- Performance/offload; segmented delivery still works

UNRESOLVED:
- Could not fetch lore.kernel.org over HTTP (403); used `b4` mbox
  instead
- Could not search stable@ archives the same way (UNVERIFIED no prior
  stable NAK)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — two-line logic fix,
   maintainer Reviewed-by, applied upstream.
2. Fixes a real bug that affects users? **PASS** — TUNSETOFFLOAD USO is
   silently ignored; virt userspace that requests it does not get USO
   frames.
3. Important issue? **PASS** (as “oh, that’s not good” / notable virt
   offload failure) — not crash/security. Official rules also allow that
   class.
4. Small and contained? **PASS** — one function, ~5 lines.
5. No new features or APIs? **PASS** — does not add ioctls or flags;
   implements flags this tree already accepts.
6. Can apply to the local tree? **PASS** — buggy code present; `git
   apply --check` clean.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or doc fix). Qualifies
as a normal small correctness fix.

**Step 9.4: MAKE YOUR DECISION**
This tree is 6.12.y. The bug exists here, the introducing commit is
here, and the fix is self-contained. Stable users of macvtap/ipvtap who
already request USO get a no-op today; backporting restores the intended
offload with negligible regression risk. That meets the 6.12 bar even
though it is not a panic-class bug.

Verification:
- [Phase 1] Parsed subject/tags/body: fix of wrong USO variable;
  Reviewed-by Willem; Link msgid 20260807070914.112698-1; no Cc: stable
  in applied message
- [Phase 2] Diff: `features |= NETIF_F_GSO_UDP_L4` → `feature_mask |=
  ...`; RX_OFFLOADS test uses `NETIF_F_GSO_UDP_L4`. Confirmed against
  `drivers/net/tap.c:952-1003`
- [Phase 2] TUN_F_USO4/6 = 0x20/0x40 vs netdev bits 5/6
  (HIGHDMA/FRAGLIST): check vs feature_mask always false. Confirmed in
  `include/uapi/linux/if_tun.h` and `include/linux/netdev_features.h`
- [Phase 3] `git blame -L 976,990 drivers/net/tap.c`: both lines from
  `399e0827642f6`; `git describe --contains` → v6.2-rc1; ancestor of
  HEAD
- [Phase 3] `git merge-base --is-ancestor fac7973f004de HEAD` → no (fix
  not in this tree)
- [Phase 3] `git show 399e0827642f6 -- drivers/net/tap.c`: original USO
  addition used the wrong variable from day one
- [Phase 3] tun.c `set_offload` correctly stores USO in `features` /
  `set_features` (lines 2938-2950)
- [Phase 4] `b4 dig -c fac7973f004de`: lore thread found; `-a` showed v1
  and v2; `-w` listed Willem/Jakub/Jason/netdev
- [Phase 4] `b4 dig -m /tmp/tap-uso-thread.mbox`: Willem LGTM; tun.c
  checked, no extra patch
- [Phase 4] v1 mbox: only the RX_OFFLOADS `arg` vs `feature_mask` flip;
  incomplete
- [Phase 4] Kuba 20260806163949: identified missing `feature_mask |=
  NETIF_F_GSO_UDP_L4` and warned backporters about a half-fix
- [Phase 5] Callers: `tap_ioctl` TUNSETOFFLOAD; `tap_handle_frame` uses
  `tap_features`; registered from macvtap.c:101 and ipvtap.c:93
- [Phase 5] `netif_needs_gso()` in `include/linux/netdevice.h:5115` —
  GSO skb segmented when features lack that GSO type
- [Phase 6] `git describe HEAD` / `make kernelversion`: p-6.12-3 /
  6.12.111; buggy assignment present at tap.c:978
- [Phase 6] `git show fac7973f004de -- drivers/net/tap.c | git apply
  --check` → hunks succeeded at offset 92
- [Phase 7] MAINTAINERS: TUN/TAP driver, Willem de Bruijn + Jason Wang
- [Phase 8] Failure mode: USO non-functional / extra software GSO, not
  oops; severity MEDIUM
- UNVERIFIED: HTTP lore.kernel.org and lore.kernel.org/stable searches
  (403); content recovered via b4 instead

The problem is a two-line mix-up that makes tap/macvtap/ipvtap USO a no-
op on this 6.12 tree. It meets stable rules: obviously correct, real
bug, small, no new API, applies cleanly. Risk is very low because only
USO-opt-in userspace changes behavior, and that change is the documented
ioctl contract.

**YES**

 drivers/net/tap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1aeaecd4030fa..9eea418afe2fc 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -883,7 +883,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 
 		/* TODO: for now USO4 and USO6 should work simultaneously */
 		if ((arg & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
-			features |= NETIF_F_GSO_UDP_L4;
+			feature_mask |= NETIF_F_GSO_UDP_L4;
 	}
 
 	/* tun/tap driver inverts the usage for TSO offloads, where
@@ -894,8 +894,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * When user space turns off TSO, we turn off GSO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
-	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6) ||
-	    (feature_mask & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
+	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4))
 		features |= RX_OFFLOADS;
 	else
 		features &= ~RX_OFFLOADS;
-- 
2.53.0

