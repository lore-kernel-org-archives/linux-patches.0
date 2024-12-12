Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2496521504F;
	Thu, 12 Dec 2024 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016473; cv=none; b=dRUYFnHpTItUnglVlhDLnil33wAnO31JcCxibIH5rvOfbf3/E+weJxxQEsscrJ7Qu8s3A32NrAtPNjeDnhvyZPvc8vZKQpeULytAI07UHkoM8xKgIae8ZhH9H02aRPUTL88TJJ8HLzxTsCF8GD5l7Eztint6xGtSPvjsALjDDD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016473; c=relaxed/simple;
	bh=NSv79MCFDIxHg8NI5cl8omOIc3hwpjeWf2s4fHJXFyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGN1M++KSYPEvud2QF5S2rjfqNCIoia/AHKNobTWNxcGbgaiZpzz1b6pgCl44SaaFzyNHhoWWua/cMRpFtxCLmtmcXcjsseGf5po/Q9S40lPQ0JColLO6N6pBRmPZEoHqs2XdDyEqm9bG0tlmQUbeqcBIq+CTe1l5+8T/LD7VAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znBPaE3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znBPaE3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819E4C4CECE;
	Thu, 12 Dec 2024 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016473;
	bh=NSv79MCFDIxHg8NI5cl8omOIc3hwpjeWf2s4fHJXFyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znBPaE3cbhGoQf9weH+jDb9x2PVlhsGGM4UO2SM28v6k5WY3MvCX4VgNJvVY4oBaU
	 vdsATg09kYzzG4bsQwR5sNK8jES51lZTBGtdqAm1u1cDqN3somQVpbvqoqA5O81zjP
	 KeDrl/BSqRoTaBguWl2NRBsyZ1s1I6vMcEkfhvRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 209/466] scsi: ufs: pltfrm: Drop PM runtime reference count after ufshcd_remove()
Date: Thu, 12 Dec 2024 15:56:18 +0100
Message-ID: <20241212144315.044253607@linuxfoundation.org>
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

commit 1745dcdb7227102e16248a324c600b9121c8f6df upstream.

During the remove stage of glue drivers, some of them are incrementing the
reference count using pm_runtime_get_sync(), before removing the ufshcd
using ufshcd_remove(). But they are not dropping that reference count after
ufshcd_remove() to balance the refcount.

So drop the reference count by calling pm_runtime_put_noidle() after
ufshcd_remove(). Since the behavior is applicable to all glue drivers, move
the PM handling to ufshcd_pltfrm_remove().

Cc: stable@vger.kernel.org # 3.12
Fixes: 62694735ca95 ("[SCSI] ufs: Add runtime PM support for UFS host controller driver")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241111-ufs_bug_fix-v1-4-45ad8b62f02e@linaro.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/tc-dwc-g210-pltfrm.c |    1 -
 drivers/ufs/host/ufs-exynos.c         |    1 -
 drivers/ufs/host/ufs-mediatek.c       |    1 -
 drivers/ufs/host/ufs-qcom.c           |    1 -
 drivers/ufs/host/ufs-sprd.c           |    1 -
 drivers/ufs/host/ufshcd-pltfrm.c      |    2 ++
 6 files changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/ufs/host/tc-dwc-g210-pltfrm.c
+++ b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
@@ -76,7 +76,6 @@ static int tc_dwc_g210_pltfm_probe(struc
  */
 static void tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
 {
-	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_pltfrm_remove(pdev);
 }
 
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1963,7 +1963,6 @@ static void exynos_ufs_remove(struct pla
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 
-	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_pltfrm_remove(pdev);
 
 	phy_power_off(ufs->phy);
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1869,7 +1869,6 @@ out:
  */
 static void ufs_mtk_remove(struct platform_device *pdev)
 {
-	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_pltfrm_remove(pdev);
 }
 
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1845,7 +1845,6 @@ static void ufs_qcom_remove(struct platf
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
-	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_pltfrm_remove(pdev);
 	if (host->esi_enabled)
 		platform_device_msi_free_irqs_all(hba->dev);
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -427,7 +427,6 @@ static int ufs_sprd_probe(struct platfor
 
 static void ufs_sprd_remove(struct platform_device *pdev)
 {
-	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_pltfrm_remove(pdev);
 }
 
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -532,8 +532,10 @@ void ufshcd_pltfrm_remove(struct platfor
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
+	pm_runtime_get_sync(&pdev->dev);
 	ufshcd_remove(hba);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(ufshcd_pltfrm_remove);
 


