Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F5F29ACCD;
	Sat, 14 Feb 2026 21:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104412; cv=none; b=jze0nXMVqxAVprC/zOT8Jj4dGOytAt4H3ft8rgNQc/kUvhcNWPGe56LIrYnaPxDzGlaTieeWzLRWkeBz8INItOT0nZOD1XgOpkfIex60aJ/0pdxFi6iO+Z1va6b3B4glCJnwAwWQ+Ke3x5fWUj+74FaA38gCvHX51sZhBPfb5rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104412; c=relaxed/simple;
	bh=spBe1UGw1ARs3IgEvRYC5YF/E9lmPPeTNpVViA6Fnso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeU9RFfwRtZ0WbhwaQSbinVb2IqBkkPcOx6dAsZUm59JPc3Ohcu22Bw59aWIxi44C5ep7v19lucZZUQDQ1S8boxwGm/xc5jQTGsK2inI5R03QyjYB0BerSoe4GBVVEXi4NiNnqj9wztWzoZrovf2evjpRv9zBAvfl4KxT4amvv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWr7AfVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWr7AfVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B97C19422;
	Sat, 14 Feb 2026 21:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104411;
	bh=spBe1UGw1ARs3IgEvRYC5YF/E9lmPPeTNpVViA6Fnso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWr7AfVPmprttSt+USWUPrqGCX3tmWTVeMrFEOY6HPamGPxjqDCLFYwspQ/FSRn3i
	 BI0DuJOlELKE+r28nR9JNRz893j5tp30EE4QkIFVFINPpr6CGZdzxwekKbrBo2TER0
	 /axbeQxDsaUUFIzUXyaTmsdvam/CsJYflY+J6KkBJm0F+D5PTNAX79S+yPSodgEaL4
	 DVLw6Dzpu+28n7DBpN8BljxhM+uzA04xcNVQ81txIKwuyS2LWsWQq2h9XXzUzc9ATc
	 YjNFi0ZZb7DFHEq1QkOA5rCipapEMo/jv9PSdnWYbqVNSGq1dnAb/2qNPnFbJ4830X
	 JV4J+0bBk3m4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	heiko@sntech.de,
	cassel@kernel.org,
	18255117159@163.com,
	bhelgaas@google.com,
	yelangyan@huaqin.corp-partner.google.com,
	linux.amoon@gmail.com,
	nicolas.frattaroli@collabora.com,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.1] PCI: dw-rockchip: Disable BAR 0 and BAR 1 for Root Port
Date: Sat, 14 Feb 2026 16:23:34 -0500
Message-ID: <20260214212452.782265-69-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit b5d712e5b87fc56ff838684afb1bae359eb8069f ]

Some Rockchip PCIe Root Ports report bogus size of 1GiB for the BAR
memories and they cause below resource allocation issue during probe.

  pci 0000:00:00.0: [1d87:3588] type 01 class 0x060400 PCIe Root Port
  pci 0000:00:00.0: BAR 0 [mem 0x00000000-0x3fffffff]
  pci 0000:00:00.0: BAR 1 [mem 0x00000000-0x3fffffff]
  pci 0000:00:00.0: ROM [mem 0x00000000-0x0000ffff pref]
	...
  pci 0000:00:00.0: BAR 0 [mem 0x900000000-0x93fffffff]: assigned
  pci 0000:00:00.0: BAR 1 [mem size 0x40000000]: can't assign; no space
  pci 0000:00:00.0: BAR 1 [mem size 0x40000000]: failed to assign
  pci 0000:00:00.0: ROM [mem 0xf0200000-0xf020ffff pref]: assigned
  pci 0000:00:00.0: BAR 0 [mem 0x900000000-0x93fffffff]: releasing
  pci 0000:00:00.0: ROM [mem 0xf0200000-0xf020ffff pref]: releasing
  pci 0000:00:00.0: BAR 0 [mem 0x900000000-0x93fffffff]: assigned
  pci 0000:00:00.0: BAR 1 [mem size 0x40000000]: can't assign; no space
  pci 0000:00:00.0: BAR 1 [mem size 0x40000000]: failed to assign

Since there is no use of the Root Port BAR memories, disable both of them.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
[mani: reworded the description and comment]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/1766570461-138256-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Key Findings from Investigation

1. **`dw_pcie_writel_dbi2`** is a well-established helper available
   since 2023 (the static inline wrapper) with the underlying
   `dw_pcie_write_dbi2` available since 2019. It should be present in
   recent stable kernels.

2. **`dbi_base2` setup pattern**: The standard DWC code has a default
   fallback of `pci->dbi_base + SZ_4K` (4KB offset). However, the
   Rockchip hardware uses a different offset of `0x100000` (1MB). This
   commit explicitly sets `pci->dbi_base2 = pci->dbi_base +
   PCIE_TYPE0_HDR_DBI2_OFFSET` because the generic fallback would use
   the wrong offset for this hardware.

3. **The rockchip DWC driver** has been present since 2021, so it exists
   in all active stable trees.

### Risk vs. Benefit

**Benefit**: Fixes a real resource allocation failure during PCIe probe
on Rockchip platforms (RK3588 and potentially others). Without this fix,
BAR allocation consumes 2GiB of address space needlessly, potentially
causing downstream device BAR allocation failures. The log output
clearly shows "can't assign; no space" errors.

**Risk**: Very low. The fix:
- Only affects Rockchip DWC PCIe in host (Root Port) mode
- Disables BARs that are not used by the Root Port
- Uses well-established DWC infrastructure (`dw_pcie_writel_dbi2`)
- The DBI2 offset is hardware-specific and correct for this platform

### Potential Concern

One thing to verify is whether `dbi_base2` might already be set by the
generic DWC code before `rockchip_pcie_host_init` is called. If the
generic code sets it to `dbi_base + SZ_4K` first, this override to
`dbi_base + 0x100000` is essential for correctness. If it's not set at
all, then both the setup AND the BAR disable writes are needed.

### User Impact

- **Moderate-High**: RK3588 is a widely used ARM SoC in Single Board
  Computers (SBCs), NAS devices, and embedded systems. PCIe resource
  allocation failures directly impact users trying to use PCIe devices
  (NVMe SSDs, network cards, etc.) on these platforms.

### Stable Criteria Assessment

| Criteria | Assessment |
|----------|------------|
| Obviously correct and tested | Yes - simple BAR disable using standard
DWC mechanism |
| Fixes a real bug | Yes - bogus BAR sizes cause resource allocation
failures |
| Important issue | Yes - PCIe device failures on popular ARM platform |
| Small and contained | Yes - ~10 lines in one file |
| No new features | Correct - this is a hardware workaround |
| Applies cleanly | Likely yes for recent stable trees |

### Conclusion

This is a hardware quirk/workaround that fixes a real resource
allocation problem on Rockchip RK3588 PCIe Root Ports. The bogus 1GiB
BAR sizes waste address space and cause downstream device allocation
failures. The fix is small, well-scoped, uses existing infrastructure,
and only affects Rockchip platforms. It clearly falls into the "hardware
quirks" exception category that is explicitly appropriate for stable
backporting.

**YES**

 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index f8605fe61a415..c5f3c8935098f 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -80,6 +80,8 @@
 #define  PCIE_LINKUP_MASK		GENMASK(17, 16)
 #define  PCIE_LTSSM_STATUS_MASK		GENMASK(5, 0)
 
+#define PCIE_TYPE0_HDR_DBI2_OFFSET      0x100000
+
 struct rockchip_pcie {
 	struct dw_pcie pci;
 	void __iomem *apb_base;
@@ -292,6 +294,8 @@ static int rockchip_pcie_host_init(struct dw_pcie_rp *pp)
 	if (irq < 0)
 		return irq;
 
+	pci->dbi_base2 = pci->dbi_base + PCIE_TYPE0_HDR_DBI2_OFFSET;
+
 	ret = rockchip_pcie_init_irq_domain(rockchip);
 	if (ret < 0)
 		dev_err(dev, "failed to init irq domain\n");
@@ -302,6 +306,10 @@ static int rockchip_pcie_host_init(struct dw_pcie_rp *pp)
 	rockchip_pcie_configure_l1ss(pci);
 	rockchip_pcie_enable_l0s(pci);
 
+	/* Disable Root Ports BAR0 and BAR1 as they report bogus size */
+	dw_pcie_writel_dbi2(pci, PCI_BASE_ADDRESS_0, 0x0);
+	dw_pcie_writel_dbi2(pci, PCI_BASE_ADDRESS_1, 0x0);
+
 	return 0;
 }
 
-- 
2.51.0

