Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE28B3254A0;
	Sat, 25 Oct 2025 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409755; cv=none; b=ptIxhnaPajbdmrfywUt6+skid7+GuF/zVSeypyjMumOJkN6eRV/txyJ7DQEEAfggd1f7JllqpdjsY+yPRY17iMjGDh6bL6IfQxbg74TniGCWsQYlzzQXrQTA970m4m1zLj8oweLwVHnZz1R/m+UojZZl8BahI30DunsB81eAy74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409755; c=relaxed/simple;
	bh=0UAtC3i7JHqia4/gM7aePnQMzTSXWqQuvIi55L4b+KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BCyUJx+wIieQ2URIdUgldQRb2PktXPw9ExQioP0dHUa3kEOdQauC92lgBKrwMuojBmHQLF2dR4H2Q6i1IgoDHVreMLnrXa9WgomddCVgW9moSMfyli++u8Z7AGXnQd07WYk0Q0up3G8QpERAXvwtMIOX9v1r3tmmHCki/xN/q1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJyQMutU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJyQMutU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839EAC4CEFF;
	Sat, 25 Oct 2025 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409755;
	bh=0UAtC3i7JHqia4/gM7aePnQMzTSXWqQuvIi55L4b+KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJyQMutUNZ8hv7srgAjckSjNXlc6xuXNZ4vViQknClOvdoEi70GbpNZqwJRreLkdn
	 lOVepYYB2NBdkepb32PwWEZHNUyMa2ty3Y+hUlarBDM+6aX+Q9iDG6itvB7HobZVGw
	 sBQGsoxcoyWbQhtD5HgtypxG5rI2JKbBbG4mh7h107RFBkRgco47luX2ZRFzAU249M
	 EwEMCWsSNq0GEpe1gKbaFew7Ym0t8LdfnmKE/TRpgRo9I+pbSS8Gwvefx05Lm9W27E
	 sZZbt9/BYLA89KgZDuBOEWiJ0tJdzroUhdgKel7ymrMJ7iXsKw/UYX3W94YBDCngAw
	 dOotyTmE4Ln2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Sasha Levin <sashal@kernel.org>,
	aradhya.bhatia@linux.dev,
	lumag@kernel.org,
	mripard@kernel.org,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.6] drm/bridge: cdns-dsi: Fix REG_WAKEUP_TIME value
Date: Sat, 25 Oct 2025 12:01:21 -0400
Message-ID: <20251025160905.3857885-450-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit eea4f89b6461294ed6bea1d3285bb3f79c09a041 ]

The driver tries to calculate the value for REG_WAKEUP_TIME. However,
the calculation itself is not correct, and to add on it, the resulting
value is almost always larger than the field's size, so the actual
result is more or less random.

According to the docs, figuring out the value for REG_WAKEUP_TIME
requires HW characterization and there's no way to have a generic
algorithm to come up with the value. That doesn't help at all...

However, we know that the value must be smaller than the line time, and,
at least in my understanding, the proper value for it is quite small.
Testing shows that setting it to 1/10 of the line time seems to work
well. All video modes from my HDMI monitor work with this algorithm.

Hopefully we'll get more information on how to calculate the value, and
we can then update this.

Tested-by: Parth Pancholi <parth.pancholi@toradex.com>
Tested-by: Jayesh Choudhary <j-choudhary@ti.com>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Link: https://lore.kernel.org/r/20250723-cdns-dsi-impro-v5-11-e61cc06074c2@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Corrects a long‑standing misprogramming of the D-PHY LP->HS “wakeup”
    time in the Cadence DSI bridge. The old value was computed from PHY
    timing options with a units mismatch and an unsuitable formula,
    often overflowing the field and yielding essentially arbitrary
    hardware values.

- Evidence in code (current tree)
  - Register layout and programming:
    `drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c:312-314` define
    `VID_DPHY_TIME`, with `REG_WAKEUP_TIME(x) ((x) << 17)` and
    `REG_LINE_DURATION(x) (x)`. Wakeup occupies the upper bits; line
    duration the lower bits.
  - Current computation and write: `drivers/gpu/drm/bridge/cadence/cdns-
    dsi-core.c:834-838`
    - `tx_byte_period = DIV_ROUND_DOWN_ULL((u64)NSEC_PER_SEC * 8,
      phy_cfg->hs_clk_rate);` (nanoseconds per byte)
    - `reg_wakeup = (phy_cfg->hs_prepare + phy_cfg->hs_zero) /
      tx_byte_period;`
    - `writel(REG_WAKEUP_TIME(reg_wakeup) | REG_LINE_DURATION(tmp),
      dsi->regs + VID_DPHY_TIME);`
  - Problem 1 — units mismatch: `hs_prepare`/`hs_zero` are in
    picoseconds (see `include/linux/phy/phy-mipi-dphy.h:148-172,
    196-205`), but `tx_byte_period` is in nanoseconds. The integer
    division computes ps/ns (i.e., ≈1000× larger than intended).
  - Problem 2 — field overflow/undefined value: With the 1000× inflation
    and faster HS clock rates, `reg_wakeup` frequently exceeds the
    WAKEUP field width (bits 31:17 = 15 bits). Since no mask is applied,
    the hardware sees only truncated low bits after the shift-or with
    `REG_LINE_DURATION`, effectively a near-random small value in the
    field, matching the commit message’s “more or less random.”

- What the new commit changes
  - Replaces the bogus formula with a robust heuristic tied to the
    actual line duration: `reg_wakeup = dsi_cfg.htotal / nlanes / 10;`
    and comments why (needs HW characterization; keep it well below line
    time). This computes wakeup in TX byte‑clock cycles, consistent with
    how `REG_LINE_DURATION(tmp)` is computed.
  - The new value is small and scales with the mode; it avoids overflow
    and is in the same order of magnitude as other drivers’ choices. As
    a reference point, Cadence’s generic PHY defaults a wakeup around
    sub‑microsecond scale (`drivers/phy/cadence/cdns-dphy.c:19` and
    `drivers/phy/cadence/cdns-dphy.c:194-197` return 800 ns), and other
    DSI blocks pick small constants (e.g., MCDE uses 48 cycles:
    `drivers/gpu/drm/mcde/mcde_dsi.c:664-665`).

- Impact and risk assessment
  - User‑visible bug: Incorrect wakeup timing can cause unreliable
    LP->HS transitions, leading to link flakiness, timeouts, or mode
    bring‑up failures, especially across different bit rates and modes.
    The current code’s overflow/truncation makes the behavior highly
    variable across configurations.
  - Change scope: One local assignment in the DSI bridge enable path
    plus a clarifying comment. No ABI/IOCTL changes, no architectural
    refactoring, no cross‑subsystem impact.
  - Regression risk: Low. The new heuristic is conservative (≤10% of
    line duration in byte clocks), scales correctly with lanes and mode,
    and has been Tested-by multiple vendors in the series. It also
    aligns with the common practice of using small, fixed/relative
    wakeup windows for D-PHY bring‑up.
  - Security: None; non‑security functional fix.

- Stable criteria
  - Fixes an actual bug affecting users (wrong units and overflowing
    field → unstable hardware timing).
  - Minimal and self‑contained change in a single driver file.
  - No new features or architectural changes.
  - Touches a display bridge, not core kernel subsystems, and is
    unlikely to destabilize unrelated components.
  - While the commit message doesn’t include explicit “Fixes:”/“Cc:
    stable” tags, the defect is clear from the code and rationale. The
    change is appropriate for stable trees that include the Cadence DSI
    driver after it was converted to the PHY framework (see blame around
    `drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c:835-838`).

- Backport notes
  - Upstream function name may differ by kernel version (your diff
    mentions `cdns_dsi_bridge_atomic_pre_enable`, older trees use
    `cdns_dsi_bridge_enable` as in `drivers/gpu/drm/bridge/cadence/cdns-
    dsi-core.c:763-900`). The logic and variables (`dsi_cfg.htotal`,
    `nlanes`, `phy_cfg`) are present; adapting the exact insertion point
    is straightforward.
  - No dependencies on other series patches for this specific line
    change.

Given the clear correctness issue, confined scope, and practical
validation, this is a good candidate for stable backport.

 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
index 695b6246b280f..9f1c460d5f0d4 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -882,7 +882,13 @@ static void cdns_dsi_bridge_atomic_pre_enable(struct drm_bridge *bridge,
 
 	tx_byte_period = DIV_ROUND_DOWN_ULL((u64)NSEC_PER_SEC * 8,
 					    phy_cfg->hs_clk_rate);
-	reg_wakeup = (phy_cfg->hs_prepare + phy_cfg->hs_zero) / tx_byte_period;
+
+	/*
+	 * Estimated time [in clock cycles] to perform LP->HS on D-PHY.
+	 * It is not clear how to calculate this, so for now,
+	 * set it to 1/10 of the total number of clocks in a line.
+	 */
+	reg_wakeup = dsi_cfg.htotal / nlanes / 10;
 	writel(REG_WAKEUP_TIME(reg_wakeup) | REG_LINE_DURATION(tmp),
 	       dsi->regs + VID_DPHY_TIME);
 
-- 
2.51.0

