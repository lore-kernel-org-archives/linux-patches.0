Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D22F305E1B;
	Tue, 11 Nov 2025 01:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823297; cv=none; b=r1H6ahJX48tDPOeDZSgDF/54pHcMFXt96QPSnHBe3zDIIxtS54oziqZa0FbEWCRLQ5vqHtC+fhXE2Tw7lklY8JPIZNs6DaCDZCgMyDlm8/vp7bZmU0XJXeFbH0ZL5jV/zrjavbvumK6WAAIkxVwURgpF9h3NJZdwuiIIuYypi3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823297; c=relaxed/simple;
	bh=Gq5w1jT2h7Y4xc8tGju6YTuehHzu7Bjy2iLjTZRTwCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM2FkCXUPtpSerxt5VEjMU3ugjg0hMvXxH+ChT9xrcLgqF5/M0wYTkapoY+WjKCVS+WgxU60Zc8EHtfeOEj2k+SNNa2JT7V8+ILY5FH8414CTvUVOJjSlOvn7X7PRWon4LaW8DDVvb/HdOVtEuUeNPV0Q3jwPGvVPZdd14nXqbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4qLqglV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4qLqglV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658AFC4CEFB;
	Tue, 11 Nov 2025 01:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823296;
	bh=Gq5w1jT2h7Y4xc8tGju6YTuehHzu7Bjy2iLjTZRTwCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4qLqglVGXnGzewOfsHIU04VHOM24NxFwh+hBHZPjWrRZICqiQf7TTDzUziTTLDKx
	 wIVg26JqG4z/5KLDNOe9iH4gxp6/8n/V0pgky+u2p1ZosavhghmQjkdH+BxusllqGi
	 xt4TO2EA2evgQSWzRDs72+tWW7bPF8egimmAR2F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/565] scsi: ufs: host: mediatek: Fix auto-hibern8 timer configuration
Date: Tue, 11 Nov 2025 09:41:10 +0900
Message-ID: <20251111004531.737988798@linuxfoundation.org>
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

[ Upstream commit aa86602a483ba48f51044fbaefa1ebbf6da194a4 ]

Move the configuration of the Auto-Hibern8 (AHIT) timer from the
post-link stage to the 'fixup_dev_quirks' function. This change allows
setting the AHIT based on the vendor requirements:

   (a) Samsung: 3.5 ms
   (b) Micron: 2 ms
   (c) Others: 1 ms

Additionally, the clock gating timer is adjusted based on the AHIT
scale, with a maximum setting of 10 ms. This ensures that the clock
gating delay is appropriately configured to match the AHIT settings.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250811131423.3444014-3-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 86 ++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index c834d38921b6c..5841431d98543 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -916,6 +916,69 @@ static void ufs_mtk_vreg_fix_vccqx(struct ufs_hba *hba)
 	}
 }
 
+static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
+{
+	unsigned long flags;
+	u32 ah_ms = 10;
+	u32 ah_scale, ah_timer;
+	u32 scale_us[] = {1, 10, 100, 1000, 10000, 100000};
+
+	if (ufshcd_is_clkgating_allowed(hba)) {
+		if (ufshcd_is_auto_hibern8_supported(hba) && hba->ahit) {
+			ah_scale = FIELD_GET(UFSHCI_AHIBERN8_SCALE_MASK,
+					  hba->ahit);
+			ah_timer = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK,
+					  hba->ahit);
+			if (ah_scale <= 5)
+				ah_ms = ah_timer * scale_us[ah_scale] / 1000;
+		}
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->clk_gating.delay_ms = max(ah_ms, 10U);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
+}
+
+/* Convert microseconds to Auto-Hibernate Idle Timer register value */
+static u32 ufs_mtk_us_to_ahit(unsigned int timer)
+{
+	unsigned int scale;
+
+	for (scale = 0; timer > UFSHCI_AHIBERN8_TIMER_MASK; ++scale)
+		timer /= UFSHCI_AHIBERN8_SCALE_FACTOR;
+
+	return FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, timer) |
+	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale);
+}
+
+static void ufs_mtk_fix_ahit(struct ufs_hba *hba)
+{
+	unsigned int us;
+
+	if (ufshcd_is_auto_hibern8_supported(hba)) {
+		switch (hba->dev_info.wmanufacturerid) {
+		case UFS_VENDOR_SAMSUNG:
+			/* configure auto-hibern8 timer to 3.5 ms */
+			us = 3500;
+			break;
+
+		case UFS_VENDOR_MICRON:
+			/* configure auto-hibern8 timer to 2 ms */
+			us = 2000;
+			break;
+
+		default:
+			/* configure auto-hibern8 timer to 1 ms */
+			us = 1000;
+			break;
+		}
+
+		hba->ahit = ufs_mtk_us_to_ahit(us);
+	}
+
+	ufs_mtk_setup_clk_gating(hba);
+}
+
 static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -1206,32 +1269,10 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
 
 	return ret;
 }
-
-static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
-{
-	u32 ah_ms;
-
-	if (ufshcd_is_clkgating_allowed(hba)) {
-		if (ufshcd_is_auto_hibern8_supported(hba) && hba->ahit)
-			ah_ms = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK,
-					  hba->ahit);
-		else
-			ah_ms = 10;
-		ufshcd_clkgate_delay_set(hba->dev, ah_ms + 5);
-	}
-}
-
 static void ufs_mtk_post_link(struct ufs_hba *hba)
 {
 	/* enable unipro clock gating feature */
 	ufs_mtk_cfg_unipro_cg(hba, true);
-
-	/* will be configured during probe hba */
-	if (ufshcd_is_auto_hibern8_supported(hba))
-		hba->ahit = FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, 10) |
-			FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
-
-	ufs_mtk_setup_clk_gating(hba);
 }
 
 static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
@@ -1556,6 +1597,7 @@ static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 
 	ufs_mtk_vreg_fix_vcc(hba);
 	ufs_mtk_vreg_fix_vccqx(hba);
+	ufs_mtk_fix_ahit(hba);
 }
 
 static void ufs_mtk_event_notify(struct ufs_hba *hba,
-- 
2.51.0



