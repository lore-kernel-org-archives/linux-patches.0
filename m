Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7513002D1;
	Wed, 25 Feb 2026 06:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002630; cv=none; b=JrrT+nMUDqQxR2eYTowCJafmfht/wx7j+pmDT0sRVzS9ChVVKQxwZcJDpnplqr0gbDF8IPPtlIkv2P73BTnRxWw+k/rxxb8/tNcScOb25gXEoVpOfVhguqg7R56YtTCN7JH3atX958y+l9AC1TLLnL9WUDl/cgW8ZEor3Rk+Upo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002630; c=relaxed/simple;
	bh=Q91rFZmI/VlO0qr3+kn4FWYrmPOFafWyv5YqJc3Z6uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftF43TsYn2q4wFyZ9I87tm24A1nmn2oN3ha9nQFikacm6XJSo4KIAzfCo8NOZ1HHWZWL82PgaXfbEujsXk57d76BGSCMhNW5u8gfXvSfcpoG3fsUS+9y5ICcB9fDbSkXEco8xg09EoXb2nIMo12NdsYXKKuLzqX3/KEzKVh9XxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNMQVbOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNMQVbOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B95C116D0;
	Wed, 25 Feb 2026 06:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002629;
	bh=Q91rFZmI/VlO0qr3+kn4FWYrmPOFafWyv5YqJc3Z6uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNMQVbOwkiS/SEAZ7KST2M1QRuaexfCCwZNIqzq+PbxPbsfOS/4dqWDJEDwtjlxKI
	 tT++YvrOd1jabxxnIegKwCTtO2R8wjV0eVM/a1zXGeK5AbXdHPJjCuLCTt3QMBlI7W
	 o7PoWkX9X5kZhdQcskJZcmjL1Z11fd6qA32wCBSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 392/641] scsi: ufs: host: mediatek: Require CONFIG_PM
Date: Tue, 24 Feb 2026 17:21:58 -0800
Message-ID: <20260225012358.074275931@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 191fbd799ec5b..48ee7e9b665ef 100644
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
index d0cbd96ad29dc..3c63adca561d2 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2366,7 +2366,6 @@ static void ufs_mtk_remove(struct platform_device *pdev)
 	ufshcd_pltfrm_remove(pdev);
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int ufs_mtk_system_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2413,9 +2412,7 @@ static int ufs_mtk_system_resume(struct device *dev)
 
 	return ret;
 }
-#endif
 
-#ifdef CONFIG_PM
 static int ufs_mtk_runtime_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2454,13 +2451,10 @@ static int ufs_mtk_runtime_resume(struct device *dev)
 
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
@@ -2470,7 +2464,7 @@ static struct platform_driver ufs_mtk_pltform = {
 	.remove = ufs_mtk_remove,
 	.driver = {
 		.name   = "ufshcd-mtk",
-		.pm     = &ufs_mtk_pm_ops,
+		.pm     = pm_ptr(&ufs_mtk_pm_ops),
 		.of_match_table = ufs_mtk_of_match,
 	},
 };
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d949db3a46759..17fe07dac6a7e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1350,17 +1350,13 @@ static inline void *ufshcd_get_variant(struct ufs_hba *hba)
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
 
 extern int ufshcd_dme_reset(struct ufs_hba *hba);
 extern int ufshcd_dme_enable(struct ufs_hba *hba);
-- 
2.51.0



