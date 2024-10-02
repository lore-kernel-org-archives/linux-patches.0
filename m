Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524D71CFECF;
	Wed,  2 Oct 2024 14:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878693; cv=none; b=qXlta5Ke5CaoiNmDmX+ABan+CZTL7BE2thBRuh9+V7oSzt7mugfXpTCoLhZGUn9TWP1hBuzyL7qLlxXtfCE6nZNQ4qPidPy9KJXJwtdssfypSzKjbleefTHxz9Ec+70EcktppKA2CRNoP0sw6DQ9Xgnz0KJ4h3idZ1ZtDbewFaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878693; c=relaxed/simple;
	bh=d/Ds/9G2IDsa/TOSl+x5T3RDetVWdIKPMV8GN0ONMj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QP1gztnmyQWz0PntfY9cj41FSzSPPl951xsAVnxEEIngpgQQUzo65ncwHLVL7ZxHAL/ztWpldij6BorXHBO8TaxmpXLBXDjB+mBR6KodG+o+06jj9q1DrO/tZ1M+31xatOla35YIJF8EwYfklcKtvtTHEP43W3/Y3ASQBILriCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcUCKsWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcUCKsWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB56C4CEC2;
	Wed,  2 Oct 2024 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878693;
	bh=d/Ds/9G2IDsa/TOSl+x5T3RDetVWdIKPMV8GN0ONMj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcUCKsWcBRqYdf4jjn+LBHMHlDvIqdvSfxU7Q20jVTwWVRfpVIVjr4lZiv3xuMv+F
	 6AgDudaZ7UAY/Jnb89ebuFXfdSUiy6AK3MGLX8G+COehq0yyW8weAwux3G9jZOTEBq
	 U2D0Rl6Cp6dkTcHz8RcBE/qwnqrkoanP1VL2xp3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 473/634] Revert "soc: qcom: smd-rpm: Match rpmsg channel instead of compatible"
Date: Wed,  2 Oct 2024 14:59:33 +0200
Message-ID: <20241002125829.777922930@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit b17155133391d7f6dd18d3fb94a7d492fdec18fa upstream.

The rpm_requests device nodes have the compatible node. As such the
rpmsg core uses OF modalias instead of a native rpmsg modalias. Thus if
smd-rpm is built as a module, it doesn't get autoloaded for the device.

Revert the commit bcabe1e09135 ("soc: qcom: smd-rpm: Match rpmsg channel
instead of compatible")

Fixes: bcabe1e09135 ("soc: qcom: smd-rpm: Match rpmsg channel instead of compatible")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240729-fix-smd-rpm-v2-1-0776408a94c5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/smd-rpm.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/drivers/soc/qcom/smd-rpm.c
+++ b/drivers/soc/qcom/smd-rpm.c
@@ -196,9 +196,6 @@ static int qcom_smd_rpm_probe(struct rpm
 {
 	struct qcom_smd_rpm *rpm;
 
-	if (!rpdev->dev.of_node)
-		return -EINVAL;
-
 	rpm = devm_kzalloc(&rpdev->dev, sizeof(*rpm), GFP_KERNEL);
 	if (!rpm)
 		return -ENOMEM;
@@ -218,18 +215,38 @@ static void qcom_smd_rpm_remove(struct r
 	of_platform_depopulate(&rpdev->dev);
 }
 
-static const struct rpmsg_device_id qcom_smd_rpm_id_table[] = {
-	{ .name = "rpm_requests", },
-	{ /* sentinel */ }
+static const struct of_device_id qcom_smd_rpm_of_match[] = {
+	{ .compatible = "qcom,rpm-apq8084" },
+	{ .compatible = "qcom,rpm-ipq6018" },
+	{ .compatible = "qcom,rpm-ipq9574" },
+	{ .compatible = "qcom,rpm-msm8226" },
+	{ .compatible = "qcom,rpm-msm8909" },
+	{ .compatible = "qcom,rpm-msm8916" },
+	{ .compatible = "qcom,rpm-msm8936" },
+	{ .compatible = "qcom,rpm-msm8953" },
+	{ .compatible = "qcom,rpm-msm8974" },
+	{ .compatible = "qcom,rpm-msm8976" },
+	{ .compatible = "qcom,rpm-msm8994" },
+	{ .compatible = "qcom,rpm-msm8996" },
+	{ .compatible = "qcom,rpm-msm8998" },
+	{ .compatible = "qcom,rpm-sdm660" },
+	{ .compatible = "qcom,rpm-sm6115" },
+	{ .compatible = "qcom,rpm-sm6125" },
+	{ .compatible = "qcom,rpm-sm6375" },
+	{ .compatible = "qcom,rpm-qcm2290" },
+	{ .compatible = "qcom,rpm-qcs404" },
+	{}
 };
-MODULE_DEVICE_TABLE(rpmsg, qcom_smd_rpm_id_table);
+MODULE_DEVICE_TABLE(of, qcom_smd_rpm_of_match);
 
 static struct rpmsg_driver qcom_smd_rpm_driver = {
 	.probe = qcom_smd_rpm_probe,
 	.remove = qcom_smd_rpm_remove,
 	.callback = qcom_smd_rpm_callback,
-	.id_table = qcom_smd_rpm_id_table,
-	.drv.name = "qcom_smd_rpm",
+	.drv  = {
+		.name  = "qcom_smd_rpm",
+		.of_match_table = qcom_smd_rpm_of_match,
+	},
 };
 
 static int __init qcom_smd_rpm_init(void)


