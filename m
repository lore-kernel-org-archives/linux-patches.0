Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3E4221FBF;
	Mon,  2 Jun 2025 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873179; cv=none; b=dM9NMRAQWL+4Rf8thPMkPswtwOdmU6PniNtyDSeBv9+bgvgGLxaXQgMawj7fkIgDmY/B407shbfuYGPb0RcKw9G/ztvfZa2YaRYAp8So+kebwQ7Ven0RRvGwLGR8SUiwxZNYZXs1FqY9EdFw9oWXYXCTzbrL+9dBK4f+wTEAzJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873179; c=relaxed/simple;
	bh=8uct2s9PoQuwAf+c6L/Fx5IXXP/RQ4Xvd7xeWfVBfg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AK4MbJ3Bibg1wTt5lcY/8ngMgLHgLnQbMbeqRisuWyXSJ4r6MSsmRO5Ofh64n1rZehzNGcVv+8uXhRinPKLMRe9/VZvBcCt7n1oLy/hHyNB4KRcqe9vte7iky9t35VcNJC2TlzMQT92WKpLprNobOWvVaxOARti8fcceIYdXzLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3/YJJX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3/YJJX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46850C4CEEE;
	Mon,  2 Jun 2025 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873177;
	bh=8uct2s9PoQuwAf+c6L/Fx5IXXP/RQ4Xvd7xeWfVBfg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3/YJJX19Kwc7hFa41TEFOm6GHW612tibF8iD9Q3unfrkCulrS+mUcW7/H73ALuoI
	 cYHuHw+69SivLcYSaPlRAGvUfUFd7AafIKcujG08pAcot5FiL9aer/G6almcXHoWBr
	 IV5WsdkXjzfIHDuF9kaI4UIb21Efh3r2mTfNKrjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/444] PCI: dwc: ep: Ensure proper iteration over outbound map windows
Date: Mon,  2 Jun 2025 15:42:06 +0200
Message-ID: <20250602134343.442862793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit f3e1dccba0a0833fc9a05fb838ebeb6ea4ca0e1a ]

Most systems' PCIe outbound map windows have non-zero physical addresses,
but the possibility of encountering zero increased after following commit
("PCI: dwc: Use parent_bus_offset").

'ep->outbound_addr[n]', representing 'parent_bus_address', might be 0 on
some hardware, which trims high address bits through bus fabric before
sending to the PCIe controller.

Replace the iteration logic with 'for_each_set_bit()' to ensure only
allocated map windows are iterated when determining the ATU index from a
given address.

Link: https://lore.kernel.org/r/20250315201548.858189-12-helgaas@kernel.org
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index f2e5feba55267..26ad643fb4248 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -281,7 +281,7 @@ static int dw_pcie_find_index(struct dw_pcie_ep *ep, phys_addr_t addr,
 	u32 index;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	for (index = 0; index < pci->num_ob_windows; index++) {
+	for_each_set_bit(index, ep->ob_window_map, pci->num_ob_windows) {
 		if (ep->outbound_addr[index] != addr)
 			continue;
 		*atu_index = index;
-- 
2.39.5



