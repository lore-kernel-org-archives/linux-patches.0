Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A25F6F2FE;
	Thu, 12 Dec 2024 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025311; cv=none; b=s2p+Rc1j0/s26tr3l60nX4oxlQEL8ixzR/XdWBFPAR9DSfvN/9FFEwVdo36DnyzF2M5w9Fze65HLCVVlZZ3aK15iBrn4Na8Qy+iTa/Tukv1moPVkDWNcAnkY6qbAdZ82GUfn0v9tBXvs9NfIM+5uS5R8Slfu8SD1VirARqCpbzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025311; c=relaxed/simple;
	bh=nEJymkZUE5X1oq9AJIJwFMU+LTvQmoMlUMrnzDu3joU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LikNa58Fr8Ckrx/nC/zhOKI9/tygm2+E/20uO75YRCbJs3TXFpii4OxyFSto4De89t9GVefGXLARydzPFDlDqwdM75qNKA8u9ia+xJGjw9rlnDr7DDSxmbAsup/rrxSpO5BCn0X+Dj9HRIFB6qXT7UwM8LpZB8/k7lO1PkSAQ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLmvHYUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLmvHYUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC3FC4CED0;
	Thu, 12 Dec 2024 17:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025311;
	bh=nEJymkZUE5X1oq9AJIJwFMU+LTvQmoMlUMrnzDu3joU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLmvHYUhOaMSU+2sED11bs22O7H8Powa4WH6GPA5cc8soMOdORFK1g5p6u6k250Py
	 PoAVD5Q29L5gUBsAYR6ujuAJzwsKAppEkot6Pe20IQBNp6zx1JbZct1tGuyMwmIBxb
	 0aDqQa1ckfhtpMkicgRc3hw0pk02t/YbHFxKEWKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghuram Chary J <raghuramchary.jallipalli@microchip.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/321] net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device
Date: Thu, 12 Dec 2024 16:00:45 +0100
Message-ID: <20241212144234.992077221@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit ae7370e61c5d8f5bcefc2d4fca724bd4e9bbf789 ]

Add calls to `phy_device_free` after `fixed_phy_unregister` to fix a
memory leak that occurs when the device is unplugged. This ensures
proper cleanup of pseudo fixed-link PHYs.

Fixes: 89b36fb5e532 ("lan78xx: Lan7801 Support for Fixed PHY")
Cc: Raghuram Chary J <raghuramchary.jallipalli@microchip.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20241116130558.1352230-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index b0efaf56d78f3..0ca3ffeb4983c 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2165,6 +2165,7 @@ static int lan78xx_phy_init(struct lan78xx_net *dev)
 		if (dev->chipid == ID_REV_CHIP_ID_7801_) {
 			if (phy_is_pseudo_fixed_link(phydev)) {
 				fixed_phy_unregister(phydev);
+				phy_device_free(phydev);
 			} else {
 				phy_unregister_fixup_for_uid(PHY_KSZ9031RNX,
 							     0xfffffff0);
@@ -3843,8 +3844,10 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 
 	phy_disconnect(net->phydev);
 
-	if (phy_is_pseudo_fixed_link(phydev))
+	if (phy_is_pseudo_fixed_link(phydev)) {
 		fixed_phy_unregister(phydev);
+		phy_device_free(phydev);
+	}
 
 	unregister_netdev(net);
 
-- 
2.43.0



