Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1566C4E66BC;
	Mon, 31 Aug 2026 13:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183609; cv=none; b=hikIlYNQqmQkFjrpZ2quRCNIGSBOHKFdiHpaGHRdBFnFm6zhu6fd3P6qw1iQjzZFMLK1A1nFEIY6rFvShxWVQhAQXVY9G752lAorFQTjvX1yfmolcuBUlcXKRs2oxBq2X7/fwvrasSpRIYlUzv1GTyvwqkecREiINsuRnBrcuA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183609; c=relaxed/simple;
	bh=33iZXMr18Rmx2EvbseASldHV6w0ykrsmyfMWzDiOeFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iaoPW8DXOqet5m9mL6a08iHXDxQK11dWKSz7wpvWMf2rUA0N4/oQn2/RWrpcSaO2sv7GCS/rgxivixZPF7AtFv26Eny91uhnS15Y8+maOpwqFWbxPANSYrSYP7KcrzO/TWGskFyYPYnhhboukz5ibH8hKR6yVjrxsVA8KvELojM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbVW9ez3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbVW9ez3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAA61F00A3E;
	Mon, 31 Aug 2026 13:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183607;
	bh=WV+wAURa510r5CuNOKKk6gKEMYbOTRJ3w7E+E6k5jyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbVW9ez36ISHqkjHpT0ODl/i80jtoN87bmJ52y0LoouTcrsyHxdS6ZMuGyjO7WHW7
	 niG2NpKr+JCZGhN+BTZm6re9mj5ZPC3VggbkUodSgTCmd+XlSTlLOGereHI/GHOgEv
	 XmDkWTNUmYLBjU3bVnOlW/3pGwOyhSVFx/ob6HqhhNB4JwN3CNSyromQc0xjSTg4dO
	 nH3MAmTyQzPDmIr0dznj1270tMk0rBKfCEwm9rP83H2QJUopmMoRmfDdeJJs5nlJJS
	 6hIZiegnv7Oli66PaVu+ZXU63J9wIB1aqKmePyhwaVSKbua8Nu7RZ6JYRxtbJzd3NF
	 kPjPXG39NbSVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Frank.Li@nxp.com,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] mailbox: imx: Add a channel shutdown field
Date: Mon, 31 Aug 2026 09:23:43 -0400
Message-ID: <20260831133314.4125787-195-sashal@kernel.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 5ccea7eacb7786c358833634f45700365f6c1d99 ]

sashiko complained about possible teardown problem. The scenario

 CPU 0                              CPU 1
  imx_mu_isr()                   imx_mu_shutdown()
                                   imx_mu_xcr_rmw(priv, IMX_MU_RCR, 0, IMX_MU_xCR_RIEn(priv->dcfg->type, cp->idx));
    imx_mu_specific_rx()
      imx_mu_xcr_rmw(priv, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, 0), 0);
                                   free_irq()

The RX event remains enabled because in this short window the RX event
was disabled in ->shutdown() while the interrupt was active and then
enabled again by the ISR while ->shutdown waited in free_irq().

This race requires timing and if happens can be problematic on shared
handlers if the "removed" channel triggers an interrupt. In this case
the irq-core will shutdown the interrupt with the "nobody cared"
message.

Introduce imx_mu_con_priv::shutdown to signal that the channel is
shutting down. This flag is set with the lock held (by
imx_mu_xcr_clr_shut()). The unmask side uses imx_mu_xcr_set_act() which
only enables the event if the channel has not been shutdown and
serialises on the same lock.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `mailbox: imx: Add a channel shutdown field`

**Local tree:** `v6.18.44` (`linux-6.18.y`, `VERSION=6 PATCHLEVEL=18
SUBLEVEL=44`)
**Upstream commit:** `5ccea7eacb778` (not present in this checkout; `git
apply --check` succeeds)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[mailbox: imx]` `[Add]` — adds a per-channel `shutdown`
flag to coordinate teardown vs. ISR interrupt re-enablement.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent; commit cites sashiko review feedback
- **Tested-by:** — absent
- **Reviewed-by:** Peng Fan `<peng.fan@nxp.com>` (NXP imx mailbox
  maintainer)
- **Reviewed-by:** Mathieu Poirier `<mathieu.poirier@linaro.org>`
- **Link:** — absent
- **Cc: stable:** — absent (expected)
- **Signed-off-by:** Sebastian Andrzej Siewior, Jassi Brar (ignore
  pipeline-added SOBs)

Notable: two subsystem reviewers, including the NXP driver maintainer.

### Step 1.3: Body analysis
**Record:**
- **Bug:** Race between `imx_mu_isr()` → `imx_mu_specific_rx()` re-
  enabling RX interrupt enable bits and `imx_mu_shutdown()` disabling
  them, then blocking in `free_irq()`.
- **Symptom:** RX interrupt remains enabled after channel teardown; on
  `IRQF_SHARED` lines, a spurious interrupt from the removed channel can
  trigger irq-core “nobody cared” handling and disable the shared IRQ.
- **Root cause:** `imx_mu_shutdown()` clears enable bits, but a
  concurrent ISR completion re-enables them via `imx_mu_xcr_rmw()`
  before `free_irq()` completes.
- **Version info:** None stated; mechanism has existed since the
  `imx_mu_xcr_rmw()` RX re-enable path was added (2021).

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite “Add a channel shutdown field”, this is a
race-condition bug fix disguised as structural addition. The `shutdown`
bool is purely a synchronization mechanism.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/mailbox/imx-mailbox.c` (+36 / -4 lines)
- **Functions modified/added:** `imx_mu_xcr_clr_shut()` (new),
  `imx_mu_xcr_set_act()` (new), `imx_mu_specific_rx()`,
  `imx_mu_startup()`, `imx_mu_shutdown()`
- **Struct:** `imx_mu_con_priv` — adds `bool shutdown`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow per hunk
**Record:**
1. **`shutdown` field added** → per-channel teardown state.
2. **`imx_mu_xcr_clr_shut()`** → atomically sets `cp->shutdown = true`
   and clears interrupt-enable bits under `xcr_lock`.
3. **`imx_mu_xcr_set_act()`** → re-enables interrupt bits only if
   `!cp->shutdown`, under same lock.
4. **`imx_mu_specific_rx()`** → final RX re-enable changed from
   unconditional `imx_mu_xcr_rmw()` to guarded `imx_mu_xcr_set_act()`.
5. **`imx_mu_startup()`** → resets `cp->shutdown = false` after
   successful `request_irq()`.
6. **`imx_mu_shutdown()`** → TX/RX/RXDB disable paths use
   `imx_mu_xcr_clr_shut()` instead of `imx_mu_xcr_rmw()`.

**Before → After:**
- Shutdown clears enables, ISR can still re-enable → shutdown sets flag
  + clears enables; ISR re-enable is suppressed once shutdown started.

### Step 2.3: Bug mechanism
**Record:** **Race condition / synchronization fix.**
Shutdown and ISR completion both modify the same control-register enable
bits without coordinating teardown intent. The fix serializes intent via
`shutdown` flag + existing `xcr_lock`.

### Step 2.4: Fix quality
**Record:** Obviously correct; minimal; uses existing `xcr_lock`. Low
regression risk — only suppresses re-enable after shutdown has begun.
`cp->shutdown = false` on startup ensures clean re-open.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `imx_mu_shutdown()` — since 2018 (`2bb7005696e22`)
- `imx_mu_specific_rx()` RX re-enable at line 382 — since 2021
  (`4f0b776ef58317`, i.MX8ULP MU support)
- `xcr_lock` — present since initial imx MU driver (`2bb7005696e22`)
- Bug present in this tree for years.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- Recent related fix in tree: `b5ef17917f3a7` “mailbox: imx: fix TXDB_V2
  channel race condition” (2024) — same driver, same class of register
  RMW races.
- Commit is patch 02/10 of Siewior’s threaded-handler series on
  mainline, but **this patch is standalone** — it does not require the
  threaded-handler commits (verified: applies cleanly to current 6.18.y
  code; later series commits are separate enhancements).

### Step 3.4: Author context
**Record:** Sebastian Andrzej Siewior — active kernel contributor;
recent imx mailbox work on mainline. Jassi Brar is mailbox subsystem
maintainer (committed the patch).

### Step 3.5: Dependencies
**Record:** No prerequisites. Self-contained. Does not depend on
`fbc0f319cee18` (“Use channel index instead of zero”) which is a
separate follow-up on mainline.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 5ccea7eacb778` → [PATCH v3 02/10] at https://patc
h.msgid.link/20260617-imx_mbox_rproc-v3-2-77948112defc@linutronix.de
Series revisions: v1 (2026-05-29), v2 (2026-06-03), v3 (2026-06-17).
Committed version matches v3.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC’d: `linux-remoteproc@vger.kernel.org`,
`imx@lists.linux.dev`, `linux-arm-kernel@lists.infradead.org`, Bjorn
Andersson, Jassi Brar, Peng Fan, Mathieu Poirier, Pengutronix team.

### Step 4.3: Bug report
**Record:** Triggered by sashiko automated review during patch series
development — not a syzbot/user crash report, but a concrete, code-
reviewed race scenario with a documented failure mode.

### Step 4.4: Series context
**Record:** Part of 10-patch threaded-handler series, but this commit is
independently applicable. Other series patches are not required for this
fix to function.

### Step 4.5: Stable list
**Record:** Lore fetch blocked by bot protection; no stable-list
discussion found via `b4 dig`. Absence of explicit stable nomination is
not a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `imx_mu_isr()`, `imx_mu_specific_rx()`, `imx_mu_shutdown()`,
`imx_mu_startup()`, `mbox_free_channel()` (caller)

### Step 5.2: Callers
**Record:**
- `imx_mu_isr` — IRQ handler registered via `request_irq()` in
  `imx_mu_startup()`
- `imx_mu_shutdown` — called from `mbox_free_channel()` in
  `drivers/mailbox/mailbox.c:474-475`
- `imx_mu_specific_rx` — called from `imx_mu_isr()` for `IMX_MU_TYPE_RX`
  on SCU/S4 configs (`imx_mu_cfg_imx8_scu`, `imx_mu_cfg_imx8ulp_s4`,
  `imx_mu_cfg_imx93_s4`)

### Step 5.3: Callees
**Record:** `imx_mu_xcr_rmw/set_act/clr_shut` use
`spin_lock_irqsave(&priv->xcr_lock)`; hardware register read/write;
`free_irq()`; `mbox_chan_received_data()`

### Step 5.4: Reachability
**Record:**
```
mbox_free_channel() → imx_mu_shutdown()     [teardown path]
IRQ → imx_mu_isr() → imx_mu_specific_rx()   [interrupt path]
```
Triggered during channel release (driver unbind, remoteproc shutdown,
SCMI client teardown). Reachable on normal i.MX embedded operation.

### Step 5.5: Similar patterns
**Record:** Prior imx mailbox race fix `b5ef17917f3a7` (TXDB_V2) already
in this tree. Same driver, same register-coordination problem class.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at `drivers/mailbox/imx-mailbox.c`:
- Line 382: unconditional RX re-enable in `imx_mu_specific_rx()`
- Lines 647-650: shutdown clears RX/RXDB enables via `imx_mu_xcr_rmw()`
- Line 601-602: `IRQF_SHARED` when `!(priv->dcfg->type & IMX_MU_V2_IRQ)`
  — applies to imx6sx, imx7ulp, imx8ulp, imx8ulp_s4, imx8_scu,
  imx8_seco, imx95 variants (not imx93_s4 which has dedicated IRQs)

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git show 5ccea7eacb778 | git apply
--check` succeeds with no conflicts.

### Step 6.3: Fix already present?
**Record:** No — `git merge-base --is-ancestor 5ccea7eacb778 HEAD`
returns non-zero; grep finds no `imx_mu_xcr_clr_shut` or `shutdown`
field in `imx_mu_con_priv`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/mailbox` — **IMPORTANT** for i.MX/ARM embedded
platforms. imx MU is used for SCMI, SECO, System Manager, and remoteproc
IPC.

### Step 7.2: Activity
**Record:** Actively maintained; multiple imx mailbox fixes in 6.18.y
and mainline since 2024.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of `CONFIG_IMX_MBOX` on i.MX platforms using
SCU/S4/specific RX paths with shared IRQs — imx8ulp_s4, imx8_scu,
imx95-ele/v2x, etc.

### Step 8.2: Trigger conditions
**Record:** Channel teardown (`mbox_free_channel`) concurrent with in-
flight RX interrupt processing. Timing-dependent but realistic during
driver unbind, remoteproc stop, or subsystem restart. Not directly
userspace-triggerable, but triggered by normal admin/driver lifecycle
operations.

### Step 8.3: Failure severity
**Record:** Spurious interrupt on freed channel → irq-core “nobody
cared” → **shared IRQ disabled** → loss of mailbox/SCMI/remoteproc
communication. **Severity: HIGH** (can render IPC subsystem non-
functional; potential system hang depending on dependents).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents IRQ disable on shared lines during
  teardown
- **Risk:** LOW — 40 lines, single file, uses existing lock, reviewed by
  maintainers
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable race between ISR and shutdown
- Concrete failure mode (spurious IRQ → “nobody cared” → IRQ disabled)
- Affects production i.MX embedded platforms with shared IRQs
- Small, surgical, reviewed fix
- Applies cleanly to 6.18.y
- Bug code present since 2021
- Prior similar imx mailbox race fix already in stable tree

**AGAINST backport:**
- Timing-dependent; no user crash report or syzbot report
- Part of a larger series (but this patch is standalone)
- Sashiko report is review-tool feedback, not field report

**Unresolved:** Full lore thread content unavailable due to bot
protection; no explicit stable nomination found.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — clear lock+flag pattern;
   reviewed by NXP maintainer and Linaro reviewer
2. Fixes a real bug? **PASS** — verified race in current tree code
3. Important issue? **PASS** — IRQ disable on shared handler can break
   critical IPC
4. Small and contained? **PASS** — 1 file, ~40 lines
5. No new features/APIs? **PASS** — internal driver flag only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix) —
qualifies on race-condition bug-fix merits.

### Step 9.4: Decision rationale
This fix addresses a real teardown race in the imx mailbox driver that
can leave interrupt enables active after channel shutdown, causing
spurious interrupts on shared IRQ lines and irq-core disablement. The
bug exists in v6.18.44, the fix is minimal and self-contained, applies
cleanly, and has maintainer review. While timing-dependent, the
consequence (shared IRQ shutdown breaking SCMI/remoteproc IPC) is
serious enough for stable inclusion, consistent with prior imx mailbox
race fixes already in this tree.

---

## Verification

- [Phase 1] Parsed commit `5ccea7eacb778`: subject, body, Reviewed-by
  tags (Peng Fan, Mathieu Poirier); no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff analysis: +36/-4 in `imx-mailbox.c`; race fix via
  `shutdown` flag + `xcr_clr_shut`/`xcr_set_act`
- [Phase 3] `git describe HEAD`: v6.18.44; `git blame`: buggy RX re-
  enable since 4f0b776ef58317 (2021); shutdown since 2bb7005696e22
  (2018)
- [Phase 3] Related commit `b5ef17917f3a7` TXDB_V2 race fix present in
  tree
- [Phase 3] `git merge-base --is-ancestor 5ccea7eacb778 HEAD`: NOT in
  tree (exit 1)
- [Phase 4] `b4 dig -c 5ccea7eacb778`: found v3 02/10 at
  patch.msgid.link/20260617-...
- [Phase 4] `b4 dig -a`: v1/v2/v3 series revisions found
- [Phase 4] `b4 dig -w`: maintainers and imx lists CC'd
- [Phase 4] Lore full-thread fetch: blocked by Anubis bot protection
  (UNVERIFIED for inline reviewer stable comments)
- [Phase 5] Read `imx_mu_isr`, `imx_mu_specific_rx`, `imx_mu_shutdown`,
  `mbox_free_channel` call chain
- [Phase 5] Verified `IRQF_SHARED` at line 601-602 for
  non-`IMX_MU_V2_IRQ` configs
- [Phase 5] Verified `imx_mu_specific_rx` used by imx8_scu, imx8ulp_s4,
  imx93_s4 configs
- [Phase 6] Confirmed buggy code at lines 382, 647-650 in current tree
- [Phase 6] `git show 5ccea7eacb778 | git apply --check`: succeeds
  (clean apply)
- [Phase 6] Grep: no `imx_mu_xcr_clr_shut` or `shutdown` field in
  current tree
- [Phase 7] `CONFIG_IMX_MBOX` in `drivers/mailbox/Kconfig`
- [Phase 8] Failure mode: spurious IRQ → irq disable on shared line;
  severity HIGH for IPC subsystems

**YES**

 drivers/mailbox/imx-mailbox.c | 40 +++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index a45c3e6d76575..3e52f70434c97 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -82,6 +82,7 @@ struct imx_mu_con_priv {
 	enum imx_mu_chan_type	type;
 	struct mbox_chan	*chan;
 	struct work_struct 	txdb_work;
+	bool			shutdown;
 };
 
 struct imx_mu_priv {
@@ -221,6 +222,36 @@ static u32 imx_mu_xcr_rmw(struct imx_mu_priv *priv, enum imx_mu_xcr type, u32 se
 	return val;
 }
 
+static void imx_mu_xcr_clr_shut(struct imx_mu_priv *priv, struct imx_mu_con_priv *cp,
+				enum imx_mu_xcr type, u32 clr)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->xcr_lock, flags);
+	cp->shutdown = true;
+
+	val = imx_mu_read(priv, priv->dcfg->xCR[type]);
+	val &= ~clr;
+	imx_mu_write(priv, val, priv->dcfg->xCR[type]);
+	spin_unlock_irqrestore(&priv->xcr_lock, flags);
+}
+
+static void imx_mu_xcr_set_act(struct imx_mu_priv *priv, struct imx_mu_con_priv *cp,
+			       enum imx_mu_xcr type, u32 set)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->xcr_lock, flags);
+	if (!cp->shutdown) {
+		val = imx_mu_read(priv, priv->dcfg->xCR[type]);
+		val |= set;
+		imx_mu_write(priv, val, priv->dcfg->xCR[type]);
+	}
+	spin_unlock_irqrestore(&priv->xcr_lock, flags);
+}
+
 static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 			     struct imx_mu_con_priv *cp,
 			     void *data)
@@ -379,7 +410,7 @@ static int imx_mu_specific_rx(struct imx_mu_priv *priv, struct imx_mu_con_priv *
 		*data++ = imx_mu_read(priv, priv->dcfg->xRR + (i % num_rr) * 4);
 	}
 
-	imx_mu_xcr_rmw(priv, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, 0), 0);
+	imx_mu_xcr_set_act(priv, cp, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, 0));
 	mbox_chan_received_data(cp->chan, (void *)priv->msg);
 
 	return 0;
@@ -607,6 +638,7 @@ static int imx_mu_startup(struct mbox_chan *chan)
 		return ret;
 	}
 
+	cp->shutdown = false;
 	switch (cp->type) {
 	case IMX_MU_TYPE_RX:
 		imx_mu_xcr_rmw(priv, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, cp->idx), 0);
@@ -641,13 +673,13 @@ static void imx_mu_shutdown(struct mbox_chan *chan)
 
 	switch (cp->type) {
 	case IMX_MU_TYPE_TX:
-		imx_mu_xcr_rmw(priv, IMX_MU_TCR, 0, IMX_MU_xCR_TIEn(priv->dcfg->type, cp->idx));
+		imx_mu_xcr_clr_shut(priv, cp, IMX_MU_TCR, IMX_MU_xCR_TIEn(priv->dcfg->type, cp->idx));
 		break;
 	case IMX_MU_TYPE_RX:
-		imx_mu_xcr_rmw(priv, IMX_MU_RCR, 0, IMX_MU_xCR_RIEn(priv->dcfg->type, cp->idx));
+		imx_mu_xcr_clr_shut(priv, cp, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, cp->idx));
 		break;
 	case IMX_MU_TYPE_RXDB:
-		imx_mu_xcr_rmw(priv, IMX_MU_GIER, 0, IMX_MU_xCR_GIEn(priv->dcfg->type, cp->idx));
+		imx_mu_xcr_clr_shut(priv, cp, IMX_MU_GIER, IMX_MU_xCR_GIEn(priv->dcfg->type, cp->idx));
 		break;
 	case IMX_MU_TYPE_RST:
 		imx_mu_xcr_rmw(priv, IMX_MU_CR, IMX_MU_xCR_RST(priv->dcfg->type), 0);
-- 
2.53.0

