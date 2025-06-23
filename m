Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F8D1E521E;
	Mon, 23 Jun 2025 21:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714013; cv=none; b=GPG5ReB9KRs+siWpVSLA1FQd+/jFlzHtzt9IYgJqzuvOFnSqRGVndNMAUoat1Xh/tyhbt5NhPHvjswNJYp+mncMKUyB/Pt+YorIGoB9UwkuWf76TECTZq0xKgnef0jE90MLgBacVzJKswboNlxlxhFZAH575Du9xOg85joFX+Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714013; c=relaxed/simple;
	bh=xRHKnhPpmsiOP7FL1IP+XJSt8nf7MQIVR4Vlx25N6z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv54yIgk4f7X3Bwy0Q8V6HLw4zeaekfuNYxDhH3fq1gBs8haROnHUadgxbCUJfWJgqjkCodiUxx5wzAZ+A4YctgJN+DKqIA7ja4Alxdw0ohbBeXNQlgK8xyEizdlCp2n7OO9sMB+SqPq8eFtyyPVxKX00E75/IfRh+ed+aZCjCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAjr5YKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAjr5YKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC82C4CEEA;
	Mon, 23 Jun 2025 21:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714013;
	bh=xRHKnhPpmsiOP7FL1IP+XJSt8nf7MQIVR4Vlx25N6z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAjr5YKUSXnGsVwxB3JuWDWEfNj13Py4U8a7vjKKxPZUuRRy4thmvQeBmPzoGNqha
	 s4zwJefkDRpX7tlfoUxVTqVHXJF7P9rEgTwpA9/d36Zr+FQLAQMjvW0/m/mYIRqsPF
	 1QOn76eo3WznbOP2/Aunyv+GJfw365cApwj1GKWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.6 108/290] PCI: cadence-ep: Correct PBA offset in .set_msix() callback
Date: Mon, 23 Jun 2025 15:06:09 +0200
Message-ID: <20250623130630.202103870@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

commit c8bcb01352a86bc5592403904109c22b66bd916e upstream.

While cdns_pcie_ep_set_msix() writes the Table Size field correctly (N-1),
the calculation of the PBA offset is wrong because it calculates space for
(N-1) entries instead of N.

This results in the following QEMU error when using PCI passthrough on a
device which relies on the PCI endpoint subsystem:

  failed to add PCI capability 0x11[0x50]@0xb0: table & pba overlap, or they don't fit in BARs, or don't align

Fix the calculation of PBA offset in the MSI-X capability.

[bhelgaas: more specific subject and commit log]

Fixes: 3ef5d16f50f8 ("PCI: cadence: Add MSI-X support to Endpoint driver")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250514074313.283156-10-cassel@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/cadence/pcie-cadence-ep.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/cadence/pcie-cadence-ep.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-ep.c
@@ -294,13 +294,14 @@ static int cdns_pcie_ep_set_msix(struct
 	struct cdns_pcie *pcie = &ep->pcie;
 	u32 cap = CDNS_PCIE_EP_FUNC_MSIX_CAP_OFFSET;
 	u32 val, reg;
+	u16 actual_interrupts = interrupts + 1;
 
 	fn = cdns_pcie_get_fn_from_vfn(pcie, fn, vfn);
 
 	reg = cap + PCI_MSIX_FLAGS;
 	val = cdns_pcie_ep_fn_readw(pcie, fn, reg);
 	val &= ~PCI_MSIX_FLAGS_QSIZE;
-	val |= interrupts;
+	val |= interrupts; /* 0's based value */
 	cdns_pcie_ep_fn_writew(pcie, fn, reg, val);
 
 	/* Set MSIX BAR and offset */
@@ -310,7 +311,7 @@ static int cdns_pcie_ep_set_msix(struct
 
 	/* Set PBA BAR and offset.  BAR must match MSIX BAR */
 	reg = cap + PCI_MSIX_PBA;
-	val = (offset + (interrupts * PCI_MSIX_ENTRY_SIZE)) | bir;
+	val = (offset + (actual_interrupts * PCI_MSIX_ENTRY_SIZE)) | bir;
 	cdns_pcie_ep_fn_writel(pcie, fn, reg, val);
 
 	return 0;


