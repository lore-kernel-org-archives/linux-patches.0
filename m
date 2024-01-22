Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00C361673;
	Tue, 23 Jan 2024 01:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974936; cv=none; b=NgzjqnUr9g5yK+XMf+HbkCzZckbU7mdthhrh970yMESQ7MvDGrQlyZd+aySL6vwvIpi4rcqTZrSdK3kHXOyi1QH2bb7yZeRqXXJCIBL92vznoBs5lCaKf62JiDpZr53VQPX6I4GS5LhZI8h0+s6IE54CXrPLagz0xDBFg348/7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974936; c=relaxed/simple;
	bh=kDIjcYHUZTzRP7iqCCOce3XIpWUzJWEXAH2CpMnzmBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iwgimeHRtRz4sQISl2I1aMgleC+wp0/L25axJxmrWabItPsqEfwm2Tn8TNWB3sTIAfUQd94BYQw9GKiLPFYjqQt6/zWwvSErw6uZe2cEOdK84CoB1N8/+WgOCejiXfKz2YnPrCrv+EprLvzZLZF96sUW2bNYBzPbt4jXlaBVMC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oc4vyGFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oc4vyGFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7458CC43390;
	Tue, 23 Jan 2024 01:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974936;
	bh=kDIjcYHUZTzRP7iqCCOce3XIpWUzJWEXAH2CpMnzmBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oc4vyGFDTS6atE5FUWwWqP5eokW7BE/SV6qhATeeCit7QNDWbSvKJE63FvzeJdo3C
	 rpX9xyem1V5wRVGrVt4QPKBADzGTFhnNmqwJoAkIBgbE+thybMPTCWl2Mykb8En6aE
	 LIeWbzBI4mBGYKhgWu5OQzoD+VOyGRFSqXLgUB88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>
Subject: [PATCH 5.15 281/374] PCI: dwc: endpoint: Fix dw_pcie_ep_raise_msix_irq() alignment support
Date: Mon, 22 Jan 2024 15:58:57 -0800
Message-ID: <20240122235754.541847685@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -589,6 +589,7 @@ int dw_pcie_ep_raise_msix_irq(struct dw_
 	}
 
 	aligned_offset = msg_addr & (epc->mem->window.page_size - 1);
+	msg_addr &= ~aligned_offset;
 	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
 				  epc->mem->window.page_size);
 	if (ret)


