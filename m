Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE161E520A;
	Sat, 17 Oct 2026 16:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253958; cv=none; b=fmYf/ZI6pzukqn3NuHg7+xg+BuLDRsVExeNsbQ50Nstj1TxHZ15sZu4OzNAkiv8Th6fg7VjRwfdxNQ+6DvzRnJBc0ZXXEGYJgSb/yJvuO97q/2v6g8zSmWXQjf4c1R9lGXCUVWrgxOIQMnc0yr2ySstgmHB5mJh9qSECMi1XqaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253958; c=relaxed/simple;
	bh=MQrTPWGsfk333/TIbd5d7Ft5GJxmg3lmFCE2xIPbWqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bF4OKToEx+p7ZWi+QxfyICxqhLWQaiEBnkfeQwFCm5eQsKH1mIGSiSaFEZZFwwNC3JCPxT2qGqilJLsuOX94JV+UP8dliCOpBezoMeXrT0JVVywCeoVaUiYM6RExjwfzsJJNtseewRFuQb+YjSHFelqTndYF1iy5KhQUyTYGI0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GE4EmmNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GE4EmmNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DC51F000C4;
	Sat, 17 Oct 2026 16:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253957;
	bh=1hEBXOaGI+GS3gxxTmIHyIUyy7D7HtACSwMd6wfv0jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GE4EmmNlMuFVclznr+ownDD7Oq9y+ajAjOw0vv6kx8efyDTjPbeNMtJOa/yMom4Q1
	 SnKxYdRBpIBSUeaV6WDi9g9vWbc8DJ3wGeM08nLRb4y2ttS71l72C4bP7NlkujrP84
	 5Qe5jXxF+KLp1nKh7w+/51wV/OmuFrV6mCOU+bxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/869] drm: renesas: rz-du: mipi_dsi: fix kernel panic when rebooting for some panels
Date: Sat, 17 Oct 2026 17:51:30 +0200
Message-ID: <20261017160043.442628934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index a9216a99b2be1..5b8da2b6cbd0f 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
@@ -574,6 +574,13 @@ static void rzg2l_mipi_dsi_atomic_disable(struct drm_bridge *bridge,
 
 	rzg2l_mipi_dsi_stop_video(dsi);
 	rzg2l_mipi_dsi_stop_hs_clock(dsi);
+}
+
+static void rzg2l_mipi_dsi_atomic_post_disable(struct drm_bridge *bridge,
+					       struct drm_bridge_state *old_bridge_state)
+{
+	struct rzg2l_mipi_dsi *dsi = bridge_to_rzg2l_mipi_dsi(bridge);
+
 	rzg2l_mipi_dsi_stop(dsi);
 }
 
@@ -598,6 +605,7 @@ static const struct drm_bridge_funcs rzg2l_mipi_dsi_bridge_ops = {
 	.atomic_reset = drm_atomic_helper_bridge_reset,
 	.atomic_enable = rzg2l_mipi_dsi_atomic_enable,
 	.atomic_disable = rzg2l_mipi_dsi_atomic_disable,
+	.atomic_post_disable = rzg2l_mipi_dsi_atomic_post_disable,
 	.mode_valid = rzg2l_mipi_dsi_bridge_mode_valid,
 };
 
-- 
2.53.0



