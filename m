Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDAF3148CD;
	Wed,  3 Dec 2025 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780441; cv=none; b=VsM4K24NmhcStP+yU6lpdGsGTgTGAl6ZkAGu+c55hKkxs6yoGzlOf9IYxBGoJ3ZZfXqr7hRiRcl592ntksIV0+dOEMStptchYMJHWuZxPXeDkW+0Dh5HAAhO3ZZCj4+yAexttElWi1VITGge8+o7TD9mtZdwgvRwONC26WSn9t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780441; c=relaxed/simple;
	bh=0zIsfJYS5H106uPBc5DYfFjxElJZtT0iwjMzvtZoAm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdiIkrMe5PmaapdFifJcGLKeSQP39QvZbyNG/ibb3MioVWqkmhVHt93y4fpTRk4dPzOIprmLv+bzhuRkBWAjlBvmC71fj6MB4vYpQbHqGOGKaBAp8KDJz15C2Al0n5PomT3+jrPc0jxs9RrezGdZJugTh/K3uhhMH/aDysYRZo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkvL4vYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkvL4vYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1B6C4CEF5;
	Wed,  3 Dec 2025 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780441;
	bh=0zIsfJYS5H106uPBc5DYfFjxElJZtT0iwjMzvtZoAm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkvL4vYZeeJX/kkECjgTy9+uYFtiRtljrW9/bfK8qUWByKkq+0GkHZ9l4Jg8Urr2r
	 nZACYRLA58YGiUwzfl4jP7V6+aVhhIVfEG/6nJYWAcTMAHlYstKrLoZAhxrUUwYGb0
	 PChyAcX+FCGsg03iZ6cE8MEeSo3tsmhcOShrLup0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luoguangfei <15388634752@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 557/568] net: macb: fix unregister_netdev call order in macb_remove()
Date: Wed,  3 Dec 2025 16:29:19 +0100
Message-ID: <20251203152501.110165942@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5068,11 +5068,11 @@ static int macb_remove(struct platform_d
 
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


