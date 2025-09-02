Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221533081A8;
	Tue,  2 Sep 2025 13:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819916; cv=none; b=RY+wUKziqIuTH+vi60Yx1Xc1sVOIKdP1M9plGrSm/8GB+yoGmbxHFrbCjaKofougzuq9lmQCR0S9hbgI9/AFuUDD98qJtOUe8hQ1dgwepJ8isMaXbQjI+2S/1rV3SIVtKJmORo7jqPWCV/tbbQDeHqCeUSvwsp8RmMAxnAGMGKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819916; c=relaxed/simple;
	bh=sBdpjXmQ1SEbyb1HDLwE8Kx4GpWzvBgTbHPriQihUck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiPlggmkwx4WzbTZ6ASyAaRrIXSsyFtsyIZinRDV9otMPfT9Qgdx7VcR6kwGJEOgZZ1bbr23dQWZ0Qg+4/rqqtv7gEIPvzfEeipjoFOvGX+a2BJIyvapqULGaibBgkq1e/Hs/yv7794NXi/KKmtReRoNrTFGVGapzoLZSMwIXfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQCTHmV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQCTHmV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934B1C4CEF5;
	Tue,  2 Sep 2025 13:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819916;
	bh=sBdpjXmQ1SEbyb1HDLwE8Kx4GpWzvBgTbHPriQihUck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQCTHmV4YTpe+DHnqVAarq6wtTipQY7+Bvbm0gLRaUIJWzASpf6l/cBUaLBEuhXDc
	 zia2ouy7fxDfhk183oniteugfDnmIIvtybOVoG03s5FTM/j4k+99OHfxW1KsY4cEqV
	 mPGJuBmbBQKyVa+mZPLDSqSwzy3bCmkLp+FCtu2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luoguangfei <15388634752@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 28/95] net: macb: fix unregister_netdev call order in macb_remove()
Date: Tue,  2 Sep 2025 15:20:04 +0200
Message-ID: <20250902131940.692435128@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: luoguangfei <15388634752@163.com>

[ Upstream commit 01b9128c5db1b470575d07b05b67ffa3cb02ebf1 ]

When removing a macb device, the driver calls phy_exit() before
unregister_netdev(). This leads to a WARN from kernfs:

  ------------[ cut here ]------------
  kernfs: can not remove 'attached_dev', no directory
  WARNING: CPU: 1 PID: 27146 at fs/kernfs/dir.c:1683
  Call trace:
    kernfs_remove_by_name_ns+0xd8/0xf0
    sysfs_remove_link+0x24/0x58
    phy_detach+0x5c/0x168
    phy_disconnect+0x4c/0x70
    phylink_disconnect_phy+0x6c/0xc0 [phylink]
    macb_close+0x6c/0x170 [macb]
    ...
    macb_remove+0x60/0x168 [macb]
    platform_remove+0x5c/0x80
    ...

The warning happens because the PHY is being exited while the netdev
is still registered. The correct order is to unregister the netdev
before shutting down the PHY and cleaning up the MDIO bus.

Fix this by moving unregister_netdev() ahead of phy_exit() in
macb_remove().

Fixes: 8b73fa3ae02b ("net: macb: Added ZynqMP-specific initialization")
Signed-off-by: luoguangfei <15388634752@163.com>
Link: https://patch.msgid.link/20250818232527.1316-1-15388634752@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 3c2a7919b1289..2421a7bcd221e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5225,11 +5225,11 @@ static void macb_remove(struct platform_device *pdev)
 
 	if (dev) {
 		bp = netdev_priv(dev);
+		unregister_netdev(dev);
 		phy_exit(bp->sgmii_phy);
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 
-		unregister_netdev(dev);
 		cancel_work_sync(&bp->hresp_err_bh_work);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.50.1



