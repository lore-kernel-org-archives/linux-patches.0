Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA1F22333B;
	Thu, 12 Dec 2024 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024909; cv=none; b=BrfpOYukDUHmQp9hrzTO2lc2wqCMbYAxxfkOLPsu2pP++0w6JQzJXGzhKn62rCJOPNz4iXUfhwWA/sN2VP/iSkE1FGmnOWh/z6QPbAINGec+4Bd00+Knvf/GXhwUZ34RCLZ8SjB6Og+CGSYGJFMuwnm4xFnm8iPSlLh/R0+JoWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024909; c=relaxed/simple;
	bh=bUgTT1fSOa9Ez8kJ3DQeXKPvDPXCGsp3uDeYJMCWpbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jQV521wjgXmnyPBtazqYfUQZ++FgF89vTH0i9sm3acTrAYjTZbfKOsYU6NlIyqczii2yG1dSYSfplTtpJgBJ/OW1aUQsODyoV0rPWYMrF016jPrOvtphQhlN80G20k98+ZS6zC1vPrye1od59FMgTM74s/rrWmnGhjS5kx7MWk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aloWmhCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aloWmhCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF671C4CECE;
	Thu, 12 Dec 2024 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024909;
	bh=bUgTT1fSOa9Ez8kJ3DQeXKPvDPXCGsp3uDeYJMCWpbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aloWmhCcnsr0nZ7RN8HgsrK4Jn07h60rK7smRS1pjwc1jrOlcKv8RCXK5kxlJLdZY
	 3H+vfM17rJKbeyy+f18T6P30zsTmmqPxK2FAvLn+PtRFJsu030ehn7i/oU0gpUbmHP
	 xvjMNICVSzyLFo4/hVUG43JQM5dKiBF+UkuhXBng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 453/459] PCI: rockchip-ep: Fix address translation unit programming
Date: Thu, 12 Dec 2024 16:03:11 +0100
Message-ID: <20241212144311.666770594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 64f093c4d99d797b68b407a9d8767aadc3e3ea7a upstream.

The Rockchip PCIe endpoint controller handles PCIe transfers addresses
by masking the lower bits of the programmed PCI address and using the
same number of lower bits masked from the CPU address space used for the
mapping. For a PCI mapping of <size> bytes starting from <pci_addr>,
the number of bits masked is the number of address bits changing in the
address range [pci_addr..pci_addr + size - 1].

However, rockchip_pcie_prog_ep_ob_atu() calculates num_pass_bits only
using the size of the mapping, resulting in an incorrect number of mask
bits depending on the value of the PCI address to map.

Fix this by introducing the helper function
rockchip_pcie_ep_ob_atu_num_bits() to correctly calculate the number of
mask bits to use to program the address translation unit. The number of
mask bits is calculated depending on both the PCI address and size of
the mapping, and clamped between 8 and 20 using the macros
ROCKCHIP_PCIE_AT_MIN_NUM_BITS and ROCKCHIP_PCIE_AT_MAX_NUM_BITS. As
defined in the Rockchip RK3399 TRM V1.3 Part2, Sections 17.5.5.1.1 and
17.6.8.2.1, this clamping is necessary because:

  1) The lower 8 bits of the PCI address to be mapped by the outbound
     region are ignored. So a minimum of 8 address bits are needed and
     imply that the PCI address must be aligned to 256.

  2) The outbound memory regions are 1MB in size. So while we can specify
     up to 63-bits for the PCI address (num_bits filed uses bits 0 to 5 of
     the outbound address region 0 register), we must limit the number of
     valid address bits to 20 to match the memory window maximum size (1
     << 20 = 1MB).

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Link: https://lore.kernel.org/r/20241017015849.190271-2-dlemoal@kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c |   18 +++++++++++++-----
 drivers/pci/controller/pcie-rockchip.h    |    4 ++++
 2 files changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -67,18 +67,26 @@ static void rockchip_pcie_clear_ep_ob_at
 			    ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR1(region));
 }
 
+static int rockchip_pcie_ep_ob_atu_num_bits(struct rockchip_pcie *rockchip,
+					    u64 pci_addr, size_t size)
+{
+	int num_pass_bits = fls64(pci_addr ^ (pci_addr + size - 1));
+
+	return clamp(num_pass_bits,
+		     ROCKCHIP_PCIE_AT_MIN_NUM_BITS,
+		     ROCKCHIP_PCIE_AT_MAX_NUM_BITS);
+}
+
 static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
 					 u32 r, u32 type, u64 cpu_addr,
 					 u64 pci_addr, size_t size)
 {
-	u64 sz = 1ULL << fls64(size - 1);
-	int num_pass_bits = ilog2(sz);
+	int num_pass_bits;
 	u32 addr0, addr1, desc0, desc1;
 	bool is_nor_msg = (type == AXI_WRAPPER_NOR_MSG);
 
-	/* The minimal region size is 1MB */
-	if (num_pass_bits < 8)
-		num_pass_bits = 8;
+	num_pass_bits = rockchip_pcie_ep_ob_atu_num_bits(rockchip,
+							 pci_addr, size);
 
 	cpu_addr -= rockchip->mem_res->start;
 	addr0 = ((is_nor_msg ? 0x10 : (num_pass_bits - 1)) &
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -241,6 +241,10 @@
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MASK_MSI_CAP	BIT(24)
 #define ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR				0x1
 #define ROCKCHIP_PCIE_EP_FUNC_BASE(fn)	(((fn) << 12) & GENMASK(19, 12))
+
+#define ROCKCHIP_PCIE_AT_MIN_NUM_BITS  8
+#define ROCKCHIP_PCIE_AT_MAX_NUM_BITS  20
+
 #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR0(fn, bar) \
 	(PCIE_RC_RP_ATS_BASE + 0x0840 + (fn) * 0x0040 + (bar) * 0x0008)
 #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR1(fn, bar) \


