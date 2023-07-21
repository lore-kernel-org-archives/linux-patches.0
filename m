Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D352B200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE78C433C7;
	Fri, 21 Jul 2023 19:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966227;
	bh=NYdWw53lMHUjfKlbSJcZXzMiEmpLx5N3wHPO5gQA25s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVlmcuk1AVDp2VcaRcu62e2ox0oFIRoyG1dCn7bOnqyOe1gCVCCI3xPjqZurrCIsq
	 jr7t99io9rg6x3sdo0xn2hZdE5gmynQhvNu60FfUxLJX6v8Z5Lfxe7H+kTUhMAIruC
	 Qmu1Sd7R3v/8Zuyutap32zeHLQwRrh974BCr22Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/532] clk: qcom: camcc-sc7180: Add parent dependency to all camera GDSCs
Date: Fri, 21 Jul 2023 18:02:54 +0200
Message-ID: <20230721160628.986311571@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 3e4d179532423f299554cd0dedabdd9d2fdd238d ]

Camera titan top GDSC is a parent supply to all other camera GDSCs. Titan
top GDSC is required to be enabled before enabling any other camera GDSCs
and it should be disabled only after all other camera GDSCs are disabled.
Ensure this behavior by marking titan top GDSC as parent of all other
camera GDSCs.

Fixes: 15d09e830bbc ("clk: qcom: camcc: Add camera clock controller driver for SC7180")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230501142932.13049-1-quic_tdas@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sc7180.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/qcom/camcc-sc7180.c b/drivers/clk/qcom/camcc-sc7180.c
index ce73ee9037cb0..4b3e3902b7eed 100644
--- a/drivers/clk/qcom/camcc-sc7180.c
+++ b/drivers/clk/qcom/camcc-sc7180.c
@@ -1493,12 +1493,21 @@ static struct clk_branch cam_cc_sys_tmr_clk = {
 	},
 };
 
+static struct gdsc titan_top_gdsc = {
+	.gdscr = 0xb134,
+	.pd = {
+		.name = "titan_top_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+};
+
 static struct gdsc bps_gdsc = {
 	.gdscr = 0x6004,
 	.pd = {
 		.name = "bps_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 	.flags = HW_CTRL,
 };
 
@@ -1508,6 +1517,7 @@ static struct gdsc ife_0_gdsc = {
 		.name = "ife_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 };
 
 static struct gdsc ife_1_gdsc = {
@@ -1516,6 +1526,7 @@ static struct gdsc ife_1_gdsc = {
 		.name = "ife_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 };
 
 static struct gdsc ipe_0_gdsc = {
@@ -1525,15 +1536,9 @@ static struct gdsc ipe_0_gdsc = {
 	},
 	.pwrsts = PWRSTS_OFF_ON,
 	.flags = HW_CTRL,
+	.parent = &titan_top_gdsc.pd,
 };
 
-static struct gdsc titan_top_gdsc = {
-	.gdscr = 0xb134,
-	.pd = {
-		.name = "titan_top_gdsc",
-	},
-	.pwrsts = PWRSTS_OFF_ON,
-};
 
 static struct clk_hw *cam_cc_sc7180_hws[] = {
 	[CAM_CC_PLL2_OUT_EARLY] = &cam_cc_pll2_out_early.hw,
-- 
2.39.2



