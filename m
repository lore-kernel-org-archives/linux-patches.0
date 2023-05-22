Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786FF168B6
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0910BC433D2;
	Mon, 22 May 2023 19:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782815;
	bh=WE3S4k8vAoSvg4gH8fUmKuHgmJOmmDkulK7laQR9/Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwzBl0IYytfjAde042Ahdt6ue1RCtuucqH5+dAAamOMNSPGhsPToJ0GzSmEBINhjZ
	 ybZ5T856mCbReFoXQZ4YN1nN38P8iTLp/sSiZ6uJQ75pjzJQCm6G7os/tkZexav4Pb
	 Xg1FkeJ0WPzYcoA9n2rWaK53C3E8sP+zwLgTJIoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Harald Seiler <hws@denx.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/203] net: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register
Date: Mon, 22 May 2023 20:07:12 +0100
Message-Id: <20230522190355.181372324@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 8efbdbfa99381a017dd2c0f6375a7d80a8118b74 ]

Initialize MAC_ONEUS_TIC_COUNTER register with correct value derived
from CSR clock, otherwise EEE is unstable on at least NXP i.MX8M Plus
and Micrel KSZ9131RNX PHY, to the point where not even ARP request can
be sent out.

i.MX 8M Plus Applications Processor Reference Manual, Rev. 1, 06/2021
11.7.6.1.34 One-microsecond Reference Timer (MAC_ONEUS_TIC_COUNTER)
defines this register as:
"
This register controls the generation of the Reference time (1 microsecond
tic) for all the LPI timers. This timer has to be programmed by the software
initially.
...
The application must program this counter so that the number of clock cycles
of CSR clock is 1us. (Subtract 1 from the value before programming).
For example if the CSR clock is 100MHz then this field needs to be programmed
to value 100 - 1 = 99 (which is 0x63).
This is required to generate the 1US events that are used to update some of
the EEE related counters.
"

The reset value is 0x63 on i.MX8M Plus, which means expected CSR clock are
100 MHz. However, the i.MX8M Plus "enet_qos_root_clk" are 266 MHz instead,
which means the LPI timers reach their count much sooner on this platform.

This is visible using a scope by monitoring e.g. exit from LPI mode on TX_CTL
line from MAC to PHY. This should take 30us per STMMAC_DEFAULT_TWT_LS setting,
during which the TX_CTL line transitions from tristate to low, and 30 us later
from low to high. On i.MX8M Plus, this transition takes 11 us, which matches
the 30us * 100/266 formula for misconfigured MAC_ONEUS_TIC_COUNTER register.

Configure MAC_ONEUS_TIC_COUNTER based on CSR clock, so that the LPI timers
have correct 1us reference. This then fixes EEE on i.MX8M Plus with Micrel
KSZ9131RNX PHY.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Marek Vasut <marex@denx.de>
Tested-by: Harald Seiler <hws@denx.de>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> # Toradex Verdin iMX8MP
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/20230506235845.246105-1-marex@denx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 71dad409f78b0..12c0e60809f47 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -181,6 +181,7 @@ enum power_event {
 #define GMAC4_LPI_CTRL_STATUS	0xd0
 #define GMAC4_LPI_TIMER_CTRL	0xd4
 #define GMAC4_LPI_ENTRY_TIMER	0xd8
+#define GMAC4_MAC_ONEUS_TIC_COUNTER	0xdc
 
 /* LPI control and status defines */
 #define GMAC4_LPI_CTRL_STATUS_LPITCSE	BIT(21)	/* LPI Tx Clock Stop Enable */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 0cb4d2d35786a..29480314a4867 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -26,6 +26,7 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 	struct stmmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value = readl(ioaddr + GMAC_CONFIG);
+	u32 clk_rate;
 
 	value |= GMAC_CORE_INIT;
 
@@ -48,6 +49,10 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 
 	writel(value, ioaddr + GMAC_CONFIG);
 
+	/* Configure LPI 1us counter to number of CSR clock ticks in 1us - 1 */
+	clk_rate = clk_get_rate(priv->plat->stmmac_clk);
+	writel((clk_rate / 1000000) - 1, ioaddr + GMAC4_MAC_ONEUS_TIC_COUNTER);
+
 	/* Enable GMAC interrupts */
 	value = GMAC_INT_DEFAULT_ENABLE;
 
-- 
2.39.2



