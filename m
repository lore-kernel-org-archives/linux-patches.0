Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCCA15D1
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAEBC433EF;
	Tue, 10 Jan 2023 18:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375402;
	bh=RDlG89BbPXv1Aj8W02aAUx2HNRoExrRTQB546UcaMq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4FAtKcvoeVkuykNYBz+mbrZ/hzRzCZ9v+Dgl2ANKHU5QC9dJMzR3CACW0vQPolp5
	 QY7+Yd8IouuZz2ZeHTDiQYoEHlmVc687gTinkF0Mxsp3iC7UeAbueTqeWPZac/BEb1
	 UqCTh5PcCbGRxs005agGYKl6fyZ7zX4q+PWSQA4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/290] phy: qcom-qmp-combo: fix out-of-bounds clock access
Date: Tue, 10 Jan 2023 19:04:30 +0100
Message-Id: <20230110180038.054170887@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit d8a5b59c5fc75c99ba17e3eb1a8f580d8d172b28 ]

The SM8250 only uses three clocks but the DP configuration erroneously
described four clocks.

In case the DP part of the PHY is initialised before the USB part, this
would lead to uninitialised memory beyond the bulk-clocks array to be
treated as a clock pointer as the clocks are requested based on the USB
configuration.

Fixes: aff188feb5e1 ("phy: qcom-qmp: add support for sm8250-usb3-dp phy")
Cc: stable@vger.kernel.org	# 5.13
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 817298d8b0e3..a9687e040960 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -3805,8 +3805,8 @@ static const struct qmp_phy_cfg sm8250_dpphy_cfg = {
 	.serdes_tbl_hbr3	= qmp_v4_dp_serdes_tbl_hbr3,
 	.serdes_tbl_hbr3_num	= ARRAY_SIZE(qmp_v4_dp_serdes_tbl_hbr3),
 
-	.clk_list		= qmp_v4_phy_clk_l,
-	.num_clks		= ARRAY_SIZE(qmp_v4_phy_clk_l),
+	.clk_list		= qmp_v4_sm8250_usbphy_clk_l,
+	.num_clks		= ARRAY_SIZE(qmp_v4_sm8250_usbphy_clk_l),
 	.reset_list		= msm8996_usb3phy_reset_l,
 	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,
-- 
2.35.1



