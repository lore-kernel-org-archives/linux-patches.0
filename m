Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265A02E0910;
	Tue,  8 Jul 2025 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992329; cv=none; b=nqQH+QclVDseruCpzgaNrIH4fnr6eiOfiKzqUqyDkNPbLKNiJKud8+8cn79Hva6wbJ7eT9V7LI4dh4T1p4R39WXM+kMm9l2rVxLhoZDdkWL9REXdTWwyAAFWYSUgQ1fiithIzq1QIseH4gJ3Rn4Y0InmqyAnRmrcxC5FwAi6WU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992329; c=relaxed/simple;
	bh=wdXx79mwa0HtlKhBulvxZSlk1EW9VTmEWzp7oVNFXhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqzZjcEU1gU4Ysn1hgEdICpNkCYnsyJ+JYVtZVXlqGnY6+o/9aw9++/aB0RlW6mqqBDOto3IRAPY6hgyL9TcCXF7K6w0eXCzYXlCULg+U7OdtvcsT+49m3IyG1JRwTf0+WHuV/jjKFDe0ylNUohi8D+0b1XNciLvk/HTV8hTB0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvQK5Uog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvQK5Uog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F50C4CEED;
	Tue,  8 Jul 2025 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992329;
	bh=wdXx79mwa0HtlKhBulvxZSlk1EW9VTmEWzp7oVNFXhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvQK5Uog5yjetC1ejlfE1yuV4clN4pfhEkJ4vhEniwCl355hjdF2lW4oruwQnzr4I
	 edF2SRWGbp5HYpqZL8CVUVMDvho9brJUJpC/kty1tznf33As48hy9nbAkFb/XtyWUV
	 sVIv2OBK2z6az95b2Zt1sRH/BvmDoRAbCO0uRiUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/132] igc: disable L1.2 PCI-E link substate to avoid performance issue
Date: Tue,  8 Jul 2025 18:22:46 +0200
Message-ID: <20250708162232.269428071@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e2f5c4384455e..11543db4c47f0 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6772,6 +6772,10 @@ static int igc_probe(struct pci_dev *pdev,
 	adapter->port_num = hw->bus.func;
 	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 
+	/* Disable ASPM L1.2 on I226 devices to avoid packet loss */
+	if (igc_is_device_id_i226(hw))
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
+
 	err = pci_save_state(pdev);
 	if (err)
 		goto err_ioremap;
@@ -7144,6 +7148,9 @@ static int __maybe_unused igc_resume(struct device *dev)
 	pci_enable_wake(pdev, PCI_D3hot, 0);
 	pci_enable_wake(pdev, PCI_D3cold, 0);
 
+	if (igc_is_device_id_i226(hw))
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
+
 	if (igc_init_interrupt_scheme(adapter, true)) {
 		netdev_err(netdev, "Unable to allocate memory for queues\n");
 		return -ENOMEM;
@@ -7259,6 +7266,9 @@ static pci_ers_result_t igc_io_slot_reset(struct pci_dev *pdev)
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



