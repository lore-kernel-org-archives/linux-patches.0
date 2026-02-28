Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7078342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301867; cv=none; b=WSLu3riL2LAFqBXHXUYJ/Ix0qGvnbYv2Xwm4CO1JlecuRZbQAKd/9H4X2Q3k62QXVFaicRJwq6qHEDu9zOTVER46Ws0TkORTknVj2It9qVryKO4m3txBLov/no8f9HTiLLBswRnwGT5Ka6WLYo48ZZEUdf6xDoF7a6hZkdUdG3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301867; c=relaxed/simple;
	bh=MTciIv1BgINnkmzHFrXEbLOmMoueKDFhOjNtU1ZOkG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwL+PRTl8f+Bd7VEdveWAcTlXkynmK85LsMhIMro98E3Im0rsOOSeArOHU0zuNgi5G3MbyZYVwjeRshppdNCr/nSklWebxBTg1ZYEMhmbu0uy57HAaL5tUTZjRFiJFdHMqVgrOAuBjkBedqkyRAt7N7X92LXqeOlagMB356nckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tq6u+UY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tq6u+UY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2218FC19425;
	Sat, 28 Feb 2026 18:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301867;
	bh=MTciIv1BgINnkmzHFrXEbLOmMoueKDFhOjNtU1ZOkG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tq6u+UY4J0Cc7934U9OxreyUud0NT9teUWseWIe2o1mvwckFmB9E966axOeb00g74
	 l106qViFbHL4wHwkkJg7hlXF8SAKSS4GgSNfmgj+Hm4z0rMgEsdr4T93vzNlMJu4ja
	 Q9jfPGz9pg/O2nQDFedQfTbXlGIVMguzp1Ar1KW/biCTA+0Zf4/tcUINRZ1YUpV7im
	 lZr2OjTzh72ezUlfBM4CXqGW1WQeVrV8HYFm21eT9Jhx4L/I9DuRD0tMDCnaRrnrHz
	 vrZLCrqmXml+/F178NtetQBCjJwce2JiHjyWgUDQ3T471af5CcJkiE1eRVYkaEyGzs
	 ZjYc0fwisRMoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/385] scsi: ufs: host: mediatek: Require CONFIG_PM
Date: Sat, 28 Feb 2026 12:58:33 -0500
Message-ID: <20260228180011.1568201-291-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bbb8d98fb4536594cb104fd630ea0f7dce3771d6 ]

The added print statement from a recent fix causes the driver to fail
building when CONFIG_PM is disabled:

drivers/ufs/host/ufs-mediatek.c: In function 'ufs_mtk_resume':
drivers/ufs/host/ufs-mediatek.c:1890:40: error: 'struct dev_pm_info' has no member named 'request'
 1890 |                         hba->dev->power.request,

It seems unlikely that the driver can work at all without CONFIG_PM, so
just add a dependency and remove the existing ifdef checks, rather than
adding another ifdef.

Fixes: 15ef3f5aa822 ("scsi: ufs: host: mediatek: Enhance recovery on resume failure")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260202095052.1232703-1-arnd@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/Kconfig        |  1 +
 drivers/ufs/host/ufs-mediatek.c | 12 +++---------
 include/ufs/ufshcd.h            |  4 ----
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 580c8d0bd8bbd..626bb9002f4a1 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -72,6 +72,7 @@ config SCSI_UFS_QCOM
 config SCSI_UFS_MEDIATEK
 	tristate "Mediatek specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
+	depends on PM
 	depends on RESET_CONTROLLER
 	select PHY_MTK_UFS
 	select RESET_TI_SYSCON
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 1fb98af4ac564..e4156238f51d9 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1987,7 +1987,6 @@ static void ufs_mtk_remove(struct platform_device *pdev)
 	ufshcd_pltfrm_remove(pdev);
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int ufs_mtk_system_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2034,9 +2033,7 @@ static int ufs_mtk_system_resume(struct device *dev)
 
 	return ret;
 }
-#endif
 
-#ifdef CONFIG_PM
 static int ufs_mtk_runtime_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2067,13 +2064,10 @@ static int ufs_mtk_runtime_resume(struct device *dev)
 
 	return ufshcd_runtime_resume(dev);
 }
-#endif
 
 static const struct dev_pm_ops ufs_mtk_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend,
-				ufs_mtk_system_resume)
-	SET_RUNTIME_PM_OPS(ufs_mtk_runtime_suspend,
-			   ufs_mtk_runtime_resume, NULL)
+	SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend, ufs_mtk_system_resume)
+	RUNTIME_PM_OPS(ufs_mtk_runtime_suspend, ufs_mtk_runtime_resume, NULL)
 	.prepare	 = ufshcd_suspend_prepare,
 	.complete	 = ufshcd_resume_complete,
 };
@@ -2083,7 +2077,7 @@ static struct platform_driver ufs_mtk_pltform = {
 	.remove_new = ufs_mtk_remove,
 	.driver = {
 		.name   = "ufshcd-mtk",
-		.pm     = &ufs_mtk_pm_ops,
+		.pm     = pm_ptr(&ufs_mtk_pm_ops),
 		.of_match_table = ufs_mtk_of_match,
 	},
 };
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bdc5564b16fba..e68ce42eaff4d 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1356,17 +1356,13 @@ static inline void *ufshcd_get_variant(struct ufs_hba *hba)
 	return hba->priv;
 }
 
-#ifdef CONFIG_PM
 extern int ufshcd_runtime_suspend(struct device *dev);
 extern int ufshcd_runtime_resume(struct device *dev);
-#endif
-#ifdef CONFIG_PM_SLEEP
 extern int ufshcd_system_suspend(struct device *dev);
 extern int ufshcd_system_resume(struct device *dev);
 extern int ufshcd_system_freeze(struct device *dev);
 extern int ufshcd_system_thaw(struct device *dev);
 extern int ufshcd_system_restore(struct device *dev);
-#endif
 
 extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
 				      int agreed_gear,
-- 
2.51.0

