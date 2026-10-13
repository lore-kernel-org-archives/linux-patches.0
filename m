Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34924FD7A5;
	Tue, 13 Oct 2026 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892712; cv=none; b=W8HDEWMZPdOPQHr1nRc2e0yCGFqw1hAAx4v12MbYMajIciZxPl/PMZNfjFIqbFMluSWO179VHG0HcMaHnvCKqzqPhnZAuIIR1By90viBopDDZpA1WedBeogzVgyasaI7lD9GQWgFVC2xlxeUGSCNospN9uYPo6zli2vu7fX7c2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892712; c=relaxed/simple;
	bh=DHUpyeeorFkeJBnqeCHkvFrUyL7mbk1LzEyYFHVnk3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvEaloxgJUsTx4HgkbGIgss61hjKM76wE3XN9u1uLLF2aORKSkiE5OUQu/doEit87GOhhp0W9RtF/Kznttob9prK5QU/EFOFhqXcq7QJGuD9TVaunUNw9/gP30taUR8unOIH4GJbnPEA3B2pHie4UuizZXmwk4zynni9Z2C1nVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LypESb+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LypESb+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA33B1F00899;
	Tue, 13 Oct 2026 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892710;
	bh=b/gqNdILeaxOCg0F8IZCGWtgUv8oxYRWmf4TN9YD0HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LypESb+o41OyZo7LRbedAVIKAIekbJ/mKabrNpK4Oc4Y6LpOZArznijkDwLzXS76G
	 BZ4hZU/tAXJb2EcNeu7TGF+5pstujTmq6dx79MsDFziwNO6HphtvS2n9mS09ZvqGez
	 ph3/6X6aWQzfVfHRtYFLlm0SBPlWS74XonDwaAN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Scott Branden <scott.branden@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 262/281] bnxt_en: Re-write the BARs following any type of PCIe errors
Date: Tue, 13 Oct 2026 13:39:38 +0200
Message-ID: <20261013112901.499622304@linuxfoundation.org>
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

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 2e52da27096d9dbc487f303bbc10d44ad837a8c4 ]

Currently the driver zeroes the BARs only when fatal PCIe errors
are reported so that pci_restore_state() restores it.  However
firmware handles both fatal and non-fatal errors the same way when
it sees the slot reset resulting from the PCI_ERS_RESULT_NEED_RESET
return code from the driver.  This means that we must re-write the
BARs post recovery even during non-fatal errors.  Otherwise we will
see that every MMIO access returns all-ones and the firmware appears
dead.

Zero-out the BARs during PCIe error recovery regardless of type of
PCIe error, and make the wait after the hot reset unconditional.

Disable memory decode and bus mastering before rewriting the BARs so
the device doesn't decode a half-updated address, bailing out if
config space is still inaccessible.  Defer pci_enable_device() until
after the BAR rewrite and restore, so the device isn't re-enabled
while its BARs are still being rewritten, then re-enable the device
and re-assert bus mastering.  Guard the same Command register cleanup
on the re-enable failure path against an inaccessible device.

Skip re-enabling the device in bnxt_io_slot_reset() if it is already
enabled, so enable_cnt does not go unbalanced.  A concurrent
bnxt_fw_reset_task() can also be re-enabling the same device in its
ENABLE_DEV state, so guard that call the same way.

Fixes: f75d9a0aa967 ("bnxt_en: Re-write PCI BARs after PCI fatal error.")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261005204246.3822563-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 107 ++++++++++++----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |   1 -
 2 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5a2efb262b769..78583cee3414f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15505,7 +15505,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		if (test_and_clear_bit(BNXT_STATE_FW_ACTIVATE_RESET, &bp->state) &&
 		    !test_bit(BNXT_STATE_FW_ACTIVATE, &bp->state))
 			bnxt_dl_remote_reload(bp);
-		if (pci_enable_device(bp->pdev)) {
+		if (!pci_is_enabled(bp->pdev) && pci_enable_device(bp->pdev)) {
 			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
 			rc = -ENODEV;
 			goto fw_reset_abort;
@@ -17557,10 +17557,8 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
 	 * so we disable bus master to prevent any potential bad DMAs before
 	 * freeing kernel memory.
 	 */
-	if (state == pci_channel_io_frozen) {
-		set_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN, &bp->state);
+	if (state == pci_channel_io_frozen)
 		bnxt_fw_fatal_close(bp);
-	}
 
 	if (netif_running(netdev))
 		__bnxt_close_nic(bp, true, true);
@@ -17590,65 +17588,80 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 	struct bnxt *bp = netdev_priv(netdev);
 	int retry = 0;
 	int err = 0;
+	u16 cmd;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
-	if (test_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN, &bp->state)) {
-		/* After DPC, the chip should return CRS when the vendor ID
-		 * config register is read until it is ready.  On all chips,
-		 * this is not happening reliably so add a 5-second delay as a
-		 * workaround.
-		 */
-		msleep(5000);
-	}
+	/* After a PCIe hot reset, the chip should return CRS when the
+	 * vendor ID config register is read until it is ready.  On all
+	 * chips, this is not happening reliably so add a 5-second delay
+	 * as a workaround.
+	 */
+	msleep(5000);
 
 	netdev_lock(netdev);
 
-	if (pci_enable_device(pdev)) {
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	if (PCI_POSSIBLE_ERROR(cmd)) {
 		dev_err(&pdev->dev,
-			"Cannot re-enable PCI device after reset.\n");
-	} else {
-		pci_set_master(pdev);
-		/* Upon fatal error, our device internal logic that latches to
-		 * BAR value is getting reset and will restore only upon
-		 * rewriting the BARs.
-		 *
-		 * As pci_restore_state() does not re-write the BARs if the
-		 * value is same as saved value earlier, driver needs to
-		 * write the BARs to 0 to force restore, in case of fatal error.
-		 */
-		if (test_and_clear_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN,
-				       &bp->state))
-			bnxt_clear_bars(pdev);
-		pci_restore_state(pdev);
+			"PCI config space inaccessible after reset\n");
+		goto reset_exit;
+	}
 
-		bnxt_inv_fw_health_reg(bp);
-		bnxt_try_map_fw_health_reg(bp);
+	/* Upon PCIe error, our device internal logic that latches to
+	 * BAR value is getting reset and will restore only upon
+	 * rewriting the BARs.
+	 *
+	 * As pci_restore_state() does not re-write the BARs if the
+	 * value is same as saved value earlier, driver needs to
+	 * write the BARs to 0 to force restore.
+	 */
+	pci_clear_master(pdev);
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	cmd &= ~PCI_COMMAND_MEMORY;
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
 
-		/* In some PCIe AER scenarios, firmware may take up to
-		 * 10 seconds to become ready in the worst case.
-		 */
-		do {
-			err = bnxt_try_recover_fw(bp);
-			if (!err)
-				break;
-			retry++;
-		} while (retry < BNXT_FW_SLOT_RESET_RETRY);
+	bnxt_clear_bars(pdev);
+	pci_restore_state(pdev);
 
-		if (err) {
-			dev_err(&pdev->dev, "Firmware not ready\n");
-			goto reset_exit;
+	if (!pci_is_enabled(pdev) && pci_enable_device(pdev)) {
+		dev_err(&pdev->dev,
+			"Cannot re-enable PCI device after reset.\n");
+		pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+		if (!PCI_POSSIBLE_ERROR(cmd)) {
+			cmd &= ~(PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY);
+			pci_write_config_word(pdev, PCI_COMMAND, cmd);
 		}
+		goto reset_exit;
+	}
+	pci_set_master(pdev);
 
-		err = bnxt_hwrm_func_reset(bp);
+	bnxt_inv_fw_health_reg(bp);
+	bnxt_try_map_fw_health_reg(bp);
+
+	/* In some PCIe AER scenarios, firmware may take up to
+	 * 10 seconds to become ready in the worst case.
+	 */
+	do {
+		err = bnxt_try_recover_fw(bp);
 		if (!err)
-			result = PCI_ERS_RESULT_RECOVERED;
+			break;
+		retry++;
+	} while (retry < BNXT_FW_SLOT_RESET_RETRY);
 
-		/* IRQ will be initialized later in bnxt_io_resume */
-		bnxt_ulp_irq_stop(bp);
-		bnxt_clear_int_mode(bp);
+	if (err) {
+		dev_err(&pdev->dev, "Firmware not ready\n");
+		goto reset_exit;
 	}
 
+	err = bnxt_hwrm_func_reset(bp);
+	if (!err)
+		result = PCI_ERS_RESULT_RECOVERED;
+
+	/* IRQ will be initialized later in bnxt_io_resume */
+	bnxt_ulp_irq_stop(bp);
+	bnxt_clear_int_mode(bp);
+
 reset_exit:
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	bnxt_clear_reservations(bp, true);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4dbcd08ef7c32..a939f4ed10079 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2470,7 +2470,6 @@ struct bnxt {
 #define BNXT_STATE_ABORT_ERR	5
 #define BNXT_STATE_FW_FATAL_COND	6
 #define BNXT_STATE_DRV_REGISTERED	7
-#define BNXT_STATE_PCI_CHANNEL_IO_FROZEN	8
 #define BNXT_STATE_NAPI_DISABLED	9
 #define BNXT_STATE_FW_ACTIVATE		11
 #define BNXT_STATE_RECOVER		12
-- 
2.53.0



