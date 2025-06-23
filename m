Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B188136348;
	Mon, 23 Jun 2025 21:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715462; cv=none; b=u8O4xjaOGOQMD63OOFEa0pAbkLv6gy5GI3SEu7SuWERe7oV/JR4vKH47XEcJvjnOQ1St05ZsarHqMGtQJlNfIjDLN9P1LetWEqDlNzC70NySYBCpBcvDVOxCJsH+utVYJpaogM+vjhkUMxomt2O6c8lLkKIhpiQAEptM2Pk3fZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715462; c=relaxed/simple;
	bh=KikcGz6noxFYh49wNwNxfwSXU3CFHMqxuLdnDoEzk34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kpz8Ev721q5IvXI/JuLUWqJQ8u+i6NFES/Y/d2skHCkBq9dHQInEYB/aWjySdpy4RlacmU5pcWYzePbxb1SI+CG9wJTeXTWZHKkTk7C8Z5h2nw0wn4DBrPGnUziVkmCv8j9GAZ06u4WkIr9hjkDnX62JKN2n/LIYJeZDutieKkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucFuZkYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucFuZkYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E35C4CEEA;
	Mon, 23 Jun 2025 21:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715462;
	bh=KikcGz6noxFYh49wNwNxfwSXU3CFHMqxuLdnDoEzk34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucFuZkYfeLvGJRPJPT4MjWkx4X7JJlKulGVNpNZ47BjNDuVMS9u6uccHTRm5Rmnpw
	 l4MqQZIvEAKIiMbXyuYkLQjor1kqixObWzKsjiSpa+3OGNh7py2tTigKEXhqGvFRb4
	 9OeqL1bbr99XmMaSHKvCbcKqU+xzNB3KmNbJN4hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.15 254/411] PCI: cadence-ep: Correct PBA offset in .set_msix() callback
Date: Mon, 23 Jun 2025 15:06:38 +0200
Message-ID: <20250623130640.039865859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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


