Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98F6621505;
	Mon, 19 Oct 2026 14:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418683; cv=none; b=l70Qf47RsxSFARAZg7JXuKFemmUpqHJIIXmb+WmqFD216lPoeOCom78Br+/8xbMHXLraCTMPfgiZxui/OyJ5ujLkKFZS1C2zTisjYHNwAUYwcloxUdRd5srPGequAXywYLQ6rxZT6He6m05zznZqirAEWDsB8/U9or2GRFnd8Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418683; c=relaxed/simple;
	bh=GBPku60R2y3boWA+imjMNAAs0VVD1lQgUGv/Vo/Fyp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GsLVszVshuXAFbcMfNYev5eu0GAOzgopx9yoEk2js+CSGksGEI0f/OxHc5FixbphrGLY7gnGt2DDI6i/XgBY0Zx/xiNS+Y+HjbyeW0CMnUnwjGqVQJZ4hMEMThKAOtLnO6Rxi/VdR2ZG11rOJJnMdBnQL/JYp1uP6lM1C//TjHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmmUh9J5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmmUh9J5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2C41F000C5;
	Mon, 19 Oct 2026 14:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418680;
	bh=w9tYo1ePiywHlsnDPw2BYj7IYsINTi3MQ626nFcaKGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmmUh9J5MNelStFykMUhj8x9GoR8t9pqXQ+TRzVvBg7Jowxk6Y4lBiP1AjjGU5in0
	 fXCeEpTldbAd5Shby84u9tvZii/CPJXf4o+5ilEFCQMQ5fXNRT+3XkWAptxjBdgdPb
	 cHLcNvIGFVoNakjji/Y2SZ+N3GLLJ3wHOXJy2X5BHE3MaANQJK3SRtnd4tlh+5jVFj
	 UIcp7aEgM2JMPWIlaij7PYj4i5O6M9M8/g7ViiLjdRK0S+tMxHOJ3gzPR8nPlAP+eA
	 gv6zle60pL+VzFTSrhv/WPs/voXxw+ar7vMEjx9Fqrdcgmnkhgx6Xk4n1bZU0hWy9d
	 i2QS0q3ZfEikQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johan Alvarado <contact@c127.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	maxime.chevallier@bootlin.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] net: stmmac: raise TX completion interrupt at the end of an xmit burst
Date: Mon, 19 Oct 2026 09:51:51 -0400
Message-ID: <20261019135441.1420968-420-sashal@kernel.org>
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

From: Johan Alvarado <contact@c127.dev>

[ Upstream commit d21a374995df9d7cfd193427748a19dcc87956a9 ]

The TX mitigation logic only sets the Interrupt on Completion bit once
every tx_coal_frames descriptors (STMMAC_TX_FRAMES = 25), with the
tx_coal_timer hrtimer (STMMAC_COAL_TX_TIMER = 5000 us) as the only
fallback. TX skbs are freed exclusively from the TX completion path,
so any flow that keeps fewer than 25 frames in flight has all of its
skbs held for up to 5 ms after transmission.

Paced flows never queue enough frames to reach the frame threshold:
TCP Small Queues caps the amount of unfreed data at roughly two pacing
intervals worth, which at moderate pacing rates is only a couple of
packets. Every small burst then stalls until the coalesce timer fires,
and throughput collapses to approximately tsq_limit / tx_coal_timer
regardless of link capacity.

This is easily reproducible with BBR, which paces its output and thus
keeps only a few frames in flight at a time. On a YT6801
(dwmac-motorcomm) equipped Orange Pi 5 Pro, a BBR upload over a ~23 ms
RTT path is capped at 5.24 Mbit/s, while CUBIC reaches 207 Mbit/s on
the same path. BBR measures the stalled send rate as the path
bandwidth and locks its estimate near the floor, so the connection
never recovers. Lowering the coalesce settings with ethtool -C
(tx-usecs 100 tx-frames 1) lifts the same transfer to 447 Mbit/s,
confirming the mechanism.

Fix this by setting the IC bit on the last descriptor of every xmit
burst, i.e. whenever netdev_xmit_more() reports that no further frames
are pending in the current dequeue batch. Frame-based coalescing still
applies within a burst, bulk traffic keeps batching through qdisc bulk
dequeue and NAPI polling, and the coalesce timer becomes a pure
fallback instead of the primary completion mechanism for lightly
queued flows.

tx-frames 0 keeps its meaning of timer-based mitigation only.

Signed-off-by: Johan Alvarado <contact@c127.dev>
Link: https://patch.msgid.link/20260731194522.55069-1-contact@c127.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111**. The TX-coalesce stall is in this
checkout; the four-line IC-on-burst-end change is a real, tested fix for
a severe paced-TCP collapse on stmmac.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [net: stmmac] [raise] [set TX Interrupt-on-Completion on the
last descriptor of each xmit burst so lightly queued/paced flows are not
stuck on the 5 ms coalesce timer]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Link: https://patch.msgid.link/20260731194522.55069-1-contact@c127.dev
- Signed-off-by: Johan Alvarado \<contact@c127.dev\> (author)
- Signed-off-by: Jakub Kicinski \<kuba@kernel.org\> (netdev maintainer,
  applied)
- No Reported-by / Tested-by / Reviewed-by / Acked-by / Cc: stable in
  the committed message
- No Fixes: in the committed message (expected for this pipeline)

Original mailing-list submission (v1 and RESEND) DID carry:
- Fixes: da2024510031 ("net: stmmac: Tune-up default coalesce settings")
That tag is treated as technical evidence of the introducing commit, not
as a “already selected for stable” marker.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: TX IC is set only every `tx_coal_frames` descriptors (default
  25). The 5 ms `tx_coal_timer` is the only fallback. TX skbs are freed
  only from the completion path, so a flow with fewer than 25 frames in
  flight holds those skbs for up to 5 ms.
- Symptom: TCP Small Queues + pacing (BBR) never queues 25 frames. Each
  small burst waits for the timer. Throughput collapses to ~tsq_limit /
  tx_coal_timer. BBR then treats that stalled rate as path bandwidth and
  never recovers.
- Measured on Orange Pi 5 Pro / YT6801: BBR 5.24 Mbit/s vs CUBIC 207
  Mbit/s; ethtool `-C tx-usecs 100 tx-frames 1` raises the same transfer
  to 447 Mbit/s.
- Root cause: coalescing designed for deep queues; lightly queued flows
  only complete via the timer.
- Fix: set IC when `!netdev_xmit_more()` (end of current dequeue batch).
  Frame coalescing still applies inside a burst; `tx-frames 0` stays
  timer-only.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. Submitted as `[PATCH net]` (bugfix
tree, not net-next). It is a logic/correctness fix for TX completion
starvation interacting with TSQ, not a style change.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/net/ethernet/stmicro/stmmac/stmmac_main.c`
- +4 / −0 (two identical two-line insertions)
- Functions: `stmmac_tso_xmit()`, `stmmac_xmit()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before (both functions): set_ic if HW timestamp, else if
  `tx_coal_frames==0` never set IC, else if this skb’s descriptor count
  exceeds the threshold, else if the running modulo wrapped, else false.
  Then arm the 5 ms timer.
- After: same, plus `else if (!netdev_xmit_more()) set_ic = true`
  immediately after the `tx_coal_frames==0` check, so the last skb of a
  dequeue batch gets IC unless the user asked for timer-only (`tx-frames
  0`).
- Path: normal `ndo_start_xmit`, not an error/init path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic / correctness (TX completion starvation vs TCP Small
  Queues)
- Mechanism: IC density was bounded by frame count only. Paced flows
  never reach 25 in-flight frames, so completion waits for the hrtimer.
  TSQ will not queue more until skbs are freed, so send rate is timer-
  capped. Setting IC on burst end completes those skbs promptly; intra-
  burst coalescing and the timer remain as fallback.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: `netdev_xmit_more()` is the standard “more packets
  in this dequeue” signal; many other NIC drivers already use it this
  way. Placement after `!tx_coal_frames` preserves timer-only mode.
- Minimal: four lines, no API/data-structure change.
- Regression risk: more TX IRQs on short bursts. Author measured ~3.3k
  IRQs/s (~12 packets/IRQ) at 447 Mbit/s. Bulk traffic still coalesces
  inside qdisc bulk dequeue / TSO. XSK/XDP paths intentionally unchanged
  (`netdev_xmit_more()` is not meaningful there; no TSQ). Maciej
  Fijalkowski asked whether coalescing could be dropped entirely; the
  author kept the frame bound so a bulk batch larger than the ring
  cannot drain with zero IC bits. Low regression risk.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Core IC logic: c2837423cb5455 (“net: stmmac: Rework TX Coalesce
  logic”, 2019-11-14)
- `!tx_coal_frames` / per-queue threshold: db2f2842e6f560 (2021-03-17)
- Default TX_FRAMES 1→25: da2024510031 (v5.5-rc1, 2019-11) — this is
  what made “every frame gets IC” into “every 25 descriptors”
- Timer 1 ms→5 ms: 039550960a223 (2023-10-19), present in this tree —
  same stall, worse ceiling
- Buggy pattern has been in tree since ~v5.5; this is long-standing, not
  new-in-6.13+ code

Step 3.2: FOLLOW THE FIXES: TAG
Record:
- Original submission tagged Fixes: da2024510031
- `git merge-base --is-ancestor da2024510031 HEAD` → yes (exit 0)
- That commit only retuned defaults (`STMMAC_TX_FRAMES` 1→25). Combined
  with timer-only fallback, that is exactly the stall.
- Intermediate related work already in this tree: c2837423cb5455
  (rework), 2d1a42cf7f77c (timer arm vs NAPI, 2023), 039550960a223 (5 ms
  timer). None of those set IC at burst end.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent `stmmac_main.c` work is TSO descriptor checks, PTP lock init,
  XDP, etc. Nothing equivalent to this IC-on-burst-end change.
- `git log --grep=netdev_xmit_more --
  drivers/net/ethernet/stmicro/stmmac/` → empty; the helper is unused in
  stmmac here.
- Standalone 4-line fix, not patch N/M.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Johan Alvarado has no prior stmmac commits in this tree (end-user
  reporter/fixer, not the subsystem maintainer).
- Maintainers CC’d on the list: Alexandre Torgue, Jose Abreu. Applied by
  Jakub Kicinski.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Needs `netdev_xmit_more()` — present in `include/linux/netdevice.h`
  (this tree).
- Needs the existing `set_ic` / `stmmac_set_tx_ic` / `tx_coal_frames`
  block — present in both xmit paths.
- Mainline context uses `CIRC_CNT` / `stmmac_get_tx_desc`; those helpers
  are not required. The added lines sit in context that is identical
  here:
  `else if (!priv->tx_coal_frames[queue]) set_ic = false;`
- Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 dig on the msgid did not resolve a local commit (this SHA is not in
  the 6.12 checkout). Fallback: openwall + patchew.
- v1: 2026-07-06, Message-ID `0100019f35ea26e0-42ad009c-01ab-4a8f-b126-
  fa65fbacae5c-000000@email.amazonses.com`
- RESEND: 2026-07-31, msgid `20260731194522.55069-1-contact@c127.dev`
  after netdev queue overflow (Jakub asked for a repost). Author: no
  code changes vs v1.
- Reviewer Maciej Fijalkowski: agreed each TX batch should get IC at the
  end; asked if coalescing could be dropped. Author explained why the
  frame bound must stay (ring-full with xmit_more set on every frame
  until the queue stops → zero IC → timer stall on the bulk path). Kept
  the patch minimal for `net`.
- No NAK. No reviewer concern that the change is unsafe for the IC-on-
  burst-end approach.
- No explicit “Cc: stable” in the thread. Submitted to `net` as a
  bugfix.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record:
- To/Cc: netdev maintainers (Kicinski, Abeni, Dumazet, Daleck, Lunn),
  stmmac (Torgue, Abreu, Coquelin), Pavel Machek (historical reporter),
  linux-stm32, linux-arm-kernel.
- Substantive review: Maciej Fijalkowski. Applied by Jakub Kicinski.

Step 4.3: SEARCH FOR THE BUG REPORT
Record:
- Concrete iperf3 numbers from the author on real hardware (Orange Pi 5
  Pro).
- Historical same class of bug: Pavel Machek 2016 UDP burst pauses (40
  ms low-res timer); his “disable coalescing” patch was rejected in
  favor of a real solution. hrtimer conversion later fixed resolution
  but left timer-as-only-completion for light flows.
- Severity from reporter: BBR unusable (~5 Mbit/s vs hundreds).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Single standalone patch. Author deferred any coalescing rework
to net-next. XSK/XDP IC logic deliberately not included.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. No evidence on
openwall/patchew that stable rejected this. UNVERIFIED that it was
discussed on stable@ specifically.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `stmmac_tso_xmit`, `stmmac_xmit`. Helper used:
`netdev_xmit_more`. Callee already present: `stmmac_set_tx_ic`.

Step 5.2: TRACE CALLERS
Record:
- `stmmac_xmit` is `ndo_start_xmit` (`stmmac_netdev_ops` at line 7155).
- `stmmac_tso_xmit` is called from `stmmac_xmit` for TSO/GSO packets
  (lines 4529/4531).
- Context: process / softirq xmit (BH off). Userspace sockets, not
  probe-only.

Step 5.3: TRACE CALLEES
Record: `stmmac_set_tx_ic` sets the hardware IC bit;
`stmmac_tx_timer_arm` still runs after xmit (lines 4461 and 4750). Timer
remains the fallback if IC is not set or NAPI is not scheduled.

Step 5.4: FOLLOW THE CALL CHAIN
Record: userspace send/write → TCP → qdisc → `ndo_start_xmit` →
`stmmac_xmit` / `stmmac_tso_xmit`. Reachable on every stmmac Ethernet
device. Unprivileged users who can send on the interface (typical
networked host) trigger it. BBR/pacing makes it easy to hit.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `netdev_xmit_more()` is already used for doorbell/IC batching in
many drivers in this tree (r8169, mlx5, virtio_net, qede, ionic, sfc,
forcedeth, …). stmmac is the outlier. XSK/XDP in the same file still use
frame-count-only IC; that is intentional and not a missed copy of this
bug (no TSQ).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `stmmac_tso_xmit` ~4380–4390 and `stmmac_xmit` ~4645–4655:
same if/else IC logic, no `netdev_xmit_more()` branch. Defaults in this
tree: `STMMAC_TX_FRAMES` 25, `STMMAC_COAL_TX_TIMER` 5000 (`common.h`).
`git describe HEAD` → `p-6.12-2-gd38d58a4e0359`; `make kernelversion` →
6.12.111.

dwmac-motorcomm / YT6801 is not in this tree; that was only the
reporter’s NIC. The bug lives in common `stmmac_main.c`, which 6.12
already uses for dwmac-rk, dwmac-sunxi, dwmac-stm32, dwmac-intel, dwmac-
imx, dwmac-qcom-ethqos, dwmac-ipq806x, dwmac-meson, etc.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Expected apply: clean for the four added lines. Surrounding
mainline helpers (`CIRC_CNT`, `stmmac_get_tx_desc`) differ, but they are
not part of this hunk. Insertion context matches 6.12 exactly.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: 2d1a42cf7f77c (don’t re-arm timer while NAPI is scheduled) and
039550960a223 (5 ms timer) are in this tree. They do not set burst-end
IC. No equivalent fix present.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [net / stmmac Ethernet] [IMPORTANT — not mm/core, but the common
DWMAC driver for a large set of ARM/x86 embedded and laptop NICs]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (recent TSO, XDP, PTP, FPE fixes). Coalesce
core has been stable since 2019 with only timer-arm tweaks in 2023.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific, but a widely used driver. Anyone using stmmac
with default coalescing and paced/TSQ-limited TCP (BBR is
`CONFIG_TCP_CONG_BBR` in this tree). CUBIC is less affected because it
queues more deeply (207 vs 5 Mbit/s in the report).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Normal TCP upload with pacing/TSQ and default ethtool coalesce
(tx-frames 25, tx-usecs 5000). Common on WAN/RTT paths, not a rare error
path. Unprivileged users sending data can trigger it. Workaround exists
(`ethtool -C`) but is not discoverable for most users.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [TCP TX completion stall / order-of-magnitude throughput
collapse; BBR bandwidth lock-in] [HIGH for affected workloads — not a
panic/UAF/corruption, but the NIC is effectively unusable for paced TCP]

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for stmmac + BBR/pacing (5 → 447 Mbit/s in the report);
  restores TSQ-friendly completion.
- Risk: low (4 lines, well-known helper, coalescing preserved in-burst,
  `tx-frames 0` unchanged). 2023 ipq806x pain was timer-arm frequency
  under bulk load; this patch does not change timer arming and keeps the
  25-descriptor IC bound so a full ring cannot drain with zero IC.
- Ratio: benefit clearly outweighs risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real, measured bug: BBR ~5 Mbit/s vs CUBIC ~207 Mbit/s; ethtool
  experiment confirms mechanism.
- TSQ/pacing vs delayed TX completion is a known correctness class, not
  a micro-optimization.
- Introducing change da2024510031 (TX_FRAMES 1→25) is in this tree since
  v5.5; 5 ms timer (039550960a223) is also here.
- Four-line, obviously correct change; `netdev_xmit_more()` already in
  this tree.
- Applies on identical context in `stmmac_xmit` / `stmmac_tso_xmit`.
- `[PATCH net]`, reviewed, applied by netdev maintainer; reviewer agreed
  IC belongs at batch end.
- Workaround requires non-default ethtool; default shipped settings are
  the broken ones.

AGAINST:
- Not a crash, UAF, deadlock, or security bug.
- Changes IRQ pattern (more interrupts on short bursts).
- Test NIC (dwmac-motorcomm) is not in 6.12 (common-path bug still is).
- Original thread did not Cc stable@.
- 2023 work raised the timer specifically to cut IRQ rate on some SoCs —
  theoretical regression if burst-end IC is too aggressive under bulk
  load. Mitigated by remaining in-burst coalescing and author’s IRQ
  measurements.

UNRESOLVED:
- Could not fetch lore.kernel.org (403) or spinics (500); used
  openwall/patchew instead.
- Could not search stable@ archives (403).
- No follow-up fix SHA in this tree (expected; this commit is not here).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — 4 lines, list review,
   before/after iperf3, IRQ rate reported.
2. Fixes a real bug that affects users? PASS — paced TCP/TSQ stall with
   measured multi-10x drop.
3. Important issue? PASS — HIGH functional failure of a standard
   congestion controller on a common NIC; not a panic, but the device is
   unusable for that workload at default settings.
4. Small and contained? PASS — +4 lines, one file, two functions.
5. No new features or APIs? PASS — uses existing `netdev_xmit_more()` /
   IC bit.
6. Can apply to the local tree? PASS — buggy code and helper exist;
   insertion context matches.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None of device-ID / quirk / DT / build / docs. Qualifies as a
normal small net driver correctness fix.

Step 9.4: MAKE YOUR DECISION
This is a small, tested fix for a long-standing TX completion stall that
makes paced TCP (notably BBR) collapse on stmmac at default coalesce
settings. The buggy path and the only dependency (`netdev_xmit_more`)
are in 6.12.y. Benefit to stable users is large; regression risk is low.

Verification:
- [Phase 1] Parsed subject/body/tags from the candidate message; Link
  msgid used to find the original `[PATCH net]` / RESEND threads.
- [Phase 1] Original list post (openwall/patchew) still had Fixes:
  da2024510031; committed copy in the pipeline does not.
- [Phase 2] Diff is +4 lines in `stmmac_tso_xmit` and `stmmac_xmit`
  only; both insertions are `else if (!netdev_xmit_more()) set_ic =
  true` after the `tx_coal_frames==0` check.
- [Phase 2] Read local `stmmac_main.c` 4380–4390 and 4645–4667: same IC
  ladder, no xmit_more branch; timer still armed at 4461 and 4750.
- [Phase 2] `STMMAC_TX_FRAMES` 25 and `STMMAC_COAL_TX_TIMER` 5000
  confirmed in `common.h`.
- [Phase 3] `git blame` on those lines: c2837423cb5455 (2019) and
  db2f2842e6f560 (2021).
- [Phase 3] `git merge-base --is-ancestor da2024510031 HEAD` exit 0;
  `git show da2024510031` changed TX_FRAMES 1→25.
- [Phase 3] `git merge-base --is-ancestor 039550960a223 HEAD` exit 0 (5
  ms timer present).
- [Phase 3] `git log --grep=netdev_xmit_more --
  drivers/net/ethernet/stmicro/stmmac/` empty.
- [Phase 3] `git describe HEAD` → p-6.12-2-gd38d58a4e0359; kernelversion
  6.12.111.
- [Phase 4] b4 dig on msgid: no local matching commit (expected).
- [Phase 4] Openwall RESEND and patchew v1: Maciej Fijalkowski review,
  Jakub apply-after-RESEND, no NAK; author kept frame coalescing for
  ring-full IC bound.
- [Phase 4] lore.kernel.org and stable@ fetches: 403. UNVERIFIED on
  stable@ specifically.
- [Phase 5] `stmmac_xmit` is `ndo_start_xmit`; `stmmac_tso_xmit` called
  from it; `netdev_xmit_more()` defined in `include/linux/netdevice.h`
  4989–5002.
- [Phase 5] Grep: many other NIC drivers already use
  `netdev_xmit_more()`; stmmac does not.
- [Phase 6] Grep `netdev_xmit_more` under stmmac: no matches. Grep
  YT6801/dwmac-motorcomm: no matches. Glob `dwmac-*.c`: 25 platform
  files including dwmac-rk, dwmac-ipq806x, dwmac-intel, dwmac-stm32.
- [Phase 6] Insertion context in 6.12 matches the patch;
  CIRC_CNT/get_tx_desc differences are mainline-only context, not
  required.
- [Phase 7] MAINTAINERS: STMMAC ETHERNET DRIVER, Alexandre Torgue / Jose
  Abreu.
- [Phase 8] `CONFIG_TCP_CONG_BBR` exists in `net/ipv4/Kconfig`.
- UNVERIFIED: whether a later mainline follow-up refined this patch (not
  in this tree; lore search blocked).

The stall is in this 6.12 tree, the fix is four obviously correct lines,
and paced TCP is a real user-visible failure at default coalesce
settings.

**YES**

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 63c045616c9b7..7dbb5e9bcb54b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4400,6 +4400,8 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		set_ic = true;
 	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
+	else if (!netdev_xmit_more())
+		set_ic = true;
 	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
 	else if ((tx_q->tx_count_frames %
@@ -4687,6 +4689,8 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		set_ic = true;
 	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
+	else if (!netdev_xmit_more())
+		set_ic = true;
 	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
 	else if ((tx_q->tx_count_frames %
-- 
2.53.0

