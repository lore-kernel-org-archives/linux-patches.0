Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B53305688;
	Tue, 16 Jun 2026 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629143; cv=none; b=dwd36c6ULdlcRVEw9WM3f8y2An8WNkcJdaU3as6unOTSO1g0Tpk4/cS0yZshQvq6131jCeEgMsnCL0suKeoYyrrOoDthbg1ulp//0w+vShdWxZoNR07qEM8a4+v8578MIykp+hF/no/6NiIlIl4OWeUUGzNar/W9XORPp0sR9Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629143; c=relaxed/simple;
	bh=dcoQIG/ggJdyheuC9YF8rGWGVUogiWVtD3nruFYv62Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/qR70CbOM5PUOA+xs/Sut6hV9UYsb0f1cexChOJ6FmYtRAVoa1t/ifuajBQlsA02DMiKhWpc6rdnu7JusAXxE86cESMnI8IoR8kykj89NAXxnSGqB2BC4PBm2fDyzv0ZkacmijT0tZmZB6lb7FdGbUnFsKkOmYSvJNvXH/8J7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFmamray; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFmamray"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A4A1F000E9;
	Tue, 16 Jun 2026 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629142;
	bh=f4w7JFAHS9CSE+/hNlvkMf2HTZWK24WvBRtMyF/Sg0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFmamrayMKXoFMmeSUfuAzz1TRTVqL3BhSspEF+Oic2NReLTKVVDI57RjZULy//r7
	 C0nf3mEciIgK5N8K/h6xgwJpyMYj31Msln5txSCIXothwPXfphti9uOJ4I82RVEe/i
	 zQOShmCyig/hex163kMlody1kVGpk3cQzclb8Mj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/452] net: fec: fix pinctrl default state restore order on resume
Date: Tue, 16 Jun 2026 20:27:37 +0530
Message-ID: <20260616145129.806271242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
index 7efe4e81cf320b..49297b83c3fdb8 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4734,6 +4734,7 @@ static int __maybe_unused fec_resume(struct device *dev)
 		if (fep->rpm_active)
 			pm_runtime_force_resume(dev);
 
+		pinctrl_pm_select_default_state(&fep->pdev->dev);
 		ret = fec_enet_clk_enable(ndev, true);
 		if (ret) {
 			rtnl_unlock();
@@ -4750,8 +4751,6 @@ static int __maybe_unused fec_resume(struct device *dev)
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



