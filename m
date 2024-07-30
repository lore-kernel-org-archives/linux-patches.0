Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724D61E86F;
	Tue, 30 Jul 2024 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358977; cv=none; b=TeSgjo1vTf/f7ORtawBfAEJIQQ8v0Y4H24Q39kKBjpo36gd3QVHY+X/ClkpWI8dKH6SiTXgnu/BFenmO50s3dxo4Gcs2Dr3cUxLTeVOQl0W+PBlQEjxGkzRMAuSYSILI2p+BQyB4nm8+iq0IFgznypfdg+kujTuJFNhR5p4p5ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358977; c=relaxed/simple;
	bh=1ZOO+jophsezJZyb+BD7WFEA97vHwaSHeu6Dmd++kXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prm82j/YYFFQ2TeZ91XWlix0IY9mbuoT32xM2Bfq1w5bxHGJv8k8JZh7TCQHxJ9bulfC8YD/UF+kKfplbt0Pf1w7mANzoQ/oPIHWk2RGhcBSf6lrQ553aDxmKJ7Bb+yfIesFOZRrKGAU74n907RaS4ZdNpJLuIfuR4/GNCpjf0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+bRwE8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+bRwE8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45E3C4AF0A;
	Tue, 30 Jul 2024 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358977;
	bh=1ZOO+jophsezJZyb+BD7WFEA97vHwaSHeu6Dmd++kXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+bRwE8PoJS3JBBRuXS+zVSTh1CQw04QttGsTluhsc8IuiGEEuLyuRv4GlqBjmqDa
	 Z1bcFR8wNR9InMaWA7m5zqbCFYc/KfKak4C+CcVaGVaEKGORyvy74MArTgnWuesbcr
	 qJjmVR6eevYWd+GbBuvKRd7gllMFH12jwtzKm4dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 413/809] clk: qcom: gcc-sa8775p: Update the GDSC wait_val fields and flags
Date: Tue, 30 Jul 2024 17:44:49 +0200
Message-ID: <20240730151741.004653647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit be208c0ccf7d861fc6109ca06c1a773512739af9 ]

Update the GDSC wait_val fields as per the default hardware values as
otherwise they would lead to GDSC FSM state to be stuck and causing
failures to power on/off. Also add the GDSC flags as applicable and
add support to control PCIE GDSC's using collapse vote registers.

Fixes: 08c51ceb12f7 ("clk: qcom: add the GCC driver for sa8775p")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20240612-sa8775p-v2-gcc-gpucc-fixes-v2-2-adcc756a23df@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sa8775p.c | 40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sa8775p.c b/drivers/clk/qcom/gcc-sa8775p.c
index 5bcbfbf52cb9e..9bbc0836fae98 100644
--- a/drivers/clk/qcom/gcc-sa8775p.c
+++ b/drivers/clk/qcom/gcc-sa8775p.c
@@ -4305,74 +4305,114 @@ static struct clk_branch gcc_video_axi1_clk = {
 
 static struct gdsc pcie_0_gdsc = {
 	.gdscr = 0xa9004,
+	.collapse_ctrl = 0x4b104,
+	.collapse_mask = BIT(0),
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc pcie_1_gdsc = {
 	.gdscr = 0x77004,
+	.collapse_ctrl = 0x4b104,
+	.collapse_mask = BIT(1),
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc ufs_card_gdsc = {
 	.gdscr = 0x81004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ufs_card_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc ufs_phy_gdsc = {
 	.gdscr = 0x83004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ufs_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc usb20_prim_gdsc = {
 	.gdscr = 0x1c004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "usb20_prim_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc usb30_prim_gdsc = {
 	.gdscr = 0x1b004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc usb30_sec_gdsc = {
 	.gdscr = 0x2f004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "usb30_sec_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc emac0_gdsc = {
 	.gdscr = 0xb6004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "emac0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc emac1_gdsc = {
 	.gdscr = 0xb4004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "emac1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct clk_regmap *gcc_sa8775p_clocks[] = {
-- 
2.43.0



