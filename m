Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9F42E54DC;
	Tue,  8 Jul 2025 17:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994080; cv=none; b=MTUfHRsk4ar3V9iwnRWQUatM1SwENZsFgtX1VH/uIHFk5AEwsFuiBaXZh90KrTZT+CRBrKx7GtCRB7Al/YJoEedAkp7XYraDErzjzeJhl7FcQFE0WM4CMCPUcfeWd2lyXtAOxN2ryRQK62y9UTT5MxpLka677XSe4AsM3RYLzAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994080; c=relaxed/simple;
	bh=zqq/RihB88gTsVCpMezRj6jCm9USPl/XHC73x1NEJUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoP8ChmEziMyFBDoxbOHj9kwCaXjeq9OQ4DShMHtSlvw3HEkhJtk8kn6HUQDZ+HOuju1O0gxmSXuOYShHGZBLI1SeQfK6COQqTOGynvtAUskSn27fFD9MSqMaCkbEzOxLcsAKTLP7PSnTxguj//Dx4Oyh+4mVAaEUdIim6Yj/lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yheovrxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yheovrxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63EFC4CEED;
	Tue,  8 Jul 2025 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994080;
	bh=zqq/RihB88gTsVCpMezRj6jCm9USPl/XHC73x1NEJUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yheovrxBT6uTM2QEzKnCSVADc2DYN0DjZpD0Jab/Oo/hQ8DXzI38NaGMZg5GScJh7
	 PjnSnSq3oKCoh5pZAn68GTlHNU1q1/aY31yU4o6d+mc7aLLEgQCrIN+ZCUi1CcHguY
	 l0MF8pie85Dx2XW1whkora0LhIigy4Qc5hT5G8DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/160] igc: disable L1.2 PCI-E link substate to avoid performance issue
Date: Tue,  8 Jul 2025 18:22:36 +0200
Message-ID: <20250708162234.746904089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit 0325143b59c6c6d79987afc57d2456e7a20d13b7 ]

I226 devices advertise support for the PCI-E link L1.2 substate. However,
due to a hardware limitation, the exit latency from this low-power state
is longer than the packet buffer can tolerate under high traffic
conditions. This can lead to packet loss and degraded performance.

To mitigate this, disable the L1.2 substate. The increased power draw
between L1.1 and L1.2 is insignificant.

Fixes: 43546211738e ("igc: Add new device ID's")
Link: https://lore.kernel.org/intel-wired-lan/15248b4f-3271-42dd-8e35-02bfc92b25e1@intel.com
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 4186e5732f972..f52c1674d19bd 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6549,6 +6549,10 @@ static int igc_probe(struct pci_dev *pdev,
 	adapter->port_num = hw->bus.func;
 	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 
+	/* Disable ASPM L1.2 on I226 devices to avoid packet loss */
+	if (igc_is_device_id_i226(hw))
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
+
 	err = pci_save_state(pdev);
 	if (err)
 		goto err_ioremap;
@@ -6914,6 +6918,9 @@ static int __maybe_unused igc_resume(struct device *dev)
 	pci_enable_wake(pdev, PCI_D3hot, 0);
 	pci_enable_wake(pdev, PCI_D3cold, 0);
 
+	if (igc_is_device_id_i226(hw))
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
+
 	if (igc_init_interrupt_scheme(adapter, true)) {
 		netdev_err(netdev, "Unable to allocate memory for queues\n");
 		return -ENOMEM;
@@ -7029,6 +7036,9 @@ static pci_ers_result_t igc_io_slot_reset(struct pci_dev *pdev)
 		pci_enable_wake(pdev, PCI_D3hot, 0);
 		pci_enable_wake(pdev, PCI_D3cold, 0);
 
+		if (igc_is_device_id_i226(hw))
+			pci_disable_link_state_locked(pdev, PCIE_LINK_STATE_L1_2);
+
 		/* In case of PCI error, adapter loses its HW address
 		 * so we should re-assign it here.
 		 */
-- 
2.39.5



