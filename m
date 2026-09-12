Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49DE364059;
	Sat, 12 Sep 2026 08:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201726; cv=none; b=uoMYywDaJbY3fKL8zi+JO7Cwur2kKMMZ5jyAag5aEfDRWZXY1bIZ4QqlcWD+0RknKy2K2AdkqjbXhKB/utYfBuztOMMHiEctZLFPCITuY2Et6LUfn9X80GUFGeGeajfh8oDqft3n/02TPPrTQsyxVB8yW4+T1ElVnPFF/ktr2oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201726; c=relaxed/simple;
	bh=Je12Cx58+lI/3tD1qD4/gs5a2yRI9swrtXj/dJHFCfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUUAXUNtPBn5OKbgumumEAxvhAWy5uh/6Lyqv+nVtYqGwXdNmIW9+Tm3mQH3LqCeyy7RoHymd0aFcdrUVF/Ll4dz0jl2RhMujEE1mJ1FeXGKAh4xHReHx+Fp5mRm8sltc2tgSpeM56g2cyMp2Di9lXvcuqwlxbi4QI94ndYYev0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YunEwMbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YunEwMbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7BA1F000FF;
	Sat, 12 Sep 2026 08:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201725;
	bh=6b6dZQP5j90SN8pw9RhAIBglZbW93Q1I27rsVfikHr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YunEwMbWeoxky6QqpNg0A4FP/6mLs+rsClMendwHFwsKhMExZJSGJG3Z5iZbdHXGO
	 BbO1+XWN12pgeb/LYQO4cbtV7Xvnf8lMpi/qmk0PDJqIyfkY6br1ozvrbUunMMGpAf
	 bAA0TU9ddqU1VLwepjFTGN8tyTkSS2fLnVMl9KIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1003/1815] PCI: dwc: ep: Fix unmap potentially unmapping the wrong iATU
Date: Sat, 12 Sep 2026 08:45:53 +0200
Message-ID: <20260912065712.553408640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 9de09b807a1942d179ac5dbcb4982b5301dcc8fd ]

The MSI path in dw_pcie_ep_raise_msi_irq() keeps its outbound iATU window
mapped across writes as a cache. The MSI-X path in
dw_pcie_ep_raise_msix_irq() maps and unmaps a window around every write.
Both use the same local aperture, ep->msi_mem_phys, as the CPU side address
that the iATU translates to the host's MSI or MSI-X target.

If dw_pcie_ep_raise_msi_irq() has cached its mapping and
dw_pcie_ep_raise_msix_irq() is then called, dw_pcie_ep_map_addr() allocates
a fresh outbound window for the MSI-X target. It does not notice that
ep->msi_mem_phys is already mapped by the MSI window, because
dw_pcie_ep_outbound_atu() only looks for a free window and does not
deduplicate by address. The controller now has two iATU windows whose
outbound_addr[] entry equals ep->msi_mem_phys.

When dw_pcie_ep_raise_msix_irq() later calls dw_pcie_ep_unmap_addr() to
tear down its own window, the lookup in dw_pcie_find_index() walks
ob_window_map in ascending index order and returns the first match. That is
the MSI window, since it was mapped first. The MSI window is torn down, the
MSI-X window is left in place, and ep->msi_iatu_mapped is never cleared.
The next MSI writel() therefore takes the cached fast path, writes into an
aperture whose iATU has been disabled, and the interrupt is silently lost.

To fix this issue, unmap the cached MSI iATU in dw_pcie_ep_raise_msix_irq()
before the MSI-X map, and clear ep->msi_iatu_mapped so that the next MSI
writel() reprograms the window. This guarantees that at most one iATU
window maps ep->msi_mem_phys at any time, so the subsequent
dw_pcie_find_index() call unambiguously returns the MSI-X window.

Fixes: 8719c64e76bf ("PCI: dwc: ep: Cache MSI outbound iATU mapping")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-pci/20260729051542.DC2741F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260730133123.1420413-6-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 9e50c589b308f..0b915824963af 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -1127,6 +1127,17 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 		return -EPERM;
 	}
 
+	/*
+	 * ep->msi_iatu_mapped means that an MSI target address is cached,
+	 * unmap it first so that we can reuse ep->msi_mem_phys for MSI-X.
+	 */
+	if (ep->msi_iatu_mapped) {
+		/* flush posted write before unmap */
+		readl(ep->msi_mem + ep->msi_iatu_mapped_offset);
+		dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
+		ep->msi_iatu_mapped = false;
+	}
+
 	msg_addr = dw_pcie_ep_align_addr(epc, msg_addr, &map_size, &offset);
 	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
 				  map_size);
-- 
2.53.0



