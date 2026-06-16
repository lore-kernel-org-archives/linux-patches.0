Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F04643E490;
	Tue, 16 Jun 2026 15:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623005; cv=none; b=YSsBIe2YN8Yejkn8e5FPeo9hzUQN3i9oeFyKvbb6urbxg4A65sYVy8PqqkH5UPHG7pvYnHPc/Ku5DBqU6gY+F1DiULMrkjL4Bb/UDhi7PnDzKxPiB1fLyzS60LBhBiiyvAU8yKp20hSG4XmP4QV3HuyOANnaBtEHxhR9lYmfue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623005; c=relaxed/simple;
	bh=R8ec1Mo9qDHW5nNy2aiodomcBiww2zb0oay6rbvxwEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9kORjnkGNWRw5OLzxfLPJ1uYJw166BE0IHh5WnC1EvLGKulghZ2zpU88WxAzvpdjhsF+t3NBWzenjzr7M3QpoqPFOskyPKPT9Rh0r1na6CzCcDA3c525f9lmk1ArUcCo/0n0NY1crK5+1DRnQNEKehhDFGFfwRmx1dq+jFD/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BB4XCPRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BB4XCPRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6BE1F000E9;
	Tue, 16 Jun 2026 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623004;
	bh=YrpYdImqKOwe0xxcBQW6iihPAXtsknxL86w9oDmKb1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BB4XCPRViTbEYgKJG0NWk8bA/rS6nrTSa0LQUr1ANeicf0vWe+gCBEKBOvDXMJLWY
	 6SKRvT0OGhNEY+nF02rY+CZnUE9g86VK5oksuuzz127J7sy+qw9frsmfKR+67IwaOB
	 RU0/ftMycYk3JYQYr5e7EavV8Ww7TRsGm9W2AejU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Thangaraj Samynathan <Thangaraj.s@microchip.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 037/378] net: lan743x: permit VLAN-tagged packets up to configured MTU
Date: Tue, 16 Jun 2026 20:24:28 +0530
Message-ID: <20260616145111.838473102@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit 8173d22b211f615015f7b35f48ab11a6dd78dc99 ]

VLAN-tagged interfaces on lan743x devices were previously unreachable via
SSH and failed to respond to large ping packets (e.g. "ping -s 1469" given
MTU=1500). In these scenarios, "ethtool -S" reports non-zero "RX Oversize
Frame Errors". According to Microchip AN2948, the MAC_RX FSE (VLAN field
size enforcement) bit determines whether frames with VLAN tags exceeding
the base MTU plus tag length are discarded.

The driver must set the MAC_RX.FSE bit before setting MAC_RX.RXEN to allow
VLAN-tagged frames up to the interface MTU, preventing them from being
treated as oversized. As a result, both the base and VLAN-tagged interfaces
can use the same MTU without receive errors.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Thangaraj Samynathan <Thangaraj.s@microchip.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de> # lan7430 on arm64 (RevPi
Link: https://patch.msgid.link/20260529210300.433135-1-davthompson@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 32 +++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.h |  1 +
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f0b5dd752f084f..5af49b2b20245d 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1212,6 +1212,36 @@ static void lan743x_mac_set_address(struct lan743x_adapter *adapter,
 		   "MAC address set to %pM\n", addr);
 }
 
+static void lan743x_mac_rx_enable_fse(struct lan743x_adapter *adapter)
+{
+	u32 mac_rx;
+	bool rxen;
+
+	mac_rx = lan743x_csr_read(adapter, MAC_RX);
+	if (mac_rx & MAC_RX_FSE_)
+		return;
+
+	rxen = mac_rx & MAC_RX_RXEN_;
+	if (rxen) {
+		mac_rx &= ~MAC_RX_RXEN_;
+		lan743x_csr_write(adapter, MAC_RX, mac_rx);
+		lan743x_csr_wait_for_bit(adapter, MAC_RX, MAC_RX_RXD_,
+					 1, 1000, 20000, 100);
+	}
+
+	/* Per AN2948, hardware prevents modification of the FSE bit while the
+	 * MAC receiver is enabled (RXEN bit set). Use separate register write
+	 * to assert the FSE bit before enabling the RXEN bit in MAC_RX
+	 */
+	mac_rx |= MAC_RX_FSE_;
+	lan743x_csr_write(adapter, MAC_RX, mac_rx);
+
+	if (rxen) {
+		mac_rx |= MAC_RX_RXEN_;
+		lan743x_csr_write(adapter, MAC_RX, mac_rx);
+	}
+}
+
 static int lan743x_mac_init(struct lan743x_adapter *adapter)
 {
 	bool mac_address_valid = true;
@@ -1251,6 +1281,8 @@ static int lan743x_mac_init(struct lan743x_adapter *adapter)
 	lan743x_mac_set_address(adapter, adapter->mac_address);
 	eth_hw_addr_set(netdev, adapter->mac_address);
 
+	lan743x_mac_rx_enable_fse(adapter);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 02a28b7091630d..b977256b742061 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -181,6 +181,7 @@
 #define MAC_RX				(0x104)
 #define MAC_RX_MAX_SIZE_SHIFT_		(16)
 #define MAC_RX_MAX_SIZE_MASK_		(0x3FFF0000)
+#define MAC_RX_FSE_			BIT(2)
 #define MAC_RX_RXD_			BIT(1)
 #define MAC_RX_RXEN_			BIT(0)
 
-- 
2.53.0



