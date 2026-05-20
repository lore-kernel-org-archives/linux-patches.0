Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C2736A376;
	Wed, 20 May 2026 16:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295031; cv=none; b=tLdoXgTTIKnt2UjGJE0X8EKyiMddJk62T+Ahzg+dRZU9UtxJAjfs4AxoDonOKjzhXFdQGtTN3a2AyDEabfDIJuTdgDEXHARwfomc+Uco+QfS5ybAWkagNQSLGPVbN2HUCUYQBBpILavdecZKwxpc52qBNQtqZNm5d11hIput44Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295031; c=relaxed/simple;
	bh=VNe666gkcjVKC5/UO94CKsawOfPvfev6UHp6h3fyYVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDAnz132+upsXEj3hewc+pnAchnHYIGdUgLpIcJxops+5R+7KNbgBXTnikYAJOetCq+L0nk7p2w1w0MQ11ax3hgIfEC/4TzgA0gHIaR+1vUWm8W9thYKNcqIWGzKSjNWwvoIt+Y+60rCA/KLb4cFwip0AdQwtp61wBYwh+DzMkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3S9p7dq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3S9p7dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0254A1F00893;
	Wed, 20 May 2026 16:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295029;
	bh=0SRIPSg60bk7tq0gTSaQ1QfwHlKUYaAMaD20gIqcEvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3S9p7dqUkhKde+DCgxT0d1WCvgsPh2vDP3PxZ/4TDj024gtFkcnAquWS8R+UHweH
	 DLPpcQ8IQ/msc0lnqfPWEDp/42xz73nQsDwZzNbRBRBOHxX8SLoz1D9/oR7bCA7nDj
	 tu+79CBMQLJTKPG4HSyDbZAKyJm7cQPLVeNm6HR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0265/1146] PCI: dwc: ep: Fix MSI-X Table Size configuration in dw_pcie_ep_set_msix()
Date: Wed, 20 May 2026 18:08:35 +0200
Message-ID: <20260520162154.221927543@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index c57ae4d6c5c0e..10d6f53cf7bad 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -754,7 +754,7 @@ static int dw_pcie_ep_set_msix(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 	val = dw_pcie_ep_readw_dbi(ep, func_no, reg);
 	val &= ~PCI_MSIX_FLAGS_QSIZE;
 	val |= nr_irqs - 1; /* encoded as N-1 */
-	dw_pcie_writew_dbi(pci, reg, val);
+	dw_pcie_ep_writew_dbi(ep, func_no, reg, val);
 
 	reg = ep_func->msix_cap + PCI_MSIX_TABLE;
 	val = offset | bir;
-- 
2.53.0



