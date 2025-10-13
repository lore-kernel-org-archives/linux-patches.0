Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F6630C37E;
	Mon, 13 Oct 2025 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368249; cv=none; b=q8Qo5sPs08RfKoSIEoURkxRBuiwvprPTM/NlSR5e63MdqCYPZHqZw2mu+vowPfwCpFFUfx12zBCSY7JXHv91gMTyb1Glikt9k8JQvb0FXvT8RBdsb9m7sEdnDRCsvd6LldwY7lVrNXSSL+nwCGM1u3AKecP/JxMXH4GwxhvMwpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368249; c=relaxed/simple;
	bh=k59j627iKSztaJscYyaxLV32oIAb5QOUVXtrI5wfV1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inw2pbrGRdZnXaxQNnHi86t/DCNC/wMwtUBb8v9CCMTcDFiHWfTm7IuVX+udeLKrhz5cl1haE56pJrpxfTUXZf4CXt9Uv5agaVU9rL84t3o7uclxcdhBftnU4O8His8vceLRNAuQLFOkzJuOVSW09/TRM2wVWXWAoMaS118NiVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8HSjRgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8HSjRgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DC0C4CEE7;
	Mon, 13 Oct 2025 15:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368248;
	bh=k59j627iKSztaJscYyaxLV32oIAb5QOUVXtrI5wfV1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8HSjRgB6lHzYgjPBeM8L6ufyNv/LZ+h74oEhWy00Uib8RDJv1UVC6aJ4UqTkqk+h
	 bZT27/9dLz4+Yxj2NAT1ZMar4DZSRaIJhr9ZWslKdy1fxZc/1FP+a7S0GuQiQMRNt9
	 ixt90ucpFvsDWIHh57o2PaB2ea+8+/ujQnPWZZAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/262] phy: rockchip: naneng-combphy: Enable U3 OTG port for RK3568
Date: Mon, 13 Oct 2025 16:43:57 +0200
Message-ID: <20251013144329.549801455@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 7bb14b61b7d03db770b7e8871493f5b9b2be2b79 ]

The boot firmware may disable the U3 port early during boot and leave it
up to the controller or PHY driver to re-enable U3 when needed.

The Rockchip USBDP PHY driver currently does this for RK3576 and RK3588,
something the Rockchip Naneng Combo PHY driver never does for RK3568.
This may result in USB 3.0 ports being limited to only using USB 2.0 or
in special cases not working at all on RK3568.

Write to PIPE_GRF USB3OTGx_CON1 reg to ensure the U3 port is enabled
when a PHY with PHY_TYPE_USB3 mode is used.

Fixes: 7160820d742a ("phy: rockchip: add naneng combo phy for RK3568")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20250723072324.2246498-1-jonas@kwiboo.se
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
index 1ef6d9630f7e0..fbaeb7ca600d1 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -122,6 +122,8 @@ struct rockchip_combphy_grfcfg {
 	struct combphy_reg pipe_xpcs_phy_ready;
 	struct combphy_reg pipe_pcie1l0_sel;
 	struct combphy_reg pipe_pcie1l1_sel;
+	struct combphy_reg u3otg0_port_en;
+	struct combphy_reg u3otg1_port_en;
 };
 
 struct rockchip_combphy_cfg {
@@ -431,6 +433,14 @@ static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txcomp_sel, false);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txelec_sel, false);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->usb_mode_set, true);
+		switch (priv->id) {
+		case 0:
+			rockchip_combphy_param_write(priv->pipe_grf, &cfg->u3otg0_port_en, true);
+			break;
+		case 1:
+			rockchip_combphy_param_write(priv->pipe_grf, &cfg->u3otg1_port_en, true);
+			break;
+		}
 		break;
 
 	case PHY_TYPE_SATA:
@@ -574,6 +584,8 @@ static const struct rockchip_combphy_grfcfg rk3568_combphy_grfcfgs = {
 	/* pipe-grf */
 	.pipe_con0_for_sata	= { 0x0000, 15, 0, 0x00, 0x2220 },
 	.pipe_xpcs_phy_ready	= { 0x0040, 2, 2, 0x00, 0x01 },
+	.u3otg0_port_en		= { 0x0104, 15, 0, 0x0181, 0x1100 },
+	.u3otg1_port_en		= { 0x0144, 15, 0, 0x0181, 0x1100 },
 };
 
 static const struct rockchip_combphy_cfg rk3568_combphy_cfgs = {
-- 
2.51.0



