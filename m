Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA821D0786;
	Wed,  2 Oct 2024 14:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880346; cv=none; b=BEdJaUjBJCxuDB+NyBaczN27Sa0lMdAFe7/IRs8Q4IBR7lWMRQ+Z+idK00stGV1/9Dp5T4mlENAd+A9XQ0NjkY7g1O40VGA4fSuB3mLk87Za+8hfw651OmdMxJrgtuc0hKOd0gJoRGNzONHlDvBX2tRCD1hVkte+YwZrk+ArJ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880346; c=relaxed/simple;
	bh=VXCG2c71jhwpDWMlIP+FG1TM83U8ZHRzMGadoYqCLMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNk+UMy7Rfcpn11MgJLg1rrQiNfvF4JyWQQJzdTO66RYmZ5K5YzVWtW7EzLilUaufnftNGH9kE9HMaSFWQvFegRKRtHuENh+uGPcsqyHW6pqRHgP5B4IqaiUhLJt5Rodv6Kj6Gv4FazTIpgPBXjNIDb7hZVA+FkerIXWa06b+e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcVu2JTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcVu2JTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEDDC4CEC2;
	Wed,  2 Oct 2024 14:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880346;
	bh=VXCG2c71jhwpDWMlIP+FG1TM83U8ZHRzMGadoYqCLMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcVu2JTyiKYCMYg02S+ITbol4AC1d0IXnwgKghJELbKU0jwUHIdd19Huww+7Ry/Ev
	 g5r5xE6O/ahDJK7MUTs+BmRzLUkG6NmeBKwriUIdGHJHImUIgV5RIILusKp8Xz5y+B
	 MRGa+EdEKUNvb8Js5P8AlGR5I2/7uyuylWOJL1ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 400/538] Revert "soc: qcom: smd-rpm: Match rpmsg channel instead of compatible"
Date: Wed,  2 Oct 2024 15:00:39 +0200
Message-ID: <20241002125808.227384977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/soc/qcom/smd-rpm.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/soc/qcom/smd-rpm.c b/drivers/soc/qcom/smd-rpm.c
index b7056aed4c7d..9d64283d2125 100644
--- a/drivers/soc/qcom/smd-rpm.c
+++ b/drivers/soc/qcom/smd-rpm.c
@@ -196,9 +196,6 @@ static int qcom_smd_rpm_probe(struct rpmsg_device *rpdev)
 {
 	struct qcom_smd_rpm *rpm;
 
-	if (!rpdev->dev.of_node)
-		return -EINVAL;
-
 	rpm = devm_kzalloc(&rpdev->dev, sizeof(*rpm), GFP_KERNEL);
 	if (!rpm)
 		return -ENOMEM;
@@ -218,18 +215,38 @@ static void qcom_smd_rpm_remove(struct rpmsg_device *rpdev)
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
-- 
2.46.2



