Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E642175549;
	Wed,  3 Jul 2024 11:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005829; cv=none; b=Zx6A2l28kQTQ+HSbTn2XMTjDT6plUgfBcfr7OpHWwrSicTM5Nxlea3RbrlH6fAe7NPH+sGa2mIIklIlJIVQWr+cG0cF+UU7N+/X/+pktT4OR4NePwQPRWcphz14nKcrAWBwjBLaSRLUa8sprZYk+EiPdo/iNTQYnvcL4bzGj1PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005829; c=relaxed/simple;
	bh=QyHuENaLevlI3geqUvQYy3p/SQ9hiV9+vgO7ey2CtHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYeBsHeIKU7JVRxhYR/Exh2a8nBkT4YTAIaFRx3cICy+oJ37dg9xZD1wHSGmbqqZWqb23Zb52NC+ZcmeLtaLWoADkBxYyzll4PoJEwBML12hC9IOdx26UwzDgLtIDcNFqDEsYTTkoR8pGt7kkUnzFSo/usaWcwQ3tK4+It2GrTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7GB9h20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7GB9h20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE61BC2BD10;
	Wed,  3 Jul 2024 11:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005829;
	bh=QyHuENaLevlI3geqUvQYy3p/SQ9hiV9+vgO7ey2CtHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7GB9h20rNX+IrPdvXQ9knVRO16OJZgyyFX/5mOVtA8Q2ocXSftYTissnQYz/P8Mq
	 NfM8inQJgPOxA7p6tKQ7EAYOkkVEkmJta6wehdGc5FZMeRLNpucJUtBpezIoGKug5v
	 /FNCsyd150esh8VTuLQ1e4G9hot+ZZXNGxJIYWxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/356] dmaengine: ioat: Drop redundant pci_enable_pcie_error_reporting()
Date: Wed,  3 Jul 2024 12:39:05 +0200
Message-ID: <20240703102921.013565914@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit e32622f84ae289dc7a04e9f01cd62cb914fdc5c6 ]

pci_enable_pcie_error_reporting() enables the device to send ERR_*
Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
native"), the PCI core does this for all devices during enumeration, so the
driver doesn't need to do it itself.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this only controls ERR_* Messages from the device.  An ERR_*
Message may cause the Root Port to generate an interrupt, depending on the
AER Root Error Command register managed by the AER service driver.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230307192655.874008-2-helgaas@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 1b11b4ef6bd6 ("dmaengine: ioatdma: Fix leaking on version mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 373b8dac6c9ba..783d4e740f115 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -15,7 +15,6 @@
 #include <linux/workqueue.h>
 #include <linux/prefetch.h>
 #include <linux/dca.h>
-#include <linux/aer.h>
 #include <linux/sizes.h>
 #include "dma.h"
 #include "registers.h"
@@ -1382,15 +1381,11 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (is_skx_ioat(pdev))
 			device->version = IOAT_VER_3_2;
 		err = ioat3_dma_probe(device, ioat_dca_enabled);
-
-		if (device->version >= IOAT_VER_3_3)
-			pci_enable_pcie_error_reporting(pdev);
 	} else
 		return -ENODEV;
 
 	if (err) {
 		dev_err(dev, "Intel(R) I/OAT DMA Engine init failed\n");
-		pci_disable_pcie_error_reporting(pdev);
 		return -ENODEV;
 	}
 
@@ -1413,7 +1408,6 @@ static void ioat_remove(struct pci_dev *pdev)
 		device->dca = NULL;
 	}
 
-	pci_disable_pcie_error_reporting(pdev);
 	ioat_dma_remove(device);
 }
 
-- 
2.43.0



