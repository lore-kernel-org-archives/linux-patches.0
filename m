Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760603FB074;
	Wed, 20 May 2026 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300328; cv=none; b=OJQ3gXqKqu8hdhGyAJ552uFJKaAtIZpK2+diIECrP2khSQqqtz76FOiyz7wduXqzyOeoFJ0k7WBPEk56/3oaviEotjWBiTgLIk2HdaeedE4UyT5NX/kC7I0tHk6qowBvGASpjokUx3Ek05WswkvPN5tAqV4622FswOduH/kiIFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300328; c=relaxed/simple;
	bh=h+TgAyBxK2ioLSqww96xCLMxybpxj/GUYVA2JjaVnmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToPlfqJQj+s0cb85BFOE1LF2drjOyJe4YHRwakvVGaVxcDl6Q2lzZmgcJckrgPeoRxoFZYmYty+HsAuz2Z0YJfzu89NRXuHiomVPjdAYBe2S0lpSS9ldDirwKDqBPh/3HhRLBnyJ3sD626GdWsz8pqizqn0EU3VcvintVz2oNdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bliOhgSm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bliOhgSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC88D1F00893;
	Wed, 20 May 2026 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300327;
	bh=T6SpVVV3QN0AgaCYs+CmTL0fRKC4z++G+FeMNXl4y9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bliOhgSmWdjnqp/EKsVgsvJ68+CTFprgMb1nM/VWKKrOWjZirQRpRkhil3CdqoqIF
	 fo+TbN6q+B1Hc0VwMhTCXjmoQnCimYAZwjZSNImXj2xGBqp8rKoqsKOtA0jN0We163
	 Y+fwn3EUUKGpHSCD61B4AdfU3XL6i4wJGbOaeozM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/666] PCI: dwc: ep: Fix MSI-X Table Size configuration in dw_pcie_ep_set_msix()
Date: Wed, 20 May 2026 18:15:45 +0200
Message-ID: <20260520162114.116927227@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a23af31d1e2c3..ec306406959af 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -423,7 +423,7 @@ static int dw_pcie_ep_set_msix(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 	val = dw_pcie_ep_readw_dbi(ep, func_no, reg);
 	val &= ~PCI_MSIX_FLAGS_QSIZE;
 	val |= nr_irqs - 1; /* encoded as N-1 */
-	dw_pcie_writew_dbi(pci, reg, val);
+	dw_pcie_ep_writew_dbi(ep, func_no, reg, val);
 
 	reg = ep_func->msix_cap + PCI_MSIX_TABLE;
 	val = offset | bir;
-- 
2.53.0



