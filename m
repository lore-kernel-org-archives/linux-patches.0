Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8737011C9B;
	Thu, 30 Nov 2023 16:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uE1xHyEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F12C433C7;
	Thu, 30 Nov 2023 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701362009;
	bh=Cd2Px7K9QRczvDVtFN/75lfsf6q61RKgwMj33Gj9+N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uE1xHyEMxv8juNyY9HznAHZ4nuZOr1qfQeGkIfsFgwWr7X67vxXHRzxKQpA5mvVYp
	 vJbm75aKBWG02V/11rNFovsefwsVl8nb6H+J+FyBQXaaySsuXpKiOuUoAPj2O2etFV
	 M5paM+GrpCqtsgQQA16C1SqH3cZ+zlrPVEzP1EIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawn.guo@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/69] USB: dwc3: qcom: fix ACPI platform device leak
Date: Thu, 30 Nov 2023 16:22:23 +0000
Message-ID: <20231130162133.938968999@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 9cf87666fc6e08572341fe08ecd909935998fbbd ]

Make sure to free the "urs" platform device, which is created for some
ACPI platforms, on probe errors and on driver unbind.

Compile-tested only.

Fixes: c25c210f590e ("usb: dwc3: qcom: add URS Host support for sdm845 ACPI boot")
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Andrew Halaney <ahalaney@redhat.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20231117173650.21161-4-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 37 +++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index d7240cdca07c1..5d67378bd77ce 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -704,9 +704,9 @@ static int dwc3_qcom_of_register_core(struct platform_device *pdev)
 	return ret;
 }
 
-static struct platform_device *
-dwc3_qcom_create_urs_usb_platdev(struct device *dev)
+static struct platform_device *dwc3_qcom_create_urs_usb_platdev(struct device *dev)
 {
+	struct platform_device *urs_usb = NULL;
 	struct fwnode_handle *fwh;
 	struct acpi_device *adev;
 	char name[8];
@@ -726,9 +726,26 @@ dwc3_qcom_create_urs_usb_platdev(struct device *dev)
 
 	adev = to_acpi_device_node(fwh);
 	if (!adev)
-		return NULL;
+		goto err_put_handle;
+
+	urs_usb = acpi_create_platform_device(adev, NULL);
+	if (IS_ERR_OR_NULL(urs_usb))
+		goto err_put_handle;
+
+	return urs_usb;
 
-	return acpi_create_platform_device(adev, NULL);
+err_put_handle:
+	fwnode_handle_put(fwh);
+
+	return urs_usb;
+}
+
+static void dwc3_qcom_destroy_urs_usb_platdev(struct platform_device *urs_usb)
+{
+	struct fwnode_handle *fwh = urs_usb->dev.fwnode;
+
+	platform_device_unregister(urs_usb);
+	fwnode_handle_put(fwh);
 }
 
 static int dwc3_qcom_probe(struct platform_device *pdev)
@@ -812,13 +829,13 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 	qcom->qscratch_base = devm_ioremap_resource(dev, parent_res);
 	if (IS_ERR(qcom->qscratch_base)) {
 		ret = PTR_ERR(qcom->qscratch_base);
-		goto clk_disable;
+		goto free_urs;
 	}
 
 	ret = dwc3_qcom_setup_irq(pdev);
 	if (ret) {
 		dev_err(dev, "failed to setup IRQs, err=%d\n", ret);
-		goto clk_disable;
+		goto free_urs;
 	}
 
 	/*
@@ -837,7 +854,7 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 
 	if (ret) {
 		dev_err(dev, "failed to register DWC3 Core, err=%d\n", ret);
-		goto clk_disable;
+		goto free_urs;
 	}
 
 	ret = dwc3_qcom_interconnect_init(qcom);
@@ -871,6 +888,9 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 	else
 		platform_device_del(qcom->dwc3);
 	platform_device_put(qcom->dwc3);
+free_urs:
+	if (qcom->urs_usb)
+		dwc3_qcom_destroy_urs_usb_platdev(qcom->urs_usb);
 clk_disable:
 	for (i = qcom->num_clocks - 1; i >= 0; i--) {
 		clk_disable_unprepare(qcom->clks[i]);
@@ -896,6 +916,9 @@ static int dwc3_qcom_remove(struct platform_device *pdev)
 		platform_device_del(qcom->dwc3);
 	platform_device_put(qcom->dwc3);
 
+	if (qcom->urs_usb)
+		dwc3_qcom_destroy_urs_usb_platdev(qcom->urs_usb);
+
 	for (i = qcom->num_clocks - 1; i >= 0; i--) {
 		clk_disable_unprepare(qcom->clks[i]);
 		clk_put(qcom->clks[i]);
-- 
2.42.0



