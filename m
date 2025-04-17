Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DE725A325;
	Thu, 17 Apr 2025 18:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912943; cv=none; b=ZTqbYZybWDIeBlmrXTwyFlF0yju97Z5xRv029Lozr4fhQzH8jhFUepOAZpoUaBOONkbo8VH1R2lbd89NDzN1FQLZqoUXAjvLtULBhZozr+w/RugTzaCNbgwwQjFFXVIQqb42s9GNUAtWpafQ/f60S73U+SOzpc/ot80MdxSdJW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912943; c=relaxed/simple;
	bh=WDFx3pazidk0Yix1WJBnl7LqcbRoT1feR1Z16fF+bwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJQS+Y45mR+qcOpVfssPPNFFqVYbZPdwyb82Q4zl3iR6Uhf7tZTn7jtfOWCWcKFmY3dN4qalk4yaw/JXQRH1LdFmIsi2kMJD3zfXqk72HBQOAGjDMpoDxx0VT4D8A7GrKMfTu4DwqS7S2YSveB014Mdza1od1SOE+i4mJU4+Axs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfcAvG1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfcAvG1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E534DC4CEEA;
	Thu, 17 Apr 2025 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912943;
	bh=WDFx3pazidk0Yix1WJBnl7LqcbRoT1feR1Z16fF+bwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfcAvG1TSv0v7lXuO344ZQ+mvrdhhSyo1jQ5enO63p0UfNot1NW52e4a/QI/P5KwM
	 G/pVS4Y8/J1PlOB/XPtXJ4tVjs3wpoqlAw/8EDR3GXMu+1c9UilBHHFoHozFd0mHAI
	 3msVZrHvtPKiPA59itcoPutip4u9cVkiwPXBxT3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 176/449] PCI: Enable Configuration RRS SV early
Date: Thu, 17 Apr 2025 19:47:44 +0200
Message-ID: <20250417175125.063862874@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 3f8c4959fc18e477801386a625e726c59f52a2c4 ]

Following a reset, a Function may respond to Config Requests with Request
Retry Status (RRS) Completion Status to indicate that it is temporarily
unable to process the Request, but will be able to process the Request in
the future (PCIe r6.0, sec 2.3.1).

If the Configuration RRS Software Visibility feature is enabled and a Root
Complex receives RRS for a config read of the Vendor ID, the Root Complex
completes the Request to the host by returning PCI_VENDOR_ID_PCI_SIG,
0x0001 (sec 2.3.2).

The Config RRS SV feature applies only to Root Ports and is not directly
related to pci_scan_bridge_extend().  Move the RRS SV enable to
set_pcie_port_type() where we handle other PCIe-specific configuration.

Link: https://lore.kernel.org/r/20250303210217.199504-1-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 0154b48bfbd7b..b4093f470d2d8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1373,8 +1373,6 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
 			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
 
-	pci_enable_rrs_sv(dev);
-
 	if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
 	    !is_cardbus && !broken) {
 		unsigned int cmax, buses;
@@ -1615,6 +1613,11 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pdev->pcie_cap = pos;
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
 	pdev->pcie_flags_reg = reg16;
+
+	type = pci_pcie_type(pdev);
+	if (type == PCI_EXP_TYPE_ROOT_PORT)
+		pci_enable_rrs_sv(pdev);
+
 	pci_read_config_dword(pdev, pos + PCI_EXP_DEVCAP, &pdev->devcap);
 	pdev->pcie_mpss = FIELD_GET(PCI_EXP_DEVCAP_PAYLOAD, pdev->devcap);
 
@@ -1631,7 +1634,6 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	 * correctly so detect impossible configurations here and correct
 	 * the port type accordingly.
 	 */
-	type = pci_pcie_type(pdev);
 	if (type == PCI_EXP_TYPE_DOWNSTREAM) {
 		/*
 		 * If pdev claims to be downstream port but the parent
-- 
2.39.5



