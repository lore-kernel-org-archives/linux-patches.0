Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7D1548C;
	Tue,  8 Jul 2025 16:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992417; cv=none; b=jo7M6kRErIq49RXKTJ7DiuWPcwMciXtgJn9hpciWa+VpTIFmce1EAm+/VSMHJIsJhFT+sQpG/Fpx+2hiJQ0nv8rGyUX0P3QlMAewFy9FWgH3sgGcC1FOflOBYxcFVZLR9uTo3HAntT52ccullwOJcYPcI9oU/U1KkVGQ6EzfUTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992417; c=relaxed/simple;
	bh=qeeztdyN5qEJEyP64RuO8o6gNtCPpPG7PZhv0ay5l/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3/iQwdEdudjgRPxXv+8R1SJygyVfNU69VqWseEdM+laidj4HCvCCO0CD02pjNES63U7Q0etchTGvj7a7J/netDiP0szCEGRwfZe+oozQG8vBIDRLrk7MKka7M23rKVf/uHkkAYet9lFGIBiO9e1UzDbuF50Mix2EGpO6FCaXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdvRtR3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdvRtR3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA38C4CEED;
	Tue,  8 Jul 2025 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992417;
	bh=qeeztdyN5qEJEyP64RuO8o6gNtCPpPG7PZhv0ay5l/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdvRtR3dwONG4gAmB+TgHp9E5lTYE/5GU2mlXOki8AZD2w1IiyfEXO/eyIKgRdY8s
	 YuvUYeWjxXC1xcdp3vTZgJiIdnllM+ksGCLoQQzLUVPah/VL7A8A8nXKTYj9MdNe53
	 3m0c4PCFU9nVQZ4wi42+2qtf2YGgS53PYsp0em84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/132] scsi: ufs: core: Fix abnormal scale up after last cmd finish
Date: Tue,  8 Jul 2025 18:23:08 +0200
Message-ID: <20250708162232.889925835@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 6fd53da45bbc834b9cfdf707d2f7ebe666667943 ]

When ufshcd_clk_scaling_suspend_work (thread A) running and new command
coming, ufshcd_clk_scaling_start_busy (thread B) may get host_lock after
thread A first time release host_lock. Then thread A second time get
host_lock will set clk_scaling.window_start_t = 0 which scale up clock
abnormal next polling_ms time.  Also inlines another
__ufshcd_suspend_clkscaling calls.

Below is racing step:
1	hba->clk_scaling.suspend_work (Thread A)
	ufshcd_clk_scaling_suspend_work
2		spin_lock_irqsave(hba->host->host_lock, irq_flags);
3		hba->clk_scaling.is_suspended = true;
4		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
		__ufshcd_suspend_clkscaling
7			spin_lock_irqsave(hba->host->host_lock, flags);
8			hba->clk_scaling.window_start_t = 0;
9			spin_unlock_irqrestore(hba->host->host_lock, flags);

	ufshcd_send_command (Thread B)
		ufshcd_clk_scaling_start_busy
5			spin_lock_irqsave(hba->host->host_lock, flags);
			....
6			spin_unlock_irqrestore(hba->host->host_lock, flags);

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20230831130826.5592-3-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 2e083cd80229 ("scsi: ufs: core: Fix clk scaling to be conditional in reset and restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 412931cf240f6..08c46fefb32b4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -289,7 +289,6 @@ static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba);
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba);
-static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba);
 static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
@@ -1377,9 +1376,10 @@ static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
 		return;
 	}
 	hba->clk_scaling.is_suspended = true;
+	hba->clk_scaling.window_start_t = 0;
 	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
-	__ufshcd_suspend_clkscaling(hba);
+	devfreq_suspend_device(hba->devfreq);
 }
 
 static void ufshcd_clk_scaling_resume_work(struct work_struct *work)
@@ -1556,16 +1556,6 @@ static void ufshcd_devfreq_remove(struct ufs_hba *hba)
 	dev_pm_opp_remove(hba->dev, clki->max_freq);
 }
 
-static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba)
-{
-	unsigned long flags;
-
-	devfreq_suspend_device(hba->devfreq);
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->clk_scaling.window_start_t = 0;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-}
-
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
 	unsigned long flags;
@@ -1578,11 +1568,12 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 	if (!hba->clk_scaling.is_suspended) {
 		suspend = true;
 		hba->clk_scaling.is_suspended = true;
+		hba->clk_scaling.window_start_t = 0;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (suspend)
-		__ufshcd_suspend_clkscaling(hba);
+		devfreq_suspend_device(hba->devfreq);
 }
 
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
-- 
2.39.5



