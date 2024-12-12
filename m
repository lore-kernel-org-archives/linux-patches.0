Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104BD2210DE;
	Thu, 12 Dec 2024 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025881; cv=none; b=gaVGptMcbPigi87mdnL4KlRSQtsT9BXyZre2kR6HieLrMY6HjrX1mlYYWnC1uUx/6k0rh2iDBf8FZGzh+q8Bnei2jFEjMtLHQxJS4IWUv9jHxEikq5KDyyjJ8vtEPE5lzf0/M26wXvA2n//0wb9yhn6V8b9OE9RxNhEM5p413NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025881; c=relaxed/simple;
	bh=+BQXhf+vaVgEecLuVE/f17g+UdTHNsOAtXSg9zfHOuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AcWnYsVN73KC6KMctR721hq10Hh58YtKCqkaZrzL3sv5GnksU7Glo3jy+j1buYrHO7ZR8WpJgDj8l7XGqtzBDwHHrdF2qKX+0Zj0OjFht5xn1vTTz4WQ4qpbbwenzrN0yj89IlWY7v89v1Tzy+TznCm2eN1uWpX2mJOHbA6FioI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LviepFH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LviepFH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BA3C4CED0;
	Thu, 12 Dec 2024 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025880;
	bh=+BQXhf+vaVgEecLuVE/f17g+UdTHNsOAtXSg9zfHOuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LviepFH00Yw1Kxxnsc4m5g5kY1IXwsQZlh7YbZEDSvtOXh8yseaIHD96QGddoBatp
	 g7VmEZzNPHGrVmCcJ7xtfqo4mbPbJ5Dy2De4umsgdWBnb2UjPvhpYyzfm/FeOvWevL
	 0Dui5zLQILpzS2Vg6KqQSenDgIvFTUol6YQniN04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 319/321] PCI: rockchip-ep: Fix address translation unit programming
Date: Thu, 12 Dec 2024 16:03:57 +0100
Message-ID: <20241212144242.583095187@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -66,18 +66,26 @@ static void rockchip_pcie_clear_ep_ob_at
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


