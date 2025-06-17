Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC3A2ED841;
	Tue, 17 Jun 2025 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177162; cv=none; b=rMbTqPrVNu4fbGcHwyVCmi5w18bIXqwuif1dDuFjLZitmsRi3vX99vHtK2i6cCCyILgqQu0bpoj2anmYnQ/UnImfspANzUNQsT2JUDJYcx5KpW1mTuYaFG5eCmlK/xSeJkRpBEU++WnbGnbsfTGSDCklVOxrOP4gV2xlsdNu1YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177162; c=relaxed/simple;
	bh=P6Y7L2SLrI+qA+p30EAJDKh1Z7aFwBAX+MmiMKJP4M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBH60VkTJDAT10Tw83PX1xxTerRxpuNnUZ/+Uy+KQY+n3Bu01F6gcYRYUjzyis7ip9MKZozHG8f+Pu8DL3TZjOOyBNHylyz0ElVI6rxRnPHZbTEsb/dJjfQ26WD0vrj3UhdlrMsOWTrWxQXEcVNrqG99NkmsXIwuymOMk/D42G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJjOw+5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJjOw+5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7706CC4CEE7;
	Tue, 17 Jun 2025 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177161;
	bh=P6Y7L2SLrI+qA+p30EAJDKh1Z7aFwBAX+MmiMKJP4M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJjOw+5dMkD57btwYRL4zDARn7ZfoWxSsQEGq+aa4yBebaXEgHN7JJSaaMpYUNeuG
	 m+p7pFnjpmY+nD11VFmBxrmrpWllVKdgEQmcfW337z+sN8bEd+uRwH2iS5tMdlfyAq
	 xZZc0b+hkL7+cacQmrwwYb0BRBCN1kOuX8iLS2n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 267/780] wifi: rtw89: pci: configure manual DAC mode via PCI config API only
Date: Tue, 17 Jun 2025 17:19:35 +0200
Message-ID: <20250617152502.339775897@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit a70cf04b08f44f41bce14659aa7012674b15d9de ]

To support 36-bit DMA, configure chip proprietary bit via PCI config API
or chip DBI interface. However, the PCI device mmap isn't set yet and
the DBI is also inaccessible via mmap, so only if the bit can be accessible
via PCI config API, chip can support 36-bit DMA. Otherwise, fallback to
32-bit DMA.

With NULL mmap address, kernel throws trace:

  BUG: unable to handle page fault for address: 0000000000001090
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0002 [#1] PREEMPT SMP PTI
  CPU: 1 UID: 0 PID: 71 Comm: irq/26-pciehp Tainted: G           OE      6.14.2-061402-generic #202504101348
  Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
  RIP: 0010:rtw89_pci_ops_write16+0x12/0x30 [rtw89_pci]
  RSP: 0018:ffffb0ffc0acf9d8 EFLAGS: 00010206
  RAX: ffffffffc158f9c0 RBX: ffff94865e702020 RCX: 0000000000000000
  RDX: 0000000000000718 RSI: 0000000000001090 RDI: ffff94865e702020
  RBP: ffffb0ffc0acf9d8 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000015
  R13: 0000000000000719 R14: ffffb0ffc0acfa1f R15: ffffffffc1813060
  FS:  0000000000000000(0000) GS:ffff9486f3480000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000001090 CR3: 0000000090440001 CR4: 00000000000626f0
  Call Trace:
   <TASK>
   rtw89_pci_read_config_byte+0x6d/0x120 [rtw89_pci]
   rtw89_pci_cfg_dac+0x5b/0xb0 [rtw89_pci]
   rtw89_pci_probe+0xa96/0xbd0 [rtw89_pci]
   ? __pfx___device_attach_driver+0x10/0x10
   ? __pfx___device_attach_driver+0x10/0x10
   local_pci_probe+0x47/0xa0
   pci_call_probe+0x5d/0x190
   pci_device_probe+0xa7/0x160
   really_probe+0xf9/0x370
   ? pm_runtime_barrier+0x55/0xa0
   __driver_probe_device+0x8c/0x140
   driver_probe_device+0x24/0xd0
   __device_attach_driver+0xcd/0x170
   bus_for_each_drv+0x99/0x100
   __device_attach+0xb4/0x1d0
   device_attach+0x10/0x20
   pci_bus_add_device+0x59/0x90
   pci_bus_add_devices+0x31/0x80
   pciehp_configure_device+0xaa/0x170
   pciehp_enable_slot+0xd6/0x240
   pciehp_handle_presence_or_link_change+0xf1/0x180
   pciehp_ist+0x162/0x1c0
   irq_thread_fn+0x24/0x70
   irq_thread+0xef/0x1c0
   ? __pfx_irq_thread_fn+0x10/0x10
   ? __pfx_irq_thread_dtor+0x10/0x10
   ? __pfx_irq_thread+0x10/0x10
   kthread+0xfc/0x230
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x47/0x70
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

Fixes: 1fd4b3fe52ef ("wifi: rtw89: pci: support 36-bit PCI DMA address")
Reported-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/ccaf49b6-ff41-4917-90f1-f53cadaaa0da@gmail.com/T/#u
Closes: https://github.com/openwrt/openwrt/issues/17025
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250506015356.7995-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 34 ++++++++++++++++--------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index c2fe5a898dc71..b5cdc18f802a9 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -3105,17 +3105,26 @@ static bool rtw89_pci_is_dac_compatible_bridge(struct rtw89_dev *rtwdev)
 	return false;
 }
 
-static void rtw89_pci_cfg_dac(struct rtw89_dev *rtwdev)
+static int rtw89_pci_cfg_dac(struct rtw89_dev *rtwdev, bool force)
 {
 	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	struct pci_dev *pdev = rtwpci->pdev;
+	int ret;
+	u8 val;
 
-	if (!rtwpci->enable_dac)
-		return;
+	if (!rtwpci->enable_dac && !force)
+		return 0;
 
 	if (!rtw89_pci_chip_is_manual_dac(rtwdev))
-		return;
+		return 0;
 
-	rtw89_pci_config_byte_set(rtwdev, RTW89_PCIE_L1_CTRL, RTW89_PCIE_BIT_EN_64BITS);
+	/* Configure DAC only via PCI config API, not DBI interfaces */
+	ret = pci_read_config_byte(pdev, RTW89_PCIE_L1_CTRL, &val);
+	if (ret)
+		return ret;
+
+	val |= RTW89_PCIE_BIT_EN_64BITS;
+	return pci_write_config_byte(pdev, RTW89_PCIE_L1_CTRL, val);
 }
 
 static int rtw89_pci_setup_mapping(struct rtw89_dev *rtwdev,
@@ -3133,13 +3142,16 @@ static int rtw89_pci_setup_mapping(struct rtw89_dev *rtwdev,
 	}
 
 	if (!rtw89_pci_is_dac_compatible_bridge(rtwdev))
-		goto no_dac;
+		goto try_dac_done;
 
 	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(36));
 	if (!ret) {
-		rtwpci->enable_dac = true;
-		rtw89_pci_cfg_dac(rtwdev);
-	} else {
+		ret = rtw89_pci_cfg_dac(rtwdev, true);
+		if (!ret) {
+			rtwpci->enable_dac = true;
+			goto try_dac_done;
+		}
+
 		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (ret) {
 			rtw89_err(rtwdev,
@@ -3147,7 +3159,7 @@ static int rtw89_pci_setup_mapping(struct rtw89_dev *rtwdev,
 			goto err_release_regions;
 		}
 	}
-no_dac:
+try_dac_done:
 
 	resource_len = pci_resource_len(pdev, bar_id);
 	rtwpci->mmap = pci_iomap(pdev, bar_id, resource_len);
@@ -4302,7 +4314,7 @@ static void rtw89_pci_l2_hci_ldo(struct rtw89_dev *rtwdev)
 void rtw89_pci_basic_cfg(struct rtw89_dev *rtwdev, bool resume)
 {
 	if (resume)
-		rtw89_pci_cfg_dac(rtwdev);
+		rtw89_pci_cfg_dac(rtwdev, false);
 
 	rtw89_pci_disable_eq(rtwdev);
 	rtw89_pci_filter_out(rtwdev);
-- 
2.39.5



