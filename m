Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1234E1F667E;
	Tue,  3 Dec 2024 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236680; cv=none; b=EkNCAAPgN2kE1WQhh58RDUK7jtLXu547FBnQzfZ7TAtNE8YQ75mDWrkv8YQzgPUTiB2IuO+6JgF+Ga9CVbD2Rv005yZWv4IhYZ8QS7omlW3jZUpUaPvksyzfxy6yfgh+rbYidWm012Rv6S60JMkpKGmL1KpFC/ZGII550Nz19DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236680; c=relaxed/simple;
	bh=Ig6w6py4oJNxm9aJ4KXBY/GupHpcUerE0eeJS3J+3IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eyj1LAT9gk0okjR0qe0jmttMiTcbR3ZYB7ClcD9oFSN4JwRtDJ5f7ZY6LR1QS4kTLl/K4Jdb1F87bvWHMp1u27h0al1+vOegvy0Ae+AVYjgWWhpL1eECeEwGsCne8y/+OU0N5+ecZx+FS/AfGPYeCbh/Qg5nDjOJzNg527x1RiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSuI4cdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSuI4cdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88451C4CECF;
	Tue,  3 Dec 2024 14:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236679;
	bh=Ig6w6py4oJNxm9aJ4KXBY/GupHpcUerE0eeJS3J+3IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSuI4cdMnC7EEwdk0q8O6aj9PTiqCC3cuqv/KVsIYDmaRtvvjRiX1bbhmgdoxmp2T
	 kumMbXezUTB3YJxzy9clzAbUFC++hNh3NIly3uvpTwqEtLxs2sJn3EOWjGNJwpMLMc
	 NkJhKXnm/QRPge7Rh6c3AVo14qbjdpcS8ILLrQoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghuram Chary J <raghuramchary.jallipalli@microchip.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/138] net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device
Date: Tue,  3 Dec 2024 15:31:58 +0100
Message-ID: <20241203141926.972967200@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f56f45c924de0..de07d90038205 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2204,6 +2204,7 @@ static int lan78xx_phy_init(struct lan78xx_net *dev)
 		if (dev->chipid == ID_REV_CHIP_ID_7801_) {
 			if (phy_is_pseudo_fixed_link(phydev)) {
 				fixed_phy_unregister(phydev);
+				phy_device_free(phydev);
 			} else {
 				phy_unregister_fixup_for_uid(PHY_KSZ9031RNX,
 							     0xfffffff0);
@@ -3884,8 +3885,10 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 
 	phy_disconnect(net->phydev);
 
-	if (phy_is_pseudo_fixed_link(phydev))
+	if (phy_is_pseudo_fixed_link(phydev)) {
 		fixed_phy_unregister(phydev);
+		phy_device_free(phydev);
+	}
 
 	unregister_netdev(net);
 
-- 
2.43.0



