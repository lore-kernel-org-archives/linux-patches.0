Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A048449ED6;
	Tue, 16 Jun 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623010; cv=none; b=j8hdVMEDp2rKxaZuV6j7tMsAy2bHStjTI0FXVqs6Go3q53kXZO8KHjdANaKCPK5WewwExPeruY9/fEyOklefUBrHUuyQrBDjcE7Kt2pVds23khZ2cvH8iDCXY600J4sU3jpsHvlhbHkfcLfKkR5xNdIGCf5vAhmcxc/LnVjMhh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623010; c=relaxed/simple;
	bh=B0BA+DWuNnij3GPepFwzQlqBwvDWcrUGPlELGXPi4bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTVFYNArFx1APg5ITMp0OUTGQX83d5din2oTpJzPBRL3zIMmLFmL4XkJIlm2008eVn0EaFuBlhHuplqOCK7NDVITgPH87ZIk+6IsvXg+UTMQRhvsN/2slTJM86rvJkpdQ1QrtAP/0idtZ1k6za9jaiExhcqTO2eeK7bLPwI1WCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOPzgzQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOPzgzQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0821F000E9;
	Tue, 16 Jun 2026 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623009;
	bh=1SCUF0mcxVY9ftzZDpviuhvdNZsOcHqUvdKk4/dQQW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOPzgzQS1oe15HRxZE0QjvBnjV6hwNBVDL6vPTPhtBxD2/OpgWPA045+zdJ4Tef+4
	 pCHgvo3Yljnrck7ImiwobuIOTcG5q/QW8QegW7qdmoPqtizl8pXgnCNJBC7yoYEaIG
	 zl4H/d27rDiOFDCltWUI772f2K1BKqw/DD8V+MZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 038/378] net: fec: fix pinctrl default state restore order on resume
Date: Tue, 16 Jun 2026 20:24:29 +0530
Message-ID: <20260616145111.900316087@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit b455410146bf723c7ebcb49ecd5becc0d6611482 ]

In fec_resume(), fec_enet_clk_enable() is called before
pinctrl_pm_select_default_state() in the non-WoL path, inverting the
ordering used in fec_suspend() which correctly switches to the sleep
pinctrl state before disabling clocks.

For PHYs with the PHY_RST_AFTER_CLK_EN flag (e.g. TI DP83848 or
SMSC LAN87xx), fec_enet_clk_enable() triggers a hardware reset pulse
via the phy-reset GPIO. With the GPIO pin still in sleep pinctrl state
at that point, the GPIO write has no physical effect and the PHY never
receives the required reset after clock enable, leading to unreliable
link establishment after system resume.

Fix by restoring the default pinctrl state before enabling clocks,
making resume the proper mirror of suspend. The call is made
unconditionally: fec_suspend() only switches to the sleep pinctrl state
on the non-WoL path and leaves the pins in the default state when WoL
is enabled, so on a WoL resume the device is already in the default
state and pinctrl_pm_select_default_state() is a no-op.

Fixes: de40ed31b3c5 ("net: fec: add Wake-on-LAN support")
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260529-b4-fec-resume-pinctrl-order-v3-1-6eda0f592fca@vaisala.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f89aa94ce0202d..6ebde65d7f1b87 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -5594,6 +5594,7 @@ static int fec_resume(struct device *dev)
 		if (fep->rpm_active)
 			pm_runtime_force_resume(dev);
 
+		pinctrl_pm_select_default_state(&fep->pdev->dev);
 		ret = fec_enet_clk_enable(ndev, true);
 		if (ret) {
 			rtnl_unlock();
@@ -5610,8 +5611,6 @@ static int fec_resume(struct device *dev)
 			val &= ~(FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
 			writel(val, fep->hwp + FEC_ECNTRL);
 			fep->wol_flag &= ~FEC_WOL_FLAG_SLEEP_ON;
-		} else {
-			pinctrl_pm_select_default_state(&fep->pdev->dev);
 		}
 		fec_restart(ndev);
 		netif_tx_lock_bh(ndev);
-- 
2.53.0



