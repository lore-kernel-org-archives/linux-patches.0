Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C47D309DC5;
	Mon, 13 Oct 2025 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367676; cv=none; b=cf8Arn7Bm1Yz8kAFZzddc/lpdyN7JqMXeR9PIGyCcjVYNx00NhUJcShR18pQRP+aDzGaMNwWAyPvJqUKz28yPl5/ufmDPelBs1lgsCIIDRi8yqsSQYN6ZQvW9ZgV5UaClfIbe+0hvXE/HZ04XYitkceJF7+GXzQFHwS4blSSM0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367676; c=relaxed/simple;
	bh=lWb2FjKa85bTtAukHDdxFZ9DAXe7x5Mbi/YkRi57XEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7QCswPYbonNcIC/FJ7euaHkAOb4SulyfaHBf+VDdNMVB9XuuvmLuL3+lIiTBUL0jlEZcqBXeaUup+j2xbecN7tItZPNHtryS9ZxMppm/FSZORj07Yy3nuuCz4pG7ydJ/38U9UMajmILb8CSL6okSHSahNz8dCVij9cPCYDpkg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpp9PE82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpp9PE82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3511C4CEE7;
	Mon, 13 Oct 2025 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367676;
	bh=lWb2FjKa85bTtAukHDdxFZ9DAXe7x5Mbi/YkRi57XEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpp9PE82dTdsgHFaZx1zLyEj+3z0U8jzzYC5ooNLqPuXrY7Wj+kJt7GSYmkSWigCi
	 Ky57a+f6JKgJcQN+C9Qs+0JIY7i/HdCrBFd3939ApvDhZvh5e/w+FZ4SVlnkuUqiLU
	 x0XZyc3/ZYOmT5GOz8oBzHrYGQk6DZdwp/8gL4KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/196] phy: rockchip: naneng-combphy: Enable U3 OTG port for RK3568
Date: Mon, 13 Oct 2025 16:44:18 +0200
Message-ID: <20251013144317.618665430@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index 2354ce8b21594..9ef496092b7e6 100644
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



