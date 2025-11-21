Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F1E3502A0;
	Fri, 21 Nov 2025 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732782; cv=none; b=i0nx/mfcHjRhFtMoxaXe3/X4WKflszJnG7Faz0jJYEjWhL/Pl1RtykcrB1qMfzBzxVtZZNi29kgN2LeFNwcOPUbm9tYNTpgNiFRvNR53Uno8ds7CYS//Fj0aVbXK5cDDDKRDckVRMKgE4kkPp1PCPP1OKaM6pbCcX/wRDTTMre8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732782; c=relaxed/simple;
	bh=/PRnH78pWoPiYVxd7iw3rxLHA73o+j+qglixzveNsgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAz7Z5WQ3oo9b213SQv8nhjCovlqkz4KmYHVSwsH7hWaewlr+veD/bOkdlzmi6zaK4qYO7usbdPcVCT2zEcVthPCCVEc9onb61K8YwEHwvhNL2QmdJcsoK0+txhYhE30ECCtEdK2DwhYHRu2rDQ1aShHr8FyJK2Gmr4Cc2zhD0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEN7A27N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEN7A27N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005E1C4CEFB;
	Fri, 21 Nov 2025 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732782;
	bh=/PRnH78pWoPiYVxd7iw3rxLHA73o+j+qglixzveNsgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEN7A27NoIDZXLlA4epRLhNt7uTk6iGarG1EnACGElWNdCCVTpb09r1M7ZgMWA59I
	 KeLM98WdD+00RbDOJjFV0Zw/0L8vfvyRulXh3HjPEnkN58jxeVVXpMwY+i0an2c5/m
	 BVM0Vd6wFAzlTxQ9Scy72LlU0KIetaMM9QqVhwXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/529] scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes
Date: Fri, 21 Nov 2025 14:08:27 +0100
Message-ID: <20251121130238.418736815@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c80780ade5aa5..8b4a3cc812531 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1131,19 +1131,49 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
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
@@ -1363,29 +1393,6 @@ static void ufs_mtk_dev_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
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



