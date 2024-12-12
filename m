Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695036F2FE;
	Thu, 12 Dec 2024 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018937; cv=none; b=WroE7ezxjaFR9zdMqwkTJ9bNYyDpdYh+jDa4ycOpoRhJjiCmCfYYu6/e5EgB8lrs0/UAMribXYephLpdVGD3hSX7zD3sTpvUKKVc76tNogaOmA6gP+yHfD4UjHg2rjqJ6JDU65ET22GxMac6oPLkCnFM2ORf0hheKKqIwNZY0j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018937; c=relaxed/simple;
	bh=CWqS+eI6tmJZ1hj+hJbD5Ssi69VEnBbkQdfMjQOeNb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewTc8SxTiPrYmfnip6UJQTU4SaitQ+TzYqZ4u9PiQx3OyonwJgb1ZcMW7sr7KxabLpJcEeIOR2UHfWxCjEuesKHutPyfv1OKptg84RX+RM4xPc2Yate9NU94kxPLWteL1EkPvrkLnaX8Dz7DQq0n/1H0qxAIM66ZETfT8H1Ux0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krIleRfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krIleRfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50100C4CECE;
	Thu, 12 Dec 2024 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018937;
	bh=CWqS+eI6tmJZ1hj+hJbD5Ssi69VEnBbkQdfMjQOeNb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krIleRfTjnNlYbqwOTaVG3lWqT+2VpTvqOv9OtN6fFH6Ow25k+PvFg3eMs8F0R7jL
	 2VS0zHKStR0Iy2z9jppJNMTixex7/g567OMoSfC15+MTaeF/zMWO4jZ6cr+1CtgiQo
	 4ektbP8XlWsu4FkWrLQwZ6AyKP95AsKBkkjTqZAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/772] crypto: hisilicon/qm - disable same error report before resetting
Date: Thu, 12 Dec 2024 15:50:20 +0100
Message-ID: <20241212144353.027321251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit c418ba6baca3ae10ffaf47b0803d2a9e6bf1af96 ]

If an error indicating that the device needs to be reset is reported,
disable the error reporting before device reset is complete,
enable the error reporting after the reset is complete to prevent
the same error from being reported repeatedly.

Fixes: eaebf4c3b103 ("crypto: hisilicon - Unify hardware error init/uninit into QM")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 35 ++++++++++++++---
 drivers/crypto/hisilicon/qm.c             | 47 +++++++----------------
 drivers/crypto/hisilicon/sec2/sec_main.c  | 35 ++++++++++++++---
 drivers/crypto/hisilicon/zip/zip_main.c   | 35 ++++++++++++++---
 include/linux/hisi_acc_qm.h               |  8 +++-
 5 files changed, 110 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index e9abb66773fe9..b0596564d27d8 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1281,11 +1281,15 @@ static u32 hpre_get_hw_err_status(struct hisi_qm *qm)
 
 static void hpre_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 {
-	u32 nfe;
-
 	writel(err_sts, qm->io_base + HPRE_HAC_SOURCE_INT);
-	nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
-	writel(nfe, qm->io_base + HPRE_RAS_NFE_ENB);
+}
+
+static void hpre_disable_error_report(struct hisi_qm *qm, u32 err_type)
+{
+	u32 nfe_mask;
+
+	nfe_mask = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
+	writel(nfe_mask & (~err_type), qm->io_base + HPRE_RAS_NFE_ENB);
 }
 
 static void hpre_open_axi_master_ooo(struct hisi_qm *qm)
@@ -1299,6 +1303,27 @@ static void hpre_open_axi_master_ooo(struct hisi_qm *qm)
 	       qm->io_base + HPRE_AM_OOO_SHUTDOWN_ENB);
 }
 
+static enum acc_err_result hpre_get_err_result(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = hpre_get_hw_err_status(qm);
+	if (err_status) {
+		if (err_status & qm->err_info.ecc_2bits_mask)
+			qm->err_status.is_dev_ecc_mbit = true;
+		hpre_log_hw_error(qm, err_status);
+
+		if (err_status & qm->err_info.dev_reset_mask) {
+			/* Disable the same error reporting until device is recovered. */
+			hpre_disable_error_report(qm, err_status);
+			return ACC_ERR_NEED_RESET;
+		}
+		hpre_clear_hw_err_status(qm, err_status);
+	}
+
+	return ACC_ERR_RECOVERED;
+}
+
 static void hpre_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -1325,12 +1350,12 @@ static const struct hisi_qm_err_ini hpre_err_ini = {
 	.hw_err_disable		= hpre_hw_error_disable,
 	.get_dev_hw_err_status	= hpre_get_hw_err_status,
 	.clear_dev_hw_err_status = hpre_clear_hw_err_status,
-	.log_dev_hw_err		= hpre_log_hw_error,
 	.open_axi_master_ooo	= hpre_open_axi_master_ooo,
 	.open_sva_prefetch	= hpre_open_sva_prefetch,
 	.close_sva_prefetch	= hpre_close_sva_prefetch,
 	.show_last_dfx_regs	= hpre_show_last_dfx_regs,
 	.err_info_init		= hpre_err_info_init,
+	.get_err_result		= hpre_get_err_result,
 };
 
 static int hpre_pf_probe_init(struct hpre *hpre)
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index df14727f6e714..a9bf65da30a68 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -281,12 +281,6 @@ enum vft_type {
 	SHAPER_VFT,
 };
 
-enum acc_err_result {
-	ACC_ERR_NONE,
-	ACC_ERR_NEED_RESET,
-	ACC_ERR_RECOVERED,
-};
-
 enum qm_alg_type {
 	ALG_TYPE_0,
 	ALG_TYPE_1,
@@ -1503,22 +1497,25 @@ static void qm_log_hw_error(struct hisi_qm *qm, u32 error_status)
 
 static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 {
-	u32 error_status, tmp;
-
-	/* read err sts */
-	tmp = readl(qm->io_base + QM_ABNORMAL_INT_STATUS);
-	error_status = qm->error_mask & tmp;
+	u32 error_status;
 
-	if (error_status) {
+	error_status = qm_get_hw_error_status(qm);
+	if (error_status & qm->error_mask) {
 		if (error_status & QM_ECC_MBIT)
 			qm->err_status.is_qm_ecc_mbit = true;
 
 		qm_log_hw_error(qm, error_status);
-		if (error_status & qm->err_info.qm_reset_mask)
+		if (error_status & qm->err_info.qm_reset_mask) {
+			/* Disable the same error reporting until device is recovered. */
+			writel(qm->err_info.nfe & (~error_status),
+			       qm->io_base + QM_RAS_NFE_ENABLE);
 			return ACC_ERR_NEED_RESET;
+		}
 
+		/* Clear error source if not need reset. */
 		writel(error_status, qm->io_base + QM_ABNORMAL_INT_SOURCE);
 		writel(qm->err_info.nfe, qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(qm->err_info.ce, qm->io_base + QM_RAS_CE_ENABLE);
 	}
 
 	return ACC_ERR_RECOVERED;
@@ -3868,30 +3865,12 @@ EXPORT_SYMBOL_GPL(hisi_qm_sriov_configure);
 
 static enum acc_err_result qm_dev_err_handle(struct hisi_qm *qm)
 {
-	u32 err_sts;
-
-	if (!qm->err_ini->get_dev_hw_err_status) {
-		dev_err(&qm->pdev->dev, "Device doesn't support get hw error status!\n");
+	if (!qm->err_ini->get_err_result) {
+		dev_err(&qm->pdev->dev, "Device doesn't support reset!\n");
 		return ACC_ERR_NONE;
 	}
 
-	/* get device hardware error status */
-	err_sts = qm->err_ini->get_dev_hw_err_status(qm);
-	if (err_sts) {
-		if (err_sts & qm->err_info.ecc_2bits_mask)
-			qm->err_status.is_dev_ecc_mbit = true;
-
-		if (qm->err_ini->log_dev_hw_err)
-			qm->err_ini->log_dev_hw_err(qm, err_sts);
-
-		if (err_sts & qm->err_info.dev_reset_mask)
-			return ACC_ERR_NEED_RESET;
-
-		if (qm->err_ini->clear_dev_hw_err_status)
-			qm->err_ini->clear_dev_hw_err_status(qm, err_sts);
-	}
-
-	return ACC_ERR_RECOVERED;
+	return qm->err_ini->get_err_result(qm);
 }
 
 static enum acc_err_result qm_process_dev_error(struct hisi_qm *qm)
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index d2ead648767bd..8dd4c0b10a74a 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1008,11 +1008,15 @@ static u32 sec_get_hw_err_status(struct hisi_qm *qm)
 
 static void sec_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 {
-	u32 nfe;
-
 	writel(err_sts, qm->io_base + SEC_CORE_INT_SOURCE);
-	nfe = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_NFE_MASK_CAP, qm->cap_ver);
-	writel(nfe, qm->io_base + SEC_RAS_NFE_REG);
+}
+
+static void sec_disable_error_report(struct hisi_qm *qm, u32 err_type)
+{
+	u32 nfe_mask;
+
+	nfe_mask = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_NFE_MASK_CAP, qm->cap_ver);
+	writel(nfe_mask & (~err_type), qm->io_base + SEC_RAS_NFE_REG);
 }
 
 static void sec_open_axi_master_ooo(struct hisi_qm *qm)
@@ -1024,6 +1028,27 @@ static void sec_open_axi_master_ooo(struct hisi_qm *qm)
 	writel(val | SEC_AXI_SHUTDOWN_ENABLE, qm->io_base + SEC_CONTROL_REG);
 }
 
+static enum acc_err_result sec_get_err_result(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = sec_get_hw_err_status(qm);
+	if (err_status) {
+		if (err_status & qm->err_info.ecc_2bits_mask)
+			qm->err_status.is_dev_ecc_mbit = true;
+		sec_log_hw_error(qm, err_status);
+
+		if (err_status & qm->err_info.dev_reset_mask) {
+			/* Disable the same error reporting until device is recovered. */
+			sec_disable_error_report(qm, err_status);
+			return ACC_ERR_NEED_RESET;
+		}
+		sec_clear_hw_err_status(qm, err_status);
+	}
+
+	return ACC_ERR_RECOVERED;
+}
+
 static void sec_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -1050,12 +1075,12 @@ static const struct hisi_qm_err_ini sec_err_ini = {
 	.hw_err_disable		= sec_hw_error_disable,
 	.get_dev_hw_err_status	= sec_get_hw_err_status,
 	.clear_dev_hw_err_status = sec_clear_hw_err_status,
-	.log_dev_hw_err		= sec_log_hw_error,
 	.open_axi_master_ooo	= sec_open_axi_master_ooo,
 	.open_sva_prefetch	= sec_open_sva_prefetch,
 	.close_sva_prefetch	= sec_close_sva_prefetch,
 	.show_last_dfx_regs	= sec_show_last_dfx_regs,
 	.err_info_init		= sec_err_info_init,
+	.get_err_result		= sec_get_err_result,
 };
 
 static int sec_pf_probe_init(struct sec_dev *sec)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index a8d5d105b3542..86e5178120936 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1069,11 +1069,15 @@ static u32 hisi_zip_get_hw_err_status(struct hisi_qm *qm)
 
 static void hisi_zip_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 {
-	u32 nfe;
-
 	writel(err_sts, qm->io_base + HZIP_CORE_INT_SOURCE);
-	nfe = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_NFE_MASK_CAP, qm->cap_ver);
-	writel(nfe, qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
+}
+
+static void hisi_zip_disable_error_report(struct hisi_qm *qm, u32 err_type)
+{
+	u32 nfe_mask;
+
+	nfe_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_NFE_MASK_CAP, qm->cap_ver);
+	writel(nfe_mask & (~err_type), qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
 }
 
 static void hisi_zip_open_axi_master_ooo(struct hisi_qm *qm)
@@ -1103,6 +1107,27 @@ static void hisi_zip_close_axi_master_ooo(struct hisi_qm *qm)
 	       qm->io_base + HZIP_CORE_INT_SET);
 }
 
+static enum acc_err_result hisi_zip_get_err_result(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = hisi_zip_get_hw_err_status(qm);
+	if (err_status) {
+		if (err_status & qm->err_info.ecc_2bits_mask)
+			qm->err_status.is_dev_ecc_mbit = true;
+		hisi_zip_log_hw_error(qm, err_status);
+
+		if (err_status & qm->err_info.dev_reset_mask) {
+			/* Disable the same error reporting until device is recovered. */
+			hisi_zip_disable_error_report(qm, err_status);
+			return ACC_ERR_NEED_RESET;
+		}
+		hisi_zip_clear_hw_err_status(qm, err_status);
+	}
+
+	return ACC_ERR_RECOVERED;
+}
+
 static void hisi_zip_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -1130,13 +1155,13 @@ static const struct hisi_qm_err_ini hisi_zip_err_ini = {
 	.hw_err_disable		= hisi_zip_hw_error_disable,
 	.get_dev_hw_err_status	= hisi_zip_get_hw_err_status,
 	.clear_dev_hw_err_status = hisi_zip_clear_hw_err_status,
-	.log_dev_hw_err		= hisi_zip_log_hw_error,
 	.open_axi_master_ooo	= hisi_zip_open_axi_master_ooo,
 	.close_axi_master_ooo	= hisi_zip_close_axi_master_ooo,
 	.open_sva_prefetch	= hisi_zip_open_sva_prefetch,
 	.close_sva_prefetch	= hisi_zip_close_sva_prefetch,
 	.show_last_dfx_regs	= hisi_zip_show_last_dfx_regs,
 	.err_info_init		= hisi_zip_err_info_init,
+	.get_err_result		= hisi_zip_get_err_result,
 };
 
 static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index b566ae420449c..50b6f30adf54f 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -226,6 +226,12 @@ struct hisi_qm_status {
 
 struct hisi_qm;
 
+enum acc_err_result {
+	ACC_ERR_NONE,
+	ACC_ERR_NEED_RESET,
+	ACC_ERR_RECOVERED,
+};
+
 struct hisi_qm_err_info {
 	char *acpi_rst;
 	u32 msi_wr_port;
@@ -254,9 +260,9 @@ struct hisi_qm_err_ini {
 	void (*close_axi_master_ooo)(struct hisi_qm *qm);
 	void (*open_sva_prefetch)(struct hisi_qm *qm);
 	void (*close_sva_prefetch)(struct hisi_qm *qm);
-	void (*log_dev_hw_err)(struct hisi_qm *qm, u32 err_sts);
 	void (*show_last_dfx_regs)(struct hisi_qm *qm);
 	void (*err_info_init)(struct hisi_qm *qm);
+	enum acc_err_result (*get_err_result)(struct hisi_qm *qm);
 };
 
 struct hisi_qm_cap_info {
-- 
2.43.0



