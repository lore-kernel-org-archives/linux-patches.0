Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118B91B87E8;
	Tue, 26 Aug 2025 13:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215323; cv=none; b=ayiR2S8g+wJ4Qb7BjxqDnAnavSq4+MqF9vr1gkh7h2KTcqBlFbL6LedniL5M+CnycsDbVlfjEiVARMqJ+JG/dFwypNOnPBNT9gBtrKeol4ER9eVgfkfKnKrmcW4UIyNVcgEduJg2WlEt3o7+NShLbHhrNODrq38rULN6U4PWnqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215323; c=relaxed/simple;
	bh=IiKagfN8NVAMMa5w4h6ZI61LDBW0xHwq/oM92UJ7vG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6/QacPukSCGi5DuDlgXY/bHes494/y+PXQYrScoSidAionRqq/+TLBgw/0lgUrZPVq0bR5RQ3Acsbm2BNQdBtc2+06aDaPEOpFTO9OA909BzFPp3V5mQS7YhIrdp0CwSPa+oQ/pk0OaPbsBpGjvkkWnz79Zy4fy9/qqmVrV05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJuKbPsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJuKbPsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40842C4CEF1;
	Tue, 26 Aug 2025 13:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215322;
	bh=IiKagfN8NVAMMa5w4h6ZI61LDBW0xHwq/oM92UJ7vG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJuKbPsYutHrabBJ/a0XaO8tkuspWnWLY8+12hZPXNiTBb5NjvuvxhwK9wiSCWGSy
	 ENv7jS6Pm9ZUWuYtMlfcvCf+c90U7nr5v9InKHFuxSiJ5BvMi1Pm/wVxf09ugvpwkl
	 Vxl56ieLVxNCgWMkyC6FUlNE9amHvtz3v1Jh5oNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+20537064367a0f98d597@syzkaller.appspotmail.com,
	Yuichiro Tsuji <yuichtsu@amazon.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 470/482] net: usb: asix_devices: Fix PHY address mask in MDIO bus initialization
Date: Tue, 26 Aug 2025 13:12:03 +0200
Message-ID: <20250826110942.432117878@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d1813a2495bc..021f38c25be8 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -676,7 +676,7 @@ static int ax88772_init_mdio(struct usbnet *dev)
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



