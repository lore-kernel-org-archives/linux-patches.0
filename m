Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F8348AE29;
	Mon, 20 Apr 2026 13:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691918; cv=none; b=eG0Sd/ZS7sYrDCt+592TJXTj+eCKQo80BEICDx4xzDXzM0kH2COJ23jTTYgsFBVRzangc76OP9g9fbYX/f11QCANnYR3+UD6x2cKOFrjtWMWNpbV/i0vdFqOXLQO8ZdbRbjesMgPCOPmVpmsQn6czK6OH9ft/jZ2AvDv9PBQeqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691918; c=relaxed/simple;
	bh=ySf/LE2O06y+dCF/bB7jvsvf0tUNgkD8x1b2qFu+YiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCjU9FparknQlnviLQ2T+O4gKoCxSBoUs6VqCGppO19kMs5cdSJRDs8JeAv1s/77cnflp2VZloqchi6xo1wYt7hyIplSvDQmgr3JZxhOhVSMrv4vWp89E6R8egycI7sbOYqG/7uDK+ESt+FRkY7Aj0wyRwzHf7NquGNOtOmEpzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4JmStDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4JmStDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FB9C2BCB9;
	Mon, 20 Apr 2026 13:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691918;
	bh=ySf/LE2O06y+dCF/bB7jvsvf0tUNgkD8x1b2qFu+YiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4JmStDpodyleQ2ZevNgGLFlAdoYfFRV+GVamMFnHM4UfCJi2yUJSuuJXrOiste1D
	 uYuMFBikhAW/g2PQABkR44509iM8vTVbUplXWQjTB+OTJj5lyz4z5Ou+Uz1bT0n2L2
	 bCXz7IzgsmVkgzGw/D3B1Wn7AdU0UX6/NPAOdQ4c2QZ5H7oGwFXlga6UbbzO2yl9n0
	 G8ov+SmVOtOBbd9I0qSqGT+fGO9+hRy7wavR6P4//na+dvAP8WG0CA118cmAQjPH8i
	 wufY7zVZScIS7uJ6QkQl5UL5Uq9Gys6+o1WxJZ+vCeZnRfUdBUqBjg/U7ySxX93asX
	 aA8MhjFp8CIfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gary Bisson <bisson.gary@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	p.zabel@pengutronix.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	matthias.bgg@gmail.com,
	dri-devel@lists.freedesktop.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 7.0-5.10] drm/mediatek: mtk_dsi: enable hs clock during pre-enable
Date: Mon, 20 Apr 2026 09:21:02 -0400
Message-ID: <20260420132314.1023554-268-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Gary Bisson <bisson.gary@gmail.com>

[ Upstream commit 76255024cadbe8c40462953f8193d2d78cd3b0ac ]

Some bridges, such as the TI SN65DSI83, require the HS clock to be
running in order to lock its PLL during its own pre-enable function.

Without this change, the bridge gives the following error:
sn65dsi83 14-002c: failed to lock PLL, ret=-110
sn65dsi83 14-002c: Unexpected link status 0x01
sn65dsi83 14-002c: reset the pipe

Move the necessary functions from enable to pre-enable.

Signed-off-by: Gary Bisson <bisson.gary@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Tested-by: Chen-Yu Tsai <wenst@chromium.org> # Chromebooks
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260120-mtkdsi-v1-1-b0f4094f3ac3@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. Now I have all the information needed for a comprehensive
analysis.

---

## Complete Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/mediatek: mtk_dsi`
- Action: "enable" (HS clock during pre-enable)
- Summary: Move HS clock activation from the bridge enable phase to pre-
  enable so downstream bridges can use it.
Record: [drm/mediatek] [enable] [Move HS clock setup earlier to fix
bridge PLL locking]

**Step 1.2: Tags**
- Signed-off-by: Gary Bisson (author)
- Reviewed-by: CK Hu (MediaTek DSI maintainer)
- Tested-by: Chen-Yu Tsai (Chromium developer) on 5 Chromebook variants
- Tested-by: AngeloGioacchino Del Regno (Collabora, regular MTK
  contributor)
- Reviewed-by: AngeloGioacchino Del Regno
- Link: to patchwork entry
- Signed-off-by: Chun-Kuang Hu (subsystem maintainer, merged it)

Record: Strong review and testing from 3 independent testers across 7+
hardware platforms. Maintainer reviewed and approved.

**Step 1.3: Commit Body**
- Bug: SN65DSI83 bridge chip fails to lock its PLL during pre-enable,
  resulting in errors: "failed to lock PLL, ret=-110" / "Unexpected link
  status 0x01" / "reset the pipe"
- Root cause: HS clock not running during the pre-enable phase
- Fix: Move `mtk_dsi_lane_ready()` and `mtk_dsi_clk_hs_mode(dsi, 1)`
  from enable to pre-enable (poweron)
Record: Clear bug description with error messages. Display completely
fails without fix.

**Step 1.4: Hidden Bug Fix?**
This is NOT hidden - it's explicitly a fix for display not working with
certain DSI bridges.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file: `drivers/gpu/drm/mediatek/mtk_dsi.c`
- +17 / -18 lines (net -1 line)
- Functions modified: `mtk_dsi_lane_ready()` (moved earlier),
  `mtk_dsi_poweron()` (added 2 calls), `mtk_output_dsi_enable()`
  (removed 3 lines)
Record: Single-file surgical fix, minimal scope.

**Step 2.2: Code Flow Change**
- `mtk_dsi_lane_ready()` function definition moved earlier (before
  `mtk_dsi_poweron`) - this is purely for forward declaration ordering
- In `mtk_dsi_poweron()` (called during bridge pre_enable): added
  `mtk_dsi_lane_ready(dsi)` and `mtk_dsi_clk_hs_mode(dsi, 1)` at end
- In `mtk_output_dsi_enable()` (called during bridge enable): removed
  `mtk_dsi_lane_ready(dsi)` and `mtk_dsi_clk_hs_mode(dsi, 1)`, kept
  `mtk_dsi_set_mode(dsi)` and `mtk_dsi_start(dsi)`

Before: Lane ready + HS clock in enable phase
After: Lane ready + HS clock in pre-enable phase

**Step 2.3: Bug Mechanism**
Category: Hardware interoperability / timing issue. The SN65DSI83 bridge
requires HS clock from the DSI host during its pre_enable to lock its
PLL. Without HS clock, the bridge fails completely.

**Step 2.4: Fix Quality**
- Obviously correct: just moves existing function calls earlier in the
  init sequence
- Minimal: no new logic, no new code paths
- Regression risk is LOW: extensively tested on 7+ platforms with
  different bridges/panels, all confirmed no regressions

### PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- `mtk_dsi_lane_ready()` introduced by commit `39e8d062b03c3d` (Jitao
  Shi, 2022-05-20) - present since ~v5.19
- `mtk_dsi_clk_hs_mode(dsi, 1)` in enable path introduced by
  `80a5cfd60d2a94` (yt.shen@mediatek.com, 2017-03-31) - present since
  v4.x
- The buggy ordering has existed since 2022 when lane_ready was moved to
  enable
Record: Bug present in all active stable trees (v5.19+)

**Step 3.2: No Fixes: tag** (expected for autosel candidate)

**Step 3.3: File History**
- Recent changes to mtk_dsi.c include bridge API updates
  (devm_drm_bridge_alloc, encoder parameter), HS mode support, pre-
  enable order fix/revert
- The pre-enable order fix/revert (f5b1819193667 / 33e8150bd32d7) is
  related but independent - it was about `pre_enable_prev_first` flag
  management

**Step 3.4: Author**
- Gary Bisson is a regular contributor to MediaTek platforms (Tungsten
  boards), actively maintains DT and driver support

**Step 3.5: Dependencies**
- No dependencies. The commit 8b00951402f74 (HS mode in cmdq) is
  completely independent
- The SN65DSI83 driver already sets `pre_enable_prev_first = true`,
  ensuring correct bridge ordering

### PHASE 4: MAILING LIST DISCUSSION

**Step 4.1: Original Discussion**
- b4 mbox retrieved 5 messages in the thread
- CK Hu (MediaTek DSI maintainer) noted "this changes the flow for all
  SoC and panel, so I would wait for more SoC and more panel test" -
  then gave Reviewed-by after testing completed
- AngeloGioacchino Del Regno tested on MT6795 + MT8395, gave both
  Tested-by and Reviewed-by
- Chen-Yu Tsai tested on 5 Chromebook models (MT8173, MT8183x2,
  MT8186x2) - "No regressions observed"
- Chun-Kuang Hu applied it with message "Applied to mediatek-drm-next"

**Step 4.2: Reviewers**
All appropriate MediaTek subsystem maintainers were CC'd and reviewed.
CK Hu explicitly asked for extensive testing, which was provided.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `mtk_dsi_poweron()`: called from `mtk_dsi_bridge_atomic_pre_enable()`
  and `mtk_dsi_ddp_start()`
- `mtk_output_dsi_enable()`: called from
  `mtk_dsi_bridge_atomic_enable()`
- `mtk_dsi_lane_ready()`: also called from `mtk_dsi_host_transfer()`
  (for DSI command transfers)

**Step 5.2: Impact on mtk_dsi_host_transfer**
After the patch, `mtk_dsi_lane_ready()` call in
`mtk_dsi_host_transfer()` becomes a no-op during normal operation (lanes
already ready from poweron). This is safe because DSI must be powered on
before any host transfers.

**Step 5.3: Bridge ordering confirmed**
The SN65DSI83 bridge driver sets `ctx->bridge.pre_enable_prev_first =
true` (line 1041 of `ti-sn65dsi83.c`), which causes
`drm_atomic_bridge_chain_pre_enable()` to call the MTK DSI pre_enable
BEFORE the SN65DSI83's pre_enable. This confirms the fix works
correctly.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code exists in stable trees**
The buggy code (`mtk_dsi_lane_ready()` being called from enable instead
of pre_enable) has been present since v5.19, so it affects all active
stable trees from 6.1 onwards.

**Step 6.2: Backport difficulty**
The patch should apply cleanly - the context in `mtk_dsi_poweron()` and
`mtk_output_dsi_enable()` is unchanged in the 7.0 tree.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- drm/mediatek (DRM display driver) - IMPORTANT category
- MediaTek SoCs are used extensively in Chromebooks, Android devices,
  and embedded systems

### PHASE 8: IMPACT AND RISK

**Step 8.1: Affected users**
Users of MediaTek SoCs with DSI bridges that need HS clock during
initialization (specifically SN65DSI83, potentially others).

**Step 8.2: Trigger conditions**
Every display initialization when using SN65DSI83 with MediaTek DSI. The
display simply doesn't work.

**Step 8.3: Failure mode**
Without fix: Display completely fails to initialize (PLL lock fails,
bridge errors, no display output). Severity: HIGH - affects usability.

**Step 8.4: Risk-Benefit**
- Benefit: HIGH - enables display to work for specific bridge
  combinations, no regressions observed on 7+ platforms
- Risk: LOW - moves existing function calls earlier, extensively tested,
  well-reviewed, single file

### PHASE 9: SYNTHESIS

**Evidence FOR backporting:**
1. Fixes a real hardware bug: display doesn't work with SN65DSI83 bridge
2. Small, surgical change (17 insertions, 18 deletions, net -1 line,
   single file)
3. Extensive testing: 7+ platforms (Chromebooks, MediaTek boards) - zero
   regressions
4. Strong review: MediaTek DSI maintainer, Collabora engineer, Chromium
   developer
5. Code is well-understood: simply moves existing calls from enable to
   pre-enable
6. Affects popular hardware (Chromebooks use MediaTek SoCs extensively)

**Evidence AGAINST backporting:**
1. CK Hu noted it "changes the flow for all SoC and panel" - but this
   concern was addressed by extensive testing
2. No explicit Cc: stable tag - but this is expected for autosel
   candidates

**Stable rules checklist:**
1. Obviously correct and tested? YES - extensively tested on 7+
   platforms
2. Fixes a real bug? YES - display completely fails with SN65DSI83
   bridge
3. Important issue? YES - hardware doesn't work (no display output)
4. Small and contained? YES - single file, 35 lines total changed
5. No new features? YES - just moves existing code to different phase
6. Can apply to stable? YES - context appears unchanged

---

### Verification

- [Phase 1] Parsed tags: Reviewed-by (CK Hu, AngeloGioacchino), Tested-
  by (Chen-Yu Tsai on 5 Chromebooks, AngeloGioacchino on 2 platforms)
- [Phase 2] Diff analysis: mtk_dsi_lane_ready + clk_hs_mode moved from
  enable to poweron (pre_enable), 17 add / 18 del
- [Phase 3] git blame: lane_ready introduced in commit 39e8d062b03c3d
  (2022, v5.19), clk_hs_mode in enable since 80a5cfd60d2a94 (2017)
- [Phase 3] git show 33e8150bd32d7: revert of pre_enable_prev_first in
  MediaTek DSI is independent
- [Phase 3] git show 8b00951402f74: HS mode support in cmdq is
  independent, no dependency
- [Phase 4] b4 mbox retrieved thread: CK Hu reviewed, requested more
  testing, got it; patch applied to mediatek-drm-next
- [Phase 4] Chen-Yu Tsai tested on MT8173, MT8183, MT8186 Chromebooks -
  no regressions
- [Phase 4] AngeloGioacchino tested on MT6795, MT8395 - no regressions
- [Phase 5] Confirmed SN65DSI83 sets pre_enable_prev_first=true (line
  1041), so MTK DSI pre_enable runs before SN65DSI83 pre_enable
- [Phase 5] mtk_dsi_host_transfer's call to lane_ready() becomes no-op
  (safe)
- [Phase 6] Buggy code exists in all stable trees since v5.19
- [Phase 8] Failure mode: display doesn't work at all (PLL lock fails),
  severity HIGH

The fix is small, surgical, well-tested across multiple platforms, and
fixes a real hardware bug where display completely fails with SN65DSI83
bridges on MediaTek DSI.

**YES**

 drivers/gpu/drm/mediatek/mtk_dsi.c | 35 +++++++++++++++---------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index aaf6c9ebd319f..5aa71fcdcfab7 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -673,6 +673,21 @@ static s32 mtk_dsi_switch_to_cmd_mode(struct mtk_dsi *dsi, u8 irq_flag, u32 t)
 	}
 }
 
+static void mtk_dsi_lane_ready(struct mtk_dsi *dsi)
+{
+	if (!dsi->lanes_ready) {
+		dsi->lanes_ready = true;
+		mtk_dsi_rxtx_control(dsi);
+		usleep_range(30, 100);
+		mtk_dsi_reset_dphy(dsi);
+		mtk_dsi_clk_ulp_mode_leave(dsi);
+		mtk_dsi_lane0_ulp_mode_leave(dsi);
+		mtk_dsi_clk_hs_mode(dsi, 0);
+		usleep_range(1000, 3000);
+		/* The reaction time after pulling up the mipi signal for dsi_rx */
+	}
+}
+
 static int mtk_dsi_poweron(struct mtk_dsi *dsi)
 {
 	struct device *dev = dsi->host.dev;
@@ -725,6 +740,8 @@ static int mtk_dsi_poweron(struct mtk_dsi *dsi)
 	mtk_dsi_set_vm_cmd(dsi);
 	mtk_dsi_config_vdo_timing(dsi);
 	mtk_dsi_set_interrupt_enable(dsi);
+	mtk_dsi_lane_ready(dsi);
+	mtk_dsi_clk_hs_mode(dsi, 1);
 
 	return 0;
 err_disable_engine_clk:
@@ -770,30 +787,12 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
 	dsi->lanes_ready = false;
 }
 
-static void mtk_dsi_lane_ready(struct mtk_dsi *dsi)
-{
-	if (!dsi->lanes_ready) {
-		dsi->lanes_ready = true;
-		mtk_dsi_rxtx_control(dsi);
-		usleep_range(30, 100);
-		mtk_dsi_reset_dphy(dsi);
-		mtk_dsi_clk_ulp_mode_leave(dsi);
-		mtk_dsi_lane0_ulp_mode_leave(dsi);
-		mtk_dsi_clk_hs_mode(dsi, 0);
-		usleep_range(1000, 3000);
-		/* The reaction time after pulling up the mipi signal for dsi_rx */
-	}
-}
-
 static void mtk_output_dsi_enable(struct mtk_dsi *dsi)
 {
 	if (dsi->enabled)
 		return;
 
-	mtk_dsi_lane_ready(dsi);
 	mtk_dsi_set_mode(dsi);
-	mtk_dsi_clk_hs_mode(dsi, 1);
-
 	mtk_dsi_start(dsi);
 
 	dsi->enabled = true;
-- 
2.53.0

