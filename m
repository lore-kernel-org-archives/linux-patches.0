Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB18340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301131; cv=none; b=ie93w5KfUNYrtMm200/bQzxzvYmnmnvcVUeSnKWNg/zRmNbOwX4IDLFG1S2Sk5RoEHfnLq5ZBb+nXcSd0ckBKT16OTlctS6qQXOvdNz1oJjisVuhmGkDw0fdq4igGpR4SzGJPwogHeg8/n0B/ijZne05fN6PoyLCRi6C54gu30Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301131; c=relaxed/simple;
	bh=ED31FqIejJkXzXn/3lOLWt2dv7853NRNj4AALhSBmjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3QJBWhshP+G4Zwld2mpqXyalk04Fi1a/KE4sxLKSAGfXhdkdfcT9sSSBobnkmV/ijBxjTFMSziTKxKLbR6k+gpsV6J3y70ZPev7TZYRe5fFtyBA82tNv/dEwhvMjxJ8KvcLrj5ZlUfJHp02gmBChitUUuR75QDPO3IK7puNC4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIdgCtPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIdgCtPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E298C19423;
	Sat, 28 Feb 2026 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301131;
	bh=ED31FqIejJkXzXn/3lOLWt2dv7853NRNj4AALhSBmjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIdgCtPcjjBfGe5a2N/VQwnESTzUOics/Gs/DImmOEQNIdz3gW3pecqe7xB2yG84C
	 UMxtmwhXyhzDIri+FW90hVHsCnsl+fVgrR/n9i3wiqEIO4ZHwb6huMJLh+cp0CNe3N
	 Wi8YuG0XlT8gM84wurDz6gDcE/pBLUs5AAm964fwKMwmrWSSLCIbSVJq2IJzYJ25yU
	 Oxmk+Raldb2u3P4DfcLJq9aCS3yGJN74WRUy9/eo1Duk0DJk85w3jM6StuBTZ+xKgf
	 ZrXVIdYk6olXQ+T7haVnkuZ9P2pzXy3zF/PSynQalWj0TRAhETtzV/CioHGBrk7drg
	 fsoxpfgjVvg0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lukas Wunner <lukas@wunner.de>,
	Lucas Van <lucas.van@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 290/752] PCI/AER: Clear stale errors on reporting agents upon probe
Date: Sat, 28 Feb 2026 12:40:01 -0500
Message-ID: <20260228174750.1542406-290-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit e242d09b58e869f86071b7889acace4cff215935 ]

Correctable and Uncorrectable Error Status Registers on reporting agents
are cleared upon PCI device enumeration in pci_aer_init() to flush past
events.  They're cleared again when an error is handled by the AER driver.

If an agent reports a new error after pci_aer_init() and before the AER
driver has probed on the corresponding Root Port or Root Complex Event
Collector, that error is not handled by the AER driver:  It clears the
Root Error Status Register on probe, but neglects to re-clear the
Correctable and Uncorrectable Error Status Registers on reporting agents.

The error will eventually be reported when another error occurs.  Which
is irritating because to an end user it appears as if the earlier error
has just happened.

Amend the AER driver to clear stale errors on reporting agents upon probe.

Skip reporting agents which have not invoked pci_aer_init() yet to avoid
using an uninitialized pdev->aer_cap.  They're recognizable by the error
bits in the Device Control register still being clear.

Reporting agents may execute pci_aer_init() after the AER driver has
probed, particularly when devices are hotplugged or removed/rescanned via
sysfs.  For this reason, it continues to be necessary that pci_aer_init()
clears Correctable and Uncorrectable Error Status Registers.

Reported-by: Lucas Van <lucas.van@intel.com> # off-list
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Lucas Van <lucas.van@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://patch.msgid.link/3011c2ed30c11f858e35e29939add754adea7478.1769332702.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 23bead9415fcd..29504173425cd 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1603,6 +1603,20 @@ static void aer_disable_irq(struct pci_dev *pdev)
 	pci_write_config_dword(pdev, aer + PCI_ERR_ROOT_COMMAND, reg32);
 }
 
+static int clear_status_iter(struct pci_dev *dev, void *data)
+{
+	u16 devctl;
+
+	/* Skip if pci_enable_pcie_error_reporting() hasn't been called yet */
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &devctl);
+	if (!(devctl & PCI_EXP_AER_FLAGS))
+		return 0;
+
+	pci_aer_clear_status(dev);
+	pcie_clear_device_status(dev);
+	return 0;
+}
+
 /**
  * aer_enable_rootport - enable Root Port's interrupts when receiving messages
  * @rpc: pointer to a Root Port data structure
@@ -1624,9 +1638,19 @@ static void aer_enable_rootport(struct aer_rpc *rpc)
 	pcie_capability_clear_word(pdev, PCI_EXP_RTCTL,
 				   SYSTEM_ERROR_INTR_ON_MESG_MASK);
 
-	/* Clear error status */
+	/* Clear error status of this Root Port or RCEC */
 	pci_read_config_dword(pdev, aer + PCI_ERR_ROOT_STATUS, &reg32);
 	pci_write_config_dword(pdev, aer + PCI_ERR_ROOT_STATUS, reg32);
+
+	/* Clear error status of agents reporting to this Root Port or RCEC */
+	if (reg32 & AER_ERR_STATUS_MASK) {
+		if (pci_pcie_type(pdev) == PCI_EXP_TYPE_RC_EC)
+			pcie_walk_rcec(pdev, clear_status_iter, NULL);
+		else if (pdev->subordinate)
+			pci_walk_bus(pdev->subordinate, clear_status_iter,
+				     NULL);
+	}
+
 	pci_read_config_dword(pdev, aer + PCI_ERR_COR_STATUS, &reg32);
 	pci_write_config_dword(pdev, aer + PCI_ERR_COR_STATUS, reg32);
 	pci_read_config_dword(pdev, aer + PCI_ERR_UNCOR_STATUS, &reg32);
-- 
2.51.0

