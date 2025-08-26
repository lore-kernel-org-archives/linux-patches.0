Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A3C3093BA;
	Tue, 26 Aug 2025 11:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208037; cv=none; b=bS8efrveqzdicnVbE/posYIMO468Ru5bGPf07+BcEaH7ODDK2ASoL1eg/t8j5es1I2Ay09Pt8o6Wi3rorYTX5cW8Rho4xim9NjBeyjgFWi1DzhSybcqef5f2YGY3/pVtI0l1yia/e+KPW6ES4A25zpjiTexiOLndtihFHUg/KwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208037; c=relaxed/simple;
	bh=4imxUJW9eJ8MNCn8BIyRbfPNRwsyu5DIEExJoQH0yJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPUJkYk4nmpRQpPJghpoUBpNH3SL8Qz8Qh4V0hp4vVgvAnck42QM7+kYHvJo1SqEvun8CCzh3UBvugGwpErdp7583ZrlVyQKRZxlYEqmRfM9HYRlEobfoBKmICdXynr8aSNy/HEmbTIqfDu8AEJPDDeJA4aqKa3Tn3TlODwO7pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuUHqxEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuUHqxEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67637C4CEF4;
	Tue, 26 Aug 2025 11:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208037;
	bh=4imxUJW9eJ8MNCn8BIyRbfPNRwsyu5DIEExJoQH0yJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuUHqxEfq8+MDMrxC5au0WSiySGv/2KhfDQcakzpDn+fdNwsO7saEZV0R002QLADL
	 X1A6vJAnLHDEskYSoffGeUCfXB2KlqFn5QZP+UCaGy4NmiTWHm2Th5NuPlEypcVodU
	 AnFcpuWdigIspHxeqT4vKIsvqW0NvLlr+IR2C9wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+20537064367a0f98d597@syzkaller.appspotmail.com,
	Yuichiro Tsuji <yuichtsu@amazon.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 412/457] net: usb: asix_devices: Fix PHY address mask in MDIO bus initialization
Date: Tue, 26 Aug 2025 13:11:36 +0200
Message-ID: <20250826110947.476612272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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



