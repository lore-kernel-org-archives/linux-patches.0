Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCF2D512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECC9C433D2;
	Mon, 15 May 2023 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170067;
	bh=kgXIv9b0Q1x6z5FTnOZu/VyQ1bcISavoEtagl+jYDWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DX2OcBdRKnL9X1p/4MTUkcay3eMohJeJAbMTgPtB/hT6ZJsRN5VZ1PsP9LAWmViP8
	 F23judGtpWEaBz4x+Yae7oslmDUbT9bzh6pfyqhDpYhR7abXAKZzLZbuifHNb5OfMP
	 pjjdLMTZ3iR1UEx0koCiCdug4C+TaiUno1E5LwOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/239] soc: qcom: llcc: Do not create EDAC platform device on SDM845
Date: Mon, 15 May 2023 18:24:37 +0200
Message-Id: <20230515161722.018718138@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit cca94f1dd6d0a4c7e5c8190672f5747e3c00ddde ]

The platforms based on SDM845 SoC locks the access to EDAC registers in the
bootloader. So probing the EDAC driver will result in a crash. Hence,
disable the creation of EDAC platform device on all SDM845 devices.

The issue has been observed on Lenovo Yoga C630 and DB845c.

While at it, also sort the members of `struct qcom_llcc_config` to avoid
any holes in-between.

Cc: <stable@vger.kernel.org> # 5.10
Reported-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230314080443.64635-15-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 63a08635fc159..d4cba3b3c56c4 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -101,10 +101,11 @@ struct llcc_slice_config {
 
 struct qcom_llcc_config {
 	const struct llcc_slice_config *sct_data;
-	int size;
-	bool need_llcc_cfg;
 	const u32 *reg_offset;
 	const struct llcc_edac_reg_offset *edac_reg_offset;
+	int size;
+	bool need_llcc_cfg;
+	bool no_edac;
 };
 
 enum llcc_reg_offset {
@@ -401,6 +402,7 @@ static const struct qcom_llcc_config sdm845_cfg = {
 	.need_llcc_cfg	= false,
 	.reg_offset	= llcc_v1_reg_offset,
 	.edac_reg_offset = &llcc_v1_edac_reg_offset,
+	.no_edac	= true,
 };
 
 static const struct qcom_llcc_config sm6350_cfg = {
@@ -851,11 +853,19 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 
 	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
 
-	llcc_edac = platform_device_register_data(&pdev->dev,
-					"qcom_llcc_edac", -1, drv_data,
-					sizeof(*drv_data));
-	if (IS_ERR(llcc_edac))
-		dev_err(dev, "Failed to register llcc edac driver\n");
+	/*
+	 * On some platforms, the access to EDAC registers will be locked by
+	 * the bootloader. So probing the EDAC driver will result in a crash.
+	 * Hence, disable the creation of EDAC platform device for the
+	 * problematic platforms.
+	 */
+	if (!cfg->no_edac) {
+		llcc_edac = platform_device_register_data(&pdev->dev,
+						"qcom_llcc_edac", -1, drv_data,
+						sizeof(*drv_data));
+		if (IS_ERR(llcc_edac))
+			dev_err(dev, "Failed to register llcc edac driver\n");
+	}
 
 	return 0;
 err:
-- 
2.39.2



