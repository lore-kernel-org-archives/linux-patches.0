Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAF634DB64;
	Fri, 21 Nov 2025 13:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732759; cv=none; b=eVFBJVIFb1WWQqfaL7jlN8H6NsQrwHf4Xzckm9ilKW9Ho0iRu+9msmBM25mXtk3jfRz8Qy4XFD5+YQNDK5OKpYGGvthNQStUdoQSZvqY/3BOgDQ3rruJ3MzZNVdb9npZLagIxug0sqWNHGhTH+6EuY5ttm8m0+KuVGH3zHVrZh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732759; c=relaxed/simple;
	bh=lqQpN0WGg4mzrBFoaBZitWCJTLHUgg+OZiUa0v6nJtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3vrn+IagE49LgVf0q3izEKE6Zd2lJbFUp78pzuZ5xdFVb4oaNnVkh+W3GUCTRI8nkh2rXVIj9v6ljO5eANgDv+HFfdXOmTp47XVxNu66C/aKC8R9KwId/Qu1EOB0E0UmprfXcsRzVxHoQT2LOTB9s3IELTu8AnS+eluBUP1RJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlzAXgZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlzAXgZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3411C4CEFB;
	Fri, 21 Nov 2025 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732759;
	bh=lqQpN0WGg4mzrBFoaBZitWCJTLHUgg+OZiUa0v6nJtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlzAXgZIARnmY/dzdezGrBlpjkkuR5RucuZQA9NjYyb87VUPJV/li9D93WNaZc7of
	 ME7yq7lj7nntdhrSmWM96bSyFEBV5bD+kvqaEVCjjC719/ZeCVL2BHUrXW6AP2Mwct
	 teonxOg95dZQRv94Fz39fLrgfkmjGWNG2Vjglp/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/529] scsi: ufs: host: mediatek: Enhance recovery on hibernation exit failure
Date: Fri, 21 Nov 2025 14:08:25 +0100
Message-ID: <20251121130238.347673232@linuxfoundation.org>
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
index 2080b251580c8..1e08bf4dfb034 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6341,13 +6341,14 @@ void ufshcd_schedule_eh_work(struct ufs_hba *hba)
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
index 6f2e5b83ff0c9..c80780ade5aa5 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1363,7 +1363,7 @@ static void ufs_mtk_dev_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 	}
 }
 
-static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
+static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 {
 	int ret;
 
@@ -1374,8 +1374,16 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
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
@@ -1386,7 +1394,7 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 	if (status == PRE_CHANGE) {
 		if (ufshcd_is_auto_hibern8_supported(hba))
-			ufs_mtk_auto_hibern8_disable(hba);
+			return ufs_mtk_auto_hibern8_disable(hba);
 		return 0;
 	}
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e9db9682316a2..9eaf47dcc7277 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1425,5 +1425,6 @@ int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
 int ufshcd_write_ee_control(struct ufs_hba *hba);
 int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
 			     const u16 *other_mask, u16 set, u16 clr);
+void ufshcd_force_error_recovery(struct ufs_hba *hba);
 
 #endif /* End of Header */
-- 
2.51.0



