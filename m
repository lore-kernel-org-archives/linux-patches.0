Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E272814A091;
	Tue, 25 Jun 2024 10:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309627; cv=none; b=Vr+APNGzbfwf/KAPUqTxm2OQqsLSeP9eE4pZCRlo1SZzONKo541CugjEEVaxpa46vRM36waOawjdxRCKCvqz1WSViyWnddPf99VFXAQxzMtEcxmcevgEZijHOAO1wYLqPF/opTdBp3e80m9XOGtcyQMFOLmlNLKDJwTLOiZRl/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309627; c=relaxed/simple;
	bh=boSg2B+ydKr3hDErvjCnB8DZN/WaVpB80/r/JsNvawA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTmufJtMlPBt01ReroAgWzlTQ0cMxsuMbmHk+diBrDEyUli3133s2eiS+JZOQFFAD/Gvrnfq0TG14g9FwayL99GhYRd8QrDXxPpH9dWm2h8t2wpReaxmJL77S0yyTMSSg+mh7KlF4GLEPtYEWXuA8D/V3qwFdeWWiHHaYFySVgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eb39FsUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eb39FsUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E21C32781;
	Tue, 25 Jun 2024 10:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309626;
	bh=boSg2B+ydKr3hDErvjCnB8DZN/WaVpB80/r/JsNvawA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eb39FsUIGgkNHbfwmGlI6gWeJjeWN0COmcFcdoBrLE2gqKfMRVJThuliNsHM51Bax
	 84kS6dVmjRn5semTIyT9OUdBBt4z+xZ7Hnqc0MlrZ75Pd+ufwjxbD7JlnRBLM9uLlk
	 5dhOaAPaR1lh+nhKMjwqSkigtksVpIQ5IxDCeJ14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/131] dmaengine: ioat: Drop redundant pci_enable_pcie_error_reporting()
Date: Tue, 25 Jun 2024 11:33:55 +0200
Message-ID: <20240625085528.982798253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5d707ff635542..6ca62edf47bd7 100644
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
@@ -1380,15 +1379,11 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
 
@@ -1411,7 +1406,6 @@ static void ioat_remove(struct pci_dev *pdev)
 		device->dca = NULL;
 	}
 
-	pci_disable_pcie_error_reporting(pdev);
 	ioat_dma_remove(device);
 }
 
-- 
2.43.0



