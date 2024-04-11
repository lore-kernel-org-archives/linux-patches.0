Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AEB149E1A;
	Thu, 11 Apr 2024 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831665; cv=none; b=DCZI27xLyV7nyIDVCx5EzudjMV5Kk6r7f2WLDht0rBXa7Xmc488uFoQ+2yE619oJkkpjkU19DXf7ymLMuvBbJ6d+2hVD5Xj9PBcyx+o8LnhEMvJ0hTZebAVJ3i0wXGa7inkZ6eyCQnzFuqeQJtRASqe9Mo32Sqc1vXJD6xBTlM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831665; c=relaxed/simple;
	bh=MRifVy54QLdhGdeYzvigvNVvVSrUBGQsjaqiyr/VcD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MLhHeFpK4h2M7mBJ5txN2ee5RGkDPIVdjHz0ja7R79obZJexuWKwYyYYTYiyZgr4dT9xWswEJnC/Hmsjg4Z7EnmnnB8ytYnNp0u9I2IGAQZkXYRd2021Wg904lfUANhz+twEaRnvHYdhYauWUyiPwiCL6UhnBGv6rtSJjB0Wtms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2Ej2WDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2Ej2WDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9303C433F1;
	Thu, 11 Apr 2024 10:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831665;
	bh=MRifVy54QLdhGdeYzvigvNVvVSrUBGQsjaqiyr/VcD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2Ej2WDehq2Jlren+XMAJyQf24XzHYPLiIXWo8uQgQWXJIGMtldo4QjKrpixcMK9R
	 a1uMEpOtNz8nEGlmVLbuvMc2OumxouIF0VCQM6KbZ1q/6DT4v/Oc2BKRrOn7esn7U/
	 I1yuH2Yz+Xey7gLC/xCah6m5wZQ6UkIDtJXnBBBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/294] PCI: dwc: endpoint: Fix advertised resizable BAR size
Date: Thu, 11 Apr 2024 11:54:08 +0200
Message-ID: <20240411095438.243397852@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 72e34b8593e08a0ee759b7a038e0b178418ea6f8 ]

The commit message in commit fc9a77040b04 ("PCI: designware-ep: Configure
Resizable BAR cap to advertise the smallest size") claims that it modifies
the Resizable BAR capability to only advertise support for 1 MB size BARs.

However, the commit writes all zeroes to PCI_REBAR_CAP (the register which
contains the possible BAR sizes that a BAR be resized to).

According to the spec, it is illegal to not have a bit set in
PCI_REBAR_CAP, and 1 MB is the smallest size allowed.

Set bit 4 in PCI_REBAR_CAP, so that we actually advertise support for a
1 MB BAR size.

Before:
        Capabilities: [2e8 v1] Physical Resizable BAR
                BAR 0: current size: 1MB
                BAR 1: current size: 1MB
                BAR 2: current size: 1MB
                BAR 3: current size: 1MB
                BAR 4: current size: 1MB
                BAR 5: current size: 1MB
After:
        Capabilities: [2e8 v1] Physical Resizable BAR
                BAR 0: current size: 1MB, supported: 1MB
                BAR 1: current size: 1MB, supported: 1MB
                BAR 2: current size: 1MB, supported: 1MB
                BAR 3: current size: 1MB, supported: 1MB
                BAR 4: current size: 1MB, supported: 1MB
                BAR 5: current size: 1MB, supported: 1MB

Fixes: fc9a77040b04 ("PCI: designware-ep: Configure Resizable BAR cap to advertise the smallest size")
Link: https://lore.kernel.org/linux-pci/20240307111520.3303774-1-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@vger.kernel.org> # 5.2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 339318e790e21..8ed1df61f9c7c 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -662,8 +662,13 @@ int dw_pcie_ep_init_complete(struct dw_pcie_ep *ep)
 		nbars = (reg & PCI_REBAR_CTRL_NBAR_MASK) >>
 			PCI_REBAR_CTRL_NBAR_SHIFT;
 
+		/*
+		 * PCIe r6.0, sec 7.8.6.2 require us to support at least one
+		 * size in the range from 1 MB to 512 GB. Advertise support
+		 * for 1 MB BAR size only.
+		 */
 		for (i = 0; i < nbars; i++, offset += PCI_REBAR_CTRL)
-			dw_pcie_writel_dbi(pci, offset + PCI_REBAR_CAP, 0x0);
+			dw_pcie_writel_dbi(pci, offset + PCI_REBAR_CAP, BIT(4));
 	}
 
 	dw_pcie_setup(pci);
-- 
2.43.0



