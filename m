Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7276E313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301032; cv=none; b=YkSDAkg9GrqsiqSBOX4LSgxspq410I4yToWJ2Qf0UXO3NrYDn5U4NVZoS2YP/vNZmZ6XFxOYMxRbRaVtPhC1VQqaQHf+IMrm0BgY5LMoNshvK4efId9EghqxxPkyWDB1+lYXin24HX1KX+10DlDu+7UbLkdZnfCKJaAXnzidEbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301032; c=relaxed/simple;
	bh=CGs+Yh1fzTOO0OdCToY9WGnEC+1GhZDEBJ9GM04t9O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr5uKJv2wOlAzwL8wODG65gr7qNNBX/QrBLf2dy9vxS5G5/vGbM/N3VNYlzmuJcLqqcgw5HuBFKlbMRLzPGDn+GqL/ug4PJ/q3pt44ShXUsTY19YQZkB1fykEVElCjW5jbfft1KciOpM5UHI93O+4YCbpgKTLg5VBGAdOGYLwQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ww5+eXJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ww5+eXJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D668CC116D0;
	Sat, 28 Feb 2026 17:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301032;
	bh=CGs+Yh1fzTOO0OdCToY9WGnEC+1GhZDEBJ9GM04t9O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ww5+eXJRvE2NsE1r9XvaibZITDZrcMRng4GctV95Q8Ju/uOQFWYUzi5VV33hxfVHF
	 k3XWrMsIrXk4Ae9P8oy9vXOaowriLyaekSqzV2gY0yfqgHbUf4FLwP3jiruXebuiOi
	 LDuofwwa3xUY257O8gQ5Jxa3vKgJR2rgiM4Yen2mDxQQay9PT47HUexbTZmh+SEqIR
	 qUE6RLB+dEDSwD4o1ydVPgC0rQXIwUMNDCFClB/25uYzWAsa7Tc4IZV7/AxGa+QEir
	 ycgG+hPzOfxX5HK9a4yO+CTimAewNP3Z7G+OqFMuDnWJaIxR52vBk/cY8foTzxCLj2
	 UudE8UaHckiFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/752] drm: renesas: rz-du: mipi_dsi: fix kernel panic when rebooting for some panels
Date: Sat, 28 Feb 2026 12:38:01 -0500
Message-ID: <20260228174750.1542406-170-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 64aa8b3a60a825134f7d866adf05c024bbe0c24c ]

Since commit 56de5e305d4b ("clk: renesas: r9a07g044: Add MSTOP for RZ/G2L")
we may get the following kernel panic, for some panels, when rebooting:

  systemd-shutdown[1]: Rebooting.
  Call trace:
   ...
   do_serror+0x28/0x68
   el1h_64_error_handler+0x34/0x50
   el1h_64_error+0x6c/0x70
   rzg2l_mipi_dsi_host_transfer+0x114/0x458 (P)
   mipi_dsi_device_transfer+0x44/0x58
   mipi_dsi_dcs_set_display_off_multi+0x9c/0xc4
   ili9881c_unprepare+0x38/0x88
   drm_panel_unprepare+0xbc/0x108

This happens for panels that need to send MIPI-DSI commands in their
unprepare() callback. Since the MIPI-DSI interface is stopped at that
point, rzg2l_mipi_dsi_host_transfer() triggers the kernel panic.

Fix by moving rzg2l_mipi_dsi_stop() to new callback function
rzg2l_mipi_dsi_atomic_post_disable().

With this change we now have the correct power-down/stop sequence:

  systemd-shutdown[1]: Rebooting.
  rzg2l-mipi-dsi 10850000.dsi: rzg2l_mipi_dsi_atomic_disable(): entry
  ili9881c-dsi 10850000.dsi.0: ili9881c_unprepare(): entry
  rzg2l-mipi-dsi 10850000.dsi: rzg2l_mipi_dsi_atomic_post_disable(): entry
  reboot: Restarting system

Suggested-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260112154333.655352-1-hugo@hugovil.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
index 3b52dfc0ea1e0..b164e3a62cc2f 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
@@ -646,6 +646,13 @@ static void rzg2l_mipi_dsi_atomic_disable(struct drm_bridge *bridge,
 
 	rzg2l_mipi_dsi_stop_video(dsi);
 	rzg2l_mipi_dsi_stop_hs_clock(dsi);
+}
+
+static void rzg2l_mipi_dsi_atomic_post_disable(struct drm_bridge *bridge,
+					       struct drm_atomic_state *state)
+{
+	struct rzg2l_mipi_dsi *dsi = bridge_to_rzg2l_mipi_dsi(bridge);
+
 	rzg2l_mipi_dsi_stop(dsi);
 }
 
@@ -681,6 +688,7 @@ static const struct drm_bridge_funcs rzg2l_mipi_dsi_bridge_ops = {
 	.atomic_pre_enable = rzg2l_mipi_dsi_atomic_pre_enable,
 	.atomic_enable = rzg2l_mipi_dsi_atomic_enable,
 	.atomic_disable = rzg2l_mipi_dsi_atomic_disable,
+	.atomic_post_disable = rzg2l_mipi_dsi_atomic_post_disable,
 	.mode_valid = rzg2l_mipi_dsi_bridge_mode_valid,
 };
 
-- 
2.51.0

