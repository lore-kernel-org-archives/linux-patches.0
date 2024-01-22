Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86FE128380;
	Tue, 23 Jan 2024 00:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968674; cv=none; b=mHvNhGNzCAPyoFGcP3MSvzWu25S1gLDMGmNxO6eTpAwfwn4K6M22SLBQwRcFykgiIea5VxEcX3RWepm1FB4rVOggQ/W1PkxFkSObu85MBqGu7dhigvGhatU49Pfqf8txmcF8CroJ5qZLt6rTCdoOGotJq2EWjXMFG0JIHgharvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968674; c=relaxed/simple;
	bh=0jufXtfVRhnS8RrnTVtARcEodq/1fGhDVGKCLYtoTEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pACUXhCyGa6DuhB98crPvmdqjDsRnv7+i1YogAT4ieZE87vSfwNHUjgA8JxWfS0atgLQlwbLnxXm0vBskcPvcbR0cJn3Cu96DfFB/O9ZY3JczSSaM6DEE4kYBW/dUvj/lpEJuLYZfArEffPtxKw2Awq0B+0yL3I0yG/RCCdJzkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POeDE3lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POeDE3lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4126AC433F1;
	Tue, 23 Jan 2024 00:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968673;
	bh=0jufXtfVRhnS8RrnTVtARcEodq/1fGhDVGKCLYtoTEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POeDE3lfQ6WtkUTiseEVL8fpH92QMkq2gAWBC6COKlxlTmY8gLAl3+Xx5LGrk8x1G
	 3rl0mTgmIBgcDhSs7UzRZIzVbc3rpY6TycQGfU25MtzpwQpoGWyzrJja4oBDCdEfU/
	 037+dSM8pGp5C6t2cEEPE6cKDhWq+reKU6miPppI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 4.19 130/148] wifi: rtlwifi: Convert LNKCTL change to PCIe cap RMW accessors
Date: Mon, 22 Jan 2024 15:58:06 -0800
Message-ID: <20240122235717.805544110@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 5894d0089cbc146063dcc0239a78ede0a8142efb upstream.

The rtlwifi driver comes with custom code to write into PCIe Link
Control register. RMW access for the Link Control register requires
locking that is already provided by the standard PCIe capability
accessors.

Convert the custom RMW code writing into LNKCTL register to standard
RMW capability accessors. The accesses are changed to cover the full
LNKCTL register instead of touching just a single byte of the register.

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231124084725.12738-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -186,21 +186,29 @@ static bool _rtl_pci_platform_switch_dev
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
+	value &= PCI_EXP_LNKCTL_ASPMC;
+
 	if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE)
-		value |= 0x40;
+		value |= PCI_EXP_LNKCTL_CCC;
 
-	pci_write_config_byte(rtlpci->pdev, 0x80, value);
+	pcie_capability_clear_and_set_word(rtlpci->pdev, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPMC | value,
+					   value);
 
 	return false;
 }
 
-/*When we set 0x01 to enable clk request. Set 0x0 to disable clk req.*/
-static void _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
+/* @value is PCI_EXP_LNKCTL_CLKREQ_EN or 0 to enable/disable clk request. */
+static void _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u16 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	pci_write_config_byte(rtlpci->pdev, 0x81, value);
+	value &= PCI_EXP_LNKCTL_CLKREQ_EN;
+
+	pcie_capability_clear_and_set_word(rtlpci->pdev, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_CLKREQ_EN,
+					   value);
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
 		udelay(100);
@@ -281,7 +289,8 @@ static void rtl_pci_enable_aspm(struct i
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_CLK_REQ) {
 		_rtl_pci_switch_clk_req(hw, (ppsc->reg_rfps_level &
-					     RT_RF_OFF_LEVL_CLK_REQ) ? 1 : 0);
+					     RT_RF_OFF_LEVL_CLK_REQ) ?
+					     PCI_EXP_LNKCTL_CLKREQ_EN : 0);
 		RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_CLK_REQ);
 	}
 	udelay(100);


