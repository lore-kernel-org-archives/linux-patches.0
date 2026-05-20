Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C85346E5E;
	Wed, 20 May 2026 17:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297902; cv=none; b=dxO3hHKNgmOTGIyzWSWea5xV7HRmEKc0iHwEICp8EXSUhcCYdNhWp52Sw0htSPjTWaBxIFu9U8lZwgqf9UkEEE0OeqKucllsn9fXjtmoBVAfRIEbZJ6KfI0Y6p39UHOQVYdVMMLM8yGb3XfSc3oN3uMotYrAt5XuqYuf55+En5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297902; c=relaxed/simple;
	bh=oxoNwqNIwGUFzjs4iBtQ/34nrIHxt2C6FcvCpPDHknY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5niLg4FStTg55vDD/H/J1YCfdp4ajhYybinULY62REZwCUH0hJqc4i3intw5HPP+G5444FHzQGM13hk3W3oDgirGL6g1INSVqji9lywQ/WihfmgpEYgy3b78+ObRc+GKymWuvUP1+3N5HpUUTb+USWmpGrkOF9wsS6drSiREM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1PB2Mlj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1PB2Mlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DC11F000E9;
	Wed, 20 May 2026 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297901;
	bh=TOm2ldGxirDEl9oTdCCLs22idVyYkkceerwPqt73U1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1PB2MljA1QRJb6Ld580aA8SdurXjC4SrubTYzUukcXj8uP1XJOmYUqJxf+3su4Rz
	 arvfVlvFqWn2z9lLCZ5s4tXN6bhh6E3wFQrdK2koZyuXFMedegZqiFJ7vvB9AMrvaC
	 5ow8u50+bifr/x5qLw66kDDmCDdVpUpE0g8LlqoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/957] PCI: dwc: ep: Fix MSI-X Table Size configuration in dw_pcie_ep_set_msix()
Date: Wed, 20 May 2026 18:11:29 +0200
Message-ID: <20260520162139.010739392@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aksh Garg <a-garg7@ti.com>

[ Upstream commit 271d0b1f058ae9815e75233d04b23e3558c3e4f4 ]

In dw_pcie_ep_set_msix(), while updating the MSI-X Table Size value for
individual functions, Message Control register is read from the passed
function number register space using dw_pcie_ep_readw_dbi(), but always
written back to the Function 0's register space using dw_pcie_writew_dbi().
This causes incorrect MSI-X configuration for the rest of the functions,
other than Function 0.

Fix this by using dw_pcie_ep_writew_dbi() to write to the correct
function's register space, matching the read operation.

Fixes: 70fa02ca1446 ("PCI: dwc: Add dw_pcie_ep_{read,write}_dbi[2] helpers")
Signed-off-by: Aksh Garg <a-garg7@ti.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260224083817.916782-2-a-garg7@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index e2e18beb2951d..7350a703c4d19 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -538,7 +538,7 @@ static int dw_pcie_ep_set_msix(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 	val = dw_pcie_ep_readw_dbi(ep, func_no, reg);
 	val &= ~PCI_MSIX_FLAGS_QSIZE;
 	val |= nr_irqs - 1; /* encoded as N-1 */
-	dw_pcie_writew_dbi(pci, reg, val);
+	dw_pcie_ep_writew_dbi(ep, func_no, reg, val);
 
 	reg = ep_func->msix_cap + PCI_MSIX_TABLE;
 	val = offset | bir;
-- 
2.53.0



