Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A858213E97;
	Thu, 12 Dec 2024 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016306; cv=none; b=ZcGpq/QYTGOWHRL+NP/jThf+dRZm9ip8aBqexNFOiZTi/usJk0jJcgBi75v50MriENsMdkiAkemgmRgM11y9TWdW0F89+nivZe8pZL2v3z8yCJsHSqfoSbi3DrJCxYGi4CQXvcpE+M+YQT+Zymytqv+xjbBEs7m7KHckkXUjr88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016306; c=relaxed/simple;
	bh=+uI5BTrUGbNgGe9D85Y7WORUBxsDGIbBEmJVKloLzAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDqfkDXsatZ4bAIJFjs23VycWzFTAnZfdnjGfH9YAHOPO/NlqZFyyk1LkkGRK/PGFyMJ6KTq/Q3naqjck07WJ6gim6BHgdG9sgqP5/wRjOt2sP95gMnqLzPBNc7uRSAgkxxXFXFWZvpfdh/AncfVLhZcYZON1Cz3dJsiMWqUM8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnU1rIo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnU1rIo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B57C4CED7;
	Thu, 12 Dec 2024 15:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016305;
	bh=+uI5BTrUGbNgGe9D85Y7WORUBxsDGIbBEmJVKloLzAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnU1rIo4K9fSXytztHStMA23NBeimQq+v3ZCsxGLQW0KSzNqGOWf8079Ny+Bbk5yb
	 H4nZxiVQAE9VG3UnySQa81ROfEoGoVYoWydoCYqb4uPUagUl5s/us1U1uVSJBWscgw
	 jACAY1VveSgzXuq8P07Rtq5NllkUMJ5OEwtFwmfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 153/466] scsi: ufs: pltfrm: Disable runtime PM during removal of glue drivers
Date: Thu, 12 Dec 2024 15:55:22 +0100
Message-ID: <20241212144312.841582339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit d3326e6a3f9bf1e075be2201fb704c2fdf19e2b7 upstream.

When the UFSHCD platform glue drivers are removed, runtime PM should be
disabled using pm_runtime_disable() to balance the enablement done in
ufshcd_pltfrm_init(). This is also reported by PM core when the glue driver
is removed and inserted again:

ufshcd-qcom 1d84000.ufshc: Unbalanced pm_runtime_enable!

So disable runtime PM using a new helper API ufshcd_pltfrm_remove(), that
also takes care of removing ufshcd. This helper should be called during the
remove() stage of glue drivers.

Cc: stable@vger.kernel.org # 3.12
Fixes: 62694735ca95 ("[SCSI] ufs: Add runtime PM support for UFS host controller driver")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241111-ufs_bug_fix-v1-3-45ad8b62f02e@linaro.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/cdns-pltfrm.c        |    4 +---
 drivers/ufs/host/tc-dwc-g210-pltfrm.c |    4 +---
 drivers/ufs/host/ufs-exynos.c         |    2 +-
 drivers/ufs/host/ufs-hisi.c           |    4 +---
 drivers/ufs/host/ufs-mediatek.c       |    4 +---
 drivers/ufs/host/ufs-qcom.c           |    2 +-
 drivers/ufs/host/ufs-renesas.c        |    4 +---
 drivers/ufs/host/ufs-sprd.c           |    4 +---
 drivers/ufs/host/ufshcd-pltfrm.c      |   13 +++++++++++++
 drivers/ufs/host/ufshcd-pltfrm.h      |    1 +
 10 files changed, 22 insertions(+), 20 deletions(-)

--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -307,9 +307,7 @@ static int cdns_ufs_pltfrm_probe(struct
  */
 static void cdns_ufs_pltfrm_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
--- a/drivers/ufs/host/tc-dwc-g210-pltfrm.c
+++ b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
@@ -76,10 +76,8 @@ static int tc_dwc_g210_pltfm_probe(struc
  */
 static void tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
 	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1964,7 +1964,7 @@ static void exynos_ufs_remove(struct pla
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 
 	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 
 	phy_power_off(ufs->phy);
 	phy_exit(ufs->phy);
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -576,9 +576,7 @@ static int ufs_hisi_probe(struct platfor
 
 static void ufs_hisi_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static const struct dev_pm_ops ufs_hisi_pm_ops = {
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1869,10 +1869,8 @@ out:
  */
 static void ufs_mtk_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
 	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 #ifdef CONFIG_PM_SLEEP
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1846,7 +1846,7 @@ static void ufs_qcom_remove(struct platf
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 	if (host->esi_enabled)
 		platform_device_msi_free_irqs_all(hba->dev);
 }
--- a/drivers/ufs/host/ufs-renesas.c
+++ b/drivers/ufs/host/ufs-renesas.c
@@ -390,9 +390,7 @@ static int ufs_renesas_probe(struct plat
 
 static void ufs_renesas_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba = platform_get_drvdata(pdev);
-
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static struct platform_driver ufs_renesas_platform = {
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -427,10 +427,8 @@ static int ufs_sprd_probe(struct platfor
 
 static void ufs_sprd_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
 	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static const struct dev_pm_ops ufs_sprd_pm_ops = {
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -524,6 +524,19 @@ out:
 }
 EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
+/**
+ * ufshcd_pltfrm_remove - Remove ufshcd platform
+ * @pdev: pointer to Platform device handle
+ */
+void ufshcd_pltfrm_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	ufshcd_remove(hba);
+	pm_runtime_disable(&pdev->dev);
+}
+EXPORT_SYMBOL_GPL(ufshcd_pltfrm_remove);
+
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
--- a/drivers/ufs/host/ufshcd-pltfrm.h
+++ b/drivers/ufs/host/ufshcd-pltfrm.h
@@ -31,6 +31,7 @@ int ufshcd_negotiate_pwr_params(const st
 void ufshcd_init_host_params(struct ufs_host_params *host_params);
 int ufshcd_pltfrm_init(struct platform_device *pdev,
 		       const struct ufs_hba_variant_ops *vops);
+void ufshcd_pltfrm_remove(struct platform_device *pdev);
 int ufshcd_populate_vreg(struct device *dev, const char *name,
 			 struct ufs_vreg **out_vreg, bool skip_current);
 


