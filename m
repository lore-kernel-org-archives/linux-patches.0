Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C2A23DB;
	Tue, 23 Jan 2024 00:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969838; cv=none; b=OjAqZf2UyB7XeCsIKhtbpsDmTrSCZ2UVo3+6iMkD96sOwHCqt0eDBxwv7RL9avAtyzSwhWK1DMZicKd/BGcl8hxCta8QYupdnq3CBGVA9z/qOQvPII50eoXXO9weatuE4oi/DfrDDBxCxhizVmPLoOLxymWSccOVRPkUzPB1dVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969838; c=relaxed/simple;
	bh=Ycvu5Ct/pRmDkiV05KZOAogyWydT5Pk+YbG4z8+0HYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xe9ClLDBwCd1GwGWlDKm8jwyBtr46vihS386LqchysI2fhFSjwx0ZtGb95R/J/sOH+D6tpg86D+mD4FRDOFQgeGTYd8iNSDHWsBjJzvmrfsA+DngwbFx0FCFyyl8pK58TJLWeO6Ovv2f9aBB3EbVa3AzmcBBJHOp2/0Or6ryaWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qA2Db+sO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qA2Db+sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10345C433F1;
	Tue, 23 Jan 2024 00:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969838;
	bh=Ycvu5Ct/pRmDkiV05KZOAogyWydT5Pk+YbG4z8+0HYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qA2Db+sOIjf7pTj5/wSikLfTU9pc5jLn/jUtxCTlILctrpu50M/S526nsG1TguLIl
	 vgxELSfOprf5XMMmgC7aQxsy7CcscYPy1FWCW8iF6dM/ChcYcJHzir0m8zpPW0XYyq
	 yDnNs8LKKpt1rZiU42jADnUEfEeMijhoXTmlopxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.7 456/641] wifi: rtlwifi: Convert LNKCTL change to PCIe cap RMW accessors
Date: Mon, 22 Jan 2024 15:56:00 -0800
Message-ID: <20240122235832.290032774@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -164,21 +164,29 @@ static bool _rtl_pci_platform_switch_dev
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
@@ -259,7 +267,8 @@ static void rtl_pci_enable_aspm(struct i
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_CLK_REQ) {
 		_rtl_pci_switch_clk_req(hw, (ppsc->reg_rfps_level &
-					     RT_RF_OFF_LEVL_CLK_REQ) ? 1 : 0);
+					     RT_RF_OFF_LEVL_CLK_REQ) ?
+					     PCI_EXP_LNKCTL_CLKREQ_EN : 0);
 		RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_CLK_REQ);
 	}
 	udelay(100);


