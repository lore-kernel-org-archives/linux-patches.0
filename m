Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ABA1DB34C;
	Tue, 27 May 2025 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364772; cv=none; b=UVLLNpqKcERhPQPw8DEtRsRYjPTb/FTYf9QRrMS512jSZ9DwUsYhRux3B1Ob7jTNBBKma0UpOCAej923C7FfUpuWwVBp4vvMVFUHG+cPweNT5xoA3puGoBW1cJLhFi7yaiER/BIvcEJ1ZueSR4SSmZfxnrrsmeAzjZEHyrjUYyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364772; c=relaxed/simple;
	bh=Gw1jFb2emWyg0ElTOuo6UvJINXQmovy8SfYTA00CgEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX1uTmx+srQyiFkTdQbVxdN+cVbldMthfKbt7gao8E1hfsmO7yzPq+1VONv9dILUEbdr+xARx0utACU0vDtPUo5i4Jmj/2zb0CGMJbkkwFHyCroKIH8tz5k3RLv4Slug7bi/f5Y4jNwRi5Tm8BKKPT6/7PdiwRnEEIYRj+/9wXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmcnDCs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmcnDCs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974E7C4CEE9;
	Tue, 27 May 2025 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364772;
	bh=Gw1jFb2emWyg0ElTOuo6UvJINXQmovy8SfYTA00CgEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmcnDCs8EhWnHEmPa34U2lxPGgsQosSOffBgze3bvbFRd6HI+eTV4AfGkn7T2LwXb
	 fZDpg1CYnCP1AnwJJToJXN4m6OqQkxOO4byG9sN1DYpWGSTI6dwU6g9fiK313hT0uG
	 /i38EVBpsYHjFFk1bYyk4l5zqw7+VZoPAfhylUVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/626] clk: qcom: lpassaudiocc-sc7280: Add support for LPASS resets for QCM6490
Date: Tue, 27 May 2025 18:20:55 +0200
Message-ID: <20250527162451.607227643@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit cdbbc480f4146cb659af97f4020601fde5fb65a7 ]

On the QCM6490 boards, the LPASS firmware controls the complete clock
controller functionalities and associated power domains. However, only
the LPASS resets required to be controlled by the high level OS. Thus,
add support for the resets in the clock driver to enable the Audio SW
driver to assert/deassert the audio resets as needed.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20250221-lpass_qcm6490_resets-v5-2-6be0c0949a83@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/lpassaudiocc-sc7280.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/lpassaudiocc-sc7280.c b/drivers/clk/qcom/lpassaudiocc-sc7280.c
index 45e7264770866..22169da08a51a 100644
--- a/drivers/clk/qcom/lpassaudiocc-sc7280.c
+++ b/drivers/clk/qcom/lpassaudiocc-sc7280.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2025, Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -713,14 +714,24 @@ static const struct qcom_reset_map lpass_audio_cc_sc7280_resets[] = {
 	[LPASS_AUDIO_SWR_WSA_CGCR] = { 0xb0, 1 },
 };
 
+static const struct regmap_config lpass_audio_cc_sc7280_reset_regmap_config = {
+	.name = "lpassaudio_cc_reset",
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.fast_io = true,
+	.max_register = 0xc8,
+};
+
 static const struct qcom_cc_desc lpass_audio_cc_reset_sc7280_desc = {
-	.config = &lpass_audio_cc_sc7280_regmap_config,
+	.config = &lpass_audio_cc_sc7280_reset_regmap_config,
 	.resets = lpass_audio_cc_sc7280_resets,
 	.num_resets = ARRAY_SIZE(lpass_audio_cc_sc7280_resets),
 };
 
 static const struct of_device_id lpass_audio_cc_sc7280_match_table[] = {
-	{ .compatible = "qcom,sc7280-lpassaudiocc" },
+	{ .compatible = "qcom,qcm6490-lpassaudiocc", .data = &lpass_audio_cc_reset_sc7280_desc },
+	{ .compatible = "qcom,sc7280-lpassaudiocc", .data = &lpass_audio_cc_sc7280_desc },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, lpass_audio_cc_sc7280_match_table);
@@ -752,13 +763,17 @@ static int lpass_audio_cc_sc7280_probe(struct platform_device *pdev)
 	struct regmap *regmap;
 	int ret;
 
+	desc = device_get_match_data(&pdev->dev);
+
+	if (of_device_is_compatible(pdev->dev.of_node, "qcom,qcm6490-lpassaudiocc"))
+		return qcom_cc_probe_by_index(pdev, 1, desc);
+
 	ret = lpass_audio_setup_runtime_pm(pdev);
 	if (ret)
 		return ret;
 
 	lpass_audio_cc_sc7280_regmap_config.name = "lpassaudio_cc";
 	lpass_audio_cc_sc7280_regmap_config.max_register = 0x2f000;
-	desc = &lpass_audio_cc_sc7280_desc;
 
 	regmap = qcom_cc_map(pdev, desc);
 	if (IS_ERR(regmap)) {
@@ -772,7 +787,7 @@ static int lpass_audio_cc_sc7280_probe(struct platform_device *pdev)
 	regmap_write(regmap, 0x4, 0x3b);
 	regmap_write(regmap, 0x8, 0xff05);
 
-	ret = qcom_cc_really_probe(&pdev->dev, &lpass_audio_cc_sc7280_desc, regmap);
+	ret = qcom_cc_really_probe(&pdev->dev, desc, regmap);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register LPASS AUDIO CC clocks\n");
 		goto exit;
-- 
2.39.5



