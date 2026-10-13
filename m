Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B0B3D5C06;
	Tue, 13 Oct 2026 12:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894518; cv=none; b=JBlYppwwNLIz8hSHuwYmEbBYt71cRHXBrh2DPs1EaSlUmyYUeEhSAeKy2Y0/RhL3YY3o7HM+scGIo8VBH6vSPJPv+S7XTiqi6Go+YtvBW2T1CMsVTs9IDbbQETioOUrC6OE0bez6ypoP8J6rh6OASKPfg42dskHEV0VXbf1G7Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894518; c=relaxed/simple;
	bh=NZ+9AVnOuuSkVw7+9zg1fCavB6mBQbdWNIyZpyqQaXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyqOGZEIzAkcjNeQgks/hFjq8SpMTcAv6Y31G9TKXLFq02jpkVcKEmR4fLfxmBLSyZ8iWQsyIzYQ1FnVGIrgWH+98ETPJPOnT5gOEJhOmgjTvlVddtHDlO8AjCvNhNiVsyMNMMk/YkpAAGAVDzGUVRzXg9yhHxI1kmabh0erlbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA46b9gi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA46b9gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9261F000FF;
	Tue, 13 Oct 2026 12:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894517;
	bh=flxpEVI2eARSYo3ZjXEQQQS9DBNqLVAIb76oYajt1xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pA46b9giKoOD1J6l5pU8I2wdCPXq11Xyg/A3j3EeNzbMDREzwOwIO6ik9rkswWSnF
	 kS299vGUqAs/6YQ9Gmj4rh/JlpP2kwTDFXZs1+39Rdp06VM5PRjf8TBkqif1T1ZCGg
	 U3CxDT0oiXMDCcLx5sD7+M65nYQTe3Auf2xY1/Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 588/621] bnxt_en: Fix driver init in kdump kernel
Date: Tue, 13 Oct 2026 13:39:43 +0200
Message-ID: <20261013112934.756491761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 386f887c8290f0747dd0180e98ec7a82811bc506 ]

Fix and strengthen the FLR sequence when initializing in the kdump
kernel.  If the NIC is behind a PCIe switch in synthetic (smart)
mode, the switch may need to see that the BARs have been initialized
before it will pass mem read/write TLPs to the NIC.

On a Dell system with a PEX89144 PCIe switch, echo c > /proc/sysrq-trigger
will trigger fatal AER without this patch:

bnxt_en 0000:67:00.0: enabling device (0000 -> 0002)
[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 5
[Hardware Error]: event severity: recoverable
[Hardware Error]:  Error 0, type: fatal
[Hardware Error]:   section_type: PCIe error
[Hardware Error]:   port_type: 5, upstream switch port
...

Add a new bnxt_kdump_reset() to do the expanded FLR sequence in the
kdump kernel.  We now disable bus master and memory, save the PCI
state, do the FLR, clear the BARs, and restore the PCI state.  The
BARs have to be cleared to ensure that they get re-initialized and
visible to the PCIe switch.

Since it is the kdump kernel, we make every effort to continue in
the best possible way even if pci_save_state() or pcie_flr() returns
error.  After FLR, we poll for an additional 5 seconds before
aborting in case the device is not properly returning CRS.  This is
similar to the 5-second wait in bnxt_io_slot_reset().

Fixes: 8743db4a9acf ("bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261005204246.3822563-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 45 ++++++++++++++++++++---
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cb846b2435216..6758f9ad37775 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16840,6 +16840,43 @@ static void bnxt_clear_bars(struct pci_dev *pdev)
 		pci_write_config_dword(pdev, off, 0);
 }
 
+/* Clear any pending DMA transactions from crash kernel while loading driver in
+ * capture kernel.
+ */
+static int bnxt_kdump_reset(struct pci_dev *pdev)
+{
+	int rc, i;
+	u16 cmd;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	cmd &= ~(PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY);
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+
+	if (pci_save_state(pdev))
+		dev_warn(&pdev->dev, "Failed to save PCI state, PCI restore may be incomplete\n");
+
+	rc = pcie_flr(pdev);
+	if (rc)
+		dev_warn(&pdev->dev, "pcie_flr() failed (rc: %d), trying to continue\n",
+			 rc);
+
+	/* In case device is not returning CRS, wait 5 seconds longer */
+	for (i = 0; i < 50; i++) {
+		pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+		if (!PCI_POSSIBLE_ERROR(cmd))
+			break;
+		msleep(100);
+	}
+	if (PCI_POSSIBLE_ERROR(cmd)) {
+		dev_err(&pdev->dev, "PCI config space inaccessible after FLR, aborting\n");
+		return -ENODEV;
+	}
+
+	bnxt_clear_bars(pdev);
+	pci_restore_state(pdev);
+	return 0;
+}
+
 static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct bnxt_hw_resc *hw_resc;
@@ -16855,12 +16892,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-	/* Clear any pending DMA transactions from crash kernel
-	 * while loading driver in capture kernel.
-	 */
 	if (is_kdump_kernel()) {
-		pci_clear_master(pdev);
-		pcie_flr(pdev);
+		rc = bnxt_kdump_reset(pdev);
+		if (rc)
+			return rc;
 	}
 
 	max_irqs = bnxt_get_max_irq(pdev);
-- 
2.53.0



