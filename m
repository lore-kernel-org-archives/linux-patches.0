Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26A14973B9;
	Thu, 17 Sep 2026 16:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660954; cv=none; b=JMvp1XqLYDNN54ioe9Kn+r1PjCz3sWLDIPILB5wLIx4ldMk311XoTNp2sd5KwJk2ertr1+zAPgxGybCHYK5PTAYzohYoU7vM/Rd/+OqwSpmLNQMBMAqiMig98iOEpnRVdnaGJCDzHtt8RMpwXdKb/+z/E5a5L6B3vSqOlPtzlS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660954; c=relaxed/simple;
	bh=oj27YOUneyS1l3wmMQx5co2EZl8kfmOVMNCdHGcVirs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQPv/F+fNlXaC1OWNES5wiGKcKbkjoH/rFsSl0whCcXwPOy1Nd8mJz7ViRTsi6BSxch+warlzAr8+EcYbRjxB+2hZvk/F8wZ85/VLCNrGJRPfbuNZggE5SfN7uP7bhHEFJbG3YvcuDuiDTNsVzTo+cBxUnMdXNyWngdICgWVIEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+hW9vVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+hW9vVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE381F000FF;
	Thu, 17 Sep 2026 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660953;
	bh=tbR3HzPS57sTWORDiqC8KCcPff8npjg640NM/JGzsmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+hW9vVIXoYrZJrEmNe7dZeGfMcsslXe/SprGKDYELra/soQ0qJiKp33vUtiMA2n0
	 Q23c/8fazJ/NZz1uba3UgNsKNDmMI9RyzfMxt/JpK+ETLS8XEKN8jabO4isYzLBcsb
	 sYRoCrQINFp+KiKn1Nh1CvjKGiA83Q63+s9+Avzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0008/1250] drm: renesas: rzg2l_mipi_dsi: Fix deassert/assert of CMN_RSTB signal
Date: Thu, 17 Sep 2026 15:56:43 +0100
Message-ID: <20260917151552.145559326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 8065890f5cda3f8a503f3b9d326aab0e9cca39e7 ]

The RZ/G2L hardware manual (Rev. 1.50, May 2025), Section 34.4.2.1,
requires deasserting the CMN_RSTB signal after setting the Link registers.
Move the reset_control_deassert() call from rzg2l_mipi_dsi_dphy_init() to
rzg2l_mipi_dsi_startup(), placing it after the Link register writes. This
reset signal is optional for RZ/V2H SoCs, so add a NULL check. Drop the
unused ret variable from rzg2l_mipi_dsi_dphy_init().

The CMN_RSTB signal is not required for reading PHY registers in the
probe. Move reset_control_assert() from rzg2l_mipi_dsi_dphy_exit() to
rzg2l_mipi_dsi_stop(), placing it before the dphy_exit() call. Since this
reset signal is optional for RZ/V2H, the call is a no-op on that SoC.

Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260330104450.128512-4-biju.das.jz@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
index 04a24ff9dde15..1c6f29c285b65 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
@@ -228,7 +228,6 @@ static int rzg2l_mipi_dsi_dphy_init(struct rzg2l_mipi_dsi *dsi,
 	u32 dphytim1;
 	u32 dphytim2;
 	u32 dphytim3;
-	int ret;
 
 	/* All DSI global operation timings are set with recommended setting */
 	for (i = 0; i < ARRAY_SIZE(rzg2l_mipi_dsi_global_timings); ++i) {
@@ -268,12 +267,6 @@ static int rzg2l_mipi_dsi_dphy_init(struct rzg2l_mipi_dsi *dsi,
 	rzg2l_mipi_dsi_phy_write(dsi, DSIDPHYTIM2, dphytim2);
 	rzg2l_mipi_dsi_phy_write(dsi, DSIDPHYTIM3, dphytim3);
 
-	ret = reset_control_deassert(dsi->rstc);
-	if (ret < 0)
-		return ret;
-
-	fsleep(1000);
-
 	return 0;
 }
 
@@ -285,8 +278,6 @@ static void rzg2l_mipi_dsi_dphy_exit(struct rzg2l_mipi_dsi *dsi)
 
 	dphyctrl0 &= ~(DSIDPHYCTRL0_EN_LDO1200 | DSIDPHYCTRL0_EN_BGR);
 	rzg2l_mipi_dsi_phy_write(dsi, DSIDPHYCTRL0, dphyctrl0);
-
-	reset_control_assert(dsi->rstc);
 }
 
 static int rzg2l_dphy_conf_clks(struct rzg2l_mipi_dsi *dsi, unsigned long mode_freq,
@@ -393,6 +384,14 @@ static int rzg2l_mipi_dsi_startup(struct rzg2l_mipi_dsi *dsi,
 	dsisetr |= FIELD_PREP(DSISETR_MRPSZ, RZG2L_DCS_BUF_SIZE);
 	rzg2l_mipi_dsi_link_write(dsi, DSISETR, dsisetr);
 
+	if (dsi->rstc) {
+		ret = reset_control_deassert(dsi->rstc);
+		if (ret < 0)
+			goto err_phy;
+
+		fsleep(1000);
+	}
+
 	return 0;
 
 err_phy:
@@ -404,6 +403,7 @@ static int rzg2l_mipi_dsi_startup(struct rzg2l_mipi_dsi *dsi,
 
 static void rzg2l_mipi_dsi_stop(struct rzg2l_mipi_dsi *dsi)
 {
+	reset_control_assert(dsi->rstc);
 	dsi->info->dphy_exit(dsi);
 	pm_runtime_put(dsi->dev);
 }
-- 
2.53.0



