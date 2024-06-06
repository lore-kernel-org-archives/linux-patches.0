Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD52E196C9F;
	Thu,  6 Jun 2024 14:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682976; cv=none; b=X7GJpZFpOsjrUeSuIydTmpeGRCNMqEIPPGHzN4zyXRyFSarctGR1i//wrUszO/IFLgzm0RSl2l4eb3QNOGjDsUlfbhw296fL56JAMWkvdL9VYlECQYYvULRho5CnsGFlnrJbM8VyqRntmXATOxrAhqgkDErpgcdebFn0A9nOmZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682976; c=relaxed/simple;
	bh=WjJuIWFivty6dMKZBbSWxvRszunvXNelEaCN9XrgJRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVUKPnbBBPvNhKpsPcWGQb7iHTOudBJUyOQAc5BkGqZ4wkxQkD8cJ60BVeERQ5p4Nz0ZeDu5K4evxd5XEtWs296HS7BYZXpPCGqIZgQCv5Yd5/8o7RerQQCfZk0YjEw1tGK6WtNopPHwmJUboQHCHb5A/Zswc2iERTDrxim3JQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQeOZCJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQeOZCJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C03DC2BD10;
	Thu,  6 Jun 2024 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682976;
	bh=WjJuIWFivty6dMKZBbSWxvRszunvXNelEaCN9XrgJRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQeOZCJKahXxGTXSRjE5KQPZR9d9oT275iVWPyBf5Jk+mfDJ4msf1bonsDd8Q/U+m
	 WqYZMWTR5wCIhP1GfTOsQCLvqXfPBhZIHH+iY+JU3lGiqG3YdGNwwX2H/06hJ6Dmss
	 pnoxg8znk3vH0KEBsUqonguRDQU/jbNGRN+6hwF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 155/374] phy: qcom: qmp-combo: fix sm8650 voltage swing table
Date: Thu,  6 Jun 2024 16:02:14 +0200
Message-ID: <20240606131657.110685109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit f320268fcebcbab02631d2070fa19ad4856a5a5e ]

The QMP USB3/DP PHY found in the SM8650 SoC requires a slightly
different Voltage Swing table for HBR/RBR link speeds.

Add a new hbr/rbr voltage switch table named "v6" used in a new
sm8650 qmp_phy_cfg struct replacing the sm8550 fallback used for
the sm8650 compatible.

Fixes: 80c1afe8c5fe ("phy: qcom: qmp-combo: add QMP USB3/DP PHY tables for SM8650")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240226-topic-sm8650-upstream-combo-phy-swing-update-v1-1-08707ebca92a@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 54 ++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index c21cdb8dbfe74..acc2b5b9ea255 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1382,6 +1382,13 @@ static const u8 qmp_dp_v5_voltage_swing_hbr_rbr[4][4] = {
 	{ 0x3f, 0xff, 0xff, 0xff }
 };
 
+static const u8 qmp_dp_v6_voltage_swing_hbr_rbr[4][4] = {
+	{ 0x27, 0x2f, 0x36, 0x3f },
+	{ 0x31, 0x3e, 0x3f, 0xff },
+	{ 0x36, 0x3f, 0xff, 0xff },
+	{ 0x3f, 0xff, 0xff, 0xff }
+};
+
 static const u8 qmp_dp_v6_pre_emphasis_hbr_rbr[4][4] = {
 	{ 0x20, 0x2d, 0x34, 0x3a },
 	{ 0x20, 0x2e, 0x35, 0xff },
@@ -2001,6 +2008,51 @@ static const struct qmp_phy_cfg sm8550_usb3dpphy_cfg = {
 	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
 };
 
+static const struct qmp_phy_cfg sm8650_usb3dpphy_cfg = {
+	.offsets		= &qmp_combo_offsets_v3,
+
+	.serdes_tbl		= sm8550_usb3_serdes_tbl,
+	.serdes_tbl_num		= ARRAY_SIZE(sm8550_usb3_serdes_tbl),
+	.tx_tbl			= sm8550_usb3_tx_tbl,
+	.tx_tbl_num		= ARRAY_SIZE(sm8550_usb3_tx_tbl),
+	.rx_tbl			= sm8550_usb3_rx_tbl,
+	.rx_tbl_num		= ARRAY_SIZE(sm8550_usb3_rx_tbl),
+	.pcs_tbl		= sm8550_usb3_pcs_tbl,
+	.pcs_tbl_num		= ARRAY_SIZE(sm8550_usb3_pcs_tbl),
+	.pcs_usb_tbl		= sm8550_usb3_pcs_usb_tbl,
+	.pcs_usb_tbl_num	= ARRAY_SIZE(sm8550_usb3_pcs_usb_tbl),
+
+	.dp_serdes_tbl		= qmp_v6_dp_serdes_tbl,
+	.dp_serdes_tbl_num	= ARRAY_SIZE(qmp_v6_dp_serdes_tbl),
+	.dp_tx_tbl		= qmp_v6_dp_tx_tbl,
+	.dp_tx_tbl_num		= ARRAY_SIZE(qmp_v6_dp_tx_tbl),
+
+	.serdes_tbl_rbr		= qmp_v6_dp_serdes_tbl_rbr,
+	.serdes_tbl_rbr_num	= ARRAY_SIZE(qmp_v6_dp_serdes_tbl_rbr),
+	.serdes_tbl_hbr		= qmp_v6_dp_serdes_tbl_hbr,
+	.serdes_tbl_hbr_num	= ARRAY_SIZE(qmp_v6_dp_serdes_tbl_hbr),
+	.serdes_tbl_hbr2	= qmp_v6_dp_serdes_tbl_hbr2,
+	.serdes_tbl_hbr2_num	= ARRAY_SIZE(qmp_v6_dp_serdes_tbl_hbr2),
+	.serdes_tbl_hbr3	= qmp_v6_dp_serdes_tbl_hbr3,
+	.serdes_tbl_hbr3_num	= ARRAY_SIZE(qmp_v6_dp_serdes_tbl_hbr3),
+
+	.swing_hbr_rbr		= &qmp_dp_v6_voltage_swing_hbr_rbr,
+	.pre_emphasis_hbr_rbr	= &qmp_dp_v6_pre_emphasis_hbr_rbr,
+	.swing_hbr3_hbr2	= &qmp_dp_v5_voltage_swing_hbr3_hbr2,
+	.pre_emphasis_hbr3_hbr2 = &qmp_dp_v5_pre_emphasis_hbr3_hbr2,
+
+	.dp_aux_init		= qmp_v4_dp_aux_init,
+	.configure_dp_tx	= qmp_v4_configure_dp_tx,
+	.configure_dp_phy	= qmp_v4_configure_dp_phy,
+	.calibrate_dp_phy	= qmp_v4_calibrate_dp_phy,
+
+	.regs			= qmp_v6_usb3phy_regs_layout,
+	.reset_list		= msm8996_usb3phy_reset_l,
+	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
+	.vreg_list		= qmp_phy_vreg_l,
+	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
+};
+
 static int qmp_combo_dp_serdes_init(struct qmp_combo *qmp)
 {
 	const struct qmp_phy_cfg *cfg = qmp->cfg;
@@ -3631,7 +3683,7 @@ static const struct of_device_id qmp_combo_of_match_table[] = {
 	},
 	{
 		.compatible = "qcom,sm8650-qmp-usb3-dp-phy",
-		.data = &sm8550_usb3dpphy_cfg,
+		.data = &sm8650_usb3dpphy_cfg,
 	},
 	{
 		.compatible = "qcom,x1e80100-qmp-usb3-dp-phy",
-- 
2.43.0



