Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA68283FDF;
	Tue, 26 Aug 2025 11:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208924; cv=none; b=Ba9kF9BhqhWU4Rs+lJpcdUejC2zCoqUbOrXDXkGwdmFCAz52Bg3LeImTtyRNLhxW0SIxNzynhzH4R7+ZHkMinkIZMNvy4CPmL0UOln4H++IVpt+Ba76iSJNEOEtDlsMRSjGnYCSKyFf1WUxjgrVPb8hKR/pEJKptmb2Y5vRbXI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208924; c=relaxed/simple;
	bh=L6B7D6bk66U+m7tbzMdbJUUiH+cVc9pudzSyp7BFuKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJeTSJBEnktSHqBmZIaY+FCUA051vXokU7YF26+XQZhL3HJTDGyrDDuTH0vjfMFPanGvjVQfkBUUg5FMxnHB+jJ+sDXWqeuYt6J6PmSVdX3VtZXKfGMN3O6hAgIqH66Ak+TSDOa7M0pmpnhWakRfwIKGi/mIdrNH33gsfND5iys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJrhFnvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJrhFnvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAEBC4CEF1;
	Tue, 26 Aug 2025 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208924;
	bh=L6B7D6bk66U+m7tbzMdbJUUiH+cVc9pudzSyp7BFuKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJrhFnvFo0JRRIaz4mylqqbrAlL3dBY+Ei4xlxSRFDuK5OspmTGe3n4mO9LmucVnH
	 ktAKP7UpJQSxHX0NsXz37mJTiwPA/ME+CgzWDrS/PvfVhNw7mR+I4mjlmt6DTkVqFB
	 Tm0hKUZfkrYL6Fyk+uNi2P6np7gKVY9PDBGOqNpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+20537064367a0f98d597@syzkaller.appspotmail.com,
	Yuichiro Tsuji <yuichtsu@amazon.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/322] net: usb: asix_devices: Fix PHY address mask in MDIO bus initialization
Date: Tue, 26 Aug 2025 13:11:52 +0200
Message-ID: <20250826110923.234111373@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
index d9f5942ccc44..792ddda1ad49 100644
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



