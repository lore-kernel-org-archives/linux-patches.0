Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68264F68CE;
	Tue, 13 Oct 2026 11:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892709; cv=none; b=YMks1Z6bN0MsDqvBlAbT1tvLkfTlxUU8qcR+NoMxA92ExSdXO31qDf0OA0OyQ+txHcWeAH9vAPY7caw2/SqLyk129sNcnMksSMuTq037U4xG7wSjsez3ov4rfPyPbmJKDnJXXnMjCx5qWTzv2oeUCakyphiS82TIj8+OrB8n60E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892709; c=relaxed/simple;
	bh=JHYplfPgeLwg0h/tsSyww7dBzjeojeFwgeeDDtjU3VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WH30OO9Nsk+2O0muo16ME07TYyQnZRhDsW7do931r/HNqn/A+nRY7l+I4iNVhP03a8EuY2kkMOFlk1SOxD1h9Ku3dJwrIW2pufKSSuMISVLbLRybI7U/YvfFQ+U8teaBmd/sSc/El9zTaa+U89Me95gi0V1b4jGTkSWr1ME1mIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0b42xcE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0b42xcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CD71F000FF;
	Tue, 13 Oct 2026 11:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892707;
	bh=74XOKIAhzKfXisAxwJlXrWvxjrKv+i8PHlE30/E2Vlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0b42xcEnOagx2DaRsywtcl6vR5Gh7br8EjbOaa0jgKd5OWAN6I0CRZFO/ZeC0wXb
	 rnLTDoIqxtAEXwnalFlQzVkIKHiX/DjJpbJkrSOAOmg7RtHJ72TaitswFWbgW/jLX1
	 IevM5Pl2mx6wKtISDzG9q5Z+Af8lFLwjBsV2/JXM=
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
Subject: [PATCH 7.2 261/281] bnxt_en: Fix driver init in kdump kernel
Date: Tue, 13 Oct 2026 13:39:37 +0200
Message-ID: <20261013112901.475525318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index da35fec65d1b0..5a2efb262b769 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -17074,6 +17074,43 @@ static void bnxt_clear_bars(struct pci_dev *pdev)
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
@@ -17089,12 +17126,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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



