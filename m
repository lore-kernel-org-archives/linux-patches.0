Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B670130BB8D;
	Tue,  2 Sep 2025 13:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819473; cv=none; b=Rbqqh4C9Jps62sKoUxxXiap9mXKibVJAJ5bUqTwrJzo50G2PGodV+R7ymotZEOTHO2Us5jTnAStv6ZIhCZF+EJILbfob2v1NO5ndVHuWCEzqgRYdB70FgEhixtrBeXPnLsXR8ndME5evCWbR2kY76t+eAgDyMODMgq/s5nmFPgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819473; c=relaxed/simple;
	bh=ZOom7z84AaWkYZ5nL7w724IMa+vAFTRaeWr3jjZg8qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geqhlbl6W0uRSUTvqK9J2/gz96bfJEJYdMBpDifm3yMnIHsXngWvWfRTqpYrl39dqTIZGz9A0gUp84+HnOLXRwUQqYmk7y9PPlZ+Tq1Rh4ggZnYRh9HxqLDHIF/2R470fVG59vvldzMvCKDHtckTEUL7ywi7Ysk7o27Oa1+H4zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0ca1OJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0ca1OJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3048C4CEED;
	Tue,  2 Sep 2025 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819473;
	bh=ZOom7z84AaWkYZ5nL7w724IMa+vAFTRaeWr3jjZg8qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0ca1OJwvlqtGuPyQdisN1y5YksYDmysnxAVzTUFxE8Kmk3N6EWrljccbxxmThMlx
	 31SwZcJoBEgvqa8jrH2qLEdZ1pJ8fEqJTzv9dS2/WgY2224XqMuxl3+oTNh7uXI78a
	 bX8WniN5Luzu/5fXKHVNP8Dw0f8SUr1A4UsXxFAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luoguangfei <15388634752@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 045/142] net: macb: fix unregister_netdev call order in macb_remove()
Date: Tue,  2 Sep 2025 15:19:07 +0200
Message-ID: <20250902131949.980613714@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d1f1ae5ea161c..c1e904e4a01f4 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5391,11 +5391,11 @@ static void macb_remove(struct platform_device *pdev)
 
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



