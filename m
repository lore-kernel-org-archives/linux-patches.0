Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA27C548383;
	Mon, 19 Oct 2026 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418213; cv=none; b=INBVNBzEOgaxuOI3l84zhsV52OTEKLQXLwDrAT5JUO9lzOiELSFbdDzXizuLAR6YFzVpRnw+b8UwWiyBqbYnzu13jGqo7tyB3JVsYmqmWeorxDCqqAMmOCN5wV3m7m8uRxUQSsxeUIfzX59jD8C5ARZHqV4wP+mwmp9/5sxwHfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418213; c=relaxed/simple;
	bh=7M85PoEdI9NGWQUxBuMNg8mZNFtJdKt6OFkidKtjHCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6MzF/I6YxIBP9dbO/Hb7nU0jDddxM8e3mc/FbFn7c2TW+MtSNim6MU675gZ4qvLeCqD+c3qYWd3VO2FxHKVdFhko5lSqE1wbdYDnHCscFEbG4i+jFt4gzHavBIz5pFeGlQpxKig1FoYSERTnmL1AbvR7o3Q1g4/UwZc7UXds7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KcdxTP8M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KcdxTP8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E01F000C4;
	Mon, 19 Oct 2026 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418209;
	bh=Irw2HciggiDScKPpb4W43ki0UZxeP1gN6Q/AOx+mPuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcdxTP8MKpSmr7W1Mkfs9QM3mz4Ehp+Wn44V1+ISKNryCZ/t/+E3iNqhrIhEc+qXO
	 ly6SIc7A10wXYIYxSjhSzmpaZ/+wqZg0cjY/6kY7omV7omN+tw2WKtgpzh83A7UOBl
	 v+qv5A1/dNqH74QnBuIoNzzj995Zy4NzputAoyt0UlaLCTkVI0SJ+9bXIKX6DLzMaT
	 5H0q+36qI4HG0bpEZAKSpkyL7S+ebcryoQzYgTMUGSM6jqJT9g/Srd4YXu0ATJ4nuO
	 GQCp5/d/SVoXeCWjE+63HGktlhbPo83q99fkFV5ndQFtR59X2IIwD7gXWQU1tWBedu
	 2iB+0dF6TtBuA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cassel@kernel.org,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ata: pata_ep93xx: fix PIO fallback when DMA init fails
Date: Mon, 19 Oct 2026 09:46:21 -0400
Message-ID: <20261019135441.1420968-90-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit c303c3619a1d5cf7d4b457106062d16724724a80 ]

ep93xx_pata_dma_init() returns an error when dma_request_chan() fails,
which causes ep93xx_pata_probe() to abort entirely.  The probe function
already has a PIO fallback path (it checks both channel pointers before
enabling UDMA), so the DMA init should not fail the probe on non-fatal
errors.

Propagate -EPROBE_DEFER, such that we allow the DMA controller driver
to load, in case we got probed before the DMA controller driver.
For all other failures (e.g. -ENODEV when the DMA controller is missing
in the device tree), fall back to PIO.

Assisted-by: Opencode:Big-Pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[ata / pata_ep93xx] [fix] restore PIO fallback when DMA init
fails so probe does not abort`

**Step 1.2 — Tags**
Record:
- `Assisted-by: Opencode:Big-Pickle`
- `Signed-off-by: Rosen Penev <rosenp@gmail.com>` (author)
- `Signed-off-by: Damien Le Moal <dlemoal@kernel.org>` (libata
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable` (absence of Fixes/Cc:stable is expected
  here)
- Notable: no user/syzbot report; maintainer SOB is present

**Step 1.3 — Body**
Record:
- **Bug:** `ep93xx_pata_dma_init()` treats any `dma_request_chan()`
  failure as fatal. `ep93xx_pata_probe()` then returns that error and
  never registers the ATA host.
- **Symptom:** PATA/IDE controller never appears; storage is
  unavailable. PIO fallback in probe (channel-pointer check before UDMA)
  is dead for this path.
- **Root cause:** after the OF DMA conversion, non-defer errors (e.g.
  `-ENODEV`) abort probe instead of continuing without DMA.
- **Intended fix:** propagate `-EPROBE_DEFER`; for other failures, warn
  and return 0 so the existing PIO path runs.
- **Version info in message:** none.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. The subject and body describe a real probe
regression. The diff also NULLs error pointers and stops
`fail_release_rx` from falling through into a second release.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/ata/pata_ep93xx.c` (+21/−9, 30 lines)
- Function: `ep93xx_pata_dma_init()`
- Scope: single-file surgical error-path change

**Step 2.2 — Code flow**
Record (pre-image from `c303c3619a1d5^`):
- **rx `dma_request_chan` fail:** `dev_err_probe()` and return the
  error. Probe aborts. `dma_rx_channel` left as `ERR_PTR`.
- **tx `dma_request_chan` fail:** `dev_err_probe()`, `goto
  fail_release_rx`. That released rx, then **fell through** into
  `fail_release_dma` → `ep93xx_pata_release_dma()` with rx still non-
  NULL and tx still an error pointer.
- **`dmaengine_slave_config` fail:** `dev_err_probe()`, release both,
  **return `ret`** → probe aborts.
- **After:** non-defer failures NULL the pointers, warn, return 0.
  `-EPROBE_DEFER` still fails probe so the DMA driver can load.
  `fail_release_rx` no longer falls through.

**Step 2.3 — Bug mechanism**
Record:
- **Primary:** logic/error-path — optional DMA failure became a hard
  probe failure (regression of designed PIO fallback).
- **Secondary:** error-path resource handling — old tx-fail path could
  `dma_release_channel()` twice on rx and pass `ERR_PTR` into
  `dma_release_channel()` (`chan->client_count` dereference in
  `drivers/dma/dmaengine.c`).

**Step 2.4 — Fix quality**
Record: Obviously correct and minimal. Matches pre-v6.12 void `dma_init`
(fail DMA, keep probing). Regression risk is low: happy path unchanged;
`-EPROBE_DEFER` still delays probe; libata only sets `udma_mask` when
both channels are non-NULL, so BMDMA ops are not used in PIO mode. No
API/data-structure change.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: The failing `dma_request_chan()` + `return int` behavior was
introduced by `9963113e3a924` (“ata: pata_ep93xx: add device tree
support”, 2024-09-12), contained in **v6.12-rc1**. Before that,
`ep93xx_pata_dma_init()` was `void` and returned after releasing
channels, leaving pointers NULL. Driver itself dates to `2fff27512600`
(2012).

**Step 3.2 — Fixes: tag**
Record: No `Fixes:` tag. The commit that introduced the bug is
`9963113e3a924`. `git merge-base --is-ancestor 9963113e3a924 HEAD`
succeeds in this tree.

**Step 3.3 — File history**
Record: Between the DT conversion and this fix: pinctrl/DT cleanup,
`remove()` callback switch, COMPILE_TEST/type tweaks. No other DMA-init
semantics change. Not patch X/Y. Standalone.

**Step 3.4 — Author**
Record: Rosen Penev is a regular ATA contributor. Damien Le Moal (libata
maintainer) applied it to `for-7.3`.

**Step 3.5 — Dependencies**
Record: Needs the v6.12 `dma_request_chan()` conversion
(`9963113e3a924`). That is in this tree. No extra helper/API required.
Applies standalone on this code.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record:
- Lore/msgid:
  https://patch.msgid.link/20260720020229.1972888-1-rosenp@gmail.com
  (v2, committed)
- v1: https://patch.msgid.link/20260601190749.20045-1-rosenp@gmail.com
- v1→v2: commit-message only (`v2: fix EPROBE_DEFER description`). Code
  unchanged.
- Niklas Cassel on v1: “This patch looks correct to me”, asked not to
  call `-EPROBE_DEFER` “fatal”.
- Damien on v2: “Applied to for-7.3. Thanks!”
- No NAK, no stable nomination, no reviewer risk flags.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: `linux-ide@vger.kernel.org`, Damien Le Moal, Niklas Cassel,
`linux-kernel`. Right maintainers.

**Step 4.3 — Bug report**
Record: No `Reported-by` / bugzilla / syzbot. Bug is from code
inspection of the DT conversion.

**Step 4.4 — Series**
Record: Single standalone patch, two revisions, message-only v2.

**Step 4.5 — stable@**
Record: No stable-list discussion found (lore HTML search was unusable;
v2 mbox/thread had no stable Cc). UNVERIFIED beyond the v1/v2 linux-ide
thread.

## Phase 5: Semantic / call chain

**Step 5.1 — Functions**
Record: `ep93xx_pata_dma_init()` only (callees: `dma_request_chan`,
`dmaengine_slave_config`, `dma_release_channel`,
`ep93xx_pata_release_dma`).

**Step 5.2 — Callers**
Record: Only `ep93xx_pata_probe()` (`err =
ep93xx_pata_dma_init(drv_data); if (err) return err;`). Platform probe /
device enumeration. Not IRQ/hot path.

**Step 5.3 — Callees**
Record: `dma_request_chan()` → `of_dma_request_slave_channel()`. Missing
`dmas` returns `-ENODEV` (“Silently fail if there is not even the dmas
property”). Missing controller while `dmas` is present returns
`-EPROBE_DEFER`.

**Step 5.4 — Reachability**
Record: Reachable when `CONFIG_PATA_EP93XX` is enabled and the
`cirrus,ep9312-pata` platform device probes. Userspace does not trigger
it directly; boot/device probe does. On this tree the SoC dtsi node is
`status = "disabled"` and no in-tree board enables `&ide`.
Binding/example still has no `dmas`, so **any** DT that enables the node
as documented hits `-ENODEV` and, before the fix, never binds.

**Step 5.5 — Similar patterns**
Record: Pre-6.12 driver already implemented this fallback. Probe still
has `if (drv_data->dma_rx_channel && drv_data->dma_tx_channel)` before
setting `udma_mask`.

## Phase 6: This tree (v7.3-rc4)

**Step 6.1 — Buggy code here?**
Record: Yes. Local tree: `git describe HEAD` =
**v7.3-rc4-27-gf0100363d8c37**, `make kernelversion` = **7.3.0-rc4**.
`9963113e3a924` is an ancestor. Pre-fix `ep93xx_pata_dma_init()` in
`c303c3619a1d5^` returns errors from `dma_request_chan()`. The candidate
itself is also an ancestor of HEAD (already in 7.3); that does not
change whether the bug class exists in this lineage.

**Step 6.2 — Backport difficulty**
Record: Clean apply on this tree’s `pata_ep93xx.c` (post-DT
`dma_request_chan` shape). No conflicting local changes after the fix.

**Step 6.3 — Related fixes already here**
Record: This is the fix. No later follow-up on the file. `5c8121262484d`
(“pata_ep93xx: fix deferred probing”) only touches `platform_get_irq()`,
not DMA init.

## Phase 7: Subsystem context

**Step 7.1**
Record: Subsystem `drivers/ata` (libata PATA). Criticality
**PERIPHERAL/IMPORTANT**: storage driver, but only Cirrus EP93xx
(`CONFIG_PATA_EP93XX` depends on `ARCH_EP93XX || COMPILE_TEST`).

**Step 7.2**
Record: File is mature (2012) with a burst of DT work in 6.12; otherwise
low churn.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: EP93xx PATA users on DT kernels (6.12+). Not universal. In-tree
boards do not enable the IDE node today; anyone enabling it per the
binding (no `dmas`; `additionalProperties: false`) is affected.

**Step 8.2 — Trigger**
Record: Device probe. Common if the node is enabled: official
dtsi/binding have no DMA properties, so `dma_request_chan("rx")` returns
`-ENODEV` every boot. Unprivileged userspace cannot trigger it. Not a
race.

**Step 8.3 — Failure mode**
Record:
- Main: probe fails → no ATA host → disk missing (boot/rootfs failure if
  PATA is the disk). Severity **HIGH** for those boards, not a kernel
  oops.
- Secondary (rx OK, tx fail): `dma_release_channel(ERR_PTR)` / double-
  release. Severity **HIGH** if hit; needs a DT with a working `rx` name
  and failing `tx`. Not the in-tree DT shape.

**Step 8.4 — Risk/benefit**
Record: Benefit medium-high for EP93xx DT PATA (driver actually binds).
Risk very low (error path only, ~20 lines, maintainer-acked). Ratio
favors backport.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Real v6.12 regression: DMA init errors abort probe; original design
  and probe still expect PIO fallback.
- In-tree binding/example/dtsi do not describe DMA, so `-ENODEV` is the
  realistic `dma_request_chan()` result if the node is enabled.
- Also closes a bad tx-fail cleanup (ERR_PTR / double-release).
- Small, obviously correct; Niklas: “looks correct”; Damien applied it.
- Prerequisites (`dma_request_chan` conversion) are in this tree.

AGAINST:
- Niche SoC; IDE node disabled in all in-tree boards — limited default
  user base.
- No crash/syzbot/user report.
- Not a new feature, but also not a universal core-kernel bug.

UNRESOLVED:
- Whether any production EP93xx DT out of tree enables this node
  (unverified).
- No stable@ thread found beyond linux-ide.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — logic matches pre-6.12; v1
   reviewed; maintainer applied. No separate hardware Tested-by.
2. Real bug affecting users? **PASS** — probe failure / non-working PATA
   when DMA is absent.
3. Important (crash/security/corruption/deadlock/etc.)? **PASS** —
   storage controller fails to register (boot-breaking if PATA is the
   disk). Not an oops, but functionally serious. Secondary error-path
   UAF-class DMA release if tx fails after rx.
4. Small and contained? **PASS** — one function, +21/−9.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — same `dma_request_chan` code; DT
   conversion is present.

**Step 9.3 — Exception category**
Record: None (not an ID/quirk/DT/build/doc exception). Ordinary driver
bugfix.

**Step 9.4 — Decision**
This tree is **7.3-rc4**. The v6.12 DT conversion is here, so the bug
exists in this lineage. The patch restores the driver’s intended PIO
fallback, keeps `-EPROBE_DEFER`, and is a small, reviewed error-path
fix. It meets stable criteria for this checkout.

What it solves for stable users: after the 6.12 OF DMA switch, missing
DMA (the documented DT) made `pata_ep93xx` fail probe instead of running
PIO. That can leave the disk missing. Risk is low; no extra commits are
required here.

Verification:
- [Phase 1] Parsed tags: author + Damien SOB only; no Fixes/Reported-
  by/Cc:stable
- [Phase 2] Diff: `ep93xx_pata_dma_init()` error paths; return 0 except
  `-EPROBE_DEFER`; NULL ERR_PTRs; split `fail_release_rx` from
  `fail_release_dma`
- [Phase 2] Parent file: `git show
  c303c3619a1d5^:drivers/ata/pata_ep93xx.c` confirms probe abort + fall-
  through release
- [Phase 2] `dma_release_channel()` dereferences `chan->client_count` —
  ERR_PTR would oops
- [Phase 3] Blame: buggy `dma_request_chan` from `9963113e3a924`
  (v6.12-rc1); `git merge-base --is-ancestor 9963113e3a924 HEAD` true
- [Phase 3] Pre-DT `dma_init` was void and already fell back to PIO
- [Phase 4] `b4 dig -c c303c3619a1d5`: v1 2026-06-01, v2 2026-07-19
  (message-only)
- [Phase 4] Niklas Cassel: “looks correct”; Damien: “Applied to for-7.3”
- [Phase 5] Only caller: `ep93xx_pata_probe()`;
  `of_dma_request_slave_channel` returns `-ENODEV` without `dmas`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 6] Binding `cirrus,ep9312-pata.yaml`: no dmas,
  `additionalProperties: false`; dtsi `ide@800a0000` has no dmas, status
  disabled; no `&ide` enable in in-tree boards
- [Phase 8] Failure: probe fail / no disk; not an oops on the common
  `-ENODEV` path
- UNVERIFIED: out-of-tree boards enabling this node; stable@ mailing
  list beyond linux-ide

**YES**

 drivers/ata/pata_ep93xx.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index b2b9e0058333e..3f61712af5bbe 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -652,14 +652,22 @@ static int ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 	 * start of new transfer.
 	 */
 	drv_data->dma_rx_channel = dma_request_chan(dev, "rx");
-	if (IS_ERR(drv_data->dma_rx_channel))
-		return dev_err_probe(dev, PTR_ERR(drv_data->dma_rx_channel),
-				     "rx DMA setup failed\n");
+	if (IS_ERR(drv_data->dma_rx_channel)) {
+		ret = PTR_ERR(drv_data->dma_rx_channel);
+		drv_data->dma_rx_channel = NULL;
+		if (ret == -EPROBE_DEFER)
+			return ret;
+		dev_warn(dev, "rx DMA unavailable, using PIO\n");
+		return 0;
+	}
 
 	drv_data->dma_tx_channel = dma_request_chan(&pdev->dev, "tx");
 	if (IS_ERR(drv_data->dma_tx_channel)) {
-		ret = dev_err_probe(dev, PTR_ERR(drv_data->dma_tx_channel),
-				    "tx DMA setup failed\n");
+		ret = PTR_ERR(drv_data->dma_tx_channel);
+		drv_data->dma_tx_channel = NULL;
+		if (ret == -EPROBE_DEFER)
+			goto fail_release_rx;
+		dev_warn(dev, "tx DMA unavailable, using PIO\n");
 		goto fail_release_rx;
 	}
 
@@ -670,7 +678,7 @@ static int ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 	conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	ret = dmaengine_slave_config(drv_data->dma_rx_channel, &conf);
 	if (ret) {
-		dev_err_probe(dev, ret, "failed to configure rx dma channel");
+		dev_warn(dev, "failed to configure rx dma channel, using PIO\n");
 		goto fail_release_dma;
 	}
 
@@ -681,7 +689,7 @@ static int ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 	conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	ret = dmaengine_slave_config(drv_data->dma_tx_channel, &conf);
 	if (ret) {
-		dev_err_probe(dev, ret, "failed to configure tx dma channel");
+		dev_warn(dev, "failed to configure tx dma channel, using PIO\n");
 		goto fail_release_dma;
 	}
 
@@ -689,10 +697,14 @@ static int ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 
 fail_release_rx:
 	dma_release_channel(drv_data->dma_rx_channel);
+	drv_data->dma_rx_channel = NULL;
+	if (ret == -EPROBE_DEFER)
+		return ret;
+	return 0;
+
 fail_release_dma:
 	ep93xx_pata_release_dma(drv_data);
-
-	return ret;
+	return 0;
 }
 
 static void ep93xx_pata_dma_start(struct ata_queued_cmd *qc)
-- 
2.53.0

