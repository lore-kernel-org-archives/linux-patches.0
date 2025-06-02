Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B3421CA1E;
	Mon,  2 Jun 2025 14:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876041; cv=none; b=QU26sxLy0qd1WUuKFfmjVJ6QO4Nr8NwrUX615QX5371UlG8NV2nFXYghUQ7cDQr+tXfcvcJVCaRgYbqls8pYKzxVusZrzT8Gc+8Yd+5yVvHgwlxgnJOUJ8iX2EvajDB2i8EOYynI6FeRurMt3gb9ROZhxLiRNLT0a2ilIIazppA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876041; c=relaxed/simple;
	bh=9PuzkWJsLpjlJeseVI3zaSaj5sthibD3oQXnRJNsP+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5mvUtBew8tpxMGVNi5uw3O7AHkw5xzsnjF3rTA80lCjgvbYO9qSpaq5uOxo60Aq2ff7LID4cJnlEPQi7unaHc9Us8XAEUrC2ojuRp54kMv1zDR0G1rw+U20HIEvda9ICa3wl3fyqibva2ASsylUiwex/4He/PKjNSflFRPj1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpxlEj+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpxlEj+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD49C4CEEB;
	Mon,  2 Jun 2025 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876040;
	bh=9PuzkWJsLpjlJeseVI3zaSaj5sthibD3oQXnRJNsP+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpxlEj+Gf43UZKXkKUgamGRtVNqQb1gFw3c6PCYqUi0m/Rq0GAElJlw+EoJTs2nnz
	 TnLIotH/KEKPaN1SxKBYenB9I/Zn+/YcloLktVD/P2K0q8Du1lUZQh/2ZUn/ONVaSz
	 pxNlHaO7o6ipdl+lAtYO1gwEqVruDaFpS69u0zDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/207] PCI: dwc: ep: Ensure proper iteration over outbound map windows
Date: Mon,  2 Jun 2025 15:46:33 +0200
Message-ID: <20250602134259.606633254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fc92d30a0ad99..5502751334cc6 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -267,7 +267,7 @@ static int dw_pcie_find_index(struct dw_pcie_ep *ep, phys_addr_t addr,
 	u32 index;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	for (index = 0; index < pci->num_ob_windows; index++) {
+	for_each_set_bit(index, ep->ob_window_map, pci->num_ob_windows) {
 		if (ep->outbound_addr[index] != addr)
 			continue;
 		*atu_index = index;
-- 
2.39.5



