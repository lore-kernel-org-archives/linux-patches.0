Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B78E34AB09;
	Tue, 11 Nov 2025 01:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823786; cv=none; b=tmzEfx41pQoPdpsx7+SdxZD++KFgSlkHvM1GXHMQHsuUpcUkVgu3sAI26rBFqOqORVH8BO3sHCGcgTj+zLrR1uozw/uHRlZM7e1quqLV+c/7x/VrGBnB4kEc/AmMwmRlx4jnevenHw0Qb0glLYD0pKrUWTLpJhzQ/69Yc1e+wO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823786; c=relaxed/simple;
	bh=2fiCxR0S7hOpHOPg9USi+qbb5TjXlsx/qJry76V2HVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iscz/9SsylQpAV7KRvh6Uuf+ZClOhVQ5ZsISQgjhTyA/GNigwv21v6ABocrq9j6kpaZ74VCj/t+zbBPKAI+Yl/+U6741KX5lHOB9F6fJJtoztVg6CQ3hN6ZRWhXOq5V/rNGLGCz+GUcZfByHyE3D/gmdAunU5QkoySMahew7EZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gy3DTyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gy3DTyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3603CC19421;
	Tue, 11 Nov 2025 01:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823786;
	bh=2fiCxR0S7hOpHOPg9USi+qbb5TjXlsx/qJry76V2HVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gy3DTywKRue/pMmJDR1N5KT18UnekyWIKcMxPRbyvMbPlYeIBPBGj7/e4ewnugQP
	 +0u9xeFirDDG1+KkNx894LFv/vIYtpaowp6IdYsA9XMlb5n2ckvun4+U14QH0bKvMm
	 AgX8m2thr2tCC/0CPvDpv6SqZiYIuxZmUfhIYgdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/565] scsi: ufs: host: mediatek: Enhance recovery on hibernation exit failure
Date: Tue, 11 Nov 2025 09:43:00 +0900
Message-ID: <20251111004534.173867039@linuxfoundation.org>
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

[ Upstream commit faac32d4ece30609f1a0930ca0ae951cf6dc1786 ]

Improve the recovery process for hibernation exit failures. Trigger the
error handler and break the suspend operation to ensure effective
recovery from hibernation errors. Activate the error handling mechanism
by ufshcd_force_error_recovery and scheduling the error handler work.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c       |  3 ++-
 drivers/ufs/host/ufs-mediatek.c | 14 +++++++++++---
 include/ufs/ufshcd.h            |  1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2d07902ce7f1b..d4dbb6769efa2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6374,13 +6374,14 @@ void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 	}
 }
 
-static void ufshcd_force_error_recovery(struct ufs_hba *hba)
+void ufshcd_force_error_recovery(struct ufs_hba *hba)
 {
 	spin_lock_irq(hba->host->host_lock);
 	hba->force_reset = true;
 	ufshcd_schedule_eh_work(hba);
 	spin_unlock_irq(hba->host->host_lock);
 }
+EXPORT_SYMBOL_GPL(ufshcd_force_error_recovery);
 
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 5cb3af17aec47..7c13bce03694f 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1483,7 +1483,7 @@ static void ufs_mtk_dev_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 	}
 }
 
-static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
+static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 {
 	int ret;
 
@@ -1494,8 +1494,16 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 	ufs_mtk_wait_idle_state(hba, 5);
 
 	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
-	if (ret)
+	if (ret) {
 		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
+
+		ufshcd_force_error_recovery(hba);
+
+		/* trigger error handler and break suspend */
+		ret = -EBUSY;
+	}
+
+	return ret;
 }
 
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
@@ -1506,7 +1514,7 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 	if (status == PRE_CHANGE) {
 		if (ufshcd_is_auto_hibern8_supported(hba))
-			ufs_mtk_auto_hibern8_disable(hba);
+			return ufs_mtk_auto_hibern8_disable(hba);
 		return 0;
 	}
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 47cba116f87b8..52ea0ab437fe0 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1487,5 +1487,6 @@ int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
 int ufshcd_write_ee_control(struct ufs_hba *hba);
 int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
 			     const u16 *other_mask, u16 set, u16 clr);
+void ufshcd_force_error_recovery(struct ufs_hba *hba);
 
 #endif /* End of Header */
-- 
2.51.0



