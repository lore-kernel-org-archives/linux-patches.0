Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8870F6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5BEC433CA;
	Sun, 17 Sep 2023 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980920;
	bh=wYZ8Ez6SAfQhmO2iHsoeNdbSh4MhMD5GfbBAuJr8xn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b69iTCvExNQ2P2jO9KXC9g/emgPhoVrUdD40LsBzwfikJuMSps2TdMpmqsY2oiXVS
	 wy8GNQnoqWOhS/mJWPUnAYLsFCL7R3CyF8CfPr0Ds05mcVtdMLx+b9c/N0eX06JLxi
	 w+BityK9JUPUuHmticRk0RFt/XW3G8wdElHQJOJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 046/219] clk: qcom: lpasscc-sc7280: fix missing resume during probe
Date: Sun, 17 Sep 2023 21:12:53 +0200
Message-ID: <20230917191042.666196864@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 66af5339d4f8e20c6d89a490570bd94d40f1a7f6 upstream.

Drivers that enable runtime PM must make sure that the controller is
runtime resumed before accessing its registers to prevent the power
domain from being disabled.

Fixes: 4ab43d171181 ("clk: qcom: Add lpass clock controller driver for SC7280")
Cc: stable@vger.kernel.org      # 5.16
Cc: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230718132902.21430-6-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/lpasscc-sc7280.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/clk/qcom/lpasscc-sc7280.c
+++ b/drivers/clk/qcom/lpasscc-sc7280.c
@@ -115,9 +115,13 @@ static int lpass_cc_sc7280_probe(struct
 	ret = pm_clk_add(&pdev->dev, "iface");
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to acquire iface clock\n");
-		goto destroy_pm_clk;
+		goto err_destroy_pm_clk;
 	}
 
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret)
+		goto err_destroy_pm_clk;
+
 	if (!of_property_read_bool(pdev->dev.of_node, "qcom,adsp-pil-mode")) {
 		lpass_regmap_config.name = "qdsp6ss";
 		lpass_regmap_config.max_register = 0x3f;
@@ -125,7 +129,7 @@ static int lpass_cc_sc7280_probe(struct
 
 		ret = qcom_cc_probe_by_index(pdev, 0, desc);
 		if (ret)
-			goto destroy_pm_clk;
+			goto err_put_rpm;
 	}
 
 	lpass_regmap_config.name = "top_cc";
@@ -134,11 +138,15 @@ static int lpass_cc_sc7280_probe(struct
 
 	ret = qcom_cc_probe_by_index(pdev, 1, desc);
 	if (ret)
-		goto destroy_pm_clk;
+		goto err_put_rpm;
+
+	pm_runtime_put(&pdev->dev);
 
 	return 0;
 
-destroy_pm_clk:
+err_put_rpm:
+	pm_runtime_put_sync(&pdev->dev);
+err_destroy_pm_clk:
 	pm_clk_destroy(&pdev->dev);
 
 disable_pm_runtime:


