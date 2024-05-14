Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAD7D531;
	Tue, 14 May 2024 10:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684211; cv=none; b=X2EJ9KCc7yEEeAHM3rsaSkBFOa7W/faw7nOAQrJrvDWBvm3DdyAfcjKTQ3i4tYOEHNlqjse9BELBKN68QfOLwQlOU1eXQyj7LJgEZdberFvV0pH9yCvCBYWAaFXeEUNB2NAwlKoUEJ/V2+k5KR3QqK9B0dbiaNTETrLwFiPm2MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684211; c=relaxed/simple;
	bh=RSV5Lq1PUi5zwKQxJfes3CuD8wzplEi9Zx+V0VeSC60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDuMFDKTZXY6sGPhcOpoCdgCYuwdsGAtIoQ+FmziJvj41w8YtSg9ZdmiocbWMFdJjIqcQCFrtxE6AqAPNA/+LJvK8ZBbGltUsrTC3gPkUyLTkozdx57Lue2X0A2s/0WCxgc3/oVRCYZtTZ1HTZ5PJeoeNvdHjKRIVMmstJULl44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeqC7yr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeqC7yr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E21C2BD10;
	Tue, 14 May 2024 10:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684211;
	bh=RSV5Lq1PUi5zwKQxJfes3CuD8wzplEi9Zx+V0VeSC60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeqC7yr6IRo0YL5WjhbVkeuBknm77TOlm/ucJsQaBvd9l/SMBcnBZEcnD7FMbj0W7
	 vZeo/EFNIN8++0ykYo269yVNHQc/hKIbaeNMEXVKCOzGXmeJo8PYUm2mgWXUYZ3U6G
	 UoQd3hAvKRTvHystbqeVl9H+tIcEpTkF1KHp0wiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.8 319/336] nvme-pci: Add quirk for broken MSIs
Date: Tue, 14 May 2024 12:18:43 +0200
Message-ID: <20240514101050.666103665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

commit d5887dc6b6c054d0da3cd053afc15b7be1f45ff6 upstream.

Sandisk SN530 NVMe drives have broken MSIs. On systems without MSI-X
support, all commands time out resulting in the following message:

nvme nvme0: I/O tag 12 (100c) QID 0 timeout, completion polled

These timeouts cause the boot to take an excessively-long time (over 20
minutes) while the initial command queue is flushed.

Address this by adding a quirk for drives with buggy MSIs. The lspci
output for this device (recorded on a system with MSI-X support) is:

02:00.0 Non-Volatile memory controller: Sandisk Corp Device 5008 (rev 01) (prog-if 02 [NVM Express])
	Subsystem: Sandisk Corp Device 5008
	Flags: bus master, fast devsel, latency 0, IRQ 16, NUMA node 0
	Memory at f7e00000 (64-bit, non-prefetchable) [size=16K]
	Memory at f7e04000 (64-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 3
	Capabilities: [90] MSI: Enable- Count=1/32 Maskable- 64bit+
	Capabilities: [b0] MSI-X: Enable+ Count=17 Masked-
	Capabilities: [c0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Device Serial Number 00-00-00-00-00-00-00-00
	Capabilities: [1b8] Latency Tolerance Reporting
	Capabilities: [300] Secondary PCI Express
	Capabilities: [900] L1 PM Substates
	Kernel driver in use: nvme
	Kernel modules: nvme

Cc: <stable@vger.kernel.org>
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/nvme.h |    5 +++++
 drivers/nvme/host/pci.c  |   14 +++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -162,6 +162,11 @@ enum nvme_quirks {
 	 * Disables simple suspend/resume path.
 	 */
 	NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND	= (1 << 20),
+
+	/*
+	 * MSI (but not MSI-X) interrupts are broken and never fire.
+	 */
+	NVME_QUIRK_BROKEN_MSI			= (1 << 21),
 };
 
 /*
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2218,6 +2218,7 @@ static int nvme_setup_irqs(struct nvme_d
 		.priv		= dev,
 	};
 	unsigned int irq_queues, poll_queues;
+	unsigned int flags = PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY;
 
 	/*
 	 * Poll queues don't need interrupts, but we need at least one I/O queue
@@ -2241,8 +2242,10 @@ static int nvme_setup_irqs(struct nvme_d
 	irq_queues = 1;
 	if (!(dev->ctrl.quirks & NVME_QUIRK_SINGLE_VECTOR))
 		irq_queues += (nr_io_queues - poll_queues);
-	return pci_alloc_irq_vectors_affinity(pdev, 1, irq_queues,
-			      PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY, &affd);
+	if (dev->ctrl.quirks & NVME_QUIRK_BROKEN_MSI)
+		flags &= ~PCI_IRQ_MSI;
+	return pci_alloc_irq_vectors_affinity(pdev, 1, irq_queues, flags,
+					      &affd);
 }
 
 static unsigned int nvme_max_io_queues(struct nvme_dev *dev)
@@ -2471,6 +2474,7 @@ static int nvme_pci_enable(struct nvme_d
 {
 	int result = -ENOMEM;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
+	unsigned int flags = PCI_IRQ_ALL_TYPES;
 
 	if (pci_enable_device_mem(pdev))
 		return result;
@@ -2487,7 +2491,9 @@ static int nvme_pci_enable(struct nvme_d
 	 * interrupts. Pre-enable a single MSIX or MSI vec for setup. We'll
 	 * adjust this later.
 	 */
-	result = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (dev->ctrl.quirks & NVME_QUIRK_BROKEN_MSI)
+		flags &= ~PCI_IRQ_MSI;
+	result = pci_alloc_irq_vectors(pdev, 1, 1, flags);
 	if (result < 0)
 		goto disable;
 
@@ -3384,6 +3390,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
 				NVME_QUIRK_DISABLE_WRITE_ZEROES|
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x15b7, 0x5008),   /* Sandisk SN530 */
+		.driver_data = NVME_QUIRK_BROKEN_MSI },
 	{ PCI_DEVICE(0x1987, 0x5012),	/* Phison E12 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */


