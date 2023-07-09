Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E4E522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A476C433C8;
	Sun,  9 Jul 2023 11:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901529;
	bh=IMNqR2sxpgk5lClFQAeM9Ea7rCZQJgP6iajBnbj+aSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/H51KLMC0K/8zgt1kkur4+tWTNjUoC88Gm0lHs2jGek9a+0JCoiuhcStNd7BzyXH
	 04f17gMAAHnToWtEOMjtuVwF/SPIIRQMg4L8vzuzypIVx83IZZTbEGWtx6ZxYx7uwZ
	 Lg+XDtiMeuD8RDUTiJHH9vNTKcCCxHLNPZDBf+qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matti=20Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Weiss <luca@z3ntu.xyz>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 052/431] thermal/drivers/qcom/tsens-v0_1: Add support for MSM8226
Date: Sun,  9 Jul 2023 13:10:00 +0200
Message-ID: <20230709111452.333541515@linuxfoundation.org>
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

From: Matti Lehtimäki <matti.lehtimaki@gmail.com>

[ Upstream commit 598e1afca47fdbb302ce8d288b06bcc8728efc6c ]

The MSM8226 TSENS IP has 6 thermal sensors in a TSENS v0.1 block.
The thermal sensors use non-standard slope values.

Signed-off-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Luca Weiss <luca@z3ntu.xyz>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230507201225.89694-4-matti.lehtimaki@gmail.com
Stable-dep-of: 6812d1dfbca9 ("thermal/drivers/qcom/tsens-v0_1: Fix mdm9607 slope values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-v0_1.c | 27 ++++++++++++++++++++++++++-
 drivers/thermal/qcom/tsens.c      |  3 +++
 drivers/thermal/qcom/tsens.h      |  2 +-
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/qcom/tsens-v0_1.c b/drivers/thermal/qcom/tsens-v0_1.c
index e89c6f39a3aea..ad57ab94546b0 100644
--- a/drivers/thermal/qcom/tsens-v0_1.c
+++ b/drivers/thermal/qcom/tsens-v0_1.c
@@ -243,6 +243,18 @@ static int calibrate_8974(struct tsens_priv *priv)
 	return 0;
 }
 
+static int __init init_8226(struct tsens_priv *priv)
+{
+	priv->sensor[0].slope = 2901;
+	priv->sensor[1].slope = 2846;
+	priv->sensor[2].slope = 3038;
+	priv->sensor[3].slope = 2955;
+	priv->sensor[4].slope = 2901;
+	priv->sensor[5].slope = 2846;
+
+	return init_common(priv);
+}
+
 static int __init init_8939(struct tsens_priv *priv) {
 	priv->sensor[0].slope = 2911;
 	priv->sensor[1].slope = 2789;
@@ -258,7 +270,7 @@ static int __init init_8939(struct tsens_priv *priv) {
 	return init_common(priv);
 }
 
-/* v0.1: 8916, 8939, 8974, 9607 */
+/* v0.1: 8226, 8916, 8939, 8974, 9607 */
 
 static struct tsens_features tsens_v0_1_feat = {
 	.ver_major	= VER_0_1,
@@ -313,6 +325,19 @@ static const struct tsens_ops ops_v0_1 = {
 	.get_temp	= get_temp_common,
 };
 
+static const struct tsens_ops ops_8226 = {
+	.init		= init_8226,
+	.calibrate	= tsens_calibrate_common,
+	.get_temp	= get_temp_common,
+};
+
+struct tsens_plat_data data_8226 = {
+	.num_sensors	= 6,
+	.ops		= &ops_8226,
+	.feat		= &tsens_v0_1_feat,
+	.fields	= tsens_v0_1_regfields,
+};
+
 static const struct tsens_ops ops_8916 = {
 	.init		= init_common,
 	.calibrate	= calibrate_8916,
diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index 8020ead2794e9..eb33a8bf0488d 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -1095,6 +1095,9 @@ static const struct of_device_id tsens_table[] = {
 	}, {
 		.compatible = "qcom,mdm9607-tsens",
 		.data = &data_9607,
+	}, {
+		.compatible = "qcom,msm8226-tsens",
+		.data = &data_8226,
 	}, {
 		.compatible = "qcom,msm8916-tsens",
 		.data = &data_8916,
diff --git a/drivers/thermal/qcom/tsens.h b/drivers/thermal/qcom/tsens.h
index dba9cd38f637c..433eba370998c 100644
--- a/drivers/thermal/qcom/tsens.h
+++ b/drivers/thermal/qcom/tsens.h
@@ -635,7 +635,7 @@ int get_temp_common(const struct tsens_sensor *s, int *temp);
 extern struct tsens_plat_data data_8960;
 
 /* TSENS v0.1 targets */
-extern struct tsens_plat_data data_8916, data_8939, data_8974, data_9607;
+extern struct tsens_plat_data data_8226, data_8916, data_8939, data_8974, data_9607;
 
 /* TSENS v1 targets */
 extern struct tsens_plat_data data_tsens_v1, data_8976, data_8956;
-- 
2.39.2



