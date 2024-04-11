Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2B714D283;
	Thu, 11 Apr 2024 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831656; cv=none; b=dwX4Z7JmCZARgi4WHHHayNtQqzbBgxpeHr9gILzQRuq18/qJ5gU309QSypSKnfJ7tedmUXqrcRlnx1/gFqwmuSUoQMgrD7I58iitVg/aAqWo4OI0/uEr02wuBDfUvDud4QTt6tjAj3sVnyS8NRewlj3SjzSgyFUzWqMoX1j79vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831656; c=relaxed/simple;
	bh=G9nCqj7YyswIJhM8bkunLCgIHh6aZRUgpDUbODaxuR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSIXwDsfJ+HDGHu3lx6oZ7rGNzcqN1Y4hNIsZhoyIehUeqr24trUIVJF6E9fj/EZLWLAcjycqKfl/bpjelZ1lxBotFY/h6JKqjodAPqxF0pCv4PSHYFqxd/k3Qy4uSsv2iNPs/TR1S6b2u8tLatR4db0H6qI7DsToUsmFQl8h3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzvTIxkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzvTIxkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2486EC433C7;
	Thu, 11 Apr 2024 10:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831656;
	bh=G9nCqj7YyswIJhM8bkunLCgIHh6aZRUgpDUbODaxuR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzvTIxkmq+iVI9eZFj+34FeKq/wNTaL0isVY1PH3mCLEj7pTImJ6HVPlfsXZ2VFeA
	 zQbcpGvStajtISaRuDcr9E5NFl2p/jN5umpewDplk89qhCfrRaw+wiat+T2Dq9NY6R
	 rd5a+zC4e4ijxhCHQLkQGMZ1Yr1bAz8vWWJFSL8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/294] PCI/AER: Block runtime suspend when handling errors
Date: Thu, 11 Apr 2024 11:54:05 +0200
Message-ID: <20240411095438.155511174@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

[ Upstream commit 002bf2fbc00e5c4b95fb167287e2ae7d1973281e ]

PM runtime can be done simultaneously with AER error handling.  Avoid that
by using pm_runtime_get_sync() before and pm_runtime_put() after reset in
pcie_do_recovery() for all recovering devices.

pm_runtime_get_sync() will increase dev->power.usage_count counter to
prevent any possible future request to runtime suspend a device.  It will
also resume a device, if it was previously in D3hot state.

I tested with igc device by doing simultaneous aer_inject and rpm
suspend/resume via /sys/bus/pci/devices/PCI_ID/power/control and can
reproduce:

  igc 0000:02:00.0: not ready 65535ms after bus reset; giving up
  pcieport 0000:00:1c.2: AER: Root Port link has been reset (-25)
  pcieport 0000:00:1c.2: AER: subordinate device reset failed
  pcieport 0000:00:1c.2: AER: device recovery failed
  igc 0000:02:00.0: Unable to change power state from D3hot to D0, device inaccessible

The problem disappears when this patch is applied.

Link: https://lore.kernel.org/r/20240212120135.146068-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/err.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index a806dfd94586c..bb4febcf45ba1 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -13,6 +13,7 @@
 #define dev_fmt(fmt) "AER: " fmt
 
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -79,6 +80,18 @@ static int report_error_detected(struct pci_dev *dev,
 	return 0;
 }
 
+static int pci_pm_runtime_get_sync(struct pci_dev *pdev, void *data)
+{
+	pm_runtime_get_sync(&pdev->dev);
+	return 0;
+}
+
+static int pci_pm_runtime_put(struct pci_dev *pdev, void *data)
+{
+	pm_runtime_put(&pdev->dev);
+	return 0;
+}
+
 static int report_frozen_detected(struct pci_dev *dev, void *data)
 {
 	return report_error_detected(dev, pci_channel_io_frozen, data);
@@ -194,6 +207,8 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	else
 		bridge = pci_upstream_bridge(dev);
 
+	pci_walk_bridge(bridge, pci_pm_runtime_get_sync, NULL);
+
 	pci_dbg(bridge, "broadcast error_detected message\n");
 	if (state == pci_channel_io_frozen) {
 		pci_walk_bridge(bridge, report_frozen_detected, &status);
@@ -239,10 +254,15 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 		pcie_clear_device_status(bridge);
 		pci_aer_clear_nonfatal_status(bridge);
 	}
+
+	pci_walk_bridge(bridge, pci_pm_runtime_put, NULL);
+
 	pci_info(bridge, "device recovery successful\n");
 	return status;
 
 failed:
+	pci_walk_bridge(bridge, pci_pm_runtime_put, NULL);
+
 	pci_uevent_ers(bridge, PCI_ERS_RESULT_DISCONNECT);
 
 	/* TODO: Should kernel panic here? */
-- 
2.43.0



