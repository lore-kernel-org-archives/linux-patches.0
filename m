Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2822123F5;
	Tue, 12 Nov 2024 10:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408002; cv=none; b=lOftForH18Vlb9XtFcFhNL6oNN12dwDdNzGSJkBjgXqXkjj95PImmpWjyz+tZ8Z4iIuWAesLOXtdtt6tyHI86CkXVw72kT2/zbTms7QnOqsaGqdqzCeH0V9dLW8RJFc8iKQO1aH61us2w9Hv/nPEmFet5w90R/JB8nZBPPDK6X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408002; c=relaxed/simple;
	bh=dZlh7oRlt7+jWPX1LmPrE71hQ43b10NuARqoUHlcIZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyoZaxnDsBVPoGkprqnh2vqO1cASm8lSmbuuUZlmSjyn9x2r+xEeeI7dE51L/BN0XTVmU2xYsPtuC7/8OcFgfX/RWj+W588Ppso9dLSSdZDdHIbPlCE2w53M8JtDd2gL3b/EzUgYC6RYKOiidt3rTN2H77G/5dqOMHVNT4HNqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaNQXn2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaNQXn2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A10C4CECD;
	Tue, 12 Nov 2024 10:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408002;
	bh=dZlh7oRlt7+jWPX1LmPrE71hQ43b10NuARqoUHlcIZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaNQXn2gxn7QeuVfaFCJvsv5oNRPKmAs8KQVFjY8Wr4O5VwFGsGmUEuOXBuopYRO3
	 bjAt/78GXDTauazQ+lCnkDRZ/i2DFE9U9mzC8mlROkd7kgGe1GHdkFAkT16S+q08jm
	 b/eiHr/wA+OE7/mwUURyB9F5Qs0+B5HxKfjeNVfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 007/184] EDAC/qcom: Make irq configuration optional
Date: Tue, 12 Nov 2024 11:19:25 +0100
Message-ID: <20241112101901.154281809@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajendra Nayak <quic_rjendra@quicinc.com>

[ Upstream commit 0a97195d2181caced187acd7454464b8e37021d7 ]

On most modern qualcomm SoCs, the configuration necessary to enable the
Tag/Data RAM related irqs being propagated to the SoC irq controller is
already done in firmware (in DSF or 'DDR System Firmware')

On some like the x1e80100, these registers aren't even accesible to the
kernel causing a crash when edac device is probed.

Hence, make the irq configuration optional in the driver and mark x1e80100
as the SoC on which this should be avoided.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Reported-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Rajendra Nayak <quic_rjendra@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240903101510.3452734-1-quic_rjendra@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/qcom_edac.c           | 8 +++++---
 drivers/soc/qcom/llcc-qcom.c       | 3 +++
 include/linux/soc/qcom/llcc-qcom.h | 2 ++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
index d3cd4cc54ace9..a9a8ba067007a 100644
--- a/drivers/edac/qcom_edac.c
+++ b/drivers/edac/qcom_edac.c
@@ -342,9 +342,11 @@ static int qcom_llcc_edac_probe(struct platform_device *pdev)
 	int ecc_irq;
 	int rc;
 
-	rc = qcom_llcc_core_setup(llcc_driv_data, llcc_driv_data->bcast_regmap);
-	if (rc)
-		return rc;
+	if (!llcc_driv_data->ecc_irq_configured) {
+		rc = qcom_llcc_core_setup(llcc_driv_data, llcc_driv_data->bcast_regmap);
+		if (rc)
+			return rc;
+	}
 
 	/* Allocate edac control info */
 	edev_ctl = edac_device_alloc_ctl_info(0, "qcom-llcc", 1, "bank",
diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 37e11e5017285..9ff3b42cb1955 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -139,6 +139,7 @@ struct qcom_llcc_config {
 	int size;
 	bool need_llcc_cfg;
 	bool no_edac;
+	bool irq_configured;
 };
 
 struct qcom_sct_config {
@@ -720,6 +721,7 @@ static const struct qcom_llcc_config x1e80100_cfg[] = {
 		.need_llcc_cfg	= true,
 		.reg_offset	= llcc_v2_1_reg_offset,
 		.edac_reg_offset = &llcc_v2_1_edac_reg_offset,
+		.irq_configured = true,
 	},
 };
 
@@ -1347,6 +1349,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 	drv_data->cfg = llcc_cfg;
 	drv_data->cfg_size = sz;
 	drv_data->edac_reg_offset = cfg->edac_reg_offset;
+	drv_data->ecc_irq_configured = cfg->irq_configured;
 	mutex_init(&drv_data->lock);
 	platform_set_drvdata(pdev, drv_data);
 
diff --git a/include/linux/soc/qcom/llcc-qcom.h b/include/linux/soc/qcom/llcc-qcom.h
index 9e9f528b13701..2f20281d4ad43 100644
--- a/include/linux/soc/qcom/llcc-qcom.h
+++ b/include/linux/soc/qcom/llcc-qcom.h
@@ -125,6 +125,7 @@ struct llcc_edac_reg_offset {
  * @num_banks: Number of llcc banks
  * @bitmap: Bit map to track the active slice ids
  * @ecc_irq: interrupt for llcc cache error detection and reporting
+ * @ecc_irq_configured: 'True' if firmware has already configured the irq propagation
  * @version: Indicates the LLCC version
  */
 struct llcc_drv_data {
@@ -139,6 +140,7 @@ struct llcc_drv_data {
 	u32 num_banks;
 	unsigned long *bitmap;
 	int ecc_irq;
+	bool ecc_irq_configured;
 	u32 version;
 };
 
-- 
2.43.0



