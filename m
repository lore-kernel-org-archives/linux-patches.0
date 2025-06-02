Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C24C231A4D;
	Mon,  2 Jun 2025 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876315; cv=none; b=HaFU2AVABVcvZyFqUioueKkJ8JiiQH+P3GGvk+A2tLRnHne/bnz1rK5/EC3yj/qyC4thPahKdFvgPiv1BMO1VEfr0Hxj61mT4++6mprqSbdknF08P6i4X3OZ0HxE1T0XzLNYm2CFiBs6s/p6E1XoBvow7qEcq0SEA8949qD9cnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876315; c=relaxed/simple;
	bh=J+NPXfEMCUSd4H35pAGiH1AyTw1USeQifUQivPkzMlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHVd/3qiXlPjBnem3jbgCqvrII2yvO905D2VIjVEIwmkITKBy2Mb+gK6vkCXEQU9C7eMxMB1iWUpJL+tGY7QmLIgIiamc+oW+B/kWLdYRDrmzk3qnx889gB9jlscTmY/P2P+bVOd50UjZYv7p4rrsryHRipv+W2dh323st4FTFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHkFh69g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHkFh69g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A32C4CEEB;
	Mon,  2 Jun 2025 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876315;
	bh=J+NPXfEMCUSd4H35pAGiH1AyTw1USeQifUQivPkzMlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHkFh69gXe1jzvicd0V6wnkTLk1al2ZF6a2hKzIux0a0f7Nmqlxx8pSnHn+hf1zCo
	 ewDGHLRL4t3Q3LbDjSODOeLgTNpzK5nRmbfTuvDXHBhdVOFgGHqYLJgenF/0lr2PF8
	 dqErYepCxQWCPedN6ucCNB88patrkSYRqxOTC1xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/207] r8169: dont scan PHY addresses > 0
Date: Mon,  2 Jun 2025 15:48:30 +0200
Message-ID: <20250602134304.131363299@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit faac69a4ae5abb49e62c79c66b51bb905c9aa5ec ]

The PHY address is a dummy, because r8169 PHY access registers
don't support a PHY address. Therefore scan address 0 only.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/830637dd-4016-4a68-92b3-618fcac6589d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d9d19ea77d20b..1ea30c9b8c07c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5185,6 +5185,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
 	new_bus->irq[0] = PHY_MAC_INTERRUPT;
+	new_bus->phy_mask = GENMASK(31, 1);
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
 		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
 
-- 
2.39.5



