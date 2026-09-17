Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4C5326B1;
	Thu, 17 Sep 2026 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664521; cv=none; b=Whwjz567A/lBZesiiA65ZrZMo4z0Ikd2t9wwM6rYf6QDFseGBnwxfwa9YcYURbZnVXRybHDmwXz5xeWBVPHpDOEIOM6Xpk7wHPoh2emm4iw+JxH0L/s6MgUgvcytEn4NfbdBuL6RjS87s4PDNwqQFfSLrIXKegtL7WpKQ/6AdUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664521; c=relaxed/simple;
	bh=xODdbNPInZg4Pmbjmjjt0ZoOUIVaOUehnfs4v3Kb4i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdKmKaLBdGkb2YmsNfv70FhDRParNxma29nhmv5H9zYgsdtRK3lxXJ4xr4ljOQnqYTi/9aTJXYiFupZ+gtCqR8V5xvsSDMXOTh1OU/JC+SxBbi1v3M5fvKoByCsFW3xDXsuwMMypUM1IXkgT78QUAbnIKp9ZFfsD+mrn5FASzbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xj+ShSiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xj+ShSiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2113D1F000FF;
	Thu, 17 Sep 2026 17:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664519;
	bh=tMkhGBv5JnZcalZmqld6ViNMsbH5Iaq0+mtDCWVZIZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xj+ShSiMA1sBI37gGUXlwJWhBXRqRK+DsTDav5Ytl3xUbHF6PYJNX5CAKn/P9LPBD
	 rAunrDuBEluHDwUkhMzT1qR5csIFrX4GzIX8fWAmbcYHVbWOgMPyFRh4qzI1nVaBAN
	 jOwYnR3cAKCjyU5pJ+bItGvmEUDK0cpIGPjr5C/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0400/1250] Bluetooth: btintel_pcie: Add 50 ms delay before MAC init on BlazarIW
Date: Thu, 17 Sep 2026 16:03:15 +0100
Message-ID: <20260917151602.871310667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 4d62d88e7ae6dcecd9a8c70a045a6c6c64bf3b52 ]

On BlazarIW, fast restart cycles fail because the D0 entry to MAC
init does not complete in time. As a result, MAC initialization
does not proceed and the controller fails to transition past the
ROM boot stage.

Add a 50 ms delay (worst case as per HW analysis) before doing MAC
init in btintel_pcie_enable_bt() so the shared hardware reset flow
has time to complete. The delay is gated on the BlazarIW PCI device
id 0x4D76 so other Intel BT PCIe controllers are unaffected.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index d0aa1666d6ac6..c0441541c0862 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -740,6 +740,11 @@ static void btintel_pcie_dump_traces(struct hci_dev *hdev)
 		bt_dev_err(hdev, "Failed to dump traces: (%d)", ret);
 }
 
+static bool btintel_pcie_is_blazariw(struct pci_dev *pdev)
+{
+	return pdev->device == 0x4D76;
+}
+
 /* This function enables BT function by setting BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_INIT bit in
  * BTINTEL_PCIE_CSR_FUNC_CTRL_REG register and wait for MSI-X with
  * BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0.
@@ -759,6 +764,14 @@ static int btintel_pcie_enable_bt(struct btintel_pcie_data *data)
 	btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_CI_ADDR_MSB_REG,
 			      (u64)data->ci_p_addr >> 32);
 
+	/* On BlazarIW, the D0 entry to MAC init does not complete in
+	 * time. Wait 50 ms (worst case as per HW analysis) for the
+	 * shared hardware reset flow to complete before proceeding with
+	 * MAC init.
+	 */
+	if (btintel_pcie_is_blazariw(data->pdev))
+		msleep(50);
+
 	/* Reset the cached value of boot stage. it is updated by the MSI-X
 	 * gp0 interrupt handler.
 	 */
-- 
2.53.0



