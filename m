Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C9012FF73;
	Tue, 23 Jan 2024 01:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971815; cv=none; b=eYAiyDKWuuppxCZYb+y/aU1EOLQkId+98Ew51hKnu0a5LSl0j8RMShZA8kQHW/DMsGngiOYiVqCn3zaCLi02RGVLGnRHMrzAKk0CvU2e5nil44m1o4npH/F+Sf0EFoQJhEToAMoTYLauzTJYG1cbwdRz+Pc25RZYpSuKPkFXbus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971815; c=relaxed/simple;
	bh=je5Tsq2XRTktAm8erw/ArwLc8XaONn/6uYve+v6vfyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2/WMB53XiFngJf1a8DCn/pr6D9OkrFHblShw9UVb3oc+D2TUwCl/n8fhNWZCaNj6AFIQOvLsXtSpKz55LbQmE9DcTgFIw+z6UxrZ21N7rH2dHkKJ0bfcDp3po2WHyfgDABNZ1njF6x3WVq7EW6hl8RbydaqLEVDj+5zQ0QQDp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hH7+cKZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hH7+cKZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62117C43390;
	Tue, 23 Jan 2024 01:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971815;
	bh=je5Tsq2XRTktAm8erw/ArwLc8XaONn/6uYve+v6vfyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hH7+cKZ/6S2hTCceQuPti5E9lSDEkrwqpCay2N7ztFGny7pn9shcsyh1ZX+tcOGjW
	 8Zrwz6Kw6rT9b38mXb4xX6QmDFi+qkX+Tq7O6Qnn9nEmkM2vOBq62xxbmyzbYSYd2d
	 asidVDLSM1odGbxn+/oOu030kIK5F7iWBTXlnewA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>
Subject: [PATCH 6.1 314/417] PCI: dwc: endpoint: Fix dw_pcie_ep_raise_msix_irq() alignment support
Date: Mon, 22 Jan 2024 15:58:02 -0800
Message-ID: <20240122235802.692374956@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <niklas.cassel@wdc.com>

commit 2217fffcd63f86776c985d42e76daa43a56abdf1 upstream.

Commit 6f5e193bfb55 ("PCI: dwc: Fix dw_pcie_ep_raise_msix_irq() to get
correct MSI-X table address") modified dw_pcie_ep_raise_msix_irq() to
support iATUs which require a specific alignment.

However, this support cannot have been properly tested.

The whole point is for the iATU to map an address that is aligned,
using dw_pcie_ep_map_addr(), and then let the writel() write to
ep->msi_mem + aligned_offset.

Thus, modify the address that is mapped such that it is aligned.
With this change, dw_pcie_ep_raise_msix_irq() matches the logic in
dw_pcie_ep_raise_msi_irq().

Link: https://lore.kernel.org/linux-pci/20231128132231.2221614-1-nks@flawful.org
Fixes: 6f5e193bfb55 ("PCI: dwc: Fix dw_pcie_ep_raise_msix_irq() to get correct MSI-X table address")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org # 5.7
Cc: Kishon Vijay Abraham I <kishon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -600,6 +600,7 @@ int dw_pcie_ep_raise_msix_irq(struct dw_
 	}
 
 	aligned_offset = msg_addr & (epc->mem->window.page_size - 1);
+	msg_addr &= ~aligned_offset;
 	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
 				  epc->mem->window.page_size);
 	if (ret)


