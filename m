Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7993446CC;
	Tue, 11 Nov 2025 01:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823606; cv=none; b=RPAx4uE3bgJgBtcikmWRTwUa9bZP8Iecs/UceWtn7EZ4hMJPE1PUuD7f87MTiZ05FnRkG7hyKaaJGjOT5fyY8hCyCXN5f5uxZxT9lUV+/41E/gZJdnE1h4uMyED8o5tk/RGAYicchBRzzaDtPRX3Hi9ZrJ4MxoGdRyPcKhlUfUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823606; c=relaxed/simple;
	bh=+a7eMMrqJQU1HjCsCtQT5wt3gbNvxtBrgl9A9q5rfPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbW6Yf8LHOrsRQZYhHWwYCqoa7OKUjdZ7PAndAYcDbZs49lc3IHDcHb6WsyHFyLidlKOFwWTMmLe+TD36DVpmGfxwx4JHyWzPlg/NJOPcRVK+Q5Ol+GvUdnDztXN2+jBmRCqM1EcNJnIOJztFueleUswqrF1V5oKwLKS6E/VEwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFwNfd+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFwNfd+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11AFC19425;
	Tue, 11 Nov 2025 01:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823606;
	bh=+a7eMMrqJQU1HjCsCtQT5wt3gbNvxtBrgl9A9q5rfPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFwNfd+55EIE2W3UMNXlmJE5vfoS6lP0EsyheO75VXbSLJACS66KJceISLbVLjrcr
	 vBMwIjla3SPlCOo8dz4/2Mh8eJscKIZSIbWaMA6CPjqYB1qFjpb2TP8mFogg7QJWtK
	 D7F3DPJ9B2CT0yabJBHHFqveRTByjbp75kx9n5f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/565] microchip: lan865x: add ndo_eth_ioctl handler to enable PHY ioctl support
Date: Tue, 11 Nov 2025 09:42:11 +0900
Message-ID: <20251111004533.070311691@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>

[ Upstream commit 34c21e91192aa1ff66f9d6cef8132717840d04e6 ]

Introduce support for standard MII ioctl operations in the LAN865x
Ethernet driver by implementing the .ndo_eth_ioctl callback. This allows
PHY-related ioctl commands to be handled via phy_do_ioctl_running() and
enables support for ethtool and other user-space tools that rely on ioctl
interface to perform PHY register access using commands like SIOCGMIIREG
and SIOCSMIIREG.

This feature enables improved diagnostics and PHY configuration
capabilities from userspace.

Signed-off-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250828114549.46116-1-parthiban.veerasooran@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan865x/lan865x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/lan865x/lan865x.c b/drivers/net/ethernet/microchip/lan865x/lan865x.c
index 79b800d2b72c2..b428ad6516c5e 100644
--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -326,6 +326,7 @@ static const struct net_device_ops lan865x_netdev_ops = {
 	.ndo_start_xmit		= lan865x_send_packet,
 	.ndo_set_rx_mode	= lan865x_set_multicast_list,
 	.ndo_set_mac_address	= lan865x_set_mac_address,
+	.ndo_eth_ioctl          = phy_do_ioctl_running,
 };
 
 static int lan865x_probe(struct spi_device *spi)
-- 
2.51.0



