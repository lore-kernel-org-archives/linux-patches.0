Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77A9522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D37C433C7;
	Sun,  9 Jul 2023 11:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901532;
	bh=H3UaHPdNJLh8FwYGDCbau5lFyoS1bRGp40pmJMWDXtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypCPbYMbYWNrzjXoLBr9De+Hjsizo+BLiaCB6wA+TWbU1wptHwsJD6tSNuK1Gz3eA
	 gwRJIZGjSQC9RVOEdw0b7uHSiKz1Uj7RQ9zqZgm+1aIbDLzAupCf/cYahiUW0PTpC9
	 EzZMhIWoWKUTXu1yfr6ne2dudiKnwoP2rG+gBB4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 053/431] thermal/drivers/qcom/tsens-v0_1: Fix mdm9607 slope values
Date: Sun,  9 Jul 2023 13:10:01 +0200
Message-ID: <20230709111452.359002493@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit 6812d1dfbca99cd5032683354bf50e0002b2aa02 ]

According to the msm-3.18 vendor kernel from Qualcomm [1], mdm9607 uses
a non-standard slope value of 3000 (instead of 3200) for all sensors.
Fill it properly similar to the 8939 code added recently.

[1]: https://git.codelinaro.org/clo/la/kernel/msm-3.18/-/blob/LE.UM.4.3.2.r1-04200-9x07/arch/arm/boot/dts/qcom/mdm9607.dtsi#L875

Fixes: a2149ab815fc ("thermal/drivers/qcom/tsens-v0_1: Add support for MDM9607")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230508-msm8909-tsens-v5-2-5eb632235ba7@kernkonzept.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-v0_1.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/tsens-v0_1.c b/drivers/thermal/qcom/tsens-v0_1.c
index ad57ab94546b0..e89a0da4b4e14 100644
--- a/drivers/thermal/qcom/tsens-v0_1.c
+++ b/drivers/thermal/qcom/tsens-v0_1.c
@@ -270,6 +270,16 @@ static int __init init_8939(struct tsens_priv *priv) {
 	return init_common(priv);
 }
 
+static int __init init_9607(struct tsens_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_sensors; ++i)
+		priv->sensor[i].slope = 3000;
+
+	return init_common(priv);
+}
+
 /* v0.1: 8226, 8916, 8939, 8974, 9607 */
 
 static struct tsens_features tsens_v0_1_feat = {
@@ -381,9 +391,15 @@ struct tsens_plat_data data_8974 = {
 	.fields	= tsens_v0_1_regfields,
 };
 
+static const struct tsens_ops ops_9607 = {
+	.init		= init_9607,
+	.calibrate	= tsens_calibrate_common,
+	.get_temp	= get_temp_common,
+};
+
 struct tsens_plat_data data_9607 = {
 	.num_sensors	= 5,
-	.ops		= &ops_v0_1,
+	.ops		= &ops_9607,
 	.feat		= &tsens_v0_1_feat,
 	.fields	= tsens_v0_1_regfields,
 };
-- 
2.39.2



