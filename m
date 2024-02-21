Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43D469317;
	Wed, 21 Feb 2024 14:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524924; cv=none; b=Zi2Wwp4oj4z9lC0FTJ7IalOmTq7ccq/Ackj9cIC2zdPgDzlj3V4t4va3BZ4hNuLAzJ4ILcPaK98QoBrPPaxTSbpgGMGPTSrKmUS/2OWGvUaYAk7AZ7rnhiGSUYieOBHH8IGoAh4h9yrzS7W4WFAp6kTFXYgFyw+O4l40ggg40UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524924; c=relaxed/simple;
	bh=trWzmlhe8vPqDrO7AOt6UowKKcJ0P7HqCSUXtk/3TG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AqE9E5/000PSfTAb7Px4EEet/JqYEcCXAkQwQQ8Vnzc5y7Sf/e/XksgwLubvFjD00XALr9l0CA9V9xnCxiA9hB1Fi0e/ZKayLGqq/CbPP20N8Mro3MVNH/uItPJgL+mcfoUwQ6qXNF3ud2/edJbiSiUHbKFWj4g0C32kli76Ilk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7q94lpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7q94lpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D194C433C7;
	Wed, 21 Feb 2024 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524923;
	bh=trWzmlhe8vPqDrO7AOt6UowKKcJ0P7HqCSUXtk/3TG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7q94lpZAQsgp1IdmKH0HB0TWh+h3R726WuhR+oHvO1vd4601uiMTuM9y8yjRGmty
	 yLTLOXzh54qNDR4sI+Fkr329qZivXhq+k5XluHy/rwlyB0Kyscxp8HwbaP9W3zqczw
	 YliOure3mQGHjZJGD+ayRUNLQF+Qw8BnWSp0XJbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.10 379/379] PCI: dwc: Fix a 64bit bug in dw_pcie_ep_raise_msix_irq()
Date: Wed, 21 Feb 2024 14:09:18 +0100
Message-ID: <20240221130006.272252883@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit b5d1b4b46f856da1473c7ba9a5cdfcb55c9b2478 upstream.

The "msg_addr" variable is u64.  However, the "aligned_offset" is an
unsigned int.  This means that when the code does:

  msg_addr &= ~aligned_offset;

it will unintentionally zero out the high 32 bits.  Use ALIGN_DOWN() to do
the alignment instead.

Fixes: 2217fffcd63f ("PCI: dwc: endpoint: Fix dw_pcie_ep_raise_msix_irq() alignment support")
Link: https://lore.kernel.org/r/af59c7ad-ab93-40f7-ad4a-7ac0b14d37f5@moroto.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -6,6 +6,7 @@
  * Author: Kishon Vijay Abraham I <kishon@ti.com>
  */
 
+#include <linux/kernel.h>
 #include <linux/of.h>
 
 #include "pcie-designware.h"
@@ -593,7 +594,7 @@ int dw_pcie_ep_raise_msix_irq(struct dw_
 	}
 
 	aligned_offset = msg_addr & (epc->mem->window.page_size - 1);
-	msg_addr &= ~aligned_offset;
+	msg_addr = ALIGN_DOWN(msg_addr, epc->mem->window.page_size);
 	ret = dw_pcie_ep_map_addr(epc, func_no, ep->msi_mem_phys,  msg_addr,
 				  epc->mem->window.page_size);
 	if (ret)


