Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E271419AE;
	Tue, 27 Feb 2024 13:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041640; cv=none; b=PKqae7l8RwoLxcU73XplMvn1iJpgh4QpkiScH0F2RBlwBZn+E2Ap3UmNbOkiuMNgkzBaSGSYECAQhF7QjMyYTHmePX5zajw3uDxl7tPzOvtAp6XAqdo2jPRd9xvuOjXzRwfCZRlRxUz8vnQW0OEXyaf0/RiuCggZCYALxP5+QoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041640; c=relaxed/simple;
	bh=fk0srsabfFKssPzuZlsG06H+s40/Ap5oUBM8TwtSalU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adOVT6/gOXRWx1vYY+3ZMirgK05Ti4Pv688EtETSKiUYBk5/85DwvtI2ABzbO2FrADD5fqdGB9UIiWJrTwD349KMxVedQpVCw4ZjYqd1KRRgDFJfOlKltsfWVIZdadJONYA4s9xijk8v7rwFOUBFctNeeiizCs89Ca/qdmIU0IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/PkjiLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/PkjiLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6F5C433C7;
	Tue, 27 Feb 2024 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041640;
	bh=fk0srsabfFKssPzuZlsG06H+s40/Ap5oUBM8TwtSalU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/PkjiLXc2BeJ3j9vqweR8C84b3qleULOjoKwPAgTq3rcZoMBfaj1tg9iRR5dD7L+
	 YYIXT/pf1/Z/3ELDDtgHYzMyZj9GbD/te0hD1LQSH3oHL8My99r28ZqgmOKvZ8EsCo
	 yTuE+Yb820l2cpe0k6aEO19bAi7f/FkpIA6XN41A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.6 002/299] PCI: dwc: Fix a 64bit bug in dw_pcie_ep_raise_msix_irq()
Date: Tue, 27 Feb 2024 14:21:53 +0100
Message-ID: <20240227131625.927684742@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -6,6 +6,7 @@
  * Author: Kishon Vijay Abraham I <kishon@ti.com>
  */
 
+#include <linux/align.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
@@ -598,7 +599,7 @@ int dw_pcie_ep_raise_msix_irq(struct dw_
 	}
 
 	aligned_offset = msg_addr & (epc->mem->window.page_size - 1);
-	msg_addr &= ~aligned_offset;
+	msg_addr = ALIGN_DOWN(msg_addr, epc->mem->window.page_size);
 	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
 				  epc->mem->window.page_size);
 	if (ret)


