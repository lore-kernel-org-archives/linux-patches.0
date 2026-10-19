Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AC3548383;
	Mon, 19 Oct 2026 13:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418194; cv=none; b=cWPRsycwkMqqYkJzOWg9efVEXyjyKhIxgYAITxW6JVd/EQkamLB32VVCGkLW2hT8pia33Jfti41m71O+73lvFNLOU0ecOjnvXGWKxg2Rn83GlSKyPEn7hFWsFwR3MGqIJjGPON7IOtA3gk4m0PnCxEu/+F00DRKH5caopk1KRpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418194; c=relaxed/simple;
	bh=ycv05iTVb9HbBERCDJCNS7QLQDCwysj1x2yEF9333bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHhUh1shMoHBcYGJlorFyY1x2BL2ps/vHIlmO++zvYqzIQHSml7lB+vF8UmHXXQ9NKs9RYUwQbXbo0UsuSMbOq1wWDzrv8gLBcVuKNq6KhvZSfOZso4hq9/lTsAQD0LKi5z3mX3oPpZl0FHCz1QM2ZgtJa6dpTf+2+913Czp/Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lazK86t4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lazK86t4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085991F000C8;
	Mon, 19 Oct 2026 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418192;
	bh=FASpZ5k/JyiXygAwiIimxKfKoMxwFYX/5kYDuwsYLlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lazK86t40XxcY2NDAWhd4CJpRHyqnNboR/sDOMjLe8rcn8zw7OOPAEmZ5Bkgb0ooi
	 s71ErRauZZbFvuhm8xAU+Y8IEwRhamyHRD5W8hksKUYPrfFxpEEaWMlaOlBGRm0B2J
	 Xu0Ez/0ZCzTUU48f6TJbHRmuRq4YYhfC6xHUFMGzs/Q+sWTaq9kLZibDwBpQ6IoyUD
	 r5/Yhi8ZZJ+TmvT/czLkFCscdnEDhjIcZQYJo0cs39zueunImfwqqHJVaXriF6s/wS
	 xDwacxPKkBzZa1c8o7t4E+sQt0/tW6f3ri6qFioet1oVpASDHYRa4zVaBA7M+UunPh
	 yEr1GRnUfepsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Prashant Rahul <prashantrahul23@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event
Date: Mon, 19 Oct 2026 09:46:08 -0400
Message-ID: <20261019135441.1420968-77-sashal@kernel.org>
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

From: Prashant Rahul <prashantrahul23@gmail.com>

[ Upstream commit 4361f1660101270611eb5dc39799f620b35f2e4d ]

The ownership of sk_buff skb is passed to mt7921_queue_rx_skb, each
path inside it under the switch case handles cleaning of skb and it
is true for mt7921_mcu_rx_event as well.

mt7921_mcu_rx_event, on a success path, either queues skb via
mt76_mcu_rx_event or cleans it immediately inside
mt7921_mcu_uni_rx_unsolicited_event.

However inside mt7921_mcu_rx_event, if skb_linearize fails, the function
returns immediately and never bothers cleaning skb which leaks skb.

Since skb is fully owned at this point, it is safe to call
dev_kfree_skb which fixes the leak.

Granted, the skb_linearize failure is rare as it can only fail under
heavy memory usage, but at the same time, leaking memory under heavy
memory usage can worsen the OOM condition.

Signed-off-by: Prashant Rahul <prashantrahul23@gmail.com>
Link: https://patch.msgid.link/20260716-mt7921-mem-leak-v1-1-6e9c0ea19f63@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: mt7921 MCU RX skb leak

**Tree decided:** `pending-6.6` (6.6.157), SHA `04810563abb71`.
At the start of this evaluation `git describe`/`make kernelversion`
reported **6.6.157**. The working copy later moved to v7.3-rc4; every
presence/absence claim below was rechecked against **`pending-6.6`**,
not that later checkout.

The candidate is mainline `4361f16601012` (`wifi: mt76: mt7921: fix
memory leak when skb_linearize fails in mcu rx event`).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject**
Record: **[wifi: mt76: mt7921]** **[fix]** memory leak when
`skb_linearize` fails in MCU RX event.

**Step 1.2 — Tags**
- `Signed-off-by: Prashant Rahul <prashantrahul23@gmail.com>` (author)
- `Link: https://patch.msgid.link/20260716-mt7921-mem-
  leak-v1-1-6e9c0ea19f63@gmail.com`
- `Signed-off-by: Felix Fietkau <nbd@nbd.name>` (mt76 maintainer;
  applied the patch)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of Fixes/Cc-stable is expected for this
  review).
Record: Maintainer SOB; msgid shows **v1 patch 1/1** (standalone).

**Step 1.3 — Body**
Record:
- **Bug:** `mt7921_queue_rx_skb` transfers skb ownership into
  `mt7921_mcu_rx_event`. Success paths free or queue the skb. If
  `skb_linearize()` fails, the function returns without freeing.
- **Symptom:** skb leak. Author notes failure is rare (ENOMEM) but
  leaking under memory pressure can worsen OOM.
- **Root cause:** missing `dev_kfree_skb` on the linearize error path.
- **Version info in message:** none.

**Step 1.4 — Hidden bug fix?**
Record: **No disguise.** This is an explicit leak fix, not cleanup-as-
fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- File: `drivers/net/wireless/mediatek/mt76/mt7921/mcu.c` (**+3 / −1**)
- Function: `mt7921_mcu_rx_event`
- Scope: **single-file surgical fix**

**Step 2.2 — Flow**
Before (pending-6.6 `mcu.c:312-313`):

```
if (skb_linearize(skb))
    return;
```

After:

```
if (skb_linearize(skb)) {
    dev_kfree_skb(skb);
    return;
}
```

Record: **error path only.** Success paths unchanged.

**Step 2.3 — Bug mechanism**
Record: **[resource leak]** On `skb_linearize` failure (`-ENOMEM` for
nonlinear skbs), the still-owned skb is dropped. Caller
`mt7921_queue_rx_skb` does not free after `PKT_TYPE_RX_EVENT`. Other
switch arms in the same caller (`dev_kfree_skb` / `napi_consume_skb`)
and other arms of `mt7921_mcu_rx_event` (`dev_kfree_skb`,
`mt76_mcu_rx_event` queue) already consume the skb.

**Step 2.4 — Fix quality**
Record: **Obviously correct.** Matches established kernel pattern (`if
(skb_linearize(skb)) { dev_kfree_skb(_any)(skb); return; }`). Same free
helper already used in this MCU event path. No API/lock/data-structure
change. Regression risk: **very low** (could only be a double-free if
linearize already freed; it does not — see Phase 5).

---

## PHASE 3: GIT HISTORY

**Step 3.1 — Blame**
Record: Leak introduced by **`f0ff5d3aa64812`** (`mt76: mt7921: make all
event parser reusable between mt7921s and mt7921e`, Sean Wang,
2021-10-19). That commit added `skb_linearize` + early return and never
freed on failure. Present since ~5.16-era; **`git merge-base --is-
ancestor f0ff5d3aa64812 pending-6.6` succeeds.**

**Step 3.2 — Fixes: tag**
Record: **None.** Introducer identified by blame: `f0ff5d3aa64812`,
which **is** in this 6.6 tree.

**Step 3.3 — File history (pending-6.6)**
Recent 6.6 work on this file is CLC firmware validation, not MCU RX. No
competing leak fix. Record: **standalone**; not part of a multi-patch
series.

**Step 3.4 — Author**
Prashant Rahul has **no other commits** in this tree’s mt76 history.
Applied by **Felix Fietkau**, listed maintainer of MEDIATEK MT76 in
`MAINTAINERS`. Record: one-off contributor; **maintainer-applied**.

**Step 3.5 — Dependencies**
The hunk only needs `mt7921_mcu_rx_event` + `skb_linearize` +
`dev_kfree_skb`, all present. Mailing-list patch context matches 6.6
(the extra `MCU_EVENT_RSSI_NOTIFY` in later mainline is **below** the
change). Record: **applies standalone**.

---

## PHASE 4: MAILING LIST / EXTERNAL

**Step 4.1 — Original discussion**
- `b4 dig -c <msgid>` / `b4 mbox`: no match (404).
- lore.kernel.org: **403**.
- Recovered from Openwall and Ratatoskr:
  https://lists.openwall.net/linux-kernel/2026/07/16/1707
  msgid `20260716-mt7921-mem-leak-v1-1-6e9c0ea19f63@gmail.com`
Record: **v1, single patch**, applied as submitted (`4361f16601012`
matches that diff). No v2/v3.

**Step 4.2 — Recipients (`b4 dig -w` unavailable; headers from
Openwall)**
To: Felix Fietkau, Lorenzo Bianconi, Ryder Lee, Shayne Chen, Sean Wang
(mt76 maintainers/reviewers), plus MediaTek ARM contacts. Cc: linux-
wireless, linux-kernel, linux-mediatek, linux-arm-kernel. Record:
**correct maintainer set**.

**Step 4.3 — Bug report**
Record: **No syzbot/bugzilla.** Static ownership analysis; author states
the leak is rare.

**Step 4.4 — Series**
Record: **1/1 standalone.** No sibling mt7925/mt7915 patches required
for this tree (only mt7921 has this `skb_linearize` in pending-6.6).

**Step 4.5 — Stable list**
Search for this subject on lore stable returned unrelated hits. Record:
**no prior stable NAK found** (lore 403 limited this).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Functions**
Record: `mt7921_mcu_rx_event` only.

**Step 5.2 — Callers**
`mt7921_queue_rx_skb()` (`mac.c`) `case PKT_TYPE_RX_EVENT:` calls it and
does **not** free afterwards.

That `rx_skb` hook is registered for **PCIe, USB, and SDIO**:
- `mt7921/pci.c`, `usb.c`, `sdio.c` → `.rx_skb = mt7921_queue_rx_skb`
- Invoked from `mt76_dma_rx_process` (NAPI), `mt76u` USB RX,
  `mt76s_process_rx_queue` (SDIO)

Record: **hot RX path** for MT7921E/S/U.

**Step 5.3 — Callees**
`skb_linearize` → `__skb_linearize` → `__pskb_pull_tail`; returns
`-ENOMEM` on failure and **does not free** the skb
(`include/linux/skbuff.h`: “If there is no free memory -ENOMEM is
returned”). Success continues to `mt7921_mcu_uni_rx_unsolicited_event` /
`mt76_mcu_rx_event` / `mt7921_mcu_rx_unsolicited_event`.

**Step 5.4 — Reachability**
Nonlinear MCU events are real:
- SDIO `mt76s_build_rx_skb` uses `skb_add_rx_frag` when payload >
  `MT_SKB_HEAD_LEN` — this is **why** `f0ff5d3aa64812` added linearize
  (“paged fragment skb for the SDIO device”).
- USB `mt76u_build_rx_skb` same pattern.
- DMA `mt76_add_fragment` builds fraglists for multi-buffer RX.

Record: reachable from normal firmware MCU events; unprivileged users
can generate MCU traffic by using WiFi. Failure needs **ENOMEM during
linearize**.

**Step 5.5 — Similar patterns**
In pending-6.6, `skb_linearize` appears **only here** under mt76. No
duplicate site left unfixed in this tree.

---

## PHASE 6: LOCAL TREE (pending-6.6 / 6.6.157)

**Step 6.1 — Buggy code present?**
Record: **Yes.**
`pending-6.6:drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:312-313`:

```
if (skb_linearize(skb))
    return;
```

`git merge-base --is-ancestor 4361f16601012 pending-6.6` → **false**
(fix not here).
`git merge-base --is-ancestor f0ff5d3aa64812 pending-6.6` → **true**
(bug intro is here).
Bug age: **2021**, well before 6.6.

**Step 6.2 — Backport difficulty**
Submitted hunk is 4 lines around `skb_linearize` with context that
matches 6.6 (`struct mt76_connac2_mcu_rxd *rxd` then the if).
`MCU_EVENT_RSSI_NOTIFY` is later mainline-only context **below** the
edit. Record: **clean apply / trivial**.

**Step 6.3 — Related fixes already here?**
`git log --grep=skb_linearize` on mt76 in this tree: **empty**. No
alternate fix. Record: **none**.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**
Record: **wifi / mt76 / mt7921**. Criticality: **IMPORTANT** — MT7921E
is a common laptop WiFi 6 adapter (PCIe); USB/SDIO variants exist
(`MT7921E/S/U` in Kconfig). Not core mm/net, not staging.

**Step 7.2**
Record: Mature driver (MCU support from `1c099ab44727c8`, 2021). 6.6
still receives mt76 bugfixes (CLC, etc.).

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**
Record: **driver-specific**, users with MediaTek MT7921 (very common on
laptops). Config: `CONFIG_MT7921E/S/U`.

**Step 8.2 — Trigger**
Record: Firmware MCU RX event whose skb is nonlinear, **and**
`skb_linearize` fails (GFP/ENOMEM). Unprivileged WiFi use can generate
events; the failure itself is **uncommon**. SDIO long events are the
originally cited nonlinear case; USB/DMA can also fragment.

**Step 8.3 — Failure mode**
Record: **skb leak under memory pressure**, which can deepen OOM. Not a
panic/UAF. Severity: **MEDIUM–HIGH** (hot-path leak, not a one-time
probe leak).

**Step 8.4 — Risk/benefit**
- Benefit: **medium** — stops a real leak on a widely shipped chip; most
  valuable when the system is already under memory pressure.
- Risk: **very low** — 3 lines, error path, same free as sibling paths.
- Ratio: **favor backport**.

---

## PHASE 9: SYNTHESIS

**Step 9.1 — Evidence**

**For:**
- Real leak with verified ownership (caller does not free).
- Code and introducer are in 6.6.157; fix is not.
- Tiny, obviously correct, maintainer-applied.
- MT7921 is production hardware, not staging.
- Leak on an RX path under OOM is a stability issue, not a style
  cleanup.

**Against:**
- Trigger is rare (`skb_linearize` ENOMEM).
- No crash/syzbot/CVE.
- No explicit `Cc: stable` (not a negative per the review rules).

**Unresolved:** Full lore thread (403/404); no reviewer comments beyond
maintainer merge. Does not change the technical verdict.

**Step 9.2 — Stable rules**
1. Obviously correct and tested — **PASS** (3-line ownership fix; in
   mainline via Felix).
2. Real bug affecting users — **PASS** (skb leak on MT7921 MCU RX).
3. Important (crash/security/corruption/deadlock) — **PASS** as an RX-
   path leak that can worsen OOM; not a panic, but in the leak class
   stable regularly takes.
4. Small and contained — **PASS** (4 lines, one function).
5. No new features/APIs — **PASS**.
6. Can apply to this tree — **PASS** (hunk matches 6.6).

**Step 9.3 — Exceptions**
Record: none needed (not an ID/quirk/DT/build/doc exception). Ordinary
small leak fix.

**Step 9.4 — Decision**
Backport to **this** 6.6.157 tree. The bug exists here, the fix is
surgical, and regression risk is negligible.

---

## What the commit solves for stable users

On MT7921, firmware MCU events are handed to `mt7921_mcu_rx_event` with
full skb ownership. Nonlinear events (especially SDIO, also USB/DMA
fragments) are linearized first. If that allocation fails, 6.6 returns
and leaks the skb. Under memory pressure that leak makes OOM worse.
Adding `dev_kfree_skb(skb)` on that path closes the leak without
changing success behavior.

## Risk vs benefit

Benefit is a real leak fix on a common WiFi chip; risk is a three-line
error-path free that matches existing code in the same function.

## Concerns

None material: no prerequisites, no API change, no locking, expected
clean apply. Trigger rarity is the only weak point and is not enough to
reject a contained leak fix.

---

## Verification

- **[Phase 1]** Parsed tags: author SOB, Link msgid, Felix Fietkau SOB;
  no Fixes/Reported-by/Cc-stable.
- **[Phase 2]** Diff: +3/−1 in `mt7921_mcu_rx_event`; adds
  `dev_kfree_skb` on `skb_linearize` failure.
- **[Phase 3]** `git blame` on pending-6.6: leak from `f0ff5d3aa64812`
  (2021-10-19); `git merge-base --is-ancestor f0ff5d3aa64812
  pending-6.6` true.
- **[Phase 3]** `git show f0ff5d3aa64812`: added `if
  (skb_linearize(skb)) return;` with no free.
- **[Phase 3]** `git log --author=Prashant Rahul`: no other mt76 commits
  in this history.
- **[Phase 4]** Openwall/Ratatoskr: v1 1/1, same diff as
  `4361f16601012`; mt76 maintainers on To:.
- **[Phase 4]** `b4 mbox` msgid: 404; lore.kernel.org: 403.
  **UNVERIFIED:** full review replies / explicit stable nomination.
- **[Phase 5]** Callers: `mt7921_queue_rx_skb` (no free on
  `PKT_TYPE_RX_EVENT`); hooked from pci/usb/sdio `.rx_skb`.
- **[Phase 5]** `skb_linearize` documented to return `-ENOMEM` and not
  free; USB/SDIO `skb_add_rx_frag` makes nonlinear skbs.
- **[Phase 6]** `git describe` at start: `p-6.6-3-g04810563abb71`, `make
  kernelversion` 6.6.157.
- **[Phase 6]** `git grep` on `pending-6.6`: leak at `mcu.c:312-313`.
- **[Phase 6]** `git merge-base --is-ancestor 4361f16601012 pending-6.6`
  false.
- **[Phase 8]** Failure mode: skb leak under ENOMEM on MCU RX; severity
  MEDIUM–HIGH.
- **UNVERIFIED:** complete lore thread text after 403.

The fix is small, matches stable leak-fix practice, and the buggy code
is in this 6.6 tree.

**YES**

 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 8c8b35cba856c..f63ef02542387 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -354,8 +354,10 @@ void mt7921_mcu_rx_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
 	struct mt76_connac2_mcu_rxd *rxd;
 
-	if (skb_linearize(skb))
+	if (skb_linearize(skb)) {
+		dev_kfree_skb(skb);
 		return;
+	}
 
 	rxd = (struct mt76_connac2_mcu_rxd *)skb->data;
 
-- 
2.53.0

