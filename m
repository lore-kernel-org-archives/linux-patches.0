Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273CC34A77A;
	Tue, 11 Nov 2025 01:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823230; cv=none; b=h2jPuJhMUkeakpKmqGu65/nMyHNcr/cXFdygTN47ypAuDtMiGhJgN3gK30mEMFAgnZ9hZHn8w9oe1GwsHWFXiBTP9BDuW9tGR0gqUGF5jl0qKciE2Qdb0+/gAGqJ2/SAvRCraWFXP8Da7xEWfn5sytuLX6Gr4ZJZKC8MUcwhL9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823230; c=relaxed/simple;
	bh=Bqw9tZfAv5SartoohybGiZgHWyFA15My85vxsVgsuKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgoHvhdCGWSVpxGWKcu9fARX7P0WGOiqEmUjbwIpZ879lAFEdcOjyJxeW7P+9zrCYoxIH9PTrrwzrm+TSRUnZecn72EYX5flpp2hpfAGw+2XesB/8uO+Mi5BT37SDZv4JIaJY1xR8424Bifw7Rr9Uy0Faf4OgLYyahso9JjCtAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqTXxDl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqTXxDl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B470C16AAE;
	Tue, 11 Nov 2025 01:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823229;
	bh=Bqw9tZfAv5SartoohybGiZgHWyFA15My85vxsVgsuKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqTXxDl6Vimr5pWMZvTKoBDYIbXgi8cc0ZVJRnbfg36FD2xx1N7ZZVHeJrYvgr9cp
	 1/qe+1OuRpUMdAo8X2z26HdMOkc3Cghx9uPZA2TgSsS+fWWqsREbl0QWdt8k6VTbaG
	 fnXBigsWfjQRGdCeC9hAXL2hfA2R/dbS3Dxlgof8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/565] drm/bridge: cdns-dsi: Fix REG_WAKEUP_TIME value
Date: Tue, 11 Nov 2025 09:40:57 +0900
Message-ID: <20251111004531.449320247@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
index 89eed0668bfb2..faa0bdfd19370 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -833,7 +833,13 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
 
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



