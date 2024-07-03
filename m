Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33CE16F8FA;
	Wed,  3 Jul 2024 11:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004832; cv=none; b=al7XOdG1zNidkcGTOBf0koO+DaWEUV1Y1pz4CeSLl0Mi20+rwAbn3XE4CAUz8BNh5CkN1BCX0wD04+q+KrLY9aPmkRNMc1zf+ddUvf2ZlmofKS6mGzPPCsvu5PLV2GwKAsiB4J7Uvzk+i2JtQFDQqJqg532P5KaNvT9JX+QR20c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004832; c=relaxed/simple;
	bh=InWnOERKkmb2WIVWzdj6Z5E4CAUs2u29prvjmOhc/Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeXFkZ3xrvvT20JmzJWp764DyW1KdvXJ6RT6b22mux0BXOuHMToyFRAwUR8X8tCo1HcCR3Fgir5Q8cVkwyoofF8MYY2xYe4rEM7hMrEzK13Dkz9t5p9vc82fyou0XuqbHIPC6tx560bWcOePTRKcWR1OjR4ui1v0czrUsS/jhLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQcrV3fQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQcrV3fQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA39C2BD10;
	Wed,  3 Jul 2024 11:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004831;
	bh=InWnOERKkmb2WIVWzdj6Z5E4CAUs2u29prvjmOhc/Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQcrV3fQvLo53AxqEZd+3WW08Cq1Rh038M4SW4tFkjGdJt8z7VrEmCFGJtCEjKJBH
	 lCmMs+Hw2mvcv9f5YSlofb2euJNhoZdcoKoL2hg2+ynKGcnYKtikQUIGevPQcDwxNA
	 XnvDoOzBtvIKIYjaTixyZIdJ2r2ZJA12tnPkp+xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/290] dmaengine: ioat: Drop redundant pci_enable_pcie_error_reporting()
Date: Wed,  3 Jul 2024 12:38:57 +0200
Message-ID: <20240703102910.071650339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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



