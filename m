Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149192F39B1;
	Tue, 11 Nov 2025 01:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823250; cv=none; b=TTUP/V07kPDWeB6OOGUtu1cSEUlt93ZMgZgN9T+Ej4HXaWkNoFBe9RpnDb4PkkTD2pfUMsRhEfvcLPrXZ+ZnRSJtbg4LFHh6JLXhYCwOb6uXmdcMHsUQzYSzazqIzLp+PE8/fW9DWUzE2AGZj2ZSEIGRPsB8wQm5ZX5OLoKg43M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823250; c=relaxed/simple;
	bh=D+faEirknAYxywRG/WD8sWA0shdZREpYZa9FfwrPvaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gv9ljqUypTJ1WyN+LezOBnjGrn7P9uOM6SNaZmgPLP++0oPAl+DHazaFL1srPRx/qw58vtmLHON+nOlIOKUmGSx6ZWEGXI4Fz9vlSIls9kAGMkYmgCOrp21CDjmCyYZNl3u+2aQRIDzBChsfmx/XS8UCXxbuZCCERxbdA5hqx+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mm2ZBKwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mm2ZBKwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D03C4CEFB;
	Tue, 11 Nov 2025 01:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823249;
	bh=D+faEirknAYxywRG/WD8sWA0shdZREpYZa9FfwrPvaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm2ZBKwcGL7YbF4BYVj2g8e2dq1nZWMH2Bvds50bFpQIhSOPvk/3s0ThkpG4O/LdT
	 txK09W8ciRM7ABqRjA2tgfjjE8IGXdEm5eGmVj/JnuYw6s/zSnji4ujoc7RjMalBZ7
	 ByGrBnWSiWo/t8CZDRpKFsx6sA7OeDMR/wraaIl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/565] PCI/ERR: Update device error_state already after reset
Date: Tue, 11 Nov 2025 09:41:01 +0900
Message-ID: <20251111004531.538560849@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 45bc82563d5505327d97963bc54d3709939fa8f8 ]

After a Fatal Error has been reported by a device and has been recovered
through a Secondary Bus Reset, AER updates the device's error_state to
pci_channel_io_normal before invoking its driver's ->resume() callback.

By contrast, EEH updates the error_state earlier, namely after resetting
the device and before invoking its driver's ->slot_reset() callback.
Commit c58dc575f3c8 ("powerpc/pseries: Set error_state to
pci_channel_io_normal in eeh_report_reset()") explains in great detail
that the earlier invocation is necessitated by various drivers checking
accessibility of the device with pci_channel_offline() and avoiding
accesses if it returns true.  It returns true for any other error_state
than pci_channel_io_normal.

The device should be accessible already after reset, hence the reasoning
is that it's safe to update the error_state immediately afterwards.

This deviation between AER and EEH seems problematic because drivers
behave differently depending on which error recovery mechanism the
platform uses.  Three drivers have gone so far as to update the
error_state themselves, presumably to work around AER's behavior.

For consistency, amend AER to update the error_state at the same recovery
steps as EEH.  Drop the now unnecessary workaround from the three drivers.

Keep updating the error_state before ->resume() in case ->error_detected()
or ->mmio_enabled() return PCI_ERS_RESULT_RECOVERED, which causes
->slot_reset() to be skipped.  There are drivers doing this even for Fatal
Errors, e.g. mhi_pci_error_detected().

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/4517af6359ffb9d66152b827a5d2833459144e3f.1755008151.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 1 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c    | 2 --
 drivers/pci/pcie/err.c                              | 3 ++-
 drivers/scsi/qla2xxx/qla_os.c                       | 5 -----
 4 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index d7cdea8f604d0..91e7b38143ead 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -4215,7 +4215,6 @@ static pci_ers_result_t qlcnic_83xx_io_slot_reset(struct pci_dev *pdev)
 	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
 	int err = 0;
 
-	pdev->error_state = pci_channel_io_normal;
 	err = pci_enable_device(pdev);
 	if (err)
 		goto disconnect;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index b3588a1ebc25f..5e170400c61b9 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -3767,8 +3767,6 @@ static int qlcnic_attach_func(struct pci_dev *pdev)
 	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 
-	pdev->error_state = pci_channel_io_normal;
-
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 628d192de90b2..e277f3735fe65 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -141,7 +141,8 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
 
 	device_lock(&dev->dev);
 	pdrv = dev->driver;
-	if (!pdrv || !pdrv->err_handler || !pdrv->err_handler->slot_reset)
+	if (!pci_dev_set_io_state(dev, pci_channel_io_normal) ||
+	    !pdrv || !pdrv->err_handler || !pdrv->err_handler->slot_reset)
 		goto out;
 
 	err_handler = pdrv->err_handler;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 31535beaaa161..81c76678f25a8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7895,11 +7895,6 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	       "Slot Reset.\n");
 
 	ha->pci_error_state = QLA_PCI_SLOT_RESET;
-	/* Workaround: qla2xxx driver which access hardware earlier
-	 * needs error state to be pci_channel_io_online.
-	 * Otherwise mailbox command timesout.
-	 */
-	pdev->error_state = pci_channel_io_normal;
 
 	pci_restore_state(pdev);
 
-- 
2.51.0



