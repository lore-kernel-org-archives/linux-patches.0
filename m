Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C673168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4C5C433EF;
	Mon,  8 May 2023 11:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545158;
	bh=OMi3JKjiYgIZcB8ovFT55piey/WFeBmlM3Zl5+fTHCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPhL3hM9td6MWLutO5ktFocNI2IxKhjf06XHe03/ldBgljZDdBwWQDyf6k490m9OO
	 zj+McqIPgimkRVRvfisUjm93pE3n1iP+EQ9XR22iPmPrjut9qS04ML8miCUIi7/SFR
	 DgDVL0qgmpifrnTc6ptn3P3swMUbvTsJ5RshTcmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
	Mohammad Rafi Shaik <quic_mohs@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 613/694] clk: qcom: lpasscc-sc7280: Skip qdsp6ss clock registration
Date: Mon,  8 May 2023 11:47:28 +0200
Message-Id: <20230508094455.319043103@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit 4fc1c2d9a2b7a394f3b873aae5e03bffd8b5cd31 ]

The qdsp6ss memory region is being shared by ADSP remoteproc device and
lpasscc clock device, hence causing memory conflict.
To avoid this, when qdsp6ss clocks are being enabled in remoteproc driver,
skip qdsp6ss clock registration if "qcom,adsp-pil-mode" is enabled and
also assign max_register value.

Fixes: 4ab43d171181 ("clk: qcom: Add lpass clock controller driver for SC7280")
Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Signed-off-by: Mohammad Rafi Shaik <quic_mohs@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230407092255.119690-3-quic_mohs@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/lpasscc-sc7280.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/lpasscc-sc7280.c b/drivers/clk/qcom/lpasscc-sc7280.c
index 48432010ce247..0df2b29e95e31 100644
--- a/drivers/clk/qcom/lpasscc-sc7280.c
+++ b/drivers/clk/qcom/lpasscc-sc7280.c
@@ -121,14 +121,18 @@ static int lpass_cc_sc7280_probe(struct platform_device *pdev)
 		goto destroy_pm_clk;
 	}
 
-	lpass_regmap_config.name = "qdsp6ss";
-	desc = &lpass_qdsp6ss_sc7280_desc;
-
-	ret = qcom_cc_probe_by_index(pdev, 0, desc);
-	if (ret)
-		goto destroy_pm_clk;
+	if (!of_property_read_bool(pdev->dev.of_node, "qcom,adsp-pil-mode")) {
+		lpass_regmap_config.name = "qdsp6ss";
+		lpass_regmap_config.max_register = 0x3f;
+		desc = &lpass_qdsp6ss_sc7280_desc;
+
+		ret = qcom_cc_probe_by_index(pdev, 0, desc);
+		if (ret)
+			goto destroy_pm_clk;
+	}
 
 	lpass_regmap_config.name = "top_cc";
+	lpass_regmap_config.max_register = 0x4;
 	desc = &lpass_cc_top_sc7280_desc;
 
 	ret = qcom_cc_probe_by_index(pdev, 1, desc);
-- 
2.39.2



