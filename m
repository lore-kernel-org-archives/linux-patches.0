Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44D72AE7F;
	Tue, 26 Aug 2025 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217083; cv=none; b=Z6P0+Scz8dUrCMeCGL42sxIsmNcAI2VunMJ6kmNA80ydvI3x+Rqtf/2Yz+Krmke6z3hWl24T0/489a621aD1zE6wlCAyt8mdrOO7TkGxkizNcFkyTfc2zYYkXGsgRnwFKQu7iRQO+Fex5G06JF/kdvukU+0j8tFl1CAx1QQqZPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217083; c=relaxed/simple;
	bh=4obc0n+8Ax21jeVcaicNxq0m7k6FzfFiaxqrjnhEESI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRvsI+4CsoOdesGAAZsNbuv7Ewxk0DyAIL9veMNe0GZCHiAYHrZZ6CJXJFrrXuGJcJ+Gp9xtuiHjb8Geoe/zahenBb2OYg6XZRAoS6pD29fkdrLLgdlijO4yAH+tOAyBb1pcl3Uqvju27ex5n7+fWD7mZD2nz9VcTPKrVp85USU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzEeBJAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzEeBJAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37377C4CEF1;
	Tue, 26 Aug 2025 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217083;
	bh=4obc0n+8Ax21jeVcaicNxq0m7k6FzfFiaxqrjnhEESI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzEeBJAz8A4K7h6ROxyVIuHzU2CxJ9hOmkwE6Mw73Zs0ouOm3qjKlLOfYMZd12ur1
	 Y6KcMiQdJh2fBlV9a4FnjWH9RfKQ5+fdpMWoEISuZwEHAsL2pV9qhAlQ/tfKYdHOav
	 cPL5C7ekeCWZYnQxFEyRvv4UrjMgNdf3WUjy1zLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+20537064367a0f98d597@syzkaller.appspotmail.com,
	Yuichiro Tsuji <yuichtsu@amazon.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 634/644] net: usb: asix_devices: Fix PHY address mask in MDIO bus initialization
Date: Tue, 26 Aug 2025 13:12:05 +0200
Message-ID: <20250826111002.270467178@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuichiro Tsuji <yuichtsu@amazon.com>

[ Upstream commit 24ef2f53c07f273bad99173e27ee88d44d135b1c ]

Syzbot reported shift-out-of-bounds exception on MDIO bus initialization.

The PHY address should be masked to 5 bits (0-31). Without this
mask, invalid PHY addresses could be used, potentially causing issues
with MDIO bus operations.

Fix this by masking the PHY address with 0x1f (31 decimal) to ensure
it stays within the valid range.

Fixes: 4faff70959d5 ("net: usb: asix_devices: add phy_mask for ax88772 mdio bus")
Reported-by: syzbot+20537064367a0f98d597@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=20537064367a0f98d597
Tested-by: syzbot+20537064367a0f98d597@syzkaller.appspotmail.com
Signed-off-by: Yuichiro Tsuji <yuichtsu@amazon.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250818084541.1958-1-yuichtsu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_devices.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 928516222959..97d2037e7fee 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -669,7 +669,7 @@ static int ax88772_init_mdio(struct usbnet *dev)
 	priv->mdio->read = &asix_mdio_bus_read;
 	priv->mdio->write = &asix_mdio_bus_write;
 	priv->mdio->name = "Asix MDIO Bus";
-	priv->mdio->phy_mask = ~(BIT(priv->phy_addr) | BIT(AX_EMBD_PHY_ADDR));
+	priv->mdio->phy_mask = ~(BIT(priv->phy_addr & 0x1f) | BIT(AX_EMBD_PHY_ADDR));
 	/* mii bus name is usb-<usb bus number>-<usb device number> */
 	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
 		 dev->udev->bus->busnum, dev->udev->devnum);
-- 
2.50.1



