Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175DA26E703;
	Tue, 11 Nov 2025 01:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823800; cv=none; b=Pg2w/lwutMkHmfqOX/Jx5twoeVVipJKOZvGmIzdsabSlLDW2DGngoHJt0VFFpy3xMVTia+cznGS7tjdtfT2eC3PHUBFMHUsjANtmBauJi9SgkotHPuvfe8aTunjTlmp59PZeph/N4ei1NdDw12Tyg83V8Km4hv1te9xbGM81ZcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823800; c=relaxed/simple;
	bh=j0xEmAWMzQ3LkkWV2GFnLECjZd70EFKap/CrJ5gHtq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpfvpLSuNN2/Wn40WFcpJgou2pTzzUppVjpoeWhxo00rkkE+xfR49id2PENGjaJtb099DaNzqBOTiTU/nXlmkyGUld11NXoFuOy85pHAmlHnxaybHJNxviCxqeNMie3JnndPCQKUm3mYgmOcLjb/E7FP+CW5MflsHSf7efEpwho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exFuZB0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exFuZB0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86BFC4CEFB;
	Tue, 11 Nov 2025 01:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823800;
	bh=j0xEmAWMzQ3LkkWV2GFnLECjZd70EFKap/CrJ5gHtq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exFuZB0fQhPx80f3wI4L/lJtENZH9mVsn6g24hneX/SRI0erwW03az81QMwaP59TJ
	 v+PvdWT8CbkBcMgByiANnJrbd/EU8MrZUt18Rg1IQuPwCnB1jFQSzqWBdbGO34KJ+q
	 ykvkkQb+vSWvczYxoXsvDVZqCLL8fEOiPxKlkH1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/565] scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes
Date: Tue, 11 Nov 2025 09:43:03 +0900
Message-ID: <20251111004534.243904407@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit f5ca8d0c7a6388abd5d8023cc682e1543728cc73 ]

Disable auto-hibern8 during power mode transitions to prevent unintended
entry into auto-hibern8. Restore the original auto-hibern8 timer value
after completing the power mode change to maintain system stability and
prevent potential issues during power state transitions.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 53 +++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 003ca5ad88228..00ecfe14c1fd9 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1237,19 +1237,49 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	return ret;
 }
 
+static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
+{
+	int ret;
+
+	/* disable auto-hibern8 */
+	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
+
+	/* wait host return to idle state when auto-hibern8 off */
+	ufs_mtk_wait_idle_state(hba, 5);
+
+	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
+	if (ret) {
+		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
+
+		ufshcd_force_error_recovery(hba);
+
+		/* trigger error handler and break suspend */
+		ret = -EBUSY;
+	}
+
+	return ret;
+}
+
 static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
 				     enum ufs_notify_change_status stage,
 				     struct ufs_pa_layer_attr *dev_max_params,
 				     struct ufs_pa_layer_attr *dev_req_params)
 {
 	int ret = 0;
+	static u32 reg;
 
 	switch (stage) {
 	case PRE_CHANGE:
+		if (ufshcd_is_auto_hibern8_supported(hba)) {
+			reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
+			ufs_mtk_auto_hibern8_disable(hba);
+		}
 		ret = ufs_mtk_pre_pwr_change(hba, dev_max_params,
 					     dev_req_params);
 		break;
 	case POST_CHANGE:
+		if (ufshcd_is_auto_hibern8_supported(hba))
+			ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1483,29 +1513,6 @@ static void ufs_mtk_dev_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 	}
 }
 
-static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
-{
-	int ret;
-
-	/* disable auto-hibern8 */
-	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
-
-	/* wait host return to idle state when auto-hibern8 off */
-	ufs_mtk_wait_idle_state(hba, 5);
-
-	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
-	if (ret) {
-		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
-
-		ufshcd_force_error_recovery(hba);
-
-		/* trigger error handler and break suspend */
-		ret = -EBUSY;
-	}
-
-	return ret;
-}
-
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	enum ufs_notify_change_status status)
 {
-- 
2.51.0



