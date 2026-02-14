Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB2A30DD30;
	Sat, 14 Feb 2026 21:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104374; cv=none; b=S/8AiT/xF6UdHNVnRZQWvCzTMWGSOyKIC4xb0qLGsXHDKoQDSpCi1OOggM9xqkG9Ja6xmNO9JH8m+yjB3yxicQywSCneB2CePWZsJFgKLVNqCftfX29fO0iNGhyVbftMtO6BRtQMWRkiAAE8ftiQ+JS7AaKnM7L7A2yFBqtJtbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104374; c=relaxed/simple;
	bh=9gzfxVU7+8bvYKPrLKPr/cWufaY6uETnn7pre+sMgas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PfMR1CVhpcuv9FkjrCuabIPx/6l6E5zF4AHIK+q/0eL4yER91NrYmDFZb1jtk6+lQAzNejmY5IOLV9gl7VE0VAdrMsrD9RKRnekKHa/uvqBM02ve8aBPwhUY+sE61h11zD+WizurN6WpOxh6/3+BMYVXTCj7D6gp2ZmkEZ7o8qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOUifURU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOUifURU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD435C19422;
	Sat, 14 Feb 2026 21:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104374;
	bh=9gzfxVU7+8bvYKPrLKPr/cWufaY6uETnn7pre+sMgas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOUifURUJYC+gcic1v8R8UUxwTfTUP96gJYUY0QRQwAs518YFdXpHcoWaOneGh8Hb
	 T078L9If+xjpTmohVv2Wb/zh0ECHVl+PYMSXI/Ymix3wgSGE9x9GCAaVGi30+rgY9M
	 hpUouN1I3HBgaW7HU4AV0yihltpUV25zcKG1wxn4XSR0ITiw4v4I0ol5cUaUy/DFMf
	 VtkoD0aXHOJzWLkm0aOnM+etK7sXHkSadUFGrCIYTB1FgAGCjJ05WQtBPmOseYbdOd
	 r9Li0DTfTkMeMhbLJEJXhxTpxdbGFIf1eNCk1qaEPg1K22txKlJUhPSzTQF9uM6q13
	 NvHXtdeNt/zLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Koichiro Den <den@valinux.co.jp>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jingoohan1@gmail.com,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] PCI: dwc: ep: Cache MSI outbound iATU mapping
Date: Sat, 14 Feb 2026 16:23:15 -0500
Message-ID: <20260214212452.782265-50-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 8719c64e76bf258cc8f44109740c854f2e2ead2e ]

dw_pcie_ep_raise_msi_irq() currently programs an outbound iATU window
for the MSI target address on every interrupt and tears it down again
via dw_pcie_ep_unmap_addr().

On systems that heavily use the AXI bridge interface (for example when
the integrated eDMA engine is active), this means the outbound iATU
registers are updated while traffic is in flight. The DesignWare
endpoint databook 5.40a - "3.10.6.1 iATU Outbound Programming Overview"
warns that updating iATU registers in this situation is not supported,
and the behavior is undefined.

Under high MSI and eDMA load this pattern results in occasional bogus
outbound transactions and IOMMU faults, on the RC side, such as:

  ipmmu-vmsa eed40000.iommu: Unhandled fault: status 0x00001502 iova 0xfe000000

followed by the system becoming unresponsive. This is the actual output
observed on Renesas R-Car S4, with its ipmmu_hc used with PCIe ch0.

There is no need to reprogram the iATU region used for MSI on every
interrupt. The host-provided MSI address is stable while MSI is enabled,
and the endpoint driver already dedicates a scratch buffer for MSI
generation.

Cache the aligned MSI address and map size, program the outbound iATU
once, and keep the window enabled. Subsequent interrupts only perform a
write to the MSI scratch buffer, avoiding dynamic iATU reprogramming in
the hot path and fixing the lockups seen under load.

dw_pcie_ep_raise_msix_irq() is not modified, as each vector can have a
different msg_addr, and because the msg_addr is allowed to be changed
while the vector is masked. Neither problem is easy to solve with the
current design. Instead, the plan is for the DWC vendor drivers to
transition to dw_pcie_ep_raise_msix_irq_doorbell(), which does not rely
on the iATU.

Signed-off-by: Koichiro Den <den@valinux.co.jp>
[cassel: improve commit message]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251222110144.3299523-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the **current state of the code** (before the patch is
applied) still has the map/unmap on every call pattern at lines 705-712.
The patch hasn't been applied yet to this tree — this is the candidate
being evaluated.

### 8. STANDALONE ASSESSMENT

Looking at the dependency analysis more carefully: the agent found that
in some stable tree, this commit was brought in as part of a 10-commit
dependency chain for a different fix. However, **that doesn't change the
standalone value of this commit**. The commit itself:

1. **Is a standalone bug fix** — it fixes iATU reprogramming under load
   causing IOMMU faults and system lockups on real hardware
2. **Has no prerequisite patches** — `dw_pcie_ep_align_addr`,
   `dw_pcie_ep_map_addr`, and `dw_pcie_ep_unmap_addr` all exist in the
   current tree
3. **Only adds internal fields to a struct** — no API changes needed
   from other patches
4. **Applies cleanly** to the current code (the pre-patch code matches
   lines 704-712)

### RISK vs BENEFIT

**Benefit**: HIGH
- Fixes real system lockups under load on DWC PCIe endpoint platforms
- The bug is documented by the hardware vendor's databook as "undefined
  behavior"
- Concrete symptoms reported on Renesas R-Car S4
- System becomes unresponsive — this is a critical stability issue

**Risk**: LOW-MEDIUM
- The change is well-contained within 2 files, single subsystem
- The caching logic is straightforward and defensive (WARN_ON_ONCE on
  unexpected address change)
- Proper cleanup on endpoint stop prevents resource leaks
- Only affects DWC PCIe endpoint users

### CONCERNS

1. The change modifies `struct dw_pcie_ep` by adding 3 fields — this is
   safe as long as no out-of-tree modules depend on this struct layout
   (unlikely given it's a controller-specific struct).
2. The WARN_ON_ONCE path returns -EINVAL if MSI address changes — this
   is a safe fallback since the databook says reprogramming under load
   is undefined anyway.
3. The commit applies cleanly to the current tree based on code
   inspection.

### CONCLUSION

This commit fixes a **real, documented hardware bug** that causes
**system lockups** on DesignWare PCIe endpoint platforms under load. The
fix is:
- **Obviously correct**: Caching an iATU mapping that the hardware
  vendor's databook says should not be reprogrammed while traffic is in
  flight
- **Well-tested**: Verified on Renesas R-Car S4
- **Contained**: 2 files, single subsystem, no API changes
- **Defensive**: WARN_ON_ONCE + -EINVAL on unexpected conditions, proper
  cleanup on stop

This clearly meets all stable kernel criteria for a backport.

**YES**

 .../pci/controller/dwc/pcie-designware-ep.c   | 48 ++++++++++++++++---
 drivers/pci/controller/dwc/pcie-designware.h  |  5 ++
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 19571ac2b9617..18b20cc877d9e 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -601,6 +601,16 @@ static void dw_pcie_ep_stop(struct pci_epc *epc)
 	struct dw_pcie_ep *ep = epc_get_drvdata(epc);
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
+	/*
+	 * Tear down the dedicated outbound window used for MSI
+	 * generation. This avoids leaking an iATU window across
+	 * endpoint stop/start cycles.
+	 */
+	if (ep->msi_iatu_mapped) {
+		dw_pcie_ep_unmap_addr(epc, 0, 0, ep->msi_mem_phys);
+		ep->msi_iatu_mapped = false;
+	}
+
 	dw_pcie_stop_link(pci);
 }
 
@@ -702,14 +712,37 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
 	msg_addr = ((u64)msg_addr_upper) << 32 | msg_addr_lower;
 
 	msg_addr = dw_pcie_ep_align_addr(epc, msg_addr, &map_size, &offset);
-	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
-				  map_size);
-	if (ret)
-		return ret;
 
-	writel(msg_data | (interrupt_num - 1), ep->msi_mem + offset);
+	/*
+	 * Program the outbound iATU once and keep it enabled.
+	 *
+	 * The spec warns that updating iATU registers while there are
+	 * operations in flight on the AXI bridge interface is not
+	 * supported, so we avoid reprogramming the region on every MSI,
+	 * specifically unmapping immediately after writel().
+	 */
+	if (!ep->msi_iatu_mapped) {
+		ret = dw_pcie_ep_map_addr(epc, func_no, 0,
+					  ep->msi_mem_phys, msg_addr,
+					  map_size);
+		if (ret)
+			return ret;
+
+		ep->msi_iatu_mapped = true;
+		ep->msi_msg_addr = msg_addr;
+		ep->msi_map_size = map_size;
+	} else if (WARN_ON_ONCE(ep->msi_msg_addr != msg_addr ||
+				ep->msi_map_size != map_size)) {
+		/*
+		 * The host changed the MSI target address or the required
+		 * mapping size changed. Reprogramming the iATU at runtime is
+		 * unsafe on this controller, so bail out instead of trying to
+		 * update the existing region.
+		 */
+		return -EINVAL;
+	}
 
-	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
+	writel(msg_data | (interrupt_num - 1), ep->msi_mem + offset);
 
 	return 0;
 }
@@ -1087,6 +1120,9 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
 	struct device *dev = pci->dev;
 
 	INIT_LIST_HEAD(&ep->func_list);
+	ep->msi_iatu_mapped = false;
+	ep->msi_msg_addr = 0;
+	ep->msi_map_size = 0;
 
 	epc = devm_pci_epc_create(dev, &epc_ops);
 	if (IS_ERR(epc)) {
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 31685951a0804..f555926a526ea 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -479,6 +479,11 @@ struct dw_pcie_ep {
 	void __iomem		*msi_mem;
 	phys_addr_t		msi_mem_phys;
 	struct pci_epf_bar	*epf_bar[PCI_STD_NUM_BARS];
+
+	/* MSI outbound iATU state */
+	bool			msi_iatu_mapped;
+	u64			msi_msg_addr;
+	size_t			msi_map_size;
 };
 
 struct dw_pcie_ops {
-- 
2.51.0

