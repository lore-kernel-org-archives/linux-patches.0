Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D55C354AFA;
	Wed,  3 Dec 2025 17:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781218; cv=none; b=fF3gST3TfG7AgjuwrpENl2jOFeKKnI2DASVj2oV0ii1191JYdBYh13wwJbNPNIaH/7Ru9u87PmMo2oCaxFeiUA3jgSkFIM4TWcN+7u2lbKDcv/rSWqX25TlIe5r9zaiUcL61PJWYSnlxQUZOy7aBxUqVRzecz8N5smIuKXHD3Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781218; c=relaxed/simple;
	bh=Uem9KKCDTSsWIafV+PPEN04Qj8OXqqr7ILJKORFrE1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUkUhiMURyo73LiCp9/JZfOg6lzPmtpA7iTKVzswGolhFJGMQn26z0W2072+wvJuznm7bfHIkL4mfb313D5CBsBLXmHknQU6v4Swi2FDzkRTv6kN25LKDj9AygiVfKb7UUvjseJJFx/k6EU7Afvw6HyquDNDC5LXhZrNMj0xUCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1ma0YYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1ma0YYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4F6C4CEF5;
	Wed,  3 Dec 2025 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781218;
	bh=Uem9KKCDTSsWIafV+PPEN04Qj8OXqqr7ILJKORFrE1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1ma0YYqirTgO90phfUJCN0rxfL6i7t8Xa396pvx1p0k0CrXX1hSF/HMjKH2cdZsw
	 2KyDvva9GQQeV+FFqcHfraK2sofCnJndw4AF4wyPdmmf0MRzcOw/natyfFtf/ymzzY
	 FYvHbevlPZM7iXKBCAeMegrFWG2p+vMOu3FlGm8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luoguangfei <15388634752@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.6 86/93] net: macb: fix unregister_netdev call order in macb_remove()
Date: Wed,  3 Dec 2025 16:30:19 +0100
Message-ID: <20251203152339.704306564@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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
[ Minor context change fixed. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5182,11 +5182,11 @@ static int macb_remove(struct platform_d
 
 	if (dev) {
 		bp = netdev_priv(dev);
+		unregister_netdev(dev);
 		phy_exit(bp->sgmii_phy);
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 
-		unregister_netdev(dev);
 		tasklet_kill(&bp->hresp_err_tasklet);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_dont_use_autosuspend(&pdev->dev);


