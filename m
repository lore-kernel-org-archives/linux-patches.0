Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD02D371067;
	Tue, 10 Mar 2026 11:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141065; cv=none; b=aEZesnCY20+YWlJY345GedCQcTK9dU2vXMVDDBxhqEtyg1UQ5JUnEZI+ODeVL+noKZ9f/zz8iXBEa5ShBT+tbr2Ina0QS0W8EUbhnNXMiRrth8Mn4zu73lVFlfxLcBV2Z2RYwoy4H5jPTwG/OMepLxRbpLnTBnvztYAavZTPZ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141065; c=relaxed/simple;
	bh=5ovp5jIBh7RSbJjMsir8riEpY21z/Csg0vjNaoi/Z04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGcLKBou8uQVI8B7LR/yVH0iUVXp6UWuoCrSHtx0U+DyvgS1uJbTtAq1qfLVpn3Y0kKRa8bMdxl9X3vF1YyWcvUYJI7WrTU3ndNNp5542DDWlSESiJgAy2L8W+l29Z6iVdATuXpzMLje+M2+ftTxkBKyKv6HD4i2Da1qVIDv3Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIKiK6y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIKiK6y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83B4C2BC86;
	Tue, 10 Mar 2026 11:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141065;
	bh=5ovp5jIBh7RSbJjMsir8riEpY21z/Csg0vjNaoi/Z04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIKiK6y7fFZ7vJsvzIvnLgNwo8z1bkslqTkbdszmTl85UBpCHFdHmxu+ksNqaEUD5
	 HM/uyOhJgBuvW2C1OxmDYGm/f47zf4LuRpuTNGp4c59yAybct1IKE+9vCc2xF4+9Rs
	 hkMci8ivdrCLIqiIABIhnqISt3o2ft/aZXbXNxZxrQlAy3Gu7+NE+CaGvwMGlyaUEj
	 KHARAJWxAOtUvhPpeMAKBO7k3foSHpvjUIieivd+nj1SsaHQfeHaK4N0gSus+PfACL
	 P0SKucnm6j4TH/4wBReVhhhEagtFuQWEiAMHsAeJeHL1DnMM1s5zz4TNNzcAeXnq64
	 4MNaNWlcV8blg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 065/311] PCI: dwc: ep: Refresh MSI Message Address cache on change
Date: Tue, 10 Mar 2026 07:01:52 -0400
Message-ID: <428fb33cba62d61b0f6cf4d2256845aa610b212f.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 468711a40d5dfc01bf0a24c1981246a2c93ac405 ]

Endpoint drivers use dw_pcie_ep_raise_msi_irq() to raise MSI interrupts to
the host.  After 8719c64e76bf ("PCI: dwc: ep: Cache MSI outbound iATU
mapping"), dw_pcie_ep_raise_msi_irq() caches the Message Address from the
MSI Capability in ep->msi_msg_addr.  But that Message Address is controlled
by the host, and it may change.  For example, if:

  - firmware on the host configures the Message Address and triggers an
    MSI,

  - a driver on the Endpoint raises the MSI via dw_pcie_ep_raise_msi_irq(),
    which caches the Message Address,

  - a kernel on the host reconfigures the Message Address and the host
    kernel driver triggers another MSI,

dw_pcie_ep_raise_msi_irq() notices that the Message Address no longer
matches the cached ep->msi_msg_addr, warns about it, and returns error
instead of raising the MSI.  The host kernel may hang because it never
receives the MSI.

This was seen with the nvmet_pci_epf_driver: the host UEFI performs NVMe
commands, e.g. Identify Controller to get the name of the controller,
nvmet-pci-epf posts the completion queue entry and raises an IRQ using
dw_pcie_ep_raise_msi_irq().  When the host boots Linux, we see a
WARN_ON_ONCE() from dw_pcie_ep_raise_msi_irq(), and the host kernel hangs
because the nvme driver never gets an IRQ.

Remove the warning when dw_pcie_ep_raise_msi_irq() notices that Message
Address has changed, remap using the new address, and update the
ep->msi_msg_addr cache.

Fixes: 8719c64e76bf ("PCI: dwc: ep: Cache MSI outbound iATU mapping")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Koichiro Den <den@valinux.co.jp>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260210181225.3926165-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-ep.c   | 22 +++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 59fd6ebf01489..77f27295b0a80 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -904,6 +904,19 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
 	 * supported, so we avoid reprogramming the region on every MSI,
 	 * specifically unmapping immediately after writel().
 	 */
+	if (ep->msi_iatu_mapped && (ep->msi_msg_addr != msg_addr ||
+				    ep->msi_map_size != map_size)) {
+		/*
+		 * The host changed the MSI target address or the required
+		 * mapping size changed. Reprogramming the iATU when there are
+		 * operations in flight is unsafe on this controller. However,
+		 * there is no unified way to check if we have operations in
+		 * flight, thus we don't know if we should WARN() or not.
+		 */
+		dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
+		ep->msi_iatu_mapped = false;
+	}
+
 	if (!ep->msi_iatu_mapped) {
 		ret = dw_pcie_ep_map_addr(epc, func_no, 0,
 					  ep->msi_mem_phys, msg_addr,
@@ -914,15 +927,6 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
 		ep->msi_iatu_mapped = true;
 		ep->msi_msg_addr = msg_addr;
 		ep->msi_map_size = map_size;
-	} else if (WARN_ON_ONCE(ep->msi_msg_addr != msg_addr ||
-				ep->msi_map_size != map_size)) {
-		/*
-		 * The host changed the MSI target address or the required
-		 * mapping size changed. Reprogramming the iATU at runtime is
-		 * unsafe on this controller, so bail out instead of trying to
-		 * update the existing region.
-		 */
-		return -EINVAL;
 	}
 
 	writel(msg_data | (interrupt_num - 1), ep->msi_mem + offset);
-- 
2.51.0

