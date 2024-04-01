Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DF38F5C;
	Mon,  1 Apr 2024 16:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989776; cv=none; b=dDj/CJsJlnOkpJiKzB/IKqnk37ifl56Iaqf74WoosZ3H7E+LjoB+eeRJoz0OYEwKBRbJ/VH/FZu5Y9pi2U9u4zxknLaRNGgDx5tDnq5EMA/otMH8ZrHEje1BXvxen2AyPqc1gav8VyTZBpvmByZfrFYdVSpbHHv8dNOt3hxascc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989776; c=relaxed/simple;
	bh=JRwAwOs3mXYhjGZlbuyEyn190Nz3eRBXrtm9i+8sCwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5F2jw+/Y4Mkk9hItN6Bt25/M7s/HArg1WACL+b5b2mcS1B5TbZ2oNnxH3ZpzDi/YIEw/2y93ouYb1hwpvvCggf5nYGCCwzgI8G4kBfP3yXDxGaT4nqjotmOJtM3Af6q5iGom5X6WL0s6pHGlKZ1Geei6SDdxe1sy3W/gHafA+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miwDqupw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miwDqupw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB9BC433F1;
	Mon,  1 Apr 2024 16:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989776;
	bh=JRwAwOs3mXYhjGZlbuyEyn190Nz3eRBXrtm9i+8sCwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miwDqupwYM2J2ou2pXQOCz+ZR/o5WZ4PWJVIwbap5DA5Dv80W2ZXh2AOlTnrZT15M
	 7xJ+k2uJM45LC0qGxtOrNARD/1pbQx+C22PiIr/xqex5K1S5eVyQX6jFLxl1AlE2nn
	 2psxgVheyRRLwUCmPMmA62rZfnrjgtiqoLv6aTjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/396] PCI: dwc: endpoint: Fix advertised resizable BAR size
Date: Mon,  1 Apr 2024 17:42:50 +0200
Message-ID: <20240401152551.526499316@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9d1f259fe3573..ad6516a3ae6ea 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -671,8 +671,13 @@ int dw_pcie_ep_init_complete(struct dw_pcie_ep *ep)
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
 
 	/*
-- 
2.43.0



