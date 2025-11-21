Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92E27147D;
	Fri, 21 Nov 2025 13:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731078; cv=none; b=IqKbL2Ev+9s3TIOh0mkYxxqm1YyLsxXRyEWK5d/EHncAczEI5Gjwnqv9HKmWQ0PeDTIrbv7GgtmI+/ylkGCLi5jZbs2Xihg7g/EKT3ULJrkuu/OhiegCRBOMogTVpBRBq5i1NlzVo+bCLexjP8DRPRjBiAlWAC3Dso3gKsrTgyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731078; c=relaxed/simple;
	bh=sDUyxH5AQ2excvz2swV2zNijg9yyKoZ+5CxC/c+EjoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QExyPCxNQTPiR3GSQmWRrQOh58/w8OIMp338diYz4682IxT1OiNYy56Ha8UD+KVm2NMrP2kajGbfgxvgMjmEc16h4K5BDJXHUemCZkp52kXTr6POpVvKKHHOkMjDSycpk2ae+9TieDQV5zhAj1tk4LYMwID6EtKUDCXe3fsIvGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3YTDjEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3YTDjEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A448DC4CEF1;
	Fri, 21 Nov 2025 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731078;
	bh=sDUyxH5AQ2excvz2swV2zNijg9yyKoZ+5CxC/c+EjoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3YTDjEs65/8uileOJgus2dP6wEdw0z2HnJbaHaHQY48dPfy9+hN/M+hfsMmb1Edu
	 XJR5c2p6G8679Q2IgOgbxZ2EDuhgqita9X8P+YgmGY82E0Pe1dTBNzr8/vQ3vUwek3
	 fReAP7taOLaJ4QUmfqRZVzlBhQGGmuoUF1XoOEng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 050/247] net: phy: micrel: Introduce lanphy_modify_page_reg
Date: Fri, 21 Nov 2025 14:09:57 +0100
Message-ID: <20251121130156.399738892@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit a0de636ed7a264a329c6a9c7d50727af02138536 ]

As the name suggests this function modifies the register in an
extended page. It has the same parameters as phy_modify_mmd.
This function was introduce because there are many places in the
code where the registers was read then the value was modified and
written back. So replace all this code with this function to make
it clear.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20250818075121.1298170-3-horatiu.vultur@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 96a9178a29a6 ("net: phy: micrel: lan8814 fix reset of the QSGMII interface")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 231 ++++++++++++++++++++-------------------
 1 file changed, 116 insertions(+), 115 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 99f8374fd32a7..0efc5adbf789d 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2840,6 +2840,27 @@ static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
 	return val;
 }
 
+static int lanphy_modify_page_reg(struct phy_device *phydev, int page, u16 addr,
+				  u16 mask, u16 set)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		    (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+	ret = __phy_modify_changed(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA,
+				   mask, set);
+	phy_unlock_mdio_bus(phydev);
+
+	if (ret < 0)
+		phydev_err(phydev, "__phy_modify_changed() failed: %pe\n",
+			   ERR_PTR(ret));
+
+	return ret;
+}
+
 static int lan8814_config_ts_intr(struct phy_device *phydev, bool enable)
 {
 	u16 val = 0;
@@ -2928,7 +2949,6 @@ static int lan8814_hwtstamp(struct mii_timestamper *mii_ts,
 	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
 	int txcfg = 0, rxcfg = 0;
 	int pkt_ts_enable;
-	int tx_mod;
 
 	ptp_priv->hwts_tx_type = config->tx_type;
 	ptp_priv->rx_filter = config->rx_filter;
@@ -2975,13 +2995,14 @@ static int lan8814_hwtstamp(struct mii_timestamper *mii_ts,
 	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_RX_TIMESTAMP_EN, pkt_ts_enable);
 	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_TIMESTAMP_EN, pkt_ts_enable);
 
-	tx_mod = lanphy_read_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD);
 	if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ONESTEP_SYNC) {
-		lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD,
-				      tx_mod | PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
+		lanphy_modify_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD,
+				       PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_,
+				       PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
 	} else if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ON) {
-		lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD,
-				      tx_mod & ~PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
+		lanphy_modify_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD,
+				       PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_,
+				       0);
 	}
 
 	if (config->rx_filter != HWTSTAMP_FILTER_NONE)
@@ -3384,73 +3405,66 @@ static void lan8814_ptp_set_reload(struct phy_device *phydev, int event,
 static void lan8814_ptp_enable_event(struct phy_device *phydev, int event,
 				     int pulse_width)
 {
-	u16 val;
-
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG);
-	/* Set the pulse width of the event */
-	val &= ~(LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_MASK(event));
-	/* Make sure that the target clock will be incremented each time when
+	/* Set the pulse width of the event,
+	 * Make sure that the target clock will be incremented each time when
 	 * local time reaches or pass it
+	 * Set the polarity high
 	 */
-	val |= LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_SET(event, pulse_width);
-	val &= ~(LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X(event));
-	/* Set the polarity high */
-	val |= LAN8814_PTP_GENERAL_CONFIG_POLARITY_X(event);
-	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG, val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG,
+			       LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_MASK(event) |
+			       LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_SET(event, pulse_width) |
+			       LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X(event) |
+			       LAN8814_PTP_GENERAL_CONFIG_POLARITY_X(event),
+			       LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_SET(event, pulse_width) |
+			       LAN8814_PTP_GENERAL_CONFIG_POLARITY_X(event));
 }
 
 static void lan8814_ptp_disable_event(struct phy_device *phydev, int event)
 {
-	u16 val;
-
 	/* Set target to too far in the future, effectively disabling it */
 	lan8814_ptp_set_target(phydev, event, 0xFFFFFFFF, 0);
 
 	/* And then reload once it recheas the target */
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG);
-	val |= LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X(event);
-	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG, val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG,
+			       LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X(event),
+			       LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X(event));
 }
 
 static void lan8814_ptp_perout_off(struct phy_device *phydev, int pin)
 {
-	u16 val;
-
 	/* Disable gpio alternate function,
 	 * 1: select as gpio,
 	 * 0: select alt func
 	 */
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin));
-	val |= LAN8814_GPIO_EN_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin), val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin),
+			       LAN8814_GPIO_EN_BIT(pin),
+			       LAN8814_GPIO_EN_BIT(pin));
 
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin));
-	val &= ~LAN8814_GPIO_DIR_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin), val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin),
+			       LAN8814_GPIO_DIR_BIT(pin),
+			       0);
 
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(pin));
-	val &= ~LAN8814_GPIO_BUF_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(pin), val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(pin),
+			       LAN8814_GPIO_BUF_BIT(pin),
+			       0);
 }
 
 static void lan8814_ptp_perout_on(struct phy_device *phydev, int pin)
 {
-	int val;
-
 	/* Set as gpio output */
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin));
-	val |= LAN8814_GPIO_DIR_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin), val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin),
+			       LAN8814_GPIO_DIR_BIT(pin),
+			       LAN8814_GPIO_DIR_BIT(pin));
 
 	/* Enable gpio 0:for alternate function, 1:gpio */
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin));
-	val &= ~LAN8814_GPIO_EN_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin), val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin),
+			       LAN8814_GPIO_EN_BIT(pin),
+			       0);
 
 	/* Set buffer type to push pull */
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(pin));
-	val |= LAN8814_GPIO_BUF_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(pin), val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(pin),
+			       LAN8814_GPIO_BUF_BIT(pin),
+			       LAN8814_GPIO_BUF_BIT(pin));
 }
 
 static int lan8814_ptp_perout(struct ptp_clock_info *ptpci,
@@ -3565,61 +3579,59 @@ static int lan8814_ptp_perout(struct ptp_clock_info *ptpci,
 
 static void lan8814_ptp_extts_on(struct phy_device *phydev, int pin, u32 flags)
 {
-	u16 tmp;
-
 	/* Set as gpio input */
-	tmp = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin));
-	tmp &= ~LAN8814_GPIO_DIR_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin), tmp);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin),
+			       LAN8814_GPIO_DIR_BIT(pin),
+			       0);
 
 	/* Map the pin to ltc pin 0 of the capture map registers */
-	tmp = lanphy_read_page_reg(phydev, 4, PTP_GPIO_CAP_MAP_LO);
-	tmp |= pin;
-	lanphy_write_page_reg(phydev, 4, PTP_GPIO_CAP_MAP_LO, tmp);
+	lanphy_modify_page_reg(phydev, 4, PTP_GPIO_CAP_MAP_LO,
+			       pin,
+			       pin);
 
 	/* Enable capture on the edges of the ltc pin */
-	tmp = lanphy_read_page_reg(phydev, 4, PTP_GPIO_CAP_EN);
 	if (flags & PTP_RISING_EDGE)
-		tmp |= PTP_GPIO_CAP_EN_GPIO_RE_CAPTURE_ENABLE(0);
+		lanphy_modify_page_reg(phydev, 4, PTP_GPIO_CAP_EN,
+				       PTP_GPIO_CAP_EN_GPIO_RE_CAPTURE_ENABLE(0),
+				       PTP_GPIO_CAP_EN_GPIO_RE_CAPTURE_ENABLE(0));
 	if (flags & PTP_FALLING_EDGE)
-		tmp |= PTP_GPIO_CAP_EN_GPIO_FE_CAPTURE_ENABLE(0);
-	lanphy_write_page_reg(phydev, 4, PTP_GPIO_CAP_EN, tmp);
+		lanphy_modify_page_reg(phydev, 4, PTP_GPIO_CAP_EN,
+				       PTP_GPIO_CAP_EN_GPIO_FE_CAPTURE_ENABLE(0),
+				       PTP_GPIO_CAP_EN_GPIO_FE_CAPTURE_ENABLE(0));
 
 	/* Enable interrupt top interrupt */
-	tmp = lanphy_read_page_reg(phydev, 4, PTP_COMMON_INT_ENA);
-	tmp |= PTP_COMMON_INT_ENA_GPIO_CAP_EN;
-	lanphy_write_page_reg(phydev, 4, PTP_COMMON_INT_ENA, tmp);
+	lanphy_modify_page_reg(phydev, 4, PTP_COMMON_INT_ENA,
+			       PTP_COMMON_INT_ENA_GPIO_CAP_EN,
+			       PTP_COMMON_INT_ENA_GPIO_CAP_EN);
 }
 
 static void lan8814_ptp_extts_off(struct phy_device *phydev, int pin)
 {
-	u16 tmp;
-
 	/* Set as gpio out */
-	tmp = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin));
-	tmp |= LAN8814_GPIO_DIR_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin), tmp);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(pin),
+			       LAN8814_GPIO_DIR_BIT(pin),
+			       LAN8814_GPIO_DIR_BIT(pin));
 
 	/* Enable alternate, 0:for alternate function, 1:gpio */
-	tmp = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin));
-	tmp &= ~LAN8814_GPIO_EN_BIT(pin);
-	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin), tmp);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(pin),
+			       LAN8814_GPIO_EN_BIT(pin),
+			       0);
 
 	/* Clear the mapping of pin to registers 0 of the capture registers */
-	tmp = lanphy_read_page_reg(phydev, 4, PTP_GPIO_CAP_MAP_LO);
-	tmp &= ~GENMASK(3, 0);
-	lanphy_write_page_reg(phydev, 4, PTP_GPIO_CAP_MAP_LO, tmp);
+	lanphy_modify_page_reg(phydev, 4, PTP_GPIO_CAP_MAP_LO,
+			       GENMASK(3, 0),
+			       0);
 
 	/* Disable capture on both of the edges */
-	tmp = lanphy_read_page_reg(phydev, 4, PTP_GPIO_CAP_EN);
-	tmp &= ~PTP_GPIO_CAP_EN_GPIO_RE_CAPTURE_ENABLE(pin);
-	tmp &= ~PTP_GPIO_CAP_EN_GPIO_FE_CAPTURE_ENABLE(pin);
-	lanphy_write_page_reg(phydev, 4, PTP_GPIO_CAP_EN, tmp);
+	lanphy_modify_page_reg(phydev, 4, PTP_GPIO_CAP_EN,
+			       PTP_GPIO_CAP_EN_GPIO_RE_CAPTURE_ENABLE(pin) |
+			       PTP_GPIO_CAP_EN_GPIO_FE_CAPTURE_ENABLE(pin),
+			       0);
 
 	/* Disable interrupt top interrupt */
-	tmp = lanphy_read_page_reg(phydev, 4, PTP_COMMON_INT_ENA);
-	tmp &= ~PTP_COMMON_INT_ENA_GPIO_CAP_EN;
-	lanphy_write_page_reg(phydev, 4, PTP_COMMON_INT_ENA, tmp);
+	lanphy_modify_page_reg(phydev, 4, PTP_COMMON_INT_ENA,
+			       PTP_COMMON_INT_ENA_GPIO_CAP_EN,
+			       0);
 }
 
 static int lan8814_ptp_extts(struct ptp_clock_info *ptpci,
@@ -3859,9 +3871,9 @@ static int lan8814_gpio_process_cap(struct lan8814_shared_priv *shared)
 	/* This is 0 because whatever was the input pin it was mapped it to
 	 * ltc gpio pin 0
 	 */
-	tmp = lanphy_read_page_reg(phydev, 4, PTP_GPIO_SEL);
-	tmp |= PTP_GPIO_SEL_GPIO_SEL(0);
-	lanphy_write_page_reg(phydev, 4, PTP_GPIO_SEL, tmp);
+	lanphy_modify_page_reg(phydev, 4, PTP_GPIO_SEL,
+			       PTP_GPIO_SEL_GPIO_SEL(0),
+			       PTP_GPIO_SEL_GPIO_SEL(0));
 
 	tmp = lanphy_read_page_reg(phydev, 4, PTP_GPIO_CAP_STS);
 	if (!(tmp & PTP_GPIO_CAP_STS_PTP_GPIO_RE_STS(0)) &&
@@ -3908,13 +3920,10 @@ static int lan8814_handle_gpio_interrupt(struct phy_device *phydev, u16 status)
 
 static int lan8804_config_init(struct phy_device *phydev)
 {
-	int val;
-
 	/* MDI-X setting for swap A,B transmit */
-	val = lanphy_read_page_reg(phydev, 2, LAN8804_ALIGN_SWAP);
-	val &= ~LAN8804_ALIGN_TX_A_B_SWAP_MASK;
-	val |= LAN8804_ALIGN_TX_A_B_SWAP;
-	lanphy_write_page_reg(phydev, 2, LAN8804_ALIGN_SWAP, val);
+	lanphy_modify_page_reg(phydev, 2, LAN8804_ALIGN_SWAP,
+			       LAN8804_ALIGN_TX_A_B_SWAP_MASK,
+			       LAN8804_ALIGN_TX_A_B_SWAP);
 
 	/* Make sure that the PHY will not stop generating the clock when the
 	 * link partner goes down
@@ -4056,7 +4065,6 @@ static void lan8814_ptp_init(struct phy_device *phydev)
 {
 	struct kszphy_priv *priv = phydev->priv;
 	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
-	u32 temp;
 
 	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
 	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
@@ -4064,13 +4072,13 @@ static void lan8814_ptp_init(struct phy_device *phydev)
 
 	lanphy_write_page_reg(phydev, 5, TSU_HARD_RESET, TSU_HARD_RESET_);
 
-	temp = lanphy_read_page_reg(phydev, 5, PTP_TX_MOD);
-	temp |= PTP_TX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_;
-	lanphy_write_page_reg(phydev, 5, PTP_TX_MOD, temp);
+	lanphy_modify_page_reg(phydev, 5, PTP_TX_MOD,
+			       PTP_TX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_,
+			       PTP_TX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_);
 
-	temp = lanphy_read_page_reg(phydev, 5, PTP_RX_MOD);
-	temp |= PTP_RX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_;
-	lanphy_write_page_reg(phydev, 5, PTP_RX_MOD, temp);
+	lanphy_modify_page_reg(phydev, 5, PTP_RX_MOD,
+			       PTP_RX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_,
+			       PTP_RX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_);
 
 	lanphy_write_page_reg(phydev, 5, PTP_RX_PARSE_CONFIG, 0);
 	lanphy_write_page_reg(phydev, 5, PTP_TX_PARSE_CONFIG, 0);
@@ -4196,23 +4204,21 @@ static void lan8814_setup_led(struct phy_device *phydev, int val)
 static int lan8814_config_init(struct phy_device *phydev)
 {
 	struct kszphy_priv *lan8814 = phydev->priv;
-	int val;
 
 	/* Reset the PHY */
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
-	val |= LAN8814_QSGMII_SOFT_RESET_BIT;
-	lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET, val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET,
+			       LAN8814_QSGMII_SOFT_RESET_BIT,
+			       LAN8814_QSGMII_SOFT_RESET_BIT);
 
 	/* Disable ANEG with QSGMII PCS Host side */
-	val = lanphy_read_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
-	val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
-	lanphy_write_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
+	lanphy_modify_page_reg(phydev, 4, LAN8814_QSGMII_PCS1G_ANEG_CONFIG,
+			       LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA,
+			       0);
 
 	/* MDI-X setting for swap A,B transmit */
-	val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
-	val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
-	val |= LAN8814_ALIGN_TX_A_B_SWAP;
-	lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
+	lanphy_modify_page_reg(phydev, 2, LAN8814_ALIGN_SWAP,
+			       LAN8814_ALIGN_TX_A_B_SWAP_MASK,
+			       LAN8814_ALIGN_TX_A_B_SWAP);
 
 	if (lan8814->led_mode >= 0)
 		lan8814_setup_led(phydev, lan8814->led_mode);
@@ -4243,29 +4249,24 @@ static int lan8814_release_coma_mode(struct phy_device *phydev)
 
 static void lan8814_clear_2psp_bit(struct phy_device *phydev)
 {
-	u16 val;
-
 	/* It was noticed that when traffic is passing through the PHY and the
 	 * cable is removed then the LED was still one even though there is no
 	 * link
 	 */
-	val = lanphy_read_page_reg(phydev, 2, LAN8814_EEE_STATE);
-	val &= ~LAN8814_EEE_STATE_MASK2P5P;
-	lanphy_write_page_reg(phydev, 2, LAN8814_EEE_STATE, val);
+	lanphy_modify_page_reg(phydev, 2, LAN8814_EEE_STATE,
+			       LAN8814_EEE_STATE_MASK2P5P,
+			       0);
 }
 
 static void lan8814_update_meas_time(struct phy_device *phydev)
 {
-	u16 val;
-
 	/* By setting the measure time to a value of 0xb this will allow cables
 	 * longer than 100m to be used. This configuration can be used
 	 * regardless of the mode of operation of the PHY
 	 */
-	val = lanphy_read_page_reg(phydev, 1, LAN8814_PD_CONTROLS);
-	val &= ~LAN8814_PD_CONTROLS_PD_MEAS_TIME_MASK;
-	val |= LAN8814_PD_CONTROLS_PD_MEAS_TIME_VAL;
-	lanphy_write_page_reg(phydev, 1, LAN8814_PD_CONTROLS, val);
+	lanphy_modify_page_reg(phydev, 1, LAN8814_PD_CONTROLS,
+			       LAN8814_PD_CONTROLS_PD_MEAS_TIME_MASK,
+			       LAN8814_PD_CONTROLS_PD_MEAS_TIME_VAL);
 }
 
 static int lan8814_probe(struct phy_device *phydev)
-- 
2.51.0



