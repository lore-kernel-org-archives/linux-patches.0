Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82791274FD3;
	Tue, 11 Nov 2025 01:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823390; cv=none; b=P20R3ofJUemOicDgPz0E95wOi2rlLiykZ+GaaunTSgMG+dcIEyj3TkIBQ9heZ3n0u0pdLtE6mB+FY1HdMQnY2qOcycYt1EB/iIMwLEa1IKAMsnIR9pD/ZP0BP3eEc+x4d/J8uaqO9S6TYwDNehdtbSMVi2cNwFE0MFEHtFnpGJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823390; c=relaxed/simple;
	bh=8OUXcERLeyWjGqFrByLVJ68rq9sr+uP9ZXwdS+cVsCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXHykdl9ipuHDVBAC9mzenXhfmIwtnF2J1qUwzdpNvgD68qTU+OpFxaHQkwI4Hzi3BJ3yowvmDElXRhoqOnAxyCmt8Zctre36sBii17HE65wFd9PqI+0IeP1fEKp8gFuxsAKASTXkVLCXcJKCu+cdP7n5Tm123f9giSZNwQ2TZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0iA6FVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0iA6FVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13F5C2BC87;
	Tue, 11 Nov 2025 01:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823390;
	bh=8OUXcERLeyWjGqFrByLVJ68rq9sr+uP9ZXwdS+cVsCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0iA6FVQ/VAZQTv0jzsk+zB8rDVrwnCkpTEt0LOsWlsY0Py8uD4auYNDPLVtHBVNX
	 9jaB8l/lBvYjritkSxJVKMBfBCkUDS/frXqtgw6ohiE4Xscn9twzLmIkDxzlRTfWrb
	 HiBKtiJznM/Bd5aUo+Iq4/dl1Gjsip/lHslo+qVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 291/849] PCI/ERR: Update device error_state already after reset
Date: Tue, 11 Nov 2025 09:37:41 +0900
Message-ID: <20251111004543.444053256@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 53cdd36c41236..e051d8c7a28d6 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -3766,8 +3766,6 @@ static int qlcnic_attach_func(struct pci_dev *pdev)
 	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 
-	pdev->error_state = pci_channel_io_normal;
-
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index a4990c9ad493a..e85b9cd5fec1b 100644
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
index d4b484c0fd9d7..4460421834cb2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7883,11 +7883,6 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
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



