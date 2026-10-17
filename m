Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231DF303A04;
	Sat, 17 Oct 2026 16:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253347; cv=none; b=CHewDisA6YsWTIzUqgAzYxLQig3O6pLhk4Yws7NgTTnKnVr03ir/i6e2LqMkbOG1GzZin3HpECaV2xPN+nEDgLYrhGHDMdmS0gRv5Nw5lwbYPqFozOhIWIFi/TfM+GwgBghBl2ZzOW2v/6zMjEny55Ux4hX7jCUSTGZZkEB7UUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253347; c=relaxed/simple;
	bh=sOEcPten7BMjt9nYbzGwKHZ5tHuj0m+Tt1jDexYR+vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P236daTSw/ZSOTe8vvNpS+HXLe8NpSJ7FS7Evjg6RltohGaYrLsEVyOjqdmd81LcF3VJGFsCjqObTbDEqFW0PhnQA5fn7qekTzdEDnUqpGzjcm8v5umVa/zKKf/Dsa5WlsRFkoiPCqdIzo4jLe7jFoh3ErB4WiW9zRhebHqphF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WisW0GcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WisW0GcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700B11F000C4;
	Sat, 17 Oct 2026 16:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253346;
	bh=lZ4qD+cvGvu086FCGLEARBUxcwQbsttaovBMd4Somjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WisW0GcURqtVeGXkzXjGkIocXn3P2ScXh7A4SDi8UB3fh2GoR2Zao27IqzFWF5gAY
	 O1s8g3Ag5zr8IKKFlBKilfIyY5zXxRqx7JiZMXDxu6sDIkozwowjyVCVjtljH7Zadx
	 5yWEBu5JjbEMupK9blkZcSRi2PZaaYhpOnAhmuLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/869] wifi: rtw89: pci: configure manual DAC mode via PCI config API only
Date: Sat, 17 Oct 2026 17:48:49 +0200
Message-ID: <20261017160039.288868529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 48415d108045f..43285d341870e 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -3086,17 +3086,26 @@ static bool rtw89_pci_is_dac_compatible_bridge(struct rtw89_dev *rtwdev)
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
@@ -3114,13 +3123,16 @@ static int rtw89_pci_setup_mapping(struct rtw89_dev *rtwdev,
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
@@ -3128,7 +3140,7 @@ static int rtw89_pci_setup_mapping(struct rtw89_dev *rtwdev,
 			goto err_release_regions;
 		}
 	}
-no_dac:
+try_dac_done:
 
 	resource_len = pci_resource_len(pdev, bar_id);
 	rtwpci->mmap = pci_iomap(pdev, bar_id, resource_len);
@@ -4267,7 +4279,7 @@ static int __maybe_unused rtw89_pci_resume(struct device *dev)
 	rtw89_pci_hci_ldo(rtwdev);
 	rtw89_pci_l2_hci_ldo(rtwdev);
 	rtw89_pci_disable_eq(rtwdev);
-	rtw89_pci_cfg_dac(rtwdev);
+	rtw89_pci_cfg_dac(rtwdev, false);
 	rtw89_pci_filter_out(rtwdev);
 	rtw89_pci_link_cfg(rtwdev);
 	rtw89_pci_l1ss_cfg(rtwdev);
-- 
2.53.0



