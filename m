Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F8644B69C;
	Tue, 16 Jun 2026 15:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624848; cv=none; b=C1oGloDKtY+spW93cuOZ4jMP8ZnwILFeiQ6WEhCB+rl9LtAcXfpbpAd8P50jDohZfoa6r+mHDR2cgzFokMt5WnODUBr5ZgeWhO3BC7lD5ZPSkt2a+AVJ+df3rUvzPYwooLcLjBYYAjO7IVRdj7/jsW0gGpsNt+MLTEcDTMWbEnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624848; c=relaxed/simple;
	bh=qP6hZLV/u6U5d0V5br6MJp4ZMcAyimaXV524ZEhUYlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+ij25DyiGDI0ZsvK2eINcmVhtGse7hTciTk8Qutwj77y8nw22rfsDqCOSWxTFmqX1NsqkVd9YWD4g+dWfSJHqf+rCrcNsG9rJP6W6Zk02EMLEbjPlJswlDbX4pCK95et5gxDOushOxjtkeGIydL1iRkd6umlEPgs2J9M9BN/2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+DwP2aS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+DwP2aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955841F000E9;
	Tue, 16 Jun 2026 15:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624846;
	bh=ES9tGKqNE/s+PCvMY0Y81bM8+9jFxXaXfDW6J6fylKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+DwP2aSVEDGkRXawgPzp5ocs034WqTxVD1YCkFVeL+6jzR+R3A/9FrYQchqfN8Rl
	 zz4Dt1U09/0ZwlmROpdWGhCyy24+fXDs2ckjERcVT1LSooI9SOlRHTWlXQht8Ieevz
	 nZjO+qS+0sBAwL6PMpr2gFutxBITN6CV5krEwGAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Thangaraj Samynathan <Thangaraj.s@microchip.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/325] net: lan743x: permit VLAN-tagged packets up to configured MTU
Date: Tue, 16 Jun 2026 20:27:14 +0530
Message-ID: <20260616145059.633404233@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 09d255e78f6cd1..ab2f3c92b3fa33 100644
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



