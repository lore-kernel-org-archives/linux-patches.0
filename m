Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1761347FCD;
	Fri, 21 Nov 2025 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732487; cv=none; b=WKyn5r94+pUt1OsAp4Nrgw9RhcdC2pPFp72vrYAwaqpdZmHYJXK2E5+0tZJ+LVBSa7DlunoLcQB1S781ineDsRTtiMY4uDdOkLTRkcDL9A3Q7IMo6Q0fzs53cDTdE0vSslOtNNtKua0s54kpHSzGA4NJAGr4A2dhDykA2ywM1bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732487; c=relaxed/simple;
	bh=YOADQjEpskIcpS2uDM1Ki9nCcAFLG2mySe6YGyoiBb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ng6JGoLlpZ2evNzsKhGSNQ/j7bklJN4NlfD8zgQmJeSkH3lS8iCmC95mEROuEFwEo5sbZmqpUte7HMotV08F3Ri/4Zuzf9DB6BSZsdxAauFQmSmm/KmrZAtv+LfSTj6aXKmQ6gYe/UUiO6ICkwgNEUy4bUR+Tpd2Ygza95D2GBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iy7DpJF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iy7DpJF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC2EC4CEF1;
	Fri, 21 Nov 2025 13:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732487;
	bh=YOADQjEpskIcpS2uDM1Ki9nCcAFLG2mySe6YGyoiBb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iy7DpJF0Xh3GB81aK5NoZ+ywXUD0wF2FIEow0NQ9Kmw8y4o+w2V8updJ/KkesWT9h
	 BiEXxtY3TIpUYs+Ge3oRGlUBUVDEqbN3F1g4aqNWreR8OKZBEtrQSEGhbcTewa5UIz
	 AvtJtcLUpqxtFJgZUHuu3/vlRiLQh5VA63SmnNRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/529] drm/bridge: cdns-dsi: Fix REG_WAKEUP_TIME value
Date: Fri, 21 Nov 2025 14:07:10 +0100
Message-ID: <20251121130235.681198881@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



